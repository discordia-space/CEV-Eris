/obj/item/weapon/gun/energy/crossbow
	name = "NT EC \"Nemesis\""
	desc = "Mini energy crossbow, produced by old Nanotrasen, discontinued now. A weapon favored by many mercenary stealth specialists."
	icon_state = "crossbow"
	w_class = 2.0
	item_state = "crossbow"
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 2, TECH_ILLEGAL = 5)
	matter = list(DEFAULT_WALL_MATERIAL = 2000)
	slot_flags = SLOT_BELT
	silenced = 1
	fire_sound = 'sound/weapons/Genhit.ogg'
	projectile_type = /obj/item/projectile/energy/bolt
	max_shots = 5
	self_recharge = 1
	charge_meter = 0

/obj/item/weapon/gun/energy/crossbow/ninja
	name = "energy dart thrower"
	projectile_type = /obj/item/projectile/energy/dart

/obj/item/weapon/gun/energy/crossbow/largecrossbow
	name = "NT EC \"Themis\""
	desc = "Energy crossbow, produced by old Nanotrasen, discontinued now. A weapon favored by mercenary infiltration teams."
	w_class = 4
	force = WEAPON_FORCE_PAINFULL
	matter = list(DEFAULT_WALL_MATERIAL = 200000)
	projectile_type = /obj/item/projectile/energy/bolt/large
