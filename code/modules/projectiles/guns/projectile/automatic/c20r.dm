/obj/item/weapon/gun/projectile/automatic/c20r
	name = "C-20r"
	desc = "The C-20r is a lightweight and rapid-firing SMG, for when you REALLY need someone dead. Uses .35 Auto rounds. Has a 'Scarborough Arms - Per falcis, per pravitas' buttstock stamp."
	icon = 'icons/obj/guns/projectile/cr20.dmi'
	icon_state = "c20r"
	item_state = "c20r"
	w_class = ITEM_SIZE_NORMAL
	force = WEAPON_FORCE_PAINFUL
	caliber = "pistol"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT|SLOT_BACK
	load_method = MAGAZINE
	mag_well = MAG_WELL_SMG
	magazine_type = /obj/item/ammo_magazine/smg
	auto_eject = TRUE
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 12)
	price_tag = 3000
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	unload_sound 	= 'sound/weapons/guns/interact/sfrifle_magout.ogg'
	reload_sound 	= 'sound/weapons/guns/interact/sfrifle_magin.ogg'
	cocked_sound 	= 'sound/weapons/guns/interact/sfrifle_cock.ogg'
	zoom_factor = 0.2
	damage_multiplier = 1.1
	recoil = 0.8
	recoil_buildup = 0.1 //smg level
	silencer_type = /obj/item/weapon/silencer

	firemodes = list(
		FULL_AUTO_400,
		SEMI_AUTO_NODELAY,
		BURST_3_ROUND
		)

/obj/item/weapon/gun/projectile/automatic/c20r/update_icon()
	overlays.Cut()
	icon_state = "[initial(icon_state)][silenced ? "_s" : ""]"
	if(ammo_magazine)
		overlays += "mag[silenced ? "_s" : ""][ammo_magazine.ammo_color]"
	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		overlays += "slide[silenced ? "_s" : ""]"

/obj/item/weapon/gun/projectile/automatic/c20r/Initialize()
	. = ..()
	update_icon()
