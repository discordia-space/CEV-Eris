/datum/trade_station/nt_cruisers
	name_pool = list(
		"NTV 'Faith'" = "NeoTheology Vessel 'Faith': \"The most holy purveyors of ecclesiarchic goods!\"",
	)
	icon_states = "nt_cruiser"
	uid = "nt_basic"
	start_discovered = TRUE
	spawn_always = TRUE
	markup = UNCOMMON_GOODS		// dept-specific stuff should be more expensive for guild
	base_income = 1600
	wealth = 0
	secret_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("nt_uncommon")
	assortiment = list(
		"Biomatter Products" = list(
			/obj/item/reagent_containers/food/snacks/meat,
			/obj/item/reagent_containers/food/drinks/milk,
			/obj/item/soap/nanotrasen,
			/obj/item/storage/pouch/medical_supply,
			/obj/item/storage/pouch/engineering_tools,
			/obj/item/storage/pouch/engineering_supply,
			/obj/item/storage/pouch/engineering_material,
			/obj/item/storage/pouch/tubular,
			/obj/item/storage/pouch/tubular/vial,
			/obj/item/storage/pouch/ammo,
			/obj/item/clothing/accessory/holster,
			/obj/item/clothing/accessory/holster/armpit,
			/obj/item/clothing/accessory/holster/waist,
			/obj/item/clothing/accessory/holster/hip
		),
		"Energy Weapons" = list(
			/obj/item/gun/energy/taser,
			/obj/item/gun/energy/nt_svalinn,
			/obj/item/gun/energy/laser = custom_good_amount_range(list(1, 5))
		),
		"Ballistic Weapons" = list(
			/obj/item/gun/projectile/mk58,
			/obj/item/gun/projectile/mk58/wood,
			/obj/item/gun/projectile/shotgun/pump/regulator,
			/obj/item/gun/projectile/shotgun/pump/grenade
		)
	)
	offer_types = list(
		/obj/item/implant/core_implant/cruciform = offer_data("cruciform", 2500, 3),
		/obj/item/book/ritual/cruciform = offer_data("Neotheology ritual book", 600, 5),		// base price: 300
		/obj/item/oddity/common/towel = offer_data("trustworthy towel", 800, 1)
	)
