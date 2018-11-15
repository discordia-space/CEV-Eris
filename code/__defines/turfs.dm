#define TURF_REMOVE_CROWBAR     1
#define TURF_REMOVE_SCREWDRIVER 2
#define TURF_REMOVE_SHOVEL      4
#define TURF_REMOVE_WRENCH      8
#define TURF_REMOVE_WELDER		16
#define TURF_CAN_BREAK          32
#define TURF_CAN_BURN           64
#define TURF_EDGES_EXTERNAL		128
#define TURF_HAS_CORNERS        256
#define TURF_HAS_INNER_CORNERS	512
#define TURF_IS_FRAGILE         1024
#define TURF_ACID_IMMUNE        2048
#define TURF_HIDES_THINGS		4096



//Used for floor/wall smoothing
#define SMOOTH_NONE 0	//Smooth only with itself
#define SMOOTH_ALL 1	//Smooth with all of type
#define SMOOTH_WHITELIST 2	//Smooth with a whitelist of subtypes