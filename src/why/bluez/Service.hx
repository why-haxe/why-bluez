package why.bluez;

import why.dbus.*;

using StringTools;
using tink.CoreApi;

class Service extends Base {
	public final uuid:String;
	
	public final service:Interface<org.bluez.GattService1>;
	public final introspectable:Interface<org.freedesktop.DBus.Introspectable>;
	
	final characteristics:Map<String, Characteristic> = [];
	
	public function new(transport, destination, path, uuid) {
		super(transport, destination, path);
		this.uuid = uuid;
		this.service = new Object<org.bluez.GattService1>(transport, destination, path);
		this.introspectable = new Object<org.freedesktop.DBus.Introspectable>(transport, destination, path);
	}
	
	public function getCharacteristics() {
		return introspectable.introspect()
			.next(why.dbus.introspection.Introspection.parse)
			.next(introspection -> Promise.inParallel([
				for(node in introspection.children)
					if(node.name.startsWith('char')) {
						final path = '$path/${node.name}';
						new Object<org.bluez.GattCharacteristic1>(transport, destination, path)
							.uuid.get().next(uuid -> getCharacteristic(path, uuid));
					}
			]));
	}
	
	function getCharacteristic(path:String, ?uuid:String) {
		return switch characteristics[path] {
			case null: characteristics[path] = new Characteristic(transport, destination, path, uuid);
			case v: v;
		}
	}
}