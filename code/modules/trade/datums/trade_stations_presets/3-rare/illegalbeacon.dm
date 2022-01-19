/datum/trade_station/illegaltrader
	name_pool = list(
		"NSTB 'Arau'" = "Null-Space Trade Beacon 'Arau'. The Trade Beacon is sending an automatized message. \"Hey, Buddie. Interested in our legal goods?"
	)
	uid = "illegal1"
	start_discovered = FALSE
	spawn_always = TRUE
	markup = RARE_GOODS
	offer_limit = 20
	base_income = 1600
	wealth = 0
	secret_inv_threshold = 8000
	recommendation_threshold = 12000
	stations_recommended = list("illegal2")
	recommendations_needed = 3
	assortiment = list(
		"Syndicate Gear" = list(
			/obj/item/clothing/under/syndicate,
			/obj/item/storage/toolbox/syndicate = custom_good_amount_range(list(1, 3)),
			/obj/item/clothing/suit/space/syndicate = custom_good_amount_range(list(1, 1)),
			/obj/item/clothing/head/space/syndicate = custom_good_amount_range(list(1, 1)),
			/obj/item/clothing/mask/gas/syndicate = custom_good_amount_range(list(-3, 1)),
			/obj/item/gun/projectile/selfload = custom_good_amount_range(list(1, 1)),
			/obj/item/gun/projectile/automatic/c20r = custom_good_amount_range(list(1, 1)),
		),
		"Useful Stuff" = list(
			// Autoinjectors defined in hypospray.dm
			/obj/item/reagent_containers/hypospray/autoinjector/hyperzine = custom_good_amount_range(list(5, 10)),
			/obj/item/reagent_containers/hypospray/autoinjector/drugs = custom_good_amount_range(list(5, 10)),
			/obj/item/reagent_containers/hypospray/autoinjector/quickhealbrute = custom_good_amount_range(list(5, 10)),
			/obj/item/reagent_containers/hypospray/autoinjector/quickhealburn = custom_good_amount_range(list(5, 10)),
		),
	)
	secret_inventory = list(
		"Syndicate Gear II" = list(
			/obj/item/gun/energy/crossbow = custom_good_amount_range(list(1, 1)),
			/obj/item/clothing/suit/space/syndicate/uplink = custom_good_amount_range(list(1, 1)),
			/obj/item/clothing/head/space/syndicate/uplink = custom_good_amount_range(list(1, 1)),
			/obj/item/device/pda/syndicate = custom_good_amount_range(list(1, 1)),
			/obj/item/clothing/glasses/powered/night = custom_good_amount_range(list(1, 1)),
		),
		"Syndicate Gun Mods" = list(
			/obj/item/gun_upgrade/barrel/gauss,
			/obj/item/gun_upgrade/mechanism/glass_widow,
			/obj/item/gun_upgrade/scope/killer,
			/obj/item/gun_upgrade/mechanism/reverse_loader,		// might be a bit too antag-y, but it's funny
			/obj/item/gun_upgrade/trigger/boom,					// might be a bit too antag-y, but it's funny
		)
	)
	offer_types = list(
		
	)