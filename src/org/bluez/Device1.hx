package org.bluez;

import why.dbus.types.*;
import haxe.io.*;

interface Device1 {
	@:readonly final address:String;
	@:readonly final name:String;
	@:readonly final icon:String;
	@:member('Class') @:readonly final class_:UInt;
	@:readonly final appearance:UInt16;
	@:member('UUIDs') @:readonly final uuids:Array<String>;
	@:readonly final connected:Bool;
	final trusted:Bool;
	final blocked:Bool;
	final alias:String;
	@:readonly final adapter:ObjectPath;
	@:member('RSSI') @:readonly final rssi:Int16;
	@:readonly final txPower:Int16;
	@:readonly final manufacturerData:Map<Int16, Bytes>;
	@:readonly final serviceData:Map<String, Bytes>;
	@:readonly final gattServices:Array<ObjectPath>;
	
	function connect():Void;
	function disconnect():Void;
}