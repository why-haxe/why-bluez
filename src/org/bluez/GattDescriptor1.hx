package org.bluez;

import tink.Chunk;
import why.dbus.types.*;

interface GattDescriptor1 {
	@:member('UUID') @:readonly final uuid:String;
	@:readonly final characteristic:ObjectPath;
	@:readonly final value:Chunk;
	@:readonly final flags:Array<String>;
	final handle:UInt16;
	
	function readValue(flags:Map<String, Variant>):Chunk;
	function writeValue(value:Chunk, flags:Map<String, Variant>):Void;
}