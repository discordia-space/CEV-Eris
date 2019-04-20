/obj/item/weapon/gun/projectile/rpg
	name = "RPG-7"
	desc = "An ancient rocket-propelled grenade launcher, this model is centuries old, but well preserved."
	icon_state = "rocket"
	item_state = "rocket"
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_PAINFUL
	flags =  CONDUCT
	slot_flags = SLOT_BACK
	caliber = "rocket"
	fire_sound = 'sound/effects/bang.ogg'
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 5)
	matter = list(MATERIAL_PLASTEEL = 30, MATERIAL_PLASTIC = 5, MATERIAL_SILVER = 5)
	price_tag = 8000
	ammo_type = "/obj/item/ammo_casing/rocket"
	load_method = SINGLE_CASING
	handle_casings = EJECT_CASINGS
	max_shells = 1
	recoil = 1.3 //balance concerns
	fire_sound = 'sound/effects/bang.ogg'
	bulletinsert_sound = 'sound/weapons/guns/interact/batrifle_magin.ogg' //placeholder
