ADMIN_VERB_ADD(/client/proc/cmd_admin_pm_context, R_ADMIN|R_MOD|R_MENTOR, FALSE)
//allows right clicking69obs to send an admin PM to their client, forwards the selected69ob's client to cmd_admin_pm
/client/proc/cmd_admin_pm_context(mob/M as69ob in SSmobs.mob_list)
	set category = null
	set name = "Admin PM69ob"
	if(!holder)
		to_chat(src, "<font color='red'>Error: Admin-PM-Context: Only administrators69ay use this command.</font>")
		return
	if( !ismob(M) || !M.client )	return
	cmd_admin_pm(M.client,null)

ADMIN_VERB_ADD(/client/proc/cmd_admin_pm_panel, R_ADMIN|R_MOD|R_MENTOR, FALSE)
//shows a list of clients we could send PMs to, then forwards our choice to cmd_admin_pm
/client/proc/cmd_admin_pm_panel()
	set category = "Admin"
	set name = "Admin PM"
	if(!holder)
		to_chat(src, "<font color='red'>Error: Admin-PM-Panel: Only administrators69ay use this command.</font>")
		return
	var/list/client/targets69069
	for(var/client/T)
		if(T.mob)
			if(isnewplayer(T.mob))
				targets69"(New Player) - 69T69"69 = T
			else if(isghost(T.mob))
				targets69"69T.mob.name69(Ghost) - 69T69"69 = T
			else
				targets69"69T.mob.real_name69(as 69T.mob.name69) - 69T69"69 = T
		else
			targets69"(No69ob) - 69T69"69 = T
	var/list/sorted = sortList(targets)
	var/target = input(src,"To whom shall we send a69essage?","Admin PM",null) in sorted|null
	cmd_admin_pm(targets69target69,null)



//takes input from cmd_admin_pm_context, cmd_admin_pm_panel or /client/Topic and sends them a PM.
//Fetching a69essage if needed. src is the sender and C is the target client

/client/proc/cmd_admin_pm(var/client/C,69ar/msg = null,69ar/type = "PM")
	if(prefs.muted &69UTE_ADMINHELP)
		to_chat(src, "<font color='red'>Error: Private-Message: You are unable to use PM-s (muted).</font>")
		return

	if(!istype(C,/client))
		if(holder)	to_chat(src, "<font color='red'>Error: Private-Message: Client not found.</font>")
		else		to_chat(src, "<font color='red'>Error: Private-Message: Client not found. They69ay have lost connection, so try using an adminhelp!</font>")
		return

	//get69essage text, limit it's length.and clean/escape html
	if(!msg)
		msg = input(src,"Message:", "Private69essage to 69key_name(C, 0, holder ? 1 : 0)69") as text|null

		if(!msg)	return
		if(!C)
			if(holder)	to_chat(src, "<font color='red'>Error: Admin-PM: Client not found.</font>")
			else		to_chat(src, "<font color='red'>Error: Private-Message: Client not found. They69ay have lost connection, so try using an adminhelp!</font>")
			return

	if (src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	msg = sanitize(msg)
	if(!msg)	return

	var/recieve_pm_type = "Player"
	if(holder)
		msg = emoji_parse(msg)
		//mod PMs are69aroon
		//PMs sent from admins and69ods display their rank
		if(holder)
			if(!C.holder && holder && holder.fakekey)
				recieve_pm_type = "Admin"
			else
				recieve_pm_type = holder.rank

	else if(!C.holder)
		to_chat(src, "<font color='red'>Error: Admin-PM: Non-admin to non-admin PM communication is forbidden.</font>")
		return

	var/recieve_message

	if(holder && !C.holder)
		recieve_message = "<span class='pm'><span class='howto'><b>-- Click the 69recieve_pm_type69's name to reply --</b></span></span>\n"
		if(C.adminhelped)
			to_chat(C, recieve_message)
			C.adminhelped = 0

		//AdminPM popup for ApocStation and anybody else who wants to use it. Set it with POPUP_ADMIN_PM in config.txt ~Carn
		if(config.popup_admin_pm)
			spawn(0)	//so we don't hold the caller proc up
				var/sender = src
				var/sendername = key
				var/reply = sanitize(input(C,69sg,"69recieve_pm_type69 PM from 69sendername69", "") as text|null)		//show69essage and await a reply
				if(C && reply)
					if(sender)
						C.cmd_admin_pm(sender,reply)										//sender is still about, let's reply to them
					else
						adminhelp(reply)													//sender has left, adminhelp instead
				return
	to_chat(src, "<span class='pm'><span class='out'>" + create_text_tag("pm_out_alt", "PM", src) + " to <span class='name'>69get_options_bar(C, holder ? 1 : 0, holder ? 1 : 0, 1)69</span>: <span class='message linkify'>69msg69</span></span></span>")
	to_chat(C, "<span class='pm'><span class='in'>" + create_text_tag("pm_in", "", C) + " <b>\6969recieve_pm_type69 PM\69</b> <span class='name'>69get_options_bar(src, C.holder ? 1 : 0, C.holder ? 1 : 0, 1)69</span>: <span class='message linkify'>69msg69</span></span></span>")

	//play the recieving admin the adminhelp sound (if they have them enabled)
	//non-admins shouldn't be able to disable this
	if(C.get_preference_value(/datum/client_preference/staff/play_adminhelp_ping) == GLOB.PREF_HEAR)
		sound_to(C, 'sound/effects/adminhelp.ogg')

	send_adminalert2adminchat(message = "PM: 69key_name(src)69->69key_name(C)69: 69msg69")

	log_admin("PM: 69key_name(src)69->69key_name(C)69: 69msg69")


	//we don't use69essage_admins here because the sender/receiver69ight get it too
	for(var/client/X in admins)
		//check client/X is an admin and isn't the sender or recipient
		if(X == C || X == src)
			continue
		if(X.key != key && X.key != C.key && (X.holder.rights & R_ADMIN|R_MOD|R_MENTOR))
			to_chat(X, "<span class='pm'><span class='other'>" + create_text_tag("pm_other", "PM:", X) + " <span class='name'>69key_name(src, X, 0)69</span> to <span class='name'>69key_name(C, X, 0)69</span>: <span class='message linkify'>69msg69</span></span></span>")

	//Check if the69ob being PM'd has any open admin tickets.
	var/tickets = list()
	if(type == "Mentorhelp")
		tickets = SSmentor_tickets.checkForTicket(C)
	else
		tickets = SStickets.checkForTicket(C)
	if(tickets)
		for(var/datum/ticket/i in tickets)
			i.addResponse(src,69sg) // Add this response to their open tickets.
		return
	if(type == "Mentorhelp")
		if(check_rights(R_ADMIN|R_MOD|R_MENTOR, 0, C.mob)) //Is the person being pm'd an admin? If so we check if the pm'er has open tickets
			tickets = SSmentor_tickets.checkForTicket(src)
	else // Ahelp
		if(check_rights(R_ADMIN|R_MOD, 0, C.mob)) //Is the person being pm'd an admin? If so we check if the pm'er has open tickets
			tickets = SStickets.checkForTicket(src)

	if(tickets)
		for(var/datum/ticket/i in tickets)
			i.addResponse(src,69sg)
		return


/client/proc/cmd_admin_irc_pm(sender)
	if(prefs.muted &69UTE_ADMINHELP)
		to_chat(src, "<font color='red'>Error: Private-Message: You are unable to use PM-s (muted).</font>")
		return

	var/msg = input(src,"Message:", "Reply private69essage to 69sender69 on IRC / 400 character limit") as text|null

	if(!msg)
		return

	sanitize(msg)

	// Handled on Bot32's end, unsure about other bots
//	if(length(msg) > 400) // TODO: if69essage length is over 400, divide it up into seperate69essages, the69essage length restriction is based on IRC limitations.  Probably easier to do this on the bots ends.
//		src << SPAN_WARNING("Your69essage was not sent because it was69ore then 400 characters find your69essage below for ease of copy/pasting")
//		src << SPAN_NOTICE("69msg69")
//		return



	to_chat(src, "<span class='pm'><span class='out'>" + create_text_tag("pm_out_alt", "", src) + " to <span class='name'>IRC-69sender69</span>: <span class='message'>69msg69</span></span></span>")

	log_admin("PM: 69key_name(src)69->IRC-69sender69: 69msg69")
	for(var/client/X in admins)
		if(X == src)
			continue
		if(X.holder.rights & R_ADMIN|R_MOD)
			to_chat(X, "<span class='pm'><span class='other'>" + create_text_tag("pm_other", "PM:", X) + " <span class='name'>69key_name(src, X, 0)69</span> to <span class='name'>IRC-69sender69</span>: <span class='message'>69msg69</span></span></span>")
