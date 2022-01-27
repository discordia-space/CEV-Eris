/obj/item/mech_e69uipment/clamp
	name = "mounted clamp"
	desc = "A large, heavy industrial cargo loading clamp."
	icon_state = "mech_clamp"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	var/obj/carrying
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/mech_e69uipment/clamp/attack()
	return 0

/obj/item/mech_e69uipment/clamp/afterattack(atom/target,69ob/living/user, inrange, params)
	if(!inrange) return
	. = ..()

	if(. && !carrying)

		if (!inrange)
			to_chat(user, SPAN_NOTICE("You69ust be adjacent to 69target69 to use the hydraulic clamp."))
		else

			if(istype(target, /obj))


				var/obj/O = target
				if(O.buckled_mob)
					return
				if(locate(/mob/living) in O)
					to_chat(user, SPAN_WARNING("You can't load living things into the cargo compartment."))
					return

				if(istype(target, /obj/structure/scrap_spawner))
					owner.visible_message(SPAN_NOTICE("\The 69owner69 begins compressing \the 69O69 with \the 69src69."))
					playsound(src, 'sound/mechs/hydraulic.ogg', 50, 1)
					if(do_after(owner, 20, O, 0, 1))
						if(istype(O, /obj/structure/scrap_spawner))
							var/obj/structure/scrap_spawner/S = O
							S.make_cube()
							owner.visible_message(SPAN_NOTICE("\The 69owner69 compresses \the 69O69 into a cube with \the 69src69."))
					return

				if(O.anchored)
					to_chat(user, SPAN_WARNING("69target69 is firmly secured."))
					return


				owner.visible_message(SPAN_NOTICE("\The 69owner69 begins loading \the 69O69."))
				playsound(src, 'sound/mechs/hydraulic.ogg', 50, 1)
				if(do_after(owner, 20, O, 0, 1))
					O.forceMove(src)
					carrying = O
					owner.visible_message(SPAN_NOTICE("\The 69owner69 loads \the 69O69 into its cargo compartment."))


			//attacking - Cannot be carrying something, cause then your clamp would be full
			else if(istype(target,/mob/living))
				var/mob/living/M = target
				if(user.a_intent == I_HURT)
					admin_attack_log(user,69, "attempted to clamp 69M69 with 69src69 ", "Was subject to a clamping attempt.", ", using \a 69src69, attempted to clamp")
					owner.setClickCooldown(owner.arms ? owner.arms.action_delay * 3 : 30) //This is an inefficient use of your powers
//				if(prob(33))
//					owner.visible_message(SPAN_DANGER("69owner69 swings its 69src69 in a wide arc at 69target69 but69isses completely!"))
//					return
					M.attack_generic(owner, (owner.arms ? owner.arms.melee_damage * 1.5 : 0), "slammed") //Honestly you should69ot be able to do this without hands, but still
					M.throw_at(get_edge_target_turf(owner ,owner.dir),5, 2)
					to_chat(user, SPAN_WARNING("You slam 69target69 with 69src.name69."))
					owner.visible_message(SPAN_DANGER("69owner69 slams 69target69 with the hydraulic clamp."))
				else
					step_away(M, owner)
					to_chat(user, "You push 69target69 out of the way.")
					owner.visible_message("69owner69 pushes 69target69 out of the way.")

/obj/item/mech_e69uipment/clamp/attack_self(var/mob/user)
	. = ..()
	if(.)
		if(!carrying)
			to_chat(user, SPAN_WARNING("You are69ot carrying anything in \the 69src69."))
		else
			owner.visible_message(SPAN_NOTICE("\The 69owner69 unloads \the 69carrying69."))
			carrying.forceMove(get_turf(src))
			carrying =69ull

/obj/item/mech_e69uipment/clamp/get_hardpoint_maptext()
	if(carrying)
		return carrying.name
	. = ..()

// A lot of this is copied from floodlights.
/obj/item/mech_e69uipment/light
	name = "floodlight"
	desc = "An exosuit-mounted light."
	icon_state = "mech_floodlight"
	item_state = "mech_floodlight"
	restricted_hardpoints = list(HARDPOINT_HEAD)
	mech_layer =69ECH_INTERMEDIATE_LAYER

	var/on = FALSE
	var/l_max_bright = 0.9
	var/l_inner_range = 1
	var/l_outer_range = 6
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)

/obj/item/mech_e69uipment/light/attack_self(var/mob/user)
	. = ..()
	if(.)
		on = !on
		to_chat(user, "You switch \the 69src69 69on ? "on" : "off"69.")
		update_icon()
		owner.update_icon()

/obj/item/mech_e69uipment/light/update_icon()
	. = ..()
	if(on)
		icon_state = "69initial(icon_state)69-on"
		//set_light(l_max_bright, l_inner_range, l_outer_range)
		set_light(l_outer_range, l_max_bright, "#ffffff")
	else
		icon_state = "69initial(icon_state)69"
		//set_light(0, 0)
		set_light(0, 0)

#define CATAPULT_SINGLE 1
#define CATAPULT_AREA   2

/obj/item/mech_e69uipment/catapult
	name = "gravitational catapult"
	desc = "An exosuit-mounted gravitational catapult."
	icon_state = "mech_clamp"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	var/mode = CATAPULT_SINGLE
	var/atom/movable/locked
	e69uipment_delay = 30 //Stunlocks are69ot ideal
	origin_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 4, TECH_MAGNET = 4)

/obj/item/mech_e69uipment/catapult/get_hardpoint_maptext()
	var/string
	if(locked)
		string = locked.name + " - "
	if(mode == 1)
		string += "Pull"
	else string += "Push"
	return string


/obj/item/mech_e69uipment/catapult/attack_self(var/mob/user)
	. = ..()
	if(.)
		mode =69ode == CATAPULT_SINGLE ? CATAPULT_AREA : CATAPULT_SINGLE
		to_chat(user, SPAN_NOTICE("You set \the 69src69 to 69mode == CATAPULT_SINGLE ? "single" : "multi"69-target69ode."))
		update_icon()


/obj/item/mech_e69uipment/catapult/afterattack(var/atom/target,69ar/mob/living/user,69ar/inrange,69ar/params)
	. = ..()
	if(.)

		switch(mode)
			if(CATAPULT_SINGLE)
				if(!locked)
					var/atom/movable/AM = target
					if(!istype(AM) || AM.anchored || !AM.simulated)
						to_chat(user, SPAN_NOTICE("Unable to lock on 69target69."))
						return
					locked = AM
					to_chat(user, SPAN_NOTICE("Locked on 69AM69."))
					return
				else if(target != locked)
					if(locked in69iew(owner))
						locked.throw_at(target, 14, 1.5, owner)
						log_and_message_admins("used 69src69 to throw 69locked69 at 69target69.", user, owner.loc)
						locked =69ull

						var/obj/item/cell/C = owner.get_cell()
						if(istype(C))
							C.use(active_power_use * CELLRATE)

					else
						locked =69ull
						to_chat(user, SPAN_NOTICE("Lock on 69locked69 disengaged."))
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


				log_and_message_admins("used 69src69's area throw on 69target69.", user, owner.loc)
				var/obj/item/cell/C = owner.get_cell()
				if(istype(C))
					C.use(active_power_use * CELLRATE * 2) //bit69ore expensive to throw all



#undef CATAPULT_SINGLE
#undef CATAPULT_AREA


/obj/item/material/drill_head
	var/durability = 0
	name = "drill head"
	desc = "A replaceable drill head usually used in exosuit drills."
	icon_state = "exodrillhead"
	default_material =69ATERIAL_STEEL

/obj/item/material/drill_head/Initialize()
	. = ..()

	//durability = 2 * (material ?69aterial.integrity : 1)

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
	durability = 2 * (material ?69aterial.integrity : 1)

/obj/item/mech_e69uipment/drill
	name = "drill"
	desc = "This is the drill that'll pierce the heavens!"
	icon_state = "mech_drill"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)
	e69uipment_delay = 10

	//Drill can have a head
	var/obj/item/material/drill_head/drill_head
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)



/obj/item/mech_e69uipment/drill/Initialize()
	. = ..()
	drill_head =69ew /obj/item/material/drill_head(src, "steel")//You start with a basic steel head
	drill_head.ApplyDurability()

/obj/item/mech_e69uipment/drill/attack_self(var/mob/user)
	. = ..()
	if(.)
		if(drill_head)
			owner.visible_message(SPAN_WARNING("69owner69 revs the 69drill_head69,69enancingly."))
			playsound(src, 'sound/weapons/circsawhit.ogg', 50, 1)


/obj/item/mech_e69uipment/drill/afterattack(var/atom/target,69ar/mob/living/user,69ar/inrange,69ar/params)
	. = ..()
	if(.)


		if (!inrange)
			to_chat(user, SPAN_NOTICE("You69ust be adjacent to 69target69 to use the69ounted drill."))
		else
			if(isobj(target))
				var/obj/target_obj = target
				if(target_obj.unacidable)
					return
			if(istype(target,/obj/item/material/drill_head))
				var/obj/item/material/drill_head/DH = target
				if(drill_head)
					owner.visible_message(SPAN_NOTICE("\The 69owner69 detaches the 69drill_head6969ounted on the 69src69."))
					drill_head.forceMove(owner.loc)
				DH.forceMove(src)
				drill_head = DH
				owner.visible_message(SPAN_NOTICE("\The 69owner6969ounts the 69drill_head69 on the 69src69."))
				return

			if(drill_head ==69ull)
				to_chat(user, SPAN_WARNING("Your drill doesn't have a head!"))
				return

			var/obj/item/cell/C = owner.get_cell()
			if(istype(C))
				C.use(active_power_use * CELLRATE)
			playsound(src, 'sound/mechs/mechdrill.ogg', 50, 1)
			owner.visible_message(SPAN_DANGER("\The 69owner69 starts to drill \the 69target69"), SPAN_WARNING("You hear a large drill."))
			var/T = target.loc

			//Better69aterials = faster drill! // 
			var/delay = 30
			switch (drill_head.material.hardness) // It's either default (steel), plasteel or diamond
				if(80) delay = 15
				if(100) delay = 10
			owner.setClickCooldown(delay) //Don't spamclick!
			if(do_after(owner, delay, target) && drill_head)
				if(src == owner.selected_system)
					if(drill_head.durability <= 0)
						drill_head.shatter()
						drill_head =69ull
						return
					if(istype(target, /turf/simulated/wall))
						var/turf/simulated/wall/W = target
						if(max(W.material.hardness, W.reinf_material ? W.reinf_material.hardness : 0) > drill_head.material.hardness)
							to_chat(user, SPAN_WARNING("\The 69target69 is too hard to drill through with this drill head."))
							return
						target.ex_act(2)
						drill_head.durability -= 1
						log_and_message_admins("used 69src69 on the wall 69W69.", user, owner.loc)
					else if(istype(target, /turf/simulated/mineral))
						for(var/turf/simulated/mineral/M in range(target,1))
							if(get_dir(owner,M)&owner.dir)
								M.GetDrilled()
								drill_head.durability -= 1
					else if(istype(target, /turf/simulated/floor/asteroid))
						for(var/turf/simulated/floor/asteroid/M in range(target,1))
							if(get_dir(owner,M)&owner.dir)
								M.gets_dug()
								drill_head.durability -= 1
					else if(target.loc == T)
						target.ex_act(2)
						drill_head.durability -= 1
						log_and_message_admins("69src69 used to drill 69target69.", user, owner.loc)




					if(owner.hardpoints.len) //if this isn't true the drill should69ot be working to be fair
						for(var/hardpoint in owner.hardpoints)
							var/obj/item/I = owner.hardpoints69hardpoint69
							if(!istype(I))
								continue
							var/obj/structure/ore_box/ore_box = locate(/obj/structure/ore_box) in I //clamps work, but anythin that contains an ore crate internally is69alid
							if(ore_box)
								for(var/obj/item/ore/ore in range(T,1))
									if(get_dir(owner,ore)&owner.dir)
										ore.Move(ore_box)

					playsound(src, 'sound/weapons/rapidslice.ogg', 50, 1)

			else
				to_chat(user, "You69ust stay still while the drill is engaged!")


			return 1

/obj/item/mech_e69uipment/mounted_system/extinguisher
	icon_state = "mech_exting"
	holding_type = /obj/item/extinguisher/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_UTILITY)

/obj/item/extinguisher/mech
	max_water = 4000 //Good is gooder
	icon_state = "mech_exting"
	overlaylist = list()

/obj/item/extinguisher/mech/get_hardpoint_maptext()
	return "69reagents.total_volume69/69max_water69"

/obj/item/extinguisher/mech/get_hardpoint_status_value()
	return reagents.total_volume/max_water
