#define DEBUG
// Turf-only flags.
#define NOJAUNT 1 // This is used in literally one place, turf.dm, to block ethereal jaunt.

#define TRANSITIONEDGE 7 // Distance from edge to move to another z-level.

// Invisibility constants.
#define INVISIBILITY_LIGHTING             20
#define INVISIBILITY_ANGEL                30
#define INVISIBILITY_LEVEL_ONE            35
#define INVISIBILITY_LEVEL_TWO            45
#define INVISIBILITY_OBSERVER             60
#define INVISIBILITY_EYE		          61

#define SEE_INVISIBLE_NOLIGHTING          15
#define SEE_INVISIBLE_LIVING              25
#define SEE_INVISIBLE_ANGEL               30
#define SEE_INVISIBLE_LEVEL_ONE           35
#define SEE_INVISIBLE_LEVEL_TWO           45
#define SEE_INVISIBLE_CULT		          60
#define SEE_INVISIBLE_OBSERVER            61

#define SEE_INVISIBLE_MINIMUM 5
#define INVISIBILITY_MAXIMUM 100

// Some arbitrary defines to be used by self-pruning global lists. (see master_controller)
#define PROCESS_KILL 26 // Used to trigger removal from a processing list.
#define MAX_GEAR_COST 5 // Used in chargen for accessory loadout limit.

// For secHUDs and medHUDs and variants. The number is the location of the image on the list hud_list of humans.
#define      HEALTH_HUD 1 // A simple line rounding the mob's number health.
#define      STATUS_HUD 2 // Alive, dead, diseased, etc.
#define          ID_HUD 3 // The job asigned to your ID.
#define      WANTED_HUD 4 // Wanted, released, paroled, security status.
#define     IMPCHEM_HUD 5 // Chemical implant.
#define    IMPTRACK_HUD 6 // Tracking implant.
#define SPECIALROLE_HUD 7 // AntagHUD image.
#define  STATUS_HUD_OOC 8 // STATUS_HUD without virus DB check for someone being ill.
#define        LIFE_HUD 9 // STATUS_HUD that only reports dead or alive

//some colors
#define COLOR_WHITE            "#ffffff"
#define COLOR_SILVER           "#c0c0c0"
#define COLOR_GRAY             "#808080"
#define COLOR_BLACK            "#000000"
#define COLOR_RED              "#ff0000"
#define COLOR_RED_LIGHT        "#b00000"
#define COLOR_MAROON           "#800000"
#define COLOR_YELLOW           "#ffff00"
#define COLOR_AMBER            "#ffbf00"
#define COLOR_OLIVE            "#808000"
#define COLOR_LIME             "#00ff00"
#define COLOR_GREEN            "#008000"
#define COLOR_CYAN             "#00ffff"
#define COLOR_TEAL             "#008080"
#define COLOR_BLUE             "#0000ff"
#define COLOR_BLUE_LIGHT       "#33ccff"
#define COLOR_NAVY             "#000080"
#define COLOR_PINK             "#ff00ff"
#define COLOR_PURPLE           "#800080"
#define COLOR_ORANGE           "#ff9900"
#define COLOR_LUMINOL          "#66ffff"
#define COLOR_BEIGE            "#ceb689"
#define COLOR_BLUE_GRAY        "#6a97b0"
#define COLOR_BROWN            "#b19664"
#define COLOR_DARK_BROWN       "#917448"
#define COLOR_DARK_ORANGE      "#b95a00"
#define COLOR_GREEN_GRAY       "#8daf6a"
#define COLOR_RED_GRAY         "#aa5f61"
#define COLOR_PALE_BLUE_GRAY   "#8bbbd5"
#define COLOR_PALE_GREEN_GRAY  "#aed18b"
#define COLOR_PALE_RED_GRAY    "#cc9090"
#define COLOR_PALE_PURPLE_GRAY "#bda2ba"
#define COLOR_PURPLE_GRAY      "#a2819e"
#define COLOR_SUN              "#ec8b2f"

//	Shuttles.

// These define the time taken for the shuttle to get to the space station, and the time before it leaves again.

#define PODS_PREPTIME 	600	//10 mins = 600 sec - hol long pods will wait before launch
#define PODS_TRANSIT 	120 //2 mins - how long pods takes to get to the centcomm
#define PODS_LOCKDOWN	90	//1.5 mins - how long pods stay opened, if evacuation will be cancelled

// Shuttle moving status.
#define SHUTTLE_IDLE      0
#define SHUTTLE_WARMUP    1
#define SHUTTLE_INTRANSIT 2

// Ferry shuttle processing status.
#define IDLE_STATE   0
#define WAIT_LAUNCH  1
#define FORCE_LAUNCH 2
#define WAIT_ARRIVE  3
#define WAIT_FINISH  4

// Setting this much higher than 1024 could allow spammers to DOS the server easily.
#define MAX_MESSAGE_LEN       1024
#define MAX_PAPER_MESSAGE_LEN 3072
#define MAX_BOOK_MESSAGE_LEN  9216
#define MAX_LNAME_LEN         64
#define MAX_NAME_LEN          26

// Event defines.
#define EVENT_LEVEL_MUNDANE  1
#define EVENT_LEVEL_MODERATE 2
#define EVENT_LEVEL_MAJOR    3
#define EVENT_LEVEL_ECONOMY  4

//General-purpose life speed define for plants.
#define HYDRO_SPEED_MULTIPLIER 1

#define DEFAULT_JOB_TYPE /datum/job/assistant

//Area flags, possibly more to come
#define RAD_SHIELDED 1 //shielded from radiation, clearly

// Custom layer definitions, supplementing the default TURF_LAYER, MOB_LAYER, etc.
#define DOOR_OPEN_LAYER 2.7		//Under all objects if opened. 2.7 due to tables being at 2.6
#define DOOR_CLOSED_LAYER 3.1	//Above most items if closed
#define LIGHTING_LAYER 11
#define HUD_LAYER 20			//Above lighting, but below obfuscation. For in-game HUD effects (whereas SCREEN_LAYER is for abstract/OOC things like inventory slots)
#define OBFUSCATION_LAYER 21	//Where images covering the view for eyes are put
#define SCREEN_LAYER 22			//Mob HUD/effects layer

// Convoluted setup so defines can be supplied by Bay12 main server compile script.
// Should still work fine for people jamming the icons into their repo.
#ifndef CUSTOM_ITEM_OBJ
#define CUSTOM_ITEM_OBJ 'icons/obj/custom_items_obj.dmi'
#endif
#ifndef CUSTOM_ITEM_MOB
#define CUSTOM_ITEM_MOB 'icons/mob/custom_items_mob.dmi'
#endif
#ifndef CUSTOM_ITEM_SYNTH
#define CUSTOM_ITEM_SYNTH 'icons/mob/custom_synthetic.dmi'
#endif

#define WALL_CAN_OPEN 1
#define WALL_OPENING 2

#define DEFAULT_TABLE_MATERIAL "plastic"
#define DEFAULT_WALL_MATERIAL "steel"

#define SHARD_SHARD "shard"
#define SHARD_SHRAPNEL "shrapnel"
#define SHARD_STONE_PIECE "piece"
#define SHARD_SPLINTER "splinters"
#define SHARD_NONE ""

#define MATERIAL_UNMELTABLE 0x1
#define MATERIAL_BRITTLE    0x2
#define MATERIAL_PADDING    0x4

#define TABLE_BRITTLE_MATERIAL_MULTIPLIER 4 // Amount table damage is multiplied by if it is made of a brittle material (e.g. glass)

#define BOMBCAP_DVSTN_RADIUS (max_explosion_range/4)
#define BOMBCAP_HEAVY_RADIUS (max_explosion_range/2)
#define BOMBCAP_LIGHT_RADIUS max_explosion_range
#define BOMBCAP_FLASH_RADIUS (max_explosion_range*1.5)

#define WEAPON_FORCE_HARMLESS    3
#define WEAPON_FORCE_WEAK        7
#define WEAPON_FORCE_NORMAL      10
#define WEAPON_FORCE_PAINFULL    15
#define WEAPON_FORCE_DANGEROUS   20
#define WEAPON_FORCE_ROBUST      26
#define WEAPON_FORCE_LETHAL      51

									// NTNet module-configuration values. Do not change these. If you need to add another use larger number (5..6..7 etc)
#define NTNET_SOFTWAREDOWNLOAD 1 	// Downloads of software from NTNet
#define NTNET_PEERTOPEER 2			// P2P transfers of files between devices
#define NTNET_COMMUNICATION 3		// Communication (messaging)
#define NTNET_SYSTEMCONTROL 4		// Control of various systems, RCon, air alarm control, etc.

// NTNet transfer speeds, used when downloading/uploading a file/program.
#define NTNETSPEED_LOWSIGNAL 0.025	// GQ/s transfer speed when the device is wirelessly connected and on Low signal
#define NTNETSPEED_HIGHSIGNAL 0.1	// GQ/s transfer speed when the device is wirelessly connected and on High signal
#define NTNETSPEED_ETHERNET 0.5		// GQ/s transfer speed when the device is using wired connection

// Program bitflags
#define PROGRAM_ALL 7
#define PROGRAM_CONSOLE 1
#define PROGRAM_LAPTOP 2
#define PROGRAM_TABLET 4

#define PROGRAM_STATE_KILLED 0
#define PROGRAM_STATE_BACKGROUND 1
#define PROGRAM_STATE_ACTIVE 2

// Caps for NTNet logging. Less than 10 would make logging useless anyway, more than 500 may make the log browser too laggy. Defaults to 100 unless user changes it.
#define MAX_NTNET_LOGS 500
#define MIN_NTNET_LOGS 10


// Special return values from bullet_act(). Positive return values are already used to indicate the blocked level of the projectile.
#define PROJECTILE_CONTINUE   -1 //if the projectile should continue flying after calling bullet_act()
#define PROJECTILE_FORCE_MISS -2 //if the projectile should treat the attack as a miss (suppresses attack and admin logs) - only applies to mobs.

//Camera capture modes
#define CAPTURE_MODE_REGULAR 0 //Regular polaroid camera mode
#define CAPTURE_MODE_ALL 1 //Admin camera mode
#define CAPTURE_MODE_PARTIAL 3 //Simular to regular mode, but does not do dummy check


//HUD element hidings flags
#define F12_FLAG 1 // 0001
#define TOGGLE_INVENTORY_FLAG 2 //0010

// Default name for announsment system
#define ANNOUNSER_NAME "CEV Eris System Announcer"


#define LIST_OF_CONSONANT list("b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","y","z","á","â","ã","ä","æ","ç","é","ê","ë","ì","í","ï","ð","ñ","ò","ô","õ","ö","÷","ø","ù")

//Multi-z
#define FALL_GIB_DAMAGE 999

//Core implants
#define CORE_GROUP_RITUAL /datum/core_module/group_ritual
#define CORE_ACTIVATED /datum/core_module/activatable

#define CRUCIFORM_COMMON /datum/core_module/cruciform/common
#define CRUCIFORM_PRIEST /datum/core_module/cruciform/priest
#define CRUCIFORM_INQUISITOR /datum/core_module/cruciform/inquisitor
#define CRUCIFORM_CLONING /datum/core_module/cruciform/cloning

#define CRUCIFORM_OBEY /datum/core_module/cruciform/obey
#define CRUCIFORM_PRIEST_CONVERT /datum/core_module/activatable/cruciform/priest_convert
#define CRUCIFORM_OBEY_ACTIVATOR /datum/core_module/activatable/cruciform/obey_activator
