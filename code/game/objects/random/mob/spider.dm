/obj/random/mob/spiders
	name = "random spider"
	icon_state = "hostilemob-red"

/obj/random/mob/spiders/item_to_spawn()
	return pick(prob(30);/obj/effect/spider/spiderling,\
				prob(4);/mob/living/simple_animal/hostile/giant_spider,\
				prob(2);/mob/living/simple_animal/hostile/giant_spider/nurse,\
				prob(2);/mob/living/simple_animal/hostile/giant_spider/hunter)

/obj/random/mob/spiders/low_chance
	name = "low chance random spider"
	icon_state = "hostilemob-red-low"
	spawn_nothing_percentage = 82

/obj/random/cluster/spiders
	name = "cluster of spiders"
	icon_state = "hostilemob-red"
	min_amount = 3
	max_amount = 10
	spread_range = 0

/obj/random/cluster/spiders/item_to_spawn()
	return /obj/random/mob/spiders

/obj/random/cluster/spiders/low_chance
	name = "low chance cluster of spiders"
	icon_state = "hostilemob-red-low"
	spawn_nothing_percentage = 82
