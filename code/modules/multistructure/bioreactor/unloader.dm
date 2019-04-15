

/obj/machinery/multistructure/bioreactor_part/unloader
	name = "unloader"
	icon = 'icons/obj/machines/bioreactor.dmi'
	icon_state = "unloader"
	var/dir_output = NORTH


/obj/machinery/multistructure/bioreactor_part/unloader/Process()
	if(!MS)
		return
	if(contents.len)
		var/atom/movable/misc = locate() in contents
		if(misc)
			unload(misc)

/obj/machinery/multistructure/bioreactor_part/unloader/Destroy()
	for(var/atom/movable/misc in contents)
		unload(misc)
	return ..()


/obj/machinery/multistructure/bioreactor_part/unloader/proc/unload(atom/movable/waste)
	waste.forceMove(get_turf(src))
	spawn(1)
		waste.forceMove(get_step(src, dir_output))
		if((MS_bioreactor.biotank_platform.pipes_cleanness <= 20) && prob(15))
			spill_biomass(get_step(src, dir_output), cardinal)


#undef CLEANING_TIME