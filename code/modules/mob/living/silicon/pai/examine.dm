/mob/living/silicon/pai/examine(mob/user, extra_description = "")
	switch(stat)
		if(CONSCIOUS)
			if(!client)
				extra_description += "\nIt appears to be in stand-by mode." //afk
		if(UNCONSCIOUS)
			extra_description += "\n[span_warning("It doesn't seem to be responding.")]"
		if(DEAD)
			extra_description += "\n[span_deadsay("It looks completely unsalvageable.")]"
	extra_description += "\n*---------*"

	if(get_flavor_text())
		extra_description += "\n[get_flavor_text()]\n"

	if(pose)
		if( findtext(pose,".",length(pose)) == 0 && findtext(pose,"!",length(pose)) == 0 && findtext(pose,"?",length(pose)) == 0 )
			pose = addtext(pose,".") //Makes sure all emotes end with a period.
		extra_description += "\nIt is [pose]"

	..(user, extra_description)
