/mob/living/simple_animal/hostile/roomba
	name = "One Star RMB-A unit"
	desc = "A small round drone, usually tasked with carrying out menial tasks. This one seems pretty harmless"
	icon = 'icons/mob/battle_roomba.dmi'
	icon_state = "roomba"
	faction = "onestar"
	attacktext = "bonked"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	speed = 5
	light_range = 3
	light_color = COLOR_LIGHTING_BLUE_BRIGHT
	mob_classification = CLASSIFICATION_SYNTHETIC
	move_to_delay = 9
	health = 20
	maxHealth = 20
	melee_damage_lower = 3
	melee_damage_upper = 7

/mob/living/simple_animal/hostile/roomba/death()
	..()
	visible_message("<b>[src]</b> blows apart!")
	new /obj/effect/decal/cleanable/blood/gibs/robot(src.loc)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)
	return


/mob/living/simple_animal/hostile/roomba/slayer
	name = "One Star RMB-A unit"
	desc = "A small round drone, usually tasked with carrying out menial tasks. This one seems to have a knife taped to it..?"
	icon_state = "roomba_knife"
	health = 30
	maxHealth = 30
	speed = 3
	melee_damage_lower = 5
	melee_damage_upper = 15



/mob/living/simple_animal/hostile/roomba/boomba
	name = "One Star RMB-A unit"
	desc = "A small round drone, usually tasked with carrying out menial tasks. Is that a fucking anti-personel mine?!"
	icon_state = "boomba"
	health = 15
	maxHealth = 15
	speed = 2
	melee_damage_lower = 1
	melee_damage_upper = 2

/mob/living/simple_animal/hostile/roomba/boomba/AttackTarget()
	. = ..()
	if(.) // If we succeeded in hitting.
		src.visible_message(SPAN_DANGER("\The [src] makes an odd warbling noise, fizzles, and explodes!"))
		explosion(get_turf(loc), -1, -1, 2, 3)
		death()

/mob/living/simple_animal/hostile/roomba/gun_ba
	name = "One Star RMB-A unit"
	desc = "A small round drone, usually tasked with carrying out menial tasks. And this one has a gun."
	icon_state = "roomba_lmg"
	health = 25
	maxHealth = 25
	speed = 4
	melee_damage_lower = 10
	melee_damage_upper = 15
	ranged = 1


/obj/random/mob/roomba
	name = "random roomba"
	icon_state = "hostilemob-black"
	alpha = 128

/obj/random/mob/roomba/item_to_spawn()
	return pickweight(list(/mob/living/simple_animal/hostile/roomba = 5,
				/mob/living/simple_animal/hostile/roomba/slayer = 3,
				/mob/living/simple_animal/hostile/roomba/boomba = 1,
				/mob/living/simple_animal/hostile/roomba/gun_ba = 2))
