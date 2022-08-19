

//Bioreactor
//This huge multistructure takes objects with biomatter and carbon mobs to dissolve them into usable liquid biomatter
//There are six various machines where multistructure datum is just a holder, each part proccess almost independently

#define CLEANING_TIME 2 SECONDS
#define CLONE_DAMAGE_PER_TICK 5


/datum/multistructure/bioreactor
	structure = list(
		list(/obj/machinery/multistructure/bioreactor_part/platform, /obj/machinery/multistructure/bioreactor_part/platform, /obj/machinery/multistructure/bioreactor_part/unloader),
		list(/obj/machinery/multistructure/bioreactor_part/platform, /obj/machinery/multistructure/bioreactor_part/platform, /obj/machinery/multistructure/bioreactor_part/biotank_platform),
		list(/obj/machinery/multistructure/bioreactor_part/loader, /obj/machinery/multistructure/bioreactor_part/console, /obj/machinery/multistructure/bioreactor_part/bioport)
					)
	var/obj/machinery/multistructure/bioreactor_part/loader/item_loader
	var/obj/machinery/multistructure/bioreactor_part/biotank_platform/biotank_platform
	var/obj/machinery/multistructure/bioreactor_part/unloader/misc_output
	var/obj/machinery/multistructure/bioreactor_part/bioport/output_port
	var/obj/machinery/multistructure/bioreactor_part/console/metrics_screen


	var/list/obj/machinery/multistructure/bioreactor_part/platform/platforms = list()
	var/platform_enter_side = WEST		//this one represent 'door' side, used by various checks
	var/chamber_closed = TRUE
	var/chamber_solution = FALSE
	var/chamber_breached = FALSE
	var/obj/effect/overlay/bioreactor_solution/solution


/datum/multistructure/bioreactor/connect_elements()
	..()
	item_loader = locate() in elements
	biotank_platform = locate() in elements
	output_port = locate() in elements
	metrics_screen = locate() in elements
	misc_output = locate() in elements
	for(var/obj/machinery/multistructure/bioreactor_part/part in elements)
		part.MS_bioreactor = src
		if(istype(part, /obj/machinery/multistructure/bioreactor_part/platform))
			var/obj/machinery/multistructure/bioreactor_part/platform/C = part
			C.update_icon()
			if(C.make_glasswalls_after_creation)
				C.make_windows()
			platforms += part
	solution = new(platforms[1].loc)
	solution.icon_state = ""
	solution.pixel_y = -26


/datum/multistructure/bioreactor/disconnect_elements()
	toggle_platform_door()
	for(var/obj/machinery/multistructure/bioreactor_part/element in elements)
		element.MS = null
		element.MS_bioreactor = null
	qdel(solution)
	solution = null


/datum/multistructure/bioreactor/is_operational()
	. = ..()
	if(!.)
		return FALSE

	if(!item_loader || !biotank_platform || !misc_output || !output_port || !metrics_screen)
		Destroy()
		return FALSE

	if(!chamber_closed || chamber_breached)
		return FALSE

	if(biotank_platform.pipes_opened || !biotank_platform.pipes_cleanness)
		return FALSE

	return TRUE


/datum/multistructure/bioreactor/proc/get_unoccupied_platform()
	for(var/obj/machinery/multistructure/bioreactor_part/platform/platform in platforms)
		var/empty = TRUE
		for(var/obj/O in platform.loc)
			if(!O.anchored)
				empty = FALSE
				break
		if(empty)
			return platform


/datum/multistructure/bioreactor/proc/toggle_platform_door()
	if(chamber_solution && is_operational())
		return
	for(var/obj/machinery/multistructure/bioreactor_part/platform/platform in platforms)
		for(var/obj/structure/window/reinforced/glass in platform.loc)
			if(glass.dir == platform_enter_side)
				if(chamber_closed)
					glass.icon_state = ""
					glass.density = FALSE
					flick("glassdoor_open", glass)
				else
					glass.icon_state = "platform_door"
					glass.density = initial(glass.density)
					flick("glassdoor_close", glass)
				playsound(glass.loc, 'sound/machines/windowdoor.ogg', 100, 1)
	chamber_closed = !chamber_closed


/datum/multistructure/bioreactor/proc/pump_solution()
	if(!chamber_closed || !is_operational())
		return
	if(chamber_solution)
		solution.icon_state = ""
		flick("solution_pump_out", solution)
		for(var/obj/machinery/multistructure/bioreactor_part/platform/platform in platforms)
			platform.set_light(0)
	else
		solution.icon_state = initial(solution.icon_state)
		flick("solution_pump_in", solution)
		for(var/obj/machinery/multistructure/bioreactor_part/platform/platform in platforms)
			platform.set_light(1, 3, COLOR_LIGHTING_ORANGE_DARK)
	chamber_solution = !chamber_solution
	playsound(solution.loc, 'sound/effects/slosh.ogg', 100, 1)


/obj/machinery/multistructure/bioreactor_part
	name = "bioreactor part"
	icon = 'icons/obj/machines/bioreactor.dmi'
	icon_state = "biomassconsole1"
	anchored = TRUE
	density = TRUE
	MS_type = /datum/multistructure/bioreactor
	var/datum/multistructure/bioreactor/MS_bioreactor




//#####################################
/obj/structure/reagent_dispensers/biomatter
	name = "medium biomatter canister"
	desc = "A biomatter canister. It is used to store high amounts of biomatter."
	description_info = "Can hold 400 units"
	description_antag = "With a beaker, raw biomatter can be pulled out. When spilled on the floor, the puddles are highly lethal to anyone without protection. Killing them in several minutes if they do not receive treatment"
	icon = 'icons/obj/bioreactor_misc.dmi'
	icon_state = "biomatter_tank_medium"
	amount_per_transfer_from_this = 50
	volume = 400
	spawn_blacklisted = TRUE


/obj/structure/reagent_dispensers/biomatter/large
	name = "large biomatter canister"
	icon_state = "biomatter_tank_large"
	description_info = "Can hold 800 units"
	description_antag = "With a beaker, raw biomatter can be pulled out. When spilled on the floor, the puddles are highly lethal to anyone without protection. Killing them in several minutes if they do not receive treatment"
	volume = 800


/obj/effect/overlay/bioreactor_solution
	name = "solution"
	icon = 'icons/obj/machines/bioreactor.dmi'
	icon_state = "solution"
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
