/datum/design/research/item/mechfab/exosuit/control_module
	name = "exosuit control module"
	build_path = /obj/item/mech_component/control_module
	materials = list(MATERIAL_STEEL = 5)

/datum/design/research/item/mechfab/exosuit/basics
	starts_unlocked = TRUE

/datum/design/research/item/mechfab/exosuit/basics/frame
	name = "exosuit frame"
	build_path = /obj/structure/heavy_vehicle_frame
	time = 70

/datum/design/research/item/mechfab/exosuit/basics/head
	name = "exosuit head"
	build_path = /obj/item/mech_component/sensors
	time = 70

/datum/design/research/item/mechfab/exosuit/basics/chassis
	name = "exosuit chassis"
	build_path = /obj/item/mech_component/chassis
	time = 70

/datum/design/research/item/mechfab/exosuit/basics/arms
	name = "exosuit arms"
	build_path = /obj/item/mech_component/manipulators
	time = 70

/datum/design/research/item/mechfab/exosuit/basics/legs
	name = "exosuit legs"
	build_path = /obj/item/mech_component/propulsion
	time = 70


//ARMOR
/datum/design/research/item/mechfab/exosuit/armour
	time = 50

/datum/design/research/item/mechfab/exosuit/armour/basic
	name = "basic exosuit armour"
	build_path = /obj/item/robot_parts/robot_component/armour/exosuit
	time = 30

/datum/design/research/item/mechfab/exosuit/armour/radproof
	name = "radiation-proof exosuit armour"
	build_path = /obj/item/robot_parts/robot_component/armour/exosuit/radproof

/datum/design/research/item/mechfab/exosuit/armour/em
	name = "EM-shielded exosuit armour"
	build_path = /obj/item/robot_parts/robot_component/armour/exosuit/em

/datum/design/research/item/mechfab/exosuit/armour/combat
	name = "combat exosuit armour"
	build_path = /obj/item/robot_parts/robot_component/armour/exosuit/combat


//POWERLOADER
/datum/design/research/item/mechfab/exosuit/powerloader
	category = "PowerLoader"
	starts_unlocked = TRUE

/datum/design/research/item/mechfab/exosuit/powerloader/head
	name = "powerloader sensors (head)"
	build_path = /obj/item/mech_component/sensors/powerloader
	time = 15

/datum/design/research/item/mechfab/exosuit/powerloader/torso
	name = "powerloader chassis"
	build_path = /obj/item/mech_component/chassis/powerloader
	time = 50

/datum/design/research/item/mechfab/exosuit/powerloader/arms
	name = "powerloader manipulators"
	build_path = /obj/item/mech_component/manipulators/powerloader
	time = 30

/datum/design/research/item/mechfab/exosuit/powerloader/legs
	name = "powerloader motivators"
	build_path = /obj/item/mech_component/propulsion/powerloader
	time = 30


//LIGHT
/datum/design/research/item/mechfab/exosuit/light/category = "Light Exosuit"
/datum/design/research/item/mechfab/exosuit/light/head
	name = "light exosuit sensors"
	time = 20
	build_path = /obj/item/mech_component/sensors/light

/datum/design/research/item/mechfab/exosuit/light/torso
	name = "light exosuit chassis"
	time = 40
	build_path = /obj/item/mech_component/chassis/light

/datum/design/research/item/mechfab/exosuit/light/arms
	name = "light exosuit manipulators"
	time = 20
	build_path = /obj/item/mech_component/manipulators/light

/datum/design/research/item/mechfab/exosuit/light/legs
	name = "light exosuit motivators"
	time = 25
	build_path = /obj/item/mech_component/propulsion/light


//HEAVY
/datum/design/research/item/mechfab/exosuit/heavy/category = "Heavy Exosuit"
/datum/design/research/item/mechfab/exosuit/heavy/head
	name = "heavy exosuit sensors"
	time = 35
	build_path = /obj/item/mech_component/sensors/heavy

/datum/design/research/item/mechfab/exosuit/heavy/torso
	name = "heavy exosuit chassis"
	time = 75
	build_path = /obj/item/mech_component/chassis/heavy

/datum/design/research/item/mechfab/exosuit/heavy/arms
	name = "heavy exosuit manipulators"
	time = 35
	build_path = /obj/item/mech_component/manipulators/heavy

/datum/design/research/item/mechfab/exosuit/heavy/legs
	name = "heavy exosuit motivators"
	time = 35
	build_path = /obj/item/mech_component/propulsion/heavy


//COMBAT
/datum/design/research/item/mechfab/exosuit/combat/category = "Combat Exosuit"
/datum/design/research/item/mechfab/exosuit/combat/head
	name = "combat exosuit sensors"
	time = 30
	build_path = /obj/item/mech_component/sensors/combat

/datum/design/research/item/mechfab/exosuit/combat/torso
	name = "combat exosuit chassis"
	time = 60
	build_path = /obj/item/mech_component/chassis/combat

/datum/design/research/item/mechfab/exosuit/combat/arms
	name = "combat exosuit manipulators"
	time = 30
	build_path = /obj/item/mech_component/manipulators/combat

/datum/design/research/item/mechfab/exosuit/combat/legs
	name = "combat exosuit motivators"
	time = 30
	build_path = /obj/item/mech_component/propulsion/combat
