/obj/item/weapon/implant/carrion_spider/explosive
	name = "explosive spider"
	icon_state = "spiderling_explosive"
	spider_price = 40
	var/devastation_range = -1
	var/heavy_range = 0
	var/weak_range = 2
	var/flash_range = 6
	var/det_time = 20

/obj/item/weapon/implant/carrion_spider/explosive/activate()
	..()
	var/obj/item/weapon/implant/carrion_spider/explosive/biteszadusto = new/obj/item/weapon/implant/carrion_spider/explosive(get_turf(src))
	if((istype(wearer, /mob/living/simple_animal) || istype(wearer, /mob/living/carbon)))
		visible_message(SPAN_WARNING("[src] pops out of [wearer] and flashes brightly!"))
	else
		visible_message(SPAN_WARNING("[src] flashes brightly!"))
	biteszadusto.set_light(3,3, COLOR_ORANGE)
	spawn(det_time)
		biteszadusto.prime()
	qdel(src)

/obj/item/weapon/implant/carrion_spider/explosive/proc/prime()
	var/turf/O = get_turf(src)
	if(!O) return

	on_explosion(O)

	die()

/obj/item/weapon/implant/carrion_spider/explosive/proc/on_explosion(var/turf/O)
	visible_message(SPAN_DANGER("[src] explodes!"))
	explosion(get_turf(src), devastation_range, heavy_range, weak_range, flash_range)
