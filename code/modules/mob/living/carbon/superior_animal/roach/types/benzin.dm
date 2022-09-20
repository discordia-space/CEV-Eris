/*
/mob/living/carbon/superior_animal/roach/benzin
	name = "Benzin Roach"
	desc = "A monstrous, dog-sized cockroach. This one smells like welding fuel."
	icon_state = "boomroach"
	turns_per_move = 4
	maxHealth = 25
	health = 25
	melee_damage_upper = 3
	meat_type = /obj/item/reagent_containers/food/snacks/meat/roachmeat/benzin
	meat_amount = 3
	rarity_value = 15



/mob/living/carbon/superior_animal/roach/benzin/Initialize(mapload)
	. = ..()
	set_light(0.5)
	reagents.maximum_volume = 40


/mob/living/carbon/superior_animal/roach/benzin/Life()
	if(reagents.total_volume < reagents.maximum_volume)
		reagents.add_reagent("fuel", 1)
	..()


/mob/living/carbon/superior_animal/roach/benzin/adjustToxLoss()
    return


/mob/living/carbon/superior_animal/roach/benzin/bullet_act(obj/item/projectile/P, def_zone)
	. = ..()
	if(prob(80))
		explosion(get_turf(src), -1, -1, 2, 3)


/mob/living/carbon/superior_animal/roach/benzin/attackby(obj/item/I, mob/living/user, params)
	if(user.a_intent == I_HELP && istool(I))
		var/obj/item/tool/T = I
		if(T.use_fuel_cost)
			return FALSE
	. = ..()


/mob/living/carbon/superior_animal/roach/benzin/fire_act()
	if(stat != DEAD)
		explosion(get_turf(src), -1, -1, 2, 3)


/mob/living/carbon/superior_animal/roach/benzin/death()
	. = ..()
	new /obj/effect/decal/cleanable/liquid_fuel(loc, reagents.get_reagent_amount("fuel"), 1)
*/
