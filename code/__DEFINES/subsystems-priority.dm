// Something to remember when setting priorities: SS_TICKER runs before Normal, which runs before SS_BACKGROUND.
// Each group has its own priority bracket.
// SS_BACKGROUND handles high server load differently than Normal and SS_TICKER do.
// Higher priority also means a larger share of a given tick before sleep checks.

// SS_TICKER
// < none >

var/list/bitflags = list(1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768)

#define FIRE_PRIORITY_DEFAULT 50          // Default priority for both normal and background processes

// Normal
#define FIRE_PRIORITY_DELAYED_VERBS 	950
#define FIRE_PRIORITY_TIMER 			700
#define FIRE_PRIORITY_TICKER			200	// Gameticker processing.
#define FIRE_PRIORITY_TGUI 				110
#define FIRE_PRIORITY_ASSETS 			108
#define FIRE_PRIORITY_EXPLOSIONS 		105 // Explosions!
#define FIRE_PRIORITY_THROWING 			106 // Throwing! after explosions since they influence throw direction
#define FIRE_PRIORITY_HUMAN				101	// Human Life().
#define FIRE_PRIORITY_MOB				100	// Non-human Mob Life().
#define FIRE_PRIORITY_CHAT				99 // Chat subsystem.
#define FIRE_PRIORITY_STATPANEL			95 // Statpanel subsystem.
#define FIRE_PRIORITY_MACHINERY			92	// Machinery + powernet ticks.
#define FIRE_PRIORITY_PLANTS			91	// Spreading vine effects.
#define FIRE_PRIORITY_I_WOUNDS			90	// Internal wounds processing.
#define FIRE_PRIORITY_AIR				80	// ZAS processing.
#define FIRE_PRIORITY_ALARM				20	// Alarm processing.
#define FIRE_PRIORITY_EVENT				20	// Event processing.
#define FIRE_PRIORITY_SHUTTLE			20	// Shuttle movement.
#define FIRE_PRIORITY_AIRFLOW			15	// Object movement from ZAS airflow.
#define FIRE_PRIORITY_INACTIVITY_AND_JOB_TRACKING		10	// Idle kicking.
#define FIRE_PRIORITY_SUPPLY			10	// Supply point accumulation.
#define FIRE_PRIORITY_PING				10	// Client ping.
#define FIRE_PRIORITY_TICKETS			10

// SS_BACKGROUND
#define FIRE_PRIORITY_OBJECTS       40	// processing_objects processing.
#define FIRE_PRIORITY_PROCESSING    30	// Generic datum processor. Replaces objects processor.
#define FIRE_PRIORITY_GARBAGE       25	// Garbage collection.
#define FIRE_PRIORITY_VINES         25	// Spreading vine effects.
#define FIRE_PRIORITY_TURF          20	// Radioactive walls/blob.
#define FIRE_PRIORITY_NANO          20	// Updates to nanoui uis.
#define FIRE_PRIORITY_EVAC          20	// Processes the evac controller.
#define FIRE_PRIORITY_WIRELESS      10	// Wireless connection setup.
#define FIRE_PRIORITY_TIPS          10	// Tips and tricks manager.
