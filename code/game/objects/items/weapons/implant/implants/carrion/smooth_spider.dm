/obj/item/weapon/implant/carrion_spider/smooth
	name = "smooth spider"
	desc = "Small spider filled with some sort of strange fluid. This one has a menacing aura."
	icon_state = "spiderling_smooth"
	spider_price = 10
	var/not_playing = TRUE

/obj/item/weapon/implant/carrion_spider/smooth/activate()
	..()
	if(not_playing)
		playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1)
		not_playing = FALSE
		spawn(5)
			not_playing = TRUE

/obj/item/weapon/implant/carrion_spider/smooth/Crossed(AM as mob|obj)
	if (isliving(AM))
		var/mob/living/M = AM
		M.slip("the [src.name]",3)