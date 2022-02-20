/datum/trade_station/fbv_hellcat
	name_pool = list(
		"FBV 'Hellcat'" = "\"Greetings. This is the Hellcat. We're currently escorting the Caduceus and we will be departing the system shortly alongside them. We are willing to part with our spare supplies while we're here.\""
	)
	icon_states = "ihs_destroyer"
	forced_overmap_zone = list(
		list(15, 20),
		list(20, 25)
	)
	uid = "guns_basic"
	start_discovered = TRUE
	spawn_always = TRUE
	markup = WHOLESALE_GOODS
	offer_limit = 20
	base_income = 1600
	wealth = 0
	hidden_inv_threshold = 2000
	recommendation_threshold = 4000
	stations_recommended = list("fs_guns", "fs_ammo")
	inventory = list(
		"Enforce Equipment" = list(
			/obj/item/handcuffs,
			/obj/item/shield/riot,
			/obj/item/melee/baton,
			/obj/machinery/deployable/barrier,
			/obj/machinery/shieldwallgen
		),
		"Energy weapons" = list(
			/obj/item/gun/energy/gun/martin,
			/obj/item/gun/energy/laser
		),
		"Ballistic weapons" = list(
			/obj/item/gun/projectile/paco,
			/obj/item/gun/projectile/selfload,
			/obj/item/gun/projectile/olivaw,
			/obj/item/gun/projectile/revolver/havelock,
			/obj/item/gun/projectile/revolver/consul,
			/obj/item/gun/projectile/automatic/ak47/fs/ih,
			/obj/item/gun/projectile/automatic/atreides,
			/obj/item/gun/projectile/shotgun/pump,
			/obj/item/gun/projectile/shotgun/pump/gladstone
		),
		"Ammunition" = list(
			/obj/item/grenade/empgrenade/low_yield,
			/obj/item/grenade/smokebomb,
			/obj/item/grenade/flashbang,
			/obj/item/ammo_magazine/ammobox/magnum,
			/obj/item/ammo_magazine/lrifle,
			/obj/item/ammo_magazine/smg,
			/obj/item/ammo_magazine/pistol,
			/obj/item/ammo_magazine/hpistol,
			/obj/item/ammo_magazine/ammobox/shotgun,
			/obj/item/ammo_magazine/ammobox/shotgun/buckshot,
			/obj/item/ammo_magazine/ammobox/shotgun/beanbags
		),
		"Armor" = list(
			/obj/item/clothing/suit/armor/heavy/riot,
			/obj/item/clothing/head/armor/riot_hud,
			/obj/item/clothing/suit/armor/vest,
			/obj/item/clothing/suit/armor/vest/security,
			/obj/item/clothing/head/armor/helmet,
			/obj/item/clothing/suit/armor/bulletproof,
			/obj/item/clothing/head/armor/bulletproof/ironhammer_nvg,
			/obj/item/clothing/suit/armor/laserproof/full,
			/obj/item/clothing/head/armor/laserproof
		)
	)
	hidden_inventory = list(
		"Basic Gun Mods" = list(
			/obj/item/gun_upgrade/barrel/forged,
			/obj/item/gun_upgrade/mechanism/gravcharger,
			/obj/item/tool_upgrade/productivity/ergonomic_grip,
			/obj/item/tool_upgrade/refinement/laserguide
		)
	)
	offer_types = list(
		/obj/item/part/gun = offer_data("gun part", 100, 10),					// base price: 100, guns can be bought and broken down into 4 parts
		/obj/item/part/armor = offer_data("armor part", 500, 10)				// base price: 300
	)
