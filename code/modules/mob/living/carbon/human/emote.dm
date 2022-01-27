/mob/living/carbon/human/emote(var/act,var/m_type=1,var/message =69ull)
	var/param =69ull

	if (findtext(act, "-", 1,69ull))
		var/t1 = findtext(act, "-", 1,69ull)
		param = copytext(act, t1 + 1, length(act) + 1)
		act = copytext(act, 1, t1)

	if(findtext(act,"s",-1) && !findtext(act,"_",-2))//Removes ending s's unless they are prefixed with a '_'
		act = copytext(act,1,length(act))

	var/muzzled = istype(src.wear_mask, /obj/item/clothing/mask/muzzle) || istype(src.wear_mask, /obj/item/grenade)
	//var/m_type = 1

	for (var/obj/item/implant/I in src)
		if (I.implanted)
			I.trigger(act, src)

	if(src.stat == 2 && (act != "deathgasp"))
		return

	var/cloud_emote = ""

	switch(act)
		if ("airguitar")
			if (!src.restrained())
				message = "is strumming the air and headbanging like a safari chimp."
				m_type = 1

		if ("blink")
			message = "blinks."
			m_type = 1

		if ("blink_r")
			message = "blinks rapidly."
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

		if ("custom")
			var/input = sanitize(input("Choose an emote to display.") as text|null)
			if (!input)
				return
			var/input2 = input("Is this a69isible or hearable emote?") in list("Visible","Hearable")
			if (input2 == "Visible")
				m_type = 1
			else if (input2 == "Hearable")
				if (src.miming)
					return
				m_type = 2
			else
				alert("Unable to use this emote,69ust be either hearable or69isible.")
				return
			return custom_emote(m_type,69essage)

		if ("me")

			//if(silent && silent > 0 && findtext(message,"\"",1,69ull) > 0)
			//	return //This check does69ot work and I have69o idea why, I'm leaving it in for reference.

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

		if("pain")
			if(!message)
				if(miming)
					message = "appears to be in pain!"
					m_type = 1 // Can't we get defines for these?
				else
					message = "twists in pain."
					m_type = 1

			cloud_emote = "cloud-pain"

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

		if ("choke")
			if(miming)
				message = "clutches 69get_visible_gender() ==69ALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"69 throat desperately!"
				m_type = 1
			else
				if (!muzzled)
					message = "chokes!"
					m_type = 2
				else
					message = "makes a strong69oise."
					m_type = 2

		if ("clap")
			if (!src.restrained())
				message = "claps."
				m_type = 2
				if(miming)
					m_type = 1
		if ("flap")
			if (!src.restrained())
				message = "flaps 69get_visible_gender() ==69ALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"69 wings."
				m_type = 2
				if(miming)
					m_type = 1

		if ("aflap")
			if (!src.restrained())
				message = "flaps 69get_visible_gender() ==69ALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"69 wings ANGRILY!"
				m_type = 2
				if(miming)
					m_type = 1

		if ("drool")
			message = "drools."
			m_type = 1

		if ("eyebrow")
			message = "raises an eyebrow."
			m_type = 1

		if ("chuckle")
			if(miming)
				message = "appears to chuckle."
				m_type = 1
			else
				if (!muzzled)
					message = "chuckles."
					m_type = 2
				else
					message = "makes a69oise."
					m_type = 2

		if ("twitch")
			message = "twitches69iolently."
			m_type = 1

		if ("twitch_s")
			message = "twitches."
			m_type = 1

		if ("faint")
			message = "faints."
			if(src.sleeping)
				return //Can't faint while asleep
			src.sleeping += 10 //Short-short69ap
			m_type = 1

		if ("cough")
			if(miming)
				message = "appears to cough!"
				m_type = 1
			else
				if (!muzzled)
					message = "coughs!"
					m_type = 2
				else
					message = "makes a strong69oise."
					m_type = 2

		if ("frown")
			message = "frowns."
			m_type = 1

		if ("nod")
			message = "nods."
			m_type = 1

		if ("blush")
			message = "blushes."
			m_type = 1

		if ("wave")
			message = "waves."
			m_type = 1

		if ("gasp")
			if(miming)
				message = "appears to be gasping!"
				m_type = 1
			else
				if (!muzzled)
					message = "gasps!"
					m_type = 2
				else
					message = "makes a weak69oise."
					m_type = 2
			cloud_emote = "cloud-gasp"

		if ("deathgasp")
			if(stats.getPerk(PERK_TERRIBLE_FATE))
				message = "their inert body emits a strange sensation and a cold invades your body. Their screams before dying recount in your69ind."
			else
				message = "69species.death_message69"
			m_type = 1

		if ("giggle")
			if(miming)
				message = "giggles silently!"
				m_type = 1
			else
				if (!muzzled)
					message = "giggles."
					m_type = 2
				else
					message = "makes a69oise."
					m_type = 2

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

		if ("grin")
			message = "grins."
			m_type = 1

		if ("cry")
			if(miming)
				message = "cries."
				m_type = 1
			else
				if (!muzzled)
					message = "cries."
					m_type = 2
				else
					message = "makes a weak69oise. 69get_visible_gender() ==69ALE ? "He" : get_visible_gender() == FEMALE ? "She" : "They"69 69get_visible_gender() ==69EUTER ? "frown" : "frowns"69."
					m_type = 2

		if ("sigh")
			if(miming)
				message = "sighs."
				m_type = 1
			else
				if (!muzzled)
					message = "sighs."
					m_type = 2
				else
					message = "makes a weak69oise."
					m_type = 2

		if ("laugh")
			if(miming)
				message = "acts out a laugh."
				m_type = 1
			else
				if (!muzzled)
					message = "laughs."
					m_type = 2
				else
					message = "makes a69oise."
					m_type = 2

		if ("mumble")
			message = "mumbles!"
			m_type = 2
			if(miming)
				m_type = 1

		if ("grumble")
			if(miming)
				message = "grumbles!"
				m_type = 1
			if (!muzzled)
				message = "grumbles!"
				m_type = 2
			else
				message = "makes a69oise."
				m_type = 2

		if ("groan")
			if(miming)
				message = "appears to groan!"
				m_type = 1
			else
				if (!muzzled)
					message = "groans!"
					m_type = 2
				else
					message = "makes a loud69oise."
					m_type = 2

		if ("moan")
			if(miming)
				message = "appears to69oan!"
				m_type = 1
			else
				message = "moans!"
				m_type = 2

		if ("johnny")
			var/M
			if (param)
				M = param
			if (!M)
				param =69ull
			else
				if(miming)
					message = "takes a drag from a cigarette and blows \"69M69\" out in smoke."
					m_type = 1
				else
					message = "says, \"69M69, please. He had a family.\" 69src.name69 takes a drag from a cigarette and blows his69ame out in smoke."
					m_type = 2

		if ("point")
			if (!src.restrained())
				var/mob/M =69ull
				if (param)
					for (var/atom/A as69ob|obj|turf|area in69iew(null,69ull))
						if (param == A.name)
							M = A
							break

				if (!M)
					message = "points."
				else
					pointed(M)

				if (M)
					message = "points to 69M69."
				else
			m_type = 1

		if ("raise")
			if (!src.restrained())
				message = "raises a hand."
			m_type = 1

		if("shake")
			message = "shakes 69get_visible_gender() ==69ALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"69 head."
			m_type = 1

		if ("shrug")
			message = "shrugs."
			m_type = 1

		if ("signal")
			if (!src.restrained())
				var/t1 = round(text2num(param))
				if (isnum(t1))
					if (t1 <= 5 && (!src.r_hand || !src.l_hand))
						message = "raises 69t169 finger\s."
					else if (t1 <= 10 && (!src.r_hand && !src.l_hand))
						message = "raises 69t169 finger\s."
			m_type = 1

		if ("smile")
			message = "smiles."
			m_type = 1

		if ("shiver")
			message = "shivers."
			m_type = 2
			if(miming)
				m_type = 1

		if ("pale")
			message = "goes pale for a second."
			m_type = 1

		if ("tremble")
			message = "trembles in fear!"
			m_type = 1

		if ("sneeze")
			if (miming)
				message = "sneezes."
				m_type = 1
			else
				if (!muzzled)
					message = "sneezes."
					m_type = 2
				else
					message = "makes a strange69oise."
					m_type = 2

		if ("sniff")
			message = "sniffs."
			m_type = 2
			if(miming)
				m_type = 1

		if ("snore")
			if (miming)
				message = "sleeps soundly."
				m_type = 1
			else
				if (!muzzled)
					message = "snores."
					m_type = 2
				else
					message = "makes a69oise."
					m_type = 2

		if ("whimper")
			if (miming)
				message = "appears hurt."
				m_type = 1
			else
				if (!muzzled)
					message = "whimpers."
					m_type = 2
				else
					message = "makes a weak69oise."
					m_type = 2

		if ("wink")
			message = "winks."
			m_type = 1

		if ("yawn")
			if (!muzzled)
				message = "yawns."
				m_type = 2
				if(miming)
					m_type = 1

		if ("collapse")
			Paralyse(2)
			message = "collapses!"
			m_type = 2
			if(miming)
				m_type = 1

		if("hug")
			m_type = 1
			if (!src.restrained())
				var/M =69ull
				if (param)
					for (var/mob/A in69iew(1,69ull))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M =69ull

				if (M)
					message = "hugs 69M69."
				else
					message = "hugs 69get_visible_gender() ==69ALE ? "himself" : get_visible_gender() == FEMALE ? "herself" : "themselves"69."

		if ("handshake")
			m_type = 1
			if (!src.restrained() && !src.r_hand)
				var/mob/M =69ull
				if (param)
					for (var/mob/A in69iew(1,69ull))
						if (param == A.name)
							M = A
							break
				if (M == src)
					M =69ull

				if (M)
					if (M.canmove && !M.r_hand && !M.restrained())
						message = "shakes hands with 69M69."
					else
						message = "holds out 69get_visible_gender() ==69ALE ? "his" : get_visible_gender() == FEMALE ? "her" : "their"69 hand to 69M69."

		if("dap")
			m_type = 1
			if (!src.restrained())
				var/M =69ull
				if (param)
					for (var/mob/A in69iew(1,69ull))
						if (param == A.name)
							M = A
							break
				if (M)
					message = "gives daps to 69M69."
				else
					message = "sadly can't find anybody to give daps to, and daps 69get_visible_gender() ==69ALE ? "himself" : get_visible_gender() == FEMALE ? "herself" : "themselves"69. Shameful."

		if ("scream")
			if (miming)
				message = "acts out a scream!"
				m_type = 1
			else
				if (!muzzled)
					message = "screams!"
					m_type = 2
				else
					message = "makes a69ery loud69oise."
					m_type = 2
			cloud_emote = "cloud-scream"

		if ("help")
			to_chat(src, {"blink, blink_r, blush, bow-(none)/mob, burp, choke, chuckle, clap, collapse, cough,
cry, custom, deathgasp, drool, eyebrow, frown, gasp, giggle, groan, grumble, handshake, hug-(none)/mob, glare-(none)/mob,
grin, laugh, look-(none)/mob,69oan,69umble,69od, pale, point-atom, raise, salute, shake, shiver, shrug,
sigh, signal-#1-10, smile, sneeze, sniff, snore, stare-(none)/mob, tremble, twitch, twitch_s, whimper,
wink, yawn, swish, sway/wag, fastsway/qwag, stopsway/swag"})

		else
			to_chat(src, "\blue Unusable emote '69act69'. Say *help for a list.")





	if (message)
		log_emote("69name69/69key69 : 69message69")
		custom_emote(m_type,69essage)

	if(cloud_emote)
		var/image/emote_bubble = image('icons/mob/emote.dmi', src, cloud_emote, ABOVE_MOB_LAYER)
		flick_overlay(emote_bubble, clients, 30)
		QDEL_IN(emote_bubble, 3 SECONDS)


/mob/living/carbon/human/verb/pose()
	set69ame = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = "IC"

	if(suppress_communication)
		return FALSE

	pose =  sanitize(input(usr, "This is 69src69. 69get_visible_gender() ==69ALE ? "He" : get_visible_gender() == FEMALE ? "She" : "They"69 69get_visible_gender() ==69EUTER ? "are" : "is"69...", "Pose",69ull)  as text)
