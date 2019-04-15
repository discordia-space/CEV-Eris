//TODO:
//Add nanoUI metrics to console and rename it into screens --sunday

//Add activation/deactivation litanies --polish
//Add power usage to all parts --polish
//Add circuits --polish
//Move it to fresh branch --polish
//Animations for pipes --polish
//Animations for all elements --polish
//Add sounds --polish
//Layers fuckery --polish
//Add comments where it needed --polish
//Check all code and tinker all stuff before code review --polish
//Add biomatter to organs --polish
//Make cloners to accept the biomatter reagent --polish



#define CLEANING_TIME 2 SECONDS


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
	var/obj/machinery/multistructure/bioreactor_part/console/control_panel

	var/list/platforms = list()
	var/platform_enter_side = WEST
	var/chamber_closed = TRUE
	var/chamber_solution = FALSE
	var/chamber_breached = FALSE
	var/obj/effect/overlay/bioreactor_solution/solution


/datum/multistructure/bioreactor/connect_elements()
	..()
	item_loader = locate() in elements
	biotank_platform = locate() in elements
	output_port = locate() in elements
	control_panel = locate() in elements
	misc_output = locate() in elements
	for(var/obj/machinery/multistructure/bioreactor_part/part in elements)
		part.MS_bioreactor = src
		if(istype(part, /obj/machinery/multistructure/bioreactor_part/platform))
			var/obj/machinery/multistructure/bioreactor_part/platform/C = part
			C.update_icon()
			C.make_windows()
			platforms += part
	solution = new(platforms[1].loc)
	solution.icon_state = ""
	solution.pixel_y = -16


/datum/multistructure/bioreactor/disconnect_elements()
	for(var/obj/machinery/multistructure/bioreactor_part/element in elements)
		element.MS = null
		element.MS_bioreactor = null


/datum/multistructure/bioreactor/is_operational()
	. = ..()
	if(!.)
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
	chamber_closed = !chamber_closed


/datum/multistructure/bioreactor/proc/pump_solution()
	if(chamber_solution)
		solution.icon_state = ""
		flick("solution_pump_out", solution)
	else
		solution.icon_state = initial(solution.icon_state)
		flick("solution_pump_in", solution)
	chamber_solution = !chamber_solution


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
	name = "biomatter canister"
	desc = "A biomatter canister. It is used to store high amounts of biomatter."
	icon = 'icons/obj/objects.dmi'
	icon_state = "weldtank"
	amount_per_transfer_from_this = 50
	volume = 500


/obj/structure/reagent_dispensers/biomatter/Initialize()
	. = ..()
	reagents.add_reagent("biomatter", 300)


/obj/effect/overlay/bioreactor_solution
	name = "solution"
	icon = 'icons/obj/machines/bioreactor.dmi'
	icon_state = "solution"