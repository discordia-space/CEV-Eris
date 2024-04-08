#define CROSSBOW_MAX_AMOUNT 3
#define CROSSBOW_AMOUNT_OF_MATERIAL_PER_SHOT 5

/obj/item/gun/energy/get_hardpoint_maptext()
	return "[round(cell.charge / charge_cost)]/[round(cell.maxcharge / charge_cost)]"

/obj/item/gun/energy/get_hardpoint_status_value()
	var/obj/item/cell/C = get_cell()
	if(istype(C))
		return C.charge/C.maxcharge
	return null

/obj/item/mech_equipment/mounted_system/taser
	name = "mounted taser carbine"
	desc = "A dual fire mode taser system connected to the exosuit's targetting system."
	icon_state = "mech_taser"
	holding_type = /obj/item/gun/energy/taser/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 3)
	matter = list(MATERIAL_PLASTEEL = 25, MATERIAL_PLASTIC = 10, MATERIAL_SILVER = 10)

/obj/item/gun/energy/taser/mounted/mech
	restrict_safety = TRUE
	twohanded = FALSE
	charge_cost = MECH_WEAPON_POWER_COST * 0.5 // Pew pew pew pew pew pew pew pew pew pew
	burst = 3
	burst_delay = 1 // PEW PEW PEW
	init_recoil = LMG_RECOIL(1)
	matter = list()
	cell_type = /obj/item/cell/medium/mech

/obj/item/mech_equipment/mounted_system/taser/ion
	name = "mounted ion rifle"
	desc = "An exosuit-mounted ion rifle. Handle with care."
	icon_state = "mech_ionrifle"
	holding_type = /obj/item/gun/energy/ionrifle/mounted/mech
	matter = list(MATERIAL_PLASTEEL = 25, MATERIAL_PLASTIC = 10, MATERIAL_SILVER = 10)
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 4)

/obj/item/gun/energy/ionrifle/mounted
	bad_type = /obj/item/gun/energy/ionrifle/mounted
	spawn_tags = null

/obj/item/gun/energy/ionrifle/mounted/mech
	use_external_power = TRUE
	restrict_safety = TRUE
	self_recharge = TRUE
	twohanded = FALSE
	charge_cost = MECH_WEAPON_POWER_COST * 0.75
	cell_type = /obj/item/cell/medium/mech
	matter = list()

/obj/item/mech_equipment/mounted_system/taser/laser
	name = "\improper CH-PS \"Immolator\" laser"
	desc = "An exosuit-mounted laser rifle. Handle with care."
	icon_state = "mech_lasercarbine"
	holding_type = /obj/item/gun/energy/laser/mounted/mech
	matter = list(MATERIAL_PLASTEEL = 25, MATERIAL_PLASTIC = 10, MATERIAL_SILVER = 10)
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 3)

/obj/item/gun/energy/laser/mounted
	bad_type = /obj/item/gun/energy/laser/mounted/mech
	spawn_tags = null

/obj/item/gun/energy/laser/mounted/mech
	name = "\improper CH-PS \"Immolator\" laser"
	use_external_power = TRUE
	restrict_safety = TRUE
	self_recharge = TRUE
	twohanded = FALSE
	charge_cost = MECH_WEAPON_POWER_COST
	burst = 2
	init_firemodes = list()
	burst_delay = 1.5
	matter = list()
	cell_type = /obj/item/cell/medium/mech

/obj/item/mech_equipment/mounted_system/taser/plasma
	name = "mounted plasma cutter"
	desc = "An industrial plasma cutter mounted onto the chassis of the mech. "
	icon_state = "mech_plasma" //TODO: Make a new sprite that doesn't get sec called on you.
	holding_type = /obj/item/gun/energy/plasmacutter/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND, HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	origin_tech = list(TECH_MATERIAL = 4, TECH_PLASMA = 4, TECH_ENGINEERING = 6, TECH_COMBAT = 3)
	matter = list(MATERIAL_STEEL = 20, MATERIAL_PLASTEEL = 5)
	spawn_blacklisted = TRUE

/obj/item/gun/energy/plasmacutter
	bad_type = /obj/item/gun/energy/plasmacutter

/obj/item/gun/energy/plasmacutter/mounted
	bad_type = /obj/item/gun/energy/plasmacutter/mounted
	spawn_tags = null

/obj/item/gun/energy/plasmacutter/mounted/mech
	use_external_power = TRUE
	restrict_safety = TRUE
	twohanded = FALSE
	self_recharge = TRUE
	charge_cost = MECH_WEAPON_POWER_COST * 1.5
	projectile_type = /obj/item/projectile/beam/cutter
	matter = list()
	cell_type = /obj/item/cell/medium/mech

/obj/item/gun/projectile/get_hardpoint_maptext()
	return "[get_ammo()]/[ammo_magazine.max_ammo]"

/obj/item/gun/projectile/get_hardpoint_status_value()
	if(ammo_magazine)
		return get_ammo()/ammo_magazine.max_ammo
	return null

/obj/item/mech_equipment/mounted_system/ballistic
	bad_type = /obj/item/mech_equipment/mounted_system/ballistic

/obj/item/mech_equipment/mounted_system/ballistic/pk
	name = "SA \"VJP\""
	desc = "A reverse engineered Pulemyot Kalashnikova fitted for mech use. Fires in 5 round bursts. Horribly inaccurate, but packs quite a punch."
	icon_state = "mech_pk"
	holding_type = /obj/item/gun/projectile/automatic/lmg/pk/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)
	origin_tech = list(TECH_COMBAT = 5, TECH_MAGNET = 3)
	matter = list(MATERIAL_PLASTEEL = 50, MATERIAL_GOLD = 8, MATERIAL_SILVER = 5) // Gold and silver for it's ammo-regeneration electronics
	spawn_blacklisted = TRUE

/obj/item/gun/projectile/automatic/lmg/pk/mounted
	bad_type = /obj/item/gun/projectile/automatic/lmg/pk/mounted

/obj/item/gun/projectile/automatic/lmg/pk/mounted/mech
	name = 	"SA \"VJP\""
	desc = "A reverse engineered Pulemyot Kalashnikova fitted for mech use. Fires in 5 round bursts. Slightly inaccurate, but packs quite a punch."
	restrict_safety = TRUE
	twohanded = FALSE
	init_firemodes = list(
		list(mode_name="spit fire",  burst=5, burst_delay=0.8, one_hand_penalty=15, icon="burst")
		)
	spawn_tags = null
	matter = list()
	magazine_type = /obj/item/ammo_magazine/lrifle/pk/mech


/obj/item/gun/projectile/automatic/lmg/pk/mounted/mech/Initialize()
	. = ..()
	ammo_magazine = new /obj/item/ammo_magazine/lrifle/pk/mech(src)

/obj/item/gun/projectile/automatic/lmg/pk/mounted/mech/afterattack(atom/A, mob/living/user)
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo && !ammo_magazine.stored_ammo.len)
		qdel(ammo_magazine)
		playsound(src.loc, 'sound/weapons/guns/interact/lmg_open.ogg', 100, 1)
		var/mob/living/exosuit/E = loc
		if(istype(E))
			var/obj/item/cell/cell = E.get_cell()
			if(istype(cell))
				cell.use(500)
		ammo_magazine = new /obj/item/ammo_magazine/lrifle/pk/mech(src)
		spawn(1)
			playsound(src.loc, 'sound/weapons/guns/interact/lmg_cock.ogg', 100, 1)
		spawn(2)
			playsound(src.loc, 'sound/weapons/guns/interact/lmg_close.ogg', 100, 1)
/obj/item/mech_equipment/mounted_system/mace
	name = "\improper NT \"Warhead\" mace"
	desc = "An exosuit-mounted mace. Handle with care."
	icon_state = "mech_mace"
	holding_type = /obj/item/tool/hammer/mace/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	matter = list(MATERIAL_PLASTEEL = 15, MATERIAL_STEEL = 10)
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 3)

/obj/item/mech_equipment/mounted_system/mace/Initialize()
	. = ..()
	var/obj/item/tool/hammer/mace/mech/holdin = holding
	holdin.wielded = TRUE

/obj/item/mech_equipment/mounted_system/mace/activate()
	. = ..()
	owner.update_icon()

/obj/item/mech_equipment/mounted_system/mace/deactivate()
	. = ..()
	owner.update_icon()

/obj/item/mech_equipment/mounted_system/mace/on_select()
	. = ..()
	activate()

/obj/item/mech_equipment/mounted_system/mace/on_unselect()
	. = ..()
	deactivate()

/obj/item/mech_equipment/mounted_system/mace/resolve_attackby(mob/living/target, mob/user, params)
	. = ..()
	if(. && ismech(loc) && istype(target) && target != loc)
		if(ishuman(target))
			var/mob/living/carbon/human/targ = target
			if(targ.stats.getStat(STAT_VIG) > STAT_LEVEL_EXPERT)
				targ.visible_message(SPAN_DANGER("[targ] dodges the [holding] slam!"), "You dodge [loc]'s [holding] slam!", "You hear a woosh.", 6)
				return
			targ.visible_message(SPAN_DANGER("[targ] gets slammed by [src]'s [holding]!"), SPAN_NOTICE("You get slammed by [src]'s [holding]!"), "You hear something soft hit a metal plate!", 6)
			targ.Weaken(1)
			targ.throw_at(get_turf_away_from_target_complex(target,user,3), 5, 1, loc)
			targ.damage_through_armor(20, BRUTE, BP_CHEST, ARMOR_MELEE, 1, src, FALSE, FALSE, 1)
		else
			target.visible_message(SPAN_DANGER("[target] gets slammed by [src]'s [holding]!"), SPAN_NOTICE("You get slammed by [src]'s [holding]!"), "You hear something soft hit a metal plate!", 6)
			target.Weaken(1)
			target.throw_at(get_turf_away_from_target_complex(target,user,3), 3, 1, loc)
			target.damage_through_armor(20, BRUTE, BP_CHEST, ARMOR_MELEE, 2, src, FALSE, FALSE, 1)


/obj/item/mech_equipment/mounted_system/mace/get_overlay_state()
	return "[icon_state]_[active ? "on" : "off"]"

/obj/item/tool/hammer/mace/mech
	name = "mace head"
	desc = "What are you standing around staring at this for? You shouldn't be seeing this..."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "mace"
	item_state = "mace"
	matter = list(MATERIAL_PLASTEEL = 15, MATERIAL_PLASTIC = 5)
	w_class = ITEM_SIZE_BULKY
	worksound = WORKSOUND_HAMMER
	wielded = TRUE
	canremove = FALSE
	// Its Big
	armor_divisor = ARMOR_PEN_DEEP
	tool_qualities = list(QUALITY_HAMMERING = 45)
	// its mech sized!!!!!
	structure_damage_factor = STRUCTURE_DAMAGE_DESTRUCTIVE
	spawn_blacklisted = TRUE
	force= WEAPON_FORCE_BRUTAL
	force_wielded_multiplier = 1.5

/obj/item/tool/hammer/mace/mech/attack_self(mob/user)
	. = ..()
	return TRUE

/obj/item/mech_equipment/mounted_system/bfg
	name = "mounted BFG"
	icon_state = "plasmabfg"
	holding_type = /obj/item/gun/energy/plasma_mech
	restricted_software = list(MECH_SOFTWARE_ADVWEAPONS)
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	origin_tech = list(TECH_MATERIAL = 4, TECH_PLASMA = 4, TECH_ENGINEERING = 6, TECH_COMBAT = 3)
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_STEEL = 10, MATERIAL_SILVER = 10)
	spawn_tags = SPAWN_MECH_QUIPMENT
	spawn_blacklisted = FALSE
	rarity_value = 60

/obj/item/gun/energy/plasma_mech
	name = "mounted BFG"
	desc = "A large, bulky weapon that fires a massive energy blast. It's a bit unwieldy, but it packs a punch."
	safety = FALSE
	spawn_tags = null
	spawn_blacklisted = TRUE
	use_external_power = TRUE
	self_recharge = TRUE
	restrict_safety = TRUE
	twohanded = FALSE
	charge_cost = MECH_WEAPON_POWER_COST * 5
	projectile_type = /obj/item/projectile/plasma/aoe/heat/strong/mech
	fire_sound='sound/weapons/energy/melt.ogg'
	burst = 1
	fire_delay = 120
	matter = list()
	cell_type = /obj/item/cell/medium/mech

/obj/item/mech_equipment/mounted_system/crossbow
	name = "mounted crossbow"
	icon_state = "crossbow"
	holding_type = /obj/item/gun/energy/crossbow_mech
	restricted_software = list(MECH_SOFTWARE_WEAPONS)
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	origin_tech = list(TECH_MATERIAL = 4, TECH_PLASMA = 4, TECH_ENGINEERING = 6, TECH_COMBAT = 3)
	matter = list(MATERIAL_STEEL = 10, MATERIAL_PLASTEEL = 15)
	spawn_tags = SPAWN_MECH_QUIPMENT
	spawn_blacklisted = FALSE
	rarity_value = 60

	var/obj/item/gun/energy/crossbow_mech/CM
	var/full_pack = 15

/obj/item/mech_equipment/mounted_system/crossbow/Initialize()
	. = ..()
	CM = holding

/obj/item/mech_equipment/mounted_system/crossbow/attackby(obj/item/I, mob/living/user, params)
	if(!istype(I, /obj/item/stack/material))
		return ..()
	if(CM.shots_amount == CROSSBOW_MAX_AMOUNT)
		to_chat(user, SPAN_NOTICE("There is already pack of material here! You can remove it by using it in hand."))
		return
	var/obj/item/stack/material/mat = I
	if(!mat.material.hardness)
		to_chat(user, SPAN_NOTICE("This material can't be sharpened!"))
		return
	if(mat.can_use(CROSSBOW_AMOUNT_OF_MATERIAL_PER_SHOT*(CROSSBOW_MAX_AMOUNT - CM.shots_amount)))
		if(mat.use(CROSSBOW_AMOUNT_OF_MATERIAL_PER_SHOT*(CROSSBOW_MAX_AMOUNT - CM.shots_amount)))
			to_chat(user , SPAN_NOTICE("You pack [CROSSBOW_AMOUNT_OF_MATERIAL_PER_SHOT * CM.shots_amount] sheets of \the [mat] into \the [src]."))
			CM.bolt_mat = mat.material
			matter[mat.material.name] += full_pack
			CM.shots_amount += CROSSBOW_MAX_AMOUNT - CM.shots_amount
			CM.calculate_damage()

/obj/item/mech_equipment/mounted_system/crossbow/attack_self(mob/user)
	if(CM.bolt_mat)
		to_chat(user, SPAN_NOTICE("You start removing pack from \the [src]."))
		if(do_after(user, 3 SECONDS, src, TRUE, TRUE))
			// No duping!!
			if(!CM.bolt_mat)
				to_chat(user, SPAN_NOTICE("There is no material left to remove from \the [src]."))
				return
			to_chat(user, SPAN_NOTICE("You remove [CROSSBOW_AMOUNT_OF_MATERIAL_PER_SHOT * CM.shots_amount] sheets of [CM.bolt_mat.display_name] from \the [src]'s pack attachment point."))
			matter[CM.bolt_mat.name] -= CROSSBOW_AMOUNT_OF_MATERIAL_PER_SHOT * CM.shots_amount
			var/obj/item/stack/material/mat_stack = new CM.bolt_mat.stack_type(get_turf(user))
			mat_stack.amount = CROSSBOW_AMOUNT_OF_MATERIAL_PER_SHOT * CM.shots_amount
			CM.bolt_mat = null
			CM.shots_amount = 0

/obj/item/gun/energy/crossbow_mech
	name = "mounted crossbow"
	desc = "A large, bulky weapon that fires a plasteel bolt. It's a bit unwieldy, but it packs a punch."
	safety = FALSE
	spawn_tags = null
	spawn_blacklisted = TRUE
	use_external_power = TRUE
	self_recharge = TRUE
	restrict_safety = TRUE
	twohanded = FALSE
	charge_cost = MECH_WEAPON_POWER_COST * 2
	projectile_type = /obj/item/projectile/bullet/bolt/mech
	fire_sound='sound/weapons/energy/melt.ogg'
	burst = 1
	fire_delay = 10
	matter = list()
	cell_type = /obj/item/cell/medium/mech
	var/shots_amount = 0
	var/damage_types = list(BRUTE = 34)
	var/material/bolt_mat = null

/obj/item/gun/energy/crossbow_mech/proc/calculate_damage()
	if(bolt_mat)
		damage_types = list(BRUTE = max(0,round((bolt_mat.hardness/2.5), 1)))
		return
	damage_types = initial(damage_types)

/obj/item/gun/energy/crossbow_mech/consume_next_projectile()
	if(cell.use(charge_cost) && shots_amount)
		shots_amount -= 1
		var/obj/item/projectile/bullet/bolt/mech/bolt = new projectile_type
		bolt.damage_types = damage_types
		. = bolt
	if(!shots_amount)
		bolt_mat = null
		calculate_damage()

#undef CROSSBOW_MAX_AMOUNT
#undef CROSSBOW_AMOUNT_OF_MATERIAL_PER_SHOT
