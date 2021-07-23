/datum/movement_handler/mob/incorporeal/cyberspace/DoMove(direction, mob/mover, is_external)
	var/turf/movedTo = get_step(mover, direction)

	var/list/collidedAvatars = GetDenseCyberspaceAvatars(movedTo)

	if(islist(collidedAvatars) && length(collidedAvatars))
		for(var/datum/CyberSpaceAvatar/CA in collidedAvatars)
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
