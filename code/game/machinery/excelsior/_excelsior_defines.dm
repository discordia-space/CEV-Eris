// # Node+Centor related [centor.dm]
//	- KPK
//	- Node
#define EX_NODE_DISTANCE 7
//	- Centor
#define EX_NODE_SPAWN_COOLDOWN 3 MINUTES




var/global/excelsior_energy
var/list/global/excelsior_nodes = list()
var/list/global/excelsior_junctions = list()

var/list/global/excelsior_turf_whitelist = list(	//  <<< see more at [node.dm]
	/turf/floor,
	/turf/wall/low
)



//-------------------------------------------------------------------------

//  Old, still used code
var/global/excelsior_max_energy //Maximum combined energy of all teleporters
var/global/excelsior_conscripts = 0
var/global/excelsior_last_draft = 0
var/list/global/excelsior_teleporters = list()

