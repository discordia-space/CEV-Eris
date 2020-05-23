/obj/item/weapon/gun/projectile/underslung
	name = "underslung grenade launcher"
	desc = "Not much more than a tube and a firing mechanism, this grenade launcher is designed to be fitted to a rifle."
	fire_sound = 'sound/weapons/guns/fire/grenadelauncher_fire.ogg'
	bulletinsert_sound = 'sound/weapons/guns/interact/batrifle_magin.ogg'   //Placeholder, could use a new sound
	w_class = ITEM_SIZE_NORMAL
	matter = null
	force = 5
	max_shells = 1
	safety = FALSE
	twohanded = FALSE
	caliber = CAL_GRENADE
	handle_casings = EJECT_CASINGS
/obj/item/weapon/gun/projectile/underslung/attack_self()
	return

