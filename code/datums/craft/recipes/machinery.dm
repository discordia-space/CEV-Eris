/datum/craft_recipe/machinery
	category = "Machinery"
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF
	time = 120
	related_stats = list(STAT_MEC)

/datum/craft_recipe/machinery/machine_frame
	name = "machine frame"
	result = /obj/machinery/constructable_frame/machine_frame
	steps = list(
		list(CRAFT_MATERIAL, 8,69ATERIAL_STEEL),
	)

/datum/craft_recipe/machinery/vertical_machine_frame
	name = "vertical69achine frame"
	result = /obj/machinery/constructable_frame/machine_frame/vertical
	steps = list(
		list(CRAFT_MATERIAL, 8,69ATERIAL_STEEL),
	)

/datum/craft_recipe/machinery/computer
	related_stats = list(STAT_MEC, STAT_COG)

/datum/craft_recipe/machinery/computer/computer_frame
	name = "computer frame"
	result = /obj/structure/computerframe
	steps = list(
		list(CRAFT_MATERIAL, 5,69ATERIAL_STEEL),
	)

/datum/craft_recipe/machinery/computer/modularconsole
	name = "modular console frame"
	result = /obj/item/modular_computer/console
	time = 200
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF
	steps = list(
		list(CRAFT_MATERIAL, 10,69ATERIAL_STEEL),
		list(CRAFT_MATERIAL, 4,69ATERIAL_GLASS),
	)
	dir_type = CRAFT_TOWARD_USER  // spawn69odular console toward the user

/datum/craft_recipe/machinery/computer/modularlaptop
	name = "modular laptop frame"
	result = /obj/item/modular_computer/laptop
	time = 200
	steps = list(
		list(CRAFT_MATERIAL, 8,69ATERIAL_STEEL),
		list(CRAFT_MATERIAL, 4,69ATERIAL_GLASS),
	)

/datum/craft_recipe/machinery/computer/modulartablet
	name = "modular tablet frame"
	result = /obj/item/modular_computer/tablet
	time = 200
	steps = list(
		list(CRAFT_MATERIAL, 5,69ATERIAL_STEEL),
		list(CRAFT_MATERIAL, 2,69ATERIAL_GLASS),
	)

/datum/craft_recipe/machinery/computer/modularpda
	name = "modular pda frame"
	result = /obj/item/modular_computer/pda
	time = 200
	steps = list(
		list(CRAFT_MATERIAL, 3,69ATERIAL_STEEL),
		list(CRAFT_MATERIAL, 1,69ATERIAL_GLASS),
	)

/datum/craft_recipe/machinery/computer/modulartelescreen
	name = "modular telescreen frame"
	result = /obj/item/modular_computer/telescreen
	time = 200
	steps = list(
		list(CRAFT_MATERIAL, 8,69ATERIAL_STEEL),
		list(CRAFT_MATERIAL, 6,69ATERIAL_GLASS),
	)

/datum/craft_recipe/machinery/turret_frame
	name = "turret frame"
	result = /obj/machinery/porta_turret_construct
	steps = list(
		list(CRAFT_MATERIAL, 10,69ATERIAL_STEEL),
	)

//wall or small you know them req only 2 list
/datum/craft_recipe/machinery/wall
	steps = list(
		list(CRAFT_MATERIAL, 2,69ATERIAL_STEEL),
	)
	flags = null

/datum/craft_recipe/machinery/wall/lightfixture
	name = "light fixture frame"
	result = /obj/item/frame/light

/datum/craft_recipe/machinery/wall/lightfixture/small
	name = "small light fixture frame"
	result = /obj/item/frame/light/small

/datum/craft_recipe/machinery/wall/apc
	name = "apc frame"
	result = /obj/item/frame/apc

/datum/craft_recipe/machinery/wall/air_alarm
	name = "air alarm frame"
	result = /obj/item/frame/air_alarm

/datum/craft_recipe/machinery/wall/fire_alarm
	name = "fire alarm frame"
	result = /obj/item/frame/fire_alarm

/datum/craft_recipe/machinery/wall/station_holomap
	name = "holomap frame"
	result = /obj/item/frame/holomap

/datum/craft_recipe/machinery/AI_core
	name = "AI core"
	result = /obj/structure/AIcore
	steps = list(
		list(CRAFT_MATERIAL, 10,69ATERIAL_PLASTEEL),
	)
	related_stats = list(STAT_MEC, STAT_COG)
