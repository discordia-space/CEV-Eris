//generic procs copied from obj/effect/alien
/obj/item/roach_egg
	name = "roach egg"
	desc = "A cockroach egg, can be eaten with proper preparation. It seems to pulse slightly with an inner life."
	icon = 'icons/effects/effects.dmi'
	icon_state = "roach_egg"
	preloaded_reagents = list("egg" = 9, "blattedin" = 3)
	volumeClass = ITEM_SIZE_TINY
	health = 5
	var/amount_grown = 0

/obj/item/roach_egg/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(istype(O,/obj/machinery/microwave))
		return ..()
	if(!proximity || !O.is_refillable())
		return
	to_chat(user, "You crack \the [src] into \the [O].")
	reagents.trans_to(O, reagents.total_volume)
	user.drop_from_inventory(src)
	qdel(src)

/obj/item/roach_egg/attackby(var/obj/item/I, var/mob/user)
	if(I.attack_verb.len)
		visible_message(SPAN_WARNING("\The [src] have been [pick(I.attack_verb)] with \the [I][(user ? " by [user]." : ".")]"))
	else
		visible_message(SPAN_WARNING("\The [src] have been attacked with \the [I][(user ? " by [user]." : ".")]"))

	health -= (dhTotalDamageStrict(I.melleDamages, ALL_ARMOR,  list(BRUTE,BURN)) / 2)
	healthcheck()

/obj/item/roach_egg/bullet_act(var/obj/item/projectile/Proj)
	..()
	health -= Proj.get_structure_damage()
	healthcheck()

/obj/item/roach_egg/proc/healthcheck()
	if(health <= 0)
		visible_message(SPAN_WARNING("[src] is squished!"))
		new /obj/effect/decal/cleanable/roach_egg_remains(loc)
		qdel(src)

/obj/item/roach_egg/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300 + T0C)
		health -= 5
		healthcheck()



/obj/item/roach_egg/New(var/location, var/atom/parent)
	pixel_x = rand(3,-3)
	pixel_y = rand(3,-3)
	START_PROCESSING(SSobj, src)
	get_light_and_color(parent)
	..()

/obj/item/roach_egg/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(istype(loc, /obj/item/organ/external)) // In case the egg is still inside an organ
		var/obj/item/organ/external/O = loc
		O.implants -= src

	. = ..()

/obj/item/roach_egg/Process()	
	if (isturf(src.loc) || istype(src.loc, /obj/structure/closet) || istype(src.loc, /obj/item/organ/external)) // suppresses hatching when not in a suitable loc
		if(amount_grown >= 100)
			var/obj/item/organ/external/O
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
		else
			amount_grown += rand(0,2)

/obj/effect/decal/cleanable/roach_egg_remains
	name = "roach egg remains"
	desc = "Green squishy mess."
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenshatter"
