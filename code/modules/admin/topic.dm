/datum/admins/proc/formatJob(var/mob/mob,69ar/title,69ar/bantype)
	if(!bantype)
		bantype = title
	var/red = jobban_isbanned(mob, bantype)
	return \
		"<a href='?src=\ref69src69;jobban3=69bantype69;jobban4=\ref69mob69'>\
		69red ? "<font color=red>" : null6969replacetext(title, " ", "&nbsp")6969red ? "</font>" : null69\
		</a> "

/datum/admins/proc/formatJobGroup(var/mob/mob,69ar/title,69ar/color,69ar/bantype,69ar/list/joblist)
	. += "<tr bgcolor='69color69'><th><a href='?src=\ref69src69;jobban3=69bantype69;jobban4=\ref69mob69'>69title69</a></th></tr><tr><td class='jobs'>"
	for(var/jobPos in joblist)
		. += formatJob(mob, jobPos, GLOB.joblist69jobPos69)
	. += "</td></tr>"


/datum/admins/Topic(href, href_list)
	..()

	if(usr.client != owner || !check_rights(0))
		log_admin("69key_name(usr)69 tried to use the admin panel without authorization.")
		message_admins("69usr.key69 has attempted to override the admin panel!")
		return

	if(href_list69"openticket"69)
		var/ticketID = text2num(href_list69"openticket"69)
		if(!href_list69"is_mhelp"69)
			if(!check_rights(R_ADMIN))
				return
			SStickets.showDetailUI(usr, ticketID)
		else
			if(!check_rights(R_MENTOR|R_MOD|R_ADMIN))
				return
			SSmentor_tickets.showDetailUI(usr, ticketID)

	if(href_list69"take_question"69)
		var/indexNum = text2num(href_list69"take_question"69)
		if(check_rights(R_ADMIN))
			SStickets.takeTicket(indexNum)

	if(href_list69"resolve"69)
		var/indexNum = text2num(href_list69"resolve"69)
		if(check_rights(R_ADMIN))
			SStickets.resolveTicket(indexNum)

	if(href_list69"convert_ticket"69)
		var/indexNum = text2num(href_list69"convert_ticket"69)
		if(check_rights(R_ADMIN))
			SStickets.convert_to_other_ticket(indexNum)

	if(href_list69"autorespond"69)
		var/indexNum = text2num(href_list69"autorespond"69)
		if(check_rights(R_ADMIN))
			SStickets.autoRespond(indexNum)

	var/static/list/topic_handlers = AdminTopicHandlers()
	var/datum/admin_topic/handler

	for(var/I in topic_handlers)
		if(I in href_list)
			handler = topic_handlers69I69
			break

	if(!handler)
		return

	handler = new handler()
	return handler.TryRun(href_list, src)



mob/living/proc/can_centcom_reply()
	return 0

mob/living/carbon/human/can_centcom_reply()
	return istype(l_ear, /obj/item/device/radio/headset) || istype(r_ear, /obj/item/device/radio/headset)

mob/living/silicon/ai/can_centcom_reply()
	return common_radio != null && !check_unable(2)

/atom/proc/extra_admin_link()
	return

/mob/extra_admin_link(var/source)
	if(client && eyeobj)
		return "|<A HREF='?69source69;adminobservejump=\ref69eyeobj69'>EYE</A>"

/mob/observer/ghost/extra_admin_link(var/source)
	if(mind &&69ind.current)
		return "|<A HREF='?69source69;adminobservejump=\ref69mind.current69'>BDY</A>"

/proc/admin_jump_link(var/atom/target,69ar/source)
	if(!target) return
	// The way admin jump links handle their src is weirdly inconsistent...
	if(istype(source, /datum/admins))
		source = "src=\ref69source69"
	else
		source = "_src_=holder"

	. = "<A HREF='?69source69;adminobservejump=\ref69target69'>JMP</A>"
	. += target.extra_admin_link(source)
