/obj/item/weapon/implant/carrion_spider/explosive
	name = "explosive spider"
	icon_state = "spiderling_explosive"
	spider_price = 40
	var/devastation_range = -1
	var/heavy_range = 0
	var/weak_range = 2
	var/flash_range = 6
	var/det_time = 2 SECONDS

/obj/item/weapon/implant/carrion_spider/explosive/activate()
	..()
	if(wearer)
		src.uninstall()
		visible_message(SPAN_WARNING("[src] pops out of [wearer] and flashes brightly!"))
	else
		visible_message(SPAN_WARNING("[src] flashes brightly!"))
	src.set_light(3,3, COLOR_ORANGE)
	spawn(det_time)
		src?.prime()

/obj/item/weapon/implant/carrion_spider/explosive/proc/prime()
	var/turf/O = get_turf(src)
	if(!O) return

	on_explosion(O)

	die()

/obj/item/weapon/implant/carrion_spider/explosive/proc/on_explosion(O)
	visible_message(SPAN_DANGER("[src] explodes!"))
	explosion(get_turf(src), devastation_range, heavy_range, weak_range, flash_range)
