#define EX_NODE_DISTANCE 7

var/list/global/excelsior_teleporters = list() //This list is used to make turrets more efficient
var/global/excelsior_energy
var/global/excelsior_max_energy //Maximum combined energy of all teleporters
var/global/excelsior_conscripts = 0
var/global/excelsior_last_draft = 0

var/list/global/excelsior_globalturflist = list()
var/list/global/excelsior_globalmarkerlist = list()
var/list/global/excelsior_nodes = list()
var/list/global/excelsior_marker_list = list()

// Stuff, presence of which will generate power for Excelsior
// >> see more at [node.dm]
var/list/global/excelsior_turf_whitelist = list(
	/turf/floor,
	/turf/wall/low
)
