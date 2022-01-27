/datum/random_map/noise/desert
	descriptor = "desert"
	smoothing_iterations = 3

/datum/random_map/noise/desert/replace_space
	descriptor = "desert (replacement)"
	target_turf_type = /turf/space

/datum/random_map/noise/desert/get_map_char(var/value)
	return "<font color='#69value6969value6969value6969value6969value6969value69'>69pick(list(",",".","'","`"))69</font>"

/datum/random_map/noise/desert/get_appropriate_path(var/value)
	var/val =69in(9,max(0,round((value/cell_range)*10)))
	if(isnull(val))69al = 0
	switch(val)
		if(0 to 1)
			return /turf/simulated/floor/beach/water
		else
			return /turf/simulated/floor/beach/sand/desert

/datum/random_map/noise/desert/get_additional_spawns(var/value,69ar/turf/T)
	var/val =69in(9,max(0,round((value/cell_range)*10)))
	if(isnull(val))69al = 0
	switch(val)
		if(2 to 3)
			if(prob(60))
				var/grass_path = pick(typesof(/obj/structure/flora/grass)-/obj/structure/flora/grass)
				new grass_path(T)
			if(prob(5))
				var/mob_type = pick(list(/mob/living/simple_animal/lizard, /mob/living/simple_animal/mouse))
				new69ob_type(T)
		if(5 to 6)
			if(prob(20))
				var/grass_path = pick(typesof(/obj/structure/flora/grass)-/obj/structure/flora/grass)
				new grass_path(T)
		if(7 to 9)
			if(prob(60))
				new /obj/structure/flora/bush(T)
			else if(prob(20))
				new /obj/structure/flora/tree/dead(T)
