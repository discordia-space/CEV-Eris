/obj/item/weapon/gun/projectile/automatic/sol
	name = "FS CAR 6.5x39 \"Sol\""
	desc = "A standard-issued weapon used by Ironhammer operatives. Compact and reliable. Uses 6.5x39 rounds."
	icon_state = "sol-para"
	item_state = "c24"
	w_class = ITEM_SIZE_LARGE
	ammo_mag = "ih_sol"
	load_method = MAGAZINE
	max_shells = 30
	caliber = "6.5mm"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	multi_aim = 1
	burst_delay = 2
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 12)

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    dispersion=list(0.0, 0.6, 1.0)),
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
	desc = "A standard-issued weapon used by Ironhammer operatives. Compact and reliable. Uses 6.5x39 rounds. This one somes with red dot sight."
	icon_state = "sol-eot"
