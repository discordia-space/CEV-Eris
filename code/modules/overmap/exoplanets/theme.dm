/datum/exoplanet_theme
	var/name = "Nothing Special"

/datum/exoplanet_theme/proc/before_map_generation(obj/effect/overmap/sector/exoplanet/E)

/datum/exoplanet_theme/proc/get_planet_image_extra()

/datum/exoplanet_theme/mountains
	name = "Mountains"
	var/rock_color

/datum/exoplanet_theme/mountains/before_map_generation(obj/effect/overmap/sector/exoplanet/E)
	rock_color = pick(E.rock_colors)
	for(var/zlevel in E.map_z)
		new /datum/random_map/automata/cave_system/mountains(null,TRANSITIONEDGE,TRANSITIONEDGE,zlevel,E.maxx-TRANSITIONEDGE,E.maxy-TRANSITIONEDGE,0,1,1, E.planetary_area, rock_color)

/datum/exoplanet_theme/mountains/get_planet_image_extra()
	var/image/res = image('icons/skybox/planet.dmi', "mountains")
	res.color = rock_color
	return res

/datum/random_map/automata/cave_system/mountains
	iterations = 2
	descriptor = "space69ountains"
	wall_type =  /turf/simulated/mineral
	cell_threshold = 6
	var/area/planetary_area
	var/rock_color

/datum/random_map/automata/cave_system/mountains/New(var/seed,69ar/tx,69ar/ty,69ar/tz,69ar/tlx,69ar/tly,69ar/do_not_apply,69ar/do_not_announce,69ar/never_be_priority = 0,69ar/_planetary_area,69ar/_rock_color)
	if(_rock_color)
		rock_color = _rock_color
	target_turf_type = world.turf
	floor_type = world.turf
	planetary_area = _planetary_area
	..()

/datum/random_map/automata/cave_system/mountains/get_additional_spawns(value,69ar/turf/simulated/mineral/T)
	T.color = rock_color
	if(planetary_area)
		ChangeArea(T, planetary_area)
		if(istype(T))
			T.mined_turf = planetary_area.base_turf
