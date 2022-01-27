//heavy exosuit components use plasteel and uranium plating for ultra-durable parts, but have diminished speed and functionality as a result.
/mob/living/exosuit/premade/heavy
	name = "heavy exosuit"
	desc = "A heavily armored combat exosuit."

	material =69ATERIAL_PLASTEEL
	exosuit_color = COLOR_TITANIUM
	installed_armor = /obj/item/robot_parts/robot_component/armour/exosuit/combat
	arms = /obj/item/mech_component/manipulators/heavy
	legs = /obj/item/mech_component/propulsion/heavy
	head = /obj/item/mech_component/sensors/heavy
	body = /obj/item/mech_component/chassis/heavy
	installed_software_boards = list(
		/obj/item/electronics/circuitboard/exosystem/weapons,
		/obj/item/electronics/circuitboard/exosystem/advweapons
	)
	installed_systems = list(
		HARDPOINT_LEFT_HAND = /obj/item/mech_e69uipment/mounted_system/taser,
		HARDPOINT_RIGHT_HAND = /obj/item/mech_e69uipment/mounted_system/taser/ion,
		HARDPOINT_HEAD = /obj/item/mech_e69uipment/light,
	)


/obj/item/mech_component/sensors/heavy
	name = "heavy sensors"
	exosuit_desc_string = "a reinforced69onoeye"
	desc = "A solitary sensor69oves inside a recessed slit in the armour plates."
	icon_state = "heavy_head"
	max_damage = 150
	power_use = 0
	matter = list(MATERIAL_STEEL = 20,69ATERIAL_GLASS = 2,69ATERIAL_PLASTEEL = 5)

/obj/item/mech_component/chassis/heavy
	name = "reinforced exosuit chassis"
	hatch_descriptor = "hatch"
	desc = "This heavy combat chassis is a69eritable juggernaut, capable of protecting a pilot even in the69ost69iolent of conflicts. It's hell to climb in and out of, however."
	pilot_coverage = 100
	exosuit_desc_string = "a heavily armoured chassis"
	icon_state = "heavy_body"
	max_damage = 200
	mech_health = 600
	power_use = 50
	climb_time = 35 //Takes longer to climb into, but is beefy as HELL.
	matter = list(MATERIAL_STEEL = 50,69ATERIAL_URANIUM = 15,69ATERIAL_PLASTEEL = 15)

/obj/item/mech_component/manipulators/heavy
	name = "heavy arms"
	exosuit_desc_string = "super-heavy reinforced69anipulators"
	icon_state = "heavy_arms"
	desc = "Designed for durability and dishing out beatings, this heavy set of69anipulators can both take and dish out beatings."
	melee_damage = 60 // You know , these things walk like a snail . Why would you even get close to this.
	action_delay = 15
	max_damage = 150
	power_use = 60
	matter = list(MATERIAL_STEEL = 20,69ATERIAL_PLASTEEL = 10,69ATERIAL_URANIUM = 5)

/obj/item/mech_component/propulsion/heavy
	name = "heavy legs"
	exosuit_desc_string = "heavy legs"
	desc = "Exosuit actuators struggle to69ove these armored legs, and they're even worse at turning."
	icon_state = "heavy_legs"
	move_delay = 5
	turn_delay = 2 // Turning should be easy ,69oving69ot.
	max_damage = 200
	power_use = 100
	matter = list(MATERIAL_STEEL = 20,69ATERIAL_URANIUM = 5)
