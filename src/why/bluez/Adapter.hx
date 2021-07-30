package why.bluez;

import why.dbus.client.*;

class Adapter extends Base {
	public final adapter:Interface<org.bluez.Adapter1>;
	// public final introspectable:Interface<org.freedesktop.DBus.Introspectable>;
	// public final properties:Interface<org.freedesktop.DBus.Properties>;
	public final gattManager:Interface<org.bluez.GattManager1>;
	public final leAdvertisingManager:Interface<org.bluez.LEAdvertisingManager1>;
	// public final media:Interface<org.bluez.Media1>;
	// public final networkServer:Interface<org.bluez.NetworkServer1>;
	
	public function new(object) {
		super(object);
		adapter = object.getInterface(org.bluez.Adapter1);
		gattManager = object.getInterface(org.bluez.GattManager1);
		leAdvertisingManager = object.getInterface(org.bluez.LEAdvertisingManager1);
	}
}