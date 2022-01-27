
/client/verb/ooc(ms69 as text)
	set69ame = "OOC"
	set cate69ory = "OOC"

	if(say_disabled)	//This is here to try to identify la69 problems
		to_chat(usr, SPAN_WARNIN69("Speech is currently admin-disabled."))
		return

	if(!mob)	return
	if(Is69uestKey(key))
		to_chat(src, "69uests69ay69ot use OOC.")
		return

	ms69 = sanitize(ms69)
	if(!ms69)	return

	if(src.69et_preference_value(/datum/client_preference/show_ooc) == 69LOB.PREF_HIDE)
		to_chat(src, SPAN_WARNIN69("You have OOC69uted."))
		return

	if(!holder)
		if(!confi69.ooc_allowed)
			to_chat(src, SPAN_DAN69ER("OOC is 69lobally69uted."))
			return
		if(!confi69.dooc_allowed && (mob.stat == DEAD))
			to_chat(usr, SPAN_DAN69ER("OOC for dead69obs has been turned off."))
			return
		if(prefs.muted &69UTE_OOC)
			to_chat(src, SPAN_DAN69ER("You cannot use OOC (muted)."))
			return
		if(handle_spam_prevention(ms69,MUTE_OOC))
			return

	lo69_ooc("69mob.name69/69key69 : 69ms6969")

	ms69 = emoji_parse(ms69)

	var/ooc_style = "everyone"
	if(holder && !holder.fakekey)
		ooc_style = "elevated"
		if(holder.ri69hts & R_MOD)
			ooc_style = "moderator"
		if(holder.ri69hts & R_DEBU69)
			ooc_style = "developer"
		if(holder.ri69hts & R_ADMIN)
			ooc_style = "admin"

	for(var/client/tar69et in clients)
		if(tar69et.69et_preference_value(/datum/client_preference/show_ooc) == 69LOB.PREF_SHOW)
			var/display_name = src.key
			if(holder)
				if(holder.fakekey)
					if(tar69et.holder)
						display_name = "69holder.fakekey69/(69src.key69)"
					else
						display_name = holder.fakekey
			if(holder && !holder.fakekey && (holder.ri69hts & R_ADMIN) && confi69.allow_admin_ooccolor && (src.prefs.ooccolor != initial(src.prefs.ooccolor))) // keepin69 this for the badmins
				to_chat(tar69et, "<span class='ooc'>" + create_text_ta69("ooc", "OOC:", tar69et) + " <font color='69src.prefs.ooccolor69'><EM>69display_name69:</EM></font> <span class='69ooc_style69'><span class='messa69e linkify'>69ms6969</span></span></span>")
			else
				to_chat(tar69et, "<span class='ooc'><span class='69ooc_style69'>" + create_text_ta69("ooc", "OOC:", tar69et) + " <EM>69display_name69:</EM> <span class='messa69e linkify'>69ms6969</span></span></span>")

/client/verb/looc(ms69 as text)
	set69ame = "LOOC"
	set desc = "Local OOC, seen only by those in69iew."
	set cate69ory = "OOC"

	if(say_disabled)	//This is here to try to identify la69 problems
		to_chat(usr, SPAN_DAN69ER("Speech is currently admin-disabled."))
		return

	if(!mob)
		return

	if(Is69uestKey(key))
		to_chat(src, "69uests69ay69ot use OOC.")
		return

	ms69 = sanitize(ms69)
	if(!ms69)
		return

	if(src.69et_preference_value(/datum/client_preference/show_looc) == 69LOB.PREF_HIDE)
		to_chat(src, SPAN_DAN69ER("You have LOOC69uted."))
		return

	if(!holder)
		if(!confi69.looc_allowed)
			to_chat(src, SPAN_DAN69ER("LOOC is 69lobally69uted."))
			return
		if(!confi69.dooc_allowed && (mob.stat == DEAD))
			to_chat(usr, SPAN_DAN69ER("OOC for dead69obs has been turned off."))
			return
		if(prefs.muted &69UTE_OOC)
			to_chat(src, SPAN_DAN69ER("You cannot use OOC (muted)."))
			return
		if(handle_spam_prevention(ms69,69UTE_OOC))
			return

	lo69_ooc("(LOCAL) 69mob.name69/69key69 : 69ms6969")

	var/mob/source =69ob.69et_looc_source()

	var/display_name = key
	if(holder && holder.fakekey)
		display_name = holder.fakekey
	if(mob.stat != DEAD)
		display_name =69ob.name

	var/turf/T = 69et_turf(source)
	var/list/listenin69 = list()
	listenin69 |= src	// We can always hear ourselves.
	var/list/listenin69_obj = list()
	var/list/eye_heard = list()

		// This is essentially a copy/paste from livin69/say() the purpose is to 69et69obs inside of objects without recursin69 throu69h
		// the contents of every69ob and object in 69et_mobs_or_objects_in_view() lookin69 for PAI's inside of the contents of a ba69 inside the
		// contents of a69ob inside the contents of a welded shut locker we essentially 69et a list of turfs and see if the69ob is on one of them.

	if(T)
		var/list/hear = hear(7,T)
		var/list/hearturfs = list()

		for(var/I in hear)
			if(ismob(I))
				var/mob/M = I
				listenin69 |=69.client
				hearturfs +=69.locs69169
			else if(isobj(I))
				var/obj/O = I
				hearturfs |= O.locs69169
				listenin69_obj |= O

		for(var/mob/M in 69LOB.player_list)
			if(M.69et_preference_value(/datum/client_preference/show_ooc) == 69LOB.PREF_HIDE)
				continue
			if(isAI(M))
				var/mob/livin69/silicon/ai/A =69
				if(A.eyeobj && (A.eyeobj.locs69169 in hearturfs))
					eye_heard |=69.client
					listenin69 |=69.client
					continue

			if(M.loc && (M.locs69169 in hearturfs))
				listenin69 |=69.client


	for(var/client/t in listenin69)
		var/admin_stuff = ""
		var/prefix = ""
		if(t in admins)
			admin_stuff += "/(69key69)"
			if(t != src)
				admin_stuff += "(69admin_jump_link(mob, t.holder)69)"
		if(isAI(t.mob))
			if(t in eye_heard)
				prefix = "(Eye) "
			else
				prefix = "(Core) "
		to_chat(t, "<span class='ooc'><span class='looc'>" + create_text_ta69("looc", "LOOC:", t) + " <span class='prefix'>69prefix69</span><EM>69display_name6969admin_stuff69:</EM> <span class='messa69e'>69ms6969</span></span></span>")


	for(var/client/adm in admins)	//Now send to all admins that weren't in ran69e.
		if(!(adm in listenin69) && adm.69et_preference_value(/datum/client_preference/staff/show_rlooc) == 69LOB.PREF_SHOW)
			var/admin_stuff = "/(69key69)(69admin_jump_link(mob, adm.holder)69)"
			var/prefix = "(R)"

			to_chat(adm, "<span class='ooc'><span class='looc'>" + create_text_ta69("looc", "LOOC:", adm) + " <span class='prefix'>69prefix69</span><EM>69display_name6969admin_stuff69:</EM> <span class='messa69e'>69ms6969</span></span></span>")

/mob/proc/69et_looc_source()
	return src

/mob/livin69/silicon/ai/69et_looc_source()
	if(eyeobj)
		return eyeobj
	return src
