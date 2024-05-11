/obj/item/mech_component/sensors
	name = "exosuit head"
	icon_state = "loader_head"
	gender = NEUTER

	has_hardpoints = list(HARDPOINT_HEAD)
	power_use = 15
	matter = list(MATERIAL_STEEL = 5, MATERIAL_GLASS = 4)
	can_gib = TRUE
	gib_hits_needed = 5
	var/vision_flags = NONE
	var/see_invisible = 0
	var/active_sensors = FALSE

	var/obj/item/robot_parts/robot_component/radio/radio
	var/obj/item/robot_parts/robot_component/camera/camera

/obj/item/mech_component/sensors/Destroy()
	QDEL_NULL(camera)
	QDEL_NULL(radio)
	. = ..()

/obj/item/mech_component/sensors/show_missing_parts(var/mob/user)
	if(!radio)
		to_chat(user, SPAN_WARNING("It is missing a radio."))
	if(!camera)
		to_chat(user, SPAN_WARNING("It is missing a camera."))

/obj/item/mech_component/sensors/prebuild()
	radio = new(src)
	camera = new(src)

/obj/item/mech_component/sensors/update_components()
	radio = locate() in src
	camera = locate() in src

/obj/item/mech_component/sensors/proc/get_sight(powered)
	var/flags = 0
	var/mob/living/exosuit/mech = loc
	if(total_damage >= 0.8 * max_damage || (!powered && mech.hatch_closed && (mech.body && mech.body.has_hatch)))
		flags |= BLIND
	else if(active_sensors)
		flags |= vision_flags

	return flags

/obj/item/mech_component/sensors/proc/get_invisible(powered)
	var/invisible = 0
	if((total_damage <= 0.8 * max_damage) && active_sensors && powered)
		invisible = see_invisible
	return invisible


/obj/item/mech_component/sensors/ready_to_install()
	return (radio && camera)

/obj/item/mech_component/sensors/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/robot_parts/robot_component/radio))
		if(radio)
			to_chat(user, SPAN_WARNING("\The [src] already has a radio installed."))
			return
		if(insert_item(I, user))
			radio = I
	else if(istype(I, /obj/item/robot_parts/robot_component/camera))
		if(camera)
			to_chat(user, SPAN_WARNING("\The [src] already has a camera installed."))
			return
		if(insert_item(I, user))
			camera = I
	else
		return ..()

/obj/item/mech_component/sensors/return_diagnostics(mob/user)
	..()
	if(radio)
		to_chat(user, SPAN_NOTICE(" Radio Integrity: <b>[round((((radio.max_dam - radio.total_dam) / radio.max_dam)) * 100)]%</b>"))
	else
		to_chat(user, SPAN_WARNING(" Radio Missing or Non-functional."))
	if(camera)
		to_chat(user, SPAN_NOTICE(" Camera Integrity: <b>[round((((camera.max_dam - camera.total_dam) / camera.max_dam)) * 100)]%</b>"))
	else
		to_chat(user, SPAN_WARNING(" Camera Missing or Non-functional."))

/obj/item/mech_component/sensors/cheap
	name = "simple exosuit sensors"
	gender = PLURAL
	exosuit_desc_string = "simple sensors"
	desc = "A primitive set of sensors designed to provide basic visual information to the pilot."
	max_damage = 125
	power_use = 0
	armor = list(melee = 20, bullet = 10, energy = 5, bomb = 60, bio = 100, rad = 0)
	shielding = 5

/obj/item/mech_component/sensors/light
	name = "light sensors"
	gender = PLURAL
	exosuit_desc_string = "advanced sensor array"
	desc = "A series of high resolution optical sensors. They can overlay several images to give the pilot a sense of location even in total darkness."
	icon_state = "light_head"
	max_damage = 75
	vision_flags = SEE_TURFS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	power_use = 50
	emp_shielded = TRUE
	matter = list(MATERIAL_STEEL = 10, MATERIAL_GLASS = 5, MATERIAL_SILVER = 2) //NVG takes uranium, but mecha NVGs are bugged & it's mecha-sized so let's not
	armor = list(melee = 16, bullet = 8, energy = 4, bomb = 40, bio = 100, rad = 100)

	front_mult = 0.5


/obj/item/mech_component/sensors/combat
	name = "combat sensors"
	gender = PLURAL
	exosuit_desc_string = "high-resolution thermal sensors"
	desc = "High resolution thermal combat sensors, designed to locate targets even through cover or smoke."
	icon_state = "combat_head"
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	max_damage = 75 //the sensors are delicate, the value of this part is in the SEE_MOBS flag anyway
	power_use = 200
	matter = list(MATERIAL_STEEL = 10, MATERIAL_GLASS = 6, MATERIAL_GOLD = 8, MATERIAL_SILVER = 8, MATERIAL_URANIUM = 8)
	armor = list(melee = 26, bullet = 22, energy = 16, bomb = 100, bio = 100, rad = 100)
	shielding = 10

	front_mult = 0.75

/obj/item/mech_component/sensors/heavy
	name = "heavy sensors"
	exosuit_desc_string = "a reinforced monoeye"
	desc = "A solitary sensor moves inside a recessed slit in the armour plates."
	icon_state = "heavy_head"
	max_damage = 200
	power_use = 0
	matter = list(MATERIAL_STEEL = 20, MATERIAL_PLASTEEL = 8, MATERIAL_URANIUM = 6)
	armor = list(melee = 32, bullet = 24, energy = 20, bomb = 160, bio = 100, rad = 100)
	shielding = 15
