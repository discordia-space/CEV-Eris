/datum/trade_station/serbfrigate
	name_pool = list(
		"STF \'Kovac\'" = "Serbian Trade Freighter \'Kovac\': \"Come with money for very good stuff! You can pay with your life, even!\"",
		"SV \'Zoric\'" = "Serbian Vessel \'Zoric\': \"For the correct price, we can sell you something... even jobs!\""
	)
	icon_states = list("serb_frigate", "ship")
	uid = "serbian"
	tree_x = 0.58
	tree_y = 0.5
	start_discovered = FALSE
	spawn_always = TRUE
	markup = RARE_GOODS
	offer_limit = 20
	base_income = 1600
	wealth = 0
	hidden_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("illegal2")
	recommendations_needed = 2
	inventory = list(
		"Guns" = list(
			/obj/item/gun/projectile/boltgun/serbian = custom_good_amount_range(list(1, 10)),
			/obj/item/gun/projectile/automatic/ak47/sa = custom_good_amount_range(list(1, 3)),
			/obj/item/gun/projectile/kovacs = custom_good_amount_range(list(1, 3)),
			/obj/item/ammo_magazine/sllrifle,
			/obj/item/ammo_magazine/lrifle,
			/obj/item/ammo_magazine/lrifle/pk = custom_good_amount_range(list(1, 2)),
			/obj/item/ammo_magazine/lrifle/drum = custom_good_amount_range(list(2, 5)),
			/obj/item/ammo_magazine/m12/empty,
			/obj/item/ammo_magazine/ammobox/shotgun,
			/obj/item/ammo_magazine/ammobox/shotgun/buckshot = custom_good_name("ammunition box (.50 pellet)"),
			/obj/item/ammo_magazine/ammobox/shotgun/incendiaryshells = custom_good_name("ammunition box (.50 incendiary)")
		),
		"Serbian Attire" = list(
			/obj/item/clothing/under/serbiansuit,
			/obj/item/clothing/under/serbiansuit/brown,
			/obj/item/clothing/under/serbiansuit/black,
			/obj/item/clothing/head/soft/green2soft,
			/obj/item/clothing/head/soft/tan2soft,
			/obj/item/clothing/suit/armor/flak/green,
			/obj/item/clothing/suit/armor/flak,
			/obj/item/clothing/suit/armor/platecarrier/green,
			/obj/item/clothing/suit/armor/platecarrier/tan,
			/obj/item/clothing/suit/armor/platecarrier,
			/obj/item/clothing/head/armor/steelpot,
			/obj/item/clothing/head/armor/faceshield/altyn/maska,
			/obj/item/clothing/head/armor/faceshield/altyn/brown = custom_good_name("brown altyn helmet"),
			/obj/item/clothing/head/armor/faceshield/altyn/black = custom_good_name("black altyn helmet"),
			/obj/item/clothing/mask/balaclava/tactical,
			/obj/item/clothing/shoes/jackboots,
			/obj/item/clothing/gloves/fingerless,
			/obj/item/clothing/suit/storage/greatcoat/serbian_overcoat_brown,
			/obj/item/clothing/suit/storage/greatcoat/serbian_overcoat
		)
	)
	hidden_inventory = list(
		"Guns II" = list(
			/obj/item/gun/projectile/automatic/lmg/pk = custom_good_amount_range(list(1, 1)),
			/obj/item/gun/projectile/shotgun/bojevic = custom_good_amount_range(list(1, 1)),
			/obj/item/computer_hardware/hard_drive/portable/design/guns/sa_boltgun = good_data("Novakovic design disk", list(1, 1), null),
			/obj/item/computer_hardware/hard_drive/portable/design/guns/sa_ak = good_data("Krinkov design disk", list(1, 1), null),
			/obj/item/computer_hardware/hard_drive/portable/design/guns/sa_br = good_data("Kovacs design disk", list(1, 1), null)
		)
	)
	offer_types = list(
		/obj/item/part/gun/frame/kovacs  = offer_data("Kovacs frame", 800, 2),
		/obj/item/part/gun/frame/zoric  = offer_data("Zoric frame", 2000, 2),
		/obj/item/part/gun/frame/pk  = offer_data("Pulemyot Kalashnikova frame", 3000, 2)
	)
