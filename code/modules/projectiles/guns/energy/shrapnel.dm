/obj/item/weapon/gun/energy/shrapnel
	name = "OR SDF \"Shellshock\" energy shotgun"
	desc = "An Oberth Republic Self Defence Force design, this mat-fab shotgun tends to burn through cells with use."
	icon = 'icons/obj/guns/energy/shrapnel.dmi'
	icon_state = "eshotgun"
	item_charge_meter = TRUE
	item_state = "eshotgun"
	charge_meter = TRUE
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_PAINFUL
	flags =  CONDUCT
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2, TECH_ENGINEERING = 4)
	charge_cost = 50
	suitable_cell = /obj/item/weapon/cell/small
	cell_type = /obj/item/weapon/cell/small
	projectile_type = /obj/item/projectile/bullet/shotgun
	one_hand_penalty = 15 //full sized shotgun level
	fire_delay = 12 //Equivalent to a pump then fire time
	fire_sound = 'sound/weapons/guns/fire/energy_shotgun.ogg'
	init_firemodes = list(
		list(mode_name="pellet", projectile_type=/obj/item/projectile/bullet/pellet/shotgun, charge_cost=100, icon="kill"),
		list(mode_name="stun", projectile_type=/obj/item/projectile/bullet/shotgun/beanbag, charge_cost=25, icon="stun"),
		list(mode_name="blast", projectile_type=/obj/item/projectile/bullet/shotgun, charge_cost=null, icon="destroy"),
	)
	var/consume_cell = FALSE
	price_tag = 2500
	rarity_value = 20
	spawn_tags = SPAWN_TAG_GUN_SHOTGUN_ENERGY
	damage_multiplier = 1.15

/obj/item/weapon/gun/energy/shrapnel/consume_next_projectile()
	.=..()
	if(. && consume_cell && cell.is_empty())
		visible_message(SPAN_WARNING("\The [cell] of \the [src] burns out!"))
		qdel(cell)
		cell = null
		playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)
		new /obj/effect/decal/cleanable/ash(get_turf(src))
	return .



/obj/item/weapon/gun/energy/shrapnel/mounted
	name = "SDF SC \"Schrapnell\""
	desc = "An energy-based shotgun, employing a matter fabricator to pull shotgun rounds from thin air and energy."
	icon_state = "shrapnel"
	self_recharge = TRUE
	use_external_power = TRUE
	safety = FALSE
	restrict_safety = TRUE
	consume_cell = FALSE
	cell_type = /obj/item/weapon/cell/small/high //Two shots
	spawn_blacklisted = TRUE

