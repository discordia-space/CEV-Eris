/obj/item/gun/projectile/automatic/sol
	name = "FS CAR .25 CS \"Sol\""
	desc = "A standard-issue weapon used by Ironhammer operatives. Compact and reliable. Uses .25 Caseless rounds."
	icon = 'icons/obj/guns/projectile/sol.dmi'
	icon_state = "sol"
	item_state = "sol"
	w_class = ITEM_SIZE_BULKY
	ammo_mag = "ih_sol"
	load_method = MAGAZINE
	mag_well = MAG_WELL_IH
	caliber = CAL_CLRIFLE
	magazine_type = /obj/item/ammo_magazine/ihclrifle
	auto_eject = 1
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	matter = list(MATERIAL_PLASTEEL = 16, MATERIAL_PLASTIC = 12)
	price_tag = 2300
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	init_recoil = CARBINE_RECOIL(1)
	penetration_multiplier = 0
	damage_multiplier = 1.1
	gun_parts = list(/obj/item/part/gun = 2 ,/obj/item/stack/material/plasteel = 6)
	gun_tags = list(GUN_FA_MODDABLE)

	init_firemodes = list(
		SEMI_AUTO_300,
		BURST_3_ROUND,
		BURST_3_ROUND_RAPID
		)
	spawn_tags = SPAWN_TAG_FS_PROJECTILE
	gun_parts = list(/obj/item/part/gun/frame/sol = 1, /obj/item/part/gun/grip/rubber = 1, /obj/item/part/gun/mechanism/smg = 1, /obj/item/part/gun/barrel/clrifle = 1)
	serial_type = "FS"

/obj/item/gun/projectile/automatic/sol/proc/update_charge()
	if(!ammo_magazine)
		return
	var/ratio = ammo_magazine.stored_ammo.len / ammo_magazine.max_ammo
	if(ratio < 0.25 && ratio != 0)
		ratio = 0.25
	ratio = round(ratio, 0.25) * 100
	overlays += "sol_[ratio]"

/obj/item/gun/projectile/automatic/sol/update_icon()
	..()

	icon_state = initial(icon_state) + (ammo_magazine ? "-full" : "")
	set_item_state(ammo_magazine ? "-full" : "", back = TRUE)
	cut_overlays()
	update_charge()

/obj/item/part/gun/frame/sol
	name = "Sol frame"
	desc = "A Sol carbine frame. Ironhammer's favorite."
	icon_state = "frame_ihbullpup"
	resultvars = list(/obj/item/gun/projectile/automatic/sol)
	gripvars = list(/obj/item/part/gun/grip/rubber)
	mechanismvar = /obj/item/part/gun/mechanism/smg // guh?? ok you do you
	barrelvars = list(/obj/item/part/gun/barrel/clrifle)
