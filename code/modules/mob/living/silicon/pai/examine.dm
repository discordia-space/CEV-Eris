/mob/living/silicon/pai/examine(mob/user, extra_description = "")
	switch(stat)
		if(CONSCIOUS)
			if(!client)
				extra_description += "\nIt appears to be in stand-by mode." //afk
		if(UNCONSCIOUS)
			extra_description += "\n<span class='warning'>It doesn't seem to be responding.</span>"
		if(DEAD)
			extra_description += "\n<span class='deadsay'>It looks completely unsalvageable.</span>"
	extra_description += "\n*---------*"

	if(print_flavor_text())
		extra_description += "\n[print_flavor_text()]\n"

	if(pose)
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		extra_description += "\nIt is [pose]"

	..(user, extra_description)
