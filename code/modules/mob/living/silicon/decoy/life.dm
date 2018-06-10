/mob/living/silicon/decoy/Life()
	if (src.stat == 2)
		return
	else
		if (src.health <= HEALTH_THRESHOLD_DEAD && src.stat != 2)
			death()
			return


/mob/living/silicon/decoy/updatehealth()
	if(status_flags & GODMODE)
		health = 100
		stat = CONSCIOUS
	else
		health = 100 - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss()
