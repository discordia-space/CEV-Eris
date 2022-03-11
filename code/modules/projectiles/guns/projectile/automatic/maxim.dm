/obj/item/gun/projectile/automatic/maxim
	bad_type = /obj/item/gun/projectile/automatic/maxim
	name = "Excelsior HMG .30 \"Maxim\""
	desc = "A bulky yet versatile gun, the Maxim has been used in ships, turrets, and by hand."
	icon = 'icons/obj/guns/projectile/maxim.dmi'
	icon_state = "maxim"
	item_state = "maxim"
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_PAINFUL
	slot_flags = 0
	max_shells = 96
	caliber = CAL_LRIFLE
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	ammo_type = /obj/item/ammo_casing/lrifle
	load_method = MAGAZINE
	mag_well = MAG_WELL_PAN
	tac_reloads = FALSE
	magazine_type = /obj/item/ammo_magazine/maxim
	matter = list(MATERIAL_PLASTEEL = 40, MATERIAL_PLASTIC = 30)
	price_tag = 5000
	unload_sound = 'sound/weapons/guns/interact/lmg_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/lmg_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/lmg_cock.ogg'
	fire_sound = 'sound/weapons/guns/fire/lmg_fire.ogg'
	recoil_buildup = 0.6 // HMG size absorbs recoil effectively
	damage_multiplier = 1.1
	penetration_multiplier = 1.3
	one_hand_penalty = 45 //not like it's used anyway, but HMG level
	burst_delay = 0.8
	init_firemodes = list(
		list(mode_name = "full auto",  mode_desc="800 rounds per minute", mode_type = /datum/firemode/automatic, fire_delay=0.8, icon="auto", damage_mult_add=-0.2, move_delay=5),
		list(mode_name="short bursts", mode_desc="dakka", burst=5, fire_delay=null, damage_mult_add=-0.2, move_delay=5,  icon="burst"),
		list(mode_name="long bursts", mode_desc="Dakka", burst=8, fire_delay=null, damage_mult_add=-0.2, move_delay=7,  icon="burst"),
		list(mode_name="suppressing fire", mode_desc="DAKKA", burst=16, fire_delay=null, damage_mult_add=-0.2, move_delay=13,  icon="burst")
		)
	twohanded = TRUE
	spawn_blacklisted = TRUE
	brace_penalty = 5 // You won't hit anything without bracing this
	init_offset = 7 // Too much even for cover
	slowdown_hold = 1
	wield_delay = 1 SECOND
	wield_delay_factor = 0.9 // 90 vig
	gun_parts = list(/obj/item/part/gun/frame/maxim = 1, /obj/item/part/gun/grip/excel = 1, /obj/item/part/gun/mechanism/machinegun = 1, /obj/item/part/gun/barrel/lrifle = 1)

/obj/item/gun/projectile/automatic/maxim/update_icon()
	..()
	var/itemstring = ""
	cut_overlays()

	if(ammo_magazine)
		overlays += "mag[ammo_magazine.ammo_label_string]"
		itemstring += "_full"

	if(wielded)
		itemstring += "_doble"

	set_item_state(itemstring)

/obj/item/part/gun/frame/maxim
	name = "Maxim frame"
	desc = "A Maxim HMG frame. Whatever happens, we have got the Maxim gun and they have not."
	icon_state = "frame_maxim"
	result = /obj/item/gun/projectile/automatic/maxim
	grip = /obj/item/part/gun/grip/excel
	mechanism = /obj/item/part/gun/mechanism/machinegun
	barrel = /obj/item/part/gun/barrel/lrifle
