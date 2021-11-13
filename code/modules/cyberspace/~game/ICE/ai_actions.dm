/mob/observer/cyber_entity/IceHolder/proc/getPotentialTargets()
	if(!istype(loc, /turf))
		return
	return CyberRange(viewRange)

/mob/observer/cyber_entity/IceHolder/proc/findTarget()
	var/list/filteredTargets = list()

	for(var/atom/O in getPotentialTargets())
		if(isValidAttackTarget(O))
			filteredTargets += O

	return safepick(nearestObjectsInList(filteredTargets, src, viewRange))

/mob/observer/cyber_entity/IceHolder/proc/attemptAttackOnTarget()
	if(get_dist(src, target_mob) <= attack_range && istype(CyberAvatar.Subroutines))
		return TriggerSubroutines(\
			CyberAvatar.Subroutines.Attack,\
			SUBROUTINE_ATTACK,\
			target_mob.CyberAvatar,\
			CyberAvatar\
			)

/mob/observer/cyber_entity/IceHolder/proc/prepareAttackOnTarget()
	if(\
		!target_mob || !isValidAttackTarget(target_mob)\
		||\
		(get_dist(src, target_mob) >= viewRange) || z != target_mob.z\
		||\
		CyberAvatar.Subroutines.IsAllSubroutinesLocked(CyberAvatar.Subroutines.Attack)\
	)
		loseTarget()
		return

	attemptAttackOnTarget()

/mob/observer/cyber_entity/IceHolder/proc/loseTarget()
	walk(src, 0)
	target_mob = null
	stance = ICE_STANCE_OVERWATCH

/mob/observer/cyber_entity/IceHolder/CheckAccess(obj/machinery/power/apc/A)
	. = !Hacked && (MyFirewall == A)

/mob/observer/cyber_entity/IceHolder/proc/isValidAttackTarget(var/atom/O)
	if(istype(O, /mob/observer/cyber_entity) && O != src)
		var/mob/observer/cyber_entity/L = O
		if(istype(L, /mob/observer/cyber_entity/IceHolder))
			var/mob/observer/cyber_entity/IceHolder/I = O
			if(I.stance == ICE_STANCE_DEAD)
				return
		if(Hacked || !MyFirewall?.CheckCyberAccess(L)) // If runner hacked ICE then it disconected from firewall and attack EVERYTHING
			return 1
/*
	if(istype(O, /mob/living/exosuit))
		var/mob/living/exosuit/M = O
		return isValidAttackTarget(M.pilots[1])
*/
