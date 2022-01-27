/mob/living/carbon/slime/emote(var/act,69ar/m_type=1,69ar/message =69ull)

	if (findtext(act, "-", 1,69ull))
		var/t1 = findtext(act, "-", 1,69ull)
		//param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

	var/updateicon = 0

	switch(act) //Alphabetical please
		if ("me")
			if(silent)
				return
			if (src.client)
				if (client.prefs.muted &69UTE_IC)
					to_chat(src, "\red You cannot send IC69essages (muted).")
					return
				if (src.client.handle_spam_prevention(message,MUTE_IC))
					return
				if (stat)
					return
				if(!(message))
					return
				return custom_emote(m_type,69essage)
		if("bounce")
			message = "<B>The 69src.name69</B> bounces in place."
			m_type = 1

		if ("custom")
			return custom_emote(m_type,69essage)

		if("jiggle")
			message = "<B>The 69src.name69</B> jiggles!"
			m_type = 1

		if("light")
			message = "<B>The 69src.name69</B> lights up for a bit, then stops."
			m_type = 1

		if("moan")
			message = "<B>The 69src.name69</B>69oans."
			m_type = 2

		if("shiver")
			message = "<B>The 69src.name69</B> shivers."
			m_type = 2

		if("sway")
			message = "<B>The 69src.name69</B> sways around dizzily."
			m_type = 1

		if("twitch")
			message = "<B>The 69src.name69</B> twitches."
			m_type = 1

		if("vibrate")
			message = "<B>The 69src.name69</B>69ibrates!"
			m_type = 1

		if("nomood")
			mood =69ull
			updateicon = 1

		if("pout")
			mood = "pout"
			updateicon = 1

		if("sad")
			mood = "sad"
			updateicon = 1

		if("angry")
			mood = "angry"
			updateicon = 1

		if("frown")
			mood = "mischevous"
			updateicon = 1

		if("smile")
			mood = ":3"
			updateicon = 1

		if ("help") //This is an exception
			to_chat(src, "Help for slime emotes. You can use these emotes with say \"*emote\":\n\nbounce, custom, jiggle, light,69oan, shiver, sway, twitch,69ibrate. You can also set your face with: \n\nnomood, pout, sad, angry, frown, smile")

		else
			to_chat(src, "\blue Unusable emote '69act69'. Say *help for a list.")
	if ((message && src.stat == 0))
		send_emote(message,69_type)
	if(updateicon)
		regenerate_icons()
	return