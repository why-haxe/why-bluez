package why.bluez;

import why.dbus.*;

using StringTools;
using tink.CoreApi;

class Characteristic extends Base {
	public final uuid:String;
	
	public final characteristic:Interface<org.bluez.GattCharacteristic1>;
	public final introspectable:Interface<org.freedesktop.DBus.Introspectable>;
	
	public function new(transport, destination, path, uuid) {
		super(transport, destination, path);
		this.uuid = uuid;
		this.characteristic = new Object<org.bluez.GattCharacteristic1>(transport, destination, path);
		this.introspectable = new Object<org.freedesktop.DBus.Introspectable>(transport, destination, path);
	}
}