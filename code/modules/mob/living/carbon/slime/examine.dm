/mob/living/carbon/slime/examine(mob/user, extra_description = "")
	if(stat == DEAD)
		extra_description += "<span class='deadsay'>It is limp and unresponsive.</span>\n"
	else
		if(getBruteLoss())
			extra_description += "<span class='warning'>"
			if(getBruteLoss() < 40)
				extra_description += "It has some punctures in its flesh!"
			else
				extra_description += "<B>It has severe punctures and tears in its flesh!</B>"
			extra_description += "</span>\n"

		switch(powerlevel)
			if(2 to 3)
				extra_description += "It is flickering gently with a little electrical activity.\n"
			if(4 to 5)
				extra_description += "It is glowing gently with moderate levels of electrical activity.\n"
			if(6 to 9)
				extra_description += "<span class='warning'>It is glowing brightly with high levels of electrical activity.</span>\n"
			if(10)
				extra_description += "<span class='warning'><B>It is radiating with massive levels of electrical activity!</B></span>\n"

	extra_description += "*---------*"
	..(user, extra_description)
