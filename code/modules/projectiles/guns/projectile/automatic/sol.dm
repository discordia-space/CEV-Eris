/obj/item/weapon/gun/projectile/automatic/sol
	name = "FS CAR 6.5x39 \"Sol\""
	desc = "A standard-issue weapon used by Ironhammer operatives. Compact and reliable. Uses 6.5x39 rounds."
	icon_state = "sol-para"
	item_state = "sol"
	w_class = ITEM_SIZE_LARGE
	ammo_mag = "ih_sol"
	load_method = MAGAZINE
	mag_well = MAG_WELL_IH
	auto_eject = 1
	caliber = "6.5mm"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 12)
	price_tag = 2300
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	recoil = 0.8 //still carbine, but unlike AK don't possess high caliber nor auto-fire, so it will be same as smg

	firemodes = list(
		SEMI_AUTO_NODELAY,
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,     icon="burst"),
		)

/obj/item/weapon/gun/projectile/automatic/sol/proc/update_charge()
	if(!ammo_magazine)
		return
	var/ratio = ammo_magazine.stored_ammo.len / ammo_magazine.max_ammo
	if(ratio < 0.25 && ratio != 0)
		ratio = 0.25
	ratio = round(ratio, 0.25) * 100
	overlays += "sol_[ratio]"

/obj/item/weapon/gun/projectile/automatic/sol/update_icon()
	icon_state = initial(icon_state) + (ammo_magazine ?  "-full" : "")
	overlays.Cut()
	update_charge()

/obj/item/weapon/gun/projectile/automatic/sol/rds
	desc = "A standard-issue weapon used by Ironhammer operatives. Compact and reliable. Uses 6.5x39 rounds. This one comes with red dot sight."
	icon_state = "sol-eot"
	price_tag = 2350
	zoom_factor = 0.2