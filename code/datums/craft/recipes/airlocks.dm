/datum/craft_recipe/airlock
	category = "Airlocks"
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF
	time = 150
	steps = list(
		list(CRAFT_MATERIAL, 10,69ATERIAL_STEEL),
	)
	related_stats = list(STAT_MEC)

/datum/craft_recipe/airlock/assembly
	name = "standard airlock assembly"
	result = /obj/structure/door_assembly

/datum/craft_recipe/airlock/assembly/command
	name = "command airlock assembly"
	result = /obj/structure/door_assembly/door_assembly_com


/datum/craft_recipe/airlock/assembly/security
	name = "security airlock assembly"
	result = /obj/structure/door_assembly/door_assembly_sec


/datum/craft_recipe/airlock/assembly/engineering
	name = "engineering airlock assembly"
	result = /obj/structure/door_assembly/door_assembly_eng


/datum/craft_recipe/airlock/assembly/mining
	name = "mining airlock assembly"
	result = /obj/structure/door_assembly/door_assembly_min


/datum/craft_recipe/airlock/assembly/atmospherics
	name = "atmospherics airlock assembly"
	result = /obj/structure/door_assembly/door_assembly_atmo


/datum/craft_recipe/airlock/assembly/research
	name = "research airlock assembly"
	result = /obj/structure/door_assembly/door_assembly_research


/datum/craft_recipe/airlock/assembly/medical
	name = "medical airlock assembly"
	result = /obj/structure/door_assembly/door_assembly_med


/datum/craft_recipe/airlock/assembly/maintenance
	name = "maintenance airlock assembly"
	result = /obj/structure/door_assembly/door_assembly_mai


/datum/craft_recipe/airlock/assembly/external
	name = "external airlock assembly"
	result = /obj/structure/door_assembly/door_assembly_ext


/datum/craft_recipe/airlock/assembly/freezer
	name = "freezer airlock assembly"
	result = /obj/structure/door_assembly/door_assembly_fre


/datum/craft_recipe/airlock/hatch/airtight
	name = "airtight hatch assembly"
	result = /obj/structure/door_assembly/door_assembly_hatch

/datum/craft_recipe/airlock/hatch/maintenance
	name = "maintenance hatch assembly"
	result = /obj/structure/door_assembly/door_assembly_mhatch

/datum/craft_recipe/airlock/assembly/high_security
	name = "high security airlock assembly"
	result = /obj/structure/door_assembly/door_assembly_highsecurity
	steps = list(
		list(CRAFT_MATERIAL, 10,69ATERIAL_PLASTEEL)
	)


/datum/craft_recipe/airlock/shutter/emergency_shutter
	name = "emergency shutter"
	result = /obj/structure/firedoor_assembly

/datum/craft_recipe/airlock/assembly/multitile
	name = "multi-tile airlock assembly"
	result = /obj/structure/door_assembly/multi_tile
	steps = list(
		list(CRAFT_MATERIAL, 20,69ATERIAL_STEEL),
	)

