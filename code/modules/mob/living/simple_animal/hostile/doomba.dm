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
	move_to_delay = 2
	turns_per_move = 5
	minbodytemp = 0
	speed = 4
	light_range = 3
	light_color = COLOR_LIGHTING_BLUE_BRIGHT
	mob_classification = CLASSIFICATION_SYNTHETIC
	projectiletype = /obj/item/projectile/beam/drone
	move_to_delay = 9
	health = 25
	maxHealth = 25
	melee_damage_lower = 5
	melee_damage_upper = 10
	rarity_value = 36
	spawn_tags = SPAWN_TAG_MOB_ROOMBA


/mob/living/simple_animal/hostile/roomba/death()
	..()
	visible_message("<b>[src]</b> blows apart!")
	new /obj/effect/decal/cleanable/blood/gibs/robot(src.loc)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	if(prob(20))
		var/os_components_reward = pick(list(
			/obj/item/stock_parts/capacitor/one_star,
			/obj/item/stock_parts/scanning_module/one_star,
			/obj/item/stock_parts/manipulator/one_star,
			/obj/item/stock_parts/micro_laser/one_star,
			/obj/item/stock_parts/matter_bin/one_star
		))
		new os_components_reward(get_turf(src))
	qdel(src)
	return


/mob/living/simple_animal/hostile/roomba/slayer
	name = "One Star RMB-A unit"
	desc = "A small round drone, usually tasked with carrying out menial tasks. This one seems to have a knife taped to it..?"
	icon_state = "roomba_knife"
	health = 35
	maxHealth = 35
	speed = 2
	melee_damage_lower = 12
	melee_damage_upper = 17
	rarity_value = 39.66


/mob/living/simple_animal/hostile/roomba/boomba
	name = "One Star RMB-A unit"
	desc = "A small round drone, usually tasked with carrying out menial tasks. Is that a fucking anti-personel mine?!"
	icon_state = "boomba"
	health = 15
	maxHealth = 15
	speed = 0
	melee_damage_lower = 10
	melee_damage_upper = 10
	rarity_value = 85

/mob/living/simple_animal/hostile/roomba/boomba/AttackTarget()
	. = ..()
	if(.) // If we succeeded in hitting.
		src.visible_message(SPAN_DANGER("\The [src] makes an odd warbling noise, fizzles, and explodes!"))
		explosion(get_turf(src), 250, 75)
		death()

/mob/living/simple_animal/hostile/roomba/gun_ba
	name = "One Star RMB-A unit"
	desc = "A small round drone, usually tasked with carrying out menial tasks. And this one has a gun."
	icon_state = "roomba_lmg"
	health = 30
	maxHealth = 30
	speed = 3
	melee_damage_lower = 5
	melee_damage_upper = 10
	ranged = TRUE
	rarity_value = 59.5

/obj/spawner/mob/roomba
	name = "random roomba"
	icon_state = "hostilemob-blue"
	alpha = 128
	tags_to_spawn = list(SPAWN_MOB_ROOMBA,SPAWN_MOB_OS_CUSTODIAN)

/obj/spawner/mob/roomba/post_spawn(list/spawns)
	for(var/mob/living/simple_animal/A in spawns)
		A.stasis = TRUE
