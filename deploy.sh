#!/bin/bash


# echo -e "require('.pnp.js');\n$(cat bin/node/tests.js)" > bin/node/tests.js
scp bin/node/*.* ble@192.168.0.119:/home/ble/test/

# sudo dbus-monitor --system "destination='why.bluez.Test'" "sender='why.bluez.Test'"