/obj/item/implant/carrion_spider/smokebomb
	name = "black mist spider"
	desc = "A spider bloated with ebony gasses, it looks ready to burst!"
	icon_state = "spiderling_toxicbomb"
	spider_price = 4
	gibs_color = "#401122"
	var/datum/reagents/gas_storage
	var/det_time = 1 SECONDS

/obj/item/implant/carrion_spider/smokebomb/activate()
	..()
	if(wearer)
		src.uninstall()
		to_chat(wearer, SPAN_WARNING("You feel something moving within [part]!"))
		visible_message(SPAN_DANGER("[src] crawls out of [wearer] and emits clouds of smoke!"))
	else
		visible_message(SPAN_DANGER("[src] emits clouds of smoke!!"))
	playsound(src, 'sound/voice/insect_battle_screeching.ogg', 80, 1, 5)
	src?.prime()

/obj/item/implant/carrion_spider/smokebomb/proc/prime()
	var/location = get_turf(src)
	var/datum/effect/effect/system/smoke_spread/S = new
	S.attach(location)
	S.set_up(5, 0, src)
	S.start()
	playsound(loc, 'sound/effects/turret/open.ogg', 50, 0)
	die()
