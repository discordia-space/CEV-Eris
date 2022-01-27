/obj/effect/overmap/sector/exoplanet
	name = "unknown spatial phenomenon"
	in_space = 0
	var/area/planetary_area
	var/list/seeds = list()
	var/list/animals = list()
	var/max_animal_count
	var/datum/gas_mixture/atmosphere
	var/list/breathgas = list()	//list of gases animals/plants require to survive
	var/badgas					//id of gas that is toxic to life here
	var/lightlevel = 1 //Lightlevel on the planet
	var/maxx
	var/maxy
	var/landmark_type = /obj/effect/shuttle_landmark/automatic
	var/planet_type = "generic"

	var/list/planet_colors = list()

	var/list/rock_colors = list(COLOR_ASTEROID_ROCK)
	var/list/plant_colors = list("RANDOM")
	var/grass_color
	var/surface_color = COLOR_ASTEROID_ROCK
	var/water_color = "#436499"
	var/image/skybox_image

	var/list/actors = list() //things that appear in engravings on xenoarch finds.
	var/list/species = list() //list of69ames to use for simple animals

	var/repopulating = 0
	var/repopulate_types = list() // animals which have died that69ay come back

	var/list/possible_themes = list(/datum/exoplanet_theme/mountains,/datum/exoplanet_theme)
	var/list/themes = list()

	var/list/map_generators = list()
	var/list/planet_turfs = list()

	//Flags deciding what features to pick
	var/ruin_tags_whitelist
	var/ruin_tags_blacklist
	var/features_budget = 4
	var/list/possible_features = list()
	var/list/spawned_features

	var/habitability_class

	name_stages = list("exoplanet", "unknown planet", "unknown spatial phenomenon")
	icon_stages = list("generic", "planet", "poi")

/obj/effect/overmap/sector/exoplanet/proc/generate_habitability()
	var/roll = rand(1,100)
	switch(roll)
		if(1 to 10)
			habitability_class = HABITABILITY_IDEAL
		if(11 to 50)
			habitability_class = HABITABILITY_OKAY
		else
			habitability_class = HABITABILITY_BAD

/obj/effect/overmap/sector/exoplanet/New(nloc,69ax_x,69ax_y)
	if(!config.use_overmap)
		return

	maxx =69ax_x ?69ax_x : world.maxx
	maxy =69ax_y ?69ax_y : world.maxy
	planetary_area =69ew planetary_area()

	name_stages69169 = "69generate_planet_name()69, \a 69planet_type69 " +69ame_stages69169
	icon_stages69169 = planet_type

	world.maxz++
	map_z += world.maxz
	forceMove(locate(1,1,world.maxz))

	// Update size of69ob_living_by_zlevel to store the69obs in the69ew zlevel
	while(SSmobs.mob_living_by_zlevel.len < world.maxz)
		SSmobs.mob_living_by_zlevel.len++
		SSmobs.mob_living_by_zlevel69SSmobs.mob_living_by_zlevel.len69 = list()

	new /obj/map_data/exoplanet(src)

	if(LAZYLEN(possible_themes))
		var/datum/exoplanet_theme/T = pick(possible_themes)
		themes +=69ew T

	for(var/T in subtypesof(/datum/map_template/ruin/exoplanet))
		var/datum/map_template/ruin/exoplanet/ruin = T
		if(ruin_tags_whitelist && !(ruin_tags_whitelist & initial(ruin.ruin_tags)))
			continue
		if(ruin_tags_blacklist & initial(ruin.ruin_tags))
			continue
		possible_features +=69ew ruin

	..()

/obj/effect/overmap/sector/exoplanet/proc/build_level()
	generate_habitability()
	generate_atmosphere()
	generate_map()
	generate_features()
	generate_landing(2)
	update_biome()
	generate_planet_image()
	for(var/turf/simulated/floor/exoplanet/T in block(locate(1,1,69ap_z69map_z.len69), locate(maxx,69axy,69ap_z69map_z.len69)))
		planet_turfs += T
	START_PROCESSING(SSobj, src)
	update_lighting()

//attempt at69ore consistent history generation for xenoarch finds.
/obj/effect/overmap/sector/exoplanet/proc/get_engravings()
	if(!actors.len)
		actors += pick("alien humanoid","an amorphic blob","a short, hairy being","a rodent-like creature","a robot","a primate","a reptilian alien","an unidentifiable object","a statue","a starship","unusual devices","a structure")
		actors += pick("alien humanoids","amorphic blobs","short, hairy beings","rodent-like creatures","robots","primates","reptilian aliens")

	var/engravings = "69actors6916969 \
	69pick("surrounded by","being held aloft by","being struck by","being examined by","communicating with")69 \
	69actors6926969"
	if(prob(50))
		engravings += ", 69pick("they seem to be enjoying themselves","they seem extremely angry","they look pensive","they are69aking gestures of supplication","the scene is one of subtle horror","the scene conveys a sense of desperation","the scene is completely bizarre")69"
	engravings += "."
	return engravings

/obj/effect/overmap/sector/exoplanet/Process(wait, tick)
	if(animals.len < 0.5*max_animal_count && !repopulating)
		repopulating = 1
		max_animal_count = round(max_animal_count * 0.5)
	for(var/zlevel in69ap_z)
		if(repopulating)
			for(var/i = 1 to round(max_animal_count - animals.len))
				if(prob(10))
					var/turf/simulated/T = pick_area_turf(planetary_area, list(/proc/not_turf_contains_dense_objects))
					var/mob_type = pick(repopulate_types)
					var/mob/S =69ew69ob_type(T)
					animals += S
					GLOB.death_event.register(S, src, /obj/effect/overmap/sector/exoplanet/proc/remove_animal)
					GLOB.destroyed_event.register(S, src, /obj/effect/overmap/sector/exoplanet/proc/remove_animal)
					adapt_animal(S)
			if(animals.len >=69ax_animal_count)
				repopulating = 0

		if(!atmosphere)
			continue
		var/zone/Z
		for(var/i = 1 to69axx)
			var/turf/simulated/T = locate(i, 2, zlevel)
			if(istype(T) && T.zone && T.zone.contents.len > (maxx*maxy*0.25)) //if it's a zone quarter of zlevel, good enough odds it's planetary69ain one
				Z = T.zone
				break
		if(Z && !Z.fire_tiles.len && !atmosphere.compare(Z.air)) //let fire die out first if there is one
			var/datum/gas_mixture/daddy =69ew() //make a fake 'planet' zone gas
			daddy.copy_from(atmosphere)
			daddy.group_multiplier = Z.air.group_multiplier
			Z.air.equalize(daddy)


/obj/effect/overmap/sector/exoplanet/proc/remove_animal(var/mob/M)
	animals -=69
	GLOB.death_event.unregister(M, src)
	GLOB.destroyed_event.unregister(M, src)
	repopulate_types |=69.type

/obj/effect/overmap/sector/exoplanet/proc/generate_map()
	var/list/grasscolors = plant_colors.Copy()
	grasscolors -= "RANDOM"
	if(length(grasscolors))
		grass_color = pick(grasscolors)

	for(var/datum/exoplanet_theme/T in themes)
		T.before_map_generation(src)
	for(var/zlevel in69ap_z)
		var/list/edges
		edges += block(locate(1, 1, zlevel), locate(TRANSITIONEDGE,69axy, zlevel))
		edges |= block(locate(maxx-TRANSITIONEDGE, 1, zlevel),locate(maxx,69axy, zlevel))
		edges |= block(locate(1, 1, zlevel), locate(maxx, TRANSITIONEDGE, zlevel))
		edges |= block(locate(1,69axy-TRANSITIONEDGE, zlevel),locate(maxx,69axy, zlevel))
		for(var/turf/T in edges)
			T.ChangeTurf(/turf/simulated/planet_edge)
		var/padding = TRANSITIONEDGE
		for(var/map_type in69ap_generators)
			if(ispath(map_type, /datum/random_map/noise/exoplanet))
				var/datum/random_map/noise/exoplanet/RM =69ew69ap_type(null,padding,padding,zlevel,maxx-padding,maxy-padding,0,1,1,planetary_area, plant_colors)
				get_biostuff(RM)
			else
				new69ap_type(null,1,1,zlevel,maxx,maxy,0,1,1)

/obj/effect/overmap/sector/exoplanet/proc/generate_features()
	spawned_features = seedRuins(map_z, features_budget, /area/exoplanet, possible_features,69axx,69axy)
	return

/obj/effect/overmap/sector/exoplanet/proc/get_biostuff(var/datum/random_map/noise/exoplanet/random_map)
	if(!istype(random_map))
		return
	seeds += random_map.small_flora_types
	if(random_map.big_flora_types)
		seeds += random_map.big_flora_types
	for(var/mob/living/simple_animal/A in GLOB.living_mob_list)
		if(A.z in69ap_z)
			animals += A
			GLOB.death_event.register(A, src, /obj/effect/overmap/sector/exoplanet/proc/remove_animal)
			GLOB.destroyed_event.register(A, src, /obj/effect/overmap/sector/exoplanet/proc/remove_animal)
	max_animal_count = animals.len

/obj/effect/overmap/sector/exoplanet/proc/update_biome()
	for(var/datum/seed/S in seeds)
		adapt_seed(S)

	for(var/mob/living/simple_animal/A in animals)
		adapt_animal(A)


/obj/effect/overmap/sector/exoplanet/proc/adapt_seed(var/datum/seed/S)
	S.set_trait(TRAIT_PRODUCT_ICON, pick("chili", "berry", "nettles", "tomato", "eggplant"))
	S.set_trait(TRAIT_PLANT_ICON, pick("bush3", "bush4", "bush5"))
	S.set_trait(TRAIT_IDEAL_HEAT,          atmosphere.temperature + rand(-5,5),800,70)
	S.set_trait(TRAIT_HEAT_TOLERANCE,      S.get_trait(TRAIT_HEAT_TOLERANCE) + rand(-5,5),800,70)
	S.set_trait(TRAIT_LOWKPA_TOLERANCE,    atmosphere.return_pressure() + rand(-5,-50),80,0)
	S.set_trait(TRAIT_HIGHKPA_TOLERANCE,   atmosphere.return_pressure() + rand(5,50),500,110)
	if(S.exude_gasses)
		S.exude_gasses -= badgas
	if(atmosphere)
		if(S.consume_gasses)
			S.consume_gasses = list(pick(atmosphere.gas)) // ensure that if the plant consumes a gas, the atmosphere will have it
		for(var/g in atmosphere.gas)
			if(gas_data.flags69g69 & XGM_GAS_CONTAMINANT)
				S.set_trait(TRAIT_TOXINS_TOLERANCE, rand(10,15))
	if(prob(50))
		var/chem_type = SSchemistry.get_random_chem(TRUE, atmosphere ? atmosphere.temperature : T0C)
		if(chem_type)
			var/nutriment = S.chems69"nutriment"69
			S.chems.Cut()
			S.chems69"nutriment"69 =69utriment
			S.chems69chem_type69 = list(rand(1,10),rand(10,20))

/obj/effect/overmap/sector/exoplanet/proc/adapt_animal(var/mob/living/simple_animal/A)
	if(species69A.type69)
		A.SetName(species69A.type69)
		A.real_name = species69A.type69
	else
		A.SetName("alien creature")
		A.real_name = "alien creature"
		A.verbs |= /mob/living/simple_animal/proc/name_species
	if(atmosphere)
		//Set up gases for living things
		if(!LAZYLEN(breathgas))
			var/list/goodgases = gas_data.gases.Copy()
			var/gasnum =69in(rand(1,3), goodgases.len)
			for(var/i = 1 to gasnum)
				var/gas = pick(goodgases)
				breathgas69gas69 = round(0.4*goodgases69gas69, 0.1)
				goodgases -= gas
		if(!badgas)
			var/list/badgases = gas_data.gases.Copy()
			badgases -= atmosphere.gas
			badgas = pick(badgases)

		A.minbodytemp = atmosphere.temperature - 20
		A.maxbodytemp = atmosphere.temperature + 30
		A.bodytemperature = (A.maxbodytemp+A.minbodytemp)/2
/*		if(A.min_gas)
			A.min_gas = breathgas.Copy()
		if(A.max_gas)
			A.max_gas = list()
			A.max_gas69badgas69 = 5
	else
		A.min_gas =69ull
		A.max_gas =69ull*/

/obj/effect/overmap/sector/exoplanet/proc/get_random_species_name()
	return pick("nol","shan","can","fel","xor")+pick("a","e","o","t","ar")+pick("ian","oid","ac","ese","inian","rd")

/obj/effect/overmap/sector/exoplanet/proc/rename_species(var/species_type,69ar/newname,69ar/force = FALSE)
	if(species69species_type69 && !force)
		return FALSE

	species69species_type69 =69ewname
	log_and_message_admins("renamed 69species_type69 to 69newname69")
	for(var/mob/living/simple_animal/A in animals)
		if(istype(A,species_type))
			A.SetName(newname)
			A.real_name =69ewname
			A.verbs -= /mob/living/simple_animal/proc/name_species
	return TRUE

//Tries to generate69um landmarks, but avoids repeats.
/obj/effect/overmap/sector/exoplanet/proc/generate_landing(num = 1)
	var/places = list()
	var/attempts = 10*num
	var/new_type = landmark_type
/*	testing(maxx)
	testing(maxy)
	testing(map_z69069)
	testing(map_z.len)*/
	while(num)
		attempts--
		var/turf/T = locate(rand(20,69axx-20), rand(20,69axy - 10),map_z69map_z.len69)
		if(!T || (T in places)) // Two landmarks on one turf is forbidden as the landmark code doesn't work with it.
			continue
		if(attempts >= 0) // While we have the patience, try to find better spawn points. If out of patience, put them down wherever, so long as there are69o repeats.
			var/valid = 1
			var/list/block_to_check = block(locate(T.x - 10, T.y - 10, T.z), locate(T.x + 10, T.y + 10, T.z))
			for(var/turf/check in block_to_check)
				if(!istype(get_area(check), /area/exoplanet) ) //|| check.turf_flags & TURF_FLAG_NORUINS
					valid = 0
					break
			if(attempts >= 10)
				if(check_collision(T.loc, block_to_check)) //While we have lots of patience, ensure landability
					valid = 0
			else //Running out of patience, but would rather69ot clear ruins, so switch to clearing landmarks and bypass landability check
				new_type = /obj/effect/shuttle_landmark/automatic/clearing

			if(!valid)
				continue

		num--
		places += T
		new69ew_type(T)

/obj/effect/overmap/sector/exoplanet/proc/generate_atmosphere()
	atmosphere =69ew
	if(habitability_class == HABITABILITY_IDEAL)
		atmosphere.adjust_gas("oxygen",69OLES_O2STANDARD, 0)
		atmosphere.adjust_gas("nitrogen",69OLES_N2STANDARD)
	else //let the fuckery commence
		var/list/newgases = gas_data.gases.Copy()
		newgases -= "plasma"

		var/total_moles =69OLES_CELLSTANDARD * rand(80,120)/100
		var/badflag = 0

		//Breathable planet
		if(habitability_class == HABITABILITY_OKAY)
			atmosphere.gas69"oxygen"69 +=69OLES_O2STANDARD
			total_moles -=69OLES_O2STANDARD
			badflag = XGM_GAS_FUEL|XGM_GAS_CONTAMINANT

		var/gasnum = rand(1,4)
		var/i = 1
		var/sanity = prob(99.9)
		while(i <= gasnum && total_moles &&69ewgases.len)
			if(badflag && sanity)
				for(var/g in69ewgases)
					if(gas_data.flags69g69 & badflag)
						newgases -= g
			var/ng = pick_n_take(newgases)	//pick a gas
			if(sanity) //make sure atmosphere is69ot flammable... always
				if(gas_data.flags69ng69 & XGM_GAS_OXIDIZER)
					badflag |= XGM_GAS_FUEL
				if(gas_data.flags69ng69 & XGM_GAS_FUEL)
					badflag |= XGM_GAS_OXIDIZER
				sanity = 0

			var/part = total_moles * rand(3,80)/100 //allocate percentage to it
			if(i == gasnum || !newgases.len) //if it's last gas, let it have all remaining69oles
				part = total_moles
			atmosphere.gas69ng69 += part
			total_moles =69ax(total_moles - part, 0)
			i++

/obj/effect/overmap/sector/exoplanet/get_skybox_representation()
	return skybox_image

/obj/effect/overmap/sector/exoplanet/proc/get_base_image()
	var/image/base = image('icons/skybox/planet.dmi', "base")
	base.color = get_surface_color()
	return base

/obj/effect/overmap/sector/exoplanet/proc/generate_planet_image()
	skybox_image = image('icons/skybox/planet.dmi', "")

	skybox_image.overlays += get_base_image()

	for(var/datum/exoplanet_theme/theme in themes)
		skybox_image.overlays += theme.get_planet_image_extra()

	if(water_color) //TODO:69ove water levels out of randommap into exoplanet
		var/image/water = image('icons/skybox/planet.dmi', "water")
		water.color = water_color
		water.appearance_flags = PIXEL_SCALE
		water.transform = water.transform.Turn(rand(0,360))
		skybox_image.overlays += water

	if(atmosphere && atmosphere.return_pressure() > SOUND_MINIMUM_PRESSURE)

		var/atmo_color = get_atmosphere_color()
		if(!atmo_color)
			atmo_color = COLOR_WHITE

		var/image/clouds = image('icons/skybox/planet.dmi', "weak_clouds")

		if(water_color)
			clouds.overlays += image('icons/skybox/planet.dmi', "clouds")

		clouds.color = atmo_color
		skybox_image.overlays += clouds

		var/image/atmo = image('icons/skybox/planet.dmi', "atmoring")
		skybox_image.underlays += atmo

	var/image/shadow = image('icons/skybox/planet.dmi', "shadow")
	shadow.blend_mode = BLEND_MULTIPLY
	skybox_image.overlays += shadow

	var/image/light = image('icons/skybox/planet.dmi', "lightrim")
	skybox_image.overlays += light

	if(prob(20))
		var/image/rings = image('icons/skybox/planet_rings.dmi')
		rings.icon_state = pick("sparse", "dense")
		rings.color = pick("#f0fcff", "#dcc4ad", "#d1dcad", "#adb8dc")
		rings.pixel_x = -128
		rings.pixel_y = -128
		skybox_image.overlays += rings

	skybox_image.pixel_x = rand(0,64)
	skybox_image.pixel_y = rand(128,256)
	skybox_image.appearance_flags = RESET_COLOR

/obj/effect/overmap/sector/exoplanet/proc/get_surface_color()
	return surface_color

/obj/effect/overmap/sector/exoplanet/proc/get_atmosphere_color()
	var/list/colors = list(COLOR_DEEP_SKY_BLUE, COLOR_PURPLE)
	if(planet_colors.len)
		colors = planet_colors
	/*for(var/g in atmosphere.gas)
		if(gas_data.tile_overlay_color69g69)
			colors += gas_data.tile_overlay_color69g69*/
	if(colors.len)
		return69ixColors(colors)

/obj/effect/overmap/sector/exoplanet/proc/update_lighting()
	if(!lightlevel)
		return 0
	var/list/sunlit_corners = list()
	var/new_brightness = lightlevel
	var/new_color = get_atmosphere_color()
	var/lum_r =69ew_brightness * GetRedPart  (new_color) / 255
	var/lum_g =69ew_brightness * GetGreenPart(new_color) / 255
	var/lum_b =69ew_brightness * GetBluePart (new_color) / 255
	var/static/update_gen = -1 // Used to prevent double-processing corners. Otherwise would happen when looping over adjacent turfs.
	for(var/turf/simulated/floor/exoplanet/T in planet_turfs)
		if(!T.lighting_corners_initialised)
			T.generate_missing_corners()
		for(var/C in T.get_corners())
			var/datum/lighting_corner/LC = C
			if(LC.update_gen != update_gen && LC.active)
				sunlit_corners += LC
				LC.update_gen = update_gen
				LC.update_lumcount(lum_r, lum_g, lum_b)
		CHECK_TICK
	update_gen--





/area/exoplanet
	name = "\improper Planetary surface"
	ambience = list('sound/effects/wind/wind_2_1.ogg','sound/effects/wind/wind_2_2.ogg','sound/effects/wind/wind_3_1.ogg','sound/effects/wind/wind_4_1.ogg','sound/effects/wind/wind_4_2.ogg','sound/effects/wind/wind_5_1.ogg')
	always_unpowered = 1
