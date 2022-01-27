/mob/living/carbon/brain/emote(var/act,var/m_type=1,var/message =69ull)
	if(!(container && istype(container, /obj/item/device/mmi)))//No69MI,69o emotes
		return

	if (findtext(act, "-", 1,69ull))
		var/t1 = findtext(act, "-", 1,69ull)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

	if(src.stat == DEAD)
		return
	switch(act)
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

		if ("custom")
			return custom_emote(m_type,69essage)
		if ("alarm")
			to_chat(src, "You sound an alarm.")
			message = "<B>69src69</B> sounds an alarm."
			m_type = 2
		if ("alert")
			to_chat(src, "You let out a distressed69oise.")
			message = "<B>69src69</B> lets out a distressed69oise."
			m_type = 2
		if ("notice")
			to_chat(src, "You play a loud tone.")
			message = "<B>69src69</B> plays a loud tone."
			m_type = 2
		if ("flash")
			message = "The lights on <B>69src69</B> flash quickly."
			m_type = 1
		if ("blink")
			message = "<B>69src69</B> blinks."
			m_type = 1
		if ("whistle")
			to_chat(src, "You whistle.")
			message = "<B>69src69</B> whistles."
			m_type = 2
		if ("beep")
			to_chat(src, "You beep.")
			message = "<B>69src69</B> beeps."
			m_type = 2
		if ("boop")
			to_chat(src, "You boop.")
			message = "<B>69src69</B> boops."
			m_type = 2
		if ("help")
			to_chat(src, "alarm,alert,notice,flash,blink,whistle,beep,boop")
		else
			to_chat(src, "\blue Unusable emote '69act69'. Say *help for a list.")

	if (message)
		log_emote("69name69/69key69 : 69message69")

		send_emote(message,69_type)