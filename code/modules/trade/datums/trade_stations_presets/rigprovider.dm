/datum/trade_station/rigvider
	name_pool = list("HTB 'Boris'" = "Hardsuit Trade Beacon 'Boris'. They're sending a message. \"Hello there, we are hardsuit salvagers. We will be around the system for some time and we have leftover stock. We can sell some off if you want them.")
	assortiment = list(
		"Voidsuits" = list(
			/obj/item/clothing/suit/space/void,
			/obj/item/clothing/suit/space/void/atmos = custom_good_amount_range(list(1, 5)),
			/obj/item/clothing/suit/space/void/mining = custom_good_amount_range(list(1, 5)),
			/obj/item/clothing/suit/space/void/engineering = custom_good_amount_range(list(-5, 3)),
			/obj/item/clothing/suit/space/void/medical = custom_good_amount_range(list(-5, 3)),
			/obj/item/clothing/suit/space/void/security = custom_good_amount_range(list(-5, 1))
		),
		"RIGs" =  list(
			/obj/item/rig/eva = custom_good_amount_range(list(1, 5)),
			/obj/item/rig/medical = custom_good_amount_range(list(1, 5)),
			/obj/item/rig/light = custom_good_amount_range(list(1, 5)),
			/obj/item/rig/hazmat = custom_good_amount_range(list(1, 5)),
			/obj/item/rig/combat = custom_good_amount_range(list(1, 5)),
			/obj/item/rig/hazard = custom_good_amount_range(list(1, 5)),
			/obj/item/rig/industrial = custom_good_amount_range(list(1, 5))
		),
		"RIG Specialized Modules" = list(
			/obj/item/rig_module/storage = good_data("Internal Storage compartment", list(1, 10)),
			/obj/item/rig_module/maneuvering_jets = good_data("Mounted Jetpack", list(1, 10)),
			/obj/item/rig_module/device/flash = good_data("Mounted Flash", list(1, 10)),
			/obj/item/rig_module/mounted/egun = good_data("Mounted Energy Gun", list(1, 10)),
			/obj/item/rig_module/mounted/taser = good_data("Mounted Taser", list(1, 10)),
			/obj/item/rig_module/device/drill = good_data("Mounted Drill", list(1, 10)),
			/obj/item/rig_module/device/orescanner = good_data("Mounted Ore Scanner", list(1, 10)),
			/obj/item/rig_module/device/anomaly_scanner = good_data("Mounted Anomaly Scanner", list(1,10)),
			/obj/item/rig_module/device/rcd = good_data("Mounted RCD", list(1, 10)),
			/obj/item/rig_module/device/healthscanner = good_data("Mounted Health Scanner", list(1, 10)),
			/obj/item/rig_module/chem_dispenser/ninja = good_data("Mounted Chemical Dispenser (small version)", list(-3, 2)),
			/obj/item/rig_module/ai_container,
			/obj/item/rig_module/power_sink,
			/obj/item/rig_module/vision/meson,
			/obj/item/rig_module/vision/nvg,
			/obj/item/rig_module/vision/sechud,
			/obj/item/rig_module/vision/medhud
		)
	)
