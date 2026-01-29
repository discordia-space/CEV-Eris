// # Node+Centor related [centor.dm]
#define EX_NODE_DISTANCE 7
var/global/excelsior_energy
var/list/global/excelsior_nodes = list()
var/list/global/excelsior_junctions = list()

var/list/global/excelsior_turf_whitelist = list(	//  <<< see more at [node.dm]
	/turf/floor,
	/turf/wall/low
)



// # Old code
var/global/excelsior_max_energy //Maximum combined energy of all teleporters
var/global/excelsior_conscripts = 0
var/global/excelsior_last_draft = 0
var/list/global/excelsior_teleporters = list()

