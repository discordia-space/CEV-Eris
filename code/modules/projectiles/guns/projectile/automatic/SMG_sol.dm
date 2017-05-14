obj/item/weapon/gun/projectile/automatic/SMG_sol
	name = "FS SMG 9x19 \"Sol\""
	desc = "A standard-issued weapon used by Ironhammer operatives. Compact and reliable. Uses 9mm rounds."
	icon_state = "SMG-IS"
	item_state = "wt550"
	w_class = 4
	ammo_mag = "ih_smg"
	load_method = MAGAZINE
	max_shells = 21
	caliber = "9mm"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	multi_aim = 1
	burst_delay = 2

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		)

/obj/item/weapon/gun/projectile/automatic/SMG_sol/proc/update_charge()
	if(!ammo_magazine)
		return
	var/ratio = ammo_magazine.stored_ammo.len / ammo_magazine.max_ammo
	if(ratio < 0.25 && ratio != 0)
		ratio = 0.25
	ratio = round(ratio, 0.25) * 100
	overlays += "smg_[ratio]"


/obj/item/weapon/gun/projectile/automatic/SMG_sol/update_icon()
	icon_state = (ammo_magazine)? "SMG-IS" : "SMG-IS-empty"
	overlays.Cut()
	update_charge()
