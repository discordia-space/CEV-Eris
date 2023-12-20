/obj/item/gun/projectile/automatic/c20r
	name = "S SMG .35 \"C-20r\""
	desc = "The C-20r is a lightweight and robust bullpup SMG of ancient design, for when you REALLY need someone dead. \
			Famous as most used SMG by criminal organizations of various sorts. Was recently reverse-engineered by Moebius \
			almost completely from the scratch, introducing gun to the broad masses of customers. This one however, is original. \
			Has a '\"Scarborough Arms\" - Per falcis, per pravitas' buttstock stamp. Uses .35 Auto rounds."
	icon = 'icons/obj/guns/projectile/cr20.dmi'
	icon_state = "c20r"
	item_state = "c20r"
	var/itemstring = ""
	volumeClass = ITEM_SIZE_NORMAL
	caliber = CAL_PISTOL
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT|SLOT_BACK
	load_method = MAGAZINE
	mag_well = MAG_WELL_SMG
	magazine_type = /obj/item/ammo_magazine/smg
	auto_eject = TRUE
	matter = list(MATERIAL_PLASTEEL = 10, MATERIAL_STEEL = 4, MATERIAL_PLASTIC = 6)
	price_tag = 1800
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	unload_sound = 'sound/weapons/guns/interact/sfrifle_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/sfrifle_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/sfrifle_cock.ogg'
	damage_multiplier = 1
	zoom_factors = list(0.4)
	init_recoil = SMG_RECOIL(0.6)
	gun_parts = list(/obj/item/part/gun/frame/c20r = 1, /obj/item/part/gun/modular/grip/black = 1, /obj/item/part/gun/modular/mechanism/smg = 1, /obj/item/part/gun/modular/barrel/pistol = 1)

	gun_tags = list(GUN_SILENCABLE)

	init_firemodes = list(
		FULL_AUTO_400,
		SEMI_AUTO_300,
		)

	serial_type = "S"


/obj/item/part/gun/frame/c20r
	name = "C20r frame"
	desc = "A C20r SMG frame. The syndicate's bread and butter."
	icon_state = "frame_syndi"
	resultvars = list(/obj/item/gun/projectile/automatic/c20r)
	gripvars = list(/obj/item/part/gun/modular/grip/black)
	mechanismvar = /obj/item/part/gun/modular/mechanism/smg
	barrelvars = list(/obj/item/part/gun/modular/barrel/pistol)

/obj/item/gun/projectile/automatic/c20r/update_icon()
	cut_overlays()
	icon_state = "[initial(icon_state)][silenced ? "_s" : ""]"
	itemstring = "[silenced ? "_s" : ""]"
	set_item_state(itemstring)

	if(ammo_magazine)
		overlays += "mag[silenced ? "_s" : ""][ammo_magazine.ammo_label_string]"
		if(!ammo_magazine.stored_ammo.len)
			overlays += "slide[silenced ? "_s" : ""]"
	else
		overlays += "slide[silenced ? "_s" : ""]"

	if (silenced)
		wielded_item_state = "_s"
	else
		wielded_item_state = ""


/obj/item/gun/projectile/automatic/c20r/Initialize()
	. = ..()
	update_icon()

/obj/item/gun/projectile/automatic/c20r/moebius
	name = "ML SMG .35 \"C-20M\""
	desc = "The C-20M is a Moebius copy of the famous C-20r, a lightweight and robust bullpup SMG of ancient design. \
			Famous as most used SMG by criminal organizations of various sorts. Uses .35 Auto rounds."
	icon = 'icons/obj/guns/projectile/c20m.dmi'
	icon_state = "c20r"
	item_state = "c20r"
	damage_multiplier = 0.8
	gun_parts = list(/obj/item/part/gun/frame/c20r/moebius = 1, /obj/item/part/gun/modular/grip/black = 1, /obj/item/part/gun/modular/mechanism/smg = 1, /obj/item/part/gun/modular/barrel/pistol = 1)
	serial_type = "ML"

/obj/item/part/gun/frame/c20r/moebius
	name = "C-20M frame"
	desc = "A C-20M SMG frame. The syndicate's bread and butter, reverse-engineered."
	icon_state = "frame_moe"
	resultvars = list(/obj/item/gun/projectile/automatic/c20r/moebius)
	spawn_blacklisted = TRUE
