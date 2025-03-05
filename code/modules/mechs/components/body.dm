/obj/item/storage/mech
	w_class = ITEM_SIZE_BULKY
	max_w_class = ITEM_SIZE_BULKY
	max_storage_space = DEFAULT_NORMAL_STORAGE
	use_sound = 'sound/effects/storage/toolbox.ogg'
	anchored = TRUE

/obj/item/mech_component/chassis/Adjacent(var/atom/neighbor, var/recurse = 1) //For interaction purposes we consider body to be adjacent to whatever holder mob is adjacent
	var/mob/living/exosuit/E = loc
	if(istype(E))
		. = E.Adjacent(neighbor, recurse)
	return . || ..()

/obj/item/storage/mech/Adjacent(var/atom/neighbor, var/recurse = 1) //in order to properly retrieve items
	var/obj/item/mech_component/chassis/C = loc
	if(istype(C))
		. = C.Adjacent(neighbor, recurse-1)
	return . || ..()

/obj/item/mech_component/chassis
	name = "exosuit chassis"
	icon_state = "loader_body"
	gender = NEUTER
	has_hardpoints = list(HARDPOINT_BACK, HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	matter = list(MATERIAL_STEEL = 20)

	var/mech_health = 300
	var/obj/item/cell/cell
	var/obj/item/robot_parts/robot_component/diagnosis_unit/diagnostics
	var/obj/item/robot_parts/robot_component/exosuit_control/computer
	var/obj/machinery/portable_atmospherics/canister/air_supply
	var/obj/item/storage/mech/storage_compartment
	var/datum/gas_mixture/cockpit
	var/transparent_cabin = FALSE
	var/hide_pilot = FALSE
	var/hatch_descriptor = "cockpit"
	var/list/pilot_positions
	var/pilot_coverage = 100
	/// if defined , will have coverage multiplied by the dir the attack is coming from.
	// first slot is frontal, second is sides and the last is behind
	var/list/coverage_multipliers
	/// wheter this chasis has a hatch or not to open/close
	var/has_hatch = TRUE
	/// wheter this mech can only take one type of this component. Setting it to true will make it not take any kind of component. False is universal. setting a type will enforce that type as acceptable
	var/strict_arm_type = FALSE
	var/strict_leg_type = FALSE
	var/strict_sensor_type = FALSE
	var/min_pilot_size = MOB_SMALL
	var/max_pilot_size = MOB_LARGE
	var/climb_time = 25
	/// does this mech chassis have support for charging all cells inside of its storage? if its 0 it doesnt
	var/cell_charge_rate = 200
	/// Wheter chassis blocks sight from a outside POV (aka can see behind mech or not ?)
	var/opaque_chassis = TRUE
	///If TRUE, the chassis will not allow humans with heavy armor to board it
	var/armor_restrictions = FALSE

/obj/item/mech_component/chassis/New()
	..()
	if(isnull(pilot_positions))
		pilot_positions = list(
			list(
				"[NORTH]" = list("x" = 8, "y" = 0),
				"[SOUTH]" = list("x" = 8, "y" = 0),
				"[EAST]"  = list("x" = 8, "y" = 0),
				"[WEST]"  = list("x" = 8, "y" = 0)
			)
		)

/obj/item/mech_component/chassis/get_cell()
	return cell

/obj/item/mech_component/chassis/Destroy()
	QDEL_NULL(cell)
	QDEL_NULL(computer)
	QDEL_NULL(air_supply)
	QDEL_NULL(diagnostics)
	QDEL_NULL(storage_compartment)
	. = ..()

/obj/item/mech_component/chassis/handle_atom_del(atom/A)
	..()
	if(A == cell)
		cell = null
	if(A == computer)
		computer = null
	if(A == air_supply)
		air_supply = null
	if(A == diagnostics)
		diagnostics = null
	if(A == storage_compartment)
		storage_compartment = null

/obj/item/mech_component/chassis/update_components()
	. = ..()
	cell = locate() in src
	computer = locate() in src
	air_supply = locate() in src
	diagnostics = locate() in src
	storage_compartment = locate() in src

/obj/item/mech_component/chassis/show_missing_parts(var/mob/user)
	if(!cell)
		to_chat(user, SPAN_WARNING("It is missing a power cell."))
	if(!computer)
		to_chat(user, SPAN_WARNING("It is missing a control computer."))
	if(!diagnostics)
		to_chat(user, SPAN_WARNING("It is missing a diagnostic scanner."))

/obj/item/mech_component/chassis/Initialize()
	. = ..()
	air_supply = new /obj/machinery/portable_atmospherics/canister/air(src)
	storage_compartment = new(src)
	cockpit = new(250)
	if(loc)
		cockpit.equalize(loc.return_air())

/obj/item/mech_component/chassis/proc/update_air(take_from_supply)

	var/changed
	if(!take_from_supply || pilot_coverage < 100)
		var/turf/T = get_turf(src)
		if(!T)
			return
		cockpit.equalize(T.return_air())
		changed = TRUE
	else if(air_supply)
		var/env_pressure = cockpit.return_pressure()
		var/pressure_delta = air_supply.release_pressure - env_pressure
		if((air_supply.air_contents.temperature > 0) && (pressure_delta > 0))
			var/transfer_moles = calculate_transfer_moles(air_supply.air_contents, cockpit, pressure_delta)
			transfer_moles = min(transfer_moles, (air_supply.release_flow_rate/air_supply.air_contents.volume)*air_supply.air_contents.total_moles)
			pump_gas_passive(air_supply, air_supply.air_contents, cockpit, transfer_moles)
			changed = TRUE
	if(changed)
		cockpit.react()

/obj/item/mech_component/chassis/ready_to_install()
	return (cell && computer && diagnostics)

/obj/item/mech_component/chassis/update_health()
	. = ..()
	if(total_damage >= max_damage)
		var/mob/living/exosuit/hold = loc
		if(!istype(hold))
			return
		hold.hatch_locked = FALSE
		hold.hatch_closed = FALSE
		hold.update_icon()

/obj/item/mech_component/chassis/prebuild()
	computer = new /obj/item/robot_parts/robot_component/exosuit_control(src)
	cell = new /obj/item/cell/large/high(src)
	diagnostics = new /obj/item/robot_parts/robot_component/diagnosis_unit(src)

/obj/item/mech_component/chassis/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/robot_parts/robot_component/exosuit_control))
		if(computer)
			to_chat(user, SPAN_WARNING("\The [src] already has a control computer installed."))
			return
		if(insert_item(I, user))
			computer = I
	else if(istype(I, /obj/item/cell/large))
		if(cell)
			to_chat(user, SPAN_WARNING("\The [src] already has a cell installed."))
			return
		if(insert_item(I, user))
			cell = I
	else if(istype(I, /obj/item/robot_parts/robot_component/diagnosis_unit))
		if(diagnostics)
			to_chat(user, SPAN_WARNING("\The [src] already has a diagnosis unit installed."))
			return
		else if(insert_item(I, user))
			diagnostics = I
	else
		return ..()

/obj/item/mech_component/chassis/MouseDrop_T(atom/dropping, mob/user)
	var/obj/machinery/portable_atmospherics/canister/C = dropping
	if(istype(C) && !C.anchored && do_after(user, 5, src))
		if(C.anchored)
			return
		to_chat(user, SPAN_NOTICE("You install the canister in the [src]."))
		if(air_supply)
			air_supply.forceMove(get_turf(src))
			air_supply = null
		C.forceMove(src)
		update_components()
	else . = ..()

/obj/item/mech_component/chassis/return_diagnostics(mob/user)
	..()
	if(diagnostics)
		to_chat(user, SPAN_NOTICE(" Diagnostics Unit Integrity: <b>[round((((diagnostics.max_dam - diagnostics.total_dam) / diagnostics.max_dam)) * 100)]%</b>"))
	else
		to_chat(user, SPAN_WARNING(" Diagnostics Unit Missing or Non-functional."))
	if(computer)
		to_chat(user, SPAN_NOTICE(" Installed Software"))
		for(var/exosystem_computer in computer.installed_software)
			to_chat(user, SPAN_NOTICE(" - <b>[capitalize(exosystem_computer)]</b>"))
	else
		to_chat(user, SPAN_WARNING(" Control Module Missing or Non-functional."))
/obj/item/mech_component/chassis/MouseDrop(atom/over)
	if(!usr || !over) return
	if(!Adjacent(usr) || !over.Adjacent(usr)) return

	if(storage_compartment)
		return storage_compartment.MouseDrop(over)

/obj/item/mech_component/chassis/cheap
	name = "open exosuit chassis"
	hatch_descriptor = "roll cage"
	pilot_coverage = 40
	exosuit_desc_string = "an industrial roll cage"
	desc = "An industrial roll cage. Absolutely useless in hazardous environments, as it isn't even sealed."
	max_damage = 150
	power_use = 0
	climb_time = 7 // Quickest entry because it's unsealed
	armor = list(melee = 24, bullet = 10, energy = 4, bomb = 60, bio = 100, rad = 0)
	shielding = 5
	rear_mult = 1.2

/obj/item/mech_component/chassis/cheap/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 8),
			"[SOUTH]" = list("x" = 8,  "y" = 8),
			"[EAST]"  = list("x" = 8,  "y" = 8),
			"[WEST]"  = list("x" = 8,  "y" = 8)
		),
		list(
			"[NORTH]" = list("x" = 8,  "y" = 16),
			"[SOUTH]" = list("x" = 8,  "y" = 16),
			"[EAST]"  = list("x" = 0,  "y" = 16),
			"[WEST]"  = list("x" = 16, "y" = 16)
		)
	)
	. = ..()

/obj/item/mech_component/chassis/light
	name = "light exosuit chassis"
	hatch_descriptor = "canopy"
	desc = "This light cockpit combines ultralight materials with clear aluminum laminates to provide an optimized cockpit experience. Doesn't offer much protection, though."
	pilot_coverage = 100
	transparent_cabin =  TRUE
	hide_pilot = TRUE //Sprite too small, legs clip through, so for now hide pilot
	exosuit_desc_string = "an open and light chassis"
	icon_state = "light_body"
	max_damage = 75
	power_use = 5
	emp_shielded = TRUE
	climb_time = 10 //gets a buff to climb_time, in exchange for being less beefy
	has_hardpoints = list(HARDPOINT_BACK, HARDPOINT_RIGHT_SHOULDER)
	matter = list(MATERIAL_STEEL = 20, MATERIAL_GLASS = 6, MATERIAL_PLASTIC = 10)
	armor = list(melee = 16, bullet = 8, energy = 4, bomb = 40, bio = 100, rad = 100)

/obj/item/mech_component/chassis/combat
	name = "sealed exosuit chassis"
	hatch_descriptor = "canopy"
	desc = "An advanced cockpit that utilises sophisticated fiber optic sensors to enable outside visibility without additional hardware."
	pilot_coverage = 100
	transparent_cabin = TRUE
	hide_pilot = TRUE
	exosuit_desc_string = "an armored chassis"
	icon_state = "combat_body"
	max_damage = 200
	mech_health = 500 //It's not as beefy as the heavy, but it IS a combat chassis, so let's make it slightly beefier
	power_use = 40
	climb_time = 25 //standard values for now to encourage use over heavy
	matter = list(MATERIAL_STEEL = 46, MATERIAL_PLASTEEL = 12, MATERIAL_GOLD = 4, MATERIAL_SILVER = 4)
	armor = list(melee = 26, bullet = 22, energy = 16, bomb = 100, bio = 100, rad = 100)
	shielding = 10
	front_mult = 1.25
	rear_mult = 0.75
	armor_restrictions = TRUE

/obj/item/mech_component/chassis/heavy
	name = "reinforced exosuit chassis"
	hatch_descriptor = "hatch"
	desc = "This heavy combat chassis is a veritable juggernaut, capable of protecting a pilot even in the most violent of conflicts. It's hell to climb in and out of, however."
	pilot_coverage = 100
	exosuit_desc_string = "a heavily armoured chassis"
	icon_state = "heavy_body"
	max_damage = 300
	mech_health = 750
	power_use = 50
	climb_time = 35 //Takes longer to climb into, but is beefy as HELL.
	matter = list(MATERIAL_STEEL = 50, MATERIAL_URANIUM = 20, MATERIAL_PLASTEEL = 20)
	armor = list(melee = 32, bullet = 24, energy = 20, bomb = 160, bio = 100, rad = 100)
	shielding = 15
	front_mult = 1.5
	rear_mult = 0.75
	armor_restrictions = TRUE

/obj/item/mech_component/chassis/forklift
	name = "forklift chassis"
	desc = "Has an integrated forklift clamp for the industrial relocation of resources. Are you ready to lift?"
	icon_state = "seat-cockpit"
	has_hardpoints = list(HARDPOINT_FRONT, HARDPOINT_RIGHT_SHOULDER)
	exosuit_desc_string = "a forklifting chassis"
	strict_sensor_type = TRUE
	strict_leg_type = /obj/item/mech_component/propulsion/wheels
	strict_arm_type = TRUE
	pilot_coverage = 30
	max_damage = 100
	mech_health = 200
	opaque_chassis = FALSE
	matter = list(MATERIAL_STEEL = 20, MATERIAL_PLASTIC = 10)
	armor = list(melee = 20, bullet = 8, energy = 4, bomb = 50, bio = 100, rad = 0)

/obj/item/mech_component/chassis/forklift/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 9,  "y" = 5),
			"[SOUTH]" = list("x" = 9,  "y" = 5),
			"[EAST]"  = list("x" = 6,  "y" = 5),
			"[WEST]"  = list("x" = 8,  "y" = 5)
		),
		list(
			"[NORTH]" = list("x" = 9,  "y" = 5),
			"[SOUTH]" = list("x" = 9,  "y" = 10),
			"[EAST]"  = list("x" = 0,  "y" = 5),
			"[WEST]"  = list("x" = 16,  "y" = 5)
		)
	)
	. = ..()

/obj/item/mech_component/chassis/walker
	name = "walker chassis"
	desc = "A walker mech chassis. Very sturdy but only provides decent pilot coverage from the front."
	icon_state = "walker"
	has_hatch = FALSE
	has_hardpoints = list(HARDPOINT_RIGHT_HAND, HARDPOINT_LEFT_HAND)
	opaque_chassis = FALSE
	strict_sensor_type = TRUE
	strict_arm_type = TRUE
	max_damage = 400
	mech_health = 900
	power_use = 40
	climb_time = 10
	matter = list(MATERIAL_STEEL = 40, MATERIAL_PLASTEEL = 30, MATERIAL_SILVER = 5)
	pilot_coverage = 30
	coverage_multipliers = list(3, 1.5, 0)
	armor = list(melee = 36, bullet = 26, energy = 20, bomb = 160, bio = 100, rad = 100)
	shielding = 20


/obj/item/mech_component/chassis/walker/Initialize()
	pilot_positions = list(
		list(
			"[NORTH]" = list("x" = 8,  "y" = 15),
			"[SOUTH]" = list("x" = 8,  "y" = 20),
			"[EAST]"  = list("x" = 0,  "y" = 16),
			"[WEST]"  = list("x" = 16,  "y" = 16)
		)
	)
	. = ..()
