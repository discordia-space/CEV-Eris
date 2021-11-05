/obj/machinery/compressor_feeder
	name = "Compressor feeder"
	desc ="A machine that feeds raw atoms to the compressor, using unknown alien technology it breaks down matter."
	icon = 'icons/obj/machines/compressor.dmi'
	icon_state = "compressor_feeder"
	density = TRUE
	use_power = NO_POWER_USE
	var/list/stored_matter = list(
		MATERIAL_DIAMOND = 0,
		MATERIAL_PLASMA = 0,
		MATERIAL_MHYDROGEN = 0
	)
	var/list/stored_limits = list(
		MATERIAL_DIAMOND = 30,
		MATERIAL_PLASMA = 30,
		MATERIAL_MHYDROGEN = 4
	)
	var/list/managed_overlays = list(
		MATERIAL_PLASMA = 0,
		MATERIAL_DIAMOND = 0,
		MATERIAL_MHYDROGEN = 0
	)
	var/tmp/obj/effect/flicker_overlay/image_load_material
	var/using = FALSE // No funny gaming

/obj/machinery/compressor_feeder/Initialize()
	image_load_material = new(src)
	. = ..()

/obj/machinery/compressor_feeder/Destroy()
	QDEL_NULL(image_load_material)
	..()

/obj/machinery/compressor_feeder/AltClick(mob/user)
	if(user.incapacitated(INCAPACITATION_ALL) || isghost(user) || !user.IsAdvancedToolUser())
		return FALSE
	visible_message(SPAN_NOTICE("[user] empties \the [src] of all its stored materials"))
	if(using)
		to_chat(user, SPAN_DANGER("Safety protocols don't allow you to empty the machine while its disintegrating atoms!"))
		return FALSE
	for(var/matter in stored_matter)
		var/actual_count = stored_matter[matter]
		if(!actual_count)
			continue
		var/mat_to_spawn = get_material_by_name(matter)
		var/obj/item/stack/material/materials = new mat_to_spawn(get_turf(src))
		materials.amount = actual_count
		materials.update_icon()
		stored_matter[matter] = 0

/obj/machinery/compressor_feeder/attackby(obj/item/I, mob/living/user)
	if(!istype(I, /obj/item/stack/material))
		to_chat(user, SPAN_NOTICE("\The [src] only accepts pure sheets of diamond , plasma or mettalic hydrogen"))
		return FALSE
	var/obj/item/stack/material/stack_being_fed = I
	var/use_amount = stack_being_fed.amount
	var/material_name = stack_being_fed.material.name
	if(!(material_name in stored_matter))
		to_chat(user, SPAN_NOTICE("\The [src] only accepts sheets of diamond , plasma or metalic hydrogen"))
		return FALSE
	use_amount = clamp(use_amount, 0 , stored_limits[material_name] - stored_matter[material_name])
	if(!use_amount)
		to_chat(user , SPAN_NOTICE("\The [src] is already full on [material_name]"))
		return FALSE
	stack_being_fed.use(use_amount)
	stored_matter[material_name] += use_amount
	image_load_material.color = stack_being_fed.material.icon_colour
	image_load_material.alpha = max(255 * stack_being_fed.material.opacity, 200) // The icons are too transparent otherwise
	FLICK("[initial(icon_state)]_load", image_load_material)
	use_amount = clamp(use_amount, 0 , stored_limits[material_name] - stored_matter[material_name])
	stack_being_fed.use(use_amount)
	stored_matter[material_name] += use_amount
	update_icon()

/obj/machinery/compressor_feeder/update_icon()
	for(var/matter in stored_matter)
		var/matter_amount = stored_matter[matter]
		var/matter_divisor = stored_limits[matter] / 6
		if(matter == MATERIAL_MHYDROGEN)
			matter_divisor = 1 // Only 4 sheets needed
		if(managed_overlays[matter])
			overlays -= managed_overlays[matter]
		managed_overlays[matter] = image('icons/obj/machines/compressor.dmi', src, "[matter]_[matter_amount ? round(matter_amount / matter_divisor) : "0"]", layer + 1 )
		overlays += managed_overlays[matter]
	..()

/obj/machinery/compressor_feeder/proc/can_make_stabilizer()
	. = TRUE
	for(var/matter in stored_matter)
		if(stored_matter[matter] != stored_limits[matter])
			. = FALSE
			break

/obj/machinery/compressor_feeder/proc/empty_matter()
	for(var/matter in stored_matter)
		stored_matter[matter] = 0
	update_icon()

