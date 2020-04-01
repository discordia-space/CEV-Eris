/obj/item/projectile/ion
	name = "ion bolt"
	icon_state = "ion"
	damage = 0
	damage_type = BURN
	nodamage = TRUE
	check_armour = ARMOR_ENERGY

/obj/item/projectile/ion/on_hit(atom/target)
	empulse(target, 1, 1)
	return TRUE

/obj/item/projectile/bullet/gyro
	name = "explosive bolt"
	icon_state = "bolter"
	damage = 50
	check_armour = ARMOR_BULLET
	sharp = TRUE
	edge = TRUE

/obj/item/projectile/bullet/gyro/on_hit(atom/target)
	explosion(target, -1, 0, 2)
	return TRUE

/obj/item/projectile/bullet/rocket
	name = "high explosive rocket"
	icon_state = "rocket"
	damage = 70
	armor_penetration = 100
	check_armour = ARMOR_BULLET

/obj/item/projectile/bullet/rocket/launch(atom/target, target_zone, x_offset, y_offset, angle_offset)
	set_light(2.5, 0.5, "#dddd00")
	..(target, target_zone, x_offset, y_offset, angle_offset)

/obj/item/projectile/bullet/rocket/on_hit(atom/target)
	explosion(target, 0, 1, 2, 4)
	set_light(0)
	return TRUE

/obj/item/projectile/temp
	name = "freeze beam"
	icon_state = "ice_2"
	damage = 0
	damage_type = BURN
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
	damage = 0
	damage_type = BRUTE
	nodamage = TRUE
	check_armour = ARMOR_BULLET

/obj/item/projectile/meteor/Bump(atom/A as mob|obj|turf|area, forced)
	if(A == firer)
		loc = A.loc
		return

	sleep(-1) //Might not be important enough for a sleep(-1) but the sleep/spawn itself is necessary thanks to explosions and metoerhits

	if(src)//Do not add to this if() statement, otherwise the meteor won't delete them
		if(A)

			A.ex_act(2)
			playsound(src.loc, 'sound/effects/meteorimpact.ogg', 40, 1)

			for(var/mob/M in range(10, src))
				if(!M.stat && !isAI(M))
					shake_camera(M, 3, 1)
			qdel(src)
			return 1
	else
		return 0

/obj/item/projectile/energy/floramut
	name = "alpha somatoray"
	icon_state = "energy"
	damage = 0
	damage_type = TOX
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
			if(prob(35))
				if(prob(80))
					randmutb(M)
					domutcheck(M,null)
				else
					randmutg(M)
					domutcheck(M,null)
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
	damage = 0
	damage_type = TOX
	nodamage = TRUE
	check_armour = ARMOR_ENERGY

/obj/item/projectile/energy/florayield/on_hit(atom/target)
	var/mob/M = target
	if(ishuman(target)) //These rays make plantmen fat.
		var/mob/living/carbon/human/H = M
		if((H.species.flags & IS_PLANT) && (H.nutrition < 500))
			H.nutrition += 30
	else if (istype(target, /mob/living/carbon/))
		M.show_message("\blue The radiation beam dissipates harmlessly through your body.")
	else
		return 1


/obj/item/projectile/beam/mindflayer
	name = "flayer ray"

/obj/item/projectile/beam/mindflayer/on_hit(atom/target)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		M.confused += rand(5,8)

/obj/item/projectile/chameleon
	name = "bullet"
	icon_state = "bullet"
	damage = 1 // stop trying to murderbone with a fake gun dumbass!!!
	embed = 0 // nope
	nodamage = TRUE
	damage_type = HALLOSS
	muzzle_type = /obj/effect/projectile/bullet/muzzle


/obj/item/projectile/flamer_lob
	name = "blob of fuel"
	icon_state = "fireball"
	damage = 20
	damage_type = BURN
	check_armour = ARMOR_MELEE
	var/life = 3


/obj/item/projectile/flamer_lob/New()
	.=..()

/obj/item/projectile/flamer_lob/Move(var/atom/A)
	.=..()
	life--
	var/turf/T = get_turf(src)
	new/obj/effect/decal/cleanable/liquid_fuel(T, 1 , 1)
	T.hotspot_expose((T20C*2) + 380,500)
	if(!life)
		qdel(src)


