/mob/living/exosuit/premade/heavy
	name = "heavy exosuit"
	desc = "A heavily armored combat exosuit."

	material = MATERIAL_PLASTEEL
	exosuit_color = COLOR_TITANIUM
	installed_armor = /obj/item/robot_parts/robot_component/armour/exosuit/combat
	installed_software_boards = list(
		/obj/item/weapon/circuitboard/exosystem/weapons,
		/obj/item/weapon/circuitboard/exosystem/advweapons
	)
	installed_systems = list(
		HARDPOINT_LEFT_HAND = /obj/item/mech_equipment/mounted_system/taser,
		HARDPOINT_RIGHT_HAND = /obj/item/mech_equipment/mounted_system/taser/ion,
		HARDPOINT_HEAD = /obj/item/mech_equipment/light,
	)

/mob/living/exosuit/premade/heavy/Initialize()
	if(!arms)
		arms = new /obj/item/mech_component/manipulators/heavy(src)
	if(!legs)
		legs = new /obj/item/mech_component/propulsion/heavy(src)
	if(!head)
		head = new /obj/item/mech_component/sensors/heavy(src)
	if(!body)
		body = new /obj/item/mech_component/chassis/heavy(src)

	. = ..()


/obj/item/mech_component/sensors/heavy
	name = "heavy sensors"
	exosuit_desc_string = "a reinforced monoeye"
	desc = "A solitary sensor moves inside a recessed slit in the armour plates."
	icon_state = "heavy_head"
	max_damage = 120
	power_use = 0
	matter = list(MATERIAL_STEEL = 16)

/obj/item/mech_component/chassis/heavy
	name = "reinforced exosuit chassis"
	hatch_descriptor = "hatch"
	desc = "The HI-Koloss chassis is a veritable juggernaut, capable of protecting a pilot even in the most hostile of environments. It handles like a battlecruiser, however."
	pilot_coverage = 100
	exosuit_desc_string = "a heavily armoured chassis"
	icon_state = "heavy_body"
	max_damage = 150
	mech_health = 500
	power_use = 50
	has_hardpoints = list(HARDPOINT_BACK)
	matter = list(MATERIAL_STEEL = 70, MATERIAL_URANIUM = 10)

/obj/item/mech_component/manipulators/heavy
	name = "combat arms"
	exosuit_desc_string = "super-heavy reinforced manipulators"
	icon_state = "heavy_arms"
	desc = "Designed to function where any other piece of equipment would have long fallen apart, the Hephaestus Superheavy Lifter series can take a beating and excel at delivering it."
	melee_damage = 25
	action_delay = 15
	max_damage = 90
	power_use = 60
	matter = list(MATERIAL_STEEL = 20)

/obj/item/mech_component/propulsion/heavy
	name = "heavy legs"
	exosuit_desc_string = "heavy legs"
	desc = "Exosuit actuators struggle to move these armored legs."
	icon_state = "heavy_legs"
	move_delay = 5
	max_damage = 90
	power_use = 100
	matter = list(MATERIAL_STEEL = 20)
