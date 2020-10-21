/obj/item/weapon/gun/energy/plasma
	name = "NT PR \"Dominion\""
	desc = "A \"NeoTheology\" weapon that uses advanced plasma generation technology to emit highly controllable blasts of energized matter. Due to its complexity and cost, it is rarely seen in use, except by specialists."
	description_info = "Plasma weapons excel at armor penetration, especially with high-power modes due to extreme temperatures they cause."
	icon = 'icons/obj/guns/energy/pulse.dmi'
	icon_state = "pulse"
	item_state = null	//so the human update icon uses the icon_state instead.
	item_charge_meter = TRUE
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BELT|SLOT_BACK
	force = WEAPON_FORCE_PAINFUL
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_WOOD = 8, MATERIAL_SILVER = 7, MATERIAL_URANIUM = 8)
	price_tag = 4500
	fire_sound = 'sound/weapons/Laser.ogg'
	suitable_cell = /obj/item/weapon/cell/medium
	sel_mode = 2
	charge_cost = 20 //Gives us 40 shots per high medium-sized cell
	recoil_buildup = 1 //pulse weapons have a bit more recoil
	one_hand_penalty = 10
	twohanded = TRUE
	damage_multiplier = 1.3

	init_firemodes = list(
		list(mode_name="burn", projectile_type=/obj/item/projectile/plasma/light, fire_sound='sound/weapons/Taser.ogg', fire_delay=8, charge_cost=20, icon="stun", projectile_color = "#0000FF"),
		list(mode_name="melt", projectile_type=/obj/item/projectile/plasma, fire_sound='sound/weapons/Laser.ogg', fire_delay=12, charge_cost=25, icon="kill", projectile_color = "#FF0000"),
		list(mode_name="INCINERATE", projectile_type=/obj/item/projectile/plasma/heavy, fire_sound='sound/weapons/pulse.ogg', fire_delay=14, charge_cost=30, icon="destroy", projectile_color = "#FFFFFF"),
	)


/obj/item/weapon/gun/energy/plasma/mounted
	self_recharge = TRUE
	use_external_power = TRUE
	safety = FALSE
	twohanded = FALSE
	one_hand_penalty = 0
	spawn_blacklisted = TRUE

/obj/item/weapon/gun/energy/plasma/mounted/blitz
	name = "SDF PR \"Sprengen\""
	desc = "A miniaturized plasma rifle, remounted for robotic use only."
	icon_state = "plasma_turret"
	charge_meter = FALSE
	spawn_tags = null

/obj/item/weapon/gun/energy/plasma/destroyer
	name = "NT PR \"Purger\""
	desc = "A more recent \"NeoTheology\" brand plasma rifle, focused on the superior firepower at the cost of high energy usage."
	icon = 'icons/obj/guns/energy/destroyer.dmi'
	fire_sound = 'sound/weapons/pulse.ogg'
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_WOOD = 8, MATERIAL_SILVER = 10, MATERIAL_URANIUM = 5)
	sel_mode = 1
	fire_delay = 15

	init_firemodes = list(
		list(mode_name="INCINERATE", projectile_type=/obj/item/projectile/plasma/heavy, fire_sound='sound/weapons/pulse.ogg', fire_delay=15, charge_cost=30, icon="kill", projectile_color = "#FFFF00"),
		list(mode_name="VAPORIZE", projectile_type=/obj/item/projectile/plasma/heavy, fire_sound='sound/weapons/pulse.ogg', fire_delay=5, charge_cost=70, icon="destroy", projectile_color = "#FF0000", recoil_buildup=3),
	)


/obj/item/weapon/gun/energy/plasma/cassad
	name = "FS PR \"Cassad\""
	desc = "\"Frozen Star\" brand energy assault rifle, capable of prolonged combat. When surrender is not an option."
	icon = 'icons/obj/guns/energy/cassad.dmi'
	icon_state = "cassad"
	item_state = "cassad"
	matter = list(MATERIAL_PLASTEEL = 18, MATERIAL_PLASTIC = 8, MATERIAL_SILVER = 6, MATERIAL_URANIUM = 6)
	fire_sound = 'sound/weapons/pulse.ogg'
	sel_mode = 1
	charge_cost = 15
	fire_delay = 8
	price_tag = 3000
	zoom_factor = null
	rarity_value = 12

	init_firemodes = list(
		list(mode_name="burn", projectile_type=/obj/item/projectile/plasma/light, fire_sound='sound/weapons/Taser.ogg', fire_delay=8, charge_cost=15, icon="stun", projectile_color = "#00FFFF"),
		list(mode_name="melt", projectile_type=/obj/item/projectile/plasma, fire_sound='sound/weapons/Laser.ogg', fire_delay=12, charge_cost=20, icon="kill", projectile_color = "#00AAFF"),
	)

/obj/item/weapon/gun/energy/plasma/cassad/update_icon()
	..()
	set_item_state(null, back = TRUE)

/obj/item/weapon/gun/energy/plasma/brigador
	name = "Moebius PP \"Brigador\""
	desc = "\"Moebius\" brand energy pistol, for personal overprotection."
	icon = 'icons/obj/guns/energy/brigador.dmi'
	icon_state = "brigador"
	charge_meter = FALSE
	w_class = ITEM_SIZE_NORMAL
	twohanded = FALSE
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	suitable_cell = /obj/item/weapon/cell/small
	projectile_type = /obj/item/projectile/plasma/light
	projectile_color = "#00FFFF"
	fire_sound = 'sound/weapons/Taser.ogg'
	fire_delay = 8
	charge_cost = 15
	matter = list(MATERIAL_PLASTEEL = 10, MATERIAL_PLASTIC = 8, MATERIAL_PLASMA = 2, MATERIAL_SILVER = 3, MATERIAL_URANIUM = 3)
	init_firemodes = list()

/obj/item/weapon/gun/energy/plasma/brigador/update_icon()
	overlays.Cut()
	..()
	if(cell)
		overlays += image(icon, "cell_guild")

/obj/item/weapon/gun/energy/plasma/martyr // or should it be  Zealot
	name = "NT PR \"Martyr\""
	desc = "A \"NeoTheology\" weapon that uses advanced biomass conversion controllable blasts of energized matter. is a disposable side arm, good enough to save you and be recycled."
	icon = 'icons/obj/guns/energy/martyr.dmi'
	icon_state = "martyr"
	suitable_cell = /obj/item/weapon/cell/small    //so if people manage to get the cell out. shouldn't be a huge deal
	item_state = null	//so the human update icon uses the icon_state instead.
	item_charge_meter = TRUE
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_BELT|SLOT_BACK|SLOT_POCKET
	force = WEAPON_FORCE_PAINFUL
	matter = list(MATERIAL_STEEL = 1, "biomatter" = 20)
	disposable = TRUE
	price_tag = 500
	fire_sound = 'sound/weapons/Laser.ogg'
	cell_type = /obj/item/weapon/cell/disposable //so it won't mess up the autolathe building materials
	sel_mode = 2
	charge_cost = 12.5 // for 8 shots
	recoil_buildup = 1
	fire_delay = 8
	one_hand_penalty = 0
	twohanded = FALSE

	init_firemodes = list(
		list(mode_name="Stun", projectile_type=/obj/item/projectile/plasma/stun, fire_sound='sound/weapons/Taser.ogg', fire_delay=null,charge_cost=12.5, icon="stun", projectile_color = "#0000FF"),
		list(mode_name="Melt", projectile_type=/obj/item/projectile/plasma/heavy, fire_sound='sound/weapons/pulse.ogg', fire_delay=null, charge_cost=100, icon="destroy", projectile_color = "#FFFFFF"),
	)
