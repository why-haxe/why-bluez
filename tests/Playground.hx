package;

import tink.core.ext.*;

using tink.CoreApi;

class Playground {
	public static function main() {
		trace('main');
		final transport = why.dbus.transport.NodeDBusNext.sessionBus({busAddress: 'tcp:host=192.168.0.119,port=7272', authMethods: ['EXTERNAL']});
		trace(new why.dbus.Object<org.bluez.Device1>(transport, 'org.bluez', '/org/bluez/hci0'));
		trace(new why.dbus.Object<org.bluez.GattService1>(transport, 'org.bluez', '/org/bluez/hci0'));
		trace(new why.dbus.Object<org.bluez.GattCharacteristic1>(transport, 'org.bluez', '/org/bluez/hci0'));
		trace(new why.dbus.Object<org.bluez.GattDescriptor1>(transport, 'org.bluez', '/org/bluez/hci0'));
		final adapter = new why.dbus.Object<org.bluez.Adapter1>(transport, 'org.bluez', '/org/bluez/hci0');
		
		final manager = new why.dbus.Object<org.freedesktop.DBus.ObjectManager>(transport, 'org.bluez', null);
		manager.interfacesAdded.handle((path, interfaces) -> {
			if(interfaces.exists('org.bluez.Device1')) {
				trace('Discovered device: $path');
				// final device = new why.dbus.Object<org.bluez.Device1>(transport, 'org.bluez', path);
				final device = new why.dbus.Object<org.freedesktop.DBus.Properties>(transport, 'org.bluez', path);
				device.getAll('org.bluez.Device1').handle(o -> trace('Properties', path, [for(k => v in o.sure()) '$k=${v.value}']));
				device.propertiesChanged.handle((interfaceName, changedProps, invalidatedProps) -> trace('PropertiesChanged', path, interfaceName, [for(k => v in changedProps) '$k=${v.value}'], invalidatedProps));
			} else {
				trace('Discovered something else: $path');
				trace([for(k in interfaces.keys()) k]);
			}
		});
		manager.interfacesRemoved.handle((path, interfaces) -> {
			trace('Gone: $path');
		});
		
		adapter.address.get()
			.next(address -> {
				trace('Adapter address: $address');
				adapter.powered.get();
			})
			.next(powered -> {
				if(powered)
					adapter.discovering.get();
				else
					new Error('Not powered');
			})
			.next(discovering -> {
				trace(discovering);
				adapter.startDiscovery();
			})
			.next(v -> {
				trace('Discovering...');
				Noise;
			})
			.handle(o -> trace(o));
	}
}