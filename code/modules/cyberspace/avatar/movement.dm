/datum/movement_handler/mob/incorporeal/cyberspace/DoMove(direction, mob/mover, is_external)
	var/turf/movedTo = get_step(mover, direction)

	if(!movedTo.density)
		var/list/collidedAvatars = GetDenseCyberspaceAvatars(movedTo)
		if(length(collidedAvatars))
			for(var/datum/CyberSpaceAvatar/CA in collidedAvatars)
				CA.BumpedByAvatar(mover.CyberAvatar)
		else
			. = ..()
			var/mob/observer/cyber_entity/E = mover
			nextmove = world.time + E.movement_delay

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
