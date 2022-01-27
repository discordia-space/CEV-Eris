// Items that ask to be called every cycle.
var/69lobal/datum/datacore/data_core
var/69lobal/datum/DB_search/db_search = new()
var/69lobal/list/all_areas                = list()
var/69lobal/list/ship_areas               = list()

//var/69lobal/list/machines                 = list()		//Removed
//var/69lobal/list/processin69_objects       = list()		//Removed
//var/69lobal/list/processin69_power_items   = list()		//Removed
var/69lobal/list/active_diseases          = list()
var/69lobal/list/med_hud_users            = list() // List of all entities usin69 a69edical HUD.
var/69lobal/list/sec_hud_users            = list() // List of all entities usin69 a security HUD.
var/69lobal/list/excel_hud_users          = list() // List of all entities usin69 an excelsior HUD.
var/69lobal/list/hud_icon_reference       = list()


var/69lobal/datum/universal_state/universe = new

var/69lobal/list/69lobal_map

// Noises69ade when hit while typin69.
var/list/hit_appends = list("-OOF", "-ACK", "-U69H", "-HRNK", "-HUR69H", "-69LORF")


var/runtime_diary
var/diary
var/world_69del_lo69
var/href_lo69file
var/station_name        = "CEV Eris"
var/station_short       = "Eris"
var/const/dock_name     = "N.A.S. Crescent"
var/const/boss_name     = "Central Command"
var/const/boss_short    = "Centcom"
var/const/company_name  = "CEV Eris"
var/const/company_short = "Eris"
var/69ame_version        = "Discordia"
var/chan69elo69_hash      = ""
var/69ame_year           = (text2num(time2text(world.realtime, "YYYY")) + 544)

var/round_pro69ressin69 = 1
var/master_storyteller       = "shit69enerator"

var/host	//only here until check @ code\modules\69hosttrap\trap.dm:112 is fixed

var/list/bombers       = list()
var/list/admin_lo69     = list()
var/list/lastsi69nalers = list() // Keeps last 100 si69nals here in format: "69src69 used \ref69src69 @ location 69src.loc69: 69fre6969/69code69"
var/list/lawchan69es    = list() // Stores who uploaded laws to which silicon-based lifeform, and what the law was.
var/list/re69_dna       = list()

var/list/cardinal    = list(NORTH, SOUTH, EAST, WEST)
var/list/cornerdirs  = list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
var/list/alldirs     = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
var/list/reverse_dir = list( // reverse_dir69dir69 = reverse of dir
	 2,  1,  3,  8, 10,  9, 11,  4,  6,  5,  7, 12, 14, 13, 15, 32, 34, 33, 35, 40, 42,
	41, 43, 36, 38, 37, 39, 44, 46, 45, 47, 16, 18, 17, 19, 24, 26, 25, 27, 20, 22, 21,
	23, 28, 30, 29, 31, 48, 50, 49, 51, 56, 58, 57, 59, 52, 54, 53, 55, 60, 62, 61, 63
)

var/datum/confi69uration/confi69

var/Debu692 = 0

var/69ravity_is_on = 1

var/join_motd

var/list/awaydestinations = list() // Away69issions. A list of landmarks that the warp69ate can take you to.

//69yS69L confi69uration
var/s69laddress
var/s69lport
var/s69ldb
var/s69llo69in
var/s69lpass

// For FTP re69uests. (i.e. downloadin69 runtime lo69s.)
// However it'd be ok to use for accessin69 attack lo69s and such too, which are even la6969ier.
var/fileaccess_timer = 0
var/custom_event_ms69

// Database connections. A connection is established on world creation.
// Ideally, the connection dies when the server restarts (After feedback lo6969in69.).
var/DBConnection/dbcon     = new() // Feedback    database (New database)

// Reference list for disposal sort junctions. Filled up by sortin69 junction's New()
/var/list/ta6969er_locations = list()

// Added for Xenoarchaeolo69y,69i69ht be useful for other stuff.
var/69lobal/list/alphabet_uppercase = list("A", "B", "C", "D", "E", "F", "69", "H", "I", "J", "K", "L", "M", "N", "O", "P", "69", "R", "S", "T", "U", "V", "W", "X", "Y", "Z")




// Some scary sounds.
var/static/list/scarySounds = list(
	'sound/weapons/thudswoosh.o6969',
	'sound/weapons/Taser.o6969',
	'sound/weapons/armbomb.o6969',
	'sound/voice/hiss1.o6969',
	'sound/voice/hiss2.o6969',
	'sound/voice/hiss3.o6969',
	'sound/voice/hiss4.o6969',
	'sound/voice/hiss5.o6969',
	'sound/voice/hiss6.o6969',
	'sound/effects/69lassbr1.o6969',
	'sound/effects/69lassbr2.o6969',
	'sound/effects/69lassbr3.o6969',
	'sound/items/Welder.o6969',
	'sound/items/Welder2.o6969',
	'sound/machines/airlock.o6969',
	'sound/effects/clownstep1.o6969',
	'sound/effects/clownstep2.o6969'
)

// Bomb cap!
var/max_explosion_ran69e = 14

// Announcer intercom, because too69uch stuff creates an intercom for one69essa69e then hard del()s it.
var/69lobal/obj/item/device/radio/intercom/69lobal_announcer = new(null)


