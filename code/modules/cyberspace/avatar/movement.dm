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

/mob/observer/cyber_entity/cyberspace_eye/AdjacentMouseDropTo(atom/target, mob/user, src_location, over_location, src_control, over_control, params)
	. = ..()
	if(istype(target, /turf) && target.density)
		var/timeToPass = 2 SECONDS
		if(istype(owner))
			var/mob/living/carbon/human/H = owner.get_user()
			if(istype(H))
				timeToPass *= 80 / max(H.stats.getStat(STAT_COG), 10)
		if(do_after(src, timeToPass, target, needhand = FALSE, incapacitation_flags = INCAPACITATION_NONE) && Adjacent(target))
			Move(get_turf(target))

/proc/GetDenseCyberspaceAvatars(turf/T)
	. = list()
	for(var/atom/A in T)
		if(A.CyberAvatar)
			var/datum/CyberSpaceAvatar/CAtoCheck = A.CyberAvatar
			if(CAtoCheck.density)
				. += CAtoCheck
