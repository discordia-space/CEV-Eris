/obj/item/implant/carrion_spider/blight
	name = "blight spider"
	icon_state = "spiderling_blight"
	spider_price = 30

/obj/item/implant/carrion_spider/blight/activate()
	..()
	if(wearer)
		wearer.reagents.add_reagent("amatoxin", 5)
		to_chat(wearer, SPAN_WARNING("You feel sick and nauseous"))
		die()
	else
		to_chat(owner_mob, SPAN_WARNING("69src69 doesn't have a host"))
