/**
  * This component handles artifact power for the Technomancer's Matter NanoForge
  *
*/

/datum/component/artifact_power
 	var/power
 	var/list/stats
/datum/component/artifact_power/Initialize(statistics)
	if(!istype(parent, /obj/item))
		return COMPONENT_INCOMPATIBLE
	if(islist(statistics))
		stats = statistics
	else
		return COMPONENT_INCOMPATIBLE
	switch(stats[STAT_MEC])
		if(1 to 3)
			power = 1
		if(3 to 5)
			power = 2
		if(5 to 7)
			power = 3
		if(7 to INFINITY)
			power = 4
/datum/component/artifact_power/RegisterWithParent()
	RegisterSignal(parent, COMSIG_EXAMINE, .proc/on_examine)

/datum/component/artifact_power/proc/on_examine(var/mob/user)
	var/aspect
	switch(stats[STAT_MEC])
		if(1 to 3)
			aspect = "a weak catalyst power"
		if(3 to 5)
			aspect = "a normal catalyst power"
		if(5 to 7)
			aspect = "a medium catalyst power"
		if(7 to INFINITY)
			aspect = "a strong catalyst power"
		else
			aspect = "no catalyst power"
	to_chat(user, SPAN_NOTICE("This item has [aspect]"))

/datum/component/artifact_power/proc/get_power()
	if(power)
		return power
	else
		return 0
