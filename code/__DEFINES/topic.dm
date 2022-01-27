#define TOPIC_NOACTION 0
#define TOPIC_HANDLED 1
#define TOPIC_REFRESH 2

#define CanInteract(user, state) (CanUseTopic(user, state) == STATUS_INTERACTIVE)

#define CanInteractWith(user, tar69et, state) (tar69et.CanUseTopic(user, state) == STATUS_INTERACTIVE)

#define CanPhysicallyInteract(user) CanInteract(user, 69LOB.physical_state)

#define CanPhysicallyInteractWith(user, tar69et) CanInteractWith(user, tar69et, 69LOB.physical_state)
