//TOOLS
/datum/design/research/item/exosuit/hydraulic_clamp
	name = "hydraulic clamp"
	id = "hydraulic_clamp"
	build_path = /obj/item/mech_equipment/clamp

/datum/design/research/item/exosuit/drill
	name = "drill"
	id = "mech_drill"
	build_path = /obj/item/mech_equipment/drill

//MISC
/datum/design/research/item/exosuit/floodlight
	name = "floodlight"
	id = "mech_floodlight"
	build_path = /obj/item/mech_equipment/light

/datum/design/research/item/exosuit/sleeper
	name = "mounted sleeper"
	id   = "mech_sleeper"
	build_path = /obj/item/mech_equipment/sleeper

/datum/design/research/item/exosuit/extinguisher
	name = "mounted extinguisher"
	id   = "mech_extinguisher"
	build_path = /obj/item/mech_equipment/mounted_system/extinguisher

//WEAPON
/datum/design/research/item/exosuit/taser
	name = "mounted taser"
	id = "mech_taser"
	build_path = /obj/item/mech_equipment/mounted_system/taser

/datum/design/research/item/exosuit/weapon/plasma
	name = "mounted plasma cutter"
	id = "mech_plasma"
	materials = list(MATERIAL_STEEL = 20000)
	build_path = /obj/item/mech_equipment/mounted_system/taser/plasma

/datum/design/research/item/exosuit/weapon/ion
	name = "mounted ion rifle"
	id = "mech_ion"
	build_path = /obj/item/mech_equipment/mounted_system/taser/ion

/datum/design/research/item/exosuit/weapon/laser
	name = "mounted laser gun"
	id = "mech_laser"
	build_path = /obj/item/mech_equipment/mounted_system/taser/laser

//SPECIAL
/datum/design/research/item/exosuit/gravity_catapult
	name = "gravity catapult"
	id = "gravity_catapult"
	build_path = /obj/item/mech_equipment/catapult

/datum/design/research/item/exosuit/rcd
	name = "RCD"
	id = "mech_rcd"
	time = 90
	materials = list(MATERIAL_STEEL = 30, MATERIAL_PLASMA = 25, MATERIAL_GOLD = 15)
	build_path = /obj/item/mech_equipment/mounted_system/rcd
