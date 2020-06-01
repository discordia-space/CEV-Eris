//generic procs copied from obj/effect/alien
/obj/effect/roach
	name = "roach effect"
	desc = "A cockroach effect."
	icon = 'icons/effects/effects.dmi'
	anchored = 1
	density = 0
	var/health = 5

/obj/effect/roach/attackby(var/obj/item/I, var/mob/user)
	if(I.attack_verb.len)
		visible_message(SPAN_WARNING("\The [src] have been [pick(I.attack_verb)] with \the [I][(user ? " by [user]." : ".")]"))
	else
		visible_message(SPAN_WARNING("\The [src] have been attacked with \the [I][(user ? " by [user]." : ".")]"))

	health -= (I.force / 2.0)
	healthcheck()

/obj/effect/roach/bullet_act(var/obj/item/projectile/Proj)
	..()
	health -= Proj.get_structure_damage()
	healthcheck()

/obj/effect/roach/proc/healthcheck()
	if(health <= 0)
		visible_message(SPAN_WARNING("[src] is squished!"))
		new /obj/effect/decal/cleanable/roach_egg_remains(loc)
		qdel(src)

/obj/effect/roach/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300 + T0C)
		health -= 5
		healthcheck()

/obj/effect/roach/roach_egg
	name = "roach egg"
	desc = "A cockroach egg. It seems to pulse slightly with an inner life."
	icon_state = "roach_egg"
	var/amount_grown = 0

/obj/effect/roach/roach_egg/New(var/location, var/atom/parent)
	pixel_x = rand(3,-3)
	pixel_y = rand(3,-3)
	START_PROCESSING(SSobj, src)
	get_light_and_color(parent)
	..()

/obj/effect/roach/roach_egg/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(istype(loc, /obj/item/organ/external)) // In case the egg is still inside an organ
		var/obj/item/organ/external/O = loc
		O.implants -= src

	. = ..()

/obj/effect/roach/roach_egg/Process()
	amount_grown += rand(0,2)
	if(amount_grown >= 100)
		var/obj/item/organ/external/O = null
		if(istype(loc, /obj/item/organ/external)) // In case you want to implant some roach eggs into someone, gross!
			O = loc
			src.visible_message(SPAN_WARNING("A roachling makes its way out of [O.owner ? "[O.owner]\'s [O.name]" : "\the [O]"]!"))
			if(O.owner)
				O.owner.apply_damage(1, BRUTE, O.organ_tag, used_weapon = src)
			O.implants -= src // Remove from implants and spawn the roachling on the ground
			src.loc = O.owner ? O.owner.loc : O.loc

		var/spawn_type = /mob/living/carbon/superior_animal/roach/roachling
		new spawn_type(src.loc, src)
		qdel(src)

/obj/effect/decal/cleanable/roach_egg_remains
	name = "roach egg remains"
	desc = "Green squishy mess."
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenshatter"
