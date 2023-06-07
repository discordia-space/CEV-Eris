// Something to remember when setting priorities: SS_TICKER runs before Normal, which runs before SS_BACKGROUND.
// Each group has its own priority bracket.
// SS_BACKGROUND handles high server load differently than Normal and SS_TICKER do.
// Higher priority also means a larger share of a given tick before sleep checks.

// SS_TICKER
// < none >

var/list/bitflags = list(1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768)

#define SS_PRIORITY_DEFAULT 50          // Default priority for both normal and background processes

// Normal
#define FIRE_PRIORITY_DELAYED_VERBS 950
#define FIRE_PRIORITY_TIMER 700
#define SS_PRIORITY_TICKER			200	// Gameticker processing.
#define FIRE_PRIORITY_TGUI 110
#define FIRE_PRIORITY_EXPLOSIONS 105 // Explosions!
#define FIRE_PRIORITY_THROWING 106 // Throwing! after explosions since they influence throw direction
#define SS_PRIORITY_HUMAN			101	// Human Life().
#define SS_PRIORITY_MOB				100	// Non-human Mob Life().
#define SS_PRIORITY_CHAT			100 // Chat subsystem.
#define SS_PRIORITY_MACHINERY		100	// Machinery + powernet ticks.
#define SS_PRIORITY_I_WOUNDS		99	// Internal wounds processing.
#define SS_PRIORITY_AIR				80	// ZAS processing.
#define SS_PRIORITY_ALARM			20	// Alarm processing.
#define SS_PRIORITY_EVENT			20	// Event processing.
#define SS_PRIORITY_SHUTTLE			20	// Shuttle movement.
#define SS_PRIORITY_AIRFLOW			15	// Object movement from ZAS airflow.
#define SS_PRIORITY_INACTIVITY_AND_JOB_TRACKING		10	// Idle kicking.
#define SS_PRIORITY_SUPPLY			10	// Supply point accumulation.
#define SS_PRIORITY_PING			10	// Client ping.
#define SS_PRIORITY_TICKETS			10

// SS_BACKGROUND
#define SS_PRIORITY_OBJECTS       40	// processing_objects processing.
#define SS_PRIORITY_PROCESSING    30	// Generic datum processor. Replaces objects processor.
#define SS_PRIORITY_GARBAGE       25	// Garbage collection.
#define SS_PRIORITY_VINES         25	// Spreading vine effects.
#define SS_PRIORITY_TURF          20	// Radioactive walls/blob.
#define SS_PRIORITY_NANO          20	// Updates to nanoui uis.
#define SS_PRIORITY_EVAC          20	// Processes the evac controller.
#define SS_PRIORITY_WIRELESS      10	// Wireless connection setup.
#define SS_PRIORITY_TIPS          10	// Tips and tricks manager.
