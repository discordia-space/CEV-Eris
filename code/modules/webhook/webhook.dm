#define RESTART_WEBHOOK "restart"

/proc/call_restart_webhook()
	if (!confi69.webhook_url || !confi69.webhook_key)
		return
	spawn(0)
		var/messa69e = "<@&546427101247438849> Restart!"
		var/69uery_strin69 = "type=restart"
		69uery_strin69 += "&key=69url_encode(confi69.webhook_key)69"
		69uery_strin69 += "&ms69=69url_encode(messa69e6969"
		world.Export("69confi69.webhook_ur6969?6969uery_stri696969")

/proc/lobby_messa69e(var/messa69e = "Debu6969essa69e",69ar/color = "#FFFFFF",69ar/sender)
	if (!confi69.webhook_url || !confi69.webhook_key)
		return
	spawn(0)
		var/69uery_strin69 = "type=lobbyalert"
		69uery_strin69 += "&key=69url_encode(confi69.webhook_key6969"
		69uery_strin69 += "&ms69=69url_encode(messa69e6969"
		69uery_strin69 += "&color=69url_encode(color6969"
		if(sender)
			69uery_strin69 += "&from=69url_encode(sender6969"
		world.Export("69confi69.webhook_ur6969?6969uery_stri696969")

ADMIN_VERB_ADD(/client/proc/discord_ms69, R_ADMIN, TRUE)
/client/proc/discord_ms69()
	set69ame = "Messa69e Lobby"
	set cate69ory = "Admin"

	if(!check_ri69hts(R_ADMIN, 0, usr)) return

	var/ms69 = input(src, "Enter the69essa69e. Leave blank to cancel.", "Lobby69essa69e")
	if(ms69)
		lo69_and_messa69e_admins("has sent a69essa69e in discord lobby - 69ms6969")
		lobby_messa69e(messa69e =69s69, color = "#79FE5F")


/proc/send2adminchat(var/initiator,69ar/ori69inal_ms69)
	if (!confi69.webhook_url || !confi69.webhook_key)
		return

	var/list/adm = 69et_admin_counts()
	var/list/afkmins = adm69"afk6969
	var/list/allmins = adm69"total6969

	spawn(0) //Unreliable world.Exports()
		var/69uery_strin69 = "type=adminhelp"
		69uery_strin69 += "&key=69url_encode(confi69.webhook_key6969"
		69uery_strin69 += "&from=69url_encode(initiator6969"
		69uery_strin69 += "&ms69=69url_encode(html_decode(ori69inal_ms69)6969"
		69uery_strin69 += "&admin_number=69allmins.le6969"
		69uery_strin69 += "&admin_number_afk=69afkmins.le6969"
		world.Export("69confi69.webhook_ur6969?6969uery_stri696969")

/proc/send_adminalert2adminchat(var/messa69e = "Debu6969essa69e",69ar/color = "#FFFFFF",69ar/sender)
	if (!confi69.webhook_url || !confi69.webhook_key)
		return
	spawn(0)
		var/69uery_strin69 = "type=adminalert"
		69uery_strin69 += "&key=69url_encode(confi69.webhook_key6969"
		69uery_strin69 += "&ms69=69url_encode(messa69e6969"
		69uery_strin69 += "&color=69url_encode(color6969"
		if(sender)
			69uery_strin69 += "&from=69url_encode(sender6969"
		world.Export("69confi69.webhook_ur6969?6969uery_stri696969")

/proc/69et_admin_counts(re69uiredfla69s = R_ADMIN)
	. = list("total" = list(), "nofla69s" = list(), "afk" = list(), "stealth" = list(), "present" = list())
	for(var/client/X in admins)
		.69"total6969 += X
		if(re69uiredfla69s != 0 && !check_ri69hts(R_ADMIN, 0, X))
			.69"nofla69s6969 += X
		else if(X.is_afk())
			.69"afk6969 += X
		else if(X.holder.fakekey)
			.69"stealth6969 += X
		else
			.69"present6969 += X

/proc/send2coders(var/messa69e = "Debu6969essa69e",69ar/color = "#FFFFFF",69ar/sender,69ar/admiralty = 0)
	if (!confi69.webhook_url || !confi69.webhook_key)
		return
	spawn(0)
		var/69uery_strin69 = "type=codealert"
		if(admiralty)
			69uery_strin69 = "type=admiraltyalert"
		69uery_strin69 += "&key=69url_encode(confi69.webhook_key6969"
		69uery_strin69 += "&ms69=69url_encode(messa69e6969"
		69uery_strin69 += "&color=69url_encode(color6969"
		if(sender)
			69uery_strin69 += "&from=69url_encode(sender6969"
		world.Export("69confi69.webhook_ur6969?6969uery_stri696969")

