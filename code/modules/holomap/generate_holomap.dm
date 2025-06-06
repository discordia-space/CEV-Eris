//
// Holomap generation.
// Based on /vg/station but trimmed down (without antag stuff) and massively optimized (you should have seen it before!) ~Leshana
//

// Define what criteria makes a turf a path or not

// Turfs that will be colored as HOLOMAP_ROCK
#define IS_ROCK(tile) (istype(tile, /turf/mineral) && tile.density)

// Turfs that will be colored as HOLOMAP_OBSTACLE
#define IS_OBSTACLE(tile) ((!istype(tile, /turf/space) && istype(tile.loc, /area/mine/unexplored)) \
					|| istype(tile, /turf/wall) \
					|| istype(tile, /turf/mineral_unsimulated) \
					|| istype(tile, /turf/wall/dummy) \
					|| istype(tile, /turf/shuttle/wall) \
					|| (locate(/obj/structure/grille) in tile))

// Turfs that will be colored as HOLOMAP_PATH
#define IS_PATH(tile) (istype(tile, /turf/floor) \
					|| istype(tile, /turf/floor/dummy) \
					|| istype(tile, /turf/shuttle/floor) \
					|| (locate(/obj/structure/catwalk) in tile))


/datum/controller/subsystem/mapping/proc/generate_holomaps()
	var/list/levels_to_map = SSmapping.main_ship_z_levels
	if(!LAZYLEN(levels_to_map))
		return

	// One section per Z-level plus the map legend
	var/section_count = LAZYLEN(levels_to_map) + 1
	var/row_count = 1
	var/column_count = 3 // We always have 3 columns on the holomap unless the map is not multi-Z
	switch(section_count)
		if(2) // If we only have a single Z-level to draw + holomap legend
			column_count = 2
		if(4 to 6) // Each row fits up to 3 sections
			row_count = 2
		if(6 to 9)
			row_count = 3

	// Multi-Z maps use the same X and Y dimensions for each individual Z-level, so look up the first one
	var/list/z_level_info = SSmapping.z_level_info_decoded[levels_to_map[1]]
	if(!z_level_info)
		return
	var/map_size_x = z_level_info["map_size_x"]
	var/map_size_y = z_level_info["map_size_y"]

	var/row_offset = 0
	var/column_offset = 0

	// How many pixels it would take to represent every tile from every Z-level with one pixel
	// map_size typically would be 150 or 200; row_count would be 2
	row_offset = map_size_y * row_count
	// How many pixels we have leftover (or missing, if the map is large enough) on the canvas
	row_offset = 480 - row_offset
	// By how many pixels on Y we pad or shrink the map
	row_offset = row_offset / row_count

	// Same as with rows, but here we expect offset to be negative a lot of the time
	// which is fine, because normally decks are much more tall than they are wide,
	// they usually fit in 100x150 dimensions regardless of the actual X and Y bounds
	// So skipping empty space (that we don't draw on the holomap anyway) on the edges is inconsequential
	column_offset = map_size_x * column_count
	column_offset = 480 - column_offset
	column_offset = column_offset / column_count

	// Drawing on two separate icons just to layer them together later
	// Otherwise area's DrawBox() would completely cover that of turf
	var/icon/turf_icon = icon('icons/480x480.dmi', "blank")
	var/icon/area_icon = icon('icons/480x480.dmi', "blank")
	var/icon/holomap = icon('icons/480x480.dmi', "stationmap")
	var/image/legend = image('icons/effects/64x64.dmi', "legend")
	var/list/deck_numbers = list()

	for(var/current_section in 1 to section_count)
		// How many sections we've processed before this one / by how many sections there are in each column
		var/rows_complete = floor((current_section - 1) / column_count)
		// We're at least at row 1, offset by however many already filled out
		var/current_row = 1 + rows_complete
		var/current_column = current_section - (rows_complete * column_count)

		var/offset_x = (current_column - 1) * (map_size_x + column_offset)
		if(!offset_x && (column_offset > 0))
			offset_x = column_offset

		var/offset_y = (current_row - 1) * (map_size_y + row_offset)
		if(!offset_y && (row_offset > 0))
			offset_y = row_offset

		// Either reached the last section, which is holomap legend, or our map is
		// comically tall and we need to bail while there is still space on the canvas
		if(current_section > LAZYLEN(levels_to_map) || (current_section > 8))
			legend.pixel_x = offset_x
			legend.pixel_y = offset_y
			// Legend itself is 64x64, but our holomap sections could be of various sizes
			// So we calculate how off-center legend is relatively to other sections and move it by that much
			var/extra_legend_offset_x = (map_size_x - 64) / 2
			var/extra_legend_offset_y = (map_size_y - 64) / 2
			legend.pixel_x += extra_legend_offset_x
			legend.pixel_y += extra_legend_offset_y
			break

		var/z_level = levels_to_map[current_section]

		holomap_offsets_per_z_level["[z_level]"] = list(offset_x, offset_y)

		for(var/x = 1 to map_size_x)
			for(var/y = 1 to map_size_y)
				var/turf/tile = locate(x, y, z_level)
				if(!tile)
					continue
				if(IS_ROCK(tile))
					turf_icon.DrawBox(HOLOMAP_ROCK, x + offset_x, y + offset_y)
				else if(IS_OBSTACLE(tile))
					turf_icon.DrawBox(HOLOMAP_OBSTACLE, x + offset_x, y + offset_y)
				else if(IS_PATH(tile))
					turf_icon.DrawBox(HOLOMAP_PATH, x + offset_x, y + offset_y)

				var/area/area = tile.loc // .loc of a /turf is /area on the same coordinates, m'kay?
				if(istype(area) && area.holomap_color)
					area_icon.DrawBox(area.holomap_color, x + offset_x, y + offset_y)

		var/icon/deck_number = icon('icons/480x480.dmi', "deck[current_section]")
		deck_number.Shift(EAST, offset_x)
		deck_number.Shift(NORTH, offset_y)
		deck_numbers += deck_number


	turf_icon.Blend(HOLOMAP_HOLOFIER, ICON_MULTIPLY)
	holomap.Blend(turf_icon, ICON_OVERLAY)
	holomap.Blend(area_icon, ICON_OVERLAY)
	for(var/icon/deck_number in deck_numbers)
		holomap.Blend(deck_number, ICON_OVERLAY)
	SSmapping.holomap = image(holomap)
	SSmapping.holomap.overlays.Add(legend)

#undef IS_ROCK
#undef IS_OBSTACLE
#undef IS_PATH
