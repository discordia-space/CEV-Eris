/obj/item/gun/projectile/pistol/type_62
	name = "OS Type 62 PDW .40 \"Nezha\"" //god forgive me i dont know chineese, Name = Protection Deity
	desc = "A compact and powerful prototype PDW typically issued to high ranking officials and spies. Unwieldy, but extremely deadly, this is the perfect gun for self defense and urban warfare. Takes both pistol and SMG .40 magazines."
	icon = 'icons/obj/guns/projectile/os/type_62.dmi'
	icon_state = "type_62"
	item_state = "type_62"
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 2)
	caliber = CAL_MAGNUM
	w_class = ITEM_SIZE_SMALL
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL|MAG_WELL_SMG
	magazine_type = /obj/item/ammo_magazine/magnum
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_PLATINUM = 8, MATERIAL_PLASTIC = 4)
	can_dual = TRUE
	slot_flags = SLOT_BELT|SLOT_HOLSTER|SLOT_BACK
	damage_multiplier = 1.1
	penetration_multiplier = 0
	init_recoil = HANDGUN_RECOIL(0.9)
	fire_sound = 'sound/weapons/guns/fire/hpistol_fire.ogg'
	unload_sound = 'sound/weapons/guns/interact/hpistol_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/hpistol_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/rifle_boltforward.ogg'
	init_firemodes = list(
		FULL_AUTO_600,
		FULL_AUTO_800,
		SEMI_AUTO_300
        )
	spawn_tags = SPAWN_TAG_GUN_OS
	price_tag = 3000

	spawn_blacklisted = TRUE //until loot rework
	serial_type = "OS"

/obj/item/gun/projectile/pistol/type_62/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if(ammo_magazine)
		iconstring += "_mag"
		itemstring += "_mag"
		if(ammo_magazine.mag_well == MAG_WELL_SMG) //thank you to kirov for the code help -Valo
			iconstring += "_smg"
		if(!LAZYLEN(ammo_magazine.stored_ammo))
			iconstring += "_empty"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/gun/projectile/pistol/type_62/Initialize()
	. = ..()
	update_icon()
