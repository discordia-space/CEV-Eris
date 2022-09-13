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
			/obj/item/computer_hardware/hard_drive/portable/design/medical = good_data("Moebius Medical Designs", list(1, 10), 400),
			/obj/item/computer_hardware/hard_drive/portable/design/computer = good_data("Moebius Computer Parts", list(1, 10), 500)
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
			/obj/item/computer_hardware/hard_drive/portable/basic,
			/obj/item/storage/hcases/med
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
		/obj/item/oddity/common/healthscanner = offer_data("odd health scanner", 500, 1),
		/obj/item/oddity/common/disk = offer_data("broken design disk", 500, 1),
		/obj/item/oddity/common/device = offer_data("odd device", 500, 1),
		/datum/reagent/stim/mbr = offer_data("Machine Binding Ritual bottle (60u)", 1500, 1),
		/datum/reagent/stim/cherrydrops = offer_data("Cherry Drops bottle (60u)", 1500, 1),
		/datum/reagent/stim/pro_surgeon = offer_data("ProSurgeon bottle (60u)", 1500, 1),
		/datum/reagent/stim/violence = offer_data("Violence bottle (60u)", 1500, 1),
		/datum/reagent/stim/bouncer = offer_data("Bouncer bottle (60u)", 1500, 1),
		/datum/reagent/medicine/ossisine = offer_data("ossisine bottle (60u)", 4000, 1),
		/datum/reagent/medicine/kyphotorin = offer_data("kyphotorin bottle (60u)", 8000, 1)
	)
