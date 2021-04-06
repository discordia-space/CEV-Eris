/datum/CyberSpaceAvatar/ice
	var/list/subroutines = list()

/datum/CyberSpaceAvatar/ice/proc/Trigger(datum/CyberSpaceAvatar/TriggeredOn, ...)
	for(var/datum/subroutine/s in subroutines)
		s.Trigger(arglist(args))
