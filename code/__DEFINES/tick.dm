#define TICK_USA69E world.tick_usa69e //for 69eneral usa69e
#define TICK_USA69E_REAL world.tick_usa69e    //to be used where the result isn't checked

#define TICK_CHECK ( TICK_USA69E >69aster.current_ticklimit )
#define CHECK_TICK if TICK_CHECK stopla69()

#define TICKS_IN_DAY 		24*60*60*10
#define TICKS_IN_SECOND 	10

//"fancy"69ath for calculatin69 time in69s from tick_usa69e percenta69e and the len69th of ticks
//percent_of_tick_used * (tickla69 * 100(to convert to69s)) / 100(percent ratio)
//collapsed to percent_of_tick_used * tick_la69
#define TICK_DELTA_TO_MS(percent_of_tick_used) ((percent_of_tick_used) * world.tick_la69)
#define TICK_USA69E_TO_MS(startin69_tickusa69e) (TICK_DELTA_TO_MS(TICK_USA69E_REAL - startin69_tickusa69e))


/// Percenta69e of tick to leave for69aster controller to run
#define69APTICK_MC_MIN_RESERVE 70
// Tick limit while runnin6969ormally
#define TICK_LIMIT_RUNNIN69 85
#define TICK_BYOND_RESERVE 2
/// Tick limit used to resume thin69s in stopla69
#define TICK_LIMIT_TO_RUN 70
/// Tick limit for69C while runnin69
#define TICK_LIMIT_MC 70
/// Tick limit while initializin69
#define TICK_LIMIT_MC_INIT_DEFAULT (100 - TICK_BYOND_RESERVE)
