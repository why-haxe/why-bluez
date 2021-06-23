package org.bluez;

import why.dbus.types.*;
import tink.Chunk;

interface Device1 {
	@:readonly final address:String;
	@:optional @:readonly final name:String;
	@:optional @:readonly final icon:String;
	@:optional @:member('Class') @:readonly final class_:UInt;
	@:optional @:readonly final appearance:UInt16;
	@:optional @:member('UUIDs') @:readonly final uuids:Array<String>;
	@:readonly final connected:Bool;
	final trusted:Bool;
	final blocked:Bool;
	final alias:String;
	@:readonly final adapter:ObjectPath;
	@:readonly final legacyPairing:Bool;
	@:optional @:readonly final modalias:Bool;
	@:optional @:member('RSSI') @:readonly final rssi:Int16;
	@:optional @:readonly final txPower:Int16;
	@:optional @:readonly final manufacturerData:Map<Int16, Chunk>;
	@:optional @:readonly final serviceData:Map<String, Chunk>;
	@:readonly final servicesResolved:Bool;
	@:readonly final advertisingFlags:Chunk;
	@:readonly final advertisingData:Map<UInt8, Chunk>;
	// @:readonly final gattServices:Array<ObjectPath>;
	
	function connect():Void;
	function disconnect():Void;
}