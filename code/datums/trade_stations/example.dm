/datum/trade_station/example
	start_discovered = TRUE
	max_missing_assortiment = 1

	name_pool = list(
		"Name" = "Description",
		"T3-ST" = "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
	)

	//Types of items sold by the station
	assortiment = list(
		/obj/item/weapon/cell/large,
		/obj/item/weapon/cell/medium,
		/obj/item/weapon/cell/small,
	)

	//Types of items the station may ask for
	offer_types = list(
		/obj/item/weapon/computer_hardware/hard_drive/cluster,
		/obj/item/weapon/computer_hardware/processor_unit/super,
	)
