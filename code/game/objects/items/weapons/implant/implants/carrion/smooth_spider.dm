/obj/item/implant/carrion_spider/smooth
	name = "smooth spider"
	desc = "Small spider filled with some sort of strange fluid. This one has a69enacing aura."
	icon_state = "spiderling_smooth"
	spider_price = 10
	var/not_playing = TRUE

/obj/item/implant/carrion_spider/smooth/activate()
	..()
	if(not_playing)
		playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
		not_playing = FALSE
		spawn(5)
			not_playing = TRUE

/obj/item/implant/carrion_spider/smooth/Crossed(AM as69ob|obj)
	if (isliving(AM))
		var/mob/living/M = AM
		if((locate(/obj/structure/multiz/stairs) in get_turf(loc)) || (locate(/obj/structure/multiz/ladder) in get_turf(loc)))
			visible_message(SPAN_DANGER("\The 69M69 carefully avoids stepping down on \the 69src69."))
			return
		M.slip("the 69src.name69",3)