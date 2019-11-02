// Z-level flags bitfield - Set these flags to determine the z level's purpose
/*#define MAP_LEVEL_STATION		0x001 // Z-levels the station exists on
#define MAP_LEVEL_ADMIN			0x002 // Z-levels for admin functionality (Centcom, shuttle transit, etc)
#define MAP_LEVEL_CONTACT		0x004 // Z-levels that can be contacted from the station, for eg announcements
#define MAP_LEVEL_PLAYER		0x008 // Z-levels a character can typically reach
#define MAP_LEVEL_SEALED		0x010 // Z-levels that don't allow random transit at edge
#define MAP_LEVEL_EMPTY			0x020 // Empty Z-levels that may be used for various things (currently used by bluespace jump)
#define MAP_LEVEL_CONSOLES		0x040 // Z-levels available to various consoles, such as the crew monitor (when that gets coded in). Defaults to station_levels if unset.
*/
// Misc map defines.
#define SUBMAP_MAP_EDGE_PAD 10 // Automatically created submaps are forbidden from being this close to the main map's edge.