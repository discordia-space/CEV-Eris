/datum/subroutine/attack
	TimeLocksFor = 5 SECONDS
/datum/subroutine/attack/Trigger(\
	datum/CyberSpaceAvatar/triggerer,\
	wayOfTrigger = SUBROUTINE_FAILED_TO_BREAK,\
	datum/CyberSpaceAvatar/host\
	)
	var/mob/observer/cyber_entity/user = host.Owner
	var/mob/observer/cyber_entity/T = triggerer.Owner
	if(T)
		. = T.ChangeHP(0, -user.Might)
		..()

/datum/subroutine/damageBrain
	TimeLocksFor = 5 SECONDS
	var/ForcedDamageValue

/datum/subroutine/damageBrain/Trigger(\
	datum/CyberSpaceAvatar/triggerer,\
	wayOfTrigger = SUBROUTINE_FAILED_TO_BREAK,\
	datum/CyberSpaceAvatar/host\
	)
	var/mob/observer/cyber_entity/user = host.Owner
	var/mob/observer/cyber_entity/cyberspace_eye/T = triggerer.Owner
	if(istype(T) && T.owner)
		var/mob/living/carbon/human/H = T.owner.get_user()
		. = H.adjustBrainLoss(ForcedDamageValue || user.Might)
		..()

/datum/subroutine/raise_alarm_level
	TimeLocksFor = 30 SECONDS
	var/value = 0.2
	var/distance = 7

/datum/subroutine/raise_alarm_level/Trigger(\
	datum/CyberSpaceAvatar/triggerer,\
	wayOfTrigger = SUBROUTINE_FAILED_TO_BREAK,\
	datum/CyberSpaceAvatar/host\
	)
//	if(wayOfTrigger == SUBROUTINE_SPOTTED && !(get_dist(triggerer.Owner, host.Owner) > distance))
//		return
	if(istype(host.Owner))
		host.Owner.RaiseAlarmLevelInArea(value)
		. = ..()
