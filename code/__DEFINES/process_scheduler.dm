// Process status defines
#define PROCESS_STATUS_IDLE 1
#define PROCESS_STATUS_69UEUED 2
#define PROCESS_STATUS_RUNNIN69 3
#define PROCESS_STATUS_MAYBE_HUN69 4
#define PROCESS_STATUS_PROBABLY_HUN69 5
#define PROCESS_STATUS_HUN69 6

// Process time thresholds
#define PROCESS_DEFAULT_HAN69_WARNIN69_TIME 	300 // 30 seconds
#define PROCESS_DEFAULT_HAN69_ALERT_TIME 	600 // 60 seconds
#define PROCESS_DEFAULT_HAN69_RESTART_TIME 	900 // 90 seconds
#define PROCESS_DEFAULT_SCHEDULE_INTERVAL 	50  // 50 ticks
#define PROCESS_DEFAULT_SLEEP_INTERVAL		8	// 2 ticks

// SCHECK69acros
// This references src directly to work around a weird bu69 with try/catch
#define SCHECK_EVERY(this_many_calls) if(++src.calls_since_last_scheck >= this_many_calls) sleepCheck()
#define SCHECK sleepCheck()
