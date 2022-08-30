/datum/trade_station/ningishzida
	name_pool = list(
		"MTB \'Ningishzida\'" = "Moebius Trade Beacon \'Ningishzida\': Connection with the Moebius surplus network established."
	)
	icon_states = list("moe_cruiser", "ship")
	uid = "moe_adv"
	tree_x = 0.38
	tree_y = 0.7
	start_discovered = FALSE
	spawn_always = TRUE
	markup = COMMON_GOODS
	offer_limit = 1
	base_income = 1600
	wealth = 0
	hidden_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list()
	recommendations_needed = 1
	inventory = list(
		"Scientific Surplus" = list(
			/obj/item/storage/deferred/slime = good_data("slime supply box", list(1, 3), 500),
			/obj/item/storage/deferred/xenobotany = good_data("xenobotany supply box", list(1, 3), 500),
			/obj/item/storage/deferred/rnd = good_data("research box", list(1, 3), 5000),			// compare with export crate pricing
			/obj/item/storage/box/monkeycubes = good_data("monkey cube box", list(1, 3), 1000),
			/obj/machinery/suspension_gen
		),
		"Chemical Surplus" = list(
			/obj/item/reagent_containers/glass/bottle/inaprovaline = custom_good_amount_range(list(1, 3)),
			/obj/item/reagent_containers/glass/bottle/antitoxin = custom_good_amount_range(list(1, 3)),
			/obj/item/reagent_containers/glass/bottle/trade/kelotane = good_data("kelotane bottle", list(1, 3), 100),
			/obj/item/reagent_containers/glass/bottle/trade/bicaridine = good_data("bicaridine bottle", list(1, 3), 100),
			/obj/item/reagent_containers/glass/bottle/trade/clonexadone = good_data("clonexadone bottle", list(1, 3), 100),
			/obj/item/reagent_containers/glass/bottle/trade/imidazoline = good_data("imidazoline bottle", list(1, 3), 100),
			/obj/item/reagent_containers/glass/bottle/trade/alkysine = good_data("alkysine bottle", list(1, 3), 100)
		)
	)
	hidden_inventory = list(
		"Upgraded Organs" = list(
			/obj/item/computer_hardware/hard_drive/portable/design/surgery = good_data("back alley organs disk", list(1, 2), 2000),
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
		/obj/item/slime_extract/lightpink = offer_data("light pink slime extract", 20000, 1),
		/obj/item/slime_extract/black = offer_data("black slime extract", 20000, 1),
		/obj/item/slime_extract/oil = offer_data("oil slime extract", 20000, 1),
		/obj/item/slime_extract/adamantine = offer_data("adamantine slime extract", 20000, 1),
		/datum/reagent/toxin/slimetoxin = offer_data("mutation toxin (60u)", 10000, 1),
		/datum/reagent/toxin/aslimetoxin = offer_data("advanced mutation toxin (60u)", 20000, 1),
		/datum/reagent/nanites/uncapped/control_booster_utility = offer_data("Control Booster Utility bottle (60u)", 30000, 1),
		/datum/reagent/nanites/uncapped/control_booster_combat = offer_data("Control Booster Combat bottle (60u)", 30000, 1)
	)
