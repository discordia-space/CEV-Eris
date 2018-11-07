#define MOVE_DELAY_BASE 1.1

//Glidesize
#define FRACTIONAL_GLIDESIZES 1
#ifdef FRACTIONAL_GLIDESIZES
#define DELAY2GLIDESIZE(delay) (WORLD_ICON_SIZE / max(Ceiling(delay / world.tick_lag), 1))
#else
#define DELAY2GLIDESIZE(delay) (Ceiling(WORLD_ICON_SIZE / max(Ceiling(delay / world.tick_lag), 1)))
#endif 