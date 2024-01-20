/obj/item/gun/energy/rxd
	name = "Rapid Crossbow Device"
	desc = "A hacked and heavily modified RCD. In exchange for losing versitility, it can flash forge its own ammunition using cell charges."
	icon = 'icons/obj/guns/energy/rapidcrossbow.dmi' // NOTE! It lacks a back and onsuit sprites and requiers one now
	icon_state = "rxb_empty"
	item_state = "rxb_empty"
	flags = CONDUCT
	slot_flags = SLOT_BACK|SLOT_BELT|SLOT_HOLSTER
	wielded_item_state = "_doble"
	fire_delay = 6
	fire_sound = 'sound/weapons/tablehit1.ogg'
	init_firemodes = list(
		list(mode_name = "Bolt", mode_desc = "Fires a flashforged quarrel", projectile_type = /obj/item/projectile/bullet/bolt, charge_cost = 100, icon = "kill"))
	price_tag = 2000
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_PLASMA = 8, MATERIAL_URANIUM = 8, MATERIAL_STEEL = 2)
	init_recoil = HANDGUN_RECOIL(1)
	safety = FALSE
	restrict_safety = TRUE

/obj/item/gun/energy/rxd/update_icon()
	icon_state = cell ? "rxb_drawn" : "rxb_empty"

/obj/item/gun/energy/rxd/generate_guntags()
	gun_tags = list(SLOT_BAYONET)
