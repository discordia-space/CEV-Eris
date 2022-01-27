/*
	Very69inor69undane event that gives a free randomly selected crate at cargo
	It has a lower cost so it won't take up too69uch of the event points
*/
/datum/storyevent/shipping_error
	id = "shipping_error"
	name = "shipping error"

	event_type = /datum/event/shipping_error
	event_pools = list(EVENT_LEVEL_MUNDANE = POOL_THRESHOLD_MUNDANE*0.3) //Low cost since its a really69inor thing

	tags = list(TAG_TARGETED, TAG_POSITIVE)

/datum/event/shipping_error/start()
	var/datum/supply_order/O = new /datum/supply_order(
		SSsupply.supply_packs69pick(SSsupply.supply_packs)69,
		random_name(pick(MALE, FEMALE), species = SPECIES_HUMAN)
	)
	SSsupply.shoppinglist += O
