/obj/item/gun/energy/plasma
	name = "NT PR \"Dominion\""
	desc = "A \"NeoTheology\" weapon that uses advanced plasma generation technology to emit highly controllable blasts of energized matter. Due to its complexity and cost, it is rarely seen in use, except by specialists."
	description_info = "Plasma weapons excel at armor penetration, especially with high-power modes due to extreme temperatures they cause."
	icon = 'icons/obj/guns/energy/pulse.dmi' // back and on_suit sprites required, pretty please
	icon_state = "pulse"
	item_state = null	//so the human update icon uses the icon_state instead.
	item_charge_meter = TRUE
	volumeClass = ITEM_SIZE_HUGE
	slot_flags = SLOT_BELT|SLOT_BACK
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_WOOD = 8, MATERIAL_SILVER = 7, MATERIAL_URANIUM = 8)
	price_tag = 4500
	fire_sound = 'sound/weapons/energy/burn.ogg'
	suitable_cell = /obj/item/cell/medium
	sel_mode = 1
	charge_cost = 15 //Gives us 40 shots per low-tier medium-sized cell
	twohanded = TRUE
	fire_delay = 4
	charge_cost = 15

	init_firemodes = list(
		list(mode_name="Burn", mode_desc="A relatively light plasma round", projectile_type=/obj/item/projectile/plasma/light, fire_sound='sound/weapons/energy/melt.ogg', burst=1, fire_delay=4, charge_cost=15, icon="kill", projectile_color = "#0088ff"),
		list(mode_name="Sear", mode_desc="A three-round burst of light plasma rounds, for dealing with unruly crowds", projectile_type=/obj/item/projectile/plasma/light, fire_sound='sound/weapons/energy/melt.ogg', burst=3, fire_delay=12, burst_delay=1, charge_cost=15, icon="burst", projectile_color = "#0088ff"),
		list(mode_name="INCINERATE", mode_desc="A heavy armor-stripping plasma round", projectile_type=/obj/item/projectile/plasma/aoe/heat, fire_sound='sound/weapons/energy/incinerate.ogg', burst=1, fire_delay=20, charge_cost=90, icon="destroy", projectile_color = "#FFFFFF"),
	)
	init_recoil = RIFLE_RECOIL(1)

	serial_type = "NT"


/obj/item/gun/energy/plasma/mounted
	self_recharge = TRUE
	use_external_power = TRUE
	safety = FALSE
	twohanded = FALSE
	spawn_tags = null
	spawn_blacklisted = TRUE
	bad_type = /obj/item/gun/energy/plasma/mounted
	init_recoil = LMG_RECOIL(1)

/obj/item/gun/energy/plasma/mounted/blitz
	name = "SDF PR \"Sprengen\""
	desc = "A miniaturized plasma rifle, remounted for robotic use only."
	icon_state = "plasma_turret"
	charge_meter = FALSE
	bad_type = /obj/item/gun/energy/plasma/mounted/blitz
	init_firemodes = list(
		list(mode_name="Medium", mode_desc="A standard plasma round, effective against armor", projectile_type=/obj/item/projectile/plasma, fire_sound='sound/weapons/energy/vaporize.ogg', burst=1, fire_delay=6, charge_cost=25, icon="kill", projectile_color = "#00AAFF")
	)

/obj/item/gun/energy/plasma/destroyer
	name = "NT PR \"Purger\""
	desc = "A more recent \"NeoTheology\" brand plasma cannon, focused on the superior firepower at the cost of high energy usage. \
            There\'s an inscription on the stock. \'For those whom the Angels hath cursed: thou wilt find, have no one to help.\'"
	icon = 'icons/obj/guns/energy/destroyer.dmi' // Dominion _doble sprites so pls draw + back and on_suit sprites required, pretty please
	fire_sound = 'sound/weapons/energy/incinerate.ogg'
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_WOOD = 8, MATERIAL_SILVER = 10, MATERIAL_URANIUM = 5)
	slot_flags = SLOT_BACK
	fire_delay = 20
	charge_cost = 200

	init_firemodes = list(
		list(mode_name="DISINTEGRATE", mode_desc="Removes heresy from sight", projectile_type=/obj/item/projectile/plasma/aoe/heat/strong, fire_sound='sound/weapons/energy/incinerate.ogg', fire_delay=20, charge_cost=200, icon="destroy", projectile_color = "#ff1212"),
		list(mode_name="CLEANSE", mode_desc="Cleanse the filth", mode_type = /datum/firemode/automatic, projectile_type=/obj/item/projectile/plasma, fire_sound='sound/weapons/energy/vaporize.ogg', fire_delay=4, charge_cost=35, icon="burst", projectile_color = "#00AAFF"),
	)
	init_recoil = LMG_RECOIL(1)

/obj/item/gun/energy/plasma/cassad
	name = "FS PR \"Cassad\""
	desc = "\"Frozen Star\" brand energy assault rifle, capable of prolonged combat. When surrender is not an option."
	icon = 'icons/obj/guns/energy/cassad.dmi'
	icon_state = "cassad"
	item_state = "cassad"
	matter = list(MATERIAL_PLASTEEL = 18, MATERIAL_PLASTIC = 8, MATERIAL_SILVER = 6, MATERIAL_URANIUM = 6)
	fire_sound = 'sound/weapons/energy/burn.ogg'
	charge_cost = 25
	fire_delay = 6
	serial_type = "FS"
	price_tag = 3000
	zoom_factors = list()

	init_firemodes = list(
		list(mode_name="Melt", mode_desc="A reliable plasma round, for stripping away armor", projectile_type=/obj/item/projectile/plasma, fire_sound='sound/weapons/energy/burn.ogg', burst=1, fire_delay=6, charge_cost=25, icon="kill", projectile_color = "#00AAFF"),
		list(mode_name="Pulse", mode_desc="A plasma round configured to explode violently on impact, and cause a pulse of EMP", projectile_type=/obj/item/projectile/plasma/aoe/ion, fire_sound='sound/weapons/Taser.ogg', burst=1, fire_delay=12, charge_cost=150, icon="stun", projectile_color = "#00FFFF")
	)
	init_recoil = RIFLE_RECOIL(1)
	spawn_tags = SPAWN_TAG_FS_ENERGY

/obj/item/gun/energy/plasma/cassad/update_icon(ignore_inhands)
	..()
	if(charge_meter)
		var/ratio = 0

		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		if(cell && cell.charge >= charge_cost)
			ratio = cell.charge / cell.maxcharge
			ratio = min(max(round(ratio, 0.25) * 100, 25), 100)

		if(item_charge_meter)
			set_item_state("-[ratio]")
			wielded_item_state = "_doble" + "-[ratio]"
			icon_state = initial(icon_state) + "[ratio]"
	if(!ignore_inhands)
		update_wear_icon()

/obj/item/gun/energy/plasma/brigador
	name = "ML PP \"Brigador\""
	desc = "\"Moebius\" brand energy pistol, for personal overprotection."
	icon = 'icons/obj/guns/energy/brigador.dmi'
	icon_state = "brigador"
	can_dual = TRUE
	charge_meter = FALSE
	volumeClass = ITEM_SIZE_NORMAL
	twohanded = FALSE
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	suitable_cell = /obj/item/cell/small
	projectile_type = /obj/item/projectile/plasma/light
	projectile_color = "#00FFFF"
	fire_sound = 'sound/weapons/energy/incinerate.ogg'
	fire_delay = 6
	charge_cost = 15
	serial_type = "ML"
	init_recoil = HANDGUN_RECOIL(1)
	matter = list(MATERIAL_PLASTEEL = 10, MATERIAL_PLASTIC = 8, MATERIAL_PLASMA = 2, MATERIAL_SILVER = 3, MATERIAL_URANIUM = 3)

	init_firemodes = list(
		list(mode_name="Low Power", mode_desc="A relatively light plasma round", projectile_type=/obj/item/projectile/plasma/light, fire_sound='sound/weapons/energy/melt.ogg', burst=1, fire_delay=6, charge_cost=15, icon="kill", projectile_color = "#0088ff"),
		list(mode_name="High Power", mode_desc="A heavy armor-stripping plasma round", projectile_type=/obj/item/projectile/plasma/heavy, fire_sound='sound/weapons/energy/incinerate.ogg', burst=1, fire_delay=15, charge_cost=60, icon="destroy", projectile_color = "#FFFFFF"),
		list(mode_name="Pulse", mode_desc="A plasma round configured to cause a small pulse of EMP", projectile_type=/obj/item/projectile/plasma/aoe/ion/light, fire_sound='sound/weapons/Taser.ogg', burst=1, fire_delay=15, charge_cost=60, icon="stun", projectile_color = "#00FFFF")
	)

/obj/item/gun/energy/plasma/brigador/update_icon()
	cut_overlays()
	..()
	overlays.Cut()
	..()

	if(istype(cell, /obj/item/cell/small/moebius/nuclear))
		overlays += image(icon, "cell_nuclear")

	else if(istype(cell, /obj/item/cell/small/moebius))
		overlays += image(icon, "cell_moebius")

	else if(istype(cell, /obj/item/cell/small/excelsior))
		overlays += image(icon, "cell_excelsior")

	else if(istype(cell, /obj/item/cell/small))
		overlays += image(icon, "cell_guild")
