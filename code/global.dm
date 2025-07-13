// Items that ask to be called every cycle.
var/global/datum/datacore/data_core
var/global/datum/DB_search/db_search = new()

var/global/datum/universal_state/universe = new

var/runtime_diary
var/diary
var/world_qdel_log
var/href_logfile

var/master_storyteller       = "shitgenerator"

var/host	//only here until check @ code\modules\ghosttrap\trap.dm:112 is fixed

var/list/admin_log     = list()

var/gravity_is_on = 1

var/join_motd

var/list/awaydestinations = list() // Away missions. A list of landmarks that the warpgate can take you to.

// For FTP requests. (i.e. downloading runtime logs.)
// However it'd be ok to use for accessing attack logs and such too, which are even laggier.
var/fileaccess_timer = 0
var/custom_event_msg


// Reference list for disposal sort junctions. Filled up by sorting junction's New()
var/list/tagger_locations = list()


// Bomb cap!
var/max_explosion_range = 14

