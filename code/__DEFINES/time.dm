//time of day but automatically adjusts to the server going into the next day within the same round.
//for when you need a reliable time number that doesn't depend on byond time.
#define MIDNIGHT_ROLLOVER		864000	//number of deciseconds in a day
#define REALTIMEOFDAY (world.timeofday + (MIDNIGHT_ROLLOVER * MIDNIGHT_ROLLOVER_CHECK))
#define MIDNIGHT_ROLLOVER_CHECK ( rollovercheck_last_timeofday != world.timeofday ? update_midnight_rollover() : midnight_rollovers )

#define SECOND *10
#define SECONDS *10
#define SECOND SECONDS

#define MINUTE SECONDS*60
#define MINUTES SECONDS*60
#define MINUTE MINUTES

#define HOUR MINUTES*60
#define HOURS MINUTES*60
#define HOUR HOURS

#define DAY *864000
#define DAYS *864000
#define DAY DAYS

#define TimeOfGame (get_game_time())
#define TimeOfTick (world.tick_usage*0.01*world.tick_lag)
