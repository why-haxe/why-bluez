package org.bluez;

import haxe.io.Bytes;
import why.dbus.types.*;

interface GattDescriptor1 {
	@:member('UUID') @:readonly final uuid:String;
	@:readonly final characteristic:ObjectPath;
	@:readonly final value:Bytes;
	@:readonly final flags:Array<String>;
	final handle:UInt16;
	
	function readValue(flags:Map<String, Variant>):Bytes;
	function writeValue(value:Bytes, flags:Map<String, Variant>):Void;
}