// Big stompy robots.
/mob/living/exosuit
	name = "exosuit"
	desc = "A powerful machine piloted from a cockpit, but worn like a suit of armour."
	density = TRUE
	opacity = TRUE
//	anchored = TRUE
	default_pixel_x = -8
	default_pixel_y = 0
	status_flags = PASSEMOTES
	a_intent = I_HURT
	mob_size = MOB_GIGANTIC
	can_be_fed = 0
	defaultHUD = "exosuits"
	bad_type = /mob/living/exosuit

	mob_classification = CLASSIFICATION_SYNTHETIC

	var/initial_icon

	var/emp_damage = 0

	var/obj/item/device/radio/exosuit/radio

	var/wreckage_path = /obj/structure/exosuit_wreckage
	var/mech_turn_sound = 'sound/mechs/Mech_Rotation.ogg'
	var/mech_step_sound = 'sound/mechs/Mech_Step.ogg'

	// Access updating/container.
	var/obj/item/card/id/access_card
	var/list/saved_access = list()
	var/sync_access = TRUE

	// Mob currently piloting the exosuit.
	var/list/pilots
	var/list/pilot_overlays

	// Visible external components. Not strictly accurately named for non-humanoid machines (submarines) but w/e
	var/obj/item/mech_component/manipulators/arms
	var/obj/item/mech_component/propulsion/legs
	var/obj/item/mech_component/sensors/head
	var/obj/item/mech_component/chassis/body

	// Invisible components.
	var/datum/effect/effect/system/spark_spread/sparks

	// Equipment tracking vars.
	var/obj/item/mech_equipment/selected_system
	var/selected_hardpoint
	var/list/hardpoints = list()
	var/hardpoints_locked
	var/maintenance_protocols
	/// For equipment that has a process based on mech Life tick
	var/list/obj/item/mech_equipment/tickers = list()

	// Material
	var/material/material = MATERIAL_STEEL

	// Cockpit access vars.
	var/hatch_closed = FALSE
	var/hatch_locked = FALSE

	//Air!
	var/use_air = FALSE

	injury_type = INJURY_TYPE_UNLIVING // Has no soft vitals, but also contains delicate electronics

// Interface stuff.
	var/list/hud_elements = list()
	var/list/hardpoint_hud_elements = list()
	var/obj/screen/movable/exosuit/health/hud_health
	var/obj/screen/movable/exosuit/toggle/hatch_open/hud_open
	var/obj/screen/movable/exosuit/power/hud_power
	var/obj/screen/movable/exosuit/heat/hud_heat
	var/obj/screen/movable/exosuit/toggle/power_control/hud_power_control
	var/obj/screen/movable/exosuit/toggle/camera/hud_camera

	var/power = MECH_POWER_OFF

	// Strafing - Is the mech currently strafing?
	var/strafing = FALSE

/mob/living/exosuit/show_message(msg, type, alt, alt_type)
	for(var/mob/i in pilots)
		i.show_message(msg, type, alt, alt_type)

/mob/living/exosuit/proc/occupant_message(msg as text)
	for(var/mob/i in pilots)
		to_chat(i, msg)

/mob/living/exosuit/proc/toggle_power(mob/living/user)
	if(power == MECH_POWER_TRANSITION)
		to_chat(user, SPAN_NOTICE("Power transition in progress. Please wait."))
	else if(power == MECH_POWER_ON) //Turning it off is instant
		playsound(src, 'sound/mechs/mech-shutdown.ogg', 100, 0)
		power = MECH_POWER_OFF
	else if(get_cell(TRUE))
		//Start power up sequence
		power = MECH_POWER_TRANSITION
		playsound(src, 'sound/mechs/powerup.ogg', 50, 0)
		if(do_after(user, 1.5 SECONDS, src) && power == MECH_POWER_TRANSITION)
			playsound(src, 'sound/mechs/nominal.ogg', 50, 0)
			power = MECH_POWER_ON
		else
			to_chat(user, SPAN_WARNING("You abort the powerup sequence."))
			power = MECH_POWER_OFF
		//hud_power_control?.queue_icon_update()
	else
		to_chat(user, SPAN_WARNING("Error: No power cell was detected."))



/*
/mob/living/exosuit/is_flooded()
	. = (body && body.pilot_coverage >= 100 && hatch_closed) ? FALSE : ..()
*/

/mob/living/exosuit/Initialize(mapload, var/obj/structure/heavy_vehicle_frame/source_frame)
	. = ..()

	material = get_material_by_name("[material]")
	if(!access_card) access_card = new (src)

	pixel_x = default_pixel_x
	pixel_y = default_pixel_y
	sparks = new(src)

	// Grab all the supplied components.
	if(source_frame)
		if(source_frame.set_name) name = source_frame.set_name
		if(source_frame.arms)
			source_frame.arms.forceMove(src)
			arms = source_frame.arms
		if(source_frame.legs)
			source_frame.legs.forceMove(src)
			legs = source_frame.legs
		if(source_frame.head)
			source_frame.head.forceMove(src)
			head = source_frame.head
		if(source_frame.body)
			source_frame.body.forceMove(src)
			body = source_frame.body
		if(source_frame.material) material = source_frame.material

	updatehealth()

	// Generate hardpoint list.
	var/list/component_descriptions
	for(var/obj/item/mech_component/comp in list(arms, legs, head, body))
		if(comp.exosuit_desc_string)
			LAZYADD(component_descriptions, comp.exosuit_desc_string)
		if(LAZYLEN(comp.has_hardpoints))
			for(var/hardpoint in comp.has_hardpoints)
				hardpoints[hardpoint] = null

	if(head && head.radio)
		radio = new(src)

	if(body)
		opacity = body.opaque_chassis

	if(LAZYLEN(component_descriptions))
		desc = "[desc] It has been built with [english_list(component_descriptions)]."

	// Create HUD.
	create_HUD()
	update_icon()

/mob/living/exosuit/Destroy()

	selected_system = null

	for(var/mob/living/Pilot in pilots)
		eject(Pilot, TRUE, TRUE)

	pilots = null
	var/obj/item/mech_equipment/forklifting_system/lifter = locate() in contents
	QDEL_NULL(lifter)

	for(var/thing in HUDneed)
		qdel(HUDneed[thing])
	HUDneed.Cut()

	for(var/hardpoint in hardpoints)
		qdel(hardpoints[hardpoint])
	hardpoints.Cut()

	QDEL_NULL(access_card)
	QDEL_NULL(arms)
	QDEL_NULL(legs)
	QDEL_NULL(head)
	QDEL_NULL(body)

	destroy_HUD()

	. = ..()

/mob/living/exosuit/IsAdvancedToolUser()
	return TRUE

/mob/living/exosuit/examine(mob/user, extra_description = "")
	if(LAZYLEN(pilots) && (!hatch_closed || body.pilot_coverage < 100 || body.transparent_cabin || (body && !body.has_hatch)))
		extra_description += "\nIt is being piloted by [english_list(pilots, nothing_text = "nobody")]."
	if(body && LAZYLEN(body.pilot_positions))
		extra_description += "\nIt can seat [body.pilot_positions.len] pilot\s total."
	if(hardpoints.len)
		extra_description += "\nIt has the following hardpoints:"
		for(var/hardpoint in hardpoints)
			var/obj/item/I = hardpoints[hardpoint]
			extra_description += "\n- [hardpoint]: [istype(I) ? "[I]" : "nothing"]."
	else
		extra_description += "\nIt has no visible hardpoints."

	for(var/obj/item/mech_component/thing in list(arms, legs, head, body))
		if(!thing)
			continue
		var/damage_string = thing.get_damage_string()
		extra_description += "\nIts [thing.name] [thing.gender == PLURAL ? "are" : "is"] [damage_string]."
	extra_description += "\nIt menaces with reinforcements of [material]."
	extra_description += SPAN_NOTICE("\nYou can remove people inside by HARM intent clicking with your hand. The hatch must be opened.")
	extra_description += SPAN_NOTICE("\nYou can eject any module from its UI by CtrlClicking the hardpoint button.")
	extra_description += SPAN_NOTICE("\nA multitool can be used on HELP intent to remove module from hardpoints, or on any other intent to start unlocking the mech through hacking.")
	if(body.storage_compartment)
		extra_description += SPAN_NOTICE("\nYou can acces its internal storage by click-dragging onto your character.")
	if(body && body.cell_charge_rate)
		extra_description += SPAN_NOTICE("\nThis mech can recharge any cell storaged in its internal storage at a rate of [body.cell_charge_rate].")
	if(arms && arms.can_force_doors)
		extra_description += SPAN_NOTICE("\nThe arms on this mech can force open any unbolted door.")
	if(locate(/obj/item/mech_equipment/mounted_system/ballistic) in contents)
		extra_description += SPAN_NOTICE("\nYou can insert ammo into any ballistic weapon by attacking this with ammunition.")
	if(locate(/obj/item/mech_equipment/auto_mender) in contents)
		extra_description += SPAN_NOTICE("\nYou can refill its auto mender by attacking the mech with trauma kits.")
	if(locate(/obj/item/mech_equipment/forklifting_system) in contents)
		extra_description += SPAN_NOTICE("\nYou can remove objects from this mech's forklifting system by using grab intent.")
	if(locate(/obj/item/mech_equipment/towing_hook) in contents)
		extra_description += SPAN_NOTICE("\nYou can remove objects from this mech's towing system by using grab intent.")
	if(locate(/obj/item/mech_equipment/power_generator/fueled) in contents)
		extra_description += SPAN_NOTICE("\nYou can refill the mounted power generators by attacking \the [src] with the fuel they use.")
	if(locate(/obj/item/mech_equipment/power_generator/fueled/welding) in contents)
		extra_description += SPAN_NOTICE("\nYou can drain from the mounted fuel welding fuel generator by attacking with a beaker on GRAB intent")
	..(user, extra_description)

/mob/living/exosuit/return_air()
	if(src && loc)
		if(ispath(body) || !hatch_closed || (body && !body.has_hatch) || body.pilot_coverage < 100)
			var/turf/current_loc = get_turf(src)
			return current_loc.return_air()
		if(body.pilot_coverage >= 100 && hatch_closed)
			return body.cockpit


/mob/living/exosuit/GetIdCard()
	return access_card

/mob/living/exosuit/proc/return_temperature()
	return bodytemperature

/mob/living/exosuit/get_mob()
	if(length(pilots))
		return pick(pilots)
