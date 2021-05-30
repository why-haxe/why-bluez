package org.bluez;

import haxe.io.Bytes;
import why.dbus.types.*;

interface GattCharacteristic1 {
	@:member('UUID') @:readonly final uuid:String;
	@:readonly final service:ObjectPath;
	@:readonly final value:Bytes;
	@:readonly final writeAcquired:Bool;
	@:readonly final notifyAcquired:Bool;
	@:readonly final notifying:Bool;
	@:readonly final flags:Array<String>;
	final handle:UInt16;
	
	function readValue(options:Map<String, Variant>):Bytes;
	function writeValue(value:Bytes, options:Map<String, Variant>):Void;
}