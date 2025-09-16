/datum/admins/proc/CheckAdminHref(href, href_list)
	var/auth = href_list["admin_token"]
	. = auth && (auth == href_token || auth == GLOB.href_token)
	if(.)
		return
	var/msg = !auth ? "no" : "a bad"
	message_admins("[key_name_admin(usr)] clicked an href with [msg] authorization key!")
	if(CONFIG_GET(flag/debug_admin_hrefs))
		message_admins("Debug mode enabled, call not blocked. Please ask your coders to review this round's logs.")
		log_world("UAH: [href]")
		return TRUE
	log_admin("[key_name(usr)] clicked an href with [msg] authorization key! [href]")

/datum/admins/proc/formatJob(mob/mob, title, bantype)
	if(!bantype)
		bantype = title
	var/red = jobban_isbanned(mob, bantype)
	return \
		"<a href='byond://?src=\ref[src];[HrefToken()];jobban3=[bantype];jobban4=\ref[mob]'>\
		[red ? "<font color=red>" : null][replacetext(title, " ", "&nbsp")][red ? "</font>" : null]\
		</a> "

/datum/admins/proc/formatJobGroup(mob/mob, title, color, bantype, list/joblist)
	. += "<tr bgcolor='[color]'><th><a href='byond://?src=\ref[src];[HrefToken()];jobban3=[bantype];jobban4=\ref[mob]'>[title]</a></th></tr><tr><td class='jobs'>"
	for(var/jobPos in joblist)
		. += formatJob(mob, jobPos, GLOB.joblist[jobPos])
	. += "</td></tr>"


/datum/admins/Topic(href, href_list)
	..()

	if(usr.client != owner || !check_rights(0))
		log_admin("[key_name(usr)] tried to use the admin panel without authorization.")
		message_admins("[usr.key] has attempted to override the admin panel!")
		return

	if (!CheckAdminHref(href, href_list))
		return

	if(href_list["openticket"])
		var/ticketID = text2num(href_list["openticket"])
		if(!href_list["is_mhelp"])
			if(!check_rights(R_ADMIN))
				return
			SStickets.showDetailUI(usr, ticketID)
		else
			if(!check_rights(R_MENTOR|R_ADMIN))
				return
			SSmentor_tickets.showDetailUI(usr, ticketID)

	if(href_list["kick_all_from_lobby"])
		if(!check_rights(R_ADMIN))
			return
		if(SSticker.IsRoundInProgress())
			var/afkonly = text2num(href_list["afkonly"])
			if(tgui_alert(usr,"Are you sure you want to kick all [afkonly ? "AFK" : ""] clients from the lobby??","Message",list("Yes","Cancel")) != "Yes")
				to_chat(usr, "Kick clients from lobby aborted", confidential = TRUE)
				return
			var/list/listkicked = kick_clients_in_lobby(span_danger("You were kicked from the lobby by [usr.client.holder.fakekey ? "an Administrator" : "[usr.client.key]"]."), afkonly)

			var/strkicked = ""
			for(var/name in listkicked)
				strkicked += "[name], "
			message_admins("[key_name_admin(usr)] has kicked [afkonly ? "all AFK" : "all"] clients from the lobby. [length(listkicked)] clients kicked: [strkicked ? strkicked : "--"]")
			log_admin("[key_name(usr)] has kicked [afkonly ? "all AFK" : "all"] clients from the lobby. [length(listkicked)] clients kicked: [strkicked ? strkicked : "--"]")
		else
			to_chat(usr, "You may only use this when the game is running.", confidential = TRUE)

	if(href_list["take_question"])
		var/indexNum = text2num(href_list["take_question"])
		if(check_rights(R_ADMIN))
			SStickets.takeTicket(indexNum)

	if(href_list["resolve"])
		var/indexNum = text2num(href_list["resolve"])
		if(check_rights(R_ADMIN))
			SStickets.resolveTicket(indexNum)

	if(href_list["convert_ticket"])
		var/indexNum = text2num(href_list["convert_ticket"])
		if(check_rights(R_ADMIN))
			SStickets.convert_to_other_ticket(indexNum)

	if(href_list["autorespond"])
		var/indexNum = text2num(href_list["autorespond"])
		if(check_rights(R_ADMIN))
			SStickets.autoRespond(indexNum)

	if(href_list["addmessage"])
		if(!check_rights(R_ADMIN))
			return
		var/target_key = href_list["addmessage"]
		create_message("message", target_key, secret = 0)

	if(href_list["addnote"])
		if(!check_rights(R_ADMIN))
			return
		var/target_key = href_list["addnote"]
		create_message("note", target_key)

	if(href_list["addwatch"])
		if(!check_rights(R_ADMIN))
			return
		var/target_key = href_list["addwatch"]
		create_message("watchlist entry", target_key, secret = 1)

	if(href_list["addmemo"])
		if(!check_rights(R_ADMIN))
			return
		create_message("memo", secret = 0, browse = 1)

	if(href_list["addmessageempty"])
		if(!check_rights(R_ADMIN))
			return
		create_message("message", secret = 0)

	if(href_list["addnoteempty"])
		if(!check_rights(R_ADMIN))
			return
		create_message("note")

	if(href_list["addwatchempty"])
		if(!check_rights(R_ADMIN))
			return
		create_message("watchlist entry", secret = 1)

	if(href_list["deletemessage"])
		if(!check_rights(R_ADMIN))
			return
		var/safety = tgui_alert(usr,"Delete message/note?",,list("Yes","No"));
		if (safety == "Yes")
			var/message_id = href_list["deletemessage"]
			delete_message(message_id)

	if(href_list["deletemessageempty"])
		if(!check_rights(R_ADMIN))
			return
		var/safety = tgui_alert(usr,"Delete message/note?",,list("Yes","No"));
		if (safety == "Yes")
			var/message_id = href_list["deletemessageempty"]
			delete_message(message_id, browse = TRUE)

	if(href_list["editmessage"])
		if(!check_rights(R_ADMIN))
			return
		var/message_id = href_list["editmessage"]
		edit_message(message_id)

	if(href_list["editmessageempty"])
		if(!check_rights(R_ADMIN))
			return
		var/message_id = href_list["editmessageempty"]
		edit_message(message_id, browse = 1)

	if(href_list["editmessageexpiry"])
		if(!check_rights(R_ADMIN))
			return
		var/message_id = href_list["editmessageexpiry"]
		edit_message_expiry(message_id)

	if(href_list["editmessageexpiryempty"])
		if(!check_rights(R_ADMIN))
			return
		var/message_id = href_list["editmessageexpiryempty"]
		edit_message_expiry(message_id, browse = 1)

	if(href_list["editmessageseverity"])
		if(!check_rights(R_ADMIN))
			return
		var/message_id = href_list["editmessageseverity"]
		edit_message_severity(message_id)

	if(href_list["secretmessage"])
		if(!check_rights(R_ADMIN))
			return
		var/message_id = href_list["secretmessage"]
		toggle_message_secrecy(message_id)

	if(href_list["searchmessages"])
		if(!check_rights(R_ADMIN))
			return
		var/target = href_list["searchmessages"]
		browse_messages(index = target)

	if(href_list["nonalpha"])
		if(!check_rights(R_ADMIN))
			return
		var/target = href_list["nonalpha"]
		target = text2num(target)
		browse_messages(index = target)

	if(href_list["showmessages"])
		if(!check_rights(R_ADMIN))
			return
		var/target = href_list["showmessages"]
		browse_messages(index = target)

	if(href_list["showmemo"])
		if(!check_rights(R_ADMIN))
			return
		browse_messages("memo")

	if(href_list["showwatch"])
		if(!check_rights(R_ADMIN))
			return
		browse_messages("watchlist entry")

	if(href_list["showwatchfilter"])
		if(!check_rights(R_ADMIN))
			return
		browse_messages("watchlist entry", filter = 1)

	if(href_list["showmessageckey"])
		if(!check_rights(R_ADMIN))
			return
		var/target = href_list["showmessageckey"]
		var/agegate = TRUE
		if (href_list["showall"])
			agegate = FALSE
		browse_messages(target_ckey = target, agegate = agegate)

	if(href_list["showmessageckeylinkless"])
		var/target = href_list["showmessageckeylinkless"]
		browse_messages(target_ckey = target, linkless = 1)

	if(href_list["messageread"])
		if(!isnum(href_list["message_id"]))
			return
		var/rounded_message_id = round(href_list["message_id"], 1)
		var/datum/db_query/query_message_read = SSdbcore.NewQuery(
			"UPDATE [format_table_name("messages")] SET type = 'message sent' WHERE targetckey = :player_key AND id = :id",
			list("id" = rounded_message_id, "player_key" = usr.ckey)
		)
		if(!query_message_read.warn_execute())
			qdel(query_message_read)
			return
		qdel(query_message_read)

	if(href_list["messageedits"])
		if(!check_rights(R_ADMIN))
			return
		var/datum/db_query/query_get_message_edits = SSdbcore.NewQuery(
			"SELECT edits FROM [format_table_name("messages")] WHERE id = :message_id",
			list("message_id" = href_list["messageedits"])
		)
		if(!query_get_message_edits.warn_execute())
			qdel(query_get_message_edits)
			return
		if(query_get_message_edits.NextRow())
			var/edit_log = query_get_message_edits.item[1]
			if(!QDELETED(usr))
				var/datum/browser/browser = new(usr, "Note edits", "Note edits")
				browser.set_content(jointext(edit_log, ""))
				browser.open()
		qdel(query_get_message_edits)

	var/static/list/topic_handlers = AdminTopicHandlers()
	var/datum/admin_topic/handler

	for(var/I in topic_handlers)
		if(I in href_list)
			handler = topic_handlers[I]
			break

	if(!handler)
		return

	handler = new handler()
	return handler.TryRun(href_list, src)



/mob/living/proc/can_centcom_reply()
	return 0

/mob/living/carbon/human/can_centcom_reply()
	return istype(l_ear, /obj/item/device/radio/headset) || istype(r_ear, /obj/item/device/radio/headset)

/mob/living/silicon/ai/can_centcom_reply()
	return common_radio != null && !check_unable(2)

/atom/proc/extra_admin_link()
	return

/mob/extra_admin_link(source)
	if(client && eyeobj)
		return "|<A href='byond://?[source];[HrefToken()];adminobservejump=\ref[eyeobj]'>EYE</A>"

/mob/observer/ghost/extra_admin_link(source)
	if(mind && mind.current)
		return "|<A href='byond://?[source];[HrefToken()];adminobservejump=\ref[mind.current]'>BDY</A>"

/proc/admin_jump_link(atom/target, source)
	if(!target) return
	// The way admin jump links handle their src is weirdly inconsistent...
	if(istype(source, /datum/admins))
		source = "src=\ref[source]"
	else
		source = "_src_=holder"

	. = "<A href='byond://?[source];[HrefToken()];adminobservejump=\ref[target]'>JMP</A>"
	. += target.extra_admin_link(source)
