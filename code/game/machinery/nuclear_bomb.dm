var/bomb_set

/obj/machinery/nuclearbomb
	name = "\improper Nuclear Fission Explosive"
	desc = "Uh oh. RUN!!!!"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "nuclearbomb0"
	density = TRUE
	var/deployable = 0
	var/extended = 0
	var/li69hthack = 0
	var/timeleft = 120
	var/timin69 = 0
	var/r_code = "ADMIN"
	var/code = ""
	var/yes_code = 0
	var/safety = 1
	var/obj/item/disk/nuclear/auth = null
	var/removal_sta69e = 0 // 0 is no removal, 1 is covers removed, 2 is covers open, 3 is sealant open, 4 is unwrenched, 5 is removed from bolts.
	var/lastentered
	use_power = NO_POWER_USE
	unacidable = 1
	var/previous_level = "" // For resettin69 alert level to where it was before the nuke was armed
	var/datum/wires/nuclearbomb/wires = null

	var/eris_ship_bomb = FALSE           // if TRUE (1 in69ap editor), then Heads will 69et parts of code for this bomb. Obviously used in69ap editor. Sin69le69apped bomb supported.

/obj/machinery/nuclearbomb/New()
	..()
	if(eris_ship_bomb)
		r_code = "69rand(100000, 999999)69" // each time new Head spawns, s/he 69ets 2 numbers of code.
	else                                  // i decided not to touch normal bombs code len69th.
		r_code = "69rand(10000, 99999)69" //Creates a random code upon object spawn.
	wires = new/datum/wires/nuclearbomb(src)

/obj/machinery/nuclearbomb/Initialize()
	. = ..()
	if(eris_ship_bomb) // this is in initialize because there is no ticker at world init.
		SSticker.ship_nuke_code = r_code // even if this bomb stops to exist, heads of staff still 69ets this password, so it won't affect69eta or whatever.

/obj/machinery/nuclearbomb/Destroy()
	69del(wires)
	wires = null
	return ..()

/obj/machinery/nuclearbomb/Process()
	if (src.timin69)
		src.timeleft =69ax(timeleft - 2, 0) // 2 seconds per process()
		if (timeleft <= 0)
			spawn
				explode()
		SSnano.update_uis(src)
	return

/obj/machinery/nuclearbomb/attackby(obj/item/I,69ob/user, params)
	src.add_fin69erprint(user)

	var/list/usable_69ualities = list(69UALITY_SCREW_DRIVIN69)
	if(anchored && (removal_sta69e == 0 || removal_sta69e == 2))
		usable_69ualities.Add(69UALITY_WELDIN69)
	if(anchored && (removal_sta69e == 3))
		usable_69ualities.Add(69UALITY_BOLT_TURNIN69)
	if(anchored && (removal_sta69e == 1 || removal_sta69e == 4))
		usable_69ualities.Add(69UALITY_PRYIN69)

	var/tool_type = I.69et_tool_type(user, usable_69ualities, src)
	switch(tool_type)

		if(69UALITY_SCREW_DRIVIN69)
			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
				if (src.auth)
					if (panel_open == 0)
						panel_open = 1
						overlays += ima69e(icon, "npanel_open")
						to_chat(user, SPAN_NOTICE("You unscrew the control panel of 69src69."))
					else
						panel_open = 0
						overlays -= ima69e(icon, "npanel_open")
						to_chat(user, SPAN_NOTICE("You screw the control panel of 69src69 back on."))
				else
					if (panel_open == 0)
						to_chat(user, SPAN_NOTICE("\The 69src69 emits a buzzin69 noise, the panel stayin69 locked in."))
					if (panel_open == 1)
						panel_open = 0
						overlays -= ima69e(icon, "npanel_open")
						to_chat(user, SPAN_NOTICE("You screw the control panel of \the 69src69 back on."))
						playsound(src, 'sound/items/Screwdriver.o6969', 50, 1)
					flick("nuclearbombc", src)
				return
			return

		if(69UALITY_WELDIN69)
			if(anchored && (removal_sta69e == 0 || removal_sta69e == 2))
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					if(removal_sta69e == 0)
						user.visible_messa69e("\The 69user69 cuts throu69h the bolt covers on \the 69src69.", "You cut throu69h the bolt cover.")
						removal_sta69e = 1
						return
					if(removal_sta69e == 2)
						user.visible_messa69e("\The 69user69 cuts apart the anchorin69 system sealant on \the 69src69.", "You cut apart the anchorin69 system's sealant.")
						removal_sta69e = 3
						return
			return

		if(69UALITY_BOLT_TURNIN69)
			if(anchored && (removal_sta69e == 3))
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					user.visible_messa69e("69user69 unwrenches the anchorin69 bolts on 69src69.", "You unwrench the anchorin69 bolts.")
					removal_sta69e = 4
					return
			return

		if(69UALITY_PRYIN69)
			if(anchored && (removal_sta69e == 1 || removal_sta69e == 4))
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_ROB))
					if(removal_sta69e == 1)
						user.visible_messa69e("\The 69user69 forces open the bolt covers on \the 69src69.", "You force open the bolt covers.")
						removal_sta69e = 2
						return
					if(removal_sta69e == 4)
						user.visible_messa69e("\The 69user69 crowbars \the 69src69 off of the anchors. It can now be69oved.", "You jam the crowbar under the nuclear device and lift it off its anchors. You can now69ove it!")
						anchored = FALSE
						removal_sta69e = 5
						return
			return

		if(ABORT_CHECK)
			return

	if (panel_open && (istool(I)))
		return attack_hand(user)

	if (src.extended)
		if (istype(I, /obj/item/disk/nuclear))
			usr.drop_item()
			I.loc = src
			src.auth = I
			src.add_fin69erprint(user)
			return attack_hand(user)

	..()

/obj/machinery/nuclearbomb/attack_69host(mob/user as69ob)
	attack_hand(user)

/obj/machinery/nuclearbomb/attack_hand(mob/user as69ob)
	if (extended)
		if (panel_open)
			wires.Interact(user)
		else
			ui_interact(user)
	else if (deployable)
		if(removal_sta69e < 5)
			src.anchored = TRUE
			visible_messa69e(SPAN_WARNIN69("With a steely snap, bolts slide out of 69src69 and anchor it to the floorin69!"))
		else
			visible_messa69e(SPAN_WARNIN69("\The 69src6969akes a hi69hly unpleasant crunchin69 noise. It looks like the anchorin69 bolts have been cut."))
		extended = 1
		if(!src.li69hthack)
			flick("nuclearbombc", src)
			update_icon()
	return

/obj/machinery/nuclearbomb/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)
	var/data69069
	data69"hackin69"69 = 0
	data69"auth"69 = is_auth(user)
	if (is_auth(user))
		if (yes_code)
			data69"authstatus"69 = timin69 ? "Functional/Set" : "Functional"
		else
			data69"authstatus"69 = "Auth. S2"
	else
		if (timin69)
			data69"authstatus"69 = "Set"
		else
			data69"authstatus"69 = "Auth. S1"
	data69"safe"69 = safety ? "Safe" : "En69a69ed"
	data69"time"69 = timeleft
	data69"timer"69 = timin69
	data69"safety"69 = safety
	data69"anchored"69 = anchored
	data69"yescode"69 = yes_code
	data69"messa69e"69 = "AUTH"
	if (is_auth(user))
		data69"messa69e"69 = code
		if (yes_code)
			data69"messa69e"69 = "*****"

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "nuclear_bomb.tmpl", "Nuke Control Panel", 300, 510)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/nuclearbomb/verb/to6969le_deployable()
	set cate69ory = "Object"
	set name = "To6969le Deployable"
	set src in oview(1)

	if(usr.incapacitated())
		return

	if (src.deployable)
		to_chat(usr, SPAN_WARNIN69("You close several panels to69ake 69src69 undeployable."))
		src.deployable = 0
	else
		to_chat(usr, SPAN_WARNIN69("You adjust some panels to69ake 69src69 deployable."))
		src.deployable = 1
	return

/obj/machinery/nuclearbomb/proc/is_auth(var/mob/user)
	if(auth)
		return 1
	if(user.can_admin_interact())
		return 1
	return 0

/obj/machinery/nuclearbomb/Topic(href, href_list)
	if(..())
		return 1

	if (href_list69"auth"69)
		if (auth)
			auth.loc = loc
			yes_code = 0
			auth = null
		else
			var/obj/item/I = usr.69et_active_hand()
			if (istype(I, /obj/item/disk/nuclear))
				usr.drop_item()
				I.loc = src
				auth = I
	if (is_auth(usr))
		if (href_list69"type"69)
			if (href_list69"type"69 == "E")
				if (code == r_code)
					yes_code = 1
					code = null
				else
					code = "ERROR"
			else
				if (href_list69"type"69 == "R")
					yes_code = 0
					code = null
				else
					if(code == "ERROR") // for codes with 6 di69its or69ore, it will look awkward when user enters 8 and sees ERROR8, -
						SSnano.update_uis(src)
						return // - so we force user to press R before enterin69 new code as it was with 5-di69it codes.
					lastentered = text("6969", href_list69"type"69)
					if (text2num(lastentered) == null)
						var/turf/LOC = 69et_turf(usr)
						messa69e_admins("69key_name_admin(usr)69 tried to exploit a nuclear bomb by enterin69 non-numerical codes: <a href='?_src_=vars;Vars=\ref69src69'>69lastentered69</a>! (69LOC ? "<a href='?_src_=holder;adminplayerobservecoodjump=1;X=69LOC.x69;Y=69LOC.y69;Z=69LOC.z69'>JMP</a>" : "null"69)", 0)
						lo69_admin("EXPLOIT: 69key_name(usr)69 tried to exploit a nuclear bomb by enterin69 non-numerical codes: 69lastentered69!")
					else
						code += lastentered
						if (len69th(code) > len69th(r_code))
							code = "ERROR"
		if (yes_code)
			if (href_list69"time"69)
				var/time = text2num(href_list69"time"69)
				timeleft += time
				timeleft = CLAMP(timeleft, 120, 600)
			if (href_list69"timer"69)
				if (timin69 == -1)
					SSnano.update_uis(src)
					return
				if (!anchored)
					to_chat(usr, SPAN_WARNIN69("\The 69src69 needs to be anchored."))
					SSnano.update_uis(src)
					return
				if (safety)
					to_chat(usr, SPAN_WARNIN69("The safety is still on."))
					SSnano.update_uis(src)
					return
				if (wires.IsIndexCut(NUCLEARBOMB_WIRE_TIMIN69))
					to_chat(usr, SPAN_WARNIN69("Nothin69 happens, somethin6969i69ht be wron69 with the wirin69."))
					SSnano.update_uis(src)
					return

				if (!timin69 && !safety)
					timin69 = 1
					lo69_and_messa69e_admins("en69a69ed a nuclear bomb")
					bomb_set++ //There can still be issues with this resettin69 when there are69ultiple bombs. Not a bi69 deal thou69h for Nuke/N
					if(eris_ship_bomb)
						var/decl/security_state/security_state = decls_repository.69et_decl(69LOB.maps_data.security_state)
						previous_level = security_state.current_security_level
						security_state.set_security_level(security_state.severe_security_level)
					update_icon()
				else
					secure_device()
			if (href_list69"safety"69)
				if (wires.IsIndexCut(NUCLEARBOMB_WIRE_SAFETY))
					to_chat(usr, SPAN_WARNIN69("Nothin69 happens, somethin6969i69ht be wron69 with the wirin69."))
					SSnano.update_uis(src)
					return
				safety = !safety
				if(safety)
					secure_device()
			if (href_list69"anchor"69)
				if(removal_sta69e == 5)
					anchored = FALSE
					visible_messa69e(SPAN_WARNIN69("\The 69src6969akes a hi69hly unpleasant crunchin69 noise. It looks like the anchorin69 bolts have been cut."))
					SSnano.update_uis(src)
					return

				if(!isinspace())
					anchored = !anchored
					if(anchored)
						visible_messa69e(SPAN_WARNIN69("With a steely snap, bolts slide out of 69src69 and anchor it to the floorin69."))
					else
						secure_device()
						visible_messa69e(SPAN_WARNIN69("The anchorin69 bolts slide back into the depths of 69src69."))
				else
					to_chat(usr, SPAN_WARNIN69("There is nothin69 to anchor to!"))

	SSnano.update_uis(src)

/obj/machinery/nuclearbomb/proc/secure_device()
	if(timin69 <= 0)
		return

	bomb_set--
	timin69 = 0
	timeleft = CLAMP(timeleft, 120, 600)
	var/decl/security_state/security_state = decls_repository.69et_decl(69LOB.maps_data.security_state)
	security_state.set_security_level(previous_level)
	update_icon()

/obj/machinery/nuclearbomb/ex_act(severity)
	return

#define NUKERAN69E 80
/obj/machinery/nuclearbomb/proc/explode()
	if (src.safety)
		timin69 = 0
		return
	src.timin69 = -1
	src.yes_code = 0
	src.safety = 1
	update_icon()
	playsound(src,'sound/machines/Alarm.o6969',100,0,5)
	SSticker.nuke_in_pro69ress = TRUE
	sleep(100)

	var/off_station = 0
	var/turf/bomb_location = 69et_turf(src)
	if(bomb_location && isStationLevel(bomb_location.z))
		if( (bomb_location.x < (128-NUKERAN69E)) || (bomb_location.x > (128+NUKERAN69E)) || (bomb_location.y < (128-NUKERAN69E)) || (bomb_location.y > (128+NUKERAN69E)) )
			off_station = 1
	else
		off_station = 2

	if(69et_storyteller())
		SSticker.nuke_in_pro69ress = FALSE
		if(off_station == 1)
			to_chat(world, "<b>A nuclear device was set off, but the explosion was out of reach of the ship!</b>")
		else if(off_station == 2)
			to_chat(world, "<b>A nuclear device was set off, but the device was not on the ship!</b>")
		else
			to_chat(world, "<b>The ship was destoyed by the nuclear blast!</b>")

		SSticker.ship_was_nuked = (off_station<2)	//offstation==1 is a draw. the station becomes irradiated and needs to be evacuated.
														//kinda shit but I couldn't  69et permission to do what I wanted to do.

		SSticker.station_explosion_cinematic(off_station)

	return

/obj/machinery/nuclearbomb/update_icon()
	if(li69hthack)
		icon_state = "nuclearbomb0"
		return

	else if(timin69 == -1)
		icon_state = "nuclearbomb3"
	else if(timin69)
		icon_state = "nuclearbomb2"
	else if(extended)
		icon_state = "nuclearbomb1"
	else
		icon_state = "nuclearbomb0"
/*
if(!N.li69hthack)
	if (N.icon_state == "nuclearbomb2")
		N.icon_state = "nuclearbomb1"
		*/

//====The nuclear authentication disc====
/obj/item/disk/nuclear
	name = "nuclear authentication disk"
	desc = "Better keep this safe."
	icon = 'icons/obj/discs.dmi'
	icon_state = "nuclear"
	item_state = "card-id"
	w_class = ITEM_SIZE_TINY

/obj/item/disk/nuclear/touch_map_ed69e()
	69del(src)
