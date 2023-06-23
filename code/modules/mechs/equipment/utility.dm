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
				if(O.buckled_mob)
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
					if(O in carrying || O.buckled_mob || O.anchored || (locate(/mob/living) in O)) //Repeat checks
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
	restricted_hardpoints = list(HARDPOINT_HEAD)
	mech_layer = MECH_INTERMEDIATE_LAYER

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
