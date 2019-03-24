//TODO:
//Wait for sprite...
//Add solid toxic biomass
//Add vents to capsules and ability to litter it overtime
//Change bioreactor disintegration method. From alpha changing to something with matrix (Or both)
//Rework capsules to platforms, remove that blocking dir fuckery to simple on_board windows with changed sprite
//Aaaaand add checks and handling for these windows to search breaches
//Add animation of "water" to capsules
//Make ability to manipulate with capsule's "water" and it's vents
//Add nanoUI metrics to console and rename it into screens
//Tons of sprites need to be done (Canister, vents, "water", etc)
//Change connector usage method from drag'n'drop to simple attackhand
//Add sprite animation to pipes of connector
//Add canister checks to biotank
//Add power usage to all parts
//Add custom construction/deconstruction for each part ?
//Add parts to cargo ?
//Make loader move mobs not to empty capsule, but to nearest
//Add sounds
//Make solid biomass when vents are littered or user fail something
//Add skillchecks
//Rename capsules to platforms, since it's not capsules anymore
//Add activation/deactivation lithanies




/datum/multistructure/bioreactor
	structure = list(
		list(/obj/machinery/multistructure/bioreactor_part/capsule, /obj/machinery/multistructure/bioreactor_part/capsule, /obj/machinery/multistructure/bioreactor_part/unloader),
		list(/obj/machinery/multistructure/bioreactor_part/capsule, /obj/machinery/multistructure/bioreactor_part/capsule, /obj/machinery/multistructure/bioreactor_part/biotank),
		list(/obj/machinery/multistructure/bioreactor_part/loader, /obj/machinery/multistructure/bioreactor_part/console, /obj/machinery/multistructure/bioreactor_part/bioport)
					)
	var/obj/machinery/multistructure/bioreactor_part/loader/item_loader
	var/obj/machinery/multistructure/bioreactor_part/biotank/biotank
	var/obj/machinery/multistructure/bioreactor_part/unloader/misc_output
	var/obj/machinery/multistructure/bioreactor_part/bioport/output_port
	var/obj/machinery/multistructure/bioreactor_part/console/control_panel

	var/list/capsules = list()


/datum/multistructure/bioreactor/connect_elements()
	..()
	item_loader = locate() in elements
	biotank = locate() in elements
	output_port = locate() in elements
	control_panel = locate() in elements
	misc_output = locate() in elements
	for(var/obj/machinery/multistructure/bioreactor_part/part in elements)
		part.MS_bioreactor = src
		if(istype(part, /obj/machinery/multistructure/bioreactor_part/capsule))
			var/obj/machinery/multistructure/bioreactor_part/capsule/C = part
			C.update_blocked_dirs()
			capsules += part
	biotank.make_connector()


/datum/multistructure/disconnect_elements()
	for(var/obj/machinery/multistructure/bioreactor_part/element in elements)
		element.MS = null
		element.MS_bioreactor = null


/datum/multistructure/bioreactor/proc/get_unoccupied_capsule()
	for(var/obj/machinery/multistructure/bioreactor_part/capsule/capsule in capsules)
		var/empty = TRUE
		for(var/obj/O in capsule.loc)
			if(!O.anchored)
				empty = FALSE
				break
		if(empty)
			return capsule



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
	name = "biomatter tank"
	desc = "A biomatter tank. It is used to store high amounts of biomatter."
	icon = 'icons/obj/objects.dmi'
	icon_state = "weldtank"
	amount_per_transfer_from_this = 50
	volume = 500


/obj/structure/reagent_dispensers/biomatter/Initialize()
	. = ..()
	reagents.add_reagent("biomatter", amount)