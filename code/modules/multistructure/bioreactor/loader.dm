


/obj/machinery/multistructure/bioreactor_part/loader
	name = "input"
	icon = 'icons/obj/machines/bioreactor.dmi'
	icon_state = "loader"
	pixel_x = -8
	var/dir_input = WEST
	var/dir_output = NORTH


/obj/machinery/multistructure/bioreactor_part/loader/Process()
	if(!MS || !MS_bioreactor.is_operational() || !MS_bioreactor.chamber_solution)
		return
	if(contents.len)
		for(var/obj/object in contents)
			var/obj/machinery/multistructure/bioreactor_part/platform/empty_platform = MS_bioreactor.get_unoccupied_platform()
			if(empty_platform)
				object.forceMove(get_step(src, dir_output))
	else
		grab()


/obj/machinery/multistructure/bioreactor_part/loader/proc/grab()
	var/obj/item/target = locate() in get_step(src, dir_input)
	if(target && !target.anchored && contents.len <= 10)
		target.forceMove(loc)
		spawn(1)
			target.forceMove(src)


/obj/machinery/multistructure/bioreactor_part/loader/attack_hand(mob/user)
	if(MS_bioreactor.chamber_closed && MS_bioreactor.is_operational())
		MS_bioreactor.pump_solution()
	else
		world << "nope"