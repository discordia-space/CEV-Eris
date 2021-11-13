/*
This file is not related to in-game Artificial Intelligence.
This is the ice bot system.
*/

#define TACTIC_GUARD 1
#define TACTIC_KILL_EM_ALL 2

/datum/CyberSpaceAvatar
	var/Faction = null // The Placeholder for identifing ices between selfs
	var/Tactic = null // Should be replaced with datums
	var/VisionRange = 4
	var/tmp/atom/target

/datum/CyberSpaceAvatar/Proccess(wait, times_fired, controller) //TODO for sentry AI
	if(Tactic)
		var/distanceToTarget = VisionRange
		for(var/mob/i in orange(VisionRange))
			if(i.CyberAvatar)
				var/distanceToI = get_dist(i, src)
				if(distanceToI < distanceToTarget)
					distanceToTarget = distanceToI
					target = i

	
		if(
			istype(target)
			&&
			!(Tactic == TACTIC_GUARD && distanceToTarget < round(VisionRange / 2))
			&&
			!Owner.Move(get_dir(src, target))
			&& Subroutines
		)
			var/turf/problem = get_step(Owner, get_dir(Owner, target))
			var/list/PROBLEMEMES = GetDenseCyberspaceAvatars(problem)
			for(var/datum/CyberSpaceAvatar/A in PROBLEMEMES)
				RaiseSubroutines(Subroutines.EnemyIceAttack, SUBROUTINE_ANOTHERICE, A)
