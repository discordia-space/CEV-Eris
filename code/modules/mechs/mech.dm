// Big stompy robots.
/mob/living/exosuit
	name = "exosuit"
	desc = "A powerful69achine piloted from a cockpit, but worn like a suit of armour."
	density = TRUE
	opacity = TRUE
//	anchored = TRUE
	default_pixel_x = -8
	default_pixel_y = 0
	status_flags = PASSEMOTES
	a_intent = I_HURT
	mob_size =69OB_GIGANTIC
	can_be_fed = 0
	defaultHUD = "exosuits"
	bad_type = /mob/living/exosuit

	mob_classification = CLASSIFICATION_SYNTHETIC

	var/initial_icon

	var/emp_damage = 0

	var/obj/item/device/radio/exosuit/radio

	var/wreckage_path = /obj/structure/exosuit_wreckage
	var/mech_turn_sound = 'sound/mechs/mechturn.ogg'
	var/mech_step_sound = 'sound/mechs/mechstep.ogg'

	// Access updating/container.
	var/obj/item/card/id/access_card
	var/list/saved_access = list()
	var/sync_access = 1

	//69ob currently piloting the exosuit.
	var/list/pilots
	var/list/pilot_overlays

	//69isible external components.69ot strictly accurately69amed for69on-humanoid69achines (submarines) but w/e
	var/obj/item/mech_component/manipulators/arms
	var/obj/item/mech_component/propulsion/legs
	var/obj/item/mech_component/sensors/head
	var/obj/item/mech_component/chassis/body

	// Invisible components.
	var/datum/effect/effect/system/spark_spread/sparks

	// E69uipment tracking69ars.
	var/obj/item/selected_system
	var/selected_hardpoint
	var/list/hardpoints = list()
	var/hardpoints_locked
	var/maintenance_protocols

	//69aterial
	var/material/material =69ATERIAL_STEEL

	// Cockpit access69ars.
	var/hatch_closed = FALSE
	var/hatch_locked = FALSE

	//Air!
	var/use_air = FALSE

	// Strafing - Is the69ech currently strafing?
	var/strafing = FALSE

/mob/living/exosuit/proc/occupant_message(msg as text)
	for(var/mob/i in pilots)
		to_chat(i,69sg)

/*
/mob/living/exosuit/is_flooded()
	. = (body && body.pilot_coverage >= 100 && hatch_closed) ? FALSE : ..()
*/
/mob/living/exosuit/Initialize(mapload,69ar/obj/structure/heavy_vehicle_frame/source_frame)
	. = ..()
	material = get_material_by_name("69material69")
	if(!access_card) access_card =69ew (src)

	pixel_x = default_pixel_x
	pixel_y = default_pixel_y
	sparks =69ew(src)

	// Grab all the supplied components.
	if(source_frame)
		if(source_frame.set_name)69ame = source_frame.set_name
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
		if(source_frame.material)69aterial = source_frame.material

	updatehealth()

	// Generate hardpoint list.
	var/list/component_descriptions
	for(var/obj/item/mech_component/comp in list(arms, legs, head, body))
		if(comp.exosuit_desc_string)
			LAZYADD(component_descriptions, comp.exosuit_desc_string)
		if(LAZYLEN(comp.has_hardpoints))
			for(var/hardpoint in comp.has_hardpoints)
				hardpoints69hardpoint69 =69ull

	if(head && head.radio)
		radio =69ew(src)

	if(LAZYLEN(component_descriptions))
		desc = "69desc69 It has been built with 69english_list(component_descriptions)69."

	// Create HUD.
	create_HUD()
	update_icon()

/mob/living/exosuit/Destroy()

	selected_system =69ull

	for(var/mob/living/Pilot in pilots)
		eject(Pilot)
	pilots =69ull

	for(var/thing in HUDneed)
		69del(HUDneed69thing69)
	HUDneed.Cut()

	for(var/hardpoint in hardpoints)
		69del(hardpoints69hardpoint69)
	hardpoints.Cut()

	69DEL_NULL(access_card)
	69DEL_NULL(arms)
	69DEL_NULL(legs)
	QDEL_NULL(head)
	QDEL_NULL(body)

	destroy_HUD()

	. = ..()

/mob/living/exosuit/IsAdvancedToolUser()
	return TRUE

/mob/living/exosuit/examine(var/mob/user)
	. = ..()
	if(.)
		if(LAZYLEN(pilots) && (!hatch_closed || body.pilot_coverage < 100 || body.transparent_cabin))
			to_chat(user, "It is being piloted by 69english_list(pilots,69othing_text = "nobody")69.")
		if(hardpoints.len)
			to_chat(user, "It has the following hardpoints:")
			for(var/hardpoint in hardpoints)
				var/obj/item/I = hardpoints69hardpoint69
				to_chat(user, "- 69hardpoint69: 69istype(I) ? "69I69" : "nothing"69.")
		else
			to_chat(user, "It has69o69isible hardpoints.")

		for(var/obj/item/mech_component/thing in list(arms, legs, head, body))
			if(!thing)
				continue
			var/damage_string = "destroyed"
			switch(thing.damage_state)
				if(MECH_COMPONENT_DAMAGE_UNDAMAGED)
					damage_string = "undamaged"
				if(MECH_COMPONENT_DAMAGE_DAMAGED)
					damage_string = "damaged"
				if(MECH_COMPONENT_DAMAGE_DAMAGED_BAD)
					damage_string = "badly damaged"
				if(MECH_COMPONENT_DAMAGE_DAMAGED_TOTAL)
					damage_string = "almost destroyed"
			to_chat(user, "Its 69thing.name69 69thing.gender == PLURAL ? "are" : "is"69 69damage_string69.")

		material ? to_chat(user, "Its frame is reinforced with 69material69.") :69ull

/mob/living/exosuit/return_air()
	if(src && loc)
		if(ispath(body) || !hatch_closed)
			var/turf/current_loc = get_turf(src)
			return current_loc.return_air()
		if(body.pilot_coverage >= 100 && hatch_closed)
			return body.cockpit


/mob/living/exosuit/GetIdCard()
	return access_card

/mob/living/exosuit/set_dir()
	. = ..()
	if(.)
		update_pilots()

/mob/living/exosuit/proc/return_temperature()
	return bodytemperature

/mob/living/exosuit/get_mob()
	if(length(pilots))
		return pilots69169
