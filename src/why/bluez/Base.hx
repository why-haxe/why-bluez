package why.bluez;

import why.dbus.*;

class Base {
	public final transport:Transport;
	public final destination:String;
	public final path:String;
	
	public function new(transport, destination, path) {
		this.transport = transport;
		this.destination = destination;
		this.path = path;
	}
}