/obj/item/weapon/gun/projectile/shotgun/pump/china
    name = "FS GL \"China Lake\""
    desc = "This centuries-old design was recently rediscovered and adapted for use in modern battlefields. \
        Working similar to a pump-action combat shotgun, its light weight and robust design quickly made it a popular weapon. \
        It holds up to 4 grenade shells."
    icon = 'icons/obj/guns/projectile/chinalake.dmi'
    icon_state = "china_lake"
    item_state = "china_lake"
    w_class = ITEM_SIZE_HUGE
    slot_flags = SLOT_BACK
    force = WEAPON_FORCE_PAINFUL
    matter = list(MATERIAL_PLASTEEL = 25, MATERIAL_WOOD = 10)
    price_tag = 4500
    caliber = CAL_GRENADE
    load_method = SINGLE_CASING
    origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 2)
    handle_casings = HOLD_CASINGS
    fire_sound = 'sound/weapons/guns/fire/grenadelauncher_fire.ogg'
    bulletinsert_sound = 'sound/weapons/guns/interact/batrifle_magin.ogg'   //Placeholder, could use a new sound
    max_shells = 4
    recoil_buildup = 20
    twohanded = TRUE

/obj/item/weapon/gun/projectile/grenade
	name = "NT GL \"Protector\""
	desc = "A bulky pump-action grenade launcher. Holds up to 6 grenade shells in a revolving magazine."
	icon = 'icons/obj/guns/launcher/riotgun.dmi'
	icon_state = "riotgun"
	item_state = "riotgun"
	w_class = ITEM_SIZE_BULKY
	force = WEAPON_FORCE_PAINFUL
	matter = list(MATERIAL_PLASTEEL = 30, MATERIAL_WOOD = 10)
	caliber = CAL_GRENADE
	load_method = SINGLE_CASING
	origin_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 2)
	handle_casings = EJECT_CASINGS
	price_tag = 5500
	fire_sound = 'sound/weapons/empty.ogg'
	fire_sound_text = "a metallic thunk"
	recoil_buildup = 20
	max_shells = 6
	zoom_factor = 2.0
	twohanded = TRUE

//revolves the magazine, allowing players to choose between multiple grenade types
/obj/item/weapon/gun/projectile/grenade/proc/pump(mob/user as mob)
	playsound(user, 'sound/weapons/shotgunpump.ogg', 60, 1)

	var/obj/item/ammo_casing/next
	if(loaded.len)
		next = loaded[1]
	if(next)
		loaded -= next
		loaded += next  //Moves the first loaded grenade to the end of the loaded list
		next = loaded[1]
		to_chat(user, SPAN_WARNING("Mechanism pumps [src], loading \a [next] into the chamber."))
	else
		to_chat(user, SPAN_WARNING("Mechanism pumps [src], but the magazine is empty."))
	update_icon()

/obj/item/weapon/gun/projectile/grenade/examine(mob/user)
	if(..(user, 2))
		var/grenade_count = loaded.len + (chambered? 1 : 0)
		to_chat(user, "Has [grenade_count] grenade\s remaining.")
		if(chambered)
			to_chat(user, "\A [chambered] is chambered.")

/obj/item/weapon/gun/projectile/grenade/attack_self(mob/user)
	pump(user)

/obj/item/weapon/gun/projectile/grenade/lenar
	name = "FS GL \"Lenar\""
	desc = "A more than bulky pump-action grenade launcher. Holds up to 6 grenade shells in a revolving magazine."
	icon = 'icons/obj/guns/launcher/grenadelauncher.dmi'
	icon_state = "Grenadelauncher_PMC"
	item_state = "pneumatic"
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	matter = list(MATERIAL_PLASTEEL = 30, MATERIAL_PLASTIC = 10)
	fire_sound = 'sound/weapons/empty.ogg'
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

/obj/item/weapon/gun/projectile/underslung
	name = "underslung grenade launcher"
	desc = "Not much more than a tube and a firing mechanism, this grenade launcher is designed to be fitted to a rifle."
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

