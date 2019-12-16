#define RESTART_WEBHOOK "restart"

/proc/call_restart_webhook()
    call_webhook(RESTART_WEBHOOK)

/proc/call_webhook(method)
    if (!config.webhook_url || !config.webhook_key)
        log_adminwarn("Looks like webhook is not configured. Please add WEBHOOK_URL and WEBHOOK_KEY to the config")
        return

    var/webhook = "[config.webhook_url]/[method]?key=[config.webhook_key]";
    log_debug("Calling webhook with address [webhook]")
    var http[] = world.Export(webhook)
    if(!http)
        log_adminwarn("Failed to call [method] webhook!");

/proc/lobby_message(var/message = "Debug Message", var/color = "#FFFFFF", var/sender)
	if (!config.webhook_url || !config.webhook_key)
		return
	spawn(0)
		var/query_string = "type=lobbyalert"
		query_string += "&key=[url_encode(config.webhook_key)]"
		query_string += "&msg=[url_encode(message)]"
		query_string += "&color=[url_encode(color)]"
		if(sender)
			query_string += "&from=[url_encode(sender)]"
		world.Export("[config.webhook_url]?[query_string]")

ADMIN_VERB_ADD(/client/proc/discord_msg, R_ADMIN, TRUE)
/client/proc/discord_msg()
	set name = "Message Lobby"
	set category = "Admin"

	if(!check_rights(R_ADMIN)) return

	var/msg = input(src, "Enter the message. Leave blank to cancel.", "Lobby Message")
	if(msg)
		log_and_message_admins("has sent a message in discord lobby - [msg]")
		lobby_message(message = msg, color = "#79FE5F")


/proc/send2adminchat(var/initiator, var/original_msg)
	if(!config.webhook_url)
		return

	var/list/adm = get_admin_counts()
	var/list/afkmins = adm["afk"]
	var/list/allmins = adm["total"]

	spawn(0) //Unreliable world.Exports()
		var/query_string = "type=adminhelp"
		query_string += "&key=[url_encode(config.webhook_key)]"
		query_string += "&from=[url_encode(initiator)]"
		query_string += "&msg=[url_encode(html_decode(original_msg))]"
		query_string += "&admin_number=[allmins.len]"
		query_string += "&admin_number_afk=[afkmins.len]"
		world.Export("[config.webhook_url]?[query_string]")


/proc/get_admin_counts(requiredflags = R_ADMIN)
	. = list("total" = list(), "noflags" = list(), "afk" = list(), "stealth" = list(), "present" = list())
	for(var/client/X in admins)
		.["total"] += X
		if(requiredflags != 0 && !check_rights(rights_required = requiredflags, show_msg = FALSE, user = X))
			.["noflags"] += X
		else if(X.is_afk())
			.["afk"] += X
		else if(X.holder.fakekey)
			.["stealth"] += X
		else
			.["present"] += X

/proc/send2coders(var/message = "Debug Message", var/color = "#FFFFFF", var/sender, var/admiralty = 0)
	if (!config.webhook_url || !config.webhook_key)
		return
	spawn(0)
		var/query_string = "type=codealert"
		if(admiralty)
			query_string = "type=admiraltyalert"
		query_string += "&key=[url_encode(config.webhook_key)]"
		query_string += "&msg=[url_encode(message)]"
		query_string += "&color=[url_encode(color)]"
		if(sender)
			query_string += "&from=[url_encode(sender)]"
		world.Export("[config.webhook_url]?[query_string]")

