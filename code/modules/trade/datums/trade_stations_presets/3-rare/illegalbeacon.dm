/datum/trade_station/illegaltrader
	name_pool = list(
		"NSTB \'Arau\'" = "Null-Space Trade Beacon \'Arau\'. The Trade Beacon is sending an automated message: \"Hey, buddy. Interested in our legal goods?\""
	)
	icon_states = list("htu_station", "station")
	uid = "illegal1"
	tree_x = 0.62
	tree_y = 0.6
	start_discovered = FALSE
	spawn_always = TRUE
	markup = RARE_GOODS
	offer_limit = 20
	base_income = 1600
	wealth = 0
	hidden_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("illegal2")
	recommendations_needed = 2
	inventory = list(
		"Syndicate Gear" = list(
			/obj/item/clothing/under/syndicate,
			/obj/item/storage/toolbox/syndicate = custom_good_amount_range(list(1, 3)),
			/obj/item/clothing/suit/space/syndicate = custom_good_amount_range(list(1, 1)),
			/obj/item/clothing/head/space/syndicate = custom_good_amount_range(list(1, 1)),
			/obj/item/clothing/suit/space/void/merc = custom_good_amount_range(list(1, 1)),
			/obj/item/clothing/mask/gas/syndicate = custom_good_amount_range(list(-3, 1)),
			/obj/item/gun/projectile/selfload = custom_good_amount_range(list(1, 1))
		),
		"Useful Stuff" = list(
			// Autoinjectors defined in hypospray.dm
			/obj/item/reagent_containers/hypospray/autoinjector/hyperzine = custom_good_amount_range(list(5, 10)),
			/obj/item/reagent_containers/hypospray/autoinjector/drugs = custom_good_amount_range(list(5, 10)),
			/obj/item/reagent_containers/hypospray/autoinjector/quickhealbrute = custom_good_amount_range(list(5, 10)),
			/obj/item/reagent_containers/hypospray/autoinjector/quickhealburn = custom_good_amount_range(list(5, 10))
		)
	)
	hidden_inventory = list(
		"Syndicate Gear II" = list(
			/obj/item/gun/energy/crossbow = custom_good_amount_range(list(1, 1)),
			/obj/item/clothing/suit/space/syndicate/uplink = custom_good_amount_range(list(1, 1)),
			/obj/item/clothing/head/space/syndicate/uplink = custom_good_amount_range(list(1, 1)),
			/obj/item/clothing/glasses/powered/night = custom_good_amount_range(list(1, 1))
		),
		"Syndicate Gun Mods" = list(
			/obj/item/gun_upgrade/barrel/gauss,
			/obj/item/gun_upgrade/mechanism/glass_widow,
			/obj/item/gun_upgrade/scope/killer
		)
	)
	offer_types = list(
		/obj/item/organ/internal/kidney = offer_data("kidney", 800, 8),					// base price: 400
		/obj/item/organ/internal/liver = offer_data("liver", 1800, 8)					// base price: 900
	)
