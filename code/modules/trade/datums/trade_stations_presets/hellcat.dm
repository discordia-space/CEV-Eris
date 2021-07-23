/datum/trade_station/fbv_hellcat
	name_pool = list("FBV 'Hellcat'" = "They are sending message, \"Greetings. This is the Hellcat. We're currently escorting the Caduceus and we will be departing the system shortly alongside them. We are willing to depart with some extra supplies to get rid of while we're still here.\"")
	icon_states = "ihs_destroyer"
	start_discovered = TRUE
	spawn_always = TRUE
	markup = 0.5
	forced_overmap_zone = list(
		list(15, 20),
		list(20, 25)
	)
	assortiment = list(
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
			/obj/item/storage/box/shotgunammo/slug,
			/obj/item/storage/box/shotgunammo/buckshot,
			/obj/item/storage/box/shotgunammo/beanbags
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
		),
	)
	
	offer_types = list(
	)
