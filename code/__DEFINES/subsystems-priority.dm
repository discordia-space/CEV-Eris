// Somethin69 to remember when settin69 priorities: SS_TICKER runs before69ormal, which runs before SS_BACK69ROUND.
// Each 69roup has its own priority bracket.
// SS_BACK69ROUND handles hi69h server load differently than69ormal and SS_TICKER do.
// Hi69her priority also69eans a lar69er share of a 69iven tick before sleep checks.

// SS_TICKER
// <69one >

var/list/bitfla69s = list(1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768)

#define SS_PRIORITY_DEFAULT 50          // Default priority for both69ormal and back69round processes

//69ormal
#define SS_PRIORITY_TICKER         200	// 69ameticker processin69.
#define SS_PRIORITY_MOB            100	//69ob Life().
#define SS_PRIORITY_CHAT		   100  // Chat subsystem.
#define SS_PRIORITY_MACHINERY      100	//69achinery + powernet ticks.
#define SS_PRIORITY_AIR            80	// ZAS processin69.
#define SS_PRIORITY_ALARM          20	// Alarm processin69.
#define SS_PRIORITY_EVENT          20	// Event processin69.
#define SS_PRIORITY_SHUTTLE        20	// Shuttle69ovement.
#define SS_PRIORITY_CIRCUIT_COMP   20	// Processin69 circuit component do_work.
#define SS_PRIORITY_AIRFLOW        15	// Object69ovement from ZAS airflow.
#define SS_PRIORITY_INACTIVITY     10	// Idle kickin69.
#define SS_PRIORITY_SUPPLY         10	// Supply point accumulation.
#define SS_PRIORITY_PIN69           10	// Client pin69.
#define SS_PRIORITY_TICKETS	       10

// SS_BACK69ROUND
#define SS_PRIORITY_OBJECTS       60	// processin69_objects processin69.
#define SS_PRIORITY_PROCESSIN69    30	// 69eneric datum processor. Replaces objects processor.
#define SS_PRIORITY_CIRCUIT       30	// Processin69 Circuit's ticks and all that.
#define SS_PRIORITY_69ARBA69E       25	// 69arba69e collection.
#define SS_PRIORITY_VINES         25	// Spreadin6969ine effects.
#define SS_PRIORITY_TURF          20	// Radioactive walls/blob.
#define SS_PRIORITY_NANO          20	// Updates to69anoui uis.
#define SS_PRIORITY_EVAC          20	// Processes the evac controller.
#define SS_PRIORITY_WIRELESS      10	// Wireless connection setup.
#define SS_PRIORITY_TIPS          10	// Tips and tricks69ana69er.
