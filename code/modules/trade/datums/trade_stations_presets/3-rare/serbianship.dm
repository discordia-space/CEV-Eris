/datum/trade_station/serbfrigate
	name_pool = list(
		"STF 'Kovac'" = "Serbian Trade Freighter 'Kovac': \"Come with money for very good stuff! You can pay with your life, even!\"",
		"SV 'Zoric'" = "Serbian Vessel 'Zoric': \"For the correct price, we can sell you something... even jobs!\""
	)
	icon_states = "serb_frigate"
	uid = "serbian"
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
			/obj/item/ammo_magazine/m12/empty,
			/obj/item/ammo_magazine/ammobox/shotgun,
			/obj/item/ammo_magazine/ammobox/shotgun/buckshot = custom_good_name("ammunition box (.50 pellet)"),
			/obj/item/ammo_magazine/ammobox/shotgun/incendiaryshells = custom_good_name("ammunition box (.50 incendiary)")
		)
	)
	hidden_inventory = list(
		"Guns II" = list(
			/obj/item/gun/projectile/automatic/lmg/pk = custom_good_amount_range(list(1, 1)),
			/obj/item/gun/projectile/shotgun/bojevic = custom_good_amount_range(list(1, 1)),
			/obj/item/computer_hardware/hard_drive/portable/design/guns/sa_boltgun = good_data("Novakovic design disk", list(1, 1)),
			/obj/item/computer_hardware/hard_drive/portable/design/guns/sa_ak = good_data("Krinkov design disk", list(1, 1)),
			/obj/item/computer_hardware/hard_drive/portable/design/guns/sa_br = good_data("Kovacs design disk", list(1, 1))
		)
	)
	offer_types = list(
		/obj/item/part/gun/frame/boltgun  = offer_data("boltgun frame", 800, 2),
		/obj/item/part/gun/frame/kovacs  = offer_data("Kovacs frame", 1000, 2),
		/obj/item/part/gun/frame/ak47  = offer_data("AK frame", 800, 2),
		/obj/item/part/gun/frame/zoric  = offer_data("Zoric frame", 1000, 2),
		/obj/item/part/gun/frame/pk  = offer_data("Pulemyot Kalashnikova frame", 1000, 2)
	)
