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
			/obj/item/storage/deferred/rnd = good_data("research box", list(1, 3), 5000),
			/obj/item/storage/box/monkeycubes = good_data("monkey cube box", list(1, 3), 2000),
			/obj/machinery/suspension_gen
		),
		"Chemical Surplus" = list(
			/obj/item/reagent_containers/glass/bottle/inaprovaline = custom_good_amount_range(list(2, 3)),
			/obj/item/reagent_containers/glass/bottle/antitoxin = custom_good_amount_range(list(2, 3)),
			/obj/item/reagent_containers/glass/bottle/trade/clonexadone = custom_good_amount_range(list(2, 3))
		)
	)
	hidden_inventory = list(
		"Back Alley Organs" = list(
			/obj/item/computer_hardware/hard_drive/portable/design/surgery = good_data("back alley organs disk", list(1, 2), 2000),
		),
		"Autoinjectors" = list(
			// Autoinjectors defined in hypospray.dm
			/obj/item/reagent_containers/hypospray/autoinjector/bloodclot_alt = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/bloodrestore_alt = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/painkiller_alt = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/speedboost_alt = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/oxygenation_alt = custom_good_amount_range(list(10, 20))
		)
	)
	offer_types = list(
		/obj/item/bluespace_crystal = offer_data("bluespace crystal", 500, 10),
		/obj/item/organ/internal/scaffold = offer_data_mods("aberrant organ (input, process, output, secondary)", 2400, 4, OFFER_ABERRANT_ORGAN_PLUS, 4),
		/datum/reagent/stim/machine_spirit = offer_data("Machine Spirit bottle (60u)", 3200, 2),
		/datum/reagent/stim/grape_drops = offer_data("Grape drops bottle (60u)", 3200, 2),
		/datum/reagent/stim/ultra_surgeon = offer_data("UltraSurgeon bottle (60u)", 3200, 2),
		/datum/reagent/stim/violence_ultra = offer_data("Violence Ultra bottle (60u)", 3200, 2),
		/datum/reagent/stim/boxer = offer_data("Boxer bottle (60u)", 3200, 2),
		/datum/reagent/stim/turbo = offer_data("TURBO bottle (60u)", 3200, 2),
		/obj/item/device/mmi/digital/posibrain = offer_data("positronic brain", 5000, 2),
		/datum/reagent/nanites/uncapped/control_booster_utility = offer_data("Control Booster Utility bottle (60u)", 30000, 1),
		/datum/reagent/nanites/uncapped/control_booster_combat = offer_data("Control Booster Combat bottle (60u)", 30000, 1),
		/obj/item/slime_extract/lightpink = offer_data("light pink slime extract", 40000, 1),
		/obj/item/slime_extract/black = offer_data("black slime extract", 40000, 1),
		/obj/item/slime_extract/oil = offer_data("oil slime extract", 40000, 1),
		/obj/item/slime_extract/adamantine = offer_data("adamantine slime extract", 40000, 1),
		/datum/reagent/toxin/slimetoxin = offer_data("mutation toxin (60u)", 20000, 1),
		/datum/reagent/toxin/aslimetoxin = offer_data("advanced mutation toxin (60u)", 40000, 1)
	)
