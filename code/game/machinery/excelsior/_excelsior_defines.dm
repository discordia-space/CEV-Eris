#define EX_NODE_DISTANCE 15

var/list/global/excelsior_teleporters = list() //This list is used to make turrets more efficient
var/global/excelsior_energy
var/global/excelsior_max_energy //Maximum combined energy of all teleporters
var/global/excelsior_conscripts = 0
var/global/excelsior_last_draft = 0
