package why.bluez;

import why.dbus.client.*;

using StringTools;
using tink.CoreApi;

class Service extends Base {
	public final uuid:String;
	
	public final service:Interface<org.bluez.GattService1>;
	
	final characteristics:Map<String, Characteristic> = [];
	
	public function new(object, uuid) {
		super(object);
		this.uuid = uuid;
		this.service = object.getInterface(org.bluez.GattService1);
	}
	
	public function getCharacteristics() {
		return object.introspectable.introspect()
			.next(why.dbus.introspection.Introspection.parse)
			.next(introspection -> Promise.inParallel([
				for(node in introspection.children)
					if(node.name.startsWith('char')) {
						final path = '${object.path}/${node.name}';
						object.destination.getObject(path)
							.getInterface(org.bluez.GattCharacteristic1)
							.uuid.get().next(uuid -> getCharacteristic(path, uuid));
					}
			]));
	}
	
	function getCharacteristic(path:String, ?uuid:String) {
		return switch characteristics[path] {
			case null: characteristics[path] = new Characteristic(object.destination.getObject(path), uuid);
			case v: v;
		}
	}
}