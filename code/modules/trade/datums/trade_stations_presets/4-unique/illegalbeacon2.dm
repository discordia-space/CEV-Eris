/datum/trade_station/illegaltrader2
	name_pool = list(
		"NSTB 'Arau'" = "Null-Space Trade Beacon 'Arau'. The Trade Beacon is sending an automatized message. \"Hey, Buddie. Interested in our legal goods?"
	)
	uid = "illegal2"
	start_discovered = TRUE//FALSE
	spawn_always = TRUE
	markup = UNIQUE_GOODS
	offer_limit = 20
	base_income = 1600
	wealth = 0
	secret_inv_threshold = 6000
	recommendations_needed = 3
	assortiment = list(
		// TEST: pricing should be tested. Guideline is 775 credits per TC.
		"RIG and RIG Accessories" = list(
			/obj/item/rig/merc,
			/obj/item/rig_module/vision/thermal,
			/obj/item/rig_module/mounted/egun
		),
		"Tools" = list(
			/obj/item/storage/box/syndie_kit/gentleman_kit,
			/obj/item/device/shield_diffuser,
			/obj/item/plastique,
			/obj/item/clothing/glasses/powered/thermal/syndi,
			/obj/item/noslipmodule,
			/obj/item/storage/box/syndie_kit/imp_compress
		),
		"Weapons" = list(
			/obj/item/melee/energy/sword,
			/obj/item/organ_module/active/simple/armblade/energy_blade,
			/obj/item/gun/projectile/mandella
		)
	)
	secret_inventory = list(
		"Firearms" = list(
			/obj/item/gun/projectile/automatic/c20r = custom_good_amount_range(list(1, 1)),
			/obj/item/gun/projectile/automatic/sts35 = custom_good_amount_range(list(1, 1))
		),
		"RIG Modules" = list(
			/obj/item/rig_module/autodoc,
			/obj/item/rig_module/mounted,
			/obj/item/rig_module/fabricator,
			/obj/item/rig_module/fabricator/energy_net
		)
	)
	offer_types = list(
		/obj/item/stack/telecrystal = offer_data("telecrystal x50", 100000, 1)
	)
