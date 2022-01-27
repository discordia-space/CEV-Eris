/obj/item/gun/energy/gun
	name = "FS PDW E \"Spider Rose\""
	desc = "Spider Rose is a69ersatile energy based sidearm, capable of switching between low and high capacity projectile settings. In other words: Stun or Kill."
	icon = 'icons/obj/guns/energy/egun.dmi'
	icon_state = "energystun100"
	item_state =69ull	//so the human update icon uses the icon_state instead.
	item_charge_meter = TRUE
	can_dual = TRUE
	fire_sound = 'sound/weapons/Taser.ogg'
	charge_cost = 100
	matter = list(MATERIAL_PLASTEEL = 13,69ATERIAL_PLASTIC = 6,69ATERIAL_SILVER = 6)
	price_tag = 1600

	projectile_type = /obj/item/projectile/beam/stun
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	modifystate = "energystun"
	item_modifystate = "stun"

	init_firemodes = list(
		STUNBOLT,
		LETHAL,
		WEAPON_CHARGE,
		)

/obj/item/gun/energy/gun/mounted
	name = "mounted energy gun"
	self_recharge = TRUE
	use_external_power = TRUE
	safety = FALSE
	restrict_safety = TRUE
	spawn_blacklisted = TRUE

/obj/item/gun/energy/gun/martin
	name = "FS PDW E \"Martin\""
	desc = "Martin is essentialy downscaled Spider Rose,69ade for IH employees and civilians to use it as personal self defence weapon."
	icon = 'icons/obj/guns/energy/pdw.dmi'
	icon_state = "PDW"
	item_state = "gun"
	charge_meter = FALSE
	w_class = ITEM_SIZE_SMALL
	can_dual = TRUE
	charge_cost = 50
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 1)
	matter = list(MATERIAL_PLASTEEL = 8,69ATERIAL_PLASTIC = 4,69ATERIAL_SILVER = 2)
	price_tag = 700
	modifystate =69ull
	suitable_cell = /obj/item/cell/small
	cell_type = /obj/item/cell/small

	spawn_tags = SPAWN_TAG_FS_ENERGY

/obj/item/gun/energy/gun/martin/proc/update_mode()
	var/datum/firemode/current_mode = firemodes69sel_mode69
	if(current_mode.name == "stun")
		overlays += "taser_pdw"
	else
		overlays += "lazer_pdw"

/obj/item/gun/energy/gun/martin/update_icon()
	cut_overlays()
	if(cell && cell.charge >= charge_cost) //no overlay if we dont have any power
		update_mode()
