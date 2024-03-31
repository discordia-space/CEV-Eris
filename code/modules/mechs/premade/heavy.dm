//heavy exosuit components use plasteel and uranium plating for ultra-durable parts, but have diminished speed and functionality as a result.
/mob/living/exosuit/premade/heavy
	name = "heavy exosuit"
	desc = "A heavily armored combat exosuit."

	material = MATERIAL_PLASTEEL
	exosuit_color = COLOR_TITANIUM
	arms = /obj/item/mech_component/manipulators/heavy
	legs = /obj/item/mech_component/propulsion/heavy
	head = /obj/item/mech_component/sensors/heavy
	body = /obj/item/mech_component/chassis/heavy
	installed_software_boards = list(
		/obj/item/electronics/circuitboard/exosystem/weapons
	)
	installed_systems = list(
		HARDPOINT_LEFT_HAND = /obj/item/mech_equipment/mounted_system/taser,
		HARDPOINT_RIGHT_HAND = /obj/item/mech_equipment/mounted_system/taser/ion,
		HARDPOINT_HEAD = /obj/item/mech_equipment/light
	)
