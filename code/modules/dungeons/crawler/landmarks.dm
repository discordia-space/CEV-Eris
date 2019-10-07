/obj/crawler/crawler_wallmaker
	name = "wallmaker"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	invisibility = 101

/obj/crawler/crawler_chanceblock
	name = "chance"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	invisibility = 101

/obj/crawler/crawler_chanceblock_danger
	name = "danger"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	invisibility = 101

/obj/crawler/room_controller
	name = "room"
	icon = 'icons/mob/eye.dmi'
	icon_state = "default-eye"
	invisibility = 101
	var/roomnum = 1

/obj/crawler/room_controller/New()
	if(loc && istype(loc.loc,/area/crawler))
		var/area/crawler/A = loc.loc
		A.room_controllers += src