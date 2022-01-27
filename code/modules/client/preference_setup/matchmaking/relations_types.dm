/datum/relation/friend
	name = "Friend"
	desc = "You have known the fellow for a while now, and you get along pretty well."
	incompatible = list(/datum/relation/enemy)

/datum/relation/friend/get_desc_string()
	return "69holder69 and 69other.holder69 seem to be on good terms."

/datum/relation/kid_friend
	name = "Childhood Friend"
	desc = "You have known them since you were both young."

/datum/relation/kid_friend/get_desc_string()
	return "69holder69 and 69other.holder69 knew each other when they were both young."

/datum/relation/kid_friend/get_candidates()
	var/list/creche = ..()
	var/mob/living/carbon/human/holdermob = holder.current

	if(istype(holdermob))
		for(var/datum/relation/kid in creche)
			var/mob/living/carbon/human/kidmob = kid.holder.current
			if(!istype(kidmob))
				continue
			if(abs(holdermob.age - kidmob.age) > 3)
				creche -= kid		//No creepers please, it's okay if the pool is small.
				continue
	return creche

/datum/relation/enemy
	name = "Enemy"
	desc = "You have known the fellow for a while now, and you really can't stand each other."
	incompatible = list(/datum/relation/friend)

/datum/relation/enemy/get_desc_string()
	return "69holder69 and 69other.holder69 do not get along well."

/datum/relation/had_crossed
	name = "Crossed"
	desc = "You have slighted them in the past, and they69ost likely hold a grudge against you."
	can_connect_to = list(/datum/relation/was_crossed)

/datum/relation/had_crossed/get_desc_string()
	return "Something has happened between 69holder69 and 69other.holder69 in the past, and 69other.holder69 is upset about it."

/datum/relation/was_crossed
	name = "Was Crossed"
	desc = "You have been slighted by them in the past, and you remember it."
	can_connect_to = list(/datum/relation/had_crossed)

/datum/relation/was_crossed/get_desc_string()
	return "Something has happened between 69holder69 and 69other.holder69 in the past, and 69holder69 is upset about it."

/datum/relation/rival
	name = "Rival"
	desc = "You are engaged in a constant struggle to show who's number one."

/datum/relation/rival/get_desc_string()
	return "69holder69 and 69other.holder69 are fiercely competitive towards one another."

/datum/relation/rival/get_candidates()
	var/list/rest = ..()
	var/list/best = list()
	var/list/good = list()
	for(var/datum/relation/R in rest)
		if(!R.holder.assigned_job || !holder.assigned_job)
			continue
		if(R.holder.assigned_job == holder.assigned_job)
			best += R
		if(R.holder.assigned_job.department_flag & holder.assigned_job.department_flag)
			good += R
	if(best.len)
		return best
	else if (good.len)
		return good
	return rest

/datum/relation/ex
	name = "Ex"
	desc = "You used to be romantically involved, but not anymore."

/datum/relation/ex/get_desc_string()
	return "69holder69 and 69other.holder69 used to be an item, but not anymore."