/obj/item/weapon/gun/energy/shrapnel
	name = "SDF SC \"Schrapnell\""
	desc = "An energy-based shotgun, employing a matter fabricator to pull shotgun rounds from thin air and energy."
	icon_state = "shrapnel"
	charge_meter = TRUE
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_PAINFUL
	flags =  CONDUCT
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2, TECH_ENGINEERING = 4)
	charge_cost = 100
	suitable_cell = /obj/item/weapon/cell/small
	cell_type = /obj/item/weapon/cell/small
	projectile_type = /obj/item/projectile/bullet/shotgun
	one_hand_penalty = 15 //full sized shotgun level
	fire_delay = 12 //Equivalent to a pump then fire time
	init_firemodes = list(
		list(mode_name="pellet", projectile_type=/obj/item/projectile/bullet/shotgun, charge_cost=null, icon="kill"),
		list(mode_name="stun", projectile_type=/obj/item/projectile/bullet/shotgun/beanbag, charge_cost=75, icon="stun"),
		list(mode_name="blast", projectile_type=/obj/item/projectile/bullet/pellet/shotgun, charge_cost=150, icon="destroy"),
	)


/obj/item/weapon/gun/energy/shrapnel/mounted
	self_recharge = 1
	use_external_power = 1
	safety = FALSE
	restrict_safety = TRUE
	cell_type = /obj/item/weapon/cell/small/high //Two shots