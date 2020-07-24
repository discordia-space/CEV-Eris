// Simple datum to keep track of a running holomap. Each machine capable of displaying the holomap will have one.
/datum/station_holomap
	var/image/station_map
	var/image/cursor
	var/image/legend
	var/image/deck_name

/datum/station_holomap/proc/initialize_holomap(turf/T, isAI = null, mob/user = null, reinit = FALSE)
	if(!station_map || reinit)
		station_map = image(SSholomaps.extraMiniMaps["[HOLOMAP_EXTRA_STATIONMAP]_[T.z]"])
	if(!cursor || reinit)
		cursor = image('icons/holomap_markers.dmi', "you")
	if(!legend || reinit)
		legend = image('icons/effects/64x64.dmi', "legend")
	if(isStationLevel(T.z))
		if(!deck_name || reinit)
			deck_name = image(HOLO_DECK_NAME, "deck")
			for(var/level in GLOB.maps_data.station_levels)
				deck_name = image(HOLO_DECK_NAME, "deck[level]")
				if(ISODD(level))
					deck_name.pixel_x = HOLOMAP_LEGEND_X(level) - 2*ERIS_HOLOMAP_CENTER_GUTTER
					deck_name.pixel_y = HOLOMAP_PIXEL_OFFSET_Y(level) + 2
				else
					deck_name.pixel_x = HOLOMAP_LEGEND_X(level) + 2*ERIS_HOLOMAP_CENTER_GUTTER
					deck_name.pixel_y = HOLOMAP_PIXEL_OFFSET_Y(level)
				station_map.overlays += deck_name

	if(isAI)
		T = get_turf(user.client.eye)
	cursor.pixel_x = (T.x - 6 + HOLOMAP_PIXEL_OFFSET_X(T.z)) * PIXEL_MULTIPLIER
	cursor.pixel_y = (T.y - 6 + HOLOMAP_PIXEL_OFFSET_Y(T.z)) * PIXEL_MULTIPLIER

	legend.pixel_x = HOLOMAP_LEGEND_X(T.z)
	legend.pixel_y = HOLOMAP_LEGEND_Y(T.z)

	station_map.overlays |= cursor
	station_map.overlays |= legend

/datum/station_holomap/proc/initialize_holomap_bogus()
	station_map = image('icons/480x480.dmi', "stationmap")
	legend = image('icons/effects/64x64.dmi', "notfound")
	legend.pixel_x = 7 * WORLD_ICON_SIZE
	legend.pixel_y = 7 * WORLD_ICON_SIZE
	station_map.overlays |= legend

// TODO - Strategic Holomap support
// /datum/station_holomap/strategic/initialize_holomap(var/turf/T, var/isAI=null, var/mob/user=null)
// 	..()
// 	station_map = image(SSholomaps.extraMiniMaps[HOLOMAP_EXTRA_STATIONMAP_STRATEGIC])
// 	legend = image('icons/effects/64x64.dmi', "strategic")
// 	legend.pixel_x = 3*WORLD_ICON_SIZE
// 	legend.pixel_y = 3*WORLD_ICON_SIZE
// 	station_map.overlays |= legend
