#define SUBMAP_MAP_EDGE_PAD 10 // Automatically created submaps are forbidden from being this close to the main map's edge.

#define IS_SHIP_LEVEL(z_level) (z_level in SSmapping.main_ship_z_levels)
#define IS_PLAYABLE_LEVEL(z_level) (z_level in SSmapping.playable_z_levels)
#define IS_TECHNICAL_LEVEL(z_level) !IS_PLAYABLE_LEVEL(z_level)
