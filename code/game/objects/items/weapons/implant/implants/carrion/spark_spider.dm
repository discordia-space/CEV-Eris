/obj/item/implant/carrion_spider/spark
	name = "spark spider"
	desc = "The match is struck"
	icon_state = "spiderling_spark"
	spider_price = 5
	var/datum/wires/connected

/obj/item/implant/carrion_spider/spark/activate()
	..()
	if(connected)
		connected.Pulse(src)
	else
		var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
		sparks.set_up(3, 0, get_turf(src))
		sparks.start()
		die()
