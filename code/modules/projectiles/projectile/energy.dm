/obj/item/projectile/energy
	name = "energy"
	icon_state = "spark"
	damage_types = list(BURN = 0)
	check_armour = ARMOR_ENERGY
	mob_hit_sound = list('sound/effects/gore/sear.ogg')
	hitsound_wall = 'sound/weapons/guns/misc/laser_searwall.ogg'

	heat = 100


//releases a burst of light on impact or after travelling a distance
/obj/item/projectile/energy/flash
	name = "chemical shell"
	icon_state = "bullet"
	damage_types = list(BURN = 5, HALLOSS = 10)
	kill_count = 15 //if the shell hasn't hit anything after travelling this far it just explodes.
	var/flash_range = 0
	var/brightness = 7
	var/light_duration = 5

/obj/item/projectile/energy/flash/on_impact(var/atom/A)
	var/turf/T = flash_range? src.loc : get_turf(A)
	if(!istype(T)) return

	//blind adjacent people
	for (var/mob/living/carbon/M in viewers(T, flash_range))
		if(M.eyecheck() < FLASH_PROTECTION_MODERATE)
			M.flash(0, FALSE, FALSE, FALSE)

	//snap pop
	playsound(src, 'sound/effects/snap.ogg', 50, 1)
	src.visible_message(SPAN_WARNING("\The [src] explodes in a bright flash!"))

	new /obj/effect/decal/cleanable/ash(src.loc) //always use src.loc so that ash doesn't end up inside windows
	new /obj/effect/sparks(T)
	new /obj/effect/effect/smoke/illumination(T, brightness=max(flash_range*2, brightness), lifetime=light_duration)

//blinds people like the flash round, but can also be used for temporary illumination
/obj/item/projectile/energy/flash/flare
	damage_types = list(BURN = 10)
	flash_range = 1
	brightness = 9 //similar to a flare
	light_duration = 200
	recoil = 8 // Shot from shotguns
	matter = list(MATERIAL_STEEL = 0.5, MATERIAL_SILVER = 0.5)

/obj/item/projectile/energy/electrode
	name = "electrode"
	icon_state = "spark"
	mob_hit_sound = list('sound/weapons/tase.ogg')
	nodamage = 1
	taser_effect = 1
	damage_types = list(HALLOSS = 40)
	//Damage will be handled on the MOB side, to prevent window shattering.
	recoil = 2

/obj/item/projectile/energy/electrode/stunshot
	name = "stunshot"
	damage_types = list(BURN = 5, HALLOSS = 80)
	taser_effect = 1
	recoil = 5

/obj/item/projectile/energy/declone
	name = "demolecularisor"
	icon_state = "declone"
	damage_types = list(CLONE = 12)
	irradiate = 10


/obj/item/projectile/energy/dart
	name = "dart"
	icon_state = "toxin"
	damage_types = list(TOX = 20)
	recoil = 2

/obj/item/projectile/energy/bolt
	name = "bolt"
	icon_state = "cbbolt"
	damage_types = list(TOX = 20, HALLOSS = 30)
	nodamage = 0
	stutter = 10
	recoil = 3


/obj/item/projectile/energy/bolt/large
	name = "largebolt"
	damage_types = list(BURN = 25)
	recoil = 5

/obj/item/projectile/energy/neurotoxin
	name = "neuro"
	icon_state = "neurotoxin"
	damage_types = list(TOX = 5)
	weaken = 5

/obj/item/projectile/energy/plasma // What?
	name = "plasma bolt"
	icon_state = "energy"
	damage_types = list(TOX = 25)
