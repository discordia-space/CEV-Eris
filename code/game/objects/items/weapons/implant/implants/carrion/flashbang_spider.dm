/obj/item/weapon/implant/carrion_spider/flashbang
	name = "flashbang spider"
	icon_state = "spiderling_flashbang"
	spider_price = 15

/obj/item/weapon/implant/carrion_spider/flashbang/activate()
	..()
	if(wearer)
		wearer.apply_damage(10, BURN, part)

	for(var/obj/structure/closet/L in view(7, get_turf(src)))
		if(locate(/mob/living/carbon/, L))
			for(var/mob/living/carbon/M in L)
				flashbang_bang(get_turf(src), M)

	for(var/mob/living/carbon/M in view(7, get_turf(src)))
		flashbang_bang(get_turf(src), M)

	new/obj/effect/sparks(get_turf(src))
	new/obj/effect/effect/smoke/illumination(get_turf(src), brightness=15)
	die()
