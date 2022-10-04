/obj/item/gun/projectile/automatic/dallas //it's a good way to die
	name = "PAR .25 CS \"Dallas\""
	desc = "Dallas is a pulse-action air-cooled automatic assault rifle made by unknown manufacturer. This weapon is very rare, but deadly efficient. \
			It's used by elite mercenaries, assassins or bald marines. Uses .25 Caseless rounds."
	icon = 'icons/obj/guns/projectile/dallas.dmi'
	icon_state = "dallas"
	item_state = "dallas"
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_PAINFUL
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1)
	caliber = CAL_CLRIFLE
	load_method = MAGAZINE
	mag_well = MAG_WELL_RIFLE
	magazine_type = /obj/item/ammo_magazine/c10x24
	auto_eject = 1
	matter = list(MATERIAL_PLASTEEL = 25, MATERIAL_PLASTIC = 15)
	price_tag = 5000 //99 rounds of pure pain and destruction served in auto-fire, so it basically an upgraded LMG
	fire_sound = 'sound/weapons/guns/fire/m41_shoot.ogg'
	unload_sound = 'sound/weapons/guns/interact/ltrifle_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/m41_reload.ogg'
	cocked_sound = 'sound/weapons/guns/interact/m41_cocked.ogg'
	damage_multiplier = 1.3
	penetration_multiplier = 0
	init_recoil = LMG_RECOIL(1)
	rarity_value = 65
	gun_parts = list(/obj/item/part/gun = 5 ,/obj/item/stack/material/plasteel = 6)
	wield_delay = 1 SECOND
	wield_delay_factor = 0.4 // 40 vig for insta wield
	gun_parts = list(/obj/item/part/gun/frame/dallas = 1, /obj/item/part/gun/grip/black = 1, /obj/item/part/gun/mechanism/machinegun = 1, /obj/item/part/gun/barrel/clrifle = 1)

	gun_tags = list(GUN_SILENCABLE)

	init_firemodes = list(
		FULL_AUTO_400,
		SEMI_AUTO_300,
		)

	serial_type = "PAR"

/obj/item/gun/projectile/automatic/dallas/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]-full"
	else
		icon_state = initial(icon_state)
	return

/obj/item/part/gun/frame/dallas
	name = "Dallas frame"
	desc = "A Dallas pulse rifle frame. Sawing aliens in twain since time immemorial."
	icon_state = "frame_dallas"
	resultvars = list(/obj/item/gun/projectile/automatic/dallas)
	gripvars = list(/obj/item/part/gun/grip/black)
	mechanismvar = /obj/item/part/gun/mechanism/machinegun
	barrelvars = list(/obj/item/part/gun/barrel/clrifle)
	spawn_blacklisted = TRUE
