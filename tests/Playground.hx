package;

import why.dbus.server.Property.SimpleProperty;
import tink.core.Disposable.SimpleDisposable;
import tink.Chunk;
import why.dbus.types.*;
import why.dbus.server.Property;
import why.dbus.client.Interface;
import why.bluez.*;
import tink.core.ext.*;
import tink.Chunk;

using StringTools;
using tink.CoreApi;

class Playground {
	public static function main() {
		trace('playground');
		js.Node.process.setuid(1000);
		final transport = why.dbus.transport.NodeDBusNext.sessionBus({busAddress: 'tcp:host=192.168.0.115,port=7272', authMethods: ['EXTERNAL']});
		final cnx = new why.dbus.Connection(transport);
		final bluez = new BlueZ(cnx);
		// @:privateAccess bluez.manager.getManagedObjects().handle(o -> for(path => interfaces in o.sure()) trace(path, [for(i in interfaces.keys()) i]));
		
		
		function handleDevice(event, device:Device) {
			// trace(event, device.path);
			Promises.multi({
				address: device.device.address.get(),
				name: device.device.name.get(),
				uuids: device.device.uuids.get(),
				servicesResolved: device.device.servicesResolved.get(),
			}).handle(o -> {
				final data = o.sure();
				if(data.name != null && data.name == 'Dasloop-LNBCHKG001455') {
					trace(event, device.object.path, 'address=${data.address}', 'name=${data.name}', 'servicesResolved=${data.servicesResolved}', 'uuids=${data.uuids}');
					device.getServices().handle(o -> {
						switch o {
							case Success(services):
								for(service in services) {
									service.service.uuid.get().handle(o -> trace('service', service.object.path, o.sure()));
									
									
									service.getCharacteristics().handle(o -> {
										for(c in o.sure()) {
											c.characteristic.uuid.get().handle(o -> {
												switch o.sure() {
													case '6e400002-b5a3-f393-e0a9-e50e24dcca9e': // write
														trace('write');
														c.characteristic.writeValue(tink.Chunk.ofHex('25200000000001000122'), ['type' => new why.dbus.types.Variant(why.dbus.Signature.String, 'command')]);
													case '6e400003-b5a3-f393-e0a9-e50e24dcca9e': // read
														trace('read');
														c.characteristic.value.changed.handle(v -> trace(v.toHex()));
														c.characteristic.startNotify().handle(o -> trace('notify', o.isSuccess()));
												}
											});
											c.characteristic.flags.get().handle(o -> trace('characteristic', c.object.path, o.sure()));
										}
									});
								}
							case Failure(e):
						}
					});
					device.device.connect().handle(o -> trace('connect', device.object.path, o));
					device.device.connected.changed.handle(o -> trace('connected', device.object.path, o));
					// final props = new why.dbus.Object<org.freedesktop.DBus.Properties>(transport, 'org.bluez', device.path + '/service0');
					// props.getAll('org.bluez.GattService1').handle(o -> trace(device.path, o.sure()));
					// final service = new Object<org.bluez.GattService1>(transport, 'org.bluez', device.path + '/service0');
				}
			});
		}
		
		// bluez.getDevices().handle(o -> for(device in o.sure()) handleDevice('init', device));
		// bluez.deviceAdded.handle(handleDevice.bind('discovered'));
		
		// bluez.deviceRemoved.handle(device -> {
		// 	trace('gone', device.object.path);
		// });
		
		cnx.bus.requestName('why.bluez.Test', 0).handle(o -> {
			trace(o);
			
			if(!o.isSuccess()) throw 0;
			
			cnx.exportObject('/why/bluez/Advertisement', (new Advertisement():org.bluez.LEAdvertisement1), (new EmptyObjectManager():org.freedesktop.DBus.ObjectManager));
			cnx.exportObject('/why/bluez/Application', (new Application():org.freedesktop.DBus.ObjectManager));
			cnx.exportObject('/why/bluez/Service', (new Service():org.bluez.GattService1));
			cnx.exportObject('/why/bluez/Characteristic', (new Characteristic():org.bluez.GattCharacteristic1));
			
			bluez.getAdapters() 
				.handle(o -> {
					for(adapter in o.sure()){
						adapter.adapter.address.get().handle(o -> trace(adapter.object.path, 'address', o.sure()));
						adapter.adapter.powered.get().handle(o -> trace(adapter.object.path, 'powered', o.sure()));
						// adapter.adapter.roles.get().handle(o -> trace(adapter.path, o.sure()));
						// adapter.adapter.startDiscovery().handle(o -> trace(o));
						// adapter.object.introspectable.introspect().handle(o -> trace(o.sure()));
						
						adapter.gattManager.registerApplication('/why/bluez/Application', [])
							.handle(o -> switch o {
								case Success(_):
									trace('registerApplication');
								case Failure(e):
									trace(e.message); trace(e.data);
							});
							
						adapter.leAdvertisingManager.registerAdvertisement('/why/bluez/Advertisement', [])
							.handle(o -> switch o {
								case Success(_): trace('registerAdvertisement');
								case Failure(e): trace(e.message); trace(e.data);
							});
					}
				});
		});
		
	}
	
	// public static function main() {
	// 	trace('main');
	// 	final transport = why.dbus.transport.NodeDBusNext.sessionBus({busAddress: 'tcp:host=192.168.0.115,port=7272', authMethods: ['EXTERNAL']});
	// 	// transport.signals.handle(v -> trace(v));
	// 	// trace(new why.dbus.Object<org.bluez.Device1>(transport, 'org.bluez', '/org/bluez/hci0'));
	// 	// trace(new why.dbus.Object<org.bluez.GattService1>(transport, 'org.bluez', '/org/bluez/hci0'));
	// 	// trace(new why.dbus.Object<org.bluez.GattCharacteristic1>(transport, 'org.bluez', '/org/bluez/hci0'));
	// 	// trace(new why.dbus.Object<org.bluez.GattDescriptor1>(transport, 'org.bluez', '/org/bluez/hci0'));
	// 	final adapter = new why.dbus.Object<org.bluez.Adapter1>(transport, 'org.bluez', '/org/bluez/hci0');
		
	// 	final manager = new why.dbus.Object<org.freedesktop.DBus.ObjectManager>(transport, 'org.bluez', '/');
		
	// 	manager.getManagedObjects().handle(o -> for(path => interfaces in o.sure()) trace(path, [for(i in interfaces.keys()) i]));
		
	// 	manager.interfacesAdded.handle((path, interfaces) -> {
	// 		if(interfaces.exists('org.bluez.Device1')) {
	// 			trace('Discovered device: $path');
	// 			final device = new why.dbus.Object<org.bluez.Device1>(transport, 'org.bluez', path);
	// 			device.name.get().handle(o -> trace(path, device.name.name, o.sure()));
	// 			final props = new why.dbus.Object<org.freedesktop.DBus.Properties>(transport, 'org.bluez', path);
	// 			// props.getAll('org.bluez.Device1').handle(o -> trace('Properties', path, [for(k => v in o.sure()) '$k=${v.value}']));
	// 			// props.propertiesChanged.handle((interfaceName, changedProps, invalidatedProps) -> trace('PropertiesChanged', path, interfaceName, [for(k => v in changedProps) '$k=${v.value}'], invalidatedProps));
	// 		} else {
	// 			trace('Discovered something else: $path');
	// 			trace([for(k in interfaces.keys()) k]);
	// 		}
	// 	});
	// 	manager.interfacesRemoved.handle((path, interfaces) -> {
	// 		trace('Gone: $path');
	// 	});
		
	// 	adapter.address.get()
	// 		.next(address -> {
	// 			trace('Adapter address: $address');
	// 			adapter.powered.get();
	// 		})
	// 		.next(powered -> {
	// 			if(powered)
	// 				adapter.discovering.get();
	// 			else
	// 				new Error('Not powered');
	// 		})
	// 		.next(discovering -> {
	// 			trace(discovering);
	// 			adapter.startDiscovery();
	// 		})
	// 		.next(v -> {
	// 			trace('Discovering...');
	// 			Noise;
	// 		})
	// 		.handle(o -> trace(o));
	// }
}

class EmptyObjectManager implements why.dbus.server.Interface<org.freedesktop.DBus.ObjectManager> {
	
	public final interfacesAdded:why.dbus.server.Signal<ObjectPath, Map<String, Map<String, Variant>>>;
	public final interfacesRemoved:why.dbus.server.Signal<ObjectPath, Array<String>>;
	
	public function new() {
		interfacesAdded = null;
		interfacesRemoved = null;
	}

	public function getManagedObjects():tink.core.Promise<Map<ObjectPath, Map<String, Map<String, Variant>>>> {
		trace('EmptyObjectManager');
		return Promise.resolve(new Map<ObjectPath, Map<String, Map<String, Variant>>>());
	}
}

class Advertisement implements why.dbus.server.Interface<org.bluez.LEAdvertisement1> {

	public final type = new SimpleProperty('peripheral');
	public final serviceUuids = new SimpleProperty([]);
	public final manufacturerData = new SimpleProperty(new Map());
	public final solicitUuids = new SimpleProperty([]);
	public final serviceData = new SimpleProperty(new Map());
	public final data = new SimpleProperty(new Map());
	public final discoverable = new SimpleProperty(true);
	public final discoverableTimeout = new SimpleProperty(0);
	public final includes = new SimpleProperty([]);
	public final localName = new SimpleProperty('rpi');
	public final appearance = new SimpleProperty(0);
	public final duration = new SimpleProperty(300);
	public final timeout = new SimpleProperty(300);
	public final secondaryChannel = new SimpleProperty('1M');
	public final minInterval = new SimpleProperty(2000);
	public final maxInterval = new SimpleProperty(4000);
	public final txPower = new SimpleProperty(0);
	
	public function new() {}
	
	public function release():Promise<Noise> {
		trace('release');
		return Promise.NOISE;
	}
}

class Application implements why.dbus.server.Interface<org.freedesktop.DBus.ObjectManager> {

	public final interfacesAdded:why.dbus.server.Signal<ObjectPath, Map<String, Map<String, Variant>>>;
	public final interfacesRemoved:why.dbus.server.Signal<ObjectPath, Array<String>>;
	
	public function new() {
		interfacesAdded = null;
		interfacesRemoved = null;
	}
	
	public function getManagedObjects():Promise<Map<ObjectPath, Map<String, Map<String, Variant>>>> {
		trace('getManagedObjects'); 
		return Promise.resolve([
			'/why/bluez/Service' => [
				'org.bluez.GattService1' => [
					'UUID' => new Variant(why.dbus.Signature.String, '3336f8d2-9f66-4f58-a53d-fc7440e7c14e'),
					'Primary' => new Variant(why.dbus.Signature.Boolean, true),
					'Characteristics' => new Variant(why.dbus.Signature.Array(ObjectPath), [/*'/why/bluez/Characteristic'*/]),
				],
			],
			'/why/bluez/Characteristic' => [
				'org.bluez.GattCharacteristic1' => [
					'Service' => new Variant(why.dbus.Signature.ObjectPath, '/why/bluez/Service'),
					'UUID' => new Variant(why.dbus.Signature.String, 'ccc6f8d2-9f66-4f58-a53d-fc7440e7c14c'),
					'Flags' => new Variant(why.dbus.Signature.Array(String), ['read', 'write']),
					'Descriptors' => new Variant(why.dbus.Signature.Array(ObjectPath), []),
				],
			]
		]);
	}
}

class Service implements why.dbus.server.Interface<org.bluez.GattService1> {
	public final uuid = new SimpleProperty('3336f8d2-9f66-4f58-a53d-fc7440e7c14e');
	public final primary = new SimpleProperty(true);
	public final device = new SimpleProperty('/why/bluez/Application');
	public final includes = new SimpleProperty([]);
	public final handle = new SimpleProperty(0);
	
	public function new() {}
}

class Characteristic implements why.dbus.server.Interface<org.bluez.GattCharacteristic1> {

	public final uuid = new SimpleProperty('ccc6f8d2-9f66-4f58-a53d-fc7440e7c14c');
	public final service = new SimpleProperty('/why/bluez/Service');
	public final value = new SimpleProperty(('current_value':Chunk));
	public final writeAcquired = new SimpleProperty(false);
	public final notifyAcquired = new SimpleProperty(false);
	public final notifying = new SimpleProperty(false);
	public final flags = new SimpleProperty([]);
	public final handle = new SimpleProperty(0);
	
	public function new() {}

	public function readValue(options:Map<String, Variant>):Promise<Chunk> {
		trace('readValue');
		return ('read_value':Chunk);
	}

	public function writeValue(value:Chunk, options:Map<String, Variant>):Promise<tink.core.Noise> {
		trace('writeValue ${value.toString()} ${value.toHex()} $options');
		throw new haxe.exceptions.NotImplementedException();
	}

	public function startNotify():Promise<tink.core.Noise> {
		trace('startNotify');
		throw new haxe.exceptions.NotImplementedException();
	}

	public function stopNotify():Promise<tink.core.Noise> {
		trace('stopNotify');
		throw new haxe.exceptions.NotImplementedException();
	}
}