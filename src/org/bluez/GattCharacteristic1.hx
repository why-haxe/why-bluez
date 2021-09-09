package org.bluez;

import tink.Chunk;
import why.dbus.types.*;

interface GattCharacteristic1 {
	@:name('UUID') @:readonly final uuid:String;
	@:readonly final service:ObjectPath;
	@:readonly final value:Chunk;
	@:readonly final writeAcquired:Bool;
	@:readonly final notifyAcquired:Bool;
	@:readonly final notifying:Bool;
	@:readonly final flags:Array<String>;
	final handle:UInt16;
	
	function readValue(options:Map<String, Variant>):Chunk;
	function writeValue(value:Chunk, options:Map<String, Variant>):Void;
	// function acquireNotify(options:Map<String, Variant>):Void;
	function startNotify():Void;
	function stopNotify():Void;
}