/obj/effect/overmap/sector/exoplanet/shrouded
	planet_type = "shrouded"
	desc = "An exoplanet shrouded in a perpetual storm of bizzare, light absorbing particles."
	//color = "#3e3960"
	planetary_area = /area/exoplanet/shrouded
	rock_colors = list(COLOR_INDIGO, COLOR_DARK_BLUE_GRAY, COLOR_NAVY_BLUE)
	plant_colors = list("#3c5434", "#2f6655", "#0e703f", "#495139", "#394c66", "#1a3b77", "#3e3166", "#52457c", "#402d56", "#580d6d")
	map_generators = list(/datum/random_map/noise/exoplanet/shrouded)
	ruin_tags_blacklist = RUIN_HABITAT
	planet_colors = list(COLOR_DEEP_SKY_BLUE, COLOR_PURPLE)
	surface_color = "#3e3960"
	water_color = "#2b2840"

/obj/effect/overmap/sector/exoplanet/shrouded/generate_atmosphere()
	..()
	if(atmosphere)
		atmosphere.temperature = T20C - rand(10, 20)
		atmosphere.update_values()

/obj/effect/overmap/sector/exoplanet/shrouded/get_atmosphere_color()
	return COLOR_BLACK

/datum/random_map/noise/exoplanet/shrouded
	descriptor = "shrouded exoplanet"
	smoothing_iterations = 2
	flora_prob = 5
	large_flora_prob = 20
	megafauna_spawn_prob = 2 //Remember to change this if more types are added.
	flora_diversity = 3
	water_level_max = 3
	water_level_min = 2
	land_type = /turf/floor/exoplanet/shrouded
	water_type = /turf/floor/exoplanet/water/shallow/tar
	/*fauna_types = list(/mob/living/simple_animal/hostile/retaliate/royalcrab,
					   /mob/living/simple_animal/hostile/retaliate/jelly/alt,
					   /mob/living/simple_animal/hostile/retaliate/beast/shantak/alt,
					   /mob/living/simple_animal/hostile/leech)
	megafauna_types = list(/obj/structure/leech_spawner)*/

/area/exoplanet/shrouded
//	forced_ambience = list("sound/ambience/spookyspace1.ogg", "sound/ambience/spookyspace2.ogg")
	base_turf = /turf/floor/exoplanet/shrouded

/turf/floor/exoplanet/water/shallow/tar
	name = "tar"
	icon = 'icons/turf/shrouded.dmi'
	icon_state = "shrouded_tar"
	desc = "A pool of viscous and sticky tar."
	reagent_type = /datum/reagent/toxin/tar
	dirt_color = "#3e3960"

/turf/floor/exoplanet/shrouded
	name = "packed sand"
	icon = 'icons/turf/shrouded.dmi'
	icon_state = "shrouded"
	desc = "Sand that has been packed in to solid earth."
	dirt_color = "#3e3960"

/turf/floor/exoplanet/shrouded/New()
	icon_state = "shrouded[rand(0,8)]"
	..()
