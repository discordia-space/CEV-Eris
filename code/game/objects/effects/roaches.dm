//generic procs copied from obj/effect/alien
/obj/item/roach_egg
	name = "roach egg"
	desc = "A cockroach egg, can be eaten with proper preparation. It seems to pulse slightly with an inner life."
	icon = 'icons/effects/effects.dmi'
	icon_state = "roach_egg"
	preloaded_reagents = list("egg" = 9, "blattedin" = 3)
	w_class = ITEM_SIZE_TINY
	health = 5
	var/amount_grown = 0

/obj/item/roach_egg/afterattack(obj/O as obj,69ob/user as69ob, proximity)
	if(istype(O,/obj/machinery/microwave))
		return ..()
	if(!proximity || !O.is_refillable())
		return
	to_chat(user, "You crack \the 69src69 into \the 69O69.")
	reagents.trans_to(O, reagents.total_volume)
	user.drop_from_inventory(src)
	69del(src)

/obj/item/roach_egg/attackby(var/obj/item/I,69ar/mob/user)
	if(I.attack_verb.len)
		visible_message(SPAN_WARNING("\The 69src69 have been 69pick(I.attack_verb)69 with \the 69I6969(user ? " by 69user69." : ".")69"))
	else
		visible_message(SPAN_WARNING("\The 69src69 have been attacked with \the 69I6969(user ? " by 69user69." : ".")69"))

	health -= (I.force / 2)
	healthcheck()

/obj/item/roach_egg/bullet_act(var/obj/item/projectile/Proj)
	..()
	health -= Proj.get_structure_damage()
	healthcheck()

/obj/item/roach_egg/proc/healthcheck()
	if(health <= 0)
		visible_message(SPAN_WARNING("69src69 is s69uished!"))
		new /obj/effect/decal/cleanable/roach_egg_remains(loc)
		69del(src)

/obj/item/roach_egg/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300 + T0C)
		health -= 5
		healthcheck()



/obj/item/roach_egg/New(var/location,69ar/atom/parent)
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
				src.visible_message(SPAN_WARNING("A roachling69akes its way out of 69O.owner ? "69O.owner69\'s 69O.name69" : "\the 69O69"69!"))
				if(O.owner)
					O.owner.apply_damage(1, BRUTE, O.organ_tag, used_weapon = src)
				O.implants -= src // Remove from implants and spawn the roachling on the ground
				src.loc = O.owner ? O.owner.loc : O.loc

			var/spawn_type = /mob/living/carbon/superior_animal/roach/roachling
			new spawn_type(src.loc, src)
			69del(src)
		else
			amount_grown += rand(0,2)

/obj/effect/decal/cleanable/roach_egg_remains
	name = "roach egg remains"
	desc = "Green s69uishy69ess."
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenshatter"
