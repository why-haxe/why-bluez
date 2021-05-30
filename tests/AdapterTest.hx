package;

import tink.core.Disposable.OwnedDisposable;
using tink.CoreApi;
using Lambda;

@:asserts
@:timeout(200000)
class AdapterTest {
	public function new() {}
	
	public function test() {
		// js.Node.process.setuid(1000);
		final transport = why.dbus.transport.NodeDBusNext.sessionBus({busAddress: 'tcp:host=192.168.0.119,port=7272', authMethods: ['EXTERNAL']});
		(cast transport).bus.on('message', m -> trace(m));
		// final transport = why.dbus.transport.NodeDBusNext.systemBus();
		// transport.signals.handle(o -> trace(o));
		final adapter = new why.dbus.Object<org.bluez.Adapter1>(transport, 'org.bluez', '/org/bluez/hci0');
		adapter.address.get()
			.next(address -> {
				final regex = ~/^[0-9A-F]{2}:[0-9A-F]{2}:[0-9A-F]{2}:[0-9A-F]{2}:[0-9A-F]{2}:[0-9A-F]{2}$/;
				trace(address);
				asserts.assert(regex.match(address));
				adapter.powered.get();
			})
			.next(powered -> {
				trace(powered);
				
				// final manager = new why.dbus.Object<org.freedesktop.DBus.ObjectManager>(transport, 'org.bluez', '/');
				// new haxe.Timer(1000).run = () -> manager.getManagedObjects().handle(o -> trace(o.sure().count(v -> v.exists('org.bluez.Device1'))));
				
				adapter.discovering.get();
			})
			.next(discovering -> {
				trace(discovering);
				
				
				final manager = new why.dbus.Object<org.freedesktop.DBus.ObjectManager>(transport, 'org.bluez', null);
				manager.interfacesAdded.handle((path, interfaces) -> {
					trace(path);
					for(key => value in interfaces) {
						trace(key);
						trace(value);
					}
				});
				manager.interfacesRemoved.handle((path, interfaces) -> {
					trace(path);
					for(key => value in interfaces) {
						trace(key, value);
					}
				});
				
				adapter.startDiscovery();
			})
			.next(v -> {
				trace(v);
				adapter.discovering.get();
			})
			.next(discovering -> {
				trace(discovering);
				
				// final manager = new why.dbus.Object<org.freedesktop.DBus.ObjectManager>(transport, 'org.bluez', '/');
				// manager.getManagedObjects().handle(o -> trace(o.sure()));
				
				
				
				Future.delay(180000, Noise).next(_ -> adapter.stopDiscovery());
			})
			.next(v -> {
				trace(v);
				adapter.discovering.get();
			})
			.next(discovering -> {
				trace(discovering);
				Noise;
			})
			.handle(asserts.handle);
			
		return asserts;
	}
}