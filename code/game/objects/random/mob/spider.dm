/obj/random/mob/spiders
	name = "random spider"
	icon_state = "hostilemob-black"
	alpha = 128

/obj/random/mob/spiders/item_to_spawn()
	return pick(prob(30);/obj/effect/spider/spiderling,\
				prob(4);/mob/living/simple_animal/hostile/giant_spider,\
				prob(2);/mob/living/simple_animal/hostile/giant_spider/nurse,\
				prob(2);/mob/living/simple_animal/hostile/giant_spider/hunter)

/obj/random/mob/spiders/low_chance
	name = "low chance random spider"
	icon_state = "hostilemob-black-low"
	spawn_nothing_percentage = 70

/obj/random/cluster/spiders
	name = "cluster of spiders"
	icon_state = "hostilemob-black-cluster"
	alpha = 128
	min_amount = 1
	max_amount = 4
	spread_range = 0

/obj/random/cluster/spiders/item_to_spawn()
	return /obj/random/mob/spiders

/obj/random/cluster/spiders/low_chance
	name = "low chance cluster of spiders"
	icon_state = "hostilemob-black-cluster-low"
	spawn_nothing_percentage = 70
