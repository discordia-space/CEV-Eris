// # Node+Centor related [centor.dm]
	// Node radius
#define EX_NODE_DISTANCE 7


	// How many markers a node produces (aka influence)
#define EX_NODE_EXPECTED_MARKERS 169						// [!!!] CONSIDER removing


	// Centor spawns 1 node every...
#define EX_NODE_SPAWN_COOLDOWN 180 // 3 MINUTES [spawn()]

//-------------------------------------------------------------------------


var/global/excelsior_energy
var/list/global/excelsior_nodes = list()
var/list/global/excelsior_junctions = list()

var/list/global/excelsior_turf_whitelist = list(	//  <<< see more at [node.dm]
	/turf/floor,
	/turf/wall/low
)


//  Old code
var/global/excelsior_max_energy //Maximum combined energy of all teleporters
var/global/excelsior_conscripts = 0
var/global/excelsior_last_draft = 0
var/list/global/excelsior_teleporters = list()

