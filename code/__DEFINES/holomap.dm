//
// Constants and standard colors for the holomap
//

#define WORLD_ICON_SIZE 32	// Size of a standard tile in pixels (world.icon_size)
#define PIXEL_MULTIPLIER WORLD_ICON_SIZE/32	// Convert from normal icon size of 32 to whatever insane thing this server is using.
#define HOLOMAP_ICON 'icons/480x480.dmi' // Icon file to start with when drawing holomaps (to get a 480x480 canvas).
#define HOLOMAP_ICON_SIZE 480 // Pixel width & height of the holomap icon.  Used for auto-centering etc.
#define HOLO_DECK_NAME 'icons/effects/holo_decks_name.dmi'

// Holomap colors
#define HOLOMAP_OBSTACLE	"#FFFFFFDD"	// Color of walls and barriers
#define HOLOMAP_PATH		"#66666699"	// Color of floors
#define HOLOMAP_ROCK		"#66666644"	// Color of mineral walls
#define HOLOMAP_HOLOFIER	"#79FF79"	// Whole map is multiplied by this to give it a green holoish look

#define HOLOMAP_AREACOLOR_COMMAND		"#0000F099"
#define HOLOMAP_AREACOLOR_SECURITY		"#AE121299"
#define HOLOMAP_AREACOLOR_MEDICAL		"#447FC299"
#define HOLOMAP_AREACOLOR_SCIENCE		"#A154A699"
#define HOLOMAP_AREACOLOR_ENGINEERING	"#F1C23199"
#define HOLOMAP_AREACOLOR_CARGO			"#E06F0099"
#define HOLOMAP_AREACOLOR_HALLWAYS		"#FFFFFF66"
#define HOLOMAP_AREACOLOR_ARRIVALS		"#0000FFCC"
#define HOLOMAP_AREACOLOR_ESCAPE		"#FF0000CC"
#define HOLOMAP_AREACOLOR_DORMS			"#CCCC0099"

#define LIST_NUMERIC_SET(L, I, V) if(!L) { L = list(); } if (L.len < I) { L.len = I; } L[I] = V

// Handy defines to lookup the pixel offsets for this Z-level.  Cache these if you use them in a loop tho.
#define HOLOMAP_PIXEL_OFFSET_X(zLevel) ((GLOB.maps_data.holomap_offset_x.len >= zLevel) ? GLOB.maps_data.holomap_offset_x[zLevel] : 0)
#define HOLOMAP_PIXEL_OFFSET_Y(zLevel) ((GLOB.maps_data.holomap_offset_y.len >= zLevel) ? GLOB.maps_data.holomap_offset_y[zLevel] : 0)
#define HOLOMAP_LEGEND_X(zLevel) ((GLOB.maps_data.holomap_legend_x.len >= zLevel) ? GLOB.maps_data.holomap_legend_x[zLevel] : 96)
#define HOLOMAP_LEGEND_Y(zLevel) ((GLOB.maps_data.holomap_legend_y.len >= zLevel) ? GLOB.maps_data.holomap_legend_y[zLevel] : 96)

// For making the 5-in-1  Eris holomap, we calculate some offsets
#define ERIS_MAP_SIZE 135 // Width and height of compiled in ERIS z levels.
#define ERIS_HOLOMAP_CENTER_GUTTER 40 // 40px central gutter between columns
#define ERIS_HOLOMAP_MARGIN_X(map_size) ((HOLOMAP_ICON_SIZE - (2*map_size) - ERIS_HOLOMAP_CENTER_GUTTER) / 3)
#define ERIS_HOLOMAP_MARGIN_Y(map_size, max_holo_per_colum, cap) (cap ? ((HOLOMAP_ICON_SIZE - (max_holo_per_colum*map_size))/(max_holo_per_colum+4.5) < cap ? ((max_holo_per_colum*map_size))/(max_holo_per_colum+4.5) : cap) : ((HOLOMAP_ICON_SIZE - (max_holo_per_colum*map_size))/(max_holo_per_colum+4.5)))
#define HOLOMAP_EXTRA_STATIONMAP			"stationmapformatted"
#define HOLOMAP_EXTRA_STATIONMAPAREAS		"stationareas"
#define HOLOMAP_EXTRA_STATIONMAPSMALL		"stationmapsmall"
