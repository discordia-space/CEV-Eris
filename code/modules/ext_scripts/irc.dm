/proc/send2irc(var/channel,69ar/msg)
	if(config.use_irc_bot && config.irc_bot_host)
		if(config.irc_bot_export)
			spawn(-1) // spawn here prevents hanging in the case that the bot isn't reachable
				world.Export("http://69config.irc_bot_host69:45678?69list2params(list(pwd=config.comms_password, chan=channel,69esg=msg))69")
		else
			if(config.use_lib_nudge)
				var/nudge_lib
				if(world.system_type ==69S_WINDOWS)
					nudge_lib = "lib\\nudge.dll"
				else
					nudge_lib = "lib/nudge.so"

				spawn(0)
					call(nudge_lib, "nudge")("69config.comms_password69","69config.irc_bot_host69","69channel69","69msg69")
			else
				spawn(0)
					ext_python("ircbot_message.py", "69config.comms_password69 69config.irc_bot_host69 69channel69 69msg69")
	return

/proc/send2mainirc(var/msg)
	if(config.main_irc)
		send2irc(config.main_irc,69sg)
	return

/proc/send2adminirc(var/msg)
	if(config.admin_irc)
		send2irc(config.admin_irc,69sg)
	return


/hook/startup/proc/ircNotify()
	send2mainirc("Server starting up on byond://69config.serverurl ? config.serverurl : (config.server ? config.server : "69world.address69:69world.port69")69")
	return 1

