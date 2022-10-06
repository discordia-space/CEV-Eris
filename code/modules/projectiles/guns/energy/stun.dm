/obj/item/gun/energy/taser
	name = "NT SP \"Counselor\""
	desc = "The NT SP \"Counselor\" is a taser gun used for non-lethal takedowns. Used by Nanotrasen security forces before Corporation Wars."
	icon = 'icons/obj/guns/energy/taser.dmi'
	icon_state = "taser"
	item_state = null	//so the human update icon uses the icon_state instead.
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_PLASTIC = 6, MATERIAL_SILVER = 3)
	price_tag = 2000
	fire_sound = 'sound/weapons/Taser.ogg'
	can_dual = TRUE
	projectile_type = /obj/item/projectile/beam/stun
	wield_delay = 0.3 SECOND
	wield_delay_factor = 0.2 // 20 vig
	init_recoil = HANDGUN_RECOIL(1)
	serial_type = "NT"

/obj/item/gun/energy/taser/mounted
	name = "mounted taser gun"
	self_recharge = TRUE
	use_external_power = TRUE
	safety = FALSE
	restrict_safety = TRUE
	spawn_tags = null
	bad_type = /obj/item/gun/energy/taser/mounted

/obj/item/gun/energy/taser/mounted/cyborg
	name = "taser gun"
	recharge_time = 10 //Time it takes for shots to recharge (in ticks)
	bad_type = /obj/item/gun/energy/taser/mounted/cyborg

/obj/item/gun/energy/stunrevolver
	name = "NT SP \"Zeus\""
	desc = "Also know as stunrevolver. Older and less precise Nanotrasen solution for non-lethal takedowns. This gun has smaller capacity in exchange for S-cells use."
	icon = 'icons/obj/guns/energy/stunrevolver.dmi'
	icon_state = "stunrevolver"
	item_state = "stunrevolver"
	fire_sound = 'sound/weapons/Gunshot.ogg'
	can_dual = TRUE
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	charge_cost = 50
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_WOOD = 6, MATERIAL_SILVER = 2)
	price_tag = 1500
	suitable_cell = /obj/item/cell/small
	cell_type = /obj/item/cell/small
	projectile_type = /obj/item/projectile/energy/electrode
	init_recoil = HANDGUN_RECOIL(1)
	serial_type = "NT"

/obj/item/gun/energy/stunrevolver/moebius
	name = "ML SP \"Suez\""	//Ersatz name
	desc = "Also know as stunrevolver. A Moebius copy of the older and less precise Nanotrasen solution for non-lethal takedowns. This gun has smaller capacity in exchange for S-cells use."
	icon = 'icons/obj/guns/energy/stunrevolver_moebius.dmi'
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_STEEL = 6, MATERIAL_SILVER = 2, MATERIAL_PLASTIC = 5)
	serial_type = "ML"
