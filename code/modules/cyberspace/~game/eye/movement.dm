/mob/observer/cyberspace_eye
	movement_handlers = list(/datum/movement_handler/mob/incorporeal/cyberspace)

/datum/movement_handler/mob/incorporeal/cyberspace/DoMove(direction, mob/mover, is_external)
	var/turf/movedTo = get_step(mover, direction)

	var/list/denseAvatar = GetDenseCyberspaceAvatars(movedTo)

	if(islist(denseAvatar) && length(denseAvatar))
		for(var/datum/CyberSpaceAvatar/CA in denseAvatar)
			CA.BumpedBy(mover.CyberAvatar)
	else
		. = ..()

/proc/GetDenseCyberspaceAvatars(turf/T)
	. = list()
	for(var/atom/A in T)
		if(A.CyberAvatar)
			var/datum/CyberSpaceAvatar/CAtoCheck = A.CyberAvatar
			if(CAtoCheck.density)
				. += CAtoCheck
