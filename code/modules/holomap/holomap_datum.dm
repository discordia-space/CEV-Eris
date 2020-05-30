// Simple datum to keep track of a running holomap. Each machine capable of displaying the holomap will have one.
/datum/station_holomap
	var/image/station_map
	var/image/cursor
	var/image/legend
	var/image/deck_name
	var/image/deck1
	var/image/deck2
	var/image/deck3
	var/image/deck4
	var/image/deck5

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
			deck1 = image(HOLO_DECK_NAME, "deck1")
			deck2 = image(HOLO_DECK_NAME, "deck2")
			deck3 = image(HOLO_DECK_NAME, "deck3")
			deck4 = image(HOLO_DECK_NAME, "deck4")
			deck5 = image(HOLO_DECK_NAME, "deck5")
			deck1.pixel_x = HOLOMAP_PIXEL_OFFSET_X(1) + ERIS_HOLOMAP_CENTER_GUTTER
			deck1.pixel_y = HOLOMAP_PIXEL_OFFSET_Y(1)
			deck2.pixel_x = HOLOMAP_PIXEL_OFFSET_X(2) + ERIS_HOLOMAP_CENTER_GUTTER 
			deck2.pixel_y = HOLOMAP_PIXEL_OFFSET_Y(2)
			deck3.pixel_x = HOLOMAP_PIXEL_OFFSET_X(3) + ERIS_HOLOMAP_CENTER_GUTTER
			deck3.pixel_y = HOLOMAP_PIXEL_OFFSET_Y(3)
			deck4.pixel_x = HOLOMAP_PIXEL_OFFSET_X(4) + ERIS_HOLOMAP_CENTER_GUTTER
			deck4.pixel_y = HOLOMAP_PIXEL_OFFSET_Y(4)
			deck5.pixel_x = HOLOMAP_PIXEL_OFFSET_X(5) + ERIS_HOLOMAP_CENTER_GUTTER
			deck5.pixel_y = HOLOMAP_PIXEL_OFFSET_Y(5)

	if(isAI)
		T = get_turf(user.client.eye)
	cursor.pixel_x = (T.x - 6 + HOLOMAP_PIXEL_OFFSET_X(T.z)) * PIXEL_MULTIPLIER
	cursor.pixel_y = (T.y - 6 + HOLOMAP_PIXEL_OFFSET_Y(T.z)) * PIXEL_MULTIPLIER

	legend.pixel_x = HOLOMAP_LEGEND_X(T.z)
	legend.pixel_y = HOLOMAP_LEGEND_Y(T.z)

	station_map.overlays |= cursor
	station_map.overlays |= legend

	station_map.overlays |= deck1
	station_map.overlays |= deck2
	station_map.overlays |= deck3
	station_map.overlays |= deck4
	station_map.overlays |= deck5

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
