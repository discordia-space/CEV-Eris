/mob/living/silicon/ai/examine(mob/user, extra_description = "")
	if(stat == DEAD)
		extra_description += "<span class='deadsay'>It appears to be powered-down.</span>\n"
	else
		extra_description += "<span class='warning'>"
		if(getBruteLoss())
			if(getBruteLoss() < 30)
				extra_description += "It looks slightly dented.\n"
			else
				extra_description += "<B>It looks severely dented!</B>\n"
		if(getFireLoss())
			if(getFireLoss() < 30)
				extra_description += "It looks slightly charred.\n"
			else
				extra_description += "<B>Its casing is melted and heat-warped!</B>\n"
		if(getOxyLoss() && (aiRestorePowerRoutine != 0 && !APU_power))
			if(getOxyLoss() > 175)
				extra_description += "<B>It seems to be running on backup power. Its display is blinking a \"BACKUP POWER CRITICAL\" warning.</B>\n"
			else if(getOxyLoss() > 100)
				extra_description += "<B>It seems to be running on backup power. Its display is blinking a \"BACKUP POWER LOW\" warning.</B>\n"
			else
				extra_description += "It seems to be running on backup power.\n"

		if(stat == UNCONSCIOUS)
			extra_description += "It is non-responsive and displaying the text: \"RUNTIME: Sensory Overload, stack 26/3\".\n"
		extra_description += "</span>"
	extra_description += "*---------*"
	if(hardware && (hardware.owner == src))
		extra_description += "<br>"
		extra_description += hardware.get_examine_desc()

	..(user, extra_description)
	user.showLaws(src)

/mob/proc/showLaws(var/mob/living/silicon/S)
	return

/mob/observer/ghost/showLaws(var/mob/living/silicon/S)
	if(antagHUD || is_admin(src))
		S.laws.show_laws(src)
