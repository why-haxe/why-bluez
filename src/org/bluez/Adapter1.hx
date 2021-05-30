package org.bluez;

interface Adapter1 {
	@:readonly final address:String;
	@:readonly final addressType:String;
	@:readonly final name:String;
	@:readonly final alias:String;
	@:member('Class') @:readonly final class_:UInt;
	final powered:Bool;
	final discoverable:Bool;
	final pairable:Bool;
	final pairableTimeout:UInt;
	final discoverableTimeout:UInt;
	@:readonly final discovering:Bool;
	@:member('UUIDs') @:readonly final uuids:Array<String>;
	@:readonly final modalias:String;
	@:readonly final roles:Array<String>;
	
	function startDiscovery():Void;
	function stopDiscovery():Void;
	
	
}