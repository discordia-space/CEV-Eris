/*
A powerful 64x64 roach can spawn in any burrow in maints. 
While emerging from it, it will bring a rich trash piles with him (gun and science loot),
that will populate floors around burrow itself. 
It will also bring a hoard of roaches with it. 
*/

/datum/storyevent/kaiser
    id = "kaiser"
    name = "kaiser"

    weight = 1

    event_type = /datum/event/kaiser
    event_pools = list(
        EVENT_LEVEL_MUNDANE     = POOL_THRESHOLD_MUNDANE * 1.2,
        EVENT_LEVEL_MODERATE    = POOL_THRESHOLD_MODERATE * 1.2,
        EVENT_LEVEL_MAJOR       = POOL_THRESHOLD_MAJOR * 1.2)
    tags = list(TAG_COMBAT, TAG_NEGATIVE)

/datum/event/kaiser
    startWhen = 1
    announceWhen = 0
    endWhen = 0
    var/failure
//    var/kaiser_burrow // A burrow where Kaiser roach and loot will be spawned

/datum/event/kaiser/can_trigger()
    if(!all_burrows.len)
        log_and_message_admins("Kaiser spawn failed: no burrows detected.")
        return FALSE
    return TRUE

/datum/event/kaiser/setup()
//    var/obj/structure/burrow/kaiser_burrow = pick(all_burrows)

/datum/event/kaiser/start()
    // TODO: Create start

/datum/event/kaiser/end()
    // TODO: do something

/datum/event/kaiser/proc/spawn_mobs()
    
