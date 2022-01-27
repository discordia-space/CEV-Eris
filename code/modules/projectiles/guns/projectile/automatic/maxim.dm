/obj/item/gun/projectile/automatic/maxim
	bad_type = /obj/item/gun/projectile/automatic/maxim
	name = "Excelsior HMG .30 \"Maxim\""
	desc = "A bulky yet69ersatile gun, the69axim has been used in ships, turrets, and by hand."
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
	load_method =69AGAZINE
	mag_well =69AG_WELL_PAN
	tac_reloads = FALSE
	magazine_type = /obj/item/ammo_magazine/maxim
	matter = list(MATERIAL_PLASTEEL = 40,69ATERIAL_PLASTIC = 30)
	price_tag = 5000
	unload_sound = 'sound/weapons/guns/interact/lmg_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/lmg_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/lmg_cock.ogg'
	fire_sound = 'sound/weapons/guns/fire/lmg_fire.ogg'
	recoil_buildup = 2.2
	one_hand_penalty = 45 //not like it's used anyway, but HMG level
	init_firemodes = list(
		list(mode_name = "full auto", 69ode_desc = "600 rounds per69inute",  69ode_type = /datum/firemode/automatic, fire_delay = 1, icon="auto", damage_mult_add = -0.1,69ove_delay=6),
		list(mode_name="short bursts",69ode_desc="dakka", burst=5,    burst_delay=1,69ove_delay=6,  icon="burst"),
		list(mode_name="long bursts",69ode_desc="Dakka", burst=8, burst_delay=1,69ove_delay=8,  icon="burst"),
		list(mode_name="suppressing fire",69ode_desc="DAKKA", burst=16, burst_delay=1,69ove_delay=16,  icon="burst")
		)
	twohanded = TRUE
	spawn_blacklisted = TRUE
	slowdown_hold = 5
	wield_delay = 1 SECOND
	wield_delay_factor = 0.9 // 9069ig

/obj/item/gun/projectile/automatic/maxim/update_icon()
	..()
	var/itemstring = ""
	cut_overlays()

	if(ammo_magazine)
		overlays += "mag69ammo_magazine.ammo_label_string69"
		itemstring += "_full"

	if(wielded)
		itemstring += "_doble"

	set_item_state(itemstring)
