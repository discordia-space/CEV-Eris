//light exosuit components use reinforced plastics to be weaker, but faster than other components. Meant for utility use rather than combat.
/mob/living/exosuit/premade/light
	name = "light exosuit"
	desc = "A light and agile exosuit."

	rarity_value = 10

	material = MATERIAL_PLASTIC
	exosuit_color = COLOR_OFF_WHITE
	arms = /obj/item/mech_component/manipulators/light
	legs = /obj/item/mech_component/propulsion/light
	head = /obj/item/mech_component/sensors/light
	body = /obj/item/mech_component/chassis/light
	installed_software_boards = list(
		/obj/item/electronics/circuitboard/exosystem/utility,
		/obj/item/electronics/circuitboard/exosystem/medical
	)
	installed_systems = list(
		HARDPOINT_LEFT_HAND = /obj/item/mech_equipment/catapult,
		HARDPOINT_BACK = /obj/item/mech_equipment/sleeper,
		HARDPOINT_HEAD = /obj/item/mech_equipment/light,
	)
