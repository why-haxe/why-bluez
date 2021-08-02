package org.bluez;

import why.dbus.types.*;

interface LEAdvertisingManager1 {
	final activeInstances:UInt8;
	final supportedInstances:UInt8;
	final supportedIncludes:Array<String>;
	final supportedSecondaryChannels:Array<String>;
	final supportedCapabilities:Map<String, Variant>;
	@:readonly final supportedFeatures:Array<String>;
	
	function registerAdvertisement(advertisement:ObjectPath, options:Map<String, Variant>):Void;
	function unregisterAdvertisement(advertisement:ObjectPath):Void;
}