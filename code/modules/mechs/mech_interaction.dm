/mob/living/exosuit/MouseDrop_T(atom/dropping, mob/user)
	if(istype(dropping, /obj/machinery/portable_atmospherics/canister))
		body.MouseDrop_T(dropping, user)
	else if(user != src && user == dropping)
		if(body)
			if(user.mob_size >= body.min_pilot_size && user.mob_size <= body.max_pilot_size)
				if(enter(user)) return 0
			else
				to_chat(user, SPAN_WARNING("You cannot pilot a exosuit of this size."))
				return 0
	else . = ..()

/mob/living/exosuit/MouseDrop(mob/living/carbon/human/over_object) //going from assumption none of previous options are relevant to exosuit
	if(body)
		if(!body.MouseDrop(over_object))
			return ..()

/mob/living/exosuit/proc/arms_action_delay()
	return arms ? arms.action_delay : 15

/mob/living/exosuit/setClickCooldown(timeout)
	. = ..()
	for(var/mob/p in pilots)
		p.setClickCooldown(timeout)

/mob/living/exosuit/ClickOn(var/atom/A, var/params, var/mob/user = usr)
	if(!user || incapacitated() || user.incapacitated())
		return

	if(!loc) return
	var/adj = A.Adjacent(src) // Why in the fuck isn't Adjacent() commutative.

	var/modifiers = params2list(params)
	if(modifiers["shift"])
		A.examine(user)
		return

	if(modifiers["ctrl"])
		if(selected_system)
			if(selected_system == A)
				selected_system.CtrlClick(user)
				setClickCooldown(3)
			return

	if(!(user in pilots) && user != src)
		return

	// Are we facing the target? Skipped if we're targetting ourselves
	if(src != A && A.loc != src && !(get_dir(src, A) & dir))
		return

	if(!selected_system)
		if(arms)
			if(!get_cell()?.checked_use(arms.power_use * CELLRATE))
				to_chat(user, power == MECH_POWER_ON ? SPAN_WARNING("Error: Power levels insufficient.") :  SPAN_WARNING("\The [src] is powered off."))
				return
			if(!arms.motivator || !arms.motivator.is_functional())
				to_chat(user, SPAN_WARNING("Your motivators are damaged! You can't use your manipulators!"))
				setClickCooldown(15)
				return
		else
			to_chat(user, SPAN_WARNING("\The [src] has no manipulators!"))
			setClickCooldown(3)
			return

	var/obj/item/cell/cell = get_cell()
	if(!cell)
		to_chat(user, SPAN_WARNING("Error: Power cell missing."))
		setClickCooldown(3)
		return

	if(istype(selected_system, /obj/item/mech_equipment) && !check_equipment_software(selected_system))
		to_chat(user, SPAN_WARNING("Error: No control software was found for [selected_system]."))
		setClickCooldown(3)
		return

	// User is not necessarily the exosuit, or the same person, so update intent.
	if(user != src)
		a_intent = user.a_intent
		targeted_organ = user.targeted_organ

	// You may attack the target with your exosuit FIST if you're malfunctioning.
	var/failed = FALSE
	if(emp_damage > EMP_ATTACK_DISRUPT && prob(emp_damage*2))
		to_chat(user, SPAN_DANGER("The wiring sparks as you attempt to control the exosuit!"))
		failed = TRUE

	if(!failed && selected_system)
		if(src == A)
			setClickCooldown(5)
			return selected_system.attack_self(user)
		// Slip up and attack yourself maybe.
		failed = FALSE
		if(emp_damage > EMP_MOVE_DISRUPT && prob(10))
			failed = TRUE

		if(failed)
			var/list/other_atoms = orange(1, A)
			A = null
			while(LAZYLEN(other_atoms))
				var/atom/picked = pick_n_take(other_atoms)
				if(istype(picked) && picked.simulated)
					A = picked
					break
			if(!A)
				A = src
			adj = A.Adjacent(src)

		var/resolved
		if(adj)
			resolved = selected_system.resolve_attackby(A, user, params)

		if(!resolved && A && selected_system)
			selected_system.afterattack(A,user,adj,params)

		//Interferes with mining
		if(istype(selected_system, /obj/item/mech_equipment/drill))
			return

		// Mech equipment subtypes can add further click delays
		var/extra_delay = selected_system.equipment_delay
		setClickCooldown(arms_action_delay() + extra_delay)

		return

	if(A == src)
		setClickCooldown(5)
		return attack_self(user)
	else if(adj && arms)
		setClickCooldown(arms_action_delay())
		playsound(src.loc, arms.punch_sound, 45 + 25 * (arms.melee_damage / 50), -1)
		if(user.a_intent == I_HURT)
			return A.attack_generic(src, arms.melee_damage, "attacked")
		else if(user.a_intent == I_DISARM && arms.can_force_doors)
			if(istype(A, /obj/machinery/door/airlock))
				var/obj/machinery/door/airlock/door = A
				if(!door.locked)
					to_chat(user, SPAN_NOTICE("You start forcing \the [door] open!"))
					visible_message(SPAN_WARNING("\The [src] starts forcing \the [door] open!"))
					playsound(src, 'sound/machines/airlock_creaking.ogg', 100, 1, 5,5)
					if(do_after(user, 3 SECONDS, A, FALSE))
						door.open(TRUE)
			return
		else
			return A.attackby(arms, user, params)

/// Checks the mech for places to store the ore.
/mob/living/exosuit/proc/getOreCarrier()
	for(var/hardpoint in hardpoints)
		if(istype(hardpoints[hardpoint], /obj/item/mech_equipment/clamp))
			var/obj/item/mech_equipment/clamp/holder = hardpoints[hardpoint]
			var/ore_box = locate(/obj/structure/ore_box) in holder.carrying
			if(ore_box)
				return ore_box
	return null



/mob/living/exosuit/proc/set_hardpoint(var/hardpoint_tag)
	clear_selected_hardpoint()
	if(hardpoints[hardpoint_tag])
		// Set the new system.
		selected_system = hardpoints[hardpoint_tag]
		selected_hardpoint = hardpoint_tag
		selected_system.on_select()
		return TRUE // The element calling this proc will set its own icon.
	return FALSE

/mob/living/exosuit/proc/clear_selected_hardpoint()

	if(selected_hardpoint)
		for(var/hardpoint in hardpoints)
			if(hardpoint != selected_hardpoint) continue
			var/obj/screen/movable/exosuit/hardpoint/H = HUDneed[hardpoint]
			if(istype(H))
				H.icon_state = "hardpoint"
				break
		var/obj/item/mech_equipment/systm = selected_system
		selected_system = null
		// done after for the full-auto firemode to properly update.
		systm.on_unselect()
		selected_hardpoint = null

/mob/living/exosuit/get_active_hand()
	var/obj/item/mech_equipment/ME = selected_system
	if(istype(ME))
		return ME.get_effective_obj()
	return ..()

/mob/living/exosuit/proc/check_enter(var/mob/user)
	if(!user || user.incapacitated())	return FALSE
	if(!user.Adjacent(src)) 			return FALSE
	if(issilicon(user))					return FALSE
	if (user.buckled)
		to_chat(user, SPAN_WARNING("You cannot enter a mech while buckled, unbuckle first."))
		return FALSE
	if(body && body.has_hatch)
		if(hatch_locked)
			to_chat(user, SPAN_WARNING("The [body.hatch_descriptor] is locked."))
			return FALSE
		if(hatch_closed)
			to_chat(user, SPAN_WARNING("The [body.hatch_descriptor] is closed."))
			return FALSE
		if(LAZYLEN(pilots) >= LAZYLEN(body.pilot_positions))
			to_chat(user, SPAN_WARNING("\The [src] is occupied to capacity."))
			return FALSE
	if(ishuman(user) && body?.armor_restrictions)	//wear_suit only exists on humans; only bother with checking if the chassis forbids it
		var/mob/living/carbon/human/enterer = user
		if(enterer.wear_suit && enterer.wear_suit)	//If the user is wearing anything in their suit slot
			to_chat(user, SPAN_WARNING("You must remove your [enterer.wear_suit] to fit inside."))
			return FALSE
	return TRUE

/mob/living/exosuit/proc/enter(var/mob/user)
	if(!check_enter(user))
		return
	to_chat(user, SPAN_NOTICE("You start climbing into \the [src]..."))
	if(!do_after(user, body.climb_time) || !check_enter(user)) //allows for specialized cockpits for rapid entry/exit, or slower for more armored ones
		return
	to_chat(user, SPAN_NOTICE("You climb into \the [src]."))

	user.drop_r_hand()
	user.drop_l_hand()
	user.forceMove(src)
	LAZYOR(pilots, user)
	sync_access()
	playsound(get_turf(src), 'sound/machines/windowdoor.ogg', 50, 1)
	user.playsound_local(null, 'sound/mechs/nominal.ogg', 50)
	//LAZYDISTINCTADD(user.additional_vision_handlers, src)
	update_pilots()
	return TRUE

/mob/living/exosuit/proc/sync_access()
	access_card.access = saved_access.Copy()
	if(sync_access)
		for(var/mob/pilot in pilots)
			access_card.access |= pilot.GetAccess()
			to_chat(pilot, SPAN_NOTICE("Security access permissions synchronized."))

/mob/living/exosuit/proc/eject(mob/living/user, silent, mech_death)
	if(!user || !(user in src.contents))
		return

	if(body && body.has_hatch)
		if(hatch_closed)
			if(hatch_locked)
				if(!silent) to_chat(user, SPAN_WARNING("The [body.hatch_descriptor] is locked."))
				return
			var/obj/screen/movable/exosuit/toggle/hatch_open/H = HUDneed["hatch open"]
			if(H && istype(H))
				H.toggled()
			if(!silent)
				to_chat(user, SPAN_NOTICE("You open the hatch and climb out of \the [src]."))
		else if(!silent)
			to_chat(user, SPAN_NOTICE("You climb out of \the [src]."))
	else if(!silent)
		to_chat(user, SPAN_NOTICE("You climb out of \the [src]."))

	user.forceMove(get_turf(src))

	if(mech_death)
		user.apply_damages(30, 30)	//Give them bruises and burns
		//Mobs process every 2 seconds but both handle_statuses() and handle_status_effects() decrements by 1
		user.AdjustWeakened(4)

	//LAZYREMOVE(user.additional_vision_handlers, src)
	if(user in pilots)
		a_intent = I_HURT
		LAZYREMOVE(pilots, user)
		update_pilots()
	if(user.client)
		update_mech_hud_4(user)
		user.client.eye = user.client.mob
		user.client.perspective = MOB_PERSPECTIVE
	clear_selected_hardpoint()
	return 1

/mob/living/exosuit/attackby(obj/item/I, mob/living/user)

	if(user.a_intent != I_HURT && istype(I, /obj/item/mech_equipment))
		if(hardpoints_locked)
			to_chat(user, SPAN_WARNING("Hardpoint system access is disabled."))
			return

		var/obj/item/mech_equipment/realThing = I
		if(realThing.owner)
			return

		var/free_hardpoints = list()
		for(var/hardpoint in hardpoints)
			if(hardpoints[hardpoint] == null)
				free_hardpoints += hardpoint

		var/to_place = input("Where would you like to install it?") as null|anything in (realThing.restricted_hardpoints & free_hardpoints)
		if(install_system(I, to_place, user))
			return
		to_chat(user, SPAN_WARNING("\The [I] could not be installed in that hardpoint."))
		return

	/// Gun reloading handling
	if(istype(I, /obj/item/ammo_magazine)||  istype(I, /obj/item/ammo_casing))
		if(!maintenance_protocols)
			to_chat(user, SPAN_NOTICE("\The [src] needs to be in maintenance mode to reload its guns!"))
			return
		var/list/obj/item/mech_equipment/mounted_system/ballistic/loadable_guns = list()
		for(var/hardpoint in hardpoints)
			if(istype(hardpoints[hardpoint], /obj/item/mech_equipment/mounted_system/ballistic))
				// store name and location so its easy to choose
				loadable_guns["[hardpoint] - [hardpoints[hardpoint]]"] = hardpoints[hardpoint]
		var/obj/item/mech_equipment/mounted_system/ballistic/chosen = null
		if(length(loadable_guns) > 1)
			chosen = input("Select mech gun to reload.") as null|anything in loadable_guns
			chosen = loadable_guns[chosen]
		else
			chosen = loadable_guns[loadable_guns[1]]
		if(chosen)
			switch(chosen.loadMagazine(I,user))
				if(-1)
					to_chat(user, SPAN_NOTICE("\The [chosen] does not accept this type of magazine."))
				if(0)
					to_chat(user, SPAN_NOTICE("\The [chosen] has no slots left in its ammunition storage."))
				if(1)
					to_chat(user, SPAN_NOTICE("You load \the [I] into \the [chosen]."))
				if(2)
					to_chat(user, SPAN_NOTICE("You partially reload one of the existing ammo magazines inside of \the [chosen]."))

	/// Medical mender handling
	if(istype(I, /obj/item/stack/medical/advanced/bruise_pack))
		var/list/choices = list()
		for(var/hardpoint in hardpoints)
			if(istype(hardpoints[hardpoint], /obj/item/mech_equipment/auto_mender))
				var/obj/item/mech_equipment/auto_mender/mend = hardpoints[hardpoint]
				choices["[hardpoint] - [mend.trauma_charges_stored]/[mend.trauma_storage_max] charges"] = mend
		var/obj/item/mech_equipment/auto_mender/choice = null
		if(!length(choices))
			return
		if(length(choices) == 1)
			choice = choices[choices[1]]
		else
			var/chosenMender = input("Select mech mender to refill") as null|anything in choices
			if(chosenMender)
				choice = choices[chosenMender]
		if(choice)
			choice.attackby(I, user)
		return

	/// Plasma generator handling
	if(istype(I, /obj/item/stack/material/plasma))
		var/list/choices = list()
		for(var/hardpoint in hardpoints)
			if(istype(hardpoints[hardpoint], /obj/item/mech_equipment/power_generator/fueled/plasma))
				var/obj/item/mech_equipment/power_generator/fueled/plasma/gen = hardpoints[hardpoint]
				choices["[hardpoint] - [gen.fuel_amount]/[gen.fuel_max]"] = gen
		var/obj/item/mech_equipment/power_generator/fueled/plasma/chosen = null
		if(!length(choices))
			return
		if(length(choices)==1)
			chosen = choices[choices[1]]
		else
			var/chosenGen = input("Select generator to refill") as null|anything in choices
			if(chosenGen)
				chosen = choices[chosenGen]
		if(chosen)
			chosen.attackby(I, user)
		return

	/// REAGENT INSERTION HANDLING
	/// Double negation to turn into 0/1 format since if its more than 1 it doesn't count as true.
	if(I.is_drainable())
		if(!maintenance_protocols)
			to_chat(user, SPAN_NOTICE("\The [src] needs to be in maintenance mode for you to refill its equipment!"))
			return
		var/list/choices = list()
		for(var/hardpoint in hardpoints)
			/// welding fuel generator
			if(istype(hardpoints[hardpoint], /obj/item/mech_equipment/power_generator/fueled/welding))
				var/obj/item/mech_equipment/power_generator/fueled/welding/gen = hardpoints[hardpoint]
				choices["[hardpoint]-[gen.name] [gen.fuel_amount]/[gen.fuel_max]"] = gen
			/// chemical sprayer
			if(istype(hardpoints[hardpoint], /obj/item/mech_equipment/mounted_system/sprayer))
				var/obj/item/mech_equipment/mounted_system/system = hardpoints[hardpoint]
				var/obj/item/reagent_containers/spray/chemsprayer/sprayer = system.holding
				choices["[hardpoint]-[system.name] [sprayer.reagents.total_volume]/[sprayer.reagents.maximum_volume]"] = system
		var/obj/item/mech_equipment/chosen = null
		if(!length(choices))
			return
		if(length(choices)==1)
			chosen = choices[choices[1]]
		else
			var/chosenAcceptor = input("Select equipment to refill") as null|anything in choices
			if(chosenAcceptor)
				chosen = choices[chosenAcceptor]
		if(chosen)
			chosen.attackby(I, user)
		return


	else if(attack_tool(I, user))
		return
	// we use BP_CHEST cause we dont need to convert targeted organ to mech format def zoning
	else if(user.a_intent != I_HELP && (!hatch_closed || (body && !body.has_hatch) )&& get_dir(user, src) == reverse_dir[dir] && get_mob() && !(user in pilots) && user.targeted_organ == BP_CHEST)
		var/mob/living/target = get_mob()
		target.attackby(I, user)
		return
	return ..()

/mob/living/exosuit/proc/attack_tool(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/cell))
		if(!maintenance_protocols)
			to_chat(user, SPAN_WARNING("The power cell bay is locked while maintenance protocols are disabled."))
			return TRUE
		if(!body)
			to_chat(user, SPAN_NOTICE("\The [src] has no slot for a battery to be installed unto!"))
			return
		var/obj/item/cell/cell = body.cell
		if(cell)
			to_chat(user, SPAN_WARNING("\The [src] already has [cell] installed!"))
			return TRUE

		to_chat(user, SPAN_NOTICE("You start inserting [I] into \the [src]."))
		if(do_mob(user, src, 30) && body.insert_item(I, user))
			body.cell = I

		return TRUE

	else if(istype(I, /obj/item/electronics/circuitboard/exosystem))
		if(!maintenance_protocols)
			to_chat(user, SPAN_WARNING("The software upload bay is locked while maintenance protocols are disabled."))
			return TRUE

		if(!body.computer)
			to_chat(user, SPAN_WARNING("The control computer is missing!"))
			return TRUE

		body.computer.install_software(I, user)
		return TRUE

	else if(istype(I, /obj/item/device/kit/paint))
		user.visible_message(
			SPAN_NOTICE("\The [user] opens \the [I] and spends some quality time customising \the [src]."),
			SPAN_NOTICE("You open \the [I] and spends some quality time customising \the [src].")
			)
		var/obj/item/device/kit/paint/P = I
		SetName(P.new_name)
		desc = P.new_desc
		for(var/obj/item/mech_component/comp in list(arms, legs, head, body))
			comp.decal = P.new_icon
		if(P.new_icon_file)
			icon = P.new_icon_file
		update_icon()
		P.use(1, user)
		return TRUE

	else if(istype(I, /obj/item/device/robotanalyzer))
		to_chat(user, SPAN_NOTICE("Diagnostic Report for \the [src]:"))
		for(var/obj/item/mech_component/MC in list(arms, legs, body, head))
			if(MC)
				MC.return_diagnostics(user)
		return

	else if(istype(I, /obj/item/stack/nanopaste))
		var/obj/item/stack/nanopaste/paste = I
		if(paste.amount < 2)
			to_chat(user, SPAN_WARNING("You need at least 2 nanite segments in order to repair damage."))
			return TRUE
		var/obj/item/mech_component/mc = get_targeted_part(user)
		if(!repairing_check(mc, user))
			return TRUE
		if(mc.total_damage <= 0)
			to_chat(user, SPAN_WARNING("Damage on this part is already repaired."))
			return TRUE
		to_chat(user, SPAN_NOTICE("You start feeding nanite segments into \the [src]'s nanite port."))
		if(do_mob(user, src, 30) && paste.use(2))
			mc.repair_burn_damage(15)
			mc.repair_brute_damage(15)
/*
Use this if you turn on armor ablation for mechs:

	else if(istype(I, material.stack_type))
		var/obj/item/mech_component/mc = get_targeted_part(user)
		var/obj/item/stack/material/fix_mat = I
		if(mc.cur_armor < mc.max_armor)
			if(mc.new_armor >= mc.max_armor)
				to_chat(user, SPAN_WARNING("The armor plating has already been replaced, you need to weld it to the frame."))
				return TRUE
			var/mats_required = mc.max_armor - mc.cur_armor
			if(mats_required > fix_mat.amount)
				mc.new_armor += fix_mat.amount
				fix_mat.use(fix_mat.amount)
				to_chat(user, SPAN_WARNING("You replace some of the damaged armor plating, but not all. You need [mats_required-fix_mat.amount] more sheets of [fix_mat]."))
				return TRUE
			to_chat(user, SPAN_NOTICE("You replace the damaged armor plating. Now you need to weld it to the frame."))
			mc.new_armor = mc.max_armor
			fix_mat.use(mats_required)
*/
	else if(istype(I, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/coil = I
		if(coil.amount < 5)
			to_chat(user, SPAN_WARNING("You need at least 5 pieces of cable in order to replace wiring."))
			return TRUE
		var/obj/item/mech_component/mc = get_targeted_part(user)
		if(!repairing_check(mc, user))
			return TRUE
		if(mc.total_damage > mc.max_damage/2)
			to_chat(user, SPAN_WARNING("The damage is too severe to repair when the exosuit is active."))
			return
		if(mc.total_damage <= 0)
			to_chat(user, SPAN_WARNING("Damage on this part is already repaired."))
			return TRUE
		to_chat(user, SPAN_NOTICE("You start replacing wiring in \the [src]."))
		if(do_mob(user, src, 30) && coil.use(5))
			mc.repair_burn_damage(15)

	// crossbow bolt handling
	else if(istype(I, /obj/item/stack/material))
		var/list/choices = list()
		for(var/hardpoint in hardpoints)
			if(istype(hardpoints[hardpoint], /obj/item/mech_equipment/mounted_system/crossbow))
				var/obj/item/mech_equipment/mounted_system/crossbow/cross = hardpoints[hardpoint]
				var/obj/item/gun/energy/crossbow_mech/CM = cross.holding
				choices["[hardpoint] - [CM.shots_amount]/3"] = cross
		var/obj/item/mech_equipment/mounted_system/crossbow/cross = null
		if(!length(choices))
			return
		if(length(choices)==1)
			cross = choices[choices[1]]
		else
			var/chosenCross = input("Select crossbow to reload") as null|anything in choices
			if(chosenCross)
				cross = choices[chosenCross]
		if(cross)
			cross.attackby(I, user)
		return

	var/list/usable_qualities = list(QUALITY_PULSING, QUALITY_BOLT_TURNING, QUALITY_PRYING, QUALITY_SCREW_DRIVING, QUALITY_WELDING)

	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	switch(tool_type)
		if(QUALITY_PULSING)
			if(user.a_intent == I_HELP)
				if(hardpoints_locked)
					to_chat(user, SPAN_WARNING("Hardpoint system access is disabled."))
					return TRUE

				var/list/parts = list()
				for(var/hardpoint in hardpoints)
					if(hardpoints[hardpoint])
						parts += hardpoint

				if(!length(parts))
					to_chat(user, SPAN_WARNING("\The [src] has no hardpoint systems to remove."))
					return TRUE

				var/to_remove = input("Which component would you like to remove") as null|anything in parts
				remove_system(to_remove, user)
				return TRUE
			else
				if(hatch_locked)
					to_chat(user, SPAN_WARNING("You start hacking \the [src]'s hatch locking mechanisms."))
					if(do_after(user, 20 SECONDS, src, TRUE))
						to_chat(user, SPAN_NOTICE("You hack [src]'s hatch locking. It is now unlocked."))
						toggle_hatch_lock()
						return TRUE


		if(QUALITY_BOLT_TURNING)
			if(!maintenance_protocols)
				to_chat(user, SPAN_WARNING("The securing bolts are not visible while maintenance protocols are disabled."))
				return TRUE

			if(length(pilots))
				to_chat(user, SPAN_WARNING("You cannot dismantle \the [src] with a pilot still inside!"))
				return TRUE

			visible_message(SPAN_WARNING("\The [user] begins unwrenching the securing bolts holding \the [src] together."))
			if(!do_mob(user, src, 60) || !maintenance_protocols || length(pilots))
				return TRUE
			visible_message(SPAN_NOTICE("\The [user] loosens and removes the securing bolts, dismantling \the [src]."))
			dismantle()
			return TRUE

		if(QUALITY_WELDING)
			if(!maintenance_protocols)
				to_chat(user, SPAN_WARNING("The securing bolts are not visible while maintenance protocols are disabled."))
				return TRUE
			var/obj/item/mech_component/mc = get_targeted_part(user)
			if(!repairing_check(mc, user))
				return TRUE
			if(mc.total_damage > mc.max_damage/2)
				to_chat(user, SPAN_WARNING("The damage is too severe to repair when the exosuit is active."))
				return
			if(mc.brute_damage <= 0)
				to_chat(user, SPAN_WARNING("Brute damage on this part is already repaired."))
				return TRUE
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
				visible_message(SPAN_WARNING("\The [mc] has been repaired by [user]!"),"You hear welding.")
				mc.repair_brute_damage(15)
				return TRUE
				/*
				Uncomment this block and put the if line just inside if(I.use_tool) if you decide to use armor ablation for mechs

				if(mc.cur_armor >= mc.max_armor)
				else
					visible_message(SPAN_WARNING("Fresh armor has been welded\the [mc]'s frame by [user]!"),"You hear welding.")
					mc.cur_armor = min(mc.max_armor, mc.cur_armor + mc.new_armor)
					mc.new_armor = 0
					return TRUE
					*/

		if(QUALITY_PRYING)
			if(!body)
				to_chat(user,  SPAN_NOTICE("\The [src] has no body to pry out a cell from!"))
				return
			var/obj/item/cell/cell = body.cell
			if(cell)
				if(!maintenance_protocols)
					to_chat(user, SPAN_WARNING("The power cell bay is locked while maintenance protocols are disabled."))
					return TRUE
			to_chat(user, SPAN_NOTICE("You start removing [cell] from \the [src]."))
			if(do_mob(user, src, 30) && cell == body.cell && body.eject_item(cell, user))
				power = MECH_POWER_OFF
				body.cell = null
				return

		if(QUALITY_SCREW_DRIVING)
			if(length(body.computer?.contents))
				if(!maintenance_protocols)
					to_chat(user, SPAN_WARNING("The software upload bay is locked while maintenance protocols are disabled."))
					return
				var/obj/item/board = body.computer.contents[length(body.computer.contents)]
				to_chat(user, SPAN_NOTICE("You start removing [board] from \the [src]."))
				if(do_mob(user, src, 30) && (board in body.computer) && body.computer?.eject_item(board, user))
					body.computer.update_software()
					return

		if(ABORT_CHECK)
			return

/// Used by hatch lock UI button
/mob/living/exosuit/proc/toggle_hatch_lock()
	if(hatch_locked)
		hatch_locked = FALSE
	else
		if(body && body.total_damage >= body.max_damage)
			return FALSE
		hatch_locked = TRUE
	return hatch_locked

/// Used by hatch toggle mech UI button
/mob/living/exosuit/proc/toggle_hatch()
	if(hatch_locked)
		return hatch_closed
	else
		hatch_closed = !hatch_closed
		return hatch_closed

/// Used by camera toglge UI button
/mob/living/exosuit/proc/toggle_sensors()
	if(head)
		if(!head.active_sensors)
			if(get_cell()?.drain_power(0,0,head.power_use))
				head.active_sensors = TRUE
				return TRUE
			return FALSE
		else
			head.active_sensors = FALSE
			return FALSE
	return FALSE

/mob/living/exosuit/attack_hand(mob/living/user)
	// Drag the pilot out if possible.
	if(user.a_intent == I_GRAB)
		for(var/obj/item/mech_equipment/towing_hook/towing in contents)
			if(towing.currentlyTowing)
				to_chat(user, SPAN_NOTICE("You start removing \the [towing.currentlyTowing] from \the [src]'s towing hook."))
				if(do_after(user, 3 SECONDS, src, TRUE))
					to_chat(user, SPAN_NOTICE("You remove \the [towing.currentlyTowing] from \the [src]'s towing hook."))
					towing.UnregisterSignal(towing.currentlyTowing,list(COMSIG_MOVABLE_MOVED,COMSIG_ATTEMPT_PULLING))
					towing.currentlyTowing = null
					return
		for(var/obj/item/mech_equipment/forklifting_system/fork in contents)
			if(fork.currentlyLifting)
				to_chat(user, SPAN_NOTICE("You start removing \the [fork.currentlyLifting] from \the [src]'s forklift."))
				if(do_after(user, 3 SECONDS ,src , TRUE))
					to_chat(user, SPAN_NOTICE("You remove \the [fork.currentlyLifting] from \the [src]'s forklift!"))
					fork.ejectLifting(get_turf(user))
					return

	if(user.a_intent == I_HURT)
		if(!LAZYLEN(pilots))
			to_chat(user, SPAN_WARNING("There is nobody inside \the [src]."))
		else if(!hatch_closed || (body && !body.has_hatch))
			var/mob/pilot = pick(pilots)
			user.visible_message(SPAN_DANGER("\The [user] is trying to pull \the [pilot] out of \the [src]!"))
			if(do_after(user, 30) && user.Adjacent(src) && (pilot in pilots) && !hatch_closed)
				user.visible_message(SPAN_DANGER("\The [user] drags \the [pilot] out of \the [src]!"))
				eject(pilot, silent=1)
		return

	if(body && body.has_hatch)
		// Otherwise toggle the hatch.
		if(hatch_locked)
			to_chat(user, SPAN_WARNING("The [body.hatch_descriptor] is locked."))
			playsound(src,'sound/mechs/doorlocked.ogg', 50, 1)
			return
		if(body && body.total_damage >= body.max_damage)
			to_chat(user, SPAN_NOTICE("The chest of \the [src] is far too damaged. The hatch hinges are stuck!"))
			return

		hatch_closed = !hatch_closed
		playsound(src, 'sound/machines/Custom_closetopen.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("You [hatch_closed ? "close" : "open"] the [body.hatch_descriptor]."))
		var/obj/screen/movable/exosuit/toggle/hatch_open/H = HUDneed["hatch open"]
		if(H && istype(H)) H.update_icon()
		update_icon()
		return

/mob/living/exosuit/proc/attack_self(mob/user)
	return visible_message("\The [src] pokes itself.")

/mob/living/exosuit/proc/rename(mob/user)
	if(user != src && !(user in pilots))
		return
	var/new_name = sanitize(input("Enter a new exosuit designation.", "Exosuit Name") as text|null, max_length = MAX_NAME_LEN)
	if(!new_name || new_name == name || (user != src && !(user in pilots)))
		return
	SetName(new_name)
	to_chat(user, SPAN_NOTICE("You have redesignated this exosuit as \the [name]."))

/mob/living/exosuit/proc/get_targeted_part(mob/user)
	var/obj/item/mech_component/mc = null
	switch(user.targeted_organ)
		if(BP_R_ARM, BP_L_ARM)
			mc = arms
		if(BP_HEAD)
			mc = head
		if(BP_CHEST, BP_GROIN)
			mc = body
		if(BP_R_LEG, BP_L_LEG)
			mc = legs
	return mc

/mob/living/exosuit/proc/repairing_check(obj/item/mech_component/mc, mob/user)
	if(!mc || !mc.can_be_repaired())
		to_chat(user, SPAN_WARNING("This part is completely destroyed, you cannot repair it."))
		return FALSE
	if(mc.total_damage == 0)
		to_chat(user, SPAN_WARNING("This part is already fully repaired."))
		return FALSE
	if(!maintenance_protocols)
		to_chat(user, SPAN_WARNING("You cannot repair \the [src] while maintenance protocols are disabled."))
		return FALSE
	return TRUE
