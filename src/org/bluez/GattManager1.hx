package org.bluez;

import why.dbus.types.*;

interface GattManager1 {
	function registerApplication(application:ObjectPath, options:Map<String, Variant>):Void;
	function unregisterApplication(application:ObjectPath):Void;
}