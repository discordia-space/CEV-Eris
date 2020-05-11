/datum/admins/proc/formatJob(var/mob/mob, var/title, var/bantype)
	if(!bantype)
		bantype = title
	var/red = jobban_isbanned(mob, bantype)
	return \
		"<a href='?src=\ref[src];jobban3=[bantype];jobban4=\ref[mob]'>\
		[red ? "<font color=red>" : null][replacetext(title, " ", "&nbsp")][red ? "</font>" : null]\
		</a> "

/datum/admins/proc/formatJobGroup(var/mob/mob, var/title, var/color, var/bantype, var/list/jobList)
	. += "<tr bgcolor='[color]'><th><a href='?src=\ref[src];jobban3=[bantype];jobban4=\ref[mob]'>[title]</a></th></tr><tr><td class='jobs'>"
	for(var/jobPos in jobList)
		. += formatJob(mob, jobPos, jobList[jobPos])
	. += "</td></tr>"


/datum/admins/Topic(href, href_list)
	..()

	if(usr.client != owner || !check_rights(0))
		log_admin("[key_name(usr)] tried to use the admin panel without authorization.")
		message_admins("[usr.key] has attempted to override the admin panel!")
		return

	var/static/list/topic_handlers = AdminTopicHandlers()
	var/datum/world_topic/handler

	for(var/I in topic_handlers)
		if(I in href_list)
			handler = topic_handlers[I]
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
		return "|<A HREF='?[source];adminobservejump=\ref[eyeobj]'>EYE</A>"

/mob/observer/ghost/extra_admin_link(var/source)
	if(mind && mind.current)
		return "|<A HREF='?[source];adminobservejump=\ref[mind.current]'>BDY</A>"

/proc/admin_jump_link(var/atom/target, var/source)
	if(!target) return
	// The way admin jump links handle their src is weirdly inconsistent...
	if(istype(source, /datum/admins))
		source = "src=\ref[source]"
	else
		source = "_src_=holder"

	. = "<A HREF='?[source];adminobservejump=\ref[target]'>JMP</A>"
	. += target.extra_admin_link(source)
