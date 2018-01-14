/mob/living/simple_animal/hostile/hivebot
	name = "Human Alliance Autonomous Drone"
	desc = "Old machine of long time fallen empire. Looks like its just attack everything on sight."
	icon = 'icons/mob/hivebot.dmi'
	icon_state = "melee"
	icon_dead = "melee_broken"
	health = 40
	maxHealth = 40
	melee_damage_lower = 5
	melee_damage_upper = 13
	attacktext = "clawed"
	projectilesound = 'sound/weapons/Laser.ogg'
	projectiletype = /obj/item/projectile/beam/drone
	faction = "hivebot"
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	speed = 4
	light_range = 3
	light_color = "#82C2D8"

/mob/living/simple_animal/hostile/hivebot/range
	name = "Human Alliance Autonomous Sentinel"
	icon_state = "range"
	icon_dead = "range_broken"
	health = 60
	maxHealth = 60
	ranged = 1

/mob/living/simple_animal/hostile/hivebot/death()
	..()
	visible_message("<b>[src]</b> blows apart!")
	new /obj/effect/decal/cleanable/blood/gibs/robot(src.loc)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)
	return
