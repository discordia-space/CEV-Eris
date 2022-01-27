/obj/item/implant/carrion_spider/healing
	name = "healing spider"
	icon_state = "spiderling_healing"
	spider_price = 25 //Not too strong but can be stacked, if we69ake a no fun limit to spiders this should be lowered

/obj/item/implant/carrion_spider/healing/activate()
	..()
	if(wearer)
		wearer.reagents.add_reagent("bicaridine", 10)
		wearer.reagents.add_reagent("dermaline", 10)
		wearer.reagents.add_reagent("anti_toxin", 10)
		to_chat(wearer, SPAN_NOTICE("You feel a flood of chemicals surge through your69eins"))
		die()
	else
		to_chat(owner_mob, SPAN_WARNING("69src69 doesn't have a host"))
