package why.bluez;

import why.dbus.client.*;

using StringTools;
using tink.CoreApi;

class Characteristic extends Base {
	public final uuid:String;
	
	public final characteristic:Interface<org.bluez.GattCharacteristic1>;
	
	public function new(object, uuid) {
		super(object);
		this.uuid = uuid;
		this.characteristic = object.getInterface(org.bluez.GattCharacteristic1);
	}
}