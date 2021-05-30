package org.bluez;

import why.dbus.types.*;

interface GattService1 {
	@:member('UUID') @:readonly final uuid:String;
	@:readonly final primary:Bool;
	@:readonly final device:ObjectPath;
	@:readonly final inlcudes:Array<ObjectPath>;
	final handle:UInt16;
}