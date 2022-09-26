/datum/trade_station/caduceus
	name_pool = list(
		"MAV \'Caduceus\'" = "Moebius Aid Vessel \'Caduceus\': \"Hello there, we are from the Old Sol Republic. We will be leaving the system shortly but we can offer you medical supplies in the meantime.\"."
	)
	forced_overmap_zone = list(
		list(20, 22),
		list(20, 25)
	)
	icon_states = list("moe_destroyer", "ship")
	uid = "moe_basic"
	tree_x = 0.42
	tree_y = 0.9
	start_discovered = TRUE
	spawn_always = TRUE
	markup = WHOLESALE_GOODS
	offer_limit = 20
	base_income = 1600
	wealth = 0
	hidden_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("moe_adv", "trapper")
	inventory = list(
		"Design Disks" = list(
			/obj/item/computer_hardware/hard_drive/portable/design/medical = good_data("Moebius Medical Designs", list(1, 10), 400)
		),
		"First Aid" = list(
			/obj/item/storage/firstaid/regular = custom_good_price(450),
			/obj/item/storage/firstaid/fire = custom_good_price(400),
			/obj/item/storage/firstaid/toxin = custom_good_price(400),
			/obj/item/storage/firstaid/o2 = custom_good_price(400),
			/obj/item/storage/firstaid/adv = custom_good_price(600),
			/obj/item/stack/medical/bruise_pack,
			/obj/item/stack/medical/ointment,
			/obj/item/stack/medical/splint
		),
		"Surgery" = list(
			/obj/item/tool/cautery,
			/obj/item/tool/surgicaldrill,
			/obj/item/tank/anesthetic,
			/obj/item/tool/hemostat,
			/obj/item/tool/scalpel,
			/obj/item/tool/retractor,
			/obj/item/tool/bonesetter,
			/obj/item/tool/saw/circular
		),
		"Blood" = list(
			/obj/structure/medical_stand,
			/obj/item/reagent_containers/blood/empty,
			/obj/item/reagent_containers/blood/APlus,
			/obj/item/reagent_containers/blood/AMinus,
			/obj/item/reagent_containers/blood/BPlus,
			/obj/item/reagent_containers/blood/BMinus,
			/obj/item/reagent_containers/blood/OPlus,
			/obj/item/reagent_containers/blood/OMinus
		),
		"Machinery" = list(
			/obj/item/electronics/circuitboard/centrifuge,
			/obj/item/electronics/circuitboard/electrolyzer,
			/obj/item/electronics/circuitboard/reagentgrinder,
			/obj/item/electronics/circuitboard/industrial_grinder
		),
		"Misc" = list(
			/obj/item/storage/pouch/medical_supply,
//			/obj/item/virusdish/random,		// Spawns without an icon
			/obj/structure/reagent_dispensers/coolanttank,
			/obj/item/clothing/mask/breath/medical,
			/obj/item/clothing/mask/surgical,
			/obj/item/clothing/gloves/latex,
			/obj/item/reagent_containers/syringe,
			/obj/item/reagent_containers/hypospray/autoinjector,
			/obj/item/bodybag,
			/obj/item/reagent_containers/spray,
			/obj/item/storage/hcases/med
		)
	)
	hidden_inventory = list(
		"Autoinjectors" = list(
			// Autoinjectors defined in hypospray.dm
			/obj/item/reagent_containers/hypospray/autoinjector/bloodclot = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/bloodrestore = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/painkiller = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/speedboost = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/oxygenation = custom_good_amount_range(list(10, 20))
		)
	)
	offer_types = list(
		/obj/item/oddity/common/healthscanner = offer_data("odd health scanner", 500, 1),
		/obj/item/oddity/common/paper_omega = offer_data("collection of obscure reports", 500, 1),
		/obj/item/organ/internal/scaffold = offer_data_mods("aberrant organ (input, process, output)", 1200, 4, OFFER_ABERRANT_ORGAN, 3),
		/datum/reagent/stim/mbr = offer_data("Machine Binding Ritual bottle (60u)", 1600, 2),
		/datum/reagent/stim/cherrydrops = offer_data("Cherry Drops bottle (60u)", 1600, 2),
		/datum/reagent/stim/pro_surgeon = offer_data("ProSurgeon bottle (60u)", 1600, 2),
		/datum/reagent/stim/violence = offer_data("Violence bottle (60u)", 1600, 2),
		/datum/reagent/stim/bouncer = offer_data("Bouncer bottle (60u)", 1600, 2),
		/datum/reagent/stim/steady = offer_data("Steady bottle (60u)", 1600, 2),
		/datum/reagent/medicine/ossisine = offer_data("ossissine bottle (60u)", 4000, 1),
		/datum/reagent/medicine/kyphotorin = offer_data("kyphotorin bottle (60u)", 8000, 1)
	)
