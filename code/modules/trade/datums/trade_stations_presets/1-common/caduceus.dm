/datum/trade_station/caduceus
	name_pool = list(
		"MAV 'Caduceus'" = "Moebius Aid Vessel 'Caduceus': \"Hello there, we are from the Old Sol Republic. We will be leaving the system shortly but we can offer you medical supplies in the mean time.\"."
	)
	icon_states = "moe_capital"
	forced_overmap_zone = list(
		list(20, 22),
		list(20, 25)
	)
	uid = "moe_basic"
	start_discovered = TRUE
	spawn_always = TRUE
	markup = WHOLESALE_GOODS
	offer_limit = 20
	base_income = 1600
	wealth = 0
	hidden_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("moe_adv")
	assortiment = list(
		"First Aid" = list(
			/obj/item/storage/firstaid/regular,
			/obj/item/storage/firstaid/fire,
			/obj/item/storage/firstaid/toxin,
			/obj/item/storage/firstaid/o2,
			/obj/item/storage/firstaid/adv,
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
			/obj/machinery/suspension_gen,
			/obj/item/computer_hardware/hard_drive/portable/design
		)
	)
	hidden_inventory = list(
		"Autoinjectors" = list(
			// Autoinjectors defined in hypospray.dm
			/obj/item/reagent_containers/hypospray/autoinjector/antitoxin = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/tricordrazine = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/kelotane = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/bicaridine = custom_good_amount_range(list(5, 10)),
			/obj/item/reagent_containers/hypospray/autoinjector/dexalin = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/spaceacillin = custom_good_amount_range(list(10, 20)),
			/obj/item/reagent_containers/hypospray/autoinjector/tramadol = custom_good_amount_range(list(5, 10))
		)
	)
	offer_types = list(
		/datum/reagent/medicine/ossisine = offer_data("ossissine bottle (60u)", 2000, 1),
		/datum/reagent/medicine/kyphotorin = offer_data("kyphotorin bottle (60u)", 4000, 1),
		/datum/reagent/nanites/uncapped/control_booster_utility = offer_data("Control Booster Utility bottle (60u)", 30000, 1),
		/datum/reagent/nanites/uncapped/control_booster_combat = offer_data("Control Booster Combat bottle (60u)", 30000, 1)
//		/datum/reagent/toxin/slimetoxin
	)
