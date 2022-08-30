/datum/trade_station/nt_uncommon
	name_pool = list(
		"NTV \'Hope\'" = "NeoTheology Vessel \'Hope\': \"Reliable, blessed, and sanctified goods for the correct price.\""
	)
	icon_states = list("nt_cruiser", "ship")
	uid = "nt_uncommon"
	tree_x = 0.82
	tree_y = 0.7
	start_discovered = FALSE
	spawn_always = TRUE
	markup = COMMON_GOODS
	base_income = 1600
	wealth = 0
	hidden_inv_threshold = 2000
	recommendation_threshold = 4000
	recommendations_needed = 1
	inventory = list(
		"Energy Weapons" = list(
			/obj/item/gun/energy/taser,
			/obj/item/gun/energy/nt_svalinn,
			/obj/item/gun/energy/laser = custom_good_amount_range(list(1, 3))
		),
		"Ballistic Weapons" = list(
			/obj/item/gun/projectile/mk58,
			/obj/item/gun/projectile/mk58/wood,
			/obj/item/gun/projectile/shotgun/pump/regulator
		),
		"Melee Weapons" = list(
			/obj/item/tool/sword/nt/shortsword,
			/obj/item/tool/knife/dagger/nt,
			/obj/item/shield/buckler/nt
		)
	)
	hidden_inventory = list(
		"Pouches" = list(
			/obj/item/storage/pouch/small_generic,
			/obj/item/storage/pouch/medium_generic,
			/obj/item/storage/pouch/large_generic
		),
		"Neotheology Cells" = list(
			/obj/item/cell/small/neotheology,
			/obj/item/cell/medium/neotheology,
			/obj/item/cell/large/neotheology
		),
		"Holy Defense Equipment" = list(
			/obj/item/grenade/smokebomb/nt = custom_good_amount_range(list(1, 4)),
			/obj/item/grenade/flashbang/nt = custom_good_amount_range(list(1, 4)),
			/obj/item/gun/energy/ionrifle = custom_good_amount_range(list(1, 4)),
			/obj/item/gun/energy/plasma = custom_good_amount_range(list(-3, 2))
		)
	)
	offer_types = list(
		/obj/item/computer_hardware/hard_drive/portable/design/nt/triarii = offer_data("NeoTheology Armory - \"Triarii Arms\"", 2000, 1),
		/obj/item/computer_hardware/hard_drive/portable/design/nt/medicii = offer_data("NeoTheology Armory - \"Medicii Supplies\"", 1000, 1),
		/obj/item/computer_hardware/hard_drive/portable/design/nt/nt_lightfall = offer_data("NeoTheology Armory - Lightfall Laser Gun", 800, 1),
		/obj/item/computer_hardware/hard_drive/portable/design/nt/grenades = offer_data("NeoTheology Armory - Grenades Pack", 800, 1),
		/obj/item/computer_hardware/hard_drive/portable/design/nt/excruciator = offer_data("NeoTheology Armory - NT \"EXCRUCIATOR\" giga lens", 800, 1)
	)
