/obj/item/projectile/ion
	name = "ion bolt"
	icon_state = "ion"
	damage_types = list(BURN = 0)
	nodamage = TRUE
	check_armour = ARMOR_ENERGY
	recoil = 5

/obj/item/projectile/ion/on_hit(atom/target)
	empulse(target, 1, 1)
	return TRUE

/obj/item/projectile/bullet/gyro
	name = "explosive bolt"
	icon_state = "bolter"
	damage_types = list(BRUTE = 50)
	check_armour = ARMOR_BULLET
	sharp = TRUE
	edge = TRUE
	recoil = 3
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASMA = 1)

/obj/item/projectile/bullet/gyro/on_hit(atom/target)
	explosion(get_turf(target), 100, 50)
	matter [MATERIAL_PLASMA] = 0
	return TRUE

/obj/item/projectile/bullet/rocket
	name = "high explosive rocket"
	icon_state = "rocket"
	damage_types = list(BRUTE = 80)
	armor_divisor = 3 // Everything has ridiculously high bomb armor. This makes up for it.
	check_armour = ARMOR_BOMB
	penetrating = -5
	recoil = 40
	can_ricochet = FALSE
	var/explosion_power = 350
	var/explosion_falloff = 75
	sharp = FALSE
	edge = FALSE
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTEEL = 3, MATERIAL_PLASMA = 2) // as it is caseless, the 'bullet' holds the entire cost.

/obj/item/projectile/bullet/rocket/launch(atom/target, target_zone, x_offset, y_offset, angle_offset, proj_sound, user_recoil)
	set_light(2.5, 0.5, "#dddd00")
	..(target, target_zone, x_offset, y_offset, angle_offset, proj_sound, user_recoil)

/obj/item/projectile/bullet/rocket/on_hit(atom/target)
	detonate(target)
	matter [MATERIAL_PLASMA] = 0
	set_light(0)
	return TRUE

/obj/item/projectile/bullet/rocket/proc/detonate(atom/target)
	explosion(get_turf(target), explosion_power, explosion_falloff)

/obj/item/projectile/bullet/rocket/scrap
	name = "improvised explosive rocket"
	damage_types = list(BRUTE = 60)

	explosion_power = 200
	explosion_falloff = 75
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASMA = 2) // as it is caseless, the 'bullet' holds the entire cost.

/obj/item/projectile/bullet/rocket/hesh
	name = "high-explosive squash head rocket"
	damage_types = list(BRUTE = 80)
	armor_divisor = 2
	check_armour = ARMOR_BULLET
	sharp = TRUE

	explosion_power = 200
	explosion_falloff = 75

/obj/item/projectile/bullet/rocket/hesh/detonate(atom/target)
	fragment_explosion_angled(get_turf(src), starting, /obj/item/projectile/bullet/pellet/fragment/strong, 20)
	..()

/obj/item/projectile/bullet/rocket/heat
	name = "high-explosive anti-tank rocket"
	damage_types = list(BRUTE = 20)
	armor_divisor = 1
	check_armour = ARMOR_BULLET
	sharp = TRUE

	explosion_power = 200
	explosion_falloff = 75

/obj/item/projectile/bullet/rocket/heat/detonate(atom/target)
	var/turf/T = get_turf_away_from_target_complex(get_turf(src), starting, 3)
	var/obj/item/projectile/forcebolt/jet/P = new(get_turf(src))
	P.launch(T, def_zone)
	if(target)
		P.Bump(target, TRUE)
	..()

/obj/item/projectile/bullet/rocket/thermo
	name = "thermobaric rocket"
	damage_types = list(BRUTE = 20)
	armor_divisor = 1
	check_armour = ARMOR_BULLET

	explosion_power = 300
	explosion_falloff = 30 // Very large, albeit weak explosion

/obj/item/projectile/bullet/rocket/thermo/detonate(atom/target)
	heatwave(get_turf(src), 3, 5, 100, TRUE, 20)
	..()

/obj/item/projectile/temp
	name = "freeze beam"
	icon_state = "ice_2"
	damage_types = list(BURN = 0)
	nodamage = 1
	check_armour = ARMOR_ENERGY
	var/temperature = 300


/obj/item/projectile/temp/on_hit(atom/target)//These two could likely check temp protection on the mob
	if(isliving(target))
		var/mob/M = target
		M.bodytemperature = temperature
	return TRUE

/obj/item/projectile/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "smallf"
	damage_types = list(BRUTE = 0)
	nodamage = TRUE
	check_armour = ARMOR_BULLET

/obj/item/projectile/meteor/Bump(atom/A as mob|obj|turf|area, forced)
	if(A == firer)
		loc = A.loc
		return


	if(src)//Do not add to this if() statement, otherwise the meteor won't delete them
		if(A)

			A.explosion_act(500, null)
			playsound(src.loc, 'sound/effects/meteorimpact.ogg', 40, 1)

			for(var/mob/M in range(10, src))
				if(!M.stat && !isAI(M))
					shake_camera(M, 3, 1)
			qdel(src)
			return TRUE
	else
		return FALSE

/obj/item/projectile/energy/floramut
	name = "alpha somatoray"
	icon_state = "energy"
	damage_types = list(TOX = 0)
	nodamage = TRUE
	check_armour = ARMOR_ENERGY

/obj/item/projectile/energy/floramut/on_hit(atom/target)
	var/mob/living/M = target
	if(ishuman(target))
		var/mob/living/carbon/human/H = M
		if((H.species.flags & IS_PLANT) && (H.nutrition < 500))
			if(prob(15))
				H.apply_effect((rand(30,80)),IRRADIATE)
				H.Weaken(5)
				for (var/mob/V in viewers(src))
					V.show_message("\red [M] writhes in pain as \his vacuoles boil.", 3, "\red You hear the crunching of leaves.", 2)
			else
				M.adjustFireLoss(rand(5,15))
				M.show_message("\red The radiation beam singes you!")
	else if(istype(target, /mob/living/carbon/))
		M.show_message("\blue The radiation beam dissipates harmlessly through your body.")
	else
		return 1

/obj/item/projectile/energy/florayield
	name = "beta somatoray"
	icon_state = "energy2"
	damage_types = list(TOX = 0)
	nodamage = TRUE
	check_armour = ARMOR_ENERGY

/obj/item/projectile/energy/florayield/on_hit(atom/target)
	var/mob/M = target
	if(ishuman(target)) //These rays make plantmen fat.
		var/mob/living/carbon/human/H = M
		if((H.species.flags & IS_PLANT) && (H.nutrition < 500))
			H.adjustNutrition(30)
	else if (istype(target, /mob/living/carbon/))
		M.show_message("\blue The radiation beam dissipates harmlessly through your body.")
	else
		return 1


/obj/item/projectile/chameleon
	name = "bullet"
	icon_state = "bullet"
	damage_types = list(HALLOSS = 1)
	embed = 0 // nope
	nodamage = TRUE
	muzzle_type = /obj/effect/projectile/bullet/muzzle


/obj/item/projectile/flamer_lob
	name = "blob of fuel"
	icon_state = "fireball"
	damage_types = list(BURN = 20)
	check_armour = ARMOR_MELEE
	var/life = 3


/obj/item/projectile/flamer_lob/New()
	.=..()

/obj/item/projectile/flamer_lob/Move(atom/A)
	.=..()
	life--
	var/turf/T = get_turf(src)
	if(T)
		new/obj/effect/decal/cleanable/liquid_fuel(T, 1 , 1)
		T.hotspot_expose((T20C*2) + 380,500)
	if(!life)
		qdel(src)


/obj/item/projectile/coin
	name = "coin"
	desc = "Keep the change, ya filthy animal."
	damage_types = list(BRUTE = 5)
	embed = 0

/obj/item/projectile/bullet/flare
	name = "flare"
	icon_state = "flare"
	damage_types = list(BRUTE = 24)
	kill_count = 16
	armor_divisor = 1
	step_delay = 2
	eyeblur = 2 // bright light slightly blurs your vision
	luminosity_range = 5
	luminosity_power = 1
	luminosity_color = COLOR_RED
	luminosity_ttl = 1
	var/fire_stacks = 1
	var/flash_range = 1
	var/light_duration = 300
	var/brightness = 10
	knockback = FALSE
	can_ricochet = FALSE
	sharp = FALSE
	embed = FALSE	// plasma is not directly destroyed as projectile does not survive impact
	recoil = 4
	matter = list(MATERIAL_PLASTIC = 0.5, MATERIAL_PLASMA = 1) 

/obj/item/projectile/bullet/flare/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		playsound(src, 'sound/effects/flare.ogg', 100, 1)
		M.adjust_fire_stacks(fire_stacks)
		M.IgniteMob()
		src.visible_message(SPAN_WARNING("\The [src] sets [target] on fire!"))

/obj/item/projectile/bullet/flare/on_impact(var/atom/A)
	var/turf/T = flash_range? src.loc : get_turf(A)
	if(!istype(T)) return

	//blind adjacent people with enhanced vision
	for (var/mob/living/carbon/M in viewers(T, flash_range))
		if(M.eyecheck() < FLASH_PROTECTION_NONE)
			M.flash(0, FALSE , FALSE , FALSE)

	src.visible_message(SPAN_WARNING("\The [src] explodes in a bright light!"))
	new /obj/effect/decal/cleanable/ash(src.loc)
	playsound(src, 'sound/effects/flare.ogg', 100, 1)
	new /obj/effect/effect/smoke/illumination(T, brightness=max(flash_range*3, brightness), lifetime=light_duration, color=COLOR_RED)

