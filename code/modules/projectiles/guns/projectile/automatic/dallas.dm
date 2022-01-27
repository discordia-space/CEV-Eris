/obj/item/gun/projectile/automatic/dallas //it's a good way to die
	name = "PAR .25 CS \"Dallas\""
	desc = "Dallas is a pulse-action air-cooled automatic assault rifle69ade by unknown69anufacturer. This weapon is69ery rare, but deadly efficient. \
			It's used by elite69ercenaries, assassins or bald69arines. Uses .25 Caseless rounds."
	icon = 'icons/obj/guns/projectile/dallas.dmi'
	icon_state = "dallas"
	item_state = "dallas"
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_PAINFUL
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1)
	caliber = CAL_CLRIFLE
	load_method =69AGAZINE
	mag_well =69AG_WELL_RIFLE
	magazine_type = /obj/item/ammo_magazine/c10x24
	auto_eject = 1
	matter = list(MATERIAL_PLASTEEL = 25,69ATERIAL_PLASTIC = 15)
	price_tag = 5000 //99 rounds of pure pain and destruction served in auto-fire, so it basically an upgraded LMG
	fire_sound = 'sound/weapons/guns/fire/m41_shoot.ogg'
	unload_sound = 'sound/weapons/guns/interact/ltrifle_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/m41_reload.ogg'
	cocked_sound = 'sound/weapons/guns/interact/m41_cocked.ogg'
	damage_multiplier = 1.35
	penetration_multiplier = 1.2
	recoil_buildup = 1.3
	one_hand_penalty = 10 //heavy, but69ery advanced, so bullpup rifle level despite69ot being bullpup
	rarity_value = 65
	gun_parts = list(/obj/item/part/gun = 5 ,/obj/item/stack/material/plasteel = 6)
	wield_delay = 1 SECOND
	wield_delay_factor = 0.4 // 4069ig for insta wield

	gun_tags = list(GUN_SILENCABLE)

	init_firemodes = list(
		FULL_AUTO_400,
		SEMI_AUTO_NODELAY,
		)

/obj/item/gun/projectile/automatic/dallas/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "69initial(icon_state)69-full"
	else
		icon_state = initial(icon_state)
	return
