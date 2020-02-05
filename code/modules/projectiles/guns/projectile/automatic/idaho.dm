/obj/item/weapon/gun/projectile/automatic/idaho
	name = "FS SMG .40 Magnum \"Idaho\""
	desc = "An experimental Submachine gun made by \"Frozen Star\", for Paramilitary and private security use. \
			Rifled to take a larger caliber than a typical submachine gun, it boasts a greater impact, but suffers \
			from poor recoil control and horrible armor penetration capabilities as a result. \
			Has worse than average fire rate. Uses .40 Magnum rounds."
	icon = 'icons/obj/guns/projectile/idaho.dmi'
	icon_state = "idaho"
	item_state = "idaho"
	w_class = ITEM_SIZE_NORMAL
	caliber = CAL_MAGNUM
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	ammo_type = "/obj/item/ammo_casing/pistol"
	load_method = MAGAZINE
	mag_well = MAG_WELL_SMG
	magazine_type = /obj/item/ammo_magazine/smg
	matter = list(MATERIAL_PLASTEEL = 10, MATERIAL_STEEL = 6, MATERIAL_WOOD = 4)
	price_tag = 2000
	damage_multiplier = 1
	penetration_multiplier = 0.3
	recoil_buildup = 8

	firemodes = list(
		FULL_AUTO_300,
		SEMI_AUTO_NODELAY,
		)

/obj/item/weapon/gun/projectile/automatic/idaho/update_icon()
	overlays.Cut()
	icon_state = "[initial(icon_state)][silenced ? "_s" : ""]"
	if(ammo_magazine)
		overlays += "mag[silenced ? "_s" : ""][ammo_magazine.ammo_color]"
	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		overlays += "slide[silenced ? "_s" : ""]"

/obj/item/weapon/gun/projectile/automatic/idaho/Initialize()
	. = ..()
	update_icon()
