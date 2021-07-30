package why.bluez;

import why.dbus.client.*;

using StringTools;
using tink.CoreApi;

class Device extends Base {
	public final uuid:String;
	
	public final device:Interface<org.bluez.Device1>;
	
	final services:Map<String, Service> = [];
	
	public function new(object, uuid) {
		super(object);
		this.uuid = uuid;
		this.device = object.getInterface(org.bluez.Device1);
	}
	
	public function getServices() {
		return device.servicesResolved.get()
			.next(resolved -> {
				if(resolved)
					Noise;
				else
					device.servicesResolved.changed.nextTime(v -> v == true).noise();
			})
			.next(_ -> object.introspectable.introspect())
			.next(why.dbus.introspection.Introspection.parse)
			.next(introspection -> Promise.inParallel([
				for(node in introspection.children)
					if(node.name.startsWith('service')) {
						final path = '${object.path}/${node.name}';
						object.destination.getObject(path).getInterface(org.bluez.GattService1)
							.uuid.get().next(uuid -> getService(path, uuid));
					}
			]));
	}
	
	function getService(path:String, ?uuid:String) {
		return switch services[path] {
			case null: services[path] = new Service(object.destination.getObject(path), uuid);
			case v: v;
		}
	}
}