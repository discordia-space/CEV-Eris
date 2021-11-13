/datum/subroutine/attack
	TimeLocksFor = 5 SECONDS
/datum/subroutine/attack/Trigger(\
	datum/CyberSpaceAvatar/triggerer,\
	wayOfTrigger = SUBROUTINE_FAILED_TO_BREAK,\
	datum/CyberSpaceAvatar/host\
	)
	. = ..()
	var/mob/observer/cyber_entity/user = host.Owner
	var/mob/observer/cyber_entity/T = triggerer.Owner
	if(T)
		return T.ChangeHP(0, -user.Might)

/datum/subroutine/damageBrain
	TimeLocksFor = 5 SECONDS
	var/ForcedDamageValue

/datum/subroutine/damageBrain/Trigger(\
	datum/CyberSpaceAvatar/triggerer,\
	wayOfTrigger = SUBROUTINE_FAILED_TO_BREAK,\
	datum/CyberSpaceAvatar/host\
	)
	. = ..()
	var/mob/observer/cyber_entity/user = host.Owner
	var/mob/observer/cyber_entity/cyberspace_eye/T = triggerer.Owner
	if(istype(T) && T.owner)
		var/mob/living/carbon/human/H = T.owner.get_user()
		return H.adjustBrainLoss(ForcedDamageValue || user.Might)
