/obj/effect/overmap/sector/exoplanet/snow
	planet_type = "frozen"
	desc = "Cold planet with limited plant life."
	//color = "#e8faff"
	planetary_area = /area/exoplanet/snow
	rock_colors = list(COLOR_DARK_BLUE_GRAY, COLOR_GUNMETAL, COLOR_GRAY80, COLOR_DARK_GRAY)
	plant_colors = list("#d0fef5","#93e1d8","#93e1d8", "#b2abbf", "#3590f3", "#4b4e6d")
	map_generators = list(/datum/random_map/noise/exoplanet/snow, /datum/random_map/noise/ore/poor)
	planet_colors = list("#e8faff")
	surface_color = "#e8faff"
	water_color = "#b5dfeb"

/obj/effect/overmap/sector/exoplanet/snow/generate_atmosphere()
	..()
	if(atmosphere)
		var/limit = 0
		if(habitability_class <= HABITABILITY_OKAY)
			var/datum/species/human/H = /datum/species/human
			limit = initial(H.cold_level_1) + rand(1,10)
		atmosphere.temperature = max(T0C - rand(10, 100), limit)
		atmosphere.update_values()

/datum/random_map/noise/exoplanet/snow
	descriptor = "frozen exoplanet"
	smoothing_iterations = 1
	flora_prob = 5
	large_flora_prob = 10
	water_level_max = 3
	land_type = /turf/floor/exoplanet/snow
	water_type = /turf/floor/exoplanet/ice
	//fauna_types = list(/mob/living/simple_animal/hostile/retaliate/beast/samak, /mob/living/simple_animal/hostile/retaliate/beast/diyaab, /mob/living/simple_animal/hostile/retaliate/beast/shantak)
	//megafauna_types = list(/mob/living/simple_animal/hostile/retaliate/giant_crab)

/area/exoplanet/snow
	ambience = list('sound/effects/wind/tundra0.ogg','sound/effects/wind/tundra1.ogg','sound/effects/wind/tundra2.ogg','sound/effects/wind/spooky0.ogg','sound/effects/wind/spooky1.ogg')
	base_turf = /turf/floor/exoplanet/snow/

/turf/floor/exoplanet/ice
	name = "ice"
	icon = 'icons/turf/snow.dmi'
	icon_state = "ice"

/turf/floor/exoplanet/ice/update_icon()
	return

/turf/floor/exoplanet/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"
	dirt_color = "#e3e7e8"

/turf/floor/exoplanet/snow/New()
	icon_state = pick("snow[rand(1,12)]","snow0")
	..()

/turf/floor/exoplanet/snow/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	name = "permafrost"
	icon_state = "permafrost"
