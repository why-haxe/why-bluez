package why.bluez;

import why.bluez.Adapter;
import why.dbus.*;

using tink.CoreApi;

class BlueZ {
	static inline final DESTINATION = 'org.bluez';
	
	public final deviceAdded:Signal<Device>;
	public final deviceRemoved:Signal<Device>;
	
	final transport:Transport;
	final manager:Interface<org.freedesktop.DBus.ObjectManager>;
	final devices:Map<String, Device> = [];
	
	public function new(transport) {
		this.transport = transport;
		this.manager = new Object<org.freedesktop.DBus.ObjectManager>(transport, DESTINATION, '/');
		
		this.deviceAdded = manager.interfacesAdded.select(tuple -> {
			final path = tuple.v0;
			final interfaces = tuple.v1;
			switch interfaces['org.bluez.Device1'] {
				case null: None;
				case iface: Some(getDevice(path, iface['Address'].value));
			}
		});
		this.deviceRemoved = manager.interfacesRemoved.select(tuple -> {
			final path = tuple.v0;
			final interfaces = tuple.v1;
			if(interfaces.contains('org.bluez.Device1')) {
				final device = getDevice(path);
				devices.remove(path);
				Some(device);
			} else {
				None;
			}
		});
	}
	
	public function getAdapters() {
		return manager.getManagedObjects()
			.next(objects -> [for(path => interfaces in objects) if(interfaces.exists('org.bluez.Adapter1')) new Adapter(transport, DESTINATION, path)]);
	}
	
	public function getDevices() {
		return manager.getManagedObjects()
			.next(objects -> [
				for(path => interfaces in objects)
					switch interfaces['org.bluez.Device1'] {
						case null: continue;
						case iface: getDevice(path, iface['Address'].value);
					}
			]);
	}
	
	function getDevice(path:String, ?uuid:String) {
		return switch devices[path] {
			case null: devices[path] = new Device(transport, DESTINATION, path, uuid);
			case v: v;
		}
	}
}