/obj/item/gun/energy/get_hardpoint_maptext()
	return "[round(cell.charge / charge_cost)]/[round(cell.maxcharge / charge_cost)]"

/obj/item/gun/energy/get_hardpoint_status_value()
	var/obj/item/cell/C = get_cell()
	if(istype(C))
		return C.charge/C.maxcharge
	return null

/obj/item/tool/sword/mech
	name = "mech blade"
	desc = "What are you standing around staring at this for? You shouldn't be seeing this..."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "claymore"
	item_state = "claymore"
	matter = list(MATERIAL_PLASTEEL = 15, MATERIAL_PLASTIC = 5)
	w_class = ITEM_SIZE_BULKY
	worksound = WORKSOUND_HARD_SLASH
	// Its Big
	armor_divisor = ARMOR_PEN_DEEP
	tool_qualities = list(QUALITY_CUTTING = 30, QUALITY_HAMMERING = 20, QUALITY_PRYING = 15)
	// its mech sized!!!!!
	structure_damage_factor = STRUCTURE_DAMAGE_BLADE
	spawn_blacklisted = TRUE

#define OVERKEY_BLADE "blade_overlay"
/obj/item/mech_blade_assembly
	name = "unfinished mech blade"
	desc = "A mech-blade framework lacking a blade"
	icon_state = "mech_blade_assembly"
	matter = list(MATERIAL_PLASTEEL = 15, MATERIAL_PLASTIC = 10)
	var/sharpeners = 0
	var/material/blade_mat = null

/obj/item/mech_blade_assembly/Initialize()
	. = ..()
	AddComponent(/datum/component/overlay_manager)

/obj/item/mech_blade_assembly/examine(user, distance)
	. = ..()
	if(.)
		if(sharpeners)
			to_chat(user, SPAN_NOTICE("It requires [sharpeners] sharpeners to be sharp enough"))
		else
			to_chat(user, SPAN_NOTICE("It needs 5 sheets of a metal inserted to form the basic blade"))
		to_chat(user , SPAN_NOTICE("Use a wrench to make this mountable. This is not reversible"))

/obj/item/mech_blade_assembly/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/tool_upgrade/productivity/whetstone))
		if(sharpeners)
			user.remove_from_mob(I, TRUE)
			I.forceMove(src)
			to_chat(user ,SPAN_NOTICE("You sharpen the blade on the [src]"))
			sharpeners--
		return
	if(istool(I))
		var/obj/item/tool/thing = I
		if(thing.has_quality(QUALITY_BOLT_TURNING))
			if(!blade_mat)
				to_chat(user, SPAN_NOTICE("You can't tighten the blade-mechanism onto a blade of air!"))
				return
			to_chat(user, SPAN_NOTICE("You start tightening \the [src] onto the blade made of [blade_mat.display_name]"))
			if(I.use_tool(user, src, WORKTIME_SLOW, QUALITY_BOLT_TURNING, 0, STAT_MEC, 150))
				if(QDELETED(src))
					return
				to_chat(user, SPAN_NOTICE("You tighten the blade on \the [src], creating a mech-mountable blade "))
				var/obj/item/mech_equipment/mounted_system/sword/le_mech_comp = new /obj/item/mech_equipment/mounted_system/sword(get_turf(src))
				var/obj/item/mech_equipment/mounted_system/sword/le_mech_sword = le_mech_comp.holding
				// DULL BLADE gets DULL DAMAGE
				le_mech_sword.force = max(0,(blade_mat.hardness - 35 * sharpeners)/2)
				le_mech_sword.matter = list(blade_mat.name = 5)
				qdel(src)
				return

	if(!istype(I, /obj/item/stack/material))
		return ..()
	if(blade_mat)
		to_chat(user, SPAN_NOTICE("There is already a blade formed! You can remove it by using it in hand."))
		return
	var/obj/item/stack/material/mat = I
	if(!mat.material.hardness)
		to_chat(user, SPAN_NOTICE("This material can't be sharpened!"))
		return
	if(mat.can_use(5))
		if(mat.use(5))
			to_chat(user , SPAN_NOTICE("You insert 5 sheets of the [mat] into the [src] , creating a blade requiring [round((mat.material.hardness)/60)] sharpeners to not be dull"))
			blade_mat = mat.material
			sharpeners = round(blade_mat.hardness/60)
			matter[mat.material.name]+= 5
			update_icon()

/obj/item/mech_blade_assembly/attack_self(mob/user)
	if(blade_mat)
		to_chat(user, SPAN_NOTICE("You start removing the blade from \the [src]"))
		if(do_after(user, 3 SECONDS, src, TRUE, TRUE))
			// No duping!!
			if(!blade_mat)
				to_chat(user, SPAN_NOTICE("There is no material left to remove from \the [src]"))
				return
			to_chat(user, SPAN_NOTICE("You remove 5 sheets of [blade_mat.display_name] from the [src]'s blade attachment point"))
			matter[blade_mat.name]-= 5
			var/obj/item/stack/material/mat_stack = new blade_mat.stack_type(get_turf(user))
			mat_stack.amount = 5
			blade_mat = null
			update_icon()

/obj/item/mech_blade_assembly/update_icon()
	. = ..()
	var/datum/component/overlay_manager/thing = GetComponent(/datum/component/overlay_manager)
	if(thing)
		thing.removeOverlay(OVERKEY_BLADE)
		if(blade_mat)
			var/mutable_appearance/overlay = mutable_appearance(src.icon, "[icon_state]_blade")
			overlay.color = blade_mat.icon_colour
			thing.addOverlay(OVERKEY_BLADE, overlay)

#undef OVERKEY_BLADE


/obj/item/mech_equipment/mounted_system/sword
	name = "\improper NT \"Warborne\" sword"
	desc = "An exosuit-mounted sword. Handle with care."
	icon_state = "mech_blade"
	holding_type = /obj/item/tool/sword/mech
	matter = list(MATERIAL_PLASTEEL = 15, MATERIAL_PLASTIC = 10)
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 3)


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
		FULL_AUTO_400
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

/obj/item/mech_equipment/mounted_system/ballistic/s
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
		FULL_AUTO_400
		)
	spawn_tags = null
	matter = list()
	magazine_type = /obj/item/ammo_magazine/lrifle/pk/mech
