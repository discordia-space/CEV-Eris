/obj/item/weapon/implant/carrion_spider/explosive
	name = "explosive spider"
	icon_state = "spiderling_explosive"
	spider_price = 40

/obj/item/weapon/implant/carrion_spider/explosive/activate()
	..()
	visible_message(SPAN_DANGER("[src] explodes!"))
	explosion(get_turf(src), -1, 0, 2, 6)
	die()
