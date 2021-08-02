package org.bluez;

import why.dbus.types.Variant;
import why.dbus.types.ObjectPath;

interface Adapter1 {
	@:readonly final address:String;
	@:readonly final addressType:String;
	@:readonly final name:String;
	final alias:String;
	@:name('Class') @:readonly final class_:UInt;
	final powered:Bool;
	final discoverable:Bool;
	final pairable:Bool;
	final pairableTimeout:UInt;
	final discoverableTimeout:UInt;
	@:readonly final discovering:Bool;
	@:name('UUIDs') @:readonly final uuids:Array<String>;
	@:optional @:readonly final modalias:String;
	@:readonly final roles:Array<String>;
	
	function startDiscovery():Void;
	function stopDiscovery():Void;
	function removeDevice(device:ObjectPath):Void;
	function getDiscoveryFilters():Array<String>;
	function setDiscoveryFilter(filter:Map<String, Variant>):Void;
}