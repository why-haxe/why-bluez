package org.bluez;

import why.dbus.types.*;

interface GattService1 {
	@:name('UUID') @:readonly final uuid:String;
	@:readonly final primary:Bool;
	@:readonly final device:ObjectPath;
	@:readonly final includes:Array<ObjectPath>;
	final handle:UInt16;
}