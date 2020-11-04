/obj/item/weapon/gun/energy/crossbow
	name = "NT EC \"Nemesis\""
	desc = "Mini energy crossbow, produced by old Nanotrasen, discontinued now. A weapon favored by many mercenary stealth specialists."
	icon = 'icons/obj/guns/energy/crossbow.dmi'
	icon_state = "crossbow"
	w_class = ITEM_SIZE_SMALL
	can_dual = 1
	item_state = "crossbow"
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2, TECH_COVERT = 5)
	matter = list(MATERIAL_PLASTEEL = 15, MATERIAL_PLASTIC = 10, MATERIAL_SILVER = 6, MATERIAL_URANIUM = 6)
	slot_flags = SLOT_BELT
	silenced = 1
	fire_sound = 'sound/weapons/Genhit.ogg'
	projectile_type = /obj/item/projectile/energy/bolt
	self_recharge = 1
	charge_meter = 0
	charge_cost = 200
	price_tag = 2500

/obj/item/weapon/gun/energy/crossbow/ninja
	name = "energy dart thrower"
	projectile_type = /obj/item/projectile/energy/dart
	safety = FALSE
	restrict_safety = TRUE

/obj/item/weapon/gun/energy/crossbow/largecrossbow
	name = "NT EC \"Themis\""
	desc = "Energy crossbow, produced by old Nanotrasen, discontinued now. A weapon favored by mercenary infiltration teams."
	w_class = ITEM_SIZE_BULKY
	force = WEAPON_FORCE_NORMAL
	matter = list(MATERIAL_PLASTEEL = 35, MATERIAL_PLASTIC = 20, MATERIAL_SILVER = 9, MATERIAL_URANIUM = 9)
	projectile_type = /obj/item/projectile/energy/bolt/large
	price_tag = 4000