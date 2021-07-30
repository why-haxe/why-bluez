# BlueZ over DBus

This is a BlueZ client for Haxe that enables access to the host machine's Bluetooth resource.

### Usage

```haxe
final transport = // pick one in the `why.dbus.transport` package
final bluez = new BlueZ(transport);

// print the addresses of all the bluetooth adpaters and instruct them to start scanning for bluetooth peripherals.
bluez.getAdapters()
	.handle(o -> {
		for(adapter in o.sure()) {
			adapter.adapter.address.get().handle(o -> trace(adapter.path, 'address', o.sure()));
			adapter.adapter.startDiscovery().handle(o -> trace(o));
		}
	});
	
	

// when a bluetooth peripheral is scanned, connect to it
bluez.deviceAdded.handle(device -> {
	device.device.connect().handle(o -> trace(o.sure()));
});
```

This will print the addresses of all the bluetooth adpaters and instruct them to start scanning for bluetooth peripherals.


### Appendix: Remote Control

It is also possible to remote control another machines's bluetooth.

0. On host machine (Linux), expose DBus via `socat`
  `socat TCP-LISTEN:7272,reuseaddr,fork UNIX-CONNECT:/var/run/dbus/system_bus_socket`
0. On client machine (e.g. Mac), connect to it via TCP connection
  `why.dbus.transport.NodeDBusNext.sessionBus({busAddress: 'tcp:host=192.168.0.115,port=7272', authMethods: ['EXTERNAL']});`
  
Note that this is really just for development/testing purpose due to the security concern of exposing DBus.