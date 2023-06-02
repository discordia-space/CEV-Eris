/obj/structure/window
	name = "window"
	desc = "A window."
	icon = 'icons/obj/structures.dmi'

	density = TRUE
	layer = ABOVE_OBJ_LAYER //Just above doors
	anchored = TRUE
	flags = ON_BORDER
	maxHealth = 20
	health = 20
	explosion_coverage = 1
	var/resistance = RESISTANCE_FLIMSY	//Incoming damage is reduced by this flat amount before being subtracted from health. Defines found in code\__defines\weapons.dm
	var/maximal_heat = T0C + 100 		// Maximal heat before this window begins taking damage from fire
	var/damage_per_fire_tick = 2 		// Amount of damage per fire tick. Regular windows are not fireproof so they might as well break quickly.
	var/ini_dir = null
	var/state = 2
	var/reinf = 0
	var/basestate
	var/shardtype = /obj/item/material/shard
	var/glasstype = null // Set this in subtypes. Null is assumed strange or otherwise impossible to dismantle, such as for shuttle glass.
	var/silicate = 0 // number of units of silicate
	var/no_color = FALSE //If true, don't apply a color to the base

	atmos_canpass = CANPASS_PROC

/obj/structure/window/can_prevent_fall()
	return !is_fulltile()

/obj/structure/window/get_fall_damage(var/turf/from, var/turf/dest)
	var/damage = health * 0.4 * get_health_ratio()

	if (from && dest)
		damage *= abs(from.z - dest.z)

	return damage

/obj/structure/window/examine(mob/user)
	. = ..(user)

	if(health == maxHealth)
		to_chat(user, SPAN_NOTICE("It looks fully intact."))
	else
		var/perc = health / maxHealth
		if(perc > 0.75)
			to_chat(user, SPAN_NOTICE("It has a few cracks."))
		else if(perc > 0.5)
			to_chat(user, SPAN_WARNING("It looks slightly damaged."))
		else if(perc > 0.25)
			to_chat(user, SPAN_WARNING("It looks moderately damaged."))
		else
			to_chat(user, SPAN_DANGER("It looks heavily damaged."))
	if(silicate)
		if (silicate < 30)
			to_chat(user, SPAN_NOTICE("It has a thin layer of silicate."))
		else if (silicate < 70)
			to_chat(user, SPAN_NOTICE("It is covered in silicate."))
		else
			to_chat(user, SPAN_NOTICE("There is a thick layer of silicate covering it."))


//Subtracts resistance from damage then applies it
//Returns the actual damage taken after resistance is accounted for. This is useful for audio volumes
/obj/structure/window/take_damage(damage = 0)
	var/initialhealth = health
	. = health - (damage * (1 - silicate / 200) - resistance) < 0 ? damage - (damage - health) : damage
	. *= explosion_coverage
	damage = damage * (1 - silicate / 200) // up to 50% damage resistance
	damage -= resistance // then flat resistance from material

	if (damage <= 0)
		return 0

	health -= damage

	if(health <= 0)
		if(health < -100)
			shatter(FALSE, TRUE)
		else
			shatter()
	else
		playsound(loc, 'sound/effects/Glasshit.ogg', 100, 1)
		if(health < maxHealth / 4 && initialhealth >= maxHealth / 4)
			visible_message("[src] looks like it's about to shatter!" )
		else if(health < maxHealth / 2 && initialhealth >= maxHealth / 2)
			visible_message("[src] looks seriously damaged!" )
		else if(health < maxHealth * 3/4 && initialhealth >= maxHealth * 3/4)
			visible_message("Cracks begin to appear in [src]!" )
	return

/obj/structure/window/proc/apply_silicate(var/amount)
	if(health < maxHealth) // Mend the damage
		health = min(health + amount * 3, maxHealth)
		if(health == maxHealth)
			visible_message("[src] looks fully repaired." )
	else // Reinforce
		silicate = min(silicate + amount, 100)
		updateSilicate()

/obj/structure/window/proc/updateSilicate()
	if (is_full_window())
		return
	if (overlays)
		overlays.Cut()

	var/image/img = image(src.icon, src.icon_state)
	img.color = "#ffffff"
	img.alpha = silicate * 255 / 100
	overlays += img

//Setting the explode var makes the shattering louder and more violent, possibly injuring surrounding mobs
/obj/structure/window/proc/shatter(var/display_message = 1, var/explode = FALSE)
	alpha = 0
	if (explode)
		playsound(src, "shatter", 100, 1, 5,5)
	else
		playsound(src, "shatter", 70, 1)

	//Cache a list of nearby turfs for throwing shards at
	var/list/turf/nearby
	if (explode)
		nearby = (RANGE_TURFS(2, src) - get_turf(src))
	else
		nearby = (RANGE_TURFS(1, src) - get_turf(src))

	if(display_message)
		visible_message("[src] shatters!")
	if(is_full_window())
		var/index = null
		index = 0
		if(reinf)
			new /obj/item/stack/rods(loc)
		while(index < rand(4,6))
			var/obj/item/material/shard/S = new shardtype(loc)
			if (nearby.len > 0)
				var/turf/target = pick(nearby)
				//spawn()
				S.throw_at(target,40,3)
			index++
	else
		new shardtype(loc) //todo pooling?
		if(reinf)
			new /obj/item/stack/rods(loc)
	qdel(src)
	return


/obj/structure/window/bullet_act(var/obj/item/projectile/Proj)

	if(config.z_level_shooting && Proj.height)
		if(Proj.height == HEIGHT_LOW)// Bullet is too low
			return TRUE
		else if(Proj.height == HEIGHT_HIGH) // Guaranteed hit
			var/proj_damage = Proj.get_structure_damage()
			if(proj_damage)
				hit(proj_damage)
			..()
			return TRUE

	var/targetzone = check_zone(Proj.def_zone)
	if(targetzone in list(BP_CHEST, BP_HEAD, BP_L_ARM, BP_R_ARM))
		var/proj_damage = Proj.get_structure_damage()
		if(proj_damage)
			hit(proj_damage)
		..()

	return TRUE


//TODO: Make full windows a separate type of window.
//Once a full window, it will always be a full window, so there's no point
//having the same type for both.
/obj/structure/window/proc/is_full_window()
	return (dir == SOUTHWEST || dir == SOUTHEAST || dir == NORTHWEST || dir == NORTHEAST)

/obj/structure/window/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return 1
	if(is_full_window())
		return 0	//full tile window, you can't move into it!
	if(get_dir(loc, target) & dir)
		return !density
	else
		return 1


/obj/structure/window/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSGLASS))
		return 1
	if(get_dir(O.loc, target) == dir)
		return !density
	return 1


/obj/structure/window/hitby(AM as mob|obj)
	..()
	if(isliving(AM))
		hit_by_living(AM)
		return
	visible_message(SPAN_DANGER("[src] was hit by [AM]."))
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else if(isobj(AM))
		var/obj/item/I = AM
		tforce = I.throwforce
	if(reinf) tforce *= 0.25
	if(hit(tforce) && health <= 7 && !reinf)
		set_anchored(FALSE)
		step(src, get_dir(AM, src))
	mount_check()

/obj/structure/window/attack_tk(mob/user as mob)
	user.visible_message(SPAN_NOTICE("Something knocks on [src]."))
	playsound(loc, 'sound/effects/Glasshit.ogg', 50, 1)

/obj/structure/window/attack_hand(mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if (user.a_intent == I_HURT)

		if (ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.species.can_shred(H))
				attack_generic(H,25)
				return
		playsound(get_turf(src), 'sound/effects/glassknock.ogg', 100, 1, 10, 10)
		user.do_attack_animation(src)
		user.visible_message(SPAN_DANGER("\The [user] bangs against \the [src]!"),
							SPAN_DANGER("You bang against \the [src]!"),
							"You hear a banging sound.")
	else
		playsound(get_turf(src), 'sound/effects/glassknock.ogg', 80, 1, 5, 5)
		user.visible_message("[user.name] knocks on the [src.name].",
							"You knock on the [src.name].",
							"You hear a knocking sound.")
	return

/obj/structure/window/attack_generic(var/mob/user, var/damage)
	if(istype(user))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.do_attack_animation(src)
	if(damage >= resistance)
		visible_message(SPAN_DANGER("[user] smashes into [src]!"))
		hit(damage)
	else
		visible_message(SPAN_NOTICE("\The [user] bonks \the [src] harmlessly."))
		playsound(get_turf(src), 'sound/effects/glasshit.ogg', 40, 1)
		return
	return 1

/obj/structure/window/affect_grab(mob/living/user, mob/living/target, state)
	target.do_attack_animation(src, FALSE) //This is to visually create the appearance of the victim being bashed against the window
	// so they don't insta spam it
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	//So we pass false on the use_item flag so it doesn't look like they hit the window with something
	// clamped between 3 times and a third of the effects
	// it takes the grabber's rob , adds 1 so it can't be 0
	var/grabberRob = user.stats.getStat(STAT_ROB, FALSE) == 0 ? 1 : user.stats.getStat(STAT_ROB, FALSE)
	var/targetTgh = target.stats.getStat(STAT_TGH, FALSE) == 0 ? 1 : target.stats.getStat(STAT_TGH, FALSE)
	var/windowResistance = resistance ? resistance : 1
	// get them positive (and add to one side if the other is negative)
	if(grabberRob < 0 && targetTgh < 0)
		grabberRob = abs(grabberRob)
		targetTgh = abs(targetTgh)
	else if(grabberRob > 0 && targetTgh < 0)
		targetTgh = abs(targetTgh)
		grabberRob += targetTgh
	else if(grabberRob < 0 && targetTgh > 0)
		grabberRob = abs(grabberRob)
		targetTgh += grabberRob
	var/skillRatio = clamp(grabberRob  / targetTgh , 0.3 , 3)
	var/toughTarget = target.stats.getPerk(PERK_ASS_OF_CONCRETE) ? TRUE : FALSE
	switch(state)
		if(GRAB_PASSIVE)
			visible_message(SPAN_WARNING("[user] slams [target] against \the [src]!"))
			// having ass of concrete divides damage by 3
			// max damage can be 30 without armor, and gets mitigated by having 15 melee armor
			target.damage_through_armor(round(10 * skillRatio * (health/maxHealth) / (toughTarget ? 3 : 1)), BRUTE, BP_HEAD, ARMOR_MELEE, sharp = FALSE, armor_divisor = 0.5)
			if(!toughTarget)
				target.stats.addTempStat(STAT_VIG, -STAT_LEVEL_ADEPT, 8 SECONDS, "window_smash")
			hit(round(target.mob_size * skillRatio * (toughTarget ? 2 : 1 ) / windowResistance))
		if(GRAB_AGGRESSIVE)
			visible_message(SPAN_DANGER("[user] bashes [target] against \the [src]!"))
			// attacker has double the victim's toughness (altough cap it at 1 second max after they chain it)
			if(skillRatio > 2 && !(target.weakened || toughTarget))
				visible_message(SPAN_DANGER("<big>[target] gets staggered by [user]'s smash against \the [src]!</big>"))
				target.Weaken(1)
			target.stats.addTempStat(STAT_VIG, -STAT_LEVEL_ADEPT * 1.5, toughTarget ? 6 SECONDS : 12 SECONDS, "window_smash")
			// at most 60 without armor , 23 with 15 melee armor
			target.damage_through_armor(round(20 * skillRatio * health/maxHealth / (toughTarget ? 3 : 1)), BRUTE, BP_HEAD, ARMOR_MELEE, sharp = FALSE, armor_divisor = 0.4)
			hit(round(target.mob_size * skillRatio * 1.5 * (toughTarget ? 2 : 1) / windowResistance))
		if(GRAB_NECK)
			visible_message(SPAN_DANGER("<big>[user] crushes [target] against \the [src]!</big>"))
			// at most 90 damage without armor, 40 with 15 melee armor
			target.damage_through_armor(round(30 * skillRatio * health/maxHealth / (toughTarget ? 3 : 1)), BRUTE, BP_HEAD, ARMOR_MELEE, sharp = FALSE, armor_divisor = 0.3)
			target.stats.addTempStat(STAT_VIG, -STAT_LEVEL_ADEPT * 2, toughTarget ? 10 SECONDS : 20 SECONDS, "window_smash")
			hit(round(target.mob_size * skillRatio * 2 * ((toughTarget ? 2 : 1)) / windowResistance))
	admin_attack_log(user, target,
		"Smashed [key_name(target)] against \the [src]",
		"Smashed against \the [src] by [key_name(user)]",
		"smashed [key_name(target)] against \the [src]."
	)
	end_grab_onto(user, target)
	return TRUE

proc/end_grab_onto(mob/living/user, mob/living/target)
	for(var/obj/item/grab/G in list(user.l_hand, user.r_hand))
		if(G.affecting == target)
			qdel(G)
			break

/obj/structure/window/proc/hit_by_living(mob/living/M)
	var/body_part = pick(BP_HEAD, BP_CHEST, BP_GROIN)
	var/direction = get_dir(M, src)
	var/tforce = M.mob_size
	visible_message(SPAN_DANGER("[M] slams against \the [src]!"))
	// being super tough has its perks!
	if(!M.stats.getPerk(PERK_ASS_OF_CONCRETE))
		var/victimToughness = M.stats.getStat(STAT_TGH, FALSE)
		victimToughness = victimToughness ? victimToughness : 1
		var/windowResistance = resistance ? resistance : 1
		var/healthRatio = health/maxHealth
		// you shall suffer for being negative on toughness , it becomes negative so it cancels the negative toughness
		var/toughnessDivisor = victimToughness > 0 ? STAT_VALUE_MAXIMUM : -(STAT_VALUE_MAXIMUM - victimToughness)
		// if you less tougher and less sized than the window itself and its health , you are more likely to suffer more
		if(victimToughness * M.mob_size / toughnessDivisor < windowResistance * healthRatio)
			M.adjustHalLoss(5)
			M.Weaken(2)
			// 40 in worst case, 10 with 15 melee armor
			M.damage_through_armor(40 * (1 - victimToughness/toughnessDivisor) * healthRatio, BRUTE, body_part, ARMOR_MELEE, sharp = FALSE, armor_divisor = 0.5)
		else
			M.adjustHalLoss(3)
			// 20 in worst  case , 5 with 15 melee armor
			M.damage_through_armor(20 * (1 - victimToughness/toughnessDivisor) * healthRatio, BRUTE, body_part, ARMOR_MELEE, sharp = FALSE)
	else
		M.damage_through_armor(5, BRUTE, body_part, ARMOR_MELEE) // just a scratch
		tforce *= 2

	if(reinf) tforce *= 0.25
	if(hit(tforce) && health <= 7 && !reinf)
		set_anchored(FALSE)
		step(src, direction)
		if(M.stats.getPerk(PERK_ASS_OF_CONCRETE)) //if your ass is heavy and the window is not reinforced, you are moved on the tile where it was
			M.forceMove(get_step(M.loc, direction), direction)
	mount_check()

/obj/structure/window/attackby(obj/item/I, mob/user)

	var/list/usable_qualities = list()
	if(!anchored && (!state || !reinf))
		usable_qualities.Add(QUALITY_BOLT_TURNING)
	if((reinf && state >= 1) || (reinf && state == 0) || (!reinf))
		usable_qualities.Add(QUALITY_SCREW_DRIVING)
	if(reinf && state <= 1)
		usable_qualities.Add(QUALITY_PRYING)
	if (health < maxHealth)
		usable_qualities.Add(QUALITY_SEALING)

	//If you set intent to harm, you can hit the window with tools to break it. Set to any other intent to use tools on it
	if (usr.a_intent != I_HURT)
		var/tool_type = I.get_tool_type(user, usable_qualities, src)
		switch(tool_type)
			if(QUALITY_SEALING)
				user.visible_message("[user] starts sealing up cracks in [src] with the [I]", "You start sealing up cracks in [src] with the [I]")
				if (I.use_tool(user, src, 60 + ((maxHealth - health)*3), QUALITY_SEALING, FAILCHANCE_NORMAL, STAT_MEC))
					to_chat(user, SPAN_NOTICE("The [src] looks pretty solid now!"))
					health = maxHealth
			if(QUALITY_BOLT_TURNING)
				if(!anchored && (!state || !reinf))
					if(!glasstype)
						to_chat(user, SPAN_NOTICE("You're not sure how to dismantle \the [src] properly."))
						return
					if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
						visible_message(SPAN_NOTICE("[user] dismantles \the [src]."))
						var/obj/glass
						if(is_fulltile())
							glass = new glasstype(loc, 6)
						else
							glass = new glasstype(loc, 1)
						glass.add_fingerprint(user)

						qdel(src)
						return
				return 1 //No whacking the window with tools unless harm intent

			if(QUALITY_PRYING)
				if(reinf && state <= 1)
					if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
						state = 1 - state
						to_chat(user, (state ? SPAN_NOTICE("You have pried the window into the frame.") : SPAN_NOTICE("You have pried the window out of the frame.")))
				return 1 //No whacking the window with tools unless harm intent


			if(QUALITY_SCREW_DRIVING)
				if(reinf && state >= 1)
					if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
						state = 3 - state
						update_nearby_icons()
						to_chat(user, (state == 1 ? SPAN_NOTICE("You have unfastened the window from the frame.") : SPAN_NOTICE("You have fastened the window to the frame.")))
						return
				if(reinf && state == 0)
					if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
						set_anchored(!anchored)
						to_chat(user, (anchored ? SPAN_NOTICE("You have fastened the frame to the floor.") : SPAN_NOTICE("You have unfastened the frame from the floor.")))
						return
				if(!reinf)
					if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY))
						set_anchored(!anchored)
						to_chat(user, (anchored ? SPAN_NOTICE("You have fastened the window to the floor.") : SPAN_NOTICE("You have unfastened the window.")))
						return
				return 1 //No whacking the window with tools unless harm intent

			if(ABORT_CHECK)
				return

	if(!istype(I)) return//I really wish I did not need this
	if(I.flags & NOBLUDGEON) return

	else
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		if(I.damtype == BRUTE || I.damtype == BURN)
			user.do_attack_animation(src)
			hit(I.force*I.structure_damage_factor)
			if(health <= 7)
				set_anchored(FALSE)
				step(src, get_dir(user, src))
		else
			playsound(loc, 'sound/effects/Glasshit.ogg', 75, 1)
		..()
	return

/obj/structure/window/proc/hit(damage, sound_effect = TRUE, ignore_resistance = FALSE)
	damage = take_damage(damage, TRUE, ignore_resistance)
	if(sound_effect && loc) // If the window was shattered and, thus, nullspaced, don't try to play hit sound
		playsound(loc, 'sound/effects/glasshit.ogg', damage*4.5, 1, damage*0.6, damage*0.6) //The harder the hit, the louder and farther travelling the sound
	return damage


/obj/structure/window/proc/rotate()
	set name = "Rotate Window Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(anchored)
		to_chat(usr, "It is fastened to the floor therefore you can't rotate it!")
		return 0

	update_nearby_tiles(need_rebuild=1) //Compel updates before
	set_dir(turn(dir, 90))
	updateSilicate()
	update_nearby_tiles(need_rebuild=1)
	return


/obj/structure/window/proc/revrotate()
	set name = "Rotate Window Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(anchored)
		to_chat(usr, "It is fastened to the floor therefore you can't rotate it!")
		return 0

	update_nearby_tiles(need_rebuild=1) //Compel updates before
	set_dir(turn(dir, 270))
	updateSilicate()
	update_nearby_tiles(need_rebuild=1)
	return

/obj/structure/window/New(Loc, start_dir=null)
	..()

	//player-constructed windows

	if (start_dir)
		set_dir(start_dir)

	health = maxHealth

	ini_dir = dir

	update_nearby_tiles(need_rebuild=1)
	update_nearby_icons()

/obj/structure/window/Created()
	set_anchored(FALSE)


/obj/structure/window/Destroy()
	density = FALSE
	update_nearby_tiles()
	var/turf/location = loc
	loc = null
	for(var/obj/structure/window/W in orange(location, 1))
		W.update_icon()
	loc = location
	. = ..()

/obj/structure/window/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, var/glide_size_override = 0)
	var/ini_dir = dir
	update_nearby_tiles(need_rebuild=1)
	. = ..()
	set_dir(ini_dir)
	update_nearby_tiles(need_rebuild=1)
	mount_check()

//checks if this window is full-tile one
/obj/structure/window/proc/is_fulltile()
	if(dir & (dir - 1))
		return 1
	return 0

/obj/structure/window/set_anchored(new_anchored)
	. = ..()
	if(!.)
		return FALSE
	update_verbs()
	update_nearby_icons()

//This proc is used to update the icons of nearby windows. It should not be confused with update_nearby_tiles(), which is an atmos proc!
/obj/structure/window/proc/update_nearby_icons()
	update_icon()
	for(var/obj/structure/window/W in orange(src, 1))
		W.update_icon()

//Updates the availabiliy of the rotation verbs
/obj/structure/window/proc/update_verbs()
	if(anchored)
		verbs -= /obj/structure/window/proc/rotate
		verbs -= /obj/structure/window/proc/revrotate
	else
		verbs += /obj/structure/window/proc/rotate
		verbs += /obj/structure/window/proc/revrotate

//merges adjacent full-tile windows into one (blatant ripoff from game/smoothwall.dm)
/obj/structure/window/update_icon()
	//A little cludge here, since I don't know how it will work with slim windows. Most likely VERY wrong.
	//this way it will only update full-tile ones
	overlays.Cut()
	if(!is_fulltile())
		icon_state = "[basestate]"
		return
	/*
	var/list/dirs = list()
	if(anchored)
		for(var/obj/structure/window/W in orange(src,1))
			if(W.anchored && W.density && W.type == src.type && W.is_fulltile()) //Only counts anchored, not-destroyed fill-tile windows.
				dirs += get_dir(src, W)

	for(var/turf/simulated/wall/T in RANGE_TURFS(1, src) - src)
		var/T_dir = get_dir(src, T)
		dirs |= T_dir
		if(propagate)
			spawn(0)
				T.update_connections()
				T.update_icon()
	*/
	//Since fulltile windows can't exist without an underlying wall, we will just copy connections from our wall
	var/list/connections = list("0", "0", "0", "0")
	var/obj/structure/low_wall/LW = (locate(/obj/structure/low_wall) in loc)
	if (istype(LW))
		connections = LW.connections

	icon_state = ""
	for(var/i = 1 to 4)
		var/image/I = image(icon, "[basestate][connections[i]]", dir = 1<<(i-1))
		overlays += I

	return

/obj/structure/window/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > maximal_heat)
		hit(damage_per_fire_tick, TRUE, TRUE)
	..()



/obj/structure/window/basic
	desc = "It looks thin and flimsy. A few knocks with... anything, really should shatter it."
	icon_state = "window"
	basestate = "window"
	glasstype = /obj/item/stack/material/glass
	maximal_heat = T0C + 200	// Was 100. Spaceship windows surely surpass coffee pots.
	damage_per_fire_tick = 3	// Was 2. Made weaker than rglass per tick.
	maxHealth = 15
	resistance = RESISTANCE_FLIMSY

/obj/structure/window/basic/full
	dir = SOUTH|EAST
	icon = 'icons/obj/structures/windows.dmi'
	icon_state = "fwindow"
	alpha = 120
	maxHealth = 40
	resistance = RESISTANCE_FLIMSY
	flags = null

/obj/structure/window/plasmabasic
	name = "plasma window"
	desc = "A borosilicate alloy window. It seems to be quite strong."

	icon_state = "plasmawindow"
	shardtype = /obj/item/material/shard/plasma
	glasstype = /obj/item/stack/material/glass/plasmaglass
	maximal_heat = T0C + 5227  // Safe use temperature at 5500 kelvin. Easy to remember.
	damage_per_fire_tick = 1.5 // Lowest per-tick damage so overheated supermatter chambers have some time to respond to it. Will still shatter before a delam.
	maxHealth = 150
	resistance = RESISTANCE_AVERAGE

/obj/structure/window/plasmabasic/full
	dir = SOUTH|EAST
	icon = 'icons/obj/structures/windows.dmi'
	basestate = "pwindow"
	icon_state = "plasmawindow_mask"
	alpha = 150
	maxHealth = 200
	resistance = RESISTANCE_AVERAGE
	flags = null

/obj/structure/window/reinforced
	name = "reinforced window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon_state = "rwindow"
	basestate = "rwindow"
	reinf = 1
	maximal_heat = T0C + 750	// Fused quartz.
	damage_per_fire_tick = 2
	glasstype = /obj/item/stack/material/glass/reinforced

	maxHealth = 50
	resistance = RESISTANCE_FRAGILE

/obj/structure/window/New(Loc, constructed=0)
	..()

	//player-constructed windows
	if (constructed)
		state = 0

/obj/structure/window/reinforced/full
	dir = SOUTH|EAST
	icon = 'icons/obj/structures/windows.dmi'
	icon_state = "fwindow"
	alpha = 150
	maxHealth = 80
	resistance = RESISTANCE_FRAGILE
	flags = null

/obj/structure/window/reinforced/plasma
	name = "reinforced plasma window"
	desc = "A borosilicate alloy window, with rods supporting it. It seems to be very strong."
	basestate = "plasmarwindow"
	icon_state = "plasmarwindow"
	shardtype = /obj/item/material/shard/plasma
	glasstype = /obj/item/stack/material/glass/plasmarglass
	maximal_heat = T0C + 5453 // Safe use temperature at 6000 kelvin.
	damage_per_fire_tick = 1.5
	maxHealth = 200
	resistance = RESISTANCE_IMPROVED

/obj/structure/window/reinforced/plasma/full
	dir = SOUTH|EAST
	icon = 'icons/obj/structures/windows.dmi'
	basestate = "rpwindow"
	icon_state = "plasmarwindow_mask"
	alpha = 150
	maxHealth = 250
	resistance = RESISTANCE_IMPROVED
	flags = null

/obj/structure/window/reinforced/tinted
	name = "tinted window"
	desc = "It looks rather strong and opaque. Might take a few good hits to shatter it."
	icon_state = "twindow"
	basestate = "twindow"
	opacity = 1

/obj/structure/window/reinforced/tinted/frosted
	name = "frosted window"
	desc = "It looks rather strong and frosted over. Looks like it might take a few less hits then a normal reinforced window."
	icon_state = "fwindow"
	basestate = "fwindow"

/obj/structure/window/shuttle
	name = "shuttle window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon = 'icons/obj/podwindows.dmi'
	icon_state = "window"
	basestate = "window"
	maxHealth = 300
	resistance = RESISTANCE_IMPROVED
	reinf = 1
	basestate = "w"
	dir = 5

/obj/structure/window/reinforced/polarized
	name = "electrochromic window"

	desc = "Adjusts its tint with voltage. Might take a few good hits to shatter it."
	var/id

/obj/structure/window/reinforced/polarized/full
	dir = SOUTH|EAST
	icon = 'icons/obj/structures/windows.dmi'
	icon_state = "fwindow"
	flags = null

/obj/structure/window/reinforced/polarized/proc/toggle()
	if(opacity)
		animate(src, color="#FFFFFF", time=5)
		set_opacity(0)
		alpha = initial(alpha)
	else
		animate(src, color="#222222", time=5)
		set_opacity(1)
		alpha = 255

/obj/structure/window/reinforced/crescent/attack_hand()
	return

/obj/structure/window/reinforced/crescent/attackby()
	return

/obj/structure/window/reinforced/crescent/explosion_act(target_power, explosion_handler/handler)
	return target_power

/obj/structure/window/reinforced/crescent/hitby()
	return

/obj/structure/window/reinforced/crescent/take_damage()
	return

/obj/structure/window/reinforced/crescent/shatter()
	return

/obj/machinery/button/windowtint
	name = "window tint control"
	icon = 'icons/obj/power.dmi'
	icon_state = "light0"
	desc = "A remote control switch for polarized windows."
	var/range = 7

/obj/machinery/button/windowtint/attack_hand(mob/user as mob)
	if(..())
		return 1

	toggle_tint()

/obj/machinery/button/windowtint/proc/toggle_tint()
	use_power(5)

	active = !active
	update_icon()

	for(var/obj/structure/window/reinforced/polarized/W in range(src,range))
		if (W.id == src.id || !W.id)
			W.toggle()
			return

/obj/machinery/button/windowtint/power_change()
	..()
	if(active && !powered(power_channel))
		toggle_tint()

/obj/machinery/button/windowtint/update_icon()
	icon_state = "light[active]"


//Fulltile windows can only exist ontop of a low wall
//If they're ever not on a wall, they will drop to the floor and smash.
/obj/structure/window/proc/mount_check()
	if(QDELETED(src))
		return

	if (!is_full_window())
		return

	//If there's a wall under us, we're safe, stop here.
	if (locate(/obj/structure/low_wall) in loc)
		return

	//This is where the fun begins
	//First of all, lets be sure we're on a tile that has a floor
	var/turf/T = get_turf(src)

	//Hole tiles are empty space and openspace. Can't fall here.
	//But if its openspace we'll probably fall through and smash below. fall_impact will handle that
	if (T.is_hole)
		return

	//Check for gravity
	var/area/A = get_area(T)
	if (!A.has_gravity)
		//No gravity, cant fall here
		return


	//We're good, lets do this
	shatterfall()


//Used when the window finds itself no longer on a tile. For example if someone drags it out of the wall
//The window will do a litle animation of falling to the floor, giving them a brief moment to regret their mistake
/obj/structure/window/proc/shatterfall()
	animate(src, pixel_y = -12, time = 7, easing = QUAD_EASING)
	shatter(TRUE, TRUE) //Use explosive shattering, might injure nearby mobs with shards
