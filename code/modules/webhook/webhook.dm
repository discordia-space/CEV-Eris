#define RESTART_WEBHOOK "restart"
#define LOBBY_ALERT "lobbyalert"
#define ADMIN_HELP "adminhelp"
#define ADMIN_ALERT "adminalert"
#define CODE_ALERT "codealert"
#define ADMIRALTY_ALERT "admiraltyalert"

/proc/is_webhook_set_up()
	return config.webhook_key && config.webhook_url

// type: string, params: byond list
/proc/call_webhook(var/type, var/params)
	spawn(0)
		params["key"] = config.webhook_key
		params["type"] = type
		var/query_string = list2params(params)
		var/url = "[config.webhook_url]?[query_string]"

		world.Export(url)

/proc/call_restart_webhook()
	if (!is_webhook_set_up())
		return
	var/message = "<@&546427101247438849> Restart!"
	var/params = list(msg = message)
	call_webhook(RESTART_WEBHOOK, params)

/proc/lobby_message(var/message = "Debug Message", var/color = "#FFFFFF", var/sender)
	if (!is_webhook_set_up())
		return
	var/params = list(
		msg = message,
		color = color
	)
	if (sender)
		params["from"] = sender
	
	call_webhook(LOBBY_ALERT, params)

ADMIN_VERB_ADD(/client/proc/discord_msg, R_ADMIN, TRUE)
/client/proc/discord_msg()
	set name = "Message Lobby"
	set category = "Admin"

	if(!check_rights(R_ADMIN, 0, usr)) return

	var/msg = input(src, "Enter the message. Leave blank to cancel.", "Lobby Message")
	if(msg)
		log_and_message_admins("has sent a message in discord lobby - [msg]")
		lobby_message(message = msg, color = "#79FE5F")


/proc/send2adminchat(var/initiator, var/original_msg)
	if(!is_webhook_set_up())
		return

	var/list/adm = get_admin_counts()
	var/list/afkmins = adm["afk"]
	var/list/allmins = adm["total"]

	var/params = list(
		from = initiator,
		msg = html_decode(original_msg),
		admin_number = allmins.len,
		admin_number_afk = afkmins.len
	)

	call_webhook(ADMIN_HELP, params)

/proc/send_adminalert2adminchat(var/message = "Debug Message", var/color = "#FFFFFF", var/sender)
	if (!is_webhook_set_up())
		return
		
	var/params = list(
		msg = message,
		color = color
	)

	if (sender)
		params["from"] = sender
	
	call_webhook(ADMIN_ALERT, params)

/proc/get_admin_counts(requiredflags = R_ADMIN)
	. = list("total" = list(), "noflags" = list(), "afk" = list(), "stealth" = list(), "present" = list())
	for(var/client/X in admins)
		.["total"] += X
		if(requiredflags != 0 && !check_rights(R_ADMIN, 0, X))
			.["noflags"] += X
		else if(X.is_afk())
			.["afk"] += X
		else if(X.holder.fakekey)
			.["stealth"] += X
		else
			.["present"] += X

/proc/send2coders(var/message = "Debug Message", var/color = "#FFFFFF", var/sender, var/admiralty = 0)
	if (!is_webhook_set_up())
		return
	
	var/params = list(
		msg = message,
		color = color
	)

	if (sender)
		params["from"] = sender
	
	if (admiralty)
		call_webhook(ADMIRALTY_ALERT, params)
	else
		call_webhook(CODE_ALERT, params)

