

/obj/machinery/multistructure/bioreactor_part/unloader
	name = "unloader"
	icon_state = "unloader"
	layer = ABOVE_MOB_LAYER
	idle_power_usage = 120
	active_power_usage = 180
	var/dir_output = NORTH

/obj/machinery/multistructure/bioreactor_part/unloader/Process()
	if(!MS)
		use_power(1)
		return
	use_power(2)
	if(contents.len)
		var/obj/item/misc = locate() in contents
		if(misc)
			unload(misc)

/obj/machinery/multistructure/bioreactor_part/unloader/Destroy()
	for(var/obj/item/misc in contents)
		unload(misc, silent = TRUE)
	return ..()


/obj/machinery/multistructure/bioreactor_part/unloader/proc/unload(atom/movable/waste, var/silent = FALSE)
	waste.forceMove(get_turf(src))
	if(!silent)
		playsound(loc, 'sound/machines/vending_drop.ogg', 100, 1)
	spawn(1)
		waste.forceMove(get_step(src, dir_output))
		if((MS_bioreactor.biotank_platform.pipes_cleanness <= 20) && prob(15))
			spill_biomass(get_step(src, dir_output), cardinal)


#undef CLEANING_TIME
#undef BIOREACTOR_DAMAGE_PER_TICK
