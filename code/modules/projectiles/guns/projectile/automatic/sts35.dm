/obj/item/weapon/gun/projectile/automatic/sts35
	name = "STS-35"
	desc = "The rugged STS-35 is a durable automatic weapon, popular on frontier worlds. Uses 7.62mm rounds. This one is unmarked."
	icon_state = "sts"
	item_state = "sts"
	w_class = ITEM_SIZE_LARGE
	force = WEAPON_FORCE_PAINFUL
	caliber = "a762"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	mag_well = MAG_WELL_CIVI_RIFLE|MAG_WELL_AK
	magazine_type = /obj/item/ammo_magazine/c762_short
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 12)
	price_tag = 3300
	fire_sound = 'sound/weapons/guns/fire/ltrifle_fire.ogg'
	unload_sound 	= 'sound/weapons/guns/interact/ltrifle_magout.ogg'
	reload_sound 	= 'sound/weapons/guns/interact/ltrifle_magin.ogg'
	cocked_sound 	= 'sound/weapons/guns/interact/ltrifle_cock.ogg'


	firemodes = list(
		FULL_AUTO_400,
		SEMI_AUTO_NODELAY,
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,     icon="burst"),
		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=6,     icon="burst"),
		)

/obj/item/weapon/gun/projectile/automatic/sts35/update_icon(var/ignore_inhands)
	..()
	icon_state = "[initial(icon_state)][ammo_magazine? "-[ammo_magazine.max_ammo]": ""]"
	if(!ignore_inhands)
		update_wear_icon()
