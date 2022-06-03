/*
	Very minor mundane event that gives a free randomly selected crate at cargo
	It has a lower cost so it won't take up too much of the event points
*/
/datum/storyevent/shipping_error
	id = "shipping_error"
	name = "shipping error"

	event_type = /datum/event/shipping_error
	event_pools = list(EVENT_LEVEL_MUNDANE = POOL_THRESHOLD_MUNDANE*0.3) //Low cost since its a really minor thing

	tags = list(TAG_TARGETED, TAG_POSITIVE)

/datum/event/shipping_error/start()
	if(SStrade.beacons_receiving.len > 0)
		var/budget = rand(500,1000)
		var/datum/trade_station/TS = pick(SStrade.discovered_stations)
		var/obj/machinery/trade_beacon/receiving/R = pick(SStrade.beacons_receiving)
		var/obj/structure/closet/crate/C = R.drop(/obj/structure/closet/crate)
		
		for(var/i in 1 to 20)
			var/list/category = TS.inventory[pick(TS.inventory)]
			var/atom/movable/AM = pick(category)
			var/price = SStrade.get_import_cost(AM, TS)
			if(price < budget)
				budget -= price
				new AM(C)

		R.activate()
