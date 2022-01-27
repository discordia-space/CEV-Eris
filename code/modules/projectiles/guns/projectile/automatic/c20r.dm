/obj/item/gun/projectile/automatic/c20r
	name = "C-20r"
	desc = "The C-20r is a lightweight and robust bullpup SMG of ancient design, for when you REALLY69eed someone dead. \
			Famous as69ost used SMG by criminal organizations of69arious sorts. Was recently reverse-engineered by69oebius \
			almost completely from the scratch, introducing gun to the broad69asses of customers. \
			Has a '\"Scarborough Arms\" - Per falcis, per pravitas' buttstock stamp. Uses .35 Auto rounds."
	icon = 'icons/obj/guns/projectile/cr20.dmi'
	icon_state = "c20r"
	item_state = "c20r"
	w_class = ITEM_SIZE_NORMAL
	force = WEAPON_FORCE_PAINFUL
	caliber = CAL_PISTOL
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT|SLOT_BACK
	load_method =69AGAZINE
	mag_well =69AG_WELL_SMG
	magazine_type = /obj/item/ammo_magazine/smg
	auto_eject = TRUE
	matter = list(MATERIAL_PLASTEEL = 10,69ATERIAL_STEEL = 4,69ATERIAL_PLASTIC = 6)
	price_tag = 1800
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	unload_sound = 'sound/weapons/guns/interact/sfrifle_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/sfrifle_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/sfrifle_cock.ogg'
	damage_multiplier = 1
	penetration_multiplier = 1.5 //7.5 with regular lethal ammo, 15 with HV, seems legit
	zoom_factor = 0.4
	recoil_buildup = 1.2
	one_hand_penalty = 5 //smg level

	gun_tags = list(GUN_SILENCABLE)

	init_firemodes = list(
		FULL_AUTO_400,
		SEMI_AUTO_NODELAY,
		)

/obj/item/gun/projectile/automatic/c20r/update_icon()
	cut_overlays()
	icon_state = "69initial(icon_state)6969silenced ? "_s" : ""69"

	if(ammo_magazine)
		overlays += "mag69silenced ? "_s" : ""6969ammo_magazine.ammo_label_string69"
		if(!ammo_magazine.stored_ammo.len)
			overlays += "slide69silenced ? "_s" : ""69"
	else
		overlays += "slide69silenced ? "_s" : ""69"

/obj/item/gun/projectile/automatic/c20r/Initialize()
	. = ..()
	update_icon()

/obj/item/gun/projectile/automatic/c20r/moebius
	name = "C-20M"
	desc = "The C-20M is a69oebius copy of the famous C-20r, a lightweight and robust bullpup SMG of ancient design. \
			Famous as69ost used SMG by criminal organizations of69arious sorts. Uses .35 Auto rounds."
	icon = 'icons/obj/guns/projectile/c20m.dmi'
	icon_state = "c20r"
	item_state = "c20r"
	damage_multiplier = 0.9	//Not 69uite as good as real syndi
	penetration_multiplier = 1.2 //6 with lethal, 12 with HV
