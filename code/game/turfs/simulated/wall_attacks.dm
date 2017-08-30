//Interactions
/turf/simulated/wall/proc/toggle_open(var/mob/user)

	if(can_open == WALL_OPENING)
		return

	if(density)
		can_open = WALL_OPENING
		//flick("[material.icon_base]fwall_opening", src)
		sleep(15)
		density = 0
		opacity = 0
		update_icon()
		set_light(0)
	else
		can_open = WALL_OPENING
		//flick("[material.icon_base]fwall_closing", src)
		density = 1
		opacity = 1
		update_icon()
		sleep(15)
		set_light(1)

	can_open = WALL_CAN_OPEN
	update_icon()

/turf/simulated/wall/proc/fail_smash(var/mob/user)
	user << SPAN_DANGER("You smash against the wall!")
	take_damage(rand(25,75))

/turf/simulated/wall/proc/success_smash(var/mob/user)
	user << SPAN_DANGER("You smash through the wall!")
	user.do_attack_animation(src)
	spawn(1)
		dismantle_wall(1)

/turf/simulated/wall/proc/try_touch(var/mob/user, var/rotting)

	if(rotting)
		if(reinf_material)
			user << SPAN_DANGER("\The [reinf_material.display_name] feels porous and crumbly.")
		else
			user << SPAN_DANGER("\The [material.display_name] crumbles under your touch!")
			dismantle_wall()
			return 1

	if(..()) return 1

	if(!can_open)
		user << SPAN_NOTICE("You push the wall, but nothing happens.")
		playsound(src, hitsound, 25, 1)
	else
		toggle_open(user)
	return 0


/turf/simulated/wall/attack_hand(var/mob/user)

	radiate()
	add_fingerprint(user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	var/rotting = (locate(/obj/effect/overlay/wallrot) in src)
	if (HULK in user.mutations)
		if (rotting || !prob(material.hardness))
			success_smash(user)
		else
			fail_smash(user)
			return 1

	try_touch(user, rotting)

/turf/simulated/wall/attack_generic(var/mob/user, var/damage, var/attack_message, var/wallbreaker)

	radiate()
	if(!istype(user))
		return

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	var/rotting = (locate(/obj/effect/overlay/wallrot) in src)
	if(!damage || !wallbreaker)
		try_touch(user, rotting)
		return

	if(rotting)
		return success_smash(user)

	if(reinf_material)
		if((wallbreaker == 2) || (damage >= max(material.hardness,reinf_material.hardness)))
			return success_smash(user)
	else if(damage >= material.hardness)
		return success_smash(user)
	return fail_smash(user)

/turf/simulated/wall/attackby(obj/item/weapon/W as obj, mob/user as mob)

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if (!user.)
		user << SPAN_WARNING("You don't have the dexterity to do this!")
		return

	//get the user's location
	if(!istype(user.loc, /turf))	return	//can't do this stuff whilst inside objects and such

	if(W)
		radiate()
		if(is_hot(W))
			burn(is_hot(W))

	if(locate(/obj/effect/overlay/wallrot) in src)
		if(istype(W, /obj/item/weapon/weldingtool) )
			var/obj/item/weapon/weldingtool/WT = W
			if( WT.remove_fuel(0,user) )
				user << SPAN_NOTICE("You burn away the fungi with \the [WT].")
				playsound(src, 'sound/items/Welder.ogg', 10, 1)
				for(var/obj/effect/overlay/wallrot/WR in src)
					qdel(WR)
				return
		else if(!is_sharp(W) && W.force >= 10 || W.force >= 20)
			user << SPAN_NOTICE("\The [src] crumbles away under the force of your [W.name].")
			src.dismantle_wall(1)
			return

	//THERMITE related stuff. Calls src.thermitemelt() which handles melting simulated walls and the relevant effects
	if(thermite)
		if( istype(W, /obj/item/weapon/weldingtool) )
			var/obj/item/weapon/weldingtool/WT = W
			if( WT.remove_fuel(0,user) )
				thermitemelt(user)
				return

		else if(istype(W, /obj/item/weapon/pickaxe/plasmacutter))
			thermitemelt(user)
			return

		else if( istype(W, /obj/item/weapon/melee/energy/blade) )
			var/obj/item/weapon/melee/energy/blade/EB = W

			EB.spark_system.start()
			user << SPAN_NOTICE("You slash \the [src] with \the [EB]; the thermite ignites!")
			playsound(src, "sparks", 50, 1)
			playsound(src, 'sound/weapons/blade1.ogg', 50, 1)

			thermitemelt(user)
			return

	var/turf/T = user.loc	//get user's location for delay checks

	if(damage && istype(W, /obj/item/weapon/weldingtool))

		var/obj/item/weapon/weldingtool/WT = W

		if(!WT.isOn())
			return

		if(WT.remove_fuel(0,user))
			user << SPAN_NOTICE("You start repairing the damage to [src].")
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			if(do_after(user, max(5, damage / 5), src) && WT && WT.isOn())
				user << SPAN_NOTICE("You finish repairing the damage to [src].")
				take_damage(-damage)
		else
			user << SPAN_NOTICE("You need more welding fuel to complete this task.")
			return
		return

	// Basic dismantling.
	if(isnull(construction_stage) || !reinf_material)

		var/cut_delay = 60 - material.cut_delay
		var/dismantle_verb
		var/dismantle_sound

		if(istype(W,/obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WT = W
			if(!WT.isOn())
				return
			if(!WT.remove_fuel(0,user))
				user << SPAN_NOTICE("You need more welding fuel to complete this task.")
				return
			dismantle_verb = "cutting"
			dismantle_sound = 'sound/items/Welder.ogg'
			cut_delay *= 0.7
		else if(istype(W,/obj/item/weapon/melee/energy/blade))
			dismantle_sound = "sparks"
			dismantle_verb = "slicing"
			cut_delay *= 0.5
		else if(istype(W,/obj/item/weapon/pickaxe))
			var/obj/item/weapon/pickaxe/P = W
			dismantle_verb = P.drill_verb
			dismantle_sound = P.drill_sound
			cut_delay -= P.digspeed

		if(dismantle_verb)

			user << SPAN_NOTICE("You begin [dismantle_verb] through the outer plating.")
			if(dismantle_sound)
				playsound(src, dismantle_sound, 100, 1)

			if(cut_delay<0)
				cut_delay = 0

			if(!do_after(user,cut_delay,src))
				return

			user << SPAN_NOTICE("You remove the outer plating.")
			dismantle_wall()
			user.visible_message(SPAN_WARNING("The wall was torn open by [user]!"))
			return

	//Reinforced dismantling.
	else
		switch(construction_stage)
			if(6)
				if (istype(W, /obj/item/weapon/wirecutters))
					playsound(src, 'sound/items/Wirecutter.ogg', 100, 1)
					construction_stage = 5
					new /obj/item/stack/rods( src )
					user << SPAN_NOTICE("You cut the outer grille.")
					update_icon()
					return
			if(5)
				if (istype(W, /obj/item/weapon/screwdriver))
					user << SPAN_NOTICE("You begin removing the support lines.")
					playsound(src, 'sound/items/Screwdriver.ogg', 100, 1)
					if(!do_after(user,40,src) || !istype(src, /turf/simulated/wall) || construction_stage != 5)
						return
					construction_stage = 4
					update_icon()
					user << SPAN_NOTICE("You remove the support lines.")
					return
				else if( istype(W, /obj/item/stack/rods) )
					var/obj/item/stack/O = W
					if(O.get_amount()>0)
						O.use(1)
						construction_stage = 6
						update_icon()
						user << SPAN_NOTICE("You replace the outer grille.")
						return
			if(4)
				var/cut_cover
				if(istype(W,/obj/item/weapon/weldingtool))
					var/obj/item/weapon/weldingtool/WT = W
					if(!WT.isOn())
						return
					if(WT.remove_fuel(0,user))
						cut_cover=1
					else
						user << SPAN_NOTICE("You need more welding fuel to complete this task.")
						return
				else if (istype(W, /obj/item/weapon/pickaxe/plasmacutter))
					cut_cover = 1
				if(cut_cover)
					user << SPAN_NOTICE("You begin slicing through the metal cover.")
					playsound(src, 'sound/items/Welder.ogg', 100, 1)
					if(!do_after(user, 60, src) || !istype(src, /turf/simulated/wall) || construction_stage != 4)
						return
					construction_stage = 3
					update_icon()
					user << SPAN_NOTICE("You press firmly on the cover, dislodging it.")
					return
			if(3)
				if (istype(W, /obj/item/weapon/crowbar))
					user << SPAN_NOTICE("You struggle to pry off the cover.")
					playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
					if(!do_after(user,100,src) || !istype(src, /turf/simulated/wall) || construction_stage != 3)
						return
					construction_stage = 2
					update_icon()
					user << SPAN_NOTICE("You pry off the cover.")
					return
			if(2)
				if (istype(W, /obj/item/weapon/wrench))
					user << SPAN_NOTICE("You start loosening the anchoring bolts which secure the support rods to their frame.")
					playsound(src, 'sound/items/Ratchet.ogg', 100, 1)
					if(!do_after(user,40,src) || !istype(src, /turf/simulated/wall) || construction_stage != 2)
						return
					construction_stage = 1
					update_icon()
					user << SPAN_NOTICE("You remove the bolts anchoring the support rods.")
					return
			if(1)
				var/cut_cover
				if(istype(W, /obj/item/weapon/weldingtool))
					var/obj/item/weapon/weldingtool/WT = W
					if( WT.remove_fuel(0,user) )
						cut_cover=1
					else
						user << SPAN_NOTICE("You need more welding fuel to complete this task.")
						return
				else if(istype(W, /obj/item/weapon/pickaxe/plasmacutter))
					cut_cover = 1
				if(cut_cover)
					user << SPAN_NOTICE("You begin slicing through the support rods.")
					playsound(src, 'sound/items/Welder.ogg', 100, 1)
					if(!do_after(user,70,src) || !istype(src, /turf/simulated/wall) || construction_stage != 1)
						return
					construction_stage = 0
					update_icon()
					new /obj/item/stack/rods(src)
					user << SPAN_NOTICE("The support rods drop out as you cut them loose from the frame.")
					return
			if(0)
				if(istype(W, /obj/item/weapon/crowbar))
					user << SPAN_NOTICE("You struggle to pry off the outer sheath.")
					playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
					sleep(100)
					if(!istype(src, /turf/simulated/wall) || !user || !W || !T )	return
					if(user.loc == T && user.get_active_hand() == W )
						user << SPAN_NOTICE("You pry off the outer sheath.")
						dismantle_wall()
					return

	if(istype(W,/obj/item/frame))
		var/obj/item/frame/F = W
		F.try_build(src)
		return

	else if(!istype(W,/obj/item/weapon/rcd) && !istype(W, /obj/item/weapon/reagent_containers))
		if(!W.force)
			return attack_hand(user)
		var/dam_threshhold = material.integrity
		if(reinf_material)
			dam_threshhold = ceil(max(dam_threshhold,reinf_material.integrity)/2)
		var/dam_prob = min(100,material.hardness*1.5)
		if(dam_prob < 100 && W.force > (dam_threshhold/10))
			playsound(src, hitsound, 80, 1)
			if(!prob(dam_prob))
				visible_message(SPAN_DANGER("\The [user] attacks \the [src] with \the [W] and it [material.destruction_desc]!"))
				dismantle_wall(1)
			else
				visible_message(SPAN_DANGER("\The [user] attacks \the [src] with \the [W]!"))
		else
			visible_message(SPAN_DANGER("\The [user] attacks \the [src] with \the [W], but it bounces off!"))
		return
