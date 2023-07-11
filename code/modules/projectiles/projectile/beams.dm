/obj/item/projectile/beam
	name = "laser"
	icon_state = "laser"
	mob_hit_sound = list('sound/effects/gore/sear.ogg')
	hitsound_wall = 'sound/weapons/guns/misc/laser_searwall.ogg'
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage_types = list(BURN = 30)
	armor_divisor = 1
	check_armour = ARMOR_ENERGY
	eyeblur = 4
	var/frequency = 1
	hitscan = 1
	invisibility = 101	//beam projectiles are invisible as they are rendered by the effect engine
	recoil = 1 // Even less than self-propelled bullets

	muzzle_type = /obj/effect/projectile/laser/muzzle
	tracer_type = /obj/effect/projectile/laser/tracer
	impact_type = /obj/effect/projectile/laser/impact

	heat = 100

/obj/item/projectile/beam/check_penetrate(var/atom/A)
	if(istype(A, /obj/item/shield))
		var/obj/item/shield/S = A
		var/loss = round(S.shield_integrity / 8)
		block_damage(loss, A)
		A.visible_message(SPAN_WARNING("\The [src] is weakened by the \the [A]!"))
		playsound(A.loc, 'sound/weapons/shield/shielddissipate.ogg', 50, 1)
		return 1
	return 0

/obj/item/projectile/beam/cutter
	name = "cutting beam"
	icon_state = "plasmablaster"
	damage_types = list(BRUTE = 25)
	armor_divisor = 1.2
	pass_flags = PASSTABLE

	muzzle_type = /obj/effect/projectile/laser/plasmacutter/muzzle
	tracer_type = /obj/effect/projectile/laser/plasmacutter/tracer
	impact_type = /obj/effect/projectile/laser/plasmacutter/impact

/obj/item/projectile/beam/cutter/on_impact(var/atom/A)
	if(istype(A, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = A
		M.GetDrilled(5)
	.=..()

/obj/item/projectile/beam/practice
	name = "laser"
	icon_state = "laser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage_types = list(BURN = 0)
	check_armour = ARMOR_ENERGY
	eyeblur = 2

/obj/item/projectile/beam/midlaser
	armor_divisor = 1.2

/obj/item/projectile/beam/heavylaser
	name = "heavy laser"
	icon_state = "heavylaser"
	damage_types = list(BURN = 50)
	armor_divisor = 1
	recoil = 3

	muzzle_type = /obj/effect/projectile/laser_heavy/muzzle
	tracer_type = /obj/effect/projectile/laser_heavy/tracer
	impact_type = /obj/effect/projectile/laser_heavy/impact

/obj/item/projectile/beam/psychic
	name = "psychic laser"
	icon_state = "psychic_heavylaser"
	var/obj/item/gun/energy/psychic/holder
	var/contractor = FALSE //Check if it's a contractor psychic beam
	damage_types = list(PSY = 30)
	armor_divisor = ARMOR_PEN_MAX
	recoil = 2

	muzzle_type = /obj/effect/projectile/psychic_laser_heavy/muzzle
	tracer_type = /obj/effect/projectile/psychic_laser_heavy/tracer
	impact_type = /obj/effect/projectile/psychic_laser_heavy/impact

/obj/item/projectile/beam/psychic/launch_from_gun(atom/target, mob/user, obj/item/gun/launcher, target_zone, x_offset=0, y_offset=0, angle_offset)
	holder = launcher
	if(holder && holder.contractor)
		contractor = holder.contractor
	..()

/obj/item/projectile/beam/psychic/heavylaser
	name = "psychic heavy laser"
	icon_state = "psychic_heavylaser"
	damage_types = list(PSY = 40)
	contractor = TRUE
	recoil = 3

	muzzle_type = /obj/effect/projectile/psychic_laser_heavy/muzzle
	tracer_type = /obj/effect/projectile/psychic_laser_heavy/tracer
	impact_type = /obj/effect/projectile/psychic_laser_heavy/impact

/obj/item/projectile/beam/xray
	name = "xray beam"
	icon_state = "xray"
	damage_types = list(BURN = 25)
	armor_divisor = 2.5

	muzzle_type = /obj/effect/projectile/xray/muzzle
	tracer_type = /obj/effect/projectile/xray/tracer
	impact_type = /obj/effect/projectile/xray/impact

/obj/item/projectile/beam/pulse
	name = "pulse"
	icon_state = "u_laser"
	damage_types = list(BURN = 40)
	armor_divisor = 1
	recoil = 5 // Effectively hattons floors and walls

	muzzle_type = /obj/effect/projectile/laser_pulse/muzzle
	tracer_type = /obj/effect/projectile/laser_pulse/tracer
	impact_type = /obj/effect/projectile/laser_pulse/impact

/obj/item/projectile/beam/pulse/on_hit(atom/target)
	if(isturf(target))
		target.explosion_act(100, null)
	..()

/obj/item/projectile/beam/emitter
	name = "emitter beam"
	icon_state = "emitter"
	damage_types = list(BURN = 0)
	recoil = 0

	muzzle_type = /obj/effect/projectile/emitter/muzzle
	tracer_type = /obj/effect/projectile/emitter/tracer
	impact_type = /obj/effect/projectile/emitter/impact

/obj/item/projectile/beam/lastertag/blue
	name = "lasertag beam"
	icon_state = "bluelaser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage_types = list(BURN = 0)
	no_attack_log = 1
	check_armour = ARMOR_ENERGY

	muzzle_type = /obj/effect/projectile/laser_blue/muzzle
	tracer_type = /obj/effect/projectile/laser_blue/tracer
	impact_type = /obj/effect/projectile/laser_blue/impact

/obj/item/projectile/beam/lastertag/blue/on_hit(atom/target)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/redtag))
			M.Weaken(5)
	return 1

/obj/item/projectile/beam/lastertag/red
	name = "lasertag beam"
	icon_state = "laser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage_types = list(BURN = 0)
	no_attack_log = 1
	check_armour = ARMOR_ENERGY

/obj/item/projectile/beam/lastertag/red/on_hit(atom/target)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if(istype(M.wear_suit, /obj/item/clothing/suit/bluetag))
			M.Weaken(5)
	return 1

/obj/item/projectile/beam/lastertag/omni//A laser tag bolt that stuns EVERYONE
	name = "lasertag beam"
	icon_state = "omnilaser"
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	damage_types = list(BURN = 0)
	check_armour = ARMOR_ENERGY

	muzzle_type = /obj/effect/projectile/laser_omni/muzzle
	tracer_type = /obj/effect/projectile/laser_omni/tracer
	impact_type = /obj/effect/projectile/laser_omni/impact

/obj/item/projectile/beam/lastertag/omni/on_hit(atom/target)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		if((istype(M.wear_suit, /obj/item/clothing/suit/bluetag))||(istype(M.wear_suit, /obj/item/clothing/suit/redtag)))
			M.Weaken(5)
	return 1

/obj/item/projectile/beam/sniper
	name = "sniper beam"
	icon_state = "xray"
	damage_types = list(BURN = 60)
	armor_divisor = 2
	stutter = 3
	recoil = 10

	muzzle_type = /obj/effect/projectile/xray/muzzle
	tracer_type = /obj/effect/projectile/xray/tracer
	impact_type = /obj/effect/projectile/xray/impact

/obj/item/projectile/beam/stun
	name = "stun beam"
	icon_state = "stun"
	nodamage = 1
	taser_effect = 1
	damage_types = list(HALLOSS = 30)

	muzzle_type = /obj/effect/projectile/stun/muzzle
	tracer_type = /obj/effect/projectile/stun/tracer
	impact_type = /obj/effect/projectile/stun/impact
