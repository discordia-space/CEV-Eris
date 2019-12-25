/obj/item/weapon/gun/energy/gun
	name = "FS PDW E \"Spider Rose\""
	desc = "Spider Rose is a versatile energy based sidearm, capable of switching between low and high capacity projectile settings. In other words: Stun or Kill."
	icon = 'icons/obj/guns/energy/egun.dmi'
	icon_state = "energystun100"
	item_state = null	//so the human update icon uses the icon_state instead.
	item_charge_meter = TRUE
	can_dual = 1
	fire_sound = 'sound/weapons/Taser.ogg'
	charge_cost = 100
	matter = list(MATERIAL_PLASTEEL = 13, MATERIAL_PLASTIC = 6, MATERIAL_SILVER = 6)
	price_tag = 2500

	projectile_type = /obj/item/projectile/beam/stun
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	modifystate = "energystun"
	item_modifystate = "stun"

	firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, modifystate="energystun", item_modifystate="stun", fire_sound='sound/weapons/Taser.ogg', icon="stun"),
		list(mode_name="kill", projectile_type=/obj/item/projectile/beam, modifystate="energykill", item_modifystate="kill", fire_sound='sound/weapons/Laser.ogg', icon="kill"),
		WEAPON_CHARGE,
		)

/obj/item/weapon/gun/energy/gun/mounted
	name = "mounted energy gun"
	self_recharge = 1
	use_external_power = 1
	safety = FALSE
	restrict_safety = TRUE

/obj/item/weapon/gun/energy/gun/martin
	name = "FS PDW E \"Martin\""
	desc = "Martin is essentialy downscaled Spider Rose, made for IH employees and civilians to use it as personal self defence weapon."
	icon = 'icons/obj/guns/energy/pdw.dmi'
	icon_state = "PDW"
	item_state = "gun"
	charge_meter = FALSE
	w_class = ITEM_SIZE_SMALL
	can_dual = 1
	charge_cost = 50
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 1)
	matter = list(MATERIAL_PLASTEEL = 8, MATERIAL_PLASTIC = 4, MATERIAL_SILVER = 2)
	price_tag = 1000
	modifystate = null
	suitable_cell = /obj/item/weapon/cell/small
	cell_type = /obj/item/weapon/cell/small

/obj/item/weapon/gun/energy/gun/martin/proc/update_mode()
	var/datum/firemode/current_mode = firemodes[sel_mode]
	if(current_mode.name == "stun")
		overlays += "taser_pdw"
	else
		overlays += "lazer_pdw"

/obj/item/weapon/gun/energy/gun/martin/update_icon()
	overlays.Cut()
	if(cell && cell.charge >= charge_cost) //no overlay if we dont have any power
		update_mode()