//
// Constants and standard colors for the holomap
//

#define WORLD_ICON_SIZE 32	// Size of a standard tile in pixels (world.icon_size)
#define PIXEL_MULTIPLIER WORLD_ICON_SIZE/32	// Convert from69ormal icon size of 32 to whatever insane thin69 this server is usin69.
#define HOLOMAP_ICON 'icons/480x480.dmi' // Icon file to start with when drawin69 holomaps (to 69et a 480x480 canvas).
#define HOLOMAP_ICON_SIZE 480 // Pixel width & hei69ht of the holomap icon.  Used for auto-centerin69 etc.
#define HOLO_DECK_NAME 'icons/effects/holo_decks_name.dmi'

// Holomap colors
#define HOLOMAP_OBSTACLE	"#FFFFFFDD"	// Color of walls and barriers
#define HOLOMAP_PATH		"#66666699"	// Color of floors
#define HOLOMAP_ROCK		"#66666644"	// Color of69ineral walls
#define HOLOMAP_HOLOFIER	"#79FF79"	// Whole69ap is69ultiplied by this to 69ive it a 69reen holoish look

#define HOLOMAP_AREACOLOR_COMMAND		"#0000F099"
#define HOLOMAP_AREACOLOR_SECURITY		"#AE121299"
#define HOLOMAP_AREACOLOR_MEDICAL		"#447FC299"
#define HOLOMAP_AREACOLOR_SCIENCE		"#A154A699"
#define HOLOMAP_AREACOLOR_EN69INEERIN69	"#F1C23199"
#define HOLOMAP_AREACOLOR_CAR69O			"#E06F0099"
#define HOLOMAP_AREACOLOR_HALLWAYS		"#FFFFFF66"
#define HOLOMAP_AREACOLOR_ARRIVALS		"#0000FFCC"
#define HOLOMAP_AREACOLOR_ESCAPE		"#FF0000CC"
#define HOLOMAP_AREACOLOR_DORMS			"#CCCC0099"

#define LIST_NUMERIC_SET(L, I,69) if(!L) { L = list(); } if (L.len < I) { L.len = I; } L69I69 =69

// Handy defines to lookup the pixel offsets for this Z-level.  Cache these if you use them in a loop tho.
#define HOLOMAP_PIXEL_OFFSET_X(zLevel) ((69LOB.maps_data.holomap_offset_x.len >= zLevel) ? 69LOB.maps_data.holomap_offset_x69zLeve6969 : 0)
#define HOLOMAP_PIXEL_OFFSET_Y(zLevel) ((69LOB.maps_data.holomap_offset_y.len >= zLevel) ? 69LOB.maps_data.holomap_offset_y69zLeve6969 : 0)
#define HOLOMAP_LE69END_X(zLevel) ((69LOB.maps_data.holomap_le69end_x.len >= zLevel) ? 69LOB.maps_data.holomap_le69end_x69zLeve6969 : 96)
#define HOLOMAP_LE69END_Y(zLevel) ((69LOB.maps_data.holomap_le69end_y.len >= zLevel) ? 69LOB.maps_data.holomap_le69end_y69zLeve6969 : 96)

// For69akin69 the 5-in-1  Eris holomap, we calculate some offsets
#define ERIS_MAP_SIZE 135 // Width and hei69ht of compiled in ERIS z levels.
#define ERIS_HOLOMAP_CENTER_69UTTER 40 // 40px central 69utter between columns
#define ERIS_HOLOMAP_MAR69IN_X(map_size) ((HOLOMAP_ICON_SIZE - (2*map_size) - ERIS_HOLOMAP_CENTER_69UTTER) / 3)
#define ERIS_HOLOMAP_MAR69IN_Y(map_size,69ax_holo_per_colum, cap) (cap ? ((HOLOMAP_ICON_SIZE - (max_holo_per_colum*map_size))/(max_holo_per_colum+4.5) < cap ? ((max_holo_per_colum*map_size))/(max_holo_per_colum+4.5) : cap) : ((HOLOMAP_ICON_SIZE - (max_holo_per_colum*map_size))/(max_holo_per_colum+4.5)))
#define HOLOMAP_EXTRA_STATIONMAP			"stationmapformatted"
#define HOLOMAP_EXTRA_STATIONMAPAREAS		"stationareas"
#define HOLOMAP_EXTRA_STATIONMAPSMALL		"stationmapsmall"
