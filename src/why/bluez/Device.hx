package why.bluez;

import why.dbus.*;

using StringTools;
using tink.CoreApi;

class Device extends Base {
	public final uuid:String;
	
	public final device:Interface<org.bluez.Device1>;
	public final introspectable:Interface<org.freedesktop.DBus.Introspectable>;
	
	final services:Map<String, Service> = [];
	
	public function new(transport, destination, path, uuid) {
		super(transport, destination, path);
		this.uuid = uuid;
		this.device = new Object<org.bluez.Device1>(transport, destination, path);
		this.introspectable = new Object<org.freedesktop.DBus.Introspectable>(transport, destination, path);
	}
	
	public function getServices() {
		return device.servicesResolved.get()
			.next(resolved -> {
				if(resolved)
					Noise;
				else
					device.servicesResolved.changed.nextTime(v -> v == true).noise();
			})
			.next(_ -> introspectable.introspect())
			.next(why.dbus.introspection.Introspection.parse)
			.next(introspection -> Promise.inParallel([
				for(node in introspection.children)
					if(node.name.startsWith('service')) {
						final path = '$path/${node.name}';
						new Object<org.bluez.GattService1>(transport, destination, path)
							.uuid.get().next(uuid -> getService(path, uuid));
					}
			]));
	}
	
	function getService(path:String, ?uuid:String) {
		return switch services[path] {
			case null: services[path] = new Service(transport, destination, path, uuid);
			case v: v;
		}
	}
}