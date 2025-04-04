/obj/item/implant/carrion_spider/breeding
	name = "breeding spider"
	icon_state = "spiderling_breeding"
	spider_price = 30
	var/number_of_spiders
	var/active = FALSE

/obj/item/implant/carrion_spider/breeding/Initialize()
	..()
	number_of_spiders = rand(9, 12)

/obj/item/implant/carrion_spider/breeding/activate()
	..()
	if(!wearer)
		to_chat(owner_mob, span_warning("[src] doesn't have a host"))
		return
	if(!istype(wearer.species, /datum/species/human))
		to_chat(owner_mob, span_warning("[src] only works on humans"))
		return	

	if(!(wearer.stat == DEAD))
		to_chat(owner_mob, span_warning("The host must be dead!"))
		return
	
	if(active)
		to_chat(owner_mob, span_warning("[src] is already active!"))
		return
	
	for(var/obj/item/implant/carrion_spider/breeding/BS in wearer)
		if(BS.active)
			to_chat(owner_mob, span_warning("Another breeding spider is already active in [wearer]!"))
			return

	active = TRUE
	spawn(1 MINUTES)
		active = FALSE
		if(wearer?.stat == DEAD)
			while(number_of_spiders)
				new /obj/spawner/mob/spiders(wearer.loc)
				number_of_spiders--
			wearer.gib()
			die()
