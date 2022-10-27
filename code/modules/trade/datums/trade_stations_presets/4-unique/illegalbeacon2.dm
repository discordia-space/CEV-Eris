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
		/obj/item/stack/telecrystal = offer_data("telecrystal x50", 100000, 1)
	)
