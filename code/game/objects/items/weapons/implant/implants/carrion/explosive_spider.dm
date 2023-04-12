/obj/item/implant/carrion_spider/explosive
	name = "explosive spider"
	desc = "A large, glowing spider, about the size of your fist. It's undulating and emitting a soft ticking noise."
	icon_state = "spiderling_explosive"
	spider_price = 40
	var/explosion_power =  100
	var/explosion_falloff = 25
	var/det_time = 2 SECONDS

/obj/item/implant/carrion_spider/explosive/activate()
	..()
	if(wearer)
		wearer.apply_damage(10, BRUTE, part)
		to_chat(wearer, SPAN_WARNING("You feel something moving within [part]!"))
		visible_message(SPAN_DANGER("[src] crawls out of [wearer] and flashes brightly!"))
		src.uninstall()
	else
		visible_message(SPAN_DANGER("[src] flashes brightly!"))
	playsound(src, 'sound/voice/insect_battle_screeching.ogg', 80, 1, 5)
	src.set_light(3,3, COLOR_ORANGE)
	spawn(det_time)
		src?.prime()

/obj/item/implant/carrion_spider/explosive/proc/prime()
	var/turf/O = get_turf(src)
	if(!O) return

	on_explosion(O)

	die()

/obj/item/implant/carrion_spider/explosive/proc/on_explosion(O)
	visible_message(SPAN_DANGER("[src] explodes!"))
	explosion(get_turf(src), explosion_power, explosion_falloff)
