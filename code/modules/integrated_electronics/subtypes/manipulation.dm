/obj/item/integrated_circuit/manipulation
	category_text = "Manipulation"

/obj/item/integrated_circuit/manipulation/weapon_firing
	name = "weapon firing mechanism"
	desc = "This somewhat complicated system allows one to slot in a gun, direct it towards a position, and remotely fire it."
	extended_desc = "The firing mechanism can slot in any energy weapon. \
	The first input pin need to be ref which correspond to target for the gun to fire. \
	The 'fire' activator will cause the mechanism to attempt to fire the weapon at the ref, if possible. Mode will switch between \
	lethal (TRUE) or stun (FALSE) modes. It uses the internal battery of the weapon itself, not the assembly. If you wish to fire the gun while the circuit is in \
	hand, you will need to use an assembly that is a gun."
	complexity = 20
	w_class = ITEM_SIZE_SMALL
	size = 15
	inputs = list(
		"target"       = IC_PINTYPE_REF,
	)
	outputs = list(
		"reference to gun"	= IC_PINTYPE_REF,
		"Weapon mode"		= IC_PINTYPE_STRING
	)
	activators = list(
		"Fire"			= IC_PINTYPE_PULSE_IN,
		"Switch mode"	= IC_PINTYPE_PULSE_IN,
		"On fired"		= IC_PINTYPE_PULSE_OUT
	)
	var/obj/item/gun/energy/installed_gun = null
	spawn_flags = IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_COMBAT
	power_draw_per_use = 0
	ext_cooldown = 1

	demands_object_input = TRUE		// You can put stuff in once the circuit is in assembly,passed down from additem and handled by attackby()

/obj/item/integrated_circuit/manipulation/weapon_firing/Destroy()
	qdel(installed_gun)
	return ..()

/obj/item/integrated_circuit/manipulation/weapon_firing/attackby(obj/item/O, mob/user)
	if(istype(O, /obj/item/gun/energy))
		var/obj/item/gun/energy/gun = O
		if(installed_gun)
			to_chat(user, SPAN("warning", "There's already a weapon installed."))
			return
		user.drop_item(gun)
		gun.forceMove(src)
		installed_gun = gun
		to_chat(user, SPAN("notice", "You slide \the [gun] into the firing mechanism."))
		playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
		if(installed_gun.fire_delay)
			cooldown_per_use = installed_gun.fire_delay * 10
		if(cooldown_per_use < 30)
			cooldown_per_use = 30 //If there's no defined fire delay let's put some
		if(installed_gun.charge_cost)
			power_draw_per_use = installed_gun.charge_cost
		if(length(installed_gun.firemodes))
			var/datum/firemode/fm = installed_gun.firemodes[installed_gun.sel_mode]
			set_pin_data(IC_OUTPUT, 2, fm.name)
		set_pin_data(IC_OUTPUT, 1, WEAKREF(installed_gun))
		push_data()
	else
		..()

/obj/item/integrated_circuit/manipulation/weapon_firing/attack_self(mob/user)
	if(installed_gun)
		installed_gun.forceMove(get_turf(user))
		to_chat(user, SPAN("notice", "You slide \the [installed_gun] out of the firing mechanism."))
		size = initial(size)
		playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
		installed_gun = null
		set_pin_data(IC_OUTPUT, 1, WEAKREF(null))
		push_data()
	else
		to_chat(user, SPAN("notice", "There's no weapon to remove from the mechanism."))

/obj/item/integrated_circuit/manipulation/weapon_firing/do_work(ord)
	if(!installed_gun)
		return
	if(!isturf(assembly.loc) && !(assembly.can_fire_equipped))
		return
	set_pin_data(IC_OUTPUT, 1, WEAKREF(installed_gun))
	push_data()
	if(assembly)
		switch(ord)
			if(1)
				var/atom/target = get_pin_data(IC_INPUT, 1)
				if(!istype(target))
					return
				installed_gun.Fire(target)
				activate_pin(3)
			if(2)
				var/datum/firemode/next_firemode = installed_gun.switch_firemodes()
				set_pin_data(IC_OUTPUT, 2, next_firemode ? next_firemode.name : null)
				push_data()

/obj/item/integrated_circuit/manipulation/locomotion
	name = "locomotion circuit"
	desc = "This allows a machine to move in a given direction."
	icon_state = "locomotion"
	extended_desc = "The circuit accepts a 'dir' number as a direction to move towards.<br>\
	Pulsing the 'step towards dir' activator pin will cause the machine to move one step in that direction, assuming it is not \
	being held, or anchored in some way. It should be noted that the ability to move is dependant on the type of assembly that this circuit inhabits; only drone assemblies can move."
	w_class = ITEM_SIZE_SMALL
	complexity = 10
	max_allowed = 4
	cooldown_per_use = 3
	ext_cooldown = 3 // 0.3 second
	inputs = list("direction" = IC_PINTYPE_DIR)
	outputs = list("obstacle" = IC_PINTYPE_REF)
	activators = list("step towards dir" = IC_PINTYPE_PULSE_IN,"on step"=IC_PINTYPE_PULSE_OUT,"blocked"=IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_MOVEMENT
	power_draw_per_use = 100

/obj/item/integrated_circuit/manipulation/locomotion/do_work()
	..()
	var/turf/T = get_turf(assembly)
	if(T && assembly)
		if(assembly.anchored || !assembly.can_move())
			return
		if(assembly.loc == T) // Check if we're held by someone.  If the loc is the floor, we're not held.
			var/datum/integrated_io/wanted_dir = inputs[1]
			if(isnum_safe(wanted_dir.data))
				if(step(assembly, wanted_dir.data))
					activate_pin(2)
					return
				else
					set_pin_data(IC_OUTPUT, 1, WEAKREF(assembly.collw))
					push_data()
					activate_pin(3)
					return FALSE
	return FALSE

/obj/item/integrated_circuit/manipulation/grenade
	name = "grenade primer"
	desc = "This circuit comes with the ability to attach most types of grenades and prime them at will."
	extended_desc = "The time between priming and detonation is limited to between 1 to 12 seconds, but is optional. \
					If the input is not set, not a number, or a number less than 1, the grenade's built-in timing will be used. \
					Beware: Once primed, there is no aborting the process!"
	icon_state = "grenade"
	complexity = 30
	max_allowed = 1
	cooldown_per_use = 10
	inputs = list("detonation time" = IC_PINTYPE_NUMBER)
	outputs = list("reference to grenade" = IC_PINTYPE_REF)
	activators = list("prime grenade" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_COMBAT
	var/obj/item/grenade/attached_grenade
	var/pre_attached_grenade_type
	demands_object_input = TRUE	// You can put stuff in once the circuit is in assembly,passed down from additem and handled by attackby()

/obj/item/integrated_circuit/manipulation/grenade/Initialize()
	. = ..()
	if(pre_attached_grenade_type)
		var/grenade = new pre_attached_grenade_type(src)
		attach_grenade(grenade)

/obj/item/integrated_circuit/manipulation/grenade/Destroy()
	if(attached_grenade && !attached_grenade.active)
		attached_grenade.forceMove(loc)
	detach_grenade()
	return ..()

/obj/item/integrated_circuit/manipulation/grenade/attackby(obj/item/grenade/G, mob/user)
	if(istype(G))
		if(attached_grenade)
			to_chat(user, SPAN("warning", "There is already a grenade attached!"))
		else if(user.canUnEquip(G))
			user.drop_item(G)
			user.visible_message(SPAN("warning", "\The [user] attaches \a [G] to \the [src]!"), SPAN("notice", "You attach \the [G] to \the [src]."))
			attach_grenade(G)
			// attach_grenade do this, but just to be sure...
			G.forceMove(src)
	else
		return ..()

/obj/item/integrated_circuit/manipulation/grenade/attack_self(mob/user)
	if(attached_grenade)
		user.visible_message(SPAN("warning", "\The [user] removes \an [attached_grenade] from \the [src]!"), SPAN("notice", "You remove \the [attached_grenade] from \the [src]."))
		user.put_in_hands(attached_grenade)
		detach_grenade()
	else
		return ..()

/obj/item/integrated_circuit/manipulation/grenade/do_work()
	if(attached_grenade && !attached_grenade.active)
		var/datum/integrated_io/detonation_time = inputs[1]
		var/dt
		if(isnum_safe(detonation_time.data) && detonation_time.data > 0)
			dt = clamp(detonation_time.data, 1, 12)*10
		else
			dt = 15
		addtimer(CALLBACK(attached_grenade, /obj/item/grenade.proc/activate), dt)
		var/atom/holder = loc
		var/atom/A = get_object()
		A.investigate_log("activated grenade with [src].", INVESTIGATE_CIRCUIT)
		log_and_message_admins("activated a grenade assembly. Last touches: Assembly: [holder.fingerprintslast] Circuit: [fingerprintslast] Grenade: [attached_grenade.fingerprintslast]")

// These procs do not relocate the grenade, that's the callers responsibility
/obj/item/integrated_circuit/manipulation/grenade/proc/attach_grenade(obj/item/grenade/G)
	if(istype(G))
		attached_grenade = G
		G.forceMove(src)
		desc += " \An [attached_grenade] is attached to it!"
		set_pin_data(IC_OUTPUT, 1, WEAKREF(G))

/obj/item/integrated_circuit/manipulation/grenade/proc/detach_grenade()
	if(!attached_grenade)
		return
	attached_grenade.forceMove(get_turf(assembly))
	set_pin_data(IC_OUTPUT, 1, WEAKREF(null))
	attached_grenade = null
	desc = initial(desc)

/obj/item/integrated_circuit/manipulation/plant_module
	name = "plant manipulation module"
	desc = "Used to uproot weeds and harvest/plant trays."
	icon_state = "plant_m"
	extended_desc = "The circuit accepts a reference to a hydroponic tray or an item on an adjacent tile. \
	Mode input (0-harvest, 1-uproot weeds, 2-uproot plant, 3-plant seed) determines action. \
	Harvesting outputs a list of the harvested plants."
	w_class = ITEM_SIZE_TINY
	complexity = 10
	inputs = list("tray" = IC_PINTYPE_REF,"mode" = IC_PINTYPE_NUMBER,"item" = IC_PINTYPE_REF)
	outputs = list()
	activators = list("pulse in" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 50

/obj/item/integrated_circuit/manipulation/plant_module/do_work()
	..()
	var/obj/acting_object = get_object()
	var/obj/OM = get_pin_data_as_type(IC_INPUT, 1, /obj)
	var/obj/O = get_pin_data_as_type(IC_INPUT, 3, /obj/item)

	if(!check_target(OM))
		push_data()
		activate_pin(2)
		return

	if((istype(OM, /obj/effect/plant) && OM.layer == SPACEVINE_LAYER) && check_target(OM) && get_pin_data(IC_INPUT, 2) == 2)
		qdel(OM)
		push_data()
		activate_pin(2)
		return

	var/obj/machinery/portable_atmospherics/hydroponics/TR = OM
	if(istype(TR))
		switch(get_pin_data(IC_INPUT, 2))
			if(0)
				TR.harvest()
				var/atom/A = get_object()
				A.investigate_log("harvested [TR] with [src].", INVESTIGATE_CIRCUIT)
			if(1)
				TR.weedlevel = 0
				TR.update_icon()
				var/atom/A = get_object()
				A.investigate_log("uproot weeds [TR] with [src].", INVESTIGATE_CIRCUIT)
			if(2)
				if(TR.seed) //Could be that they're just using it as a de-weeder
					TR.age = 0
					TR.health = 0
					if(TR.harvest)
						TR.harvest = FALSE //To make sure they can't just put in another seed and insta-harvest it
					TR.sampled = FALSE
					qdel(TR.seed)
					TR.seed = null
				TR.weedlevel = 0 //Has a side effect of cleaning up those nasty weeds
				TR.dead = 0
				TR.update_icon()
				var/atom/A = get_object()
				A.investigate_log("uproot plant [TR] with [src].", INVESTIGATE_CIRCUIT)
			if(3)
				if(!check_target(O))
					activate_pin(2)
					return FALSE

				else if(istype(O, /obj/item/seeds) && !istype(O, /obj/item/seeds/cutting))
					if(TR.seed)
						// TODO: refact this to OnyxBay code
						// if(istype(O, /obj/item/seeds/kudzu))
						// 	investigate_log("had Kudzu planted in it by [acting_object] at [AREACOORD(src)]","kudzu")
						acting_object.visible_message(SPAN("notice", "[acting_object] plants [O]."))
						TR.dead = 0
						TR.seed = O
						TR.age = 1
						TR.health = TR.seed.get_trait(TRAIT_ENDURANCE)
						TR.lastcycle = world.time
						O.forceMove(TR)
						TR.update_icon()
						var/atom/A = get_object()
						A.investigate_log("plant [O] in [TR] with [src].", INVESTIGATE_CIRCUIT)
	activate_pin(2)

/obj/item/integrated_circuit/manipulation/seed_extractor
	name = "seed extractor module"
	desc = "Used to extract seeds from grown produce."
	icon_state = "plant_m"
	extended_desc = "The circuit accepts a reference to a plant item and extracts seeds from it, outputting the results to a list."
	complexity = 8
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list("result" = IC_PINTYPE_LIST)
	activators = list("pulse in" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 50

/obj/item/integrated_circuit/manipulation/seed_extractor/do_work()
	..()
	var/obj/item/reagent_containers/food/snacks/grown/O = get_pin_data_as_type(IC_INPUT, 1, /obj/item/reagent_containers/food/snacks/grown)
	if(!check_target(O))
		push_data()
		activate_pin(2)
		return
	var/list/seed_output = list()
	for(var/i in 1 to rand(1,4))
		var/obj/item/seeds/seeds = new(get_turf(O))
		seeds.seed = plant_controller.seeds[O.plantname]
		seeds.seed_type = plant_controller.seeds[O.seed.name]
		seeds.update_seed()
		seed_output += WEAKREF(seeds)
	var/atom/A = get_object()
	A.investigate_log("extracted seeds from [O] with [src].", INVESTIGATE_CIRCUIT)
	qdel(O)

	if(seed_output.len)
		set_pin_data(IC_OUTPUT, 1, seed_output)
		push_data()
	activate_pin(2)

/obj/item/integrated_circuit/manipulation/grabber
	name = "grabber"
	desc = "A circuit with its own inventory for items. Used to grab and store things."
	icon_state = "grabber"
	extended_desc = "This circuit accepts a reference to an object to be grabbed, and can store up to 10 objects. Modes: 1 to grab, 0 to eject the first object, -1 to eject all objects, and -2 to eject the target. If you throw something from a grabber's inventory with a thrower, the grabber will update its outputs accordingly."
	w_class = ITEM_SIZE_SMALL
	size = 3
	cooldown_per_use = 5
	complexity = 10
	max_allowed = 1
	inputs = list("target" = IC_PINTYPE_REF,"mode" = IC_PINTYPE_NUMBER)
	outputs = list("first" = IC_PINTYPE_REF, "last" = IC_PINTYPE_REF, "amount" = IC_PINTYPE_NUMBER,"contents" = IC_PINTYPE_LIST)
	activators = list("pulse in" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_COMBAT
	power_draw_per_use = 50
	var/max_items = 10

/obj/item/integrated_circuit/manipulation/grabber/do_work()
	//There shouldn't be any target required to eject all contents
	var/mode = get_pin_data(IC_INPUT, 2)
	if(!isnum_safe(mode))
		return
	switch(mode)
		if(-1)
			drop_all()
		if(0)
			if(contents.len)
				drop(contents[1])

	var/obj/item/I = get_object()
	var/obj/item/AM = get_pin_data_as_type(IC_INPUT, 1, /obj/item)
	if(AM && !QDELETED(AM) && !istype(AM, /obj/item/device/electronic_assembly) && \
	!istype(AM, /obj/item/integrated_circuit) && !istype(AM, /obj/item/device/transfer_valve) && !istype(assembly.loc, /obj/item/implant/compressed) \
	&& isturf(assembly.loc))
		if(istype(AM, /obj/item/storage))
			var/obj/item/storage/S = AM
			for(var/obj/item/device/electronic_assembly/EA in S.return_inv())
				S.remove_from_storage(EA, get_turf(I))
		switch(mode)
			if(1)
				grab(AM)
			if(-2)
				drop(AM)
	update_outputs()
	activate_pin(2)

/obj/item/integrated_circuit/manipulation/grabber/proc/grab(obj/item/AM)
	var/max_w_class = assembly.w_class
	if(check_target(AM))
		if(contents.len < max_items && AM.w_class < max_w_class)
			var/atom/A = get_object()
			A.investigate_log("picked up ([AM]) with [src].", INVESTIGATE_CIRCUIT)
			AM.forceMove(src)

/obj/item/integrated_circuit/manipulation/grabber/proc/drop(obj/item/AM, turf/T)
	T = get_turf(assembly)
	if(!(AM in contents))
		return
	var/atom/A = get_object()
	A.investigate_log("dropped ([AM]) from [src].", INVESTIGATE_CIRCUIT)
	AM.forceMove(T)

/obj/item/integrated_circuit/manipulation/grabber/proc/drop_all()
	if(contents.len)
		var/turf/T = get_turf(assembly)
		for(var/obj/item/U in contents)
			drop(U, T)

/obj/item/integrated_circuit/manipulation/grabber/proc/update_outputs()
	if(contents.len)
		set_pin_data(IC_OUTPUT, 1, WEAKREF(contents[1]))
		set_pin_data(IC_OUTPUT, 2, WEAKREF(contents[contents.len]))
	else
		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, null)
	set_pin_data(IC_OUTPUT, 3, contents.len)
	set_pin_data(IC_OUTPUT, 4, contents)
	push_data()

/obj/item/integrated_circuit/manipulation/grabber/attack_self(mob/user)
	drop_all()
	update_outputs()
	push_data()

/obj/item/integrated_circuit/manipulation/claw
	name = "pulling claw"
	desc = "Circuit which can pull things.."
	icon_state = "pull_claw"
	extended_desc = "This circuit accepts a reference to a thing to be pulled."
	w_class = ITEM_SIZE_SMALL
	size = 3
	cooldown_per_use = 5
	max_allowed = 1
	complexity = 10
	inputs = list("target" = IC_PINTYPE_REF,"dir" = IC_PINTYPE_DIR)
	outputs = list("is pulling" = IC_PINTYPE_BOOLEAN)
	activators = list("pulse in" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT,"release" = IC_PINTYPE_PULSE_IN,"pull to dir" = IC_PINTYPE_PULSE_IN, "released" = IC_PINTYPE_PULSE_OUT, "pulled to dir" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 50
	ext_cooldown = 1
	var/atom/movable/pulling

/obj/item/integrated_circuit/manipulation/claw/Destroy()
	stop_pulling()
	return ..()

/obj/item/integrated_circuit/manipulation/claw/do_work(ord)
	var/obj/acting_object = get_object()
	var/atom/movable/to_pull = get_pin_data_as_type(IC_INPUT, 1, /obj/item)
	switch(ord)
		if(1)
			if(can_pull(to_pull))
				if(check_target(to_pull, exclude_contents = TRUE))
					set_pin_data(IC_OUTPUT, 1, TRUE)
					pulling = to_pull
					acting_object.visible_message("\The [acting_object] starts pulling \the [to_pull] around.")
					GLOB.moved_event.register(to_pull, src, .proc/check_pull) //Whenever the target moves, make sure we can still pull it!
					GLOB.destroyed_event.register(to_pull, src, .proc/stop_pulling) //Stop pulling if it gets destroyed
					GLOB.moved_event.register(acting_object, src, .proc/pull) //Make sure we actually pull it.
					var/atom/A = get_object()
					A.investigate_log("started pulling [pulling] with [src].", INVESTIGATE_CIRCUIT)
			push_data()
		if(3)
			if(pulling)
				stop_pulling()
				activate_pin(5)
		if(4)
			if(pulling)
				var/dir = get_pin_data(IC_INPUT, 2)
				var/turf/G =get_step(get_turf(acting_object),dir)
				var/turf/Pl = get_turf(pulling)
				var/turf/F = get_step_towards(Pl,G)
				if(acting_object.Adjacent(F))
					if(!step_towards(pulling, F))
						F = get_step_towards2(Pl,G)
						if(acting_object.Adjacent(F))
							step_towards(pulling, F)
							activate_pin(6)
	activate_pin(2)

/obj/item/integrated_circuit/manipulation/claw/proc/can_pull(obj/I)
	return assembly && I && I.w_class <= assembly.w_class && !I.anchored && I != assembly

/obj/item/integrated_circuit/manipulation/claw/proc/pull()
	var/obj/acting_object = get_object()
	if(isturf(acting_object.loc))
		step_towards(pulling,src)
	else
		stop_pulling()

/obj/item/integrated_circuit/manipulation/claw/proc/check_pull()
	if(get_dist(pulling,src) > 1 && pulling)
		stop_pulling()

/obj/item/integrated_circuit/manipulation/claw/proc/stop_pulling()
	if(pulling)
		var/atom/movable/AM = get_object()
		GLOB.moved_event.unregister(pulling, src)
		GLOB.moved_event.unregister(AM, src)
		AM.visible_message("\The [AM] stops pulling \the [pulling]")
		GLOB.destroyed_event.unregister(pulling, src)
		var/atom/A = get_object()
		A.investigate_log("stopped pulling [pulling] with [src].", INVESTIGATE_CIRCUIT)
		pulling = null
		set_pin_data(IC_OUTPUT, 1, FALSE)
		activate_pin(3)
		push_data()

/obj/item/integrated_circuit/manipulation/claw/Destroy()
	stop_pulling()
	return ..()

/obj/item/integrated_circuit/manipulation/thrower
	name = "thrower"
	desc = "A compact launcher to throw things from inside or nearby tiles."
	extended_desc = "The first and second inputs need to be numbers which correspond to the coordinates to throw objects at relative to the machine itself. \
	The 'fire' activator will cause the mechanism to attempt to throw objects at the coordinates, if possible. Note that the \
	projectile needs to be inside the machine, or on an adjacent tile, and must be medium sized or smaller. The assembly \
	must also be a gun if you wish to throw something while the assembly is in hand."
	complexity = 25
	w_class = ITEM_SIZE_SMALL
	size = 2
	cooldown_per_use = 10
	ext_cooldown = 1
	inputs = list(
		"target X rel"	= IC_PINTYPE_NUMBER,
		"target Y rel"	= IC_PINTYPE_NUMBER,
		"projectile"	= IC_PINTYPE_REF
	)
	outputs = list()
	activators = list(
		"fire" = IC_PINTYPE_PULSE_IN
	)
	spawn_flags = IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_COMBAT
	power_draw_per_use = 50

/obj/item/integrated_circuit/manipulation/thrower/do_work()
	var/target_x_rel = round(get_pin_data(IC_INPUT, 1))
	var/target_y_rel = round(get_pin_data(IC_INPUT, 2))
	var/obj/item/A = get_pin_data_as_type(IC_INPUT, 3, /obj/item)

	if(!A || A.anchored || A.throwing || A == assembly || istype(A, /obj/item/twohanded) || istype(A, /obj/item/device/transfer_valve))
		return

	if(istype(assembly.loc, /obj/item/implant/compressed)) //Prevents the more abusive form of chestgun.
		return

	if(A.w_class > assembly.w_class)
		return

	if(!assembly.can_fire_equipped && ishuman(assembly.loc))
		return

	// Is the target inside the assembly or close to it?
	if(!check_target(A, exclude_components = TRUE))
		return

	var/turf/T = get_turf(get_object())
	if(!T)
		return

	// If the item is in mob's inventory, try to remove it from there.
	if(ismob(A.loc))
		var/mob/living/M = A.loc
		if(!M.unEquip(A))
			return

	// If the item is in a grabber circuit we'll update the grabber's outputs after we've thrown it.
	var/obj/item/integrated_circuit/manipulation/grabber/G = A.loc
	// If the item came from a grabber now we can update the outputs since we've thrown it.
	// Remove item from grabber and updates outputs.
	if(istype(G))
		G.drop(A, get_turf(assembly))
		G.update_outputs()

	var/x_abs = clamp(T.x + target_x_rel, 0, world.maxx)
	var/y_abs = clamp(T.y + target_y_rel, 0, world.maxy)
	var/range = round(clamp(sqrt(target_x_rel*target_x_rel+target_y_rel*target_y_rel),0,8),1)

	assembly.visible_message(SPAN("danger", "[assembly] has thrown [A]!"))
	log_attack("[assembly] \ref[assembly] has thrown [A].")
	A.forceMove(get_turf(assembly))
	A.throw_at(locate(x_abs, y_abs, T.z), range, 3)
	var/atom/AM = get_object()
	AM.investigate_log("threw [A] with [src] at X: [x_abs], y: [y_abs].", INVESTIGATE_CIRCUIT)

/obj/item/integrated_circuit/manipulation/bluespace_rift
	name = "bluespace rift generator"
	desc = "This powerful circuit can open rifts to another realspace location through bluespace."
	extended_desc = "If a valid teleporter console is supplied as input then its selected teleporter beacon will be used as destination point, \
					and if not an undefined destination point is selected. \
					Rift direction is a cardinal value determening in which direction the rift will be opened, relative the local north. \
					A direction value of 0 will open the rift on top of the assembly, and any other non-cardinal values will open the rift in the assembly's current facing."
	icon_state = "bluespace"
	complexity = 100
	size = 3
	cooldown_per_use = 10 SECONDS
	power_draw_per_use = 300
	inputs = list("teleporter", "rift direction")
	outputs = list()
	activators = list("open rift" = IC_PINTYPE_PULSE_IN)
	spawn_flags = IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_LONG_RANGE

	origin_tech = list(TECH_MAGNET = 1, TECH_BLUESPACE = 3)
	matter = list(MATERIAL_STEEL = 10000, MATERIAL_SILVER = 2000, MATERIAL_GOLD = 200)
	var/entropy_value = 1

/obj/item/integrated_circuit/manipulation/bluespace_rift/do_work()

	var/obj/machinery/computer/teleporter/tporter = get_pin_data_as_type(IC_INPUT, 1, /obj/machinery/computer/teleporter)
	var/step_dir = get_pin_data(IC_INPUT, 2)
	var/turf/rift_location = get_turf(src)

	if(!rift_location || !isPlayerLevel(rift_location.z))
		playsound(src, get_sfx("spark"), 50, 1)
		return

	if(isnum_safe(step_dir) && (!step_dir || (step_dir in GLOB.cardinal)))
		rift_location = get_step(rift_location, step_dir) || rift_location

	var/obj/effect/portal/P = new(rift_location)
	if(tporter && tporter.locked && !tporter.one_time_use)
		P.set_target(tporter.locked)
		P.entropy_value += entropy_value
	else
		var/turf/destination = get_random_turf_in_range(src, 10)
		if(destination)
			P.set_target(destination)
			P.entropy_value += entropy_value
			P.failchance = 33
		else
			playsound(src, get_sfx("spark"), 50, 1)
	var/atom/A = get_object()
	A.investigate_log("was opened rift with [src].", INVESTIGATE_CIRCUIT)

// - inserter circuit - //
/obj/item/integrated_circuit/manipulation/inserter
	name = "inserter"
	desc = "A nimble circuit that puts stuff inside a storage like a backpack and can take it out aswell."
	icon_state = "grabber"
	extended_desc = "This circuit accepts a reference to an object to be inserted or extracted depending on mode. If a storage is given for extraction, the extracted item will be put in the new storage. Modes: 1 insert, 0 to extract."
	w_class = ITEM_SIZE_SMALL
	size = 3
	cooldown_per_use = 5
	complexity = 10
	inputs = list("target object" = IC_PINTYPE_REF, "target container" = IC_PINTYPE_REF,"mode" = IC_PINTYPE_NUMBER)
	activators = list("pulse in" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	action_flags = IC_ACTION_COMBAT
	power_draw_per_use = 20

/obj/item/integrated_circuit/manipulation/inserter/do_work()
	//There shouldn't be any target required to eject all contents
	var/obj/item/target_obj = get_pin_data_as_type(IC_INPUT, 1, /obj/item)
	if(!target_obj)
		return

	var/distance = get_dist(get_turf(src),get_turf(target_obj))
	if(distance > 1 || distance < 0)
		return

	var/obj/item/storage/container = get_pin_data_as_type(IC_INPUT, 2, /obj/item/storage)
	var/mode = get_pin_data(IC_INPUT, 3)
	if(assembly && istype(container) && istype(target_obj) && isnum_safe(mode))
		switch(mode)
			if(1)	//Not working
				if(!container.can_be_inserted(target_obj))
					return

				// The circuit is smarter than people that does this
				if(istype(container, /obj/item/storage/backpack/holding) && istype(target_obj, /obj/item/storage/backpack/holding))
					return

				container.handle_item_insertion(target_obj)

			if(2)
				if(target_obj in container.contents)
					container.remove_from_storage(target_obj, get_turf(src))

// Renamer circuit. Renames the assembly it is in. Useful in cooperation with telecomms-based circuits.
/obj/item/integrated_circuit/manipulation/renamer
	name = "renamer"
	desc = "A small circuit that renames the assembly it is in. Useful paired with speech-based circuits."
	icon_state = "internalbm"
	extended_desc = "This circuit accepts a string as input, and can be pulsed to rewrite the current assembly's name with said string. On success, it pulses the default pulse-out wire."
	inputs = list("name" = IC_PINTYPE_STRING)
	outputs = list("current name" = IC_PINTYPE_STRING)
	activators = list("rename" = IC_PINTYPE_PULSE_IN,"get name" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT)
	power_draw_per_use = 1
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/manipulation/renamer/do_work(ord)
	if(!assembly)
		return
	switch(ord)
		if(1)
			var/new_name = sanitizeName(get_pin_data(IC_INPUT, 1), max_length = IC_MAX_NAME_LEN)
			if(new_name)
				var/atom/A = get_object()
				A.investigate_log("was renamed with [src] into [new_name].", INVESTIGATE_CIRCUIT)
				A.SetName(new_name)

		else
			set_pin_data(IC_OUTPUT, 1, assembly.name)
			push_data()

	activate_pin(3)



// - redescribing circuit - //
/obj/item/integrated_circuit/manipulation/redescribe
	name = "redescriber"
	desc = "Takes any string as an input and will set it as the assembly's description."
	extended_desc = "Strings should can be of any length."
	icon_state = "speaker"
	cooldown_per_use = 10
	complexity = 3
	inputs = list("text" = IC_PINTYPE_STRING)
	outputs = list("description" = IC_PINTYPE_STRING)
	activators = list("redescribe" = IC_PINTYPE_PULSE_IN,"get description" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/manipulation/redescribe/do_work(ord)
	if(!assembly)
		return

	switch(ord)
		if(1)
			var/new_desc = sanitize(get_pin_data(IC_INPUT, 1))
			if(new_desc)
				var/atom/A = get_object()
				A.investigate_log("was redescribed with [src] into [new_desc].", INVESTIGATE_CIRCUIT)
				assembly.desc = new_desc

		else
			set_pin_data(IC_OUTPUT, 1, assembly.desc)
			push_data()

	activate_pin(3)

// - repainting circuit - //
/obj/item/integrated_circuit/manipulation/repaint
	name = "auto-repainter"
	desc = "There's an oddly high amount of spraying cans fitted right inside this circuit."
	extended_desc = "Takes a value in hexadecimal and uses it to repaint the assembly it is in."
	cooldown_per_use = 10
	complexity = 3
	inputs = list("color" = IC_PINTYPE_COLOR)
	outputs = list("current color" = IC_PINTYPE_COLOR)
	activators = list("repaint" = IC_PINTYPE_PULSE_IN,"get color" = IC_PINTYPE_PULSE_IN,"pulse out" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH

/obj/item/integrated_circuit/manipulation/repaint/do_work(ord)
	if(!assembly)
		return

	switch(ord)
		if(1)
			var/atom/A = get_object()
			A.investigate_log("was repained with [src].", INVESTIGATE_CIRCUIT)
			assembly.detail_color = get_pin_data(IC_INPUT, 1)
			assembly.update_icon()

		else
			set_pin_data(IC_OUTPUT, 1, assembly.detail_color)
			push_data()

	activate_pin(3)
/obj/item/integrated_circuit/manipulation/hatchlock
	name = "maintenance hatch lock"
	desc = "An electronically controlled lock for the assembly's maintenance hatch."
	extended_desc = "WARNING: If you lock the hatch with no circuitry to reopen it, there is no way to open the hatch again!"
	icon_state = "hatch_lock"

	outputs = list(
		"enabled" = IC_PINTYPE_BOOLEAN
	)
	activators = list(
		"toggle" = IC_PINTYPE_PULSE_IN,
		"on toggle" = IC_PINTYPE_PULSE_OUT
	)

	complexity = 4
	cooldown_per_use = 2 SECOND
	power_draw_per_use = 50
	spawn_flags = IC_SPAWN_DEFAULT
	origin_tech = list(TECH_ENGINEERING = 2)

	var/lock_enabled = FALSE

/obj/item/integrated_circuit/manipulation/hatchlock/do_work(ord)
	if(ord == 1 && assembly)
		lock_enabled = !lock_enabled
		assembly.force_sealed = lock_enabled
		visible_message(
			lock_enabled ? \
			SPAN("notice", "\The [get_object()] whirrs. The screws are now covered.") \
			: \
			SPAN("notice","\The [get_object()] whirrs. The screws are now exposed!")
		)

		var/atom/A = get_object()
		A.investigate_log("The [A] was [lock_enabled ? "locked" : "unlocked"] with [src].", INVESTIGATE_CIRCUIT)

		set_pin_data(IC_OUTPUT, 1, lock_enabled)
		push_data()
		activate_pin(2)
