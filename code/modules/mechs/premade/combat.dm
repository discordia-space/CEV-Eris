//combat exosuit components use plasteel reinforcement for more durability than most exosuits, and gold for thermal sensors
/mob/living/exosuit/premade/combat
	name = "combat exosuit"
	desc = "A sleek, modern combat exosuit."

	rarity_value = 60

	arms = /obj/item/mech_component/manipulators/combat
	legs = /obj/item/mech_component/propulsion/combat
	head = /obj/item/mech_component/sensors/combat
	body = /obj/item/mech_component/chassis/combat

	material = MATERIAL_PLASTEEL
	exosuit_color = COLOR_GUNMETAL
	installed_software_boards = list(
		/obj/item/electronics/circuitboard/exosystem/weapons
	)
	installed_systems = list(
		HARDPOINT_LEFT_HAND = /obj/item/mech_equipment/mounted_system/taser,
		HARDPOINT_RIGHT_HAND = /obj/item/mech_equipment/mounted_system/taser/ion,
		HARDPOINT_HEAD = /obj/item/mech_equipment/light
	)


/mob/living/exosuit/premade/combat/slayer
	name = "S.C.U. 'Slayer'" //Space Combat Unit
	desc = "A sleek, modern combat exosuit. It has two red stripes on it's chassis."

	exosuit_color = "#5a6934"
	decal = "stripes"
	installed_systems = list(
		HARDPOINT_LEFT_HAND = /obj/item/mech_equipment/mounted_system/taser/laser,
		HARDPOINT_RIGHT_HAND = /obj/item/mech_equipment/mounted_system/taser/ion,
		HARDPOINT_HEAD = /obj/item/mech_equipment/light
	)
