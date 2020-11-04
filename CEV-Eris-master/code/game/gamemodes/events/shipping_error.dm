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
	var/datum/supply_order/O = new /datum/supply_order(
		SSsupply.supply_packs[pick(SSsupply.supply_packs)],
		random_name(pick(MALE, FEMALE), species = "Human")
	)
	SSsupply.shoppinglist += O
