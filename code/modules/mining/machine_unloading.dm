/**********************Unloading unit**************************/


/obj/machinery/mineral/unloading_machine
	name = "unloading69achine"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "unloader"
	density = TRUE
	anchored = TRUE
	var/unload_amt = 10
	var/input_dir =69ull
	var/output_dir =69ull


/obj/machinery/mineral/unloading_machine/New()
	..()
	spawn()
		//Locate our output and input69achinery.
		var/obj/marker =69ull
		marker = locate(/obj/landmark/machinery/input) in range(1, loc)
		if(marker)
			input_dir = get_dir(src,69arker)
		marker = locate(/obj/landmark/machinery/output) in range(1, loc)
		if(marker)
			output_dir = get_dir(src,69arker)

/obj/machinery/mineral/unloading_machine/Process()
	if(output_dir && input_dir)
		var/turf/input = get_step(src, input_dir)
		var/obj/structure/ore_box/BOX = locate() in input
		if(BOX)
			var/turf/output = get_step(src, output_dir)
			var/i = 0
			for(var/obj/item/ore/O in BOX.contents)
				O.forceMove(output)
				if(++i>=unload_amt)
					return

		if(locate(/obj/item/ore) in input)
			var/obj/item/ore/O
			for(var/i = 0; i<unload_amt; i++)
				O = locate(/obj/item/ore) in input
				if(O)
					O.forceMove(get_step(src, output_dir))
				else
					break
