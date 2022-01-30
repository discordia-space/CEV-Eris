/datum/trade_station/illegaltrader2
	name_pool = list(
		"NSTB 'Arau'" = "Null-Space Trade Beacon 'Arau'. The Trade Beacon is sending an automatized message. \"Hey, Buddie. Interested in our legal goods?"
	)
	uid = "illegal2"
	start_discovered = FALSE
	spawn_always = TRUE
	markup = RARE_GOODS
	offer_limit = 20
	base_income = 1600
	wealth = 0
	secret_inv_threshold = 6000
	recommendations_needed = 3
	assortiment = list(
        // add uplink gear
		"Voidsuits" = list(
			/obj/item/rig/merc,
		),
		"Tools" = list(
		),
	)
	secret_inventory = list(
		"Firearms" = list(
			/obj/item/gun/projectile/automatic/c20r = custom_good_amount_range(list(1, 1)),
		),
		"RIG Modules" = list(
			/obj/item/rig_module/fabricator,
			/obj/item/rig_module/fabricator/energy_net,
		)
	)
	offer_types = list(
		
	)