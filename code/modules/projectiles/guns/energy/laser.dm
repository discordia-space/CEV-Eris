/obj/item/weapon/gun/energy/laser
	name = "NT LG \"Lightfall\""
	desc = "NeoTheology brand laser carabin. Deadly and radiant, like ire of God it should represent."
	icon_state = "laser"
	item_state = "laser"
	fire_sound = 'sound/weapons/Laser.ogg'
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = ITEM_SIZE_NORMAL
	force = WEAPON_FORCE_NORMAL
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_WOOD = 8, MATERIAL_SILVER = 5)
	projectile_type = /obj/item/projectile/beam/midlaser

/obj/item/weapon/gun/energy/laser/mounted
	self_recharge = 1
	use_external_power = 1

/obj/item/weapon/gun/energy/laser/practice
	name = "NT LG \"Lightfall\" - P"
	desc = "A modified version of the NeoTheology brand laser carabin, this one fires less concentrated energy bolts designed for target practice."
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_WOOD = 8, MATERIAL_SILVER = 2)
	projectile_type = /obj/item/projectile/beam/practice

obj/item/weapon/gun/energy/retro
	name = "Alliance LG \"Cog\""
	icon_state = "retro"
	item_state = "retro"
	desc = "Alliance cheap laser gun. In our deep past - this was main weapon of low-rank police force across all Milky Way, bilions copys of this gun was made. They still can be found almoust everywhere."
	fire_sound = 'sound/weapons/Laser.ogg'
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_NORMAL
	projectile_type = /obj/item/projectile/beam
	fire_delay = 10 //old technology

/obj/item/weapon/gun/energy/captain
	name = "NT LG \"Destiny\""
	icon_state = "caplaser"
	item_state = "caplaser"
	desc = "This weapon is old, yet still robust and reliable. Its marked with old Nanotrasen brand, like a last reminder of what this corporation was, before church take control of everything."
	force = WEAPON_FORCE_PAINFULL
	fire_sound = 'sound/weapons/Laser.ogg'
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_NORMAL
	projectile_type = /obj/item/projectile/beam
	origin_tech = null
	self_recharge = 1

/obj/item/weapon/gun/energy/lasercannon
	name = "Prototype: laser cannon"
	desc = "With the laser cannon, the lasing medium is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core. This incredible technology may help YOU achieve high excitation rates with small laser volumes!"
	icon_state = "lasercannon"
	item_state = null
	fire_sound = 'sound/weapons/lasercannonfire.ogg'
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	slot_flags = SLOT_BELT|SLOT_BACK
	projectile_type = /obj/item/projectile/beam/heavylaser
	charge_cost = 250
	fire_delay = 20

/obj/item/weapon/gun/energy/lasercannon/mounted
	name = "mounted laser cannon"
	self_recharge = 1
	use_external_power = 1
	recharge_time = 10
