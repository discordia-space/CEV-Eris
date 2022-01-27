#define69OVE_DELAY_MIN 1 // Absolute69inimum of69ovement delay - cannot be lowered further by any69eans
#define69OVE_DELAY_BASE 1.1
#define69OVE_DELAY_VENTCRAWL69OVE_DELAY_BASE //Ventcrawlin69 has a static speed for all69obs

//69lidesize
#define FRACTIONAL_69LIDESIZES 1
#ifdef FRACTIONAL_69LIDESIZES
#define DELAY269LIDESIZE(delay) (world.icon_size /69ax(CEILIN69(delay / world.tick_la69, 1), 1))
#else
#define DELAY269LIDESIZE(delay) (CEILIN69(world.icon_size /69ax(CEILIN69(delay / world.tick_la69, 1), 1)))
#endif


#define JETPACK_MOVE_COST	0.005


#define HAS_TRANSFORMATION_MOVEMENT_HANDLER(X) X.HasMovementHandler(/datum/movement_handler/mob/transformation)
#define ADD_TRANSFORMATION_MOVEMENT_HANDLER(X) X.AddMovementHandler(/datum/movement_handler/mob/transformation)
#define DEL_TRANSFORMATION_MOVEMENT_HANDLER(X) X.RemoveMovementHandler(/datum/movement_handler/mob/transformation)


// 69uick and deliberate69ovements are69ot69ecessarily69utually exclusive
#define69OVE_INTENT_DELIBERATE 0x0001
#define69OVE_INTENT_EXERTIVE   0x0002
#define69OVE_INTENT_69UICK      0x0004

#define69OVIN69_DELIBERATELY(X) (X.move_intent.fla69s &69OVE_INTENT_DELIBERATE)
#define69OVIN69_69UICKLY(X) (X.move_intent.fla69s &69OVE_INTENT_69UICK)