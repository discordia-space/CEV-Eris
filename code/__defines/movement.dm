#define MOVE_DELAY_BASE 1.1

//Glidesize
#define FRACTIONAL_GLIDESIZES 1
#ifdef FRACTIONAL_GLIDESIZES
#define DELAY2GLIDESIZE(delay) (world.icon_size / max(Ceiling(delay / world.tick_lag), 1))
#else
#define DELAY2GLIDESIZE(delay) (Ceiling(world.icon_size / max(Ceiling(delay / world.tick_lag), 1)))
#endif


#define JETPACK_MOVE_COST	0.025


#define HAS_TRANSFORMATION_MOVEMENT_HANDLER(X) X.HasMovementHandler(/datum/movement_handler/mob/transformation)
#define ADD_TRANSFORMATION_MOVEMENT_HANDLER(X) X.AddMovementHandler(/datum/movement_handler/mob/transformation)
#define DEL_TRANSFORMATION_MOVEMENT_HANDLER(X) X.RemoveMovementHandler(/datum/movement_handler/mob/transformation)

#define MOVING_DELIBERATELY(X) (X.move_intent.flags & MOVE_INTENT_DELIBERATE)
#define MOVING_QUICKLY(X) (X.move_intent.flags & MOVE_INTENT_QUICK)