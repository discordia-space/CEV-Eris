/**
 * Machines in the world, such as computers, pipes, and airlocks.
 *
 *Overview:
 *  Used to create objects that need a per step proc call.  Default definition of 'Initialize()'
 *  stores a reference to src machine in global 'machines list'.  Default definition
 *  of 'Destroy' removes reference to src machine in global 'machines list'.
 *
 *Class Variables:
 *  use_power (num)
 *     current state of auto power use.
 *     Possible Values:
 *        NO_POWER_USE -- no auto power use
 *        IDLE_POWER_USE -- machine is using power at its idle power level
 *        ACTIVE_POWER_USE -- machine is using power at its active power level
 *
 *  active_power_usage (num)
 *     Value for the amount of power to use when in active power mode
 *
 *  idle_power_usage (num)
 *     Value for the amount of power to use when in idle power mode
 *
 *  power_channel (num)
 *     What channel to draw from when drawing power for power mode
 *     Possible Values:
 *        AREA_USAGE_EQUIP:1 -- Equipment Channel
 *        AREA_USAGE_LIGHT:2 -- Lighting Channel
 *        AREA_USAGE_ENVIRON:3 -- Environment Channel
 *
 *  component_parts (list)
 *     A list of component parts of machine used by frame based machines.
 *
 *  stat (bitflag)
 *     Machine status bit flags.
 *     Possible bit flags:
 *        BROKEN -- Machine is broken
 *        NOPOWER -- No power is being supplied to machine.
 *        MAINT -- machine is currently under going maintenance.
 *        EMPED -- temporary broken by EMP pulse
 *
 *Class Procs:
 *  Initialize()
 *
 *  Destroy()
 *
 *	update_mode_power_usage()
 *		updates the static_power_usage var of this machine and makes its static power usage from its area accurate.
 *		called after the idle or active power usage has been changed.
 *
 *	update_power_channel()
 *		updates the static_power_usage var of this machine and makes its static power usage from its area accurate.
 *		called after the power_channel var has been changed or called to change the var itself.
 *
 *	unset_static_power()
 *		completely removes the current static power usage of this machine from its area.
 *		used in the other power updating procs to then readd the correct power usage.
 *
 *
 *     Default definition uses 'use_power', 'power_channel', 'active_power_usage',
 *     'idle_power_usage', 'powered()', and 'use_power()' implement behavior.
 *
 *  powered(chan = -1)         'modules/power/power.dm'
 *     Checks to see if area that contains the object has power available for power
 *     channel given in 'chan'. -1 defaults to power_channel
 *
 *  use_power(amount, chan=-1)   'modules/power/power.dm'
 *     Deducts 'amount' from the power channel 'chan' of the area that contains the object.
 *
 *  power_change()               'modules/power/power.dm'
 *     Called by the area that contains the object when ever that area under goes a
 *     power state change (area runs out of power, or area channel is turned off).
 *
 *  RefreshParts()               'game/machinery/machine.dm'
 *     Called to refresh the variables in the machine that are contributed to by parts
 *     contained in the component_parts list. (example: glass and material amounts for
 *     the autolathe)
 *
 *     Default definition does nothing.
 *
 *  process()                  'game/machinery/machine.dm'
 *     Called by the 'machinery subsystem' once per machinery tick for each machine that is listed in its 'machines' list.
 *
 *  process_atmos()
 *     Called by the 'air subsystem' once per atmos tick for each machine that is listed in its 'atmos_machines' list.
 * Compiled by Aygar
 */
/obj/machinery
	name = "machinery"
	icon = 'icons/obj/stationobjs.dmi'
	w_class = ITEM_SIZE_GARGANTUAN

	price_tag = 100

	var/stat = 0
	var/emagged = 0
	var/use_power = IDLE_POWER_USE
		//0 = dont run the auto
		//1 = run auto, use idle
		//2 = run auto, use active
	var/idle_power_usage = 0
	var/active_power_usage = 0
	var/power_channel = STATIC_EQUIP //STATIC_EQUIP, STATIC_ENVIRON or STATIC_LIGHT
	var/list/component_parts //list of all the parts used to build it, if made from certain kinds of frames.
	var/uid
	var/panel_open = 0
	var/global/gl_uid = 1
	var/interact_offline = 0 // Can the machine be interacted with while de-powered.
	var/obj/item/electronics/circuitboard/circuit
	var/frame_type = FRAME_DEFAULT
	var/health = 100
	var/maxHealth = 100

	var/current_power_usage = 0 // How much power are we currently using, dont change by hand, change power_usage vars and then use set_power_use
	var/area/current_power_area // What area are we powering currently

	var/hacked = FALSE // If this machine has had its access requirements hacked or not


/obj/machinery/Initialize(mapload, d=0)
	. = ..()
	if(d)
		set_dir(d)
	GLOB.machines += src
	InitCircuit()
	START_PROCESSING(SSmachines, src)

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/LateInitialize()
	. = ..()
	power_change()

/obj/machinery/Destroy()
	GLOB.machines.Remove(src)
	STOP_PROCESSING(SSmachines, src)
	QDEL_LIST(component_parts)
	if(contents) // The same for contents.
		for(var/atom/A in contents)
			qdel(A)
	set_power_use(NO_POWER_USE)
	return ..()

/obj/machinery/Process()//If you dont use process or power why are you here
	return PROCESS_KILL

/obj/machinery/emp_act(severity)
	if(use_power && !stat)
		use_power(7500/severity)

		new /obj/effect/overlay/pulse(loc)
	..()

/obj/machinery/proc/take_damage(amount)
	. = health - amount < 0 ? amount - (amount - health) : amount
	health -= amount
	if(health <= 0)
		qdel(src)

/obj/machinery/explosion_act(target_power, explosion_handler/handler)
	take_damage(target_power)
	return 0

/proc/is_operable(obj/machinery/M, mob/user)
	return istype(M) && M.operable()

/obj/machinery/proc/operable(var/additional_flags = 0)
	return !inoperable(additional_flags)

/obj/machinery/proc/inoperable(var/additional_flags = 0)
	return (stat & (NOPOWER|BROKEN|additional_flags))

/obj/machinery/CanUseTopic(mob/user)
	if(stat & BROKEN)
		return STATUS_CLOSE

	if(!interact_offline && (stat & NOPOWER))
		return STATUS_CLOSE

	return ..()

/obj/machinery/CouldUseTopic(mob/user)
	..()
	user.set_machine(src)

/obj/machinery/CouldNotUseTopic(mob/user)
	user.unset_machine()

////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/attack_ai(mob/user as mob)
	if(isrobot(user))
		// For some reason attack_robot doesn't work
		// This is to stop robots from using cameras to remotely control machines.
		if(user.client && user.client.eye == user)
			return src.attack_hand(user)
	else
		return src.attack_hand(user)

/obj/machinery/attack_hand(mob/user as mob)
	if(inoperable(MAINT))
		return 1
	if(user.lying || user.stat)
		return 1
	if(!user.IsAdvancedToolUser())
		to_chat(usr, SPAN_WARNING("You don't have the dexterity to do this!"))
		return 1

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.getBrainLoss() >= 55)
			visible_message(SPAN_WARNING("[H] stares cluelessly at [src]."))
			return 1
		else if(prob(H.getBrainLoss()))
			to_chat(user, SPAN_WARNING("You momentarily forget how to use \the [src]."))
			return 1

	src.add_fingerprint(user)

	return ..()

/obj/machinery/proc/InitCircuit()
	if(!circuit)
		return

	if(ispath(circuit))
		circuit = new circuit

	if(!component_parts)
		component_parts = list()
	if(circuit)
		component_parts += circuit

	for(var/item in circuit.req_components)
		if(item == /obj/item/stack/cable_coil)
			component_parts += new item(null, circuit.req_components[item])
		else
			for(var/j = 1 to circuit.req_components[item])
				component_parts += new item

	RefreshParts()

/obj/machinery/proc/RefreshParts() //Placeholder proc for machines that are built using frames.
	return

/obj/machinery/proc/max_part_rating(var/type) //returns max rating of installed part type or null on error(keep in mind that all parts have to match that raiting).
	if(!type)
		error("max_part_rating() wrong usage")
		return
	var/list/obj/item/stock_parts/parts = list()
	for(var/list/obj/item/stock_parts/P in component_parts)
		if(istype(P, type))
			parts.Add(P)
	if(!parts.len)
		error("max_part_rating() havent found any parts")
		return
	var/rating = 1
	for(var/obj/item/stock_parts/P in parts)
		if(P.rating < rating)
			return rating
		else
			rating = P.rating

	return rating

/obj/machinery/proc/assign_uid()
	uid = gl_uid
	gl_uid++

/obj/machinery/proc/state(var/msg)
	for(var/mob/O in hearers(src, null))
		O.show_message("\icon[src] <span class = 'notice'>[msg]</span>", 2)

/obj/machinery/proc/ping(text="\The [src] pings.")
	state(text, "blue")
	playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)

/obj/machinery/proc/shock(mob/user, prb)
	if(inoperable())
		return 0
	if(!prob(prb))
		return 0
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, src)
	s.start()
	if(electrocute_mob(user, get_area(src), src, 0.7))
		var/area/temp_area = get_area(src)
		if(temp_area)
			var/obj/machinery/power/apc/temp_apc = temp_area.get_apc()

			if(temp_apc && temp_apc.terminal && temp_apc.terminal.powernet)
				temp_apc.terminal.powernet.trigger_warning()
		if(user.stunned)
			return 1
	return 0


//Tool qualities are stored in \code\__defines\tools_and_qualities.dm
/obj/machinery/proc/default_deconstruction(obj/item/I, mob/user)

	var/qualities = list(QUALITY_SCREW_DRIVING)

	if(panel_open && circuit)
		qualities += QUALITY_PRYING

	var/tool_type = I.get_tool_type(user, qualities, src)
	switch(tool_type)
		if(QUALITY_PRYING)
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_HARD, required_stat = STAT_MEC))
				to_chat(user, SPAN_NOTICE("You remove the components of \the [src] with [I]."))
				dismantle()
			return TRUE

		if(QUALITY_SCREW_DRIVING)
			var/used_sound = panel_open ? 'sound/machines/Custom_screwdriveropen.ogg' :  'sound/machines/Custom_screwdriverclose.ogg'
			if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC, instant_finish_tier = 30, forced_sound = used_sound))
				updateUsrDialog()
				panel_open = !panel_open
				to_chat(user, SPAN_NOTICE("You [panel_open ? "open" : "close"] the maintenance hatch of \the [src] with [I]."))
				update_icon()
			return TRUE

		if(ABORT_CHECK)
			return TRUE

	return FALSE //If got no qualities - continue base attackby proc

/obj/machinery/proc/default_part_replacement(obj/item/storage/part_replacer/R, mob/user)
	if(!istype(R))
		return 0
	if(!component_parts)
		return 0
	if(panel_open)
		var/P
		for(var/obj/item/stock_parts/A in component_parts)
			for(var/D in circuit.req_components)
				if(istype(A, D))
					P = D
					break
			for(var/obj/item/stock_parts/B in R.contents)
				if(istype(B, P) && istype(A, P))
					if(B.rating > A.rating)
						R.remove_from_storage(B, src)
						R.handle_item_insertion(A, 1)
						component_parts -= A
						component_parts += B
						B.loc = null
						to_chat(user, SPAN_NOTICE("[A.name] replaced with [B.name]."))
						break
			update_icon()
			RefreshParts()
	else
		to_chat(user, SPAN_NOTICE("Following parts detected in the machine:"))
		for(var/obj/item/C in component_parts)
			to_chat(user, SPAN_NOTICE("    [C.name]"))
	return 1

/obj/machinery/proc/create_frame(type)
	if(type == FRAME_DEFAULT)
		return new /obj/machinery/constructable_frame/machine_frame(loc)
	if(type == FRAME_VERTICAL)
		return new /obj/machinery/constructable_frame/machine_frame/vertical(loc)


/obj/machinery/proc/dismantle()
	on_deconstruction()
	spawn_frame()

	for(var/obj/I in component_parts)
		I.forceMove(loc)
		component_parts -= I
	if(circuit)
		circuit.forceMove(loc)
		circuit.deconstruct(src)
	qdel(src)
	return 1

//called on deconstruction before the final deletion
/obj/machinery/proc/on_deconstruction()
	return

/obj/machinery/proc/spawn_frame(disassembled=TRUE)
	var/obj/machinery/constructable_frame/machine_frame/M = create_frame(frame_type)

	transfer_fingerprints_to(M)
	M.anchored = anchored
	M.set_dir(src.dir)

	M.state = 2
	M.icon_state = "[M.base_state]_1"
	M.update_icon()

	return M


/datum/proc/remove_visual(mob/M)
	return

/datum/proc/apply_visual(mob/M)
	return

/obj/machinery/proc/update_power_use()
	set_power_use(use_power)

// The main proc that controls power usage of a machine, change use_power only with this proc
/obj/machinery/proc/set_power_use(new_use_power)
	if(current_power_usage && current_power_area) // We are tracking the area that is powering us so we can remove power from the right one if we got moved or something
		current_power_area.removeStaticPower(current_power_usage, power_channel)
		current_power_area = null

	current_power_usage = 0
	use_power = new_use_power

	var/area/A = get_area(src)
	if(!A || !anchored || stat & NOPOWER) // Unwrenched machines aren't plugged in, unpowered machines don't use power
		return

	if(use_power == IDLE_POWER_USE && idle_power_usage)
		current_power_area = A
		current_power_usage = idle_power_usage
		current_power_area.addStaticPower(current_power_usage, power_channel)
	else if(use_power == ACTIVE_POWER_USE && active_power_usage)
		current_power_area = A
		current_power_usage = active_power_usage
		current_power_area.addStaticPower(current_power_usage, power_channel)


// Unwrenching = unpluging from a power source
/obj/machinery/wrenched_change()
	update_power_use()

/obj/machinery/get_item_cost(export)
	. = ..()
	for(var/atom/movable/i in component_parts)
		. += SStrade.get_new_cost(i)
