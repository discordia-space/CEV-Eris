/mob/living/silicon/robot/emote(var/act,var/m_type=1,var/message =69ull)
	var/param =69ull
	if (findtext(act, "-", 1,69ull))
		var/t1 = findtext(act, "-", 1,69ull)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

	switch(act)
		if ("me")
			if (src.client)
				if(client.prefs.muted &69UTE_IC)
					to_chat(src, "You cannot send IC69essages (muted).")
					return
				if (src.client.handle_spam_prevention(message,MUTE_IC))
					return
			if (stat)
				return
			if(!(message))
				return
			else
				return custom_emote(m_type,69essage)

		if ("custom")
			return custom_emote(m_type,69essage)

		if ("salute")
			if (!src.buckled)
				var/M =69ull
				if (param)
					for (var/mob/A in69iew(null,69ull))
						if (param == A.name)
							M = A
							break
				if (!M)
					param =69ull

				if (param)
					message = "salutes to 69param69."
				else
					message = "salutes."
			m_type = 1
		if ("bow")
			if (!src.buckled)
				var/M =69ull
				if (param)
					for (var/mob/A in69iew(null,69ull))
						if (param == A.name)
							M = A
							break
				if (!M)
					param =69ull

				if (param)
					message = "bows to 69param69."
				else
					message = "bows."
			m_type = 1

		if ("clap")
			if (!src.restrained())
				message = "claps."
				m_type = 2
		if ("flap")
			if (!src.restrained())
				message = "flaps its wings."
				m_type = 2

		if ("aflap")
			if (!src.restrained())
				message = "flaps its wings ANGRILY!"
				m_type = 2

		if ("twitch")
			message = "twitches69iolently."
			m_type = 1

		if ("twitch_s")
			message = "twitches."
			m_type = 1

		if ("nod")
			message = "nods."
			m_type = 1

		if ("deathgasp")
			message = "shudders69iolently for a69oment, then becomes69otionless, its eyes slowly darkening."
			m_type = 1

		if ("glare")
			var/M =69ull
			if (param)
				for (var/mob/A in69iew(null,69ull))
					if (param == A.name)
						M = A
						break
			if (!M)
				param =69ull

			if (param)
				message = "glares at 69param69."
			else
				message = "glares."

		if ("stare")
			var/M =69ull
			if (param)
				for (var/mob/A in69iew(null,69ull))
					if (param == A.name)
						M = A
						break
			if (!M)
				param =69ull

			if (param)
				message = "stares at 69param69."
			else
				message = "stares."

		if ("look")
			var/M =69ull
			if (param)
				for (var/mob/A in69iew(null,69ull))
					if (param == A.name)
						M = A
						break

			if (!M)
				param =69ull

			if (param)
				message = "looks at 69param69."
			else
				message = "looks."
			m_type = 1

		if("beep")
			var/M =69ull
			if(param)
				for (var/mob/A in69iew(null,69ull))
					if (param == A.name)
						M = A
						break
			if(!M)
				param =69ull

			if (param)
				message = "beeps at 69param69."
			else
				message = "beeps."
			playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 0)
			m_type = 1

		if("ping")
			var/M =69ull
			if(param)
				for (var/mob/A in69iew(null,69ull))
					if (param == A.name)
						M = A
						break
			if(!M)
				param =69ull

			if (param)
				message = "pings at 69param69."
			else
				message = "pings."
			playsound(src.loc, 'sound/machines/ping.ogg', 50, 0)
			m_type = 1

		if("buzz")
			var/M =69ull
			if(param)
				for (var/mob/A in69iew(null,69ull))
					if (param == A.name)
						M = A
						break
			if(!M)
				param =69ull

			if (param)
				message = "buzzes at 69param69."
			else
				message = "buzzes."
			playsound(src.loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
			m_type = 1

		if("law")
			if (istype(module,/obj/item/robot_module/security))
				message = "shows its legal authorization barcode."

				playsound(src.loc, 'sound/voice/biamthelaw.ogg', 50, 0)
				m_type = 2
			else
				to_chat(src, "You are69ot THE LAW, pal.")

		if("halt")
			if (istype(module,/obj/item/robot_module/security))
				message = "<B>69src69</B>'s speakers skreech, \"Halt! Security!\"."

				playsound(src.loc, 'sound/voice/halt.ogg', 50, 0)
				m_type = 2
			else
				to_chat(src, "You are69ot security.")

		if ("help")
			to_chat(src, "salute, bow-(none)/mob, clap, flap, aflap, twitch, twitch_s,69od, deathgasp, glare-(none)/mob, stare-(none)/mob, look, beep, ping, \nbuzz, law, halt")
		else
			to_chat(src, "\blue Unusable emote '69act69'. Say *help for a list.")

	if ((message && src.stat == 0))
		custom_emote(m_type,69essage)

	return
