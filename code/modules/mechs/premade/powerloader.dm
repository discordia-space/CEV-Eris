/mob/living/exosuit/premade/powerloader
	name = "power loader"
	desc = "An ancient, but well-liked cargo handling exosuit."

	material = MATERIAL_STEEL
	exosuit_color = "#ffbc37"
	installed_software = list(
		MECH_SOFTWARE_UTILITY,
		MECH_SOFTWARE_ENGINEERING
	)
	installed_systems = list(
		HARDPOINT_LEFT_HAND = /obj/item/mech_equipment/drill,
		HARDPOINT_RIGHT_HAND = /obj/item/mech_equipment/clamp,
		HARDPOINT_HEAD = /obj/item/mech_equipment/light,
	)

/mob/living/exosuit/premade/powerloader/Initialize()
	if(!arms)
		arms = new /obj/item/mech_component/manipulators/powerloader(src)
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/powerloader(src)
	if(!head)
		head = new /obj/item/mech_component/sensors/powerloader(src)
	if(!body)
		body = new /obj/item/mech_component/chassis/powerloader(src)

	. = ..()


/obj/item/mech_component/manipulators/powerloader
	name = "exosuit arms"
	exosuit_desc_string = "heavy-duty industrial lifters"
	max_damage = 70
	power_use = 30
	desc = "The Xion Industrial Digital Interaction Manifolds allow you poke untold dangers from the relative safety of your cockpit."

/obj/item/mech_component/propulsion/powerloader
	name = "exosuit legs"
	exosuit_desc_string = "reinforced hydraulic legs"
	desc = "Wide and stable but not particularly fast."
	max_damage = 70
	move_delay = 4
	power_use = 10

/obj/item/mech_component/sensors/powerloader
	name = "exosuit sensors"
	gender = PLURAL
	exosuit_desc_string = "simple collision detection sensors"
	desc = "A primitive set of sensors designed to work in tandem with most MKI Eyeball platforms."
	max_damage = 100
	power_use = 0

/obj/item/mech_component/chassis/powerloader
	name = "open exosuit chassis"
	hatch_descriptor = "roll cage"
	pilot_coverage = 40
	exosuit_desc_string = "an industrial rollcage"
	desc = "A Xion industrial brand roll cage. Technically OSHA compliant. Technically."
	max_damage = 100
	power_use = 0

/obj/item/mech_component/chassis/powerloader/Initialize()
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

/mob/living/exosuit/premade/powerloader/flames_red
	name = "APLU \"Firestarter\""
	desc = "An ancient, but well-liked cargo handling exosuit. This one has cool red flames."
	decal = "flames_red"

/mob/living/exosuit/premade/powerloader/flames_blue
	name = "APLU \"Burning Chrome\""
	desc = "An ancient, but well-liked cargo handling exosuit. This one has cool blue flames."
	decal = "flames_blue"


/mob/living/exosuit/premade/powerloader/firefighter
	name = "firefighting exosuit"
	desc = "A mix and match of industrial parts designed to withstand fires."

	exosuit_color = "#385b3c"
	installed_systems = list(
		HARDPOINT_LEFT_HAND = /obj/item/mech_equipment/drill,
		HARDPOINT_RIGHT_HAND = /obj/item/mech_equipment/mounted_system/extinguisher,
		HARDPOINT_HEAD = /obj/item/mech_equipment/light,
	)
