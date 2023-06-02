// BLAST DOORS
//
// Refactored 27.12.2014 by Atlantis
//
// Blast doors are suposed to be reinforced versions of regular doors. Instead of being manually
// controlled they use buttons or other means of remote control. This is why they cannot be emagged
// as they lack any ID scanning system, they just handle remote control signals. Subtypes have
// different icons, which are defined by set of variables. Subtypes are on bottom of this file.

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
	// Icon states for different shutter types. Simply change this instead of rewriting the update_icon proc.
	var/icon_state_open = null
	var/icon_state_opening = null
	var/icon_state_closed = null
	var/icon_state_closing = null

	dir = 1
	explosion_resistance = 25

	//Most blast doors are infrequently toggled and sometimes used with regular doors anyways,
	//turning this off prevents awkward zone geometry in places like medbay lobby, for example.
	block_air_zones = 0

	var/_wifi_id
	var/datum/wifi/receiver/button/door/wifi_receiver

/obj/machinery/door/blast/Initialize()
	. = ..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)

/obj/machinery/door/blast/Destroy()
	qdel(wifi_receiver)
	wifi_receiver = null
	return ..()

// Proc: Bumped()
// Parameters: 1 (AM - Atom that tried to walk through this object)
// Description: If we are open returns zero, otherwise returns result of parent function.
/obj/machinery/door/blast/Bumped(atom/AM)
	if(!density)
		return ..()
	else
		return 0

// Proc: update_icon()
// Parameters: None
// Description: Updates icon of this object. Uses icon state variables.
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
	src.operating = 1
	flick(icon_state_opening, src)
	playsound(src.loc, 'sound/machines/Custom_blastdooropen.ogg', 65, 0)
	src.density = FALSE
	update_nearby_tiles()
	src.update_icon()
	src.set_opacity(0)
	src.layer = open_layer
	src.operating = 0

// Proc: force_close()
// Parameters: None
// Description: Closes the door. No checks are done inside this proc.
/obj/machinery/door/blast/proc/force_close()
	src.operating = 1
	src.layer = closed_layer
	flick(icon_state_closing, src)
	playsound(src.loc, 'sound/machines/Custom_blastdoorclose.ogg', 65, 0)
	src.density = TRUE
	update_nearby_tiles()
	src.update_icon()
	src.set_opacity(1)
	src.operating = 0

// Proc: force_toggle()
// Parameters: None
// Description: Opens or closes the door, depending on current state. No checks are done inside this proc.
/obj/machinery/door/blast/proc/force_toggle()
	if(src.density)
		src.force_open()
	else
		src.force_close()

// Proc: attackby()
// Parameters: 2 (C - Item this object was clicked with, user - Mob which clicked this object)
// Description: If we are clicked with crowbar or wielded fire axe, try to manually open the door.
// This only works on broken doors or doors without power. Also allows repair with Plasteel.
/obj/machinery/door/blast/attackby(obj/item/I, mob/user)
	src.add_fingerprint(user)
	if(QUALITY_PRYING in I.tool_qualities)
		if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_PRYING, FAILCHANCE_VERY_EASY,  required_stat = STAT_ROB))
			if(((stat & NOPOWER) || (stat & BROKEN)) && !( src.operating ))
				force_toggle()
			else
				to_chat(usr, SPAN_NOTICE("[src]'s motors resist your effort."))
		return
	if(istype(I, /obj/item/stack/material) && I.get_material_name() == "plasteel")
		var/amt = CEILING((maxHealth - health)/150, 1)
		if(!amt)
			to_chat(usr, SPAN_NOTICE("\The [src] is already fully repaired."))
			return
		var/obj/item/stack/P = I
		if(P.amount < amt)
			to_chat(usr, SPAN_WARNING("You don't have enough sheets to repair this! You need at least [amt] sheets."))
			return
		to_chat(usr, SPAN_NOTICE("You begin repairing [src]..."))
		if(do_after(usr, 30, src))
			if(P.use(amt))
				to_chat(usr, SPAN_NOTICE("You have repaired \the [src]"))
				src.repair()
			else
				to_chat(usr, SPAN_WARNING("You don't have enough sheets to repair this! You need at least [amt] sheets."))

/obj/machinery/door/blast/attack_hand(mob/user as mob)
	to_chat(usr, SPAN_WARNING("You can't [density ? "open" : "close"] [src] by your own hands only."))
	return

// Proc: open()
// Parameters: 1 (forced - if true, the checks will be skipped)
// Description: Opens the door. Does necessary checks. Automatically closes if autoclose is true
/obj/machinery/door/blast/open(forced = FALSE)
	if ((operating || (stat & BROKEN || stat & NOPOWER)) && !forced)
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
	if ((operating || (stat & BROKEN || stat & NOPOWER)) && !forced)
		return
	force_close()
	crush()


// Proc: repair()
// Parameters: None
// Description: Fully repairs the blast door.
/obj/machinery/door/blast/proc/repair()
	health = maxHealth
	if(stat & BROKEN)
		stat &= ~BROKEN


/obj/machinery/door/blast/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group) return 1
	return ..()



// SUBTYPE: Regular
// Your classical blast door, found almost everywhere.
/obj/machinery/door/blast/regular
	icon_state_open = "pdoor0"
	icon_state_opening = "pdoorc0"
	icon_state_closed = "pdoor1"
	icon_state_closing = "pdoorc1"
	icon_state = "pdoor1"
	maxHealth = 400
	block_air_zones = 1

/obj/machinery/door/blast/regular/open
	icon_state = "pdoor0"
	density = FALSE
	opacity = 0

// SUBTYPE: Shutters
// Nicer looking, and also weaker, shutters. Found in kitchen and similar areas.
/obj/machinery/door/blast/shutters
	icon_state_open = "shutter0"
	icon_state_opening = "shutterc0"
	icon_state_closed = "shutter1"
	icon_state_closing = "shutterc1"
	icon_state = "shutter1"
	layer = SHUTTER_LAYER
	open_layer = SHUTTER_LAYER
	closed_layer = SHUTTER_LAYER

/obj/machinery/door/proc/crush()
	for(var/mob/living/L in get_turf(src))
		if(ishuman(L)) //For humans
			var/mob/living/carbon/human/H = L
			H.adjustBruteLoss(DOOR_CRUSH_DAMAGE)
			H.emote("scream")
			H.Weaken(5)
		else //for simple_animals & borgs
			L.adjustBruteLoss(DOOR_CRUSH_DAMAGE)
