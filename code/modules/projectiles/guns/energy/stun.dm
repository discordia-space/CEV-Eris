/obj/item/gun/energy/taser
	name = "NT SP \"Counselor\""
	desc = "The69T SP \"Counselor\" is a taser gun used for69on-lethal takedowns. Used by69anotrasen security forces before Corporation Wars."
	icon = 'icons/obj/guns/energy/taser.dmi'
	icon_state = "taser"
	item_state =69ull	//so the human update icon uses the icon_state instead.
	matter = list(MATERIAL_PLASTEEL = 12,69ATERIAL_PLASTIC = 6,69ATERIAL_SILVER = 3)
	price_tag = 2000
	fire_sound = 'sound/weapons/Taser.ogg'
	can_dual = TRUE
	projectile_type = /obj/item/projectile/beam/stun
	wield_delay = 0.3 SECOND
	wield_delay_factor = 0.2 // 2069ig

/obj/item/gun/energy/taser/mounted
	name = "mounted taser gun"
	self_recharge = TRUE
	use_external_power = TRUE
	safety = FALSE
	restrict_safety = TRUE
	spawn_blacklisted = TRUE

/obj/item/gun/energy/taser/mounted/cyborg
	name = "taser gun"
	recharge_time = 10 //Time it takes for shots to recharge (in ticks)

/obj/item/gun/energy/stunrevolver
	name = "NT SP \"Zeus\""
	desc = "Also know as stunrevolver. Older and less precise69anotrasen solution for69on-lethal takedowns. This gun has smaller capacity in exchange for S-cells use."
	icon = 'icons/obj/guns/energy/stunrevolver.dmi'
	icon_state = "stunrevolver"
	item_state = "stunrevolver"
	fire_sound = 'sound/weapons/Gunshot.ogg'
	can_dual = TRUE
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	charge_cost = 50
	matter = list(MATERIAL_PLASTEEL = 12,69ATERIAL_WOOD = 6,69ATERIAL_SILVER = 2)
	price_tag = 1500
	suitable_cell = /obj/item/cell/small
	cell_type = /obj/item/cell/small
	projectile_type = /obj/item/projectile/energy/electrode

/obj/item/gun/energy/stunrevolver/moebius
	name = "Moebius SP \"Suez\""	//Ersatz69ame 
	desc = "Also know as stunrevolver. A69oebius copy of the older and less precise69anotrasen solution for69on-lethal takedowns. This gun has smaller capacity in exchange for S-cells use."
	icon = 'icons/obj/guns/energy/stunrevolver_moebius.dmi'
	matter = list(MATERIAL_PLASTEEL = 12,69ATERIAL_STEEL = 6,69ATERIAL_SILVER = 2,69ATERIAL_PLASTIC = 5)
