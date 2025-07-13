/proc/send2irc(channel, msg)
	if(CONFIG_GET(flag/use_irc_bot) && CONFIG_GET(string/irc_bot_host))
		if(CONFIG_GET(flag/irc_bot_export))
			spawn(-1) // spawn here prevents hanging in the case that the bot isn't reachable
				world.Export("http://[CONFIG_GET(string/irc_bot_host)]:45678?[list2params(list(pwd=CONFIG_GET(string/comms_key), chan=channel, mesg=msg))]")
		else
			if(CONFIG_GET(flag/use_lib_nudge))
				var/nudge_lib
				if(world.system_type == MS_WINDOWS)
					nudge_lib = "lib\\nudge.dll"
				else
					nudge_lib = "lib/nudge.so"

				spawn(0)
					LIBCALL(nudge_lib, "nudge")("[CONFIG_GET(string/comms_key)]","[CONFIG_GET(string/irc_bot_host)]","[channel]","[msg]")
			else
				spawn(0)
					ext_python("ircbot_message.py", "[CONFIG_GET(string/comms_key)] [CONFIG_GET(string/irc_bot_host)] [channel] [msg]")
	return

/proc/send2mainirc(msg)
	if(CONFIG_GET(string/main_irc))
		send2irc(CONFIG_GET(string/main_irc), msg)
	return

/proc/send2adminirc(msg)
	if(CONFIG_GET(string/admin_irc))
		send2irc(CONFIG_GET(string/admin_irc), msg)
	return


/hook/startup/proc/ircNotify()
	send2mainirc("Server starting up on byond://[CONFIG_GET(string/serverurl) ? CONFIG_GET(string/serverurl) : (CONFIG_GET(string/server) ? CONFIG_GET(string/server) : "[world.address]:[world.port]")]")
	return 1

