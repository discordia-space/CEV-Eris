/datum/trade_station/ningishzida
	name_pool = list(
		"MTB 'Ningishzida'" = "Moebius Trade Beacon 'Ningishzida': Connection with the Moebius surplus network established."
	)
	icon_states = "moe_capital"
	uid = "moe_adv"
	start_discovered = FALSE
	spawn_always = TRUE
	markup = RARE_GOODS
	offer_limit = 1
	base_income = 1600
	wealth = 0
	secret_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("trapper")//, "anomalies")
	recommendations_needed = 1
	assortiment = list(
		"Scientific Surplus" = list(
			/obj/item/storage/deferred/slime = custom_good_amount_range(list(1, 3)),
			/obj/item/storage/deferred/xenobotany = custom_good_amount_range(list(1, 3)),
			/obj/item/storage/deferred/rnd = custom_good_amount_range(list(1, 3))
		),
		"Chemical Surplus" = list(
			/obj/item/reagent_containers/glass/bottle/inaprovaline = custom_good_amount_range(list(1, 3)),
			/obj/item/reagent_containers/glass/bottle/antitoxin = custom_good_amount_range(list(1, 3)),
			/obj/item/reagent_containers/glass/bottle/trade/kelotane = good_data("kelotane bottle", list(1, 3)),
			/obj/item/reagent_containers/glass/bottle/trade/bicaridine = good_data("bicaridine bottle", list(1, 3)),
			/obj/item/reagent_containers/glass/bottle/trade/clonexadone = good_data("clonexadone bottle", list(1, 3)),
			/obj/item/reagent_containers/glass/bottle/trade/imidazoline = good_data("imidazoline bottle", list(1, 3)),
			/obj/item/reagent_containers/glass/bottle/trade/alkysine = good_data("alkysine bottle", list(1, 3))
		)
	)
	secret_inventory = list(
		"Upgraded Organs" = list(
			/obj/item/computer_hardware/hard_drive/portable/design/surgery = good_data("back alley organs disk", list(1, 2)),
			/obj/item/organ_module/active/simple/armshield
		),
		"Autoinjectors II" = list(
			// Autoinjectors defined in hypospray.dm
			/obj/item/reagent_containers/hypospray/autoinjector/polystem = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/meralyne = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/dermaline = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/dexalinplus = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/oxycodone = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/ryetalyn = custom_good_amount_range(list(10, 20))
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
