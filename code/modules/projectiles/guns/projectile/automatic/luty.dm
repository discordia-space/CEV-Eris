/obj/item/gun/projectile/automatic/luty
	name = "HM SMG Auto \"Luty\""
	desc = "A dead simple open-bolt automatic firearm, easily made and easily concealed.\
			A gun that has gone by many names, from the Grease gun to the Carlo to the Swedish K. \
			Some designs are too good to change."
	icon = 'icons/obj/guns/projectile/luty.dmi'
	icon_state = "luty"
	item_state = "luty"


	spawn_blacklisted = FALSE
	spawn_tags = SPAWN_TAG_GUN_HANDMADE
	volumeClass = ITEM_SIZE_NORMAL
	can_dual = TRUE
	caliber = CAL_PISTOL
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	ammo_type = /obj/item/ammo_casing/pistol
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL|MAG_WELL_H_PISTOL|MAG_WELL_SMG
	matter = list(MATERIAL_STEEL = 10, MATERIAL_PLASTIC = 5)
	init_firemodes = list(
		FULL_AUTO_400,
		SEMI_AUTO_300,
		)

	can_dual = 1
	damage_multiplier = 0.7
	init_recoil = SMG_RECOIL(0.6)
	spawn_blacklisted = TRUE
	wield_delay = 0 // No delay for this , its litteraly a junk gun
	gun_parts = list(/obj/item/part/gun/frame/luty = 1, /obj/item/part/gun/modular/grip/black = 1, /obj/item/part/gun/modular/mechanism/smg/steel = 1, /obj/item/part/gun/modular/barrel/pistol/steel = 1)
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)


/obj/item/part/gun/frame/luty
	name = "Luty frame"
	desc = "A Luty SMG. It rattles a bit, but it's okay. Just don\'t shake it too hard."
	icon_state = "frame_luty"
	matter = list(MATERIAL_STEEL = 5)
	resultvars = list(/obj/item/gun/projectile/automatic/luty)
	gripvars = list(/obj/item/part/gun/modular/grip/black)
	mechanismvar = /obj/item/part/gun/modular/mechanism/smg/steel
	barrelvars = list(/obj/item/part/gun/modular/barrel/pistol/steel, /obj/item/part/gun/modular/barrel/magnum/steel)

/obj/item/gun/projectile/automatic/luty/update_icon()
	cut_overlays()
	icon_state = "[initial(icon_state)][safety ? "_safe" : ""]"

	if(ammo_magazine)
		overlays += "mag[silenced ? "_s" : ""][ammo_magazine.ammo_label_string]"
	else
		overlays += "slide[silenced ? "_s" : ""]"

/obj/item/gun/projectile/automatic/luty/Initialize()
	. = ..()
	update_icon()

/obj/item/gun/projectile/automatic/luty/toggle_safety()
	. = ..()
	update_icon()
