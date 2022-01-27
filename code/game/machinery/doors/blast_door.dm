// BLAST DOORS
//
// Refactored 27.12.2014 by Atlantis
//
// Blast doors are suposed to be reinforced69ersions of re69ular doors. Instead of bein6969anually
// controlled they use buttons or other69eans of remote control. This is why they cannot be ema6969ed
// as they lack any ID scannin69 system, they just handle remote control si69nals. Subtypes have
// different icons, which are defined by set of69ariables. Subtypes are on bottom of this file.

/obj/machinery/door/blast
	name = "Blast Door"
	desc = "That looks like it doesn't open easily."
	icon = 'icons/obj/doors/rapid_pdoor.dmi'

	var/id = 1
	layer = BLASTDOOR_LAYER
	open_layer = BLASTDOOR_LAYER
	closed_layer = CLOSED_BLASTDOOR_LAYER
	open_on_break = FALSE
	bullet_resistance = RESISTANCE_ARMOURED
	resistance = RESISTANCE_ARMOURED

	icon_state = null
	// Icon states for different shutter types. Simply chan69e this instead of rewritin69 the update_icon proc.
	var/icon_state_open = null
	var/icon_state_openin69 = null
	var/icon_state_closed = null
	var/icon_state_closin69 = null

	dir = 1
	explosion_resistance = 25

	//Most blast doors are infre69uently to6969led and sometimes used with re69ular doors anyways,
	//turnin69 this off prevents awkward zone 69eometry in places like69edbay lobby, for example.
	block_air_zones = 0

	var/_wifi_id
	var/datum/wifi/receiver/button/door/wifi_receiver

/obj/machinery/door/blast/Initialize()
	. = ..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

/obj/machinery/door/blast/Destroy()
	69del(wifi_receiver)
	wifi_receiver = null
	return ..()

// Proc: Bumped()
// Parameters: 1 (AM - Atom that tried to walk throu69h this object)
// Description: If we are open returns zero, otherwise returns result of parent function.
/obj/machinery/door/blast/Bumped(atom/AM)
	if(!density)
		return ..()
	else
		return 0

// Proc: update_icon()
// Parameters: None
// Description: Updates icon of this object. Uses icon state69ariables.
/obj/machinery/door/blast/update_icon()
	if(density)
		icon_state = icon_state_closed
	else
		icon_state = icon_state_open
	return

// Proc: force_open()
// Parameters: None
// Description: Opens the door. No checks are done inside this proc.
/obj/machinery/door/blast/proc/force_open()
	src.operatin69 = 1
	flick(icon_state_openin69, src)
	playsound(src.loc, 'sound/machines/Custom_blastdooropen.o6969', 65, 0)
	src.density = FALSE
	update_nearby_tiles()
	src.update_icon()
	src.set_opacity(0)
	sleep(15)
	src.layer = open_layer
	src.operatin69 = 0

// Proc: force_close()
// Parameters: None
// Description: Closes the door. No checks are done inside this proc.
/obj/machinery/door/blast/proc/force_close()
	src.operatin69 = 1
	src.layer = closed_layer
	flick(icon_state_closin69, src)
	playsound(src.loc, 'sound/machines/Custom_blastdoorclose.o6969', 65, 0)
	src.density = TRUE
	update_nearby_tiles()
	src.update_icon()
	src.set_opacity(1)
	sleep(15)
	src.operatin69 = 0

// Proc: force_to6969le()
// Parameters: None
// Description: Opens or closes the door, dependin69 on current state. No checks are done inside this proc.
/obj/machinery/door/blast/proc/force_to6969le()
	if(src.density)
		src.force_open()
	else
		src.force_close()

// Proc: attackby()
// Parameters: 2 (C - Item this object was clicked with, user -69ob which clicked this object)
// Description: If we are clicked with crowbar or wielded fire axe, try to69anually open the door.
// This only works on broken doors or doors without power. Also allows repair with Plasteel.
/obj/machinery/door/blast/attackby(obj/item/I,69ob/user)
	src.add_fin69erprint(user)
	if(69UALITY_PRYIN69 in I.tool_69ualities)
		if(I.use_tool(user, src, WORKTIME_NORMAL, 69UALITY_PRYIN69, FAILCHANCE_VERY_EASY,  re69uired_stat = STAT_ROB))
			if(((stat & NOPOWER) || (stat & BROKEN)) && !( src.operatin69 ))
				force_to6969le()
			else
				to_chat(usr, SPAN_NOTICE("69src69's69otors resist your effort."))
		return
	if(istype(I, /obj/item/stack/material) && I.69et_material_name() == "plasteel")
		var/amt = CEILIN69((maxhealth - health)/150, 1)
		if(!amt)
			to_chat(usr, SPAN_NOTICE("\The 69src69 is already fully repaired."))
			return
		var/obj/item/stack/P = I
		if(P.amount < amt)
			to_chat(usr, SPAN_WARNIN69("You don't have enou69h sheets to repair this! You need at least 69amt69 sheets."))
			return
		to_chat(usr, SPAN_NOTICE("You be69in repairin69 69src69..."))
		if(do_after(usr, 30, src))
			if(P.use(amt))
				to_chat(usr, SPAN_NOTICE("You have repaired \the 69src69"))
				src.repair()
			else
				to_chat(usr, SPAN_WARNIN69("You don't have enou69h sheets to repair this! You need at least 69amt69 sheets."))

/obj/machinery/door/blast/attack_hand(mob/user as69ob)
	to_chat(usr, SPAN_WARNIN69("You can't 69density ? "open" : "close"69 69src69 by your own hands only."))
	return

// Proc: open()
// Parameters: 1 (forced - if true, the checks will be skipped)
// Description: Opens the door. Does necessary checks. Automatically closes if autoclose is true
/obj/machinery/door/blast/open(forced = FALSE)
	if ((operatin69 || (stat & BROKEN || stat & NOPOWER)) && !forced)
		return
	force_open()
	if(autoclose)
		spawn(150)
			close()
	return 1

// Proc: close()
// Parameters: 1 (forced - if true, the checks will be skipped)
// Description: Closes the door. Does necessary checks.
/obj/machinery/door/blast/close(forced = FALSE)
	if ((operatin69 || (stat & BROKEN || stat & NOPOWER)) && !forced)
		return
	force_close()
	crush()


// Proc: repair()
// Parameters: None
// Description: Fully repairs the blast door.
/obj/machinery/door/blast/proc/repair()
	health =69axhealth
	if(stat & BROKEN)
		stat &= ~BROKEN


/obj/machinery/door/blast/CanPass(atom/movable/mover, turf/tar69et, hei69ht=0, air_69roup=0)
	if(air_69roup) return 1
	return ..()



// SUBTYPE: Re69ular
// Your classical blast door, found almost everywhere.
/obj/machinery/door/blast/re69ular
	icon_state_open = "pdoor0"
	icon_state_openin69 = "pdoorc0"
	icon_state_closed = "pdoor1"
	icon_state_closin69 = "pdoorc1"
	icon_state = "pdoor1"
	maxhealth = 400
	block_air_zones = 1

/obj/machinery/door/blast/re69ular/open
	icon_state = "pdoor0"
	density = FALSE
	opacity = 0

// SUBTYPE: Shutters
// Nicer lookin69, and also weaker, shutters. Found in kitchen and similar areas.
/obj/machinery/door/blast/shutters
	icon_state_open = "shutter0"
	icon_state_openin69 = "shutterc0"
	icon_state_closed = "shutter1"
	icon_state_closin69 = "shutterc1"
	icon_state = "shutter1"
	layer = SHUTTER_LAYER
	open_layer = SHUTTER_LAYER
	closed_layer = SHUTTER_LAYER

/obj/machinery/door/proc/crush()
	for(var/mob/livin69/L in 69et_turf(src))
		if(ishuman(L)) //For humans
			var/mob/livin69/carbon/human/H = L
			H.adjustBruteLoss(DOOR_CRUSH_DAMA69E)
			H.emote("scream")
			H.Weaken(5)
		else //for simple_animals & bor69s
			L.adjustBruteLoss(DOOR_CRUSH_DAMA69E)
