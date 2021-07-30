package why.bluez;

import why.dbus.client.*;

class Base {
	public final object:Object;
	
	public function new(object) {
		this.object = object;
	}
}