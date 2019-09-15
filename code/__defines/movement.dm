#define MOVE_DELAY_BASE 1.1

//Glidesize
#define FRACTIONAL_GLIDESIZES 1
#ifdef FRACTIONAL_GLIDESIZES
#define DELAY2GLIDESIZE(delay) (world.icon_size / max(CEILING(delay / world.tick_lag, 1), 1))
#else
#define DELAY2GLIDESIZE(delay) (CEILING(world.icon_size / max(CEILING(delay / world.tick_lag, 1), 1)))
#endif


#define JETPACK_MOVE_COST	0.025


#define HAS_TRANSFORMATION_MOVEMENT_HANDLER(X) X.HasMovementHandler(/datum/movement_handler/mob/transformation)
#define ADD_TRANSFORMATION_MOVEMENT_HANDLER(X) X.AddMovementHandler(/datum/movement_handler/mob/transformation)
#define DEL_TRANSFORMATION_MOVEMENT_HANDLER(X) X.RemoveMovementHandler(/datum/movement_handler/mob/transformation)


// Quick and deliberate movements are not necessarily mutually exclusive
#define MOVE_INTENT_DELIBERATE 0x0001
#define MOVE_INTENT_EXERTIVE   0x0002
#define MOVE_INTENT_QUICK      0x0004

#define MOVING_DELIBERATELY(X) (X.move_intent.flags & MOVE_INTENT_DELIBERATE)
#define MOVING_QUICKLY(X) (X.move_intent.flags & MOVE_INTENT_QUICK)