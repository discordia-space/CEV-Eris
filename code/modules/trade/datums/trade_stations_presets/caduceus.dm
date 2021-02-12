/datum/trade_station/caduceus
	name_pool = list("MAV 'Caduceus'" = "Moebius Aid Vessel 'Caduceus'. They're sending a message. \"Hello there, we are from the Old Sol Republic. We will be leaving the system shortly but we can offer you any medical aid while we are still here.\".")
	icon_states = "ship"
	start_discovered = TRUE
	spawn_always = TRUE

	forced_overmap_zone = list(
		list(20, 22),
		list(20, 25)
	)
	assortiment = list(
		"First Aid" = list(
			/obj/item/weapon/storage/firstaid/regular,
			/obj/item/weapon/storage/firstaid/fire,
			/obj/item/weapon/storage/firstaid/toxin,
			/obj/item/weapon/storage/firstaid/o2,
			/obj/item/weapon/storage/firstaid/adv,
		),
		"Surgery" = list(
			/obj/item/weapon/tool/cautery,
			/obj/item/weapon/tool/surgicaldrill,
			/obj/item/weapon/tank/anesthetic,
			/obj/item/weapon/tool/hemostat,
			/obj/item/weapon/tool/scalpel,
			/obj/item/weapon/tool/retractor,
			/obj/item/weapon/tool/bonesetter,
			/obj/item/weapon/tool/saw/circular,
		),
		"Blood" = list(
			/obj/structure/medical_stand,
			/obj/item/weapon/reagent_containers/blood/empty,
			/obj/item/weapon/reagent_containers/blood/APlus,
			/obj/item/weapon/reagent_containers/blood/AMinus,
			/obj/item/weapon/reagent_containers/blood/BPlus,
			/obj/item/weapon/reagent_containers/blood/BMinus,
			/obj/item/weapon/reagent_containers/blood/OPlus,
			/obj/item/weapon/reagent_containers/blood/OMinus,
		),
		"Misc" = list(
			/obj/item/weapon/virusdish/random,
			/obj/structure/reagent_dispensers/coolanttank,
			/obj/item/clothing/mask/breath/medical,
			/obj/item/clothing/mask/surgical,
			/obj/item/clothing/gloves/latex,
			/obj/item/weapon/reagent_containers/syringe,
			/obj/item/weapon/reagent_containers/hypospray/autoinjector,
			/obj/item/bodybag,
			/obj/machinery/suspension_gen,
			/obj/item/weapon/computer_hardware/hard_drive/portable/design
		),
	)

	offer_types = list(
			/obj/item/weapon/reagent_containers/blood/APlus,
			/obj/item/weapon/reagent_containers/blood/AMinus,
			/obj/item/weapon/reagent_containers/blood/BPlus,
			/obj/item/weapon/reagent_containers/blood/BMinus,
			/obj/item/weapon/reagent_containers/blood/OPlus,
			/obj/item/weapon/reagent_containers/blood/OMinus,
			/obj/item/weapon/storage/firstaid/regular,
			/obj/item/weapon/storage/firstaid/fire,
			/obj/item/weapon/storage/firstaid/toxin,
			/obj/item/weapon/storage/firstaid/o2,
			/obj/item/weapon/storage/firstaid/adv,
		)
