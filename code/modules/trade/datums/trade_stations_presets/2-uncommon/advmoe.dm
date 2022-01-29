/datum/trade_station/ningishzida
	name_pool = list(
		"MTB 'Ningishzida'" = "Moebius Trade Beacon 'Ningishzida':\n\"TBD.\"."
	)
	icon_states = "moe_capital"
	uid = "moe_adv"
	start_discovered = FALSE
	spawn_always = TRUE
	markup = RARE_GOODS
	offer_limit = 20
	base_income = 1600
	wealth = 0
	secret_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("trapper")//, "anomalies")
	recommendations_needed = 1
	assortiment = list(
		"Xenobiology Supply" = list(
			/obj/item/slime_extract/grey = custom_good_amount_range(list(5, 10)),	// needs price tag
			/obj/item/extinguisher													// needs price tag
		),
		"Xenobotany Surplus" = list(
			/obj/item/seeds/random = good_data("random seed packet", list(3, 7))	// needs price tag
		),
		"Chemical Surplus" = list(
			/obj/item/reagent_containers/glass/bottle/inaprovaline = custom_good_amount_range(list(1, 3)),
			/obj/item/reagent_containers/glass/bottle/antitoxin = custom_good_amount_range(list(1, 3)),
			/obj/item/reagent_containers/glass/bottle/kelotane = custom_good_amount_range(list(1, 3)),
			/obj/item/reagent_containers/glass/bottle/bicaridine = custom_good_amount_range(list(1, 3)),
			/obj/item/reagent_containers/glass/bottle/clonexadone = custom_good_amount_range(list(1, 3)),
			/obj/item/reagent_containers/glass/bottle/imidazoline = custom_good_amount_range(list(1, 3)),
			/obj/item/reagent_containers/glass/bottle/alkysine = custom_good_amount_range(list(1, 3)),
		),
		"Technological Curiosities" = list(
			/obj/item/computer_hardware/hard_drive/portable/research_points = good_data("research data", list(2, 4))	// should probably get a price increase
		)
	)
	secret_inventory = list(
		"Upgraded Organs" = list(
			/obj/item/computer_hardware/hard_drive/portable/design/surgery = good_data("back alley organs", list(1, 2))		// should probably get a price increase
		),
		"Autoinjectors II" = list(
			// Autoinjectors defined in hypospray.dm
			/obj/item/reagent_containers/hypospray/autoinjector/polystem = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/meralyne = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/dermaline = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/dexalinplus = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/oxycodone = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/ryetalyn = custom_good_amount_range(list(10, 20)),
		),
		"Scientific Enigmas" = list(
			/obj/item/computer_hardware/hard_drive/portable/research_points/rare = good_data("rare research data", list(1, 3))
		)
	)
	offer_types = list(
		/obj/item/oddity/common/healthscanner = offer_data("odd health scanner", 800, 1),
		/obj/item/oddity/common/disk = offer_data("broken design disk", 800, 1),
		/obj/item/oddity/common/device = offer_data("odd device", 800, 1),
		/obj/item/slime_extract/lightpink = offer_data("light pink slime extract", 10000, 1),
		/obj/item/slime_extract/black = offer_data("black slime extract", 10000, 1),
		/obj/item/slime_extract/oil = offer_data("oil slime extract", 10000, 1),
		/obj/item/slime_extract/adamantine = offer_data("adamantine slime extract", 10000, 1)
		// /obj/item/slime_extract/bluespace
		// /obj/item/slime_extract/pyrite
		// /obj/item/slime_extract/cerulean
		// /obj/item/slime_extract/sepia
		// /obj/item/slime_extract/rainbow
	)