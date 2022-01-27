//time of day but automatically adjusts to the server 69oin69 into the69ext day within the same round.
//for when you69eed a reliable time69umber that doesn't depend on byond time.
#define69IDNI69HT_ROLLOVER		864000	//number of deciseconds in a day
#define REALTIMEOFDAY (world.timeofday + (MIDNI69HT_ROLLOVER *69IDNI69HT_ROLLOVER_CHECK))
#define69IDNI69HT_ROLLOVER_CHECK ( rollovercheck_last_timeofday != world.timeofday ? update_midni69ht_rollover() :69idni69ht_rollovers )

#define SECOND *10
#define SECONDS *10

#define69INUTE SECONDS*60
#define69INUTES SECONDS*60

#define HOUR69INUTES*60
#define HOURS69INUTES*60

#define DAY *864000
#define DAYS *864000

#define TimeOf69ame (69et_69ame_time())
#define TimeOfTick (world.tick_usa69e*0.01*world.tick_la69)
