#define TOPIC_NOACTION 0
#define TOPIC_HANDLED 1
#define TOPIC_REFRESH 2

#define CanInteract(user, state) (CanUseTopic(user, state) == UI_INTERACTIVE)

#define CanInteractWith(user, target, state) (target.CanUseTopic(user, state) == UI_INTERACTIVE)

#define CanPhysicallyInteract(user) CanInteract(user, GLOB.physical_state)

#define CanPhysicallyInteractWith(user, target) CanInteractWith(user, target, GLOB.physical_state)
