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
	matter = list(
		MATERIAL_PLASTEEL = 20
	)

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

	//Most blast doors are infrequently toggled and sometimes used with regular doors anyways,
	//turning this off prevents awkward zone geometry in places like medbay lobby, for example.
	block_air_zones = 0

	var/hydraulics_blown = 0
	var/datum/radio_frequency/radio_connection
	var/obj/item/electronics/airlock/electronics
	// here for map compatibility
	var/_wifi_id

/obj/machinery/door/blast/Initialize()
	. = ..()
	radio_connection = SSradio.add_object(src , BLAST_DOOR_FREQ, RADIO_BLASTDOORS)
	if(!electronics)
		electronics = new(src)
		if(_wifi_id)
			electronics.wifi_id = _wifi_id
		else
			electronics.wifi_id = id
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
	data_packet.encryption = electronics.wifi_id
	data_packet.data = list()
	data_packet.data["message"] = density ? "DATA_DOOR_CLOSED" : "DATA_DOOR_OPENED"
	radio_connection.post_signal(src, data_packet, RADIO_BLASTDOORS)


/obj/machinery/door/blast/receive_signal(datum/signal/signal, receive_method, receive_param)
	if(!signal || !electronics)
		return
	if(signal.encryption != electronics.wifi_id)
		return
	// no receiving if no power!!!!
	if(stat & NOPOWER)
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
		if("CMD_DOOR_STATE")
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
	if(!screws_welded)
		var/mutable_appearance/overlay = mutable_appearance(icon, "[icon_sufix]_unwelded")
		overlay.dir = src.dir
		overlay_manager.updateOverlay(OVERKEY_DOOR_CONSTRUCTION, overlay)
	if(panel_open)
		var/mutable_appearance/overlay = mutable_appearance(icon, "[icon_sufix]_unscrewed")
		overlay.dir = src.dir
		overlay_manager.updateOverlay(OVERKEY_DOOR_CONSTRUCTION, overlay)
	else
		overlay_manager.removeOverlay(OVERKEY_DOOR_CONSTRUCTION)
	if(assembly_step <= -3)
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
	panel_open = TRUE
	screws_welded = FALSE
	stat |= BROKEN
	anchored = FALSE
	update_icon()

/obj/machinery/door/blast/examine(mob/user)
	var/description = ""
	description += SPAN_NOTICE("You can try to open this by using a crowbar on disarm intent. \n")
	if(screws_welded)
		description += SPAN_NOTICE("The screws on \the [src] can be welded off. \n")
	else if(!screws_welded && !panel_open)
		description += SPAN_NOTICE("The panel on \the [src] can be opened by screwing, or sealed by welding.\n")
	else if(panel_open)
		description += SPAN_NOTICE("The panel on \the [src] can be closed by screwing.\n")

		switch(assembly_step)
			if(0)
				description += SPAN_NOTICE("You can weaken the hydraulic connections on \the [src] by wrenching.")
			if(-1)
				description += SPAN_NOTICE("You can cut off the hydraulics of \the [src], or tighten them again by wrenching.")
			if(-2)
				description += SPAN_NOTICE("You can pry off the metal coverings of \the [src], or reconnect the hydraulics by using a wirecutter.")
			if(-3)
				description += SPAN_NOTICE("You can remove securing bolts of \the [src] by wrenching, or pry back in the metal coverings.")
			if(-4)
				description += SPAN_NOTICE("You can cut the wirings of \the [src], or secure its bolts back in by wrenching.")
			if(-5)
				description += SPAN_NOTICE("You can now unscrew the door circuit of \the [src], or wire it back.")
			if(-6)
				description += SPAN_NOTICE("You can now fully dismantle \the [src], or insert in a new door circuit.")
	..(user, afterDesc = description)


// Proc: attackby()
// Parameters: 2 (C - Item this object was clicked with, user - Mob which clicked this object)
// Description: If we are clicked with crowbar or wielded fire axe, try to manually open the door.
// This only works on broken doors or doors without power. Also allows repair with Plasteel.
/obj/machinery/door/blast/attackby(obj/item/I, mob/user)
	src.add_fingerprint(user)
	if(user.a_intent == I_HURT)
		hit(user, I, FALSE)
		return
	var/tool_type = I.get_tool_type(user, list(
		QUALITY_PRYING,
		!screws_welded  ? QUALITY_SCREW_DRIVING : null,
		(!panel_open || assembly_step == -6) ? QUALITY_WELDING : null,
		panel_open ? QUALITY_PULSING : null,
		((assembly_step == 0 || assembly_step == -1 || assembly_step == -3 || assembly_step == -4) && panel_open) ? QUALITY_BOLT_TURNING : null,
		((assembly_step == -1 || assembly_step == -2 || assembly_step == -4) && panel_open) ? QUALITY_WIRE_CUTTING : null
	), src)
	switch(tool_type)
		if(QUALITY_PRYING)
			if(user.a_intent == I_DISARM)
				if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_PRYING, FAILCHANCE_VERY_EASY,  required_stat = STAT_ROB))
					if(((stat & NOPOWER) || (stat & BROKEN)) && !( src.operating ))
						force_toggle()
					else
						to_chat(user, SPAN_NOTICE("The motors of \the [src] resist your effort."))
				return
			if(assembly_step == -2)
				if(!density)
					to_chat(user,SPAN_NOTICE("The [src] must be closed for the metal coverings to be pried off."))
					return
				to_chat(user,  SPAN_NOTICE("You start prying off the metal coverings of \the [src]."))
				if(I.use_tool(user,  src,  WORKTIME_NORMAL, QUALITY_PRYING , FAILCHANCE_VERY_EASY , required_stat = STAT_MEC))
					to_chat(user,  SPAN_NOTICE("You pry off the metal coverings of \the [src]."))
					assembly_step = -3
					update_icon()
				return
			if(assembly_step == -3)
				to_chat(user,  SPAN_NOTICE("You start prying back in the metal coverings of \the [src]."))
				if(I.use_tool(user,  src,  WORKTIME_NORMAL, QUALITY_PRYING , FAILCHANCE_VERY_EASY , required_stat = STAT_MEC))
					to_chat(user,  SPAN_NOTICE("You pry the metal coverings of \the [src] back in."))
					assembly_step = -2
					update_icon()
				return
		if(QUALITY_PULSING)
			// detach ourselves from this proc.
			spawn(0)
				if(!electronics)
					to_chat(user, SPAN_NOTICE("There are no electronics inside of \the [src]."))
					return
				var/input = input(user, "Insert a code for this blastdoor between 1 and 1000", "Blastdoor configuration", 1) as num
				if(!Adjacent(user) || !panel_open || !electronics)
					return
				input = clamp(input, 0, 1000)
				electronics.wifi_id = input
				return
		if(QUALITY_WELDING)
			if(screws_welded)
				to_chat(user,  SPAN_NOTICE("You start welding off the metal seals around the screws of \the [src]."))
				user.show_message(SPAN_NOTICE("[user] starts welding off at \the [src]."))
				if(I.use_tool(user, src , WORKTIME_LONG, QUALITY_WELDING, FAILCHANCE_CHALLENGING, required_stat = STAT_MEC))
					to_chat(user,  SPAN_NOTICE("You manage to weld off the metal seals, giving way to remove the screws."))
					user.show_message(SPAN_NOTICE("[user] stops welding off at \the [src]."))
					screws_welded = FALSE
					update_icon()
				return
			if(assembly_step == -6)
				to_chat(user,  SPAN_NOTICE("You start welding off the framework of \the [src]."))
				user.show_message(SPAN_NOTICE("[user] starts welding off at \the [src]."))
				if(I.use_tool(user, src , WORKTIME_LONG, QUALITY_WELDING, FAILCHANCE_CHALLENGING, required_stat = STAT_MEC))
					to_chat(user,  SPAN_NOTICE("You manage to completly dismantle \the [src]."))
					user.show_message(SPAN_NOTICE("[user] dismantles \the [src]."))
					drop_materials(get_turf(user), user)
					qdel(src)
				return
			else
				if(panel_open)
					to_chat(user, SPAN_NOTICE("You have to close the panel first to weld the screws shut."))
					return
				to_chat(user, SPAN_NOTICE("You start sealing the screws to the circuit panel of \the [src]."))
				user.show_message(SPAN_NOTICE("[user] starts sealing the screws of \the [src]."))
				if(I.use_tool(user, src , WORKTIME_LONG, QUALITY_WELDING, FAILCHANCE_CHALLENGING, required_stat = STAT_MEC))
					to_chat(user,  SPAN_NOTICE("You manage to seal the screws of \the [src]."))
					user.show_message(SPAN_NOTICE("[user] finishes sealing the screws of \the [src]."))
					screws_welded = TRUE
					update_icon()
				return
		if(QUALITY_SCREW_DRIVING)
			if(assembly_step == -5 && panel_open)
				spawn(0)
					var/result = show_radial_menu(user, src, list("dc" = image(icon = electronics.icon, icon_state = electronics.icon_state), "sp" = image(icon = 'icons/mob/radial/tools.dmi', icon_state = "screw driving")), tooltips = TRUE, require_near = TRUE)
					switch(result)
						if("dc")
							to_chat(user, SPAN_NOTICE("You start removing the door control circuit of \the [src]."))
							if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_SCREW_DRIVING, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
								to_chat(user, SPAN_NOTICE("You remove the door control circuit of \the [src]."))
								electronics.forceMove(get_turf(user))
								electronics = null
								assembly_step = -6
							return
						if("sp")
							if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_SCREW_DRIVING, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
								panel_open = !panel_open
								to_chat(user, SPAN_NOTICE("You screw [panel_open ? "open" : "shut"] the circuit panel of \the [src]."))
								update_icon()
			else
				if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_SCREW_DRIVING, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					panel_open = !panel_open
					to_chat(user, SPAN_NOTICE("You screw [panel_open ? "open" : "shut"] the circuit panel of \the [src]."))
					update_icon()
				return
		if(QUALITY_BOLT_TURNING)
			switch(assembly_step)
				if(0)
					if(!(stat & NOPOWER) && user.a_intent != I_DISARM)
						to_chat(user , SPAN_DANGER("The [src] must be powered off before the hydraulics can be weakened safely. Switch to disarm intent to do it anyway."))
						return
					to_chat(user, SPAN_NOTICE("You start weakening the hydraulic sockets of \the [src]."))
					var/turning_time
					if(!(stat & NOPOWER))
						turning_time = WORKTIME_LONG
						to_chat(user, SPAN_NOTICE("The pressure inside the hydraulics of \the [src] makes the turning harder, this might be dangerous."))
					else
						turning_time = WORKTIME_NORMAL
					if(I.use_tool(user, src, turning_time, QUALITY_BOLT_TURNING, FAILCHANCE_EASY, required_stat = STAT_MEC))
						assembly_step = -1
						to_chat(user,  SPAN_NOTICE("You weaken the hydraulic sockets of \the [src]."))
						// Uh Oh
						if(!(stat & NOPOWER) && (hydraulics_blown < world.time))
							explosion(get_turf(user), 150, 150, 0, TRUE)
							hydraulics_blown = world.time + 5 MINUTES
							// So we can all laugh
							message_admins("[user] triggered a explosion by unsafely weakening blast door hydraulics, door id = [electronics.wifi_id]")
							log_game("[user] triggered a explosion by unsafely weakening blast door hydraulics, door id = [electronics.wifi_id]")
					return
				if(-1)
					to_chat(user,  SPAN_NOTICE("You start tightening the hydraulic sockets of \the [src]."))
					if(I.use_tool(user, src,  WORKTIME_NORMAL, QUALITY_BOLT_TURNING, FAILCHANCE_EASY, required_stat = STAT_MEC))
						assembly_step = 0
						to_chat(user,  SPAN_NOTICE("You tighten the hydraulic sockets of \the [src]."))
					return
				if(-3)
					to_chat(user, SPAN_NOTICE("You start weakening the locking bolts of \the [src]."))
					if(I.use_tool(user, src,  WORKTIME_NORMAL, QUALITY_BOLT_TURNING, FAILCHANCE_EASY, required_stat = STAT_MEC))
						assembly_step = -4
						to_chat(user,  SPAN_NOTICE("You weaken the locking bolts of \the [src]."))
						anchored = FALSE
					return
				if(-4)
					to_chat(user, SPAN_NOTICE("You start tightening the locking bolts of \the [src]."))
					if(I.use_tool(user, src,  WORKTIME_NORMAL, QUALITY_BOLT_TURNING, FAILCHANCE_EASY, required_stat = STAT_MEC))
						assembly_step = -3
						to_chat(user,  SPAN_NOTICE("You tighten the locking bolts of \the [src]."))
						anchored = TRUE
						// so it updates.
						power_change()
					return
		if(QUALITY_WIRE_CUTTING)
			switch(assembly_step)
				if(-1)
					to_chat(user, SPAN_NOTICE("You start cutting off the hydraulic sockets of \the [src]."))
					if(I.use_tool(user, src,  WORKTIME_NORMAL, QUALITY_WIRE_CUTTING, FAILCHANCE_EASY, required_stat = STAT_MEC))
						assembly_step = -2
						to_chat(user,  SPAN_NOTICE("You cut off the hydraulic sockets of \the [src], rendering it unfunctional."))
						stat |= BROKEN
					return
				if(-2)
					to_chat(user,  SPAN_NOTICE("You start reconnecting the hydraulic sockets of \the [src]."))
					if(I.use_tool(user, src,  WORKTIME_NORMAL, QUALITY_WIRE_CUTTING, FAILCHANCE_EASY, required_stat = STAT_MEC))
						assembly_step = -1
						to_chat(user,  SPAN_NOTICE("You reconnect the hydraulic sockets, making the door work again."))
						if(stat & BROKEN)
							stat &= ~BROKEN
					return
				if(-4)
					to_chat(user,  SPAN_NOTICE("You start removing the wirings of \the [src]."))
					if(I.use_tool(user, src,  WORKTIME_NORMAL, QUALITY_WIRE_CUTTING, FAILCHANCE_EASY, required_stat = STAT_MEC))
						assembly_step = -5
						to_chat(user,  SPAN_NOTICE("You remove the wirings of \the [src]."))
						var/obj/item/stack/cable_coil/coil = new(null)
						coil.setAmount(3)

						coil.forceMove(get_turf(user))
					return

	if(istype(I,/obj/item/stack/cable_coil) && assembly_step == -5)
		var/obj/item/stack/cable_coil/cable = I
		if(cable.can_use(3))
			to_chat(user, SPAN_NOTICE("You start wiring \the [src]."))
			if(do_after(user, 3 SECONDS, src, TRUE, TRUE))
				to_chat(user,  SPAN_NOTICE("You wire \the [src]."))
				if(cable.use(3))
					assembly_step = -4
				else
					to_chat(user, SPAN_NOTICE("You fail to wire \the [src]."))

	if(istype(I, /obj/item/electronics/airlock) && assembly_step == -6)
		to_chat(user, SPAN_NOTICE("You insert the electronics into \the [src]."))
		user.drop_from_inventory(I, src)
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
	matter = list(
		MATERIAL_PLASTEEL = 5
	)

/obj/machinery/door/blast/shutters/holey
	icon_state_open = "lshutter0"
	icon_state_opening = "lshutterc0"
	icon_state_closed = "lshutter1"
	icon_state_closing = "lshutterc1"
	icon_sufix = "lshutter"
	icon_state = "lshutter1"
	matter = list(
		MATERIAL_PLASTEEL = 4
	)
	opacity = 0
	visible = 0

/obj/machinery/door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASSGRILLE))
		return !opacity
	return ..()

/obj/machinery/door/proc/crush()
	for(var/mob/living/L in get_turf(src))
		if(ishuman(L)) //For humans
			var/mob/living/carbon/human/H = L
			H.adjustBruteLoss(DOOR_CRUSH_DAMAGE)
			H.emote("scream")
			H.Weaken(5)
		else //for simple_animals & borgs
			L.adjustBruteLoss(DOOR_CRUSH_DAMAGE)
