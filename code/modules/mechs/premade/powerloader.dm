/mob/living/exosuit/premade/powerloader
	name = "APLU \"Ripley\""
	desc = "An old but well-liked utility exosuit. Once manufactured by Nanotrasen, this design was made omnipresent by data leaks that followed the Fall."

	material = MATERIAL_STEEL
	exosuit_color = "#ffbc37"
	installed_software_boards = list(
		/obj/item/weapon/circuitboard/exosystem/utility,
		/obj/item/weapon/circuitboard/exosystem/engineering
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
	name = "lifter exosuit arms"
	exosuit_desc_string = "industrial lifter arms"
	max_damage = 70
	power_use = 30
	desc = "Reinforced lifter arms that allow you to poke untold dangers from the relative safety of your cockpit."

/obj/item/mech_component/propulsion/powerloader
	name = "lifter exosuit legs"
	exosuit_desc_string = "reinforced lifter legs"
	desc = "Wide and stable, but not particularly fast."
	max_damage = 70
	move_delay = 4
	power_use = 10

/obj/item/mech_component/sensors/powerloader
	name = "simple exosuit sensors"
	gender = PLURAL
	exosuit_desc_string = "simple sensors"
	desc = "A primitive set of sensors designed to work in tandem with most MKI Eyeball platforms."
	max_damage = 100
	power_use = 0

/obj/item/mech_component/chassis/powerloader
	name = "open exosuit chassis"
	hatch_descriptor = "roll cage"
	pilot_coverage = 40
	exosuit_desc_string = "an industrial roll cage"
	desc = "An industrial roll cage. Technically compliant with Nanotrasen era safety regulations."
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
	desc = "An old but well-liked utility exosuit. This one has cool red flames."
	decal = "flames_red"

/mob/living/exosuit/premade/powerloader/flames_blue
	name = "APLU \"Burning Chrome\""
	desc = "An old but well-liked utility exosuit. This one has cool blue flames."
	decal = "flames_blue"


/mob/living/exosuit/premade/powerloader/firefighter
	name = "APLU \"Firefighter\""
	desc = "A mix and match of industrial parts designed to withstand heavy fires."

	material = MATERIAL_PLASTEEL // Reinforced with plasteel to fireproof the chassis
	exosuit_color = "#819a73"
	installed_systems = list(
		HARDPOINT_LEFT_HAND = /obj/item/mech_equipment/drill,
		HARDPOINT_RIGHT_HAND = /obj/item/mech_equipment/mounted_system/extinguisher,
		HARDPOINT_HEAD = /obj/item/mech_equipment/light,
	)

/mob/living/exosuit/premade/powerloader/firefighter/Initialize()
	if(!body)
		body = new /obj/item/mech_component/chassis/heavy(src) // Sealed chassis to protect the pilot from fire

	. = ..()
