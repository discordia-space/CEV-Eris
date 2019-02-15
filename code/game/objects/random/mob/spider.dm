/obj/random/mob/spiders
	name = "random spider"
	icon_state = "hostilemob-black"
	alpha = 128

/obj/random/mob/spiders/item_to_spawn()
	return pickweight(list(/obj/effect/spider/spiderling = 30,\
				/mob/living/carbon/superior_animal/giant_spider = 4,\
				/mob/living/carbon/superior_animal/giant_spider/nurse = 2,\
				/mob/living/carbon/superior_animal/giant_spider/hunter = 2))

/obj/random/mob/spiders/low_chance
	name = "low chance random spider"
	icon_state = "hostilemob-black-low"
	spawn_nothing_percentage = 60

/obj/random/cluster/spiders
	name = "cluster of spiders"
	icon_state = "hostilemob-black-cluster"
	alpha = 128
	min_amount = 1
	max_amount = 5
	spread_range = 0

/obj/random/cluster/spiders/item_to_spawn()
	return /obj/random/mob/spiders

/obj/random/cluster/spiders/low_chance
	name = "low chance cluster of spiders"
	icon_state = "hostilemob-black-cluster-low"
	spawn_nothing_percentage = 60
