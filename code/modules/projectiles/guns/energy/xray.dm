/obj/item/gun/energy/xray
	name = "xray laser gun"
	desc = "A high-power laser gun capable of expelling concentrated xray blasts."
	icon = 'icons/obj/guns/energy/xray.dmi' // note: sprites are slightly broken, if you want - fix them (notably: righthand wielded when looking left, lefthand wielded when looking right)
	icon_state = "xray"
	item_state = null
	fire_sound = 'sound/weapons/laser3.ogg'
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_COVERT = 2)
	price_tag = 4000
	projectile_type = /obj/item/projectile/beam/xray
	charge_cost = 100
	suitable_cell = /obj/item/cell/medium
	fire_delay = 1
	twohanded = TRUE
	init_recoil = RIFLE_RECOIL(1)
	serial_type = "ML"
	item_charge_meter = TRUE
	charge_meter = TRUE

/obj/item/gun/energy/xray/update_icon(var/ignore_inhands)
	if(charge_meter)
		var/ratio = 0

		if(cell && cell.charge >= charge_cost)
			ratio = cell.charge / cell.maxcharge
			ratio = min(max(round(ratio, 0.25) * 100, 25), 100)

		if(item_charge_meter)
			set_item_state("-[ratio]")
			wielded_item_state = "_doble" + "-[ratio]"
			icon_state = initial(icon_state) + "[ratio]"
	if(!ignore_inhands)
		update_wear_icon()
