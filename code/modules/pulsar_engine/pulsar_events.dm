//Pulsar events

/datum/pulsar_event
	var/name = "parent of all pulsar events"

/datum/pulsar_event/proc/check_tile(tile)
	var/turf/T = tile
	if(!istype(T))
		return FALSE
	var/list/banned_objects = list(/obj/effect/pulsar)
	banned_objects += typesof(/obj/effect/pulsar_beam)
	banned_objects += typesof(/obj/effect/pulsar_ship)
	for(var/O in T)
		if(O in banned_objects)
			return FALSE
	return TRUE

/datum/pulsar_event/proc/get_valid_tile()
	var/tile_x = rand(2, GLOB.maps_data.pulsar_size - 2)
	var/tile_y = rand(2, GLOB.maps_data.pulsar_size - 2)
	var/turf/T = locate(tile_x, tile_y, GLOB.maps_data.pulsar_z)
	if(istype(T) && check_tile(T))
		return T
	return get_valid_tile() //Infinite reccurson highly improabable

/datum/pulsar_event/proc/on_trigger()
	return

/datum/pulsar_event/pulsar_portals
	name = "pulsar portals"

/datum/pulsar_event/pulsar_portals/on_trigger()
	var/turf/portal_1_turf = get_valid_tile()
	var/turf/portal_2_turf = get_valid_tile()
	var/obj/effect/portal/perfect/portal_1 = new /obj/effect/portal/perfect(portal_1_turf)
	var/obj/effect/portal/perfect/portal_2 = new /obj/effect/portal/perfect(portal_2_turf)
	portal_1.set_target(portal_2_turf)
	portal_2.set_target(portal_1_turf)
	//Shadows for the map
	var/turf/mirror_tile_1 = locate(GLOB.maps_data.pulsar_size - portal_1_turf.x, GLOB.maps_data.pulsar_size - portal_1_turf.y, portal_1_turf.z)
	var/turf/mirror_tile_2 = locate(GLOB.maps_data.pulsar_size - portal_2_turf.x, GLOB.maps_data.pulsar_size - portal_2_turf.y, portal_2_turf.z)
	var/obj/effect/portal/perfect/portal_1_shadow = new /obj/effect/portal/perfect(mirror_tile_1)
	var/obj/effect/portal/perfect/portal_2_shadow = new /obj/effect/portal/perfect(mirror_tile_2)
	portal_1_shadow.set_target(mirror_tile_2)
	portal_2_shadow.set_target(mirror_tile_1)
	portal_1_shadow.alpha = 255 * 0.5
	portal_2_shadow.alpha = 255 * 0.5

/datum/event/pulsar_rad_storm //Much different than regular radstorm, can't be subtype
	startWhen = 5
	announceWhen = 1
	endWhen = INFINITY // YEA

/datum/event/pulsar_rad_storm/announce()
	command_announcement.Announce("High levels of radiation detected near the ship. Please evacuate into one of the shielded maintenance tunnels.", "Anomaly Alert", new_sound = 'sound/AI/radiation.ogg')

/datum/event/pulsar_rad_storm/start()
	make_maint_all_access()
	SSweather.run_weather(/datum/weather/rad_storm)
	for(var/datum/weather/rad_storm/R in SSweather.processing)
		R.start()

/datum/event/pulsar_rad_storm/tick()
	. = ..()
	if(prob(20))
		radiate()

/datum/event/pulsar_rad_storm/proc/radiate()
	for(var/mob/living/carbon/C in GLOB.living_mob_list)
		var/area/A = get_area(C)
		if(!A)
			continue
		if(!(A.z in GLOB.maps_data.station_levels))
			continue
		if(A.flags & AREA_FLAG_RAD_SHIELDED)
			continue

		if(ishuman(C))
			var/mob/living/carbon/human/H = C
			H.apply_effect((rand(15,30)),IRRADIATE)
			if(prob(4))
				H.apply_effect((rand(20,60)),IRRADIATE)

/datum/event/pulsar_rad_storm/end()
	. = ..()
	for(var/datum/weather/rad_storm/R in SSweather.processing)
		R.wind_down()
	command_announcement.Announce("The sattelite has passed the radiation beams. Please report to medbay if you experience any unusual symptoms. Maintenance will lose all access again shortly.", "Anomaly Alert")
	revoke_maint_all_access()
