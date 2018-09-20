#define MOVE_DELAY_BASE 1.1

//Glidesize
#define FRACTIONAL_GLIDESIZES 1
#ifdef FRACTIONAL_GLIDESIZES
#define DELAY2GLIDESIZE(delay) (world.icon_size / max(Ceiling(delay / world.tick_lag), 1))
#else
#define DELAY2GLIDESIZE(delay) (Ceiling(world.icon_size / max(Ceiling(delay / world.tick_lag), 1)))
#endif


#define JETPACK_MOVE_COST	0.01