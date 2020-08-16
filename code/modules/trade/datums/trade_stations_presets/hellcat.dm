/datum/trade_station/fbv_hellcat
	name_pool = list("FBV 'Hellcat'" = "They are sending message, \"Greetings. This is the Hellcat. We're currently escorting the Caduceus and we will be departing the system shortly alongside them. We are willing to depart with some extra supplies to get rid of while we're still here.\"")
	icon_states = "ship"
	max_missing_assortiment = 8
	spawn_probability = 0
	start_discovered = TRUE
	forced_overmap_zone = list(
		list(15, 20),
		list(20, 25)
	)
	assortiment = list(
		"Enforce Equipment" = list(
			/obj/item/weapon/storage/box/emps,
			/obj/item/weapon/grenade/smokebomb,
			/obj/item/weapon/grenade/chem_grenade/incendiary,
			/obj/item/weapon/handcuffs,
			/obj/item/weapon/shield/riot,
			/obj/item/weapon/storage/box/flashbangs,
			/obj/item/weapon/melee/baton,
			/obj/machinery/deployable/barrier,
			/obj/machinery/shieldwallgen,
		),
		"Energy weapon" = list(
			/obj/item/weapon/gun/energy/gun/martin,
			/obj/item/weapon/gun/energy/laser,
		),
		"Projectile weapon" = list(
			/obj/item/weapon/gun/projectile/paco,
			/obj/item/weapon/gun/projectile/clarissa,
			/obj/item/weapon/gun/projectile/olivaw,
			/obj/item/weapon/gun/projectile/revolver/havelock,
			/obj/item/weapon/gun/projectile/revolver/consul,
			/obj/item/weapon/gun/projectile/automatic/ak47/fs,
			/obj/item/weapon/gun/projectile/automatic/atreides,
		),
		"Armor" = list(
			/obj/item/clothing/head/armor/riot_hud,
			/obj/item/clothing/suit/armor/vest,
			/obj/item/clothing/suit/armor/vest/security,
			/obj/item/clothing/suit/armor/vest/detective,
			/obj/item/clothing/suit/storage/vest,
			/obj/item/clothing/head/armor/helmet,
			/obj/item/clothing/suit/armor/bulletproof,
			/obj/item/clothing/suit/armor/laserproof,
		),
	)

	offer_types = list()
