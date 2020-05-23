/obj/item/weapon/gun/projectile/grenade/lenar
	name = "FS GL \"Lenar\""
	desc = "A more than bulky pump-action grenade launcher. Holds up to 6 grenade shells in a revolving magazine."
	icon = 'icons/obj/guns/launcher/grenadelauncher.dmi'
	icon_state = "Grenadelauncher_PMC"
	item_state = "pneumatic"
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	matter = list(MATERIAL_PLASTEEL = 30, MATERIAL_PLASTIC = 10)
	fire_sound = 'sound/weapons/guns/fire/grenadelauncher_fire.ogg'
	bulletinsert_sound = 'sound/weapons/guns/interact/batrifle_magin.ogg'   //Placeholder, could use a new sound
	fire_sound_text = "a metallic thunk"

/obj/item/weapon/gun/projectile/grenade/lenar/proc/update_charge()
	var/ratio = loaded.len / max_shells
	if(ratio < 0.33 && ratio != 0)
		ratio = 0.33
	ratio = round(ratio, 0.33) * 100
	overlays += "grenademag_[ratio]"

/obj/item/weapon/gun/projectile/grenade/lenar/update_icon()
	overlays.Cut()
	update_charge()
