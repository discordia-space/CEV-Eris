/obj/item/mech_equipment/clamp
	name = "mounted clamp"
	desc = "A large, heavy industrial cargo loading clamp."
	icon_state = "mech_clamp"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	var/carrying_capacity = 5
	var/list/obj/carrying = list()


/obj/item/mech_equipment/clamp/resolve_attackby(atom/A, mob/user, click_params)
	if(isturf(A))
		var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in owner
		if(ore_box)
			for(var/obj/item/ore/i in A)
				i.Move(ore_box)
	if(istype(A, /obj/structure/closet) || istype(A, /obj/item/storage) || istype(A, /obj/structure/scrap_cube) && owner)
		return FALSE
	. = ..()


/obj/item/mech_equipment/clamp/afterattack(atom/target, mob/living/user, inrange, params)
	if(!inrange) return
	. = ..()

	if(.)
		if(length(carrying) >= carrying_capacity)
			to_chat(user, SPAN_WARNING("\The [src] is fully loaded!"))
			return

		if (!inrange)
			to_chat(user, SPAN_NOTICE("You must be adjacent to [target] to use the hydraulic clamp."))
		else
			if(isobj(target))
				var/obj/O = target
				var/datum/component/buckling/buckle = O.GetComponent(/datum/component/buckling)
				if(buckle && buckle.buckled)
					return
				if(locate(/mob/living) in O)
					to_chat(user, SPAN_WARNING("You can't load living things into the cargo compartment."))
					return

				if(istype(target, /obj/structure/scrap_spawner))
					owner.visible_message(SPAN_NOTICE("\The [owner] begins compressing \the [O] with \the [src]."))
					playsound(src, 'sound/mechs/hydraulic.ogg', 50, 1)
					if(do_after(owner, 20, O, 0, 1))
						if(istype(O, /obj/structure/scrap_spawner))
							var/obj/structure/scrap_spawner/S = O
							S.make_cube()
							owner.visible_message(SPAN_NOTICE("\The [owner] compresses \the [O] into a cube with \the [src]."))
					return

				if(O.anchored)
					to_chat(user, SPAN_WARNING("[target] is firmly secured."))
					return

				owner.visible_message(SPAN_NOTICE("\The [owner] begins loading \the [O]."))
				playsound(src, 'sound/mechs/hydraulic.ogg', 50, 1)
				if(do_after(owner, 20, O, 0, 1))
					if(buckle && buckle.buckled)
						return
					if(O in carrying  || O.anchored || (locate(/mob/living) in O)) //Repeat checks
						return
					if(length(carrying) >= carrying_capacity)
						to_chat(user, SPAN_WARNING("\The [src] is fully loaded!"))
						return
					O.forceMove(src)
					carrying += O
					owner.visible_message(SPAN_NOTICE("\The [owner] loads \the [O] into its cargo compartment."))

			//attacking - Cannot be carrying something, cause then your clamp would be full
			else if(isliving(target))
				var/mob/living/M = target
				if(user.a_intent == I_HURT)
					admin_attack_log(user, M, "attempted to clamp [M] with [src] ", "Was subject to a clamping attempt.", ", using \a [src], attempted to clamp")
					owner.setClickCooldown(owner.arms ? owner.arms.action_delay * 3 : 30) //This is an inefficient use of your powers
//				if(prob(33))
//					owner.visible_message(SPAN_DANGER("[owner] swings its [src] in a wide arc at [target] but misses completely!"))
//					return
					M.attack_generic(owner, (owner.arms ? owner.arms.melee_damage * 1.5 : 0), "slammed") //Honestly you should not be able to do this without hands, but still
					M.throw_at(get_edge_target_turf(owner ,owner.dir),5, 2)
					to_chat(user, SPAN_WARNING("You slam [target] with [src.name]."))
					owner.visible_message(SPAN_DANGER("[owner] slams [target] with the hydraulic clamp."))
				else
					step_away(M, owner)
					to_chat(user, "You push [target] out of the way.")
					owner.visible_message("[owner] pushes [target] out of the way.")


/obj/item/mech_equipment/clamp/attack_self(var/mob/user)
	. = ..()
	if(.)
		drop_carrying(user, TRUE)

/obj/item/mech_equipment/clamp/CtrlClick(mob/user)
	if(owner)
		drop_carrying(user, FALSE)
	else
		..()

/obj/item/mech_equipment/clamp/proc/drop_carrying(var/mob/user, var/choose_object)
	if(!length(carrying))
		to_chat(user, SPAN_WARNING("You are not carrying anything in \the [src]."))
		return
	var/obj/chosen_obj = carrying[1]
	if(choose_object)
		chosen_obj = input(user, "Choose an object to set down.", "Clamp Claw") as null|anything in carrying
	if(!chosen_obj)
		return/*
	if(chosen_obj.density)
		for(var/atom/A in get_turf(src))
			if(A != owner && A.density && !(A.atom_flags & ATOM_FLAG_CHECKS_BORDER))
				to_chat(user, SPAN_WARNING("\The [A] blocks you from putting down \the [chosen_obj]."))
				return */

	owner.visible_message(SPAN_NOTICE("\The [owner] unloads \the [chosen_obj]."))
	playsound(src, 'sound/mechs/hydraulic.ogg', 50, 1)
	chosen_obj.forceMove(get_turf(src))
	carrying -= chosen_obj

/obj/item/mech_equipment/clamp/get_hardpoint_status_value()
	if(length(carrying) > 1)
		return length(carrying)/carrying_capacity
	return null

/obj/item/mech_equipment/clamp/get_hardpoint_maptext()
	if(length(carrying) == 1)
		return carrying[1].name
	else if(length(carrying) > 1)
		return "Multiple"
	. = ..()

/obj/item/mech_equipment/clamp/uninstalled()
	if(length(carrying))
		for(var/obj/load in carrying)
			var/turf/location = get_turf(src)
			var/list/turfs = location.AdjacentTurfsSpace()
			if(load.density)
				if(turfs.len > 0)
					location = pick(turfs)
					turfs -= location
				else
					load.dropInto(location)
					load.throw_at_random(FALSE, rand(2,4), 4)
					location = null
			if(location)
				load.dropInto(location)
			carrying -= load
	. = ..()

// A lot of this is copied from floodlights.
/obj/item/mech_equipment/light
	name = "floodlight"
	desc = "An exosuit-mounted light."
	icon_state = "mech_floodlight"
	item_state = "mech_floodlight"
	restricted_hardpoints = list(HARDPOINT_HEAD, HARDPOINT_RIGHT_SHOULDER, HARDPOINT_LEFT_SHOULDER)

	var/on = FALSE
	var/l_max_bright = 1.2
	var/l_inner_range = 1
	var/l_outer_range = 9
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)

/obj/item/mech_equipment/light/attack_self(var/mob/user)
	. = ..()
	if(.)
		on = !on
		to_chat(user, "You switch \the [src] [on ? "on" : "off"].")
		update_icon()
		owner.update_icon()
		playsound(src, 'sound/mechs/industrial_floodlight.ogg', 50, 1)

/obj/item/mech_equipment/light/update_icon()
	. = ..()
	if(on)
		icon_state = "[initial(icon_state)]-on"
		//set_light(l_max_bright, l_inner_range, l_outer_range)
		set_light(l_outer_range, l_max_bright, "#ffffff")
	else
		icon_state = "[initial(icon_state)]"
		//set_light(0, 0)
		set_light(0, 0)

	if(owner && (owner.hardpoints[HARDPOINT_HEAD] == src))
		mech_layer = MECH_INTERMEDIATE_LAYER
	else mech_layer = initial(mech_layer)

/obj/item/mech_equipment/thrusters
	name = "exosuit thrusters"
	desc = "An industrial-sized jetpack for mechs."
	icon_state = "mech_jet"
	item_state = "mech_jet"
	restricted_hardpoints = list(HARDPOINT_BACK)
	matter = list(MATERIAL_PLATINUM = 4, MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 3)
	mech_layer = MECH_INTERMEDIATE_LAYER

	var/on = FALSE
	/// Needed for Z-travel methods
	var/obj/item/tank/jetpack/infinite/jetpack_fluff
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 4)

/obj/item/mech_equipment/thrusters/Initialize()
	. = ..()
	jetpack_fluff = new /obj/item/tank/jetpack/infinite(src)
	// needs to be on for it to be used by any Vertical travel method (VTM)
	jetpack_fluff.on = TRUE
	// so it doesnt show when vertically traveling as INFINITE DEBUF JETPACK
	jetpack_fluff.name = src.name
	update_icon()

/obj/item/mech_equipment/thrusters/attack_self(mob/user)
	. = ..()
	if(.)
		on = !on
		to_chat(user, "You switch \the [src] [on ? "on" : "off"].")
		update_icon()
		owner.update_icon()

/obj/item/mech_equipment/thrusters/update_icon()
	. = ..()
	if(on)
		icon_state = "[initial(icon_state)]_on"
	else
		icon_state = "[initial(icon_state)]_off"

#define CATAPULT_SINGLE 1
#define CATAPULT_AREA   2

/obj/item/mech_equipment/catapult
	name = "gravitational catapult"
	desc = "An exosuit-mounted gravitational catapult."
	icon_state = "mech_wormhole"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	var/mode = CATAPULT_SINGLE
	var/atom/movable/locked
	equipment_delay = 30 //Stunlocks are not ideal
	origin_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 4, TECH_MAGNET = 4)

/obj/item/mech_equipment/catapult/get_hardpoint_maptext()
	var/string
	if(locked)
		string = locked.name + " - "
	if(mode == 1)
		string += "Pull"
	else string += "Push"
	return string


/obj/item/mech_equipment/catapult/attack_self(var/mob/user)
	. = ..()
	if(.)
		mode = mode == CATAPULT_SINGLE ? CATAPULT_AREA : CATAPULT_SINGLE
		to_chat(user, SPAN_NOTICE("You set \the [src] to [mode == CATAPULT_SINGLE ? "single" : "multi"]-target mode."))
		update_icon()


/obj/item/mech_equipment/catapult/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	. = ..()
	if(.)

		switch(mode)
			if(CATAPULT_SINGLE)
				if(!locked)
					var/atom/movable/AM = target
					if(!istype(AM) || AM.anchored || !AM.simulated)
						to_chat(user, SPAN_NOTICE("Unable to lock on [target]."))
						return
					locked = AM
					to_chat(user, SPAN_NOTICE("Locked on [AM]."))
					return
				else if(target != locked)
					if(locked in view(owner))
						locked.throw_at(target, 14, 1.5, owner)
						log_and_message_admins("used [src] to throw [locked] at [target].", user, owner.loc)
						locked = null

						var/obj/item/cell/C = owner.get_cell()
						if(istype(C))
							C.use(active_power_use * CELLRATE)

					else
						locked = null
						to_chat(user, SPAN_NOTICE("Lock on [locked] disengaged."))
			if(CATAPULT_AREA)

				var/list/atoms = list()
				if(isturf(target))
					atoms = range(target,3)
				else
					atoms = orange(target,3)
				for(var/atom/movable/A in atoms)
					if(A.anchored || !A.simulated) continue
					var/dist = 5-get_dist(A,target)
					A.throw_at(get_edge_target_turf(A,get_dir(target, A)),dist,0.7)


				log_and_message_admins("used [src]'s area throw on [target].", user, owner.loc)
				var/obj/item/cell/C = owner.get_cell()
				if(istype(C))
					C.use(active_power_use * CELLRATE * 2) //bit more expensive to throw all



#undef CATAPULT_SINGLE
#undef CATAPULT_AREA


/obj/item/material/drill_head
	var/durability = 0
	name = "drill head"
	desc = "A replaceable drill head usually used in exosuit drills."
	icon_state = "exodrillhead"
	default_material = MATERIAL_STEEL

/obj/item/material/drill_head/Initialize()
	. = ..()

	//durability = 3 * (material ? material.integrity : 1)

/obj/item/material/drill_head/Created(var/creator)
	ApplyDurability()

/obj/item/material/drill_head/steel/New(var/newloc)
	..(newloc,MATERIAL_STEEL)
	ApplyDurability()

/obj/item/material/drill_head/plasteel/New(var/newloc)
	..(newloc,MATERIAL_PLASTEEL)
	ApplyDurability()

/obj/item/material/drill_head/diamond/New(var/newloc)
	..(newloc,MATERIAL_DIAMOND)
	ApplyDurability()


/obj/item/material/drill_head/verb/ApplyDurability()
	durability = 3 * (material ? material.integrity : 1)

/obj/item/mech_equipment/drill
	name = "drill"
	desc = "This is the drill that'll pierce the heavens!"
	icon_state = "mech_drill"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	equipment_delay = 10

	//Drill can have a head
	var/obj/item/material/drill_head/drill_head
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)



/obj/item/mech_equipment/drill/Initialize()
	. = ..()
	drill_head = new /obj/item/material/drill_head(src, "steel")//You start with a basic steel head
	drill_head.ApplyDurability()

/obj/item/mech_equipment/drill/attack_self(var/mob/user)
	. = ..()
	if(.)
		if(drill_head)
			owner.visible_message(SPAN_WARNING("[owner] revs the [drill_head], menancingly."))
			playsound(src, 'sound/weapons/circsawhit.ogg', 50, 1)


/obj/item/mech_equipment/drill/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	. = ..()
	if(.)


		if (!inrange)
			to_chat(user, SPAN_NOTICE("You must be adjacent to [target] to use the mounted drill."))
		else
			if(isobj(target))
				var/obj/target_obj = target
				if(target_obj.unacidable)
					return
			if(istype(target,/obj/item/material/drill_head))
				var/obj/item/material/drill_head/DH = target
				if(drill_head)
					owner.visible_message(SPAN_NOTICE("\The [owner] detaches the [drill_head] mounted on the [src]."))
					drill_head.forceMove(owner.loc)
				DH.forceMove(src)
				drill_head = DH
				owner.visible_message(SPAN_NOTICE("\The [owner] mounts the [drill_head] on the [src]."))
				return

			if(drill_head == null)
				to_chat(user, SPAN_WARNING("Your drill doesn't have a head!"))
				return

			var/obj/item/cell/C = owner.get_cell()
			if(istype(C))
				C.use(active_power_use * CELLRATE)
			playsound(src, 'sound/mechs/mechdrill.ogg', 50, 1)
			owner.visible_message(SPAN_DANGER("\The [owner] starts to drill \the [target]"), SPAN_WARNING("You hear a large drill."))
			var/T = target.loc

			//Better materials = faster drill! //
			var/delay = 20
			switch (drill_head.material.hardness) // It's either default (steel), plasteel or diamond
				if(80) delay = 10
				if(100) delay = 5
			owner.setClickCooldown(delay) //Don't spamclick!
			if(do_after(owner, delay, target) && drill_head)
				if(src == owner.selected_system)
					if(drill_head.durability <= 0)
						drill_head.shatter()
						drill_head = null
						return
					if(istype(target, /turf/simulated/wall))
						var/turf/simulated/wall/W = target
						if(max(W.material.hardness, W.reinf_material ? W.reinf_material.hardness : 0) > drill_head.material.hardness)
							to_chat(user, SPAN_WARNING("\The [target] is too hard to drill through with this drill head."))
							return
						target.explosion_act(100, null)
						drill_head.durability -= 1
						log_and_message_admins("used [src] on the wall [W].", user, owner.loc)
					else if(istype(target, /turf/simulated/mineral))
						for(var/turf/simulated/mineral/M in range(target,1))
							if(get_dir(owner,M)&owner.dir)
								M.GetDrilled()
								drill_head.durability -= 1
					else if(istype(target, /turf/simulated/floor/asteroid))
						for(var/turf/simulated/floor/asteroid/M in range(target,1))
							if(get_dir(owner,M)&owner.dir)
								M.gets_dug()
								drill_head.durability -= 0.1
					else if(target.loc == T)
						target.explosion_act(200, null)
						drill_head.durability -= 1
						log_and_message_admins("[src] used to drill [target].", user, owner.loc)




					if(owner.hardpoints.len) //if this isn't true the drill should not be working to be fair
						for(var/hardpoint in owner.hardpoints)
							var/obj/item/I = owner.hardpoints[hardpoint]
							if(!istype(I))
								continue
							var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in I //clamps work, but anythin that contains an ore crate internally is valid
							if(ore_box)
								for(var/obj/item/ore/ore in range(T,1))
									if(get_dir(owner,ore)&owner.dir)
										ore.Move(ore_box)
								to_chat(user, SPAN_NOTICE("The drill automatically loaded the ore into the ore box."))
					playsound(src, 'sound/weapons/rapidslice.ogg', 50, 1)

			else
				to_chat(user, "You must stay still while the drill is engaged!")


			return 1

/obj/item/mech_equipment/mounted_system/extinguisher
	icon_state = "mech_exting"
	holding_type = /obj/item/extinguisher/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)

/obj/item/extinguisher/mech
	max_water = 4000 //Good is gooder
	icon_state = "mech_exting"
	overlaylist = list()

/obj/item/extinguisher/mech/get_hardpoint_maptext()
	return "[reagents.total_volume]/[max_water]"

/obj/item/extinguisher/mech/get_hardpoint_status_value()
	return reagents.total_volume/max_water

/obj/item/mech_equipment/power_generator
	name = "debug power generator"
	desc = "If you see this tell coders to fix code!"
	icon_state = "mech_power"
	restricted_hardpoints = list(HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	equipment_flags = EQUIPFLAG_PRETICK
	spawn_blacklisted = TRUE
	var/obj/item/cell/internal_cell
	/// 50 power per mech life tick , adjust for cell RATE
	var/generation_rate = 50

/obj/item/mech_equipment/power_generator/Initialize()
	. = ..()
	internal_cell = new /obj/item/cell/small
	internal_cell.matter = list()

/obj/item/mech_equipment/power_generator/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(istype(I, /obj/item/cell) && !internal_cell)
		user.drop_from_inventory(I)
		I.forceMove(src)
		internal_cell = I
		to_chat(user, SPAN_NOTICE("You replace [src]'s cell!"))
		return

/obj/item/mech_equipment/power_generator/pretick()
	var/ungiven_power = internal_cell?.give(generation_rate)
	if(owner && internal_cell)
		var/obj/item/cell/batt = owner.get_cell(TRUE)
		if(batt && batt != internal_cell)
			batt.give(internal_cell.use(batt.maxcharge - batt.charge))

	return ungiven_power

/obj/item/mech_equipment/power_generator/fueled
	name = "fueled debug power generator"
	// YES WE NEED VISCONTENTS FOR THE ANIMATIONS
	equipment_flags = EQUIPFLAG_UPDTMOVE | EQUIPFLAG_PRETICK
	var/fuel_amount = 0
	var/fuel_max = 1000
	var/fuel_usage_per_tick = 5
	var/mode = 0
	var/datum/repeating_sound/sound_loop = null
	var/obj/visual_bluff = null
	spawn_blacklisted = TRUE

/obj/item/mech_equipment/power_generator/fueled/Initialize()
	. = ..()
	visual_bluff = new(src)
	visual_bluff.forceMove(src)
	visual_bluff.icon = MECH_WEAPON_OVERLAYS_ICON
	visual_bluff.layer = MECH_ABOVE_LAYER

/obj/item/mech_equipment/power_generator/fueled/pretick()
	// for when we arențt on
	if(!mode)
		sound_loop?.stop()
		return
	if(fuel_amount > fuel_usage_per_tick)
		. = ..()
		/// if we had a extremely minimal use
		if(. > generation_rate - generation_rate * 0.01 || . == null)
			return
		else
			fuel_amount -= fuel_usage_per_tick
			if(QDELETED(sound_loop))
				sound_loop = new(_interval = 2 SECONDS, duration = 10 SECONDS, interval_variance = 0,
				_source = owner, _soundin = 'sound/mechs/mech_generator.ogg' , _vol = 25 * mode, _vary = 0, _extrarange = mode * 3,
				_falloff = 0, _is_global = FALSE, _use_pressure = TRUE)
			else
				// extend it artificially.
				sound_loop.end_time = world.time + 10 SECONDS
				sound_loop.vol = mode * 25
				sound_loop.extrarange = mode * 3

/obj/item/mech_equipment/power_generator/fueled/installed(mob/living/exosuit/_owner, hardpoint)
	. = ..()
	_owner.tickers.Add(src)
	_owner.vis_contents.Add(visual_bluff)

/obj/item/mech_equipment/power_generator/fueled/uninstalled()
	. = ..()
	owner.tickers.Remove(src)
	owner.vis_contents.Remove(visual_bluff)

/obj/item/mech_equipment/power_generator/fueled/update_icon()
	..()
	icon_state = "[initial(icon_state)]"
	visual_bluff.icon_state = "[initial(icon_state)]_[mode ? "on" : ""]_[get_hardpoint()]"
	if(owner)
		visual_bluff.dir = owner.dir

/obj/item/mech_equipment/power_generator/fueled/attack_self(mob/user)
	. = ..()
	if(. && owner)
		switch(mode)
			/// Eco mode , very slow generation but doubled power output ( 20% of power production at cost of 10% of fuel usage)
			if(0)
				mode = 1
				fuel_usage_per_tick = initial(fuel_usage_per_tick) * 0.1
				generation_rate = initial(generation_rate) * 0.2
				to_chat(user, SPAN_NOTICE("You switch \the [src]'s power production mode to ECO. 10% Fuel usage, 20% power output."))
			/// Default
			if(1)
				mode = 2
				fuel_usage_per_tick = initial(fuel_usage_per_tick)
				generation_rate = initial(generation_rate)
				to_chat(user, SPAN_NOTICE("You switch \the [src]'s power production mode to NORMAL. 100% Fuel usage, 100% power output."))
			/// Turbo mode, 2x fuel usage at 1.6x power output
			if(2)
				mode = 3
				fuel_usage_per_tick = initial(fuel_usage_per_tick) * 2
				generation_rate = initial(generation_rate) * 1.6
				to_chat(user, SPAN_NOTICE("You switch \the [src]'s power production mode to TURBO. 200% Fuel usage, 160% power output."))
			/// back to eco.
			if(3)
				mode = 0
				fuel_usage_per_tick = initial(fuel_usage_per_tick)
				generation_rate = initial(generation_rate)
				to_chat(user, SPAN_NOTICE("You switch \the [src]'s power production mode to OFF. 0% Fuel usage, 0% power output."))
		update_icon()


/obj/item/mech_equipment/power_generator/fueled/get_hardpoint_maptext()
	return "[fuel_amount]/[fuel_max] - [fuel_usage_per_tick]"

/obj/item/mech_equipment/power_generator/fueled/plasma
	name = "plasma powered mech-mountable power generator"
	desc = "a plasma-fueled mech power generator, creates 5 KW out of 1 sheet of plasma at a rate of 0.25 KW. Fully stocked it generates 35 KW in total."
	icon_state = "mech_generator_plasma"
	spawn_frequency = 80
	spawn_blacklisted = FALSE
	spawn_tags = SPAWN_MECH_QUIPMENT
	matter = list(MATERIAL_PLASTEEL = 15, MATERIAL_GLASS = 6, MATERIAL_PLASTIC = 3, MATERIAL_SILVER = 2, MATERIAL_GOLD = 3, MATERIAL_STEEL = 4)
	origin_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 5, TECH_POWER = 3)
	generation_rate = 250
	// each sheet is 5000 watts
	fuel_usage_per_tick = 50
	// 1 sheet = 1000 fuel
	// 35000 max power out of a fully loaded generator
	fuel_max = 7000

/obj/item/mech_equipment/power_generator/fueled/plasma/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(istype(I, /obj/item/stack/material/plasma))
		var/obj/item/stack/material/plasma/stck = I
		var/amount_to_use = round((fuel_max - fuel_amount)/1000)
		amount_to_use = clamp(stck.amount, 0, amount_to_use)
		if(amount_to_use && stck.use(amount_to_use))
			fuel_amount += amount_to_use * 1000

/obj/item/mech_equipment/power_generator/fueled/welding
	name ="welding fuel powered mech-mountable power generator"
	desc = "a mech mounted generator that runs off welding fuel, creates 1 KW out of 10 units of welding fuel, at a rate of 0.1 KW. Fully stocked it generates 20 KW in total."
	icon_state = "mech_generator_welding"
	spawn_frequency = 80
	spawn_blacklisted = FALSE
	spawn_tags = SPAWN_MECH_QUIPMENT
	matter = list(MATERIAL_PLASTEEL = 10, MATERIAL_GLASS = 3, MATERIAL_PLASTIC = 3, MATERIAL_SILVER = 2, MATERIAL_STEEL = 4)
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 3, TECH_POWER = 2)
	generation_rate = 100
	fuel_usage_per_tick = 1
	reagent_flags = DRAINABLE | REFILLABLE
	/// can generate 20000 power
	fuel_max = 200
	/// The "explosion" chamber , used for when the fuel is mixed with something else
	var/datum/reagents/chamberReagent = null

/obj/item/mech_equipment/power_generator/fueled/welding/Initialize()
	. = ..()
	// max volume
	create_reagents(200)
	chamberReagent = new(1, src)


/obj/item/mech_equipment/power_generator/fueled/welding/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	/// Only needed when we attack from outside
	if(owner)
		if(I.is_drainable() && I.reagents.total_volume)
			to_chat(user, SPAN_NOTICE("You transfer 10 units of substance from \the [I] to \the [src]'s internal fuel storage."))
			I.reagents.trans_to_holder(reagents, 10, 1, FALSE)
		else if(I.reagents && I.reagent_flags & REFILLABLE && user.a_intent == I_GRAB)
			to_chat(user, SPAN_NOTICE("You drain 10 units of substance from \the [src] to \the [I]."))
			reagents.trans_to_holder(I.reagents, 10, 1, FALSE)
		else
			to_chat(user, SPAN_NOTICE("You need to be on GRAB intent to drain from \the [src]."))
	else if(I.is_refillable() && reagents.total_volume && user.a_intent == I_GRAB)
		return FALSE
	else
		to_chat(user, SPAN_NOTICE("You need to be on GRAB intent to drain from \the [src]."))


/obj/item/mech_equipment/power_generator/fueled/welding/pretick()
	// dont run if we aren't on
	if(!mode)
		sound_loop?.stop()
		return
	chamberReagent.clear_reagents()
	reagents.trans_to_holder(chamberReagent, 1, 1, FALSE)
	if(chamberReagent.has_reagent("fuel"))
		var/fuel = chamberReagent.get_reagent_amount("fuel")
		// for the future just add any other reagent here with + * explosion_power_multiplier
		var/explosives = chamberReagent.get_reagent_amount("plasma") * 3
		if(explosives > 0.5)
			// if its full plasma if just fucking blows instantly
			health -= maxHealth * (explosives / 3)
			if(health < 1)
				owner.remove_system(src, null, TRUE)
				qdel(src)
				return
		// min needed for combustion
		if(fuel > 0.25)
			var/amountUsed = internal_cell?.give(generation_rate * fuel)
			// refund if none of it gets turned into power for qol reasons (its never exact returnal due to float errors)
			if(amountUsed < generation_rate * 0.1)
				chamberReagent.trans_to_holder(reagents, 1, 1, FALSE)
			if(fuel > fuel_usage_per_tick)
				chamberReagent.trans_id_to(reagents, "fuel", chamberReagent.total_volume - fuel_usage_per_tick, TRUE)
			if(internal_cell && owner)
				var/obj/item/cell/batt = owner.get_cell(TRUE)
				if(batt && batt != internal_cell)
					batt.give(internal_cell.use(batt.maxcharge - batt.charge))
			if(QDELETED(sound_loop))
				sound_loop = new(_interval = 2 SECONDS, duration = 10 SECONDS, interval_variance = 0,
				_source = owner, _soundin = 'sound/mechs/mech_generator.ogg' , _vol = 25 * mode, _vary = 0, _extrarange = mode * 3,
				_falloff = 0, _is_global = FALSE, _use_pressure = TRUE)
			else
				// extend it artificially.
				sound_loop.end_time = world.time + 10 SECONDS
				sound_loop.vol = mode * 25
				sound_loop.extrarange = mode * 3
	fuel_amount = reagents.total_volume

/obj/item/mech_equipment/towing_hook
	name = "mounted towing hook"
	desc = "A mech mounted towing hook, usually found in cars. Can hook to anything that isn't anchored down."
	icon_state = "mech_tow"
	restricted_hardpoints = list(HARDPOINT_BACK)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	origin_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 4)
	spawn_frequency = 80
	spawn_blacklisted = FALSE
	spawn_tags = SPAWN_MECH_QUIPMENT
	matter = list(MATERIAL_PLASTEEL = 10, MATERIAL_PLASTIC = 10)
	var/atom/movable/currentlyTowing = null

/obj/item/mech_equipment/towing_hook/installed(mob/living/exosuit/_owner, hardpoint)
	. = ..()
	RegisterSignal(_owner, COMSIG_MOVABLE_MOVED, PROC_REF(onMechMove))

/obj/item/mech_equipment/towing_hook/uninstalled()
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	if(currentlyTowing)
		UnregisterSignal(currentlyTowing, list(COMSIG_MOVABLE_MOVED,COMSIG_ATTEMPT_PULLING))
		currentlyTowing = null
	. = ..()

/// Yes you can hook onto other mechs that are hooked onto you, and yes it won't break anything , SPCR-2023
/obj/item/mech_equipment/towing_hook/proc/onTowingMove(atom/movable/mover, atom/oldLocation, atom/newLocation)
	SIGNAL_HANDLER
	if(newLocation.Adjacent(src))
		return
	UnregisterSignal(mover, list(COMSIG_MOVABLE_MOVED,COMSIG_ATTEMPT_PULLING))
	to_chat(owner.get_mob(), SPAN_NOTICE("You lose your hook ono \the [currentlyTowing]!"))
	currentlyTowing = null

/obj/item/mech_equipment/towing_hook/proc/onMechMove(atom/movable/mover, atom/oldLocation, atom/newLocation)
	SIGNAL_HANDLER
	if(!currentlyTowing)
		return
	if(!oldLocation.Adjacent(currentlyTowing))
		UnregisterSignal(currentlyTowing, list(COMSIG_MOVABLE_MOVED,COMSIG_ATTEMPT_PULLING))
		to_chat(owner.get_mob(), SPAN_NOTICE("You lose your hook ono \the [currentlyTowing]!"))
		currentlyTowing = null
		return
	// Protection against move loops caused by 2 mechs towing eachother.
	if(COMSIG_PULL_CANCEL == SEND_SIGNAL(src, COMSIG_ATTEMPT_PULLING))
		UnregisterSignal(currentlyTowing, list(COMSIG_MOVABLE_MOVED,COMSIG_ATTEMPT_PULLING))
		to_chat(owner.get_mob(), SPAN_NOTICE("You lose your hook ono \the [currentlyTowing]!"))
		currentlyTowing = null
		return
	// If we move up a z-level we want to instantly pull it up with us as to prevent possible abuse.
	// Protection against move loops caused by 2 mechs towing eachother walking diagonally
	// this gets triggered by z-moves too ,so inbuilt check for that
	/*
	if(lastMove > world.time - 0.1 SECONDS)
		UnregisterSignal(currentlyTowing, list(COMSIG_MOVABLE_MOVED,COMSIG_ATTEMPT_PULLING))
		currentlyTowing = null
		return
	*/
	if(oldLocation == newLocation)
		return
	if(oldLocation.z != newLocation.z)
		currentlyTowing.forceMove(newLocation)
	else
		currentlyTowing.Move(oldLocation)

/// We get supreme priority on pulling
/obj/item/mech_equipment/towing_hook/proc/onTowingPullAttempt()
	SIGNAL_HANDLER
	return COMSIG_PULL_CANCEL

/obj/item/mech_equipment/towing_hook/afterattack(atom/movable/target, mob/living/user, inrange, params)
	. = ..()
	if(!owner || target == owner)
		return
	if(!istype(target))
		to_chat(user, SPAN_NOTICE("You cannot hook onto this!"))
		return
	if(!currentlyTowing)
		if(target.Adjacent(src.owner) && !target.anchored)
			to_chat(user, SPAN_NOTICE("You hook \the [src] onto \the [target]!"))
			currentlyTowing = target
			RegisterSignal(target, COMSIG_MOVABLE_MOVED, PROC_REF(onTowingMove))
			RegisterSignal(target, COMSIG_ATTEMPT_PULLING, PROC_REF(onTowingPullAttempt))
	else if(currentlyTowing == target)
		to_chat(user, SPAN_NOTICE("You unhook \the [src] from \the [target]."))
		UnregisterSignal(currentlyTowing,list(COMSIG_MOVABLE_MOVED,COMSIG_ATTEMPT_PULLING))
		currentlyTowing = null
	else
		to_chat(user, SPAN_NOTICE("You are already towing \the [currentlyTowing]. Unhook from it first by attacking it again!"))

/obj/item/mech_equipment/mounted_system/toolkit
	name = "mounted toolkit"
	desc = "A automatic suite of tools suited for installation on a mech."
	icon_state = "mech_tools"
	holding_type = /obj/item/tool/mech_kit
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	origin_tech = list(TECH_ENGINEERING = 5, TECH_MAGNET = 2, TECH_MATERIAL = 2)
	matter = list(MATERIAL_PLASTEEL = 25, MATERIAL_PLASTIC = 10, MATERIAL_SILVER = 5)
	spawn_frequency = 80
	spawn_blacklisted = FALSE
	spawn_tags = SPAWN_MECH_QUIPMENT

/obj/item/tool/mech_kit
	name = "mech toolkit"
	desc = "A robust selection of mech-sized tools."
	icon_state = "engimplant"
	worksound = WORKSOUND_DRIVER_TOOL
	flags = CONDUCT
	tool_qualities = list(
		QUALITY_SCREW_DRIVING = 70,
		QUALITY_BOLT_TURNING = 70,
		QUALITY_DRILLING = 10,
		QUALITY_WELDING = 100,
		QUALITY_CAUTERIZING = 5,
		QUALITY_PRYING = 100,
		QUALITY_DIGGING = 50,
		QUALITY_PULSING = 50,
		QUALITY_WIRE_CUTTING = 100,
		QUALITY_HAMMERING = 75)
	degradation = 0
	workspeed = 1
	maxUpgrades = 1
	spawn_blacklisted = TRUE

/// Fancy way to move someone up a z-level if you think about it..
/obj/item/mech_equipment/forklifting_system
	name = "forklifting bars"
	desc = "a set of forklifts bars. Can be used to elevate crates above by a level.. or people! You can forklift a z-level up by attacking this with itself."
	icon_state = "forklift"
	restricted_hardpoints = list(HARDPOINT_FRONT)
	origin_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	spawn_frequency = 80
	spawn_blacklisted = FALSE
	spawn_tags = SPAWN_MECH_QUIPMENT
	matter = list(MATERIAL_PLASTEEL = 15, MATERIAL_STEEL = 15, MATERIAL_PLASTIC = 10)
	equipment_flags = EQUIPFLAG_UPDTMOVE
	var/atom/movable/currentlyLifting = null
	var/obj/structure/forklift_platform/platform = null
	var/lastZ = null
	var/lastDir = null
	var/lifted = FALSE

/obj/item/mech_equipment/forklifting_system/Initialize()
	. = ..()
	platform = new(NULLSPACE)
	platform.master = src
	platform.forceMove(src)

/obj/item/mech_equipment/forklifting_system/Destroy()
	if(currentlyLifting)
		ejectLifting(get_turf(src))
	if(platform)
		QDEL_NULL(platform)
	. = ..()


/obj/item/mech_equipment/forklifting_system/proc/ejectLifting(atom/target)
	currentlyLifting.forceMove(target)
	currentlyLifting.transform = null
	currentlyLifting.pixel_x = initial(currentlyLifting.pixel_x)
	currentlyLifting.pixel_y = initial(currentlyLifting.pixel_y)
	currentlyLifting.mouse_opacity = initial(currentlyLifting.mouse_opacity)
	owner.vis_contents.Remove(currentlyLifting)
	var/mob/targ = currentlyLifting
	targ.update_icon()
	targ.update_plane()
	targ.layer = initial(targ.layer)
	if(ismob(targ) && targ.client)
		targ.client.perspective = MOB_PERSPECTIVE
		targ.client.eye = src
	currentlyLifting = null
	target.atomFlags &= ~AF_LAYER_UPDATE_HANDLED
	target.atomFlags &= ~AF_PLANE_UPDATE_HANDLED
	update_icon()

/obj/item/mech_equipment/forklifting_system/proc/startLifting(atom/movable/target)
	currentlyLifting = target
	// No clicking this whilst lifted
	currentlyLifting.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	currentlyLifting.forceMove(src)
	target.atomFlags &= AF_LAYER_UPDATE_HANDLED
	target.atomFlags &= AF_PLANE_UPDATE_HANDLED
	var/mob/targ = currentlyLifting
	if(ismob(targ) && targ.client)
		targ.client.perspective = EYE_PERSPECTIVE
		targ.client.eye = src
		to_chat(targ, SPAN_DANGER("You can resist out of the forklift to instantly get out!"))
	update_icon()

/obj/item/mech_equipment/forklifting_system/uninstalled()
	. = ..()
	if(currentlyLifting)
		ejectLifting(get_turf(owner))


/obj/structure/forklift_platform
	layer = TURF_LAYER + 0.5
	icon = MECH_EQUIPMENT_ICON
	icon_state = "forklift_platform"
	name = "forklift platform"
	desc = "A fun way to reach new horizons. Mind the gap between.. small things fall through."
	density = FALSE
	anchored = TRUE
	health = 200
	var/obj/item/mech_equipment/forklifting_system/master = null

/obj/structure/forklift_platform/Destroy()
	if(master)
		master.platform = null
		master.update_icon()
		if(master.owner)
			master.owner.update_icon()
		master = null
	. = ..()

/// We can prevent the fall of humans and structures , but everything else will just fall down
/obj/structure/forklift_platform/can_prevent_fall(above, atom/movable/mover)
	if(!above)
		if(ishuman(mover))
			return TRUE
		if(isstructure(mover))
			return TRUE
	return FALSE


/obj/item/mech_equipment/forklifting_system/update_icon()
	. = ..()
	if(owner)
		if(!platform)
			icon_state = "forklift_platformless"
			return
		if(lifted)
			icon_state = "forklift_lifted"
		else
			icon_state = "forklift"
			if(currentlyLifting)
				if(!locate(currentlyLifting) in owner.vis_contents)
					owner.vis_contents.Add(currentlyLifting)
				if(owner.dir != lastDir)
					lastDir = owner.dir
					currentlyLifting.dir = owner.dir
					if(lastDir == NORTH)
						currentlyLifting.pixel_x = 8
						currentlyLifting.pixel_y = 10
						currentlyLifting.layer = MECH_UNDER_LAYER
					if(lastDir == EAST)
						currentlyLifting.pixel_x = 33
						currentlyLifting.pixel_y = 8
						currentlyLifting.layer = MECH_ABOVE_LAYER
					if(lastDir == SOUTH)
						currentlyLifting.pixel_x = 8
						currentlyLifting.pixel_y = 0
						currentlyLifting.layer = MECH_ABOVE_LAYER
					if(lastDir == WEST)
						currentlyLifting.pixel_x = -15
						currentlyLifting.pixel_y = 8
						currentlyLifting.layer = MECH_ABOVE_LAYER
				if(owner.z != lastZ)
					lastZ = owner.z
					currentlyLifting.z = owner.z
					currentlyLifting.update_plane()

/obj/item/mech_equipment/forklifting_system/attack_self(mob/user)
	. = ..()
	if(!owner)
		return
	if(platform)
		if(!lifted)
			/// We are checking the turf above first
			var/turf/aboveSpace = GetAbove(get_turf(owner))
			if(!aboveSpace)
				to_chat(user, SPAN_NOTICE("The universe runs out of fabric here! You cannot possibly elevate something here."))
				return
			if(!istype(aboveSpace, /turf/simulated/open) || locate(/obj/structure/catwalk) in aboveSpace)
				to_chat(user, SPAN_NOTICE("Something dense prevents lifting up."))
				return
			/// Then the one infront + above
			aboveSpace = get_step(owner, owner.dir)
			aboveSpace = GetAbove(aboveSpace)
			if(!aboveSpace)
				to_chat(user, SPAN_NOTICE("The universe runs out of fabric here! You cannot possibly elevate something here."))
				return
			if(!istype(aboveSpace, /turf/simulated/open) || locate(/obj/structure/catwalk) in aboveSpace)
				to_chat(user, SPAN_NOTICE("Something dense prevents lifting up."))
				return
			to_chat(user, SPAN_NOTICE("You start elevating \the [src] platform."))
			if(do_after(user, 2 SECONDS, owner, TRUE))
				to_chat(user, SPAN_NOTICE("You elevate \the [src]'s platform"))
				platform.dir = owner.dir
				platform.forceMove(aboveSpace)
				owner.update_icon()
				if(currentlyLifting)
					ejectLifting(aboveSpace)
				lifted = TRUE
		else
			to_chat(user, SPAN_NOTICE("You start retracting the forklift!"))
			var/turf/targ = get_turf(platform)
			if(do_after(user, 2 SECONDS, owner, TRUE))
				if(!platform)
					return
				to_chat(user, SPAN_NOTICE("You retract the forklift!"))
				lifted = FALSE
				platform.forceMove(src)
				owner.update_icon()
				var/atom/whoWeBringingBack
				/// Pick up the first mob , else just get the last atom returned
				for(var/atom/movable/A in targ)
					if(A == platform)
						continue
					if(A.anchored)
						continue
					if(ismob(A))
						whoWeBringingBack = A
						break
					whoWeBringingBack = A
				if(whoWeBringingBack)
					startLifting(whoWeBringingBack)
	else
		to_chat(user, SPAN_NOTICE("You can't lift without a platform!"))

/obj/item/mech_equipment/forklifting_system/afterattack(atom/movable/target, mob/living/user, inrange, params)
	. = ..()
	if(.)
		if(currentlyLifting && isturf(target) && inrange)
			for(var/atom/A in target)
				if(A.density)
					to_chat(user, SPAN_NOTICE("[A] is taking up space, preventing you from dropping \the [currentlyLifting] here!"))
					return
			ejectLifting(target)
			return
		if(currentlyLifting)
			to_chat(user, SPAN_NOTICE("You are already lifting something!"))
			return
		if(!platform)
			to_chat(user, SPAN_NOTICE("There is no forklift platform to lift on! You should get it replaced"))
			return
		if(lifted)
			to_chat(user, SPAN_NOTICE("You can't lift someone whilst the forklift is lifted!"))
			return
		if(inrange && istype(target))
			if(target.anchored)
				to_chat(user, SPAN_NOTICE("\The [target] is anchored!"))
				return
			if(ismob(target))
				var/mob/living/trg = target
				if(trg.mob_size >= MOB_HUGE)
					to_chat(user, SPAN_NOTICE("\The [target] is far too big to fit on the forklift clamps!"))
					return
			to_chat(user, SPAN_NOTICE("You start lifting \the [target] onto the hooks."))
			if(do_after(user, 2 SECONDS, target))
				startLifting(target)
			update_icon()







