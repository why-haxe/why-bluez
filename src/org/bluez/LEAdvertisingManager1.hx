package org.bluez;

import why.dbus.types.*;

interface LEAdvertisingManager1 {
	function registerAdvertisement(advertisement:ObjectPath, options:Map<String, Variant>):Void;
	function unregisterAdvertisement(advertisement:ObjectPath):Void;
}