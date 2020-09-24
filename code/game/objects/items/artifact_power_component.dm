/**
  * This component handles artifact power for the Technomancer's Matter NanoForge 
  *
*/

/datum/component/artifact_power
    var/power
/datum/component/artifact_power/Initialize()
    if(!istype(parent, /obj/item))
        return COMPONENT_INCOMPATIBLE
/datum/component/artifact_power/RegisterWithParent()
    RegisterSignal(parent, COMSIG_EXAMINE, .proc/on_examine)

/datum/component/artifact_power/proc/on_examine(var/mob/user)
    for(var/stat in stats)
        var/aspect 
        switch(stats[STAT_MEC])
            if(1 to 3)
                aspect = "a weak catalyst power"
                power = 1
            if(3 to 5)
                aspect = "a normal catalyst power"
                power = 2
            if(5 to 7)
                aspect = "a medium catalyst power"
                power = 3
            if(7 to INFINITY)
                aspect = "a strong catalyst power"
                power = 4
            else 
                continue
        to_chat(user, SPAN_NOTICE("This item has [aspect]"))

/datum/component/artifact_power/proc/return_power()
    if(power)
        return power
    else
        return 0
    