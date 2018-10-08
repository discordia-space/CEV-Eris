/datum/craft_recipe/machinery
	category = "Machinery"
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF

/datum/craft_recipe/machinery/machine_frame
	name = "machine frame"
	result = /obj/machinery/constructable_frame/machine_frame
	steps = list(
		list(/obj/item/stack/material/steel, 8),
	)

/datum/craft_recipe/machinery/vertical_machine_frame
	name = "vertical machine frame"
	result = /obj/machinery/constructable_frame/machine_frame/vertical
	steps = list(
		list(/obj/item/stack/material/steel, 8),
	)

/datum/craft_recipe/machinery/computer_frame
	name = "computer frame"
	result = /obj/structure/computerframe
	steps = list(
		list(/obj/item/stack/material/steel, 5),
	)

/datum/craft_recipe/machinery/modularconsole
	name = "modular console frame"
	result = /obj/item/modular_computer/console
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF
	steps = list(
		list(/obj/item/stack/material/steel, 10),
		list(/obj/item/stack/material/glass, 4),
	)

/datum/craft_recipe/machinery/modularlaptop
	name = "modular laptop frame"
	result = /obj/item/modular_computer/laptop
	steps = list(
		list(/obj/item/stack/material/steel, 8),
		list(/obj/item/stack/material/glass, 4),
	)

/datum/craft_recipe/machinery/modulartablet
	name = "modular tablet frame"
	result = /obj/item/modular_computer/tablet
	steps = list(
		list(/obj/item/stack/material/steel, 5),
		list(/obj/item/stack/material/glass, 2),
	)

/datum/craft_recipe/machinery/modularpda
	name = "modular pda frame"
	result = /obj/item/modular_computer/pda
	steps = list(
		list(/obj/item/stack/material/steel, 3),
		list(/obj/item/stack/material/glass, 1),
	)

/datum/craft_recipe/machinery/modulartelescreen
	name = "modular telescreen frame"
	result = /obj/item/modular_computer/telescreen
	steps = list(
		list(/obj/item/stack/material/steel, 8),
		list(/obj/item/stack/material/glass, 6),
	)

/datum/craft_recipe/machinery/turret_frame
	name = "turret frame"
	result = /obj/machinery/porta_turret_construct
	steps = list(
		list(/obj/item/stack/material/steel, 10),
	)



//wall or small you know them req only 2 list
/datum/craft_recipe/machinery/wall
	steps = list(
		list(/obj/item/stack/material/steel, 2),
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
	steps = list(
		list(/obj/item/stack/material/steel, 2),
	)

/datum/craft_recipe/machinery/wall/air_alarm
	name = "air alarm frame"
	result = /obj/item/frame/air_alarm
	steps = list(
		list(/obj/item/stack/material/steel, 2),
	)

/datum/craft_recipe/machinery/wall/fire_alarm
	name = "fire alarm frame"
	result = /obj/item/frame/fire_alarm
	steps = list(
		list(/obj/item/stack/material/steel, 2),
	)

/datum/craft_recipe/machinery/AI_core
	name = "AI core"
	result = /obj/structure/AIcore
	steps = list(
		list(/obj/item/stack/material/plasteel, 10),
	)
