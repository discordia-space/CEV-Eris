/datum/trade_station/illegaltrader2
	name_pool = list(
		"NSTB \'Introversion\'" = "Null-Space Trade Beacon \'Introversion\'. The Trade Beacon is sending an automated message. \"Uplink established. Welcome, agent.\""
	)
	icon_states = list("htu_station", "station")
	uid = "illegal2"
	tree_x = 0.62
	tree_y = 0.3
	start_discovered = FALSE
	spawn_always = TRUE
	markup = RARE_GOODS
	offer_limit = 20
	base_income = 1600
	wealth = 0
	hidden_inv_threshold = 6000
	recommendations_needed = 3
	inventory = list(
		// Guideline is 775 credits per TC.
		"RIG and RIG Accessories" = list(
			/obj/item/rig/merc = custom_good_price(15500),
			/obj/item/rig_module/vision/thermal = custom_good_price(4650),
			/obj/item/rig_module/mounted/egun = custom_good_price(5425)
		),
		"Tools" = list(
			/obj/item/storage/box/syndie_kit/gentleman_kit = custom_good_price(2325),
			/obj/item/device/shield_diffuser = custom_good_price(3100),
			/obj/item/plastique = custom_good_price(2325),
			/obj/item/clothing/glasses/powered/thermal/syndi = custom_good_price(9300),
			/obj/item/noslipmodule = custom_good_price(775),
			/obj/item/storage/box/syndie_kit/imp_compress = custom_good_price(3100)
		),
		"Weapons" = list(
			/obj/item/melee/energy/sword = custom_good_price(4650),
			/obj/item/organ_module/active/simple/armblade/energy_blade = custom_good_price(4650),
			/obj/item/gun/projectile/mandella = custom_good_price(4650)
		)
	)
	hidden_inventory = list(
		"Firearms" = list(
			/obj/item/gun/projectile/automatic/c20r = custom_good_amount_range(list(1, 1)),
			/obj/item/gun/projectile/automatic/sts35 = custom_good_amount_range(list(1, 1))
		),
		"RIG Modules" = list(
			/obj/item/rig_module/autodoc = custom_good_price(8525),
			/obj/item/rig_module/mounted = custom_good_price(10850),
			/obj/item/rig_module/fabricator = custom_good_price(4650),
			/obj/item/rig_module/fabricator/energy_net = custom_good_price(3875)
		),
		"Software" = list(
			/obj/item/computer_hardware/hard_drive/portable/advanced/shady = good_data("old data disk", list(1, 1), 10000)
		)
	)
	offer_types = list(
		/obj/item/biosyphon = offer_data("Bluespace Biosyphon", 35000, 1),
		/obj/item/reagent_containers/bonsai = offer_data("Laurelin Bonsai", 35000, 1),
		/obj/item/reagent_containers/atomic_distillery = offer_data("Atomic Distillery", 35000, 1),
		/obj/item/device/von_krabin = offer_data("Von-Krabin Stimulator", 35000, 1),
		/obj/item/complicator = offer_data("Reality Complicator", 35000, 1),
		/obj/item/gun/projectile/revolver/sky_driver = offer_data(".35 Auto \"Sky Driver\" Revolver", 50000, 1),
		/obj/item/tool/sword/nt_sword = offer_data("The Sword of Truth", 50000, 1),
		/obj/machinery/nuclearbomb = offer_data("nuclear weapon", 50000, 1),
		/obj/item/stack/telecrystal = offer_data("telecrystal x50", 100000, 1)
	)
