/datum/trade_station/fbv_hellcat
	name_pool = list(
		"FBV \'Hellcat\'" = "\"Greetings. This is the Hellcat. We\'re currently escorting the Caduceus and we will be departing the system shortly alongside them. We are willing to part with our spare supplies while we\'re here.\""
	)
	forced_overmap_zone = list(
		list(15, 20),
		list(20, 25)
	)
	icon_states = list("ihs_destroyer", "ship")
	uid = "guns_basic"
	tree_x = 0.74
	tree_y = 0.9
	start_discovered = TRUE
	spawn_always = TRUE
	markup = WHOLESALE_GOODS
	offer_limit = 20
	base_income = 1600
	wealth = 0
	hidden_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("fs_ammo", "style")
	inventory = list(
		"Design Disks" = list(
			/obj/item/computer_hardware/hard_drive/portable/design/nonlethal_ammo = good_data("Frozen Star Nonlethal Magazines Pack", list(1, 10), 500),
			/obj/item/computer_hardware/hard_drive/portable/design/lethal_ammo = good_data("Frozen Star Lethal Magazines Pack", list(1, 10), 1000)
		),
		"Enforce Equipment" = list(
			/obj/item/handcuffs,
			/obj/item/shield/riot,
			/obj/item/melee/baton
		),
		"Energy Weapons" = list(
			/obj/item/gun/energy/gun/martin,
			/obj/item/gun/energy/retro
		),
		"Ballistic Weapons" = list(
			/obj/item/gun/projectile/paco,
			/obj/item/gun/projectile/selfload,
			/obj/item/gun/projectile/olivaw,
			/obj/item/gun/projectile/revolver/havelock,
			/obj/item/gun/projectile/automatic/ak47/fs,
			/obj/item/gun/projectile/automatic/atreides,
			/obj/item/gun/projectile/shotgun/pump
		),
		"Ammunition and Accessories" = list(
			/obj/item/grenade/empgrenade/low_yield,
			/obj/item/grenade/smokebomb,
			/obj/item/grenade/flashbang,
			/obj/item/ammo_magazine/ammobox/magnum,
			/obj/item/ammo_magazine/lrifle,
			/obj/item/ammo_magazine/smg,
			/obj/item/ammo_magazine/slpistol,
			/obj/item/ammo_magazine/slpistol/rubber = custom_good_name("speed loader (.35 Auto rubber)"),
			/obj/item/ammo_magazine/pistol,
			/obj/item/ammo_magazine/pistol/rubber = custom_good_name("standard magazine (.35 Auto rubber)"),
			/obj/item/ammo_magazine/hpistol,
			/obj/item/ammo_magazine/hpistol/rubber = custom_good_name("highcap magazine (.35 Auto rubber)"),
			/obj/item/ammo_magazine/ammobox/shotgun = custom_good_name("ammunition box (.50 shells)"),
			/obj/item/ammo_magazine/ammobox/shotgun/buckshot = custom_good_name("ammunition box (.50 pellet)"),
			/obj/item/ammo_magazine/ammobox/shotgun/beanbags = custom_good_name("ammunition box (.50 beanbag)"),
			/obj/item/clothing/accessory/holster,
			/obj/item/clothing/accessory/holster/scabbard,
			/obj/item/clothing/accessory/holster/knife,
			/obj/item/storage/pouch/holster,
			/obj/item/storage/pouch/holster/baton,
			/obj/item/storage/pouch/holster/belt,
			/obj/item/storage/pouch/holster/belt/sheath,
			/obj/item/storage/pouch/holster/belt/knife,
			/obj/item/storage/hcases/ammo
		),
		"Armor" = list(
			/obj/item/clothing/suit/armor/heavy/riot,
			/obj/item/clothing/head/armor/faceshield/riot,
			/obj/item/clothing/suit/armor/vest/security,
			/obj/item/clothing/suit/armor/vest/full/security,
			/obj/item/clothing/head/armor/helmet,
			/obj/item/clothing/suit/armor/bulletproof,
			/obj/item/clothing/suit/armor/bulletproof/full,
			/obj/item/clothing/head/armor/laserproof,
			/obj/item/clothing/suit/armor/laserproof/full
		)
	)
	hidden_inventory = list(
		"Explosive Weapons" = list(
			/obj/item/gun/projectile/shotgun/pump/grenade/china,
			/obj/item/ammo_casing/grenade/weak = custom_good_amount_range(list(6,9))
		)
	)
	offer_types = list(
		/obj/item/oddity/common/photo_crime = offer_data("crime scene photo", 500, 1),
		/obj/item/part/armor = offer_data("armor part", 500, 8),
		/obj/item/part/armor/artwork = offer_data("artistic armor part", 1000, 1),
		/obj/item/part/gun/artwork = offer_data("artistic gun part", 1000, 1),
		/obj/item/gun = offer_data_mods("modified gun (3 upgrades)", 3200, 2, OFFER_MODDED_GUN, 3),
		/obj/item/part/gun/frame/ak47 = offer_data("AK frame", 800, 1),
		/obj/item/part/gun/frame/boltgun  = offer_data("boltgun frame", 800, 1),
		/obj/item/part/gun/frame/sol = offer_data("Sol frame", 2000, 1),
		/obj/item/part/gun/frame/straylight = offer_data("Straylight frame", 2000, 1),
		/obj/item/part/gun/frame/wintermute = offer_data("Wintermute frame", 2000, 1),
		/obj/item/part/gun/frame/kadmin = offer_data("Kadmin frame", 2000, 1),
		/obj/item/part/gun/frame/bull = offer_data("Bull frame", 2000, 1),
		/obj/item/part/gun/frame/gladstone = offer_data("Gladstone frame", 2000, 1),
		/obj/item/part/gun/frame/tk = offer_data("Takeshi frame", 2000, 1),
		/obj/item/part/gun/frame/lamia = offer_data("Lamia frame", 2000, 1),
		/obj/item/part/gun/frame/molly = offer_data("Molly frame", 2000, 1),
		/obj/item/part/gun/frame/consul = offer_data("Consul frame", 2000, 1),
		/obj/item/part/gun/frame/deckard = offer_data("Deckard frame", 2000, 1),
		/obj/item/part/gun/frame/mateba = offer_data("Mateba frame", 2000, 1)
	)
