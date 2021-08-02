package org.bluez;

import why.dbus.types.*;

interface LEAdvertisement1 {
	@:readonly final type:String;
	@:readonly @:name('ServiceUUIDs') final serviceUuids:Array<String>;
	@:readonly final manufacturerData:Map<UInt16, Variant>;
	@:readonly @:name('SolicitUUIDs') final solicitUuids:Array<String>;
	@:readonly final serviceData:Map<String, Variant>;
	@:readonly final data:Map<UInt8, Variant>;
	@:readonly final discoverable:Bool;
	@:readonly final discoverableTimeout:UInt16;
	@:readonly final includes:Array<String>;
	@:readonly final localName:String;
	@:readonly final appearance:UInt16;
	@:readonly final duration:UInt16;
	@:readonly final timeout:UInt16;
	@:readonly final secondaryChannel:String;
	@:readonly final minInterval:UInt;
	@:readonly final maxInterval:UInt;
	@:readonly final txPower:Int16;
	
	function release():Void;
}