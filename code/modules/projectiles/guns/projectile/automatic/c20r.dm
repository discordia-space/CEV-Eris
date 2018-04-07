/obj/item/weapon/gun/projectile/automatic/c20r
	name = "C-20r"
	desc = "The C-20r is a lightweight and rapid firing SMG, for when you REALLY need someone dead. Uses 10mm rounds. Has a 'Scarborough Arms - Per falcis, per pravitas' buttstamp."
	icon_state = "c20r"
	item_state = "c20r"
	w_class = ITEM_SIZE_NORMAL
	force = WEAPON_FORCE_PAINFULL
	caliber = "10mm"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	slot_flags = SLOT_BELT|SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a10mm
	auto_eject = TRUE
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 12)
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	unload_sound 	= 'sound/weapons/guns/interact/sfrifle_magout.ogg'
	reload_sound 	= 'sound/weapons/guns/interact/sfrifle_magin.ogg'
	cocked_sound 	= 'sound/weapons/guns/interact/sfrifle_cock.ogg'

/obj/item/weapon/gun/projectile/automatic/c20r/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "c20r-[round(ammo_magazine.stored_ammo.len,4)]"
	else
		icon_state = "c20r"
	return
