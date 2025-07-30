
GLOBAL_VAR_INIT(OOC_COLOR, null)//If this is null, use the CSS for OOC. Otherwise, use a custom colour.
GLOBAL_VAR_INIT(normal_ooc_colour, "#002eb8")

/client/verb/ooc(msg as text)
	set name = "OOC"
	set category = "OOC"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_warning("Speech is currently admin-disabled."))
		return

	if(!mob)	return
	if(IsGuestKey(key))
		to_chat(src, "Guests may not use OOC.")
		return

	msg = sanitize(msg)
	if(!msg)	return

	if(src.get_preference_value(/datum/client_preference/show_ooc) == GLOB.PREF_HIDE)
		to_chat(src, span_warning("You have OOC muted."))
		return

	if(!holder)
		if(!GLOB.ooc_allowed)
			to_chat(src, span_danger("OOC is globally muted."))
			return
		if(!GLOB.dooc_allowed && (mob.stat == DEAD))
			to_chat(usr, span_danger("OOC for dead mobs has been turned off."))
			return
		if(prefs.muted & MUTE_OOC)
			to_chat(src, span_danger("You cannot use OOC (muted)."))
			return
		if(handle_spam_prevention(msg,MUTE_OOC))
			return

	log_ooc("[mob.name]/[key] : [msg]")

	msg = emoji_parse(msg)

	var/keyname = key
	if(!!IsByondMember())
		// if(prefs.toggles & MEMBER_PUBLIC)
		keyname = "<font color='[src.prefs.ooccolor || GLOB.normal_ooc_colour]'>[icon2html('icons/ui_icons/chat/member_content.dmi', world, "blag")][keyname]</font>"
	// var/ooc_style = "everyone"
	// if(holder && !holder.fakekey)
	// 	ooc_style = "elevated"
	// 	if(holder.rights & R_DEBUG)
	// 		ooc_style = "developer"
	// 	if(holder.rights & R_ADMIN)
	// 		ooc_style = "admin"


	// for(var/client/target in GLOB.clients)
	// 	if(target.get_preference_value(/datum/client_preference/show_ooc) != GLOB.PREF_SHOW)
	// 		continue
	// 	var/display_name = src.key
	// 	if(holder)
	// 		if(holder.fakekey)
	// 			if(target.holder)
	// 				display_name = "[holder.fakekey]/([src.key])"
	// 			else
	// 				display_name = holder.fakekey
	// 	if(holder && !holder.fakekey && (holder.rights & R_ADMIN) && config.allow_admin_ooccolor && (src.prefs.ooccolor != initial(src.prefs.ooccolor))) // keeping this for the badmins
	// 		to_chat(target, span_ooc("" + create_text_tag("ooc", "OOC:", target) + " <font color='[src.prefs.ooccolor]'><EM>[display_name]:</EM></font> <span class='[ooc_style]'><span class='message linkify'>[msg]</span></span>"))
	// 	else
	// 		to_chat(target, span_ooc("<span class='[ooc_style]'>" + create_text_tag("ooc", "OOC:", target) + " <EM>[display_name]:</EM> <span class='message linkify'>[msg]</span></span>"))
	for(var/client/receiver as anything in GLOB.clients)
		if(!receiver.prefs) // Client being created or deleted. Despite all, this can be null.
			continue
		if(receiver.get_preference_value(/datum/client_preference/show_ooc) != GLOB.PREF_SHOW)
			continue
		if(holder?.fakekey in receiver.prefs.ignored_players)
			continue
		var/avoid_highlight = receiver == src
		if(holder)
			if(!holder.fakekey || receiver.holder)
				if(check_rights_for(src, R_ADMIN))
					var/ooc_color = src.prefs.ooccolor
					to_chat(receiver, span_adminooc("[CONFIG_GET(flag/allow_admin_ooccolor) && ooc_color ? "<font color=[ooc_color]>" :"" ][span_prefix("OOC:")] <EM>[keyname][holder.fakekey ? "/([holder.fakekey])" : ""]:</EM> <span class='message linkify'>[msg]</span>"), avoid_highlighting = avoid_highlight)
				else
					to_chat(receiver, span_adminobserverooc(span_prefix("OOC:</span> <EM>[keyname][holder.fakekey ? "/([holder.fakekey])" : ""]:</EM> <span class='message linkify'>[msg]")), avoid_highlighting = avoid_highlight)
			else
				if(GLOB.OOC_COLOR)
					to_chat(receiver, span_oocplain("<font color='[GLOB.OOC_COLOR]'><b>[span_prefix("OOC:")] <EM>[holder.fakekey ? holder.fakekey : key]:</EM> <span class='message linkify'>[msg]</span></b></font>"), avoid_highlighting = avoid_highlight)
				else
					to_chat(receiver, span_ooc(span_prefix("OOC:</span> <EM>[holder.fakekey ? holder.fakekey : key]:</EM> <span class='message linkify'>[msg]")), avoid_highlighting = avoid_highlight)

		else if(!(key in receiver.prefs.ignored_players))
			if(GLOB.OOC_COLOR)
				to_chat(receiver, span_oocplain("<font color='[GLOB.OOC_COLOR]'><b>[span_prefix("OOC:")] <EM>[keyname]:</EM> <span class='message linkify'>[msg]</span></b></font>"), avoid_highlighting = avoid_highlight)
			else
				to_chat(receiver, span_ooc(span_prefix("OOC:</span> <EM>[keyname]:</EM> <span class='message linkify'>[msg]")), avoid_highlighting = avoid_highlight)

/client/verb/looc(msg as text)
	set name = "LOOC"
	set desc = "Local OOC, seen only by those in view."
	set category = "OOC"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return

	if(!mob)
		return

	if(IsGuestKey(key))
		to_chat(src, "Guests may not use OOC.")
		return

	msg = sanitize(msg)
	if(!msg)
		return

	if(src.get_preference_value(/datum/client_preference/show_looc) == GLOB.PREF_HIDE)
		to_chat(src, span_danger("You have LOOC muted."))
		return

	if(!holder)
		if(!GLOB.looc_allowed)
			to_chat(src, span_danger("LOOC is globally muted."))
			return
		if(!GLOB.dooc_allowed && (mob.stat == DEAD))
			to_chat(usr, span_danger("OOC for dead mobs has been turned off."))
			return
		if(prefs.muted & MUTE_OOC)
			to_chat(src, span_danger("You cannot use OOC (muted)."))
			return
		if(handle_spam_prevention(msg, MUTE_OOC))
			return

	log_ooc("(LOCAL) [mob.name]/[key] : [msg]")

	var/mob/source = mob.get_looc_source()

	var/turf/T = get_turf(source)
	var/list/listening = list()
	listening |= src	// We can always hear ourselves.
	var/list/listening_obj = list()
	var/list/eye_heard = list()

		// This is essentially a copy/paste from living/say() the purpose is to get mobs inside of objects without recursing through
		// the contents of every mob and object in get_mobs_or_objects_in_view() looking for PAI's inside of the contents of a bag inside the
		// contents of a mob inside the contents of a welded shut locker we essentially get a list of turfs and see if the mob is on one of them.

	if(T)
		var/list/hear = hear(7,T)
		var/list/hearturfs = list()

		for(var/I in hear)
			if(ismob(I))
				var/mob/M = I
				listening |= M.client
				hearturfs += M.locs[1]
			else if(isobj(I))
				var/obj/O = I
				hearturfs |= O.locs[1]
				listening_obj |= O

		for(var/mob/M in GLOB.player_list)
			if(M.get_preference_value(/datum/client_preference/show_ooc) == GLOB.PREF_HIDE)
				continue
			if(isAI(M))
				var/mob/living/silicon/ai/A = M
				if(A.eyeobj && (A.eyeobj.locs[1] in hearturfs))
					eye_heard |= M.client
					listening |= M.client
					continue

			if(M.loc && (M.locs[1] in hearturfs))
				listening |= M.client


	for(var/client/hearer in listening)
		var/admin_stuff = ""
		var/prefix = ""
		if(hearer in GLOB.admins)
			admin_stuff += "/([key])"
			if(hearer != src)
				admin_stuff += "([admin_jump_link(mob, hearer.holder)])"
		if(isAI(hearer.mob))
			if(hearer in eye_heard)
				prefix = "(Eye) "
			else
				prefix = "(Core) "
		if(hearer.prefs.RC_see_looc_on_map)
			hearer.mob?.create_chat_message(mob, /datum/language/common, "\[LOOC: [msg]\]", runechat_flags = LOOC_MESSAGE)
		to_chat(hearer, span_looc("[span_prefix("LOOC:")] [span_prefix(prefix)]<EM>[span_name("[mob.name]")][admin_stuff]:</EM> <span class='message linkify'>[msg]</span>"), type = MESSAGE_TYPE_LOOC, avoid_highlighting = (hearer == mob))

	for(var/client/client in GLOB.admins)	//Now send to all admins that weren't in range.
		if(!(client in listening) && client.get_preference_value(/datum/client_preference/staff/show_rlooc) == GLOB.PREF_SHOW)
			var/admin_stuff = "/([key])([admin_jump_link(client, client.holder)])"
			var/prefix = "[listening[client] ? "" : "(R)"]LOOC"
			if(client.prefs.RC_see_looc_on_map)
				client.mob?.create_chat_message(mob, /datum/language/common, "\[LOOC: [msg]\]", runechat_flags = LOOC_MESSAGE)
			to_chat(client, span_looc("[span_prefix("[prefix]:")] <EM>[admin_stuff]:</EM> <span class='message linkify'>[msg]</span>"), type = MESSAGE_TYPE_LOOC, avoid_highlighting = (client == src))

/mob/proc/get_looc_source()
	return src

/mob/living/silicon/ai/get_looc_source()
	if(eyeobj)
		return eyeobj
	return src

//Checks admin notice
/client/verb/admin_notice()
	set name = "Adminnotice"
	set category = "Admin"
	set desc ="Check the admin notice if it has been set"

	if(GLOB.admin_notice)
		to_chat(src, "[span_boldnotice("Admin Notice:")]\n \t [GLOB.admin_notice]")
	else
		to_chat(src, span_notice("There are no admin notices at the moment."))
