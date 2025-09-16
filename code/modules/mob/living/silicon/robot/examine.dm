/mob/living/silicon/robot/examine(mob/user, extra_description = "")
	extra_description += "<span class='warning'>"
	if(getBruteLoss())
		if(getBruteLoss() < 75)
			extra_description += "It looks slightly dented.\n"
		else
			extra_description += "<B>It looks severely dented!</B>\n"
	if(getFireLoss())
		if(getFireLoss() < 75)
			extra_description += "It looks slightly charred.\n"
		else
			extra_description += "<B>It looks severely burnt and heat-warped!</B>\n"
	extra_description += "</span>"

	if(opened)
		extra_description += "[span_warning("Its cover is open and the power cell is [cell ? "installed" : "missing"].")]\n"
	else
		extra_description += "Its cover is closed.\n"

	if(!has_power)
		extra_description += "[span_warning("It appears to be running on backup power.")]\n"

	switch(stat)
		if(CONSCIOUS)
			if(!client)
				extra_description += "It appears to be in stand-by mode.\n" //afk
		if(UNCONSCIOUS)
			extra_description += "[span_warning("It doesn't seem to be responding.")]\n"
		if(DEAD)
			extra_description += "[span_deadsay("It's completely broken, but looks repairable.")]\n" //TODO: add no_soul status or flag
	if(module_active)
		extra_description += "It is wielding [icon2html(module_active, user)] [module_active].\n"
	extra_description += "*---------*"

	if(get_flavor_text()) extra_description += "\n[get_flavor_text()]\n"

	if(pose)
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		extra_description += "\nIt is [pose]"

	..(user, extra_description)
	user.showLaws(src)
