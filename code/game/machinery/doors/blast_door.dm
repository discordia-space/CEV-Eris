// BLAST DOORS
//
// Refactored 27.12.2014 by Atlantis
//
// Blast doors are suposed to be reinforced versions of regular doors. Instead of being manually
// controlled they use buttons or other means of remote control. This is why they cannot be emagged
// as they lack any ID scanning system, they just handle remote control signals. Subtypes have
// different icons, which are defined by set of variables. Subtypes are on bottom of this file.
#define OVERKEY_DOOR_CONSTRUCTION "construction_overlay"
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
	var/icon_sufix = "pdoor"

	var/screws_welded = TRUE
	// used for deconstruction or reconstruction
	var/assembly_step = 0
	var/last_message = 0

	dir = 1
	explosion_resistance = 25

	//Most blast doors are infrequently toggled and sometimes used with regular doors anyways,
	//turning this off prevents awkward zone geometry in places like medbay lobby, for example.
	block_air_zones = 0

	var/_wifi_id
	var/configurable = FALSE
	var/datum/radio_frequency/radio_connection
	var/obj/item/electronics/airlock/electronics

/obj/machinery/door/blast/Initialize()
	. = ..()
	radio_connection = SSradio.add_object(src , BLAST_DOOR_FREQ, RADIO_BLASTDOORS)
	_wifi_id = id
	if(_wifi_id)
		configurable = FALSE
	if(!electronics)
		electronics = new(src)
	AddComponent(/datum/component/overlay_manager)
	/*
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)
	else
		door_control = new(NULL)
	*/

/obj/machinery/door/blast/Destroy()
	SSradio.remove_object(src, BLAST_DOOR_FREQ)
	radio_connection = null
	return ..()

/obj/machinery/door/blast/proc/broadcast_status()
	var/datum/signal/data_packet = new()
	data_packet.frequency = BLAST_DOOR_FREQ
	data_packet.encryption = _wifi_id
	data_packet.data = list()
	data_packet.data["message"] = density ? "DATA_DOOR_CLOSED" : "DATA_DOOR_OPENED"
	radio_connection.post_signal(src, data_packet, RADIO_BLASTDOORS)


/obj/machinery/door/blast/receive_signal(datum/signal/signal, receive_method, receive_param)
	if(!signal)
		return
	if(signal.encryption != _wifi_id)
		return
	/// prevent command spam
	if(last_message > world.timeofday)
		return
	switch(signal.data["message"])
		if("DATA_DOOR_OPENED")
			return
		if("DATA_DOOR_CLOSED")
			return
		if("CMD_DOOR_OPEN")
			open()
			broadcast_status()
		if("CMD_DOOR_CLOSE")
			close()
			broadcast_status()
		if("CMD_DOOR_TOGGLE")
			if(density)
				open()
			else
				close()
			broadcast_status()
	last_message = world.timeofday + 1 SECONDS

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
	var/datum/component/overlay_manager/overlay_manager = GetComponent(/datum/component/overlay_manager)
	if(!overlay_manager)
		return
	if(screws_welded)
		overlay_manager.updateOverlay(OVERKEY_DOOR_CONSTRUCTION, mutable_appearance(icon, "[icon_sufix]_unwelded"))
	else if(panel_open)
		overlay_manager.updateOverlay(OVERKEY_DOOR_CONSTRUCTION, mutable_appearance(icon, "[icon_sufix]_unscrewed"))
	else
		overlay_manager.removeOverlay(OVERKEY_DOOR_CONSTRUCTION)
	if(assembly_step == -3)
		icon_state = "[icon_sufix]_unplated"

#undef OVERKEY_DOOR_CONSTRUCTION


// Proc: force_open()
// Parameters: None
// Description: Opens the door. No checks are done inside this proc.
/obj/machinery/door/blast/proc/force_open()
	src.operating = 1
	flick(icon_state_opening, src)
	playsound(src.loc, 'sound/machines/Custom_blastdooropen.ogg', 65, 0)
	src.density = FALSE
	SEND_SIGNAL(src, COMSIG_DOOR_OPENED, TRUE)
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
	SEND_SIGNAL(src, COMSIG_DOOR_CLOSED, TRUE)
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

/obj/machinery/door/blast/Created(mob/user)
	. = ..()
	assembly_step = -6
	update_icon()

// Proc: attackby()
// Parameters: 2 (C - Item this object was clicked with, user - Mob which clicked this object)
// Description: If we are clicked with crowbar or wielded fire axe, try to manually open the door.
// This only works on broken doors or doors without power. Also allows repair with Plasteel.
/obj/machinery/door/blast/attackby(obj/item/I, mob/user)
	src.add_fingerprint(user)
	if(user.a_intent == I_HURT)
		hit(user, I, FALSE)
		return
	if(QUALITY_PRYING in I.tool_qualities)
		if(user.a_intent == I_DISARM)
			if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_PRYING, FAILCHANCE_VERY_EASY,  required_stat = STAT_ROB))
				if(((stat & NOPOWER) || (stat & BROKEN)) && !( src.operating ))
					force_toggle()
				else
					to_chat(user, SPAN_NOTICE("[src]'s motors resist your effort."))
			return
		else if(assembly_step == -2)
			to_chat(user,  SPAN_NOTICE("You start prying off [src]'s metal plates"))
			if(I.use_tool(user,  src,  WORKTIME_NORMAL, QUALITY_PRYING , FAILCHANCE_VERY_EASY , required_stat = STAT_MEC))
				to_chat(user,  SPAN_NOTICE("You pry off [src]'s metal plates"))
				assembly_step = -3
				update_icon()
			return
		else if(assembly_step == -3)
			to_chat(user,  SPAN_NOTICE("You start prying back in [src]'s metal plates"))
			if(I.use_tool(user,  src,  WORKTIME_NORMAL, QUALITY_PRYING , FAILCHANCE_VERY_EASY , required_stat = STAT_MEC))
				to_chat(user,  SPAN_NOTICE("You pry [src]'s metal plates back in"))
				assembly_step = -2
				update_icon()
			return

	if(QUALITY_PULSING in I.tool_qualities)
		if(!panel_open)
			to_chat(user, SPAN_NOTICE("You need to open [src]'s control panel to modify its radio-signalling"))
		spawn(0)
			var/input = input(user, "Insert a code for this blastdoor between 1 and 1000", "Blastdoor configuration", 1) as num
			if(!Adjacent(user))
				return
			input = clamp(input, 0, 1000)
			_wifi_id = input
			return

	if(QUALITY_WELDING in I.tool_qualities)
		if(screws_welded)
			to_chat(user,  SPAN_NOTICE("You start welding off the metal seals around [src]'s screws"))
			user.show_message(SPAN_NOTICE("[user] starts welding off at the [src]"))
			if(I.use_tool(user, src , WORKTIME_LONG, QUALITY_WELDING, FAILCHANCE_CHALLENGING, required_stat = STAT_MEC))
				to_chat(user,  SPAN_NOTICE("You manage to weld off the metal seals, giving way to remove the screws"))
				user.show_message(SPAN_NOTICE("[user] stops welding off at the [src]"))
				screws_welded = FALSE
				update_icon()
			return
		else if(assembly_step != -6)
			if(panel_open)
				to_chat(user, SPAN_NOTICE("You have to close the panel first to weld the screws shut"))
				return
			to_chat(user, SPAN_NOTICE("You start sealing the screws to [src]'s circuit panel"))
			user.show_message(SPAN_NOTICE("[user] starts sealing [src]'s screws"))
			if(I.use_tool(user, src , WORKTIME_LONG, QUALITY_WELDING, FAILCHANCE_CHALLENGING, required_stat = STAT_MEC))
				to_chat(user,  SPAN_NOTICE("You manage to seal [src]'s screws"))
				user.show_message(SPAN_NOTICE("[user] finishes sealing [src]'s screws"))
				screws_welded = TRUE
				update_icon()
			return
		else
			to_chat(user,  SPAN_NOTICE("You start welding off [src]'s framework"))
			user.show_message(SPAN_NOTICE("[user] starts welding off at the [src]"))
			if(I.use_tool(user, src , WORKTIME_LONG, QUALITY_WELDING, FAILCHANCE_CHALLENGING, required_stat = STAT_MEC))
				to_chat(user,  SPAN_NOTICE("You manage to completly dismantle the [src]"))
				user.show_message(SPAN_NOTICE("[user] dismantles [src]"))
				var/obj/item/stack/material/plasteel/mat = new(null)
				mat.amount = 20
				mat.forceMove(get_turf(user))
				qdel(src)
			return


	if(QUALITY_SCREW_DRIVING in I.tool_qualities)
		if(assembly_step != -5 && !screws_welded)
			if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_SCREW_DRIVING, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
				panel_open = !panel_open
				to_chat(user, SPAN_NOTICE("You screw [panel_open ? "open" : "shut"] [src]'s circuit panel"))
				update_icon()
				return
		else
			to_chat(user, SPAN_NOTICE("You start removing [src]'s door control circuit"))
			if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_SCREW_DRIVING, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
				to_chat(user, SPAN_NOTICE("You remove [src]'s door control circuit"))
				electronics.forceMove(get_turf(user))
				electronics = null
				assembly_step = -6
				return




	if((QUALITY_BOLT_TURNING in I.tool_qualities) && panel_open)
		if(assembly_step == 0)
			to_chat(user, SPAN_NOTICE("You start weakening the [src]'s hydraulic sockets"))
			if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_BOLT_TURNING, FAILCHANCE_EASY, required_stat = STAT_MEC))
				assembly_step = -1
				to_chat(user,  SPAN_NOTICE("You weaken the [src]'s hydraulic socket"))
			return
		else if(assembly_step == -1)
			to_chat(user,  SPAN_NOTICE("You start tightening the [src]'s hydraulic sockets"))
			if(I.use_tool(user, src,  WORKTIME_NORMAL, QUALITY_BOLT_TURNING, FAILCHANCE_EASY, required_stat = STAT_MEC))
				assembly_step = 0
				to_chat(user,  SPAN_NOTICE("You tighten the [src]'s hydraulic socket"))
			return
		else if(assembly_step == -3)
			to_chat(user, SPAN_NOTICE("You start weakening the [src]'s locking bolts"))
			if(I.use_tool(user, src,  WORKTIME_NORMAL, QUALITY_BOLT_TURNING, FAILCHANCE_EASY, required_stat = STAT_MEC))
				assembly_step = -4
				to_chat(user,  SPAN_NOTICE("You weaken the [src]'s locking bolts"))
			return
		else if(assembly_step == -4)
			to_chat(user, SPAN_NOTICE("You start tightening [src]'s locking bolts"))
			if(I.use_tool(user, src,  WORKTIME_NORMAL, QUALITY_BOLT_TURNING, FAILCHANCE_EASY, required_stat = STAT_MEC))
				assembly_step = -3
				to_chat(user,  SPAN_NOTICE("You tighten [src]'s locking bolts"))
			return
	if(QUALITY_CUTTING in I.tool_qualities)
		if(assembly_step == -1)
			to_chat(user, SPAN_NOTICE("You cut off [src]'s hydraulic sockets"))
			if(I.use_tool(user, src,  WORKTIME_NORMAL, QUALITY_CUTTING, FAILCHANCE_EASY, required_stat = STAT_MEC))
				assembly_step = -2
				to_chat(user,  SPAN_NOTICE("You cut off [src]'s hydraulic socket"))
			return
		else if(assembly_step == -2)
			to_chat(user,  SPAN_NOTICE("You start reconnecting [src]'s hydraulic sockets"))
			if(I.use_tool(user, src,  WORKTIME_NORMAL, QUALITY_CUTTING, FAILCHANCE_EASY, required_stat = STAT_MEC))
				assembly_step = -1
				to_chat(user,  SPAN_NOTICE("You reconnect [src]'s hydraulic socket"))
			return
		else if(assembly_step == -4)
			to_chat(user,  SPAN_NOTICE("You start removing [src]'s wiring"))
			if(I.use_tool(user, src,  WORKTIME_NORMAL, QUALITY_CUTTING, FAILCHANCE_EASY, required_stat = STAT_MEC))
				assembly_step = -5
				to_chat(user,  SPAN_NOTICE("You remove [src]'s wiring"))
				var/obj/item/stack/cable_coil/coil = new(null)
				coil.amount = 3
				coil.forceMove(get_turf(user))
			return
	if(istype(I,/obj/item/stack/cable_coil) && I:amount > 3 && assembly_step == -5)
		to_chat(user, SPAN_NOTICE("You start wiring [src]"))
		if(do_after(user, 3 SECONDS, src, TRUE, TRUE) && I:amount > 3)
			to_chat(user,  SPAN_NOTICE("You wire [src]"))
			I:amount -= 3
			assembly_step = -4

	if(istype(I, /obj/item/electronics/airlock) && assembly_step == -6)
		to_chat(user, SPAN_NOTICE("You insert the electronics into [src]"))
		I.forceMove(src)
		electronics = I
		assembly_step = -5

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
	icon_sufix = "shutter"
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
