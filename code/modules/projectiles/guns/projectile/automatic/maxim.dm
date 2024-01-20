/obj/item/gun/projectile/automatic/maxim
	bad_type = /obj/item/gun/projectile/automatic/maxim
	name = "Excelsior HMG .30 \"Maxim\""
	desc = "A bulky yet versatile gun, the Maxim has been used in ships, turrets, and by hand."
	icon = 'icons/obj/guns/projectile/maxim.dmi'
	icon_state = "maxim"
	item_state = "maxim"
	volumeClass = ITEM_SIZE_HUGE
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
	init_recoil = HMG_RECOIL(0.5)
	damage_multiplier = 1.2
	burst_delay = 0.8
	init_firemodes = list(
		list(mode_name = "full auto",  mode_desc="800 rounds per minute", mode_type = /datum/firemode/automatic, fire_delay=2.4, icon="auto"),
		list(mode_name="short bursts", mode_desc="dakka", burst=5, fire_delay=null, icon="burst"),
		list(mode_name="long bursts", mode_desc="Dakka", burst=8, fire_delay=null, icon="burst"),
		list(mode_name="suppressing fire", mode_desc="DAKKA", burst=16, fire_delay=null, icon="burst")
		)
	twohanded = TRUE
	spawn_blacklisted = TRUE
	init_offset = 20 // Too much even for cover
	slowdown_hold = 1
	wield_delay = 1 SECOND
	wield_delay_factor = 0.9 // 90 vig
	gun_parts = list(/obj/item/part/gun/frame/maxim = 1, /obj/item/part/gun/modular/grip/excel = 1, /obj/item/part/gun/modular/mechanism/machinegun = 1, /obj/item/part/gun/modular/barrel/lrifle = 1)
	serial_type = "Excelsior"

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
	resultvars = list(/obj/item/gun/projectile/automatic/maxim)
	gripvars = list(/obj/item/part/gun/modular/grip/excel)
	mechanismvar = /obj/item/part/gun/modular/mechanism/machinegun
	barrelvars = list(/obj/item/part/gun/modular/barrel/lrifle)
