/obj/item/implant/carrion_spider/smokebomb
	name = "black mist spider"
	desc = "A spider bloated with ebony gasses, it looks ready to burst!"
	icon_state = "spiderling_smoke"
	spider_price = 5
	gibs_color = "#401122"
	var/datum/effect/effect/system/smoke_spread/smoke
	var/charges = 1

/obj/item/implant/carrion_spider/smokebomb/activate()
	..()
	visible_message(SPAN_DANGER("[src] emits clouds of smoke!!"))
	playsound(src, 'sound/voice/insect_battle_screeching.ogg', 80, 1, 5)
	playsound(src, 'sound/effects/smoke.ogg', 50, 1, -3)
	if(charges)
		src.prime()

/obj/item/implant/carrion_spider/smokebomb/proc/prime()
	var/datum/effect/effect/system/smoke_spread/S = new
	S.attach(src)
	S.set_up(10, 0, usr.loc)
	charges = 0
	S.start()
	sleep(1 SECOND)
	S.start()
	sleep(1 SECOND)
	S.start()
	die()
