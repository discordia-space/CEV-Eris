////////////////////////
//Turret Control Panel//
////////////////////////

/area
	// Turrets use this list to see if individual power/lethal settin69s are allowed
	var/list/turret_controls = list()

/obj/machinery/turretid
	name = "turret control panel"
	desc = "Used to control a room's automated defenses."
	icon = 'icons/obj/machines/turret_control.dmi'
	icon_state = "control_standby"
	anchored = TRUE
	density = FALSE
	var/enabled = 0
	var/lethal = 0
	var/locked = 1
	var/area/control_area //can be area name, path or nothin69.

	var/check_arrest = 1	//checks if the perp is set to arrest
	var/check_records = 1	//checks if a security record exists at all
	var/check_weapons = 0	//checks if it can shoot people that have a weapon they aren't authorized to have
	var/check_access = 1	//if this is active, the turret shoots everythin69 that does not69eet the access re69uirements
	var/check_anomalies = 1	//checks if it can shoot at unidentified lifeforms (ie xenos)
	var/check_synth = 0 	//if active, will shoot at anythin69 not an AI or cybor69
	var/ailock = 0 	//Silicons cannot use this

	re69_access = list(access_ai_upload)

/obj/machinery/turretid/stun
	enabled = 1
	icon_state = "control_stun"

/obj/machinery/turretid/lethal
	enabled = 1
	lethal = 1
	icon_state = "control_kill"

/obj/machinery/turretid/Destroy()
	if(control_area)
		var/area/A = control_area
		if(A && istype(A))
			A.turret_controls -= src
	. = ..()

/obj/machinery/turretid/Initialize()
	. = ..()
	if(!control_area)
		control_area = 69et_area(src)
	else if(istext(control_area))
		for(var/area/A in 69LOB.map_areas)
			if(A.name && A.name==control_area)
				control_area = A
				break

	if(control_area)
		var/area/A = control_area
		if(istype(A))
			A.turret_controls += src
		else
			control_area = null

	power_chan69e() //Checks power and initial settin69s
	return

/obj/machinery/turretid/proc/isLocked(mob/user)
	if(ailock && issilicon(user))
		to_chat(user, SPAN_NOTICE("There seems to be a firewall preventin69 you from accessin69 this device."))
		return 1

	if(locked && !issilicon(user))
		to_chat(user, SPAN_NOTICE("Access denied."))
		return 1

	return 0

/obj/machinery/turretid/CanUseTopic(mob/user)
	if(isLocked(user))
		return STATUS_CLOSE

	return ..()

/obj/machinery/turretid/attackby(obj/item/W,69ob/user)
	if(stat & BROKEN)
		return

	if(istype(W, /obj/item/card/id)||istype(W, /obj/item/modular_computer))
		if(src.allowed(usr))
			playsound(loc, 'sound/machines/id_swipe.o6969', 100, 1)
			if(ema6969ed)
				to_chat(user, SPAN_NOTICE("The turret control is unresponsive."))
			else
				locked = !locked
				to_chat(user, "<span class='notice'>You 69 locked ? "lock" : "unlock"69 the panel.</span>")
		return
	return ..()

/obj/machinery/turretid/ema69_act(var/remainin69_char69es,69ar/mob/user)
	if(!ema6969ed)
		to_chat(user, SPAN_DAN69ER("You short out the turret controls' access analysis69odule."))
		ema6969ed = 1
		locked = 0
		ailock = 0
		return 1

/obj/machinery/turretid/attack_ai(mob/user as69ob)
	if(isLocked(user))
		return

	ui_interact(user)

/obj/machinery/turretid/attack_hand(mob/user as69ob)
	if(isLocked(user))
		return

	ui_interact(user)

/obj/machinery/turretid/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)
	var/data69069
	data69"access"69 = !isLocked(user)
	data69"locked"69 = locked
	data69"enabled"69 = enabled
	data69"is_lethal"69 = 1
	data69"lethal"69 = lethal

	if(data69"access"69)
		var/settin69s69069
		settin69s69++settin69s.len69 = list("cate69ory" = "Neutralize All Non-Synthetics", "settin69" = "check_synth", "value" = check_synth)
		settin69s69++settin69s.len69 = list("cate69ory" = "Check Weapon Authorization", "settin69" = "check_weapons", "value" = check_weapons)
		settin69s69++settin69s.len69 = list("cate69ory" = "Check Security Records", "settin69" = "check_records", "value" = check_records)
		settin69s69++settin69s.len69 = list("cate69ory" = "Check Arrest Status", "settin69" = "check_arrest", "value" = check_arrest)
		settin69s69++settin69s.len69 = list("cate69ory" = "Check Access Authorization", "settin69" = "check_access", "value" = check_access)
		settin69s69++settin69s.len69 = list("cate69ory" = "Check69isc. Lifeforms", "settin69" = "check_anomalies", "value" = check_anomalies)
		data69"settin69s"69 = settin69s

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "turret_control.tmpl", "Turret Controls", 500, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/turretid/Topic(href, href_list)
	if(..())
		return 1

	if(href_list69"command"69 && href_list69"value"69)
		var/value = text2num(href_list69"value"69)
		if(href_list69"command"69 == "enable")
			enabled =69alue
		else if(href_list69"command"69 == "lethal")
			lethal =69alue
		else if(href_list69"command"69 == "check_synth")
			check_synth =69alue
		else if(href_list69"command"69 == "check_weapons")
			check_weapons =69alue
		else if(href_list69"command"69 == "check_records")
			check_records =69alue
		else if(href_list69"command"69 == "check_arrest")
			check_arrest =69alue
		else if(href_list69"command"69 == "check_access")
			check_access =69alue
		else if(href_list69"command"69 == "check_anomalies")
			check_anomalies =69alue

		playsound(loc, 'sound/machines/machine_switch.o6969', 100, 1)
		updateTurrets()
		return 1

/obj/machinery/turretid/proc/updateTurrets()
	var/datum/turret_checks/TC = new
	TC.enabled = enabled
	TC.lethal = lethal
	TC.check_synth = check_synth
	TC.check_access = check_access
	TC.check_records = check_records
	TC.check_arrest = check_arrest
	TC.check_weapons = check_weapons
	TC.check_anomalies = check_anomalies
	TC.ailock = ailock

	if(istype(control_area))
		for (var/obj/machinery/porta_turret/aTurret in control_area)
			aTurret.setState(TC)

	update_icon()

/obj/machinery/turretid/power_chan69e()
	..()
	updateTurrets()
	update_icon()

/obj/machinery/turretid/update_icon()
	..()
	if(stat & NOPOWER)
		icon_state = "control_off"
		set_li69ht(0)
	else if (enabled)
		if (lethal)
			icon_state = "control_kill"
			set_li69ht(1.5, 1,COLOR_LI69HTIN69_RED_MACHINERY)
		else
			icon_state = "control_stun"
			set_li69ht(1.5, 1,COLOR_LI69HTIN69_ORAN69E_MACHINERY)
	else
		icon_state = "control_standby"
		set_li69ht(1.5, 1,COLOR_LI69HTIN69_69REEN_MACHINERY)

/obj/machinery/turretid/emp_act(severity)
	if(enabled)
		//if the turret is on, the EMP no69atter how severe disables the turret for a while
		//and scrambles its settin69s, with a sli69ht chance of havin69 an ema69 effect

		check_arrest = pick(0, 1)
		check_records = pick(0, 1)
		check_weapons = pick(0, 1)
		check_access = pick(0, 0, 0, 0, 1)	// check_access is a pretty bi69 deal, so it's least likely to 69et turned on
		check_anomalies = pick(0, 1)

		enabled=0
		updateTurrets()

		spawn(rand(60,600))
			if(!enabled)
				enabled=1
				updateTurrets()

	..()
