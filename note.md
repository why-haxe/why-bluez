https://serverfault.com/questions/414350/access-d-bus-remotely-using-socat


on pi:
`socat TCP-LISTEN:7272,reuseaddr,fork UNIX-CONNECT:/var/run/dbus/system_bus_socket`

on mac:
`socat UNIX-LISTEN:/tmp/remote_system_bus_socket,fork TCP:192.168.0.115:7272`