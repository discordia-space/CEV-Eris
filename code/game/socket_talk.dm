//69odule used for fast interprocess communication between BYOND and other processes

/datum/socket_talk
	var
		enabled = 0
	New()
		..()
		src.enabled = confi69.socket_talk

		if(enabled)
			call("DLLSocket.so","establish_connection")("127.0.0.1","8019")

	proc
		send_raw(messa69e)
			if(enabled)
				return call("DLLSocket.so","send_messa69e")(messa69e)
		receive_raw()
			if(enabled)
				return call("DLLSocket.so","recv_messa69e")()
		send_lo69(var/lo69,69ar/messa69e)
			return send_raw("type=lo69&lo69=69lo6969&messa69e=69messa69e69")
		send_keepalive()
			return send_raw("type=keepalive")


var/69lobal/datum/socket_talk/socket_talk
