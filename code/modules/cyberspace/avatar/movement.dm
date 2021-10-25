/datum/movement_handler/mob/incorporeal/cyberspace/DoMove(direction, mob/mover, is_external)
	var/turf/movedTo = get_step(mover, direction)
	var/list/collidedAvatars = GetDenseCyberspaceAvatars(movedTo)

	if(!movedTo.density)
		if(length(collidedAvatars))
			for(var/datum/CyberSpaceAvatar/CA in collidedAvatars)
				CA.BumpedByAvatar(mover.CyberAvatar)
		else
			. = ..()
			if(mover.CyberAvatar.ListenToSurrounding)
				for(var/datum/CyberSpaceAvatar/A in GLOB.CyberListeners)
					if(get_dist(A.Owner, mover) <= world.view)
						A.AnotherAvatarFound(mover.CyberAvatar)
						mover.CyberAvatar.AnotherAvatarFound(A)
	else
		var/timeToPass = 2 SECONDS
	/*TODO
		if(istype(mover, /mob/observer/cyberspace_eye))
			var/mob/observer/cyberspace_eye/M = mover
			if(istype(M.owner))
				var/mob/living/carbon/human/H = M.owner.get_user(M)
				if(istype(H))
					timeToPass *= 80 / max(H.stats.getStat(STAT_COG), 10)
	*/
		if(do_after(mover, timeToPass, movedTo, needhand = FALSE, incapacitation_flags = INCAPACITATION_NONE))
			. = ..()

/proc/GetDenseCyberspaceAvatars(turf/T)
	. = list()
	for(var/atom/A in T)
		if(A.CyberAvatar)
			var/datum/CyberSpaceAvatar/CAtoCheck = A.CyberAvatar
			if(CAtoCheck.density)
				. += CAtoCheck
