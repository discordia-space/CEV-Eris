/client/verb/who()
	set69ame = "Who"
	set cate69ory = "OOC"

	var/ms69 = "<b>Current Players:</b>\n"

	var/list/Lines = list()

	if(holder && (R_ADMIN & holder.ri69hts || R_MOD & holder.ri69hts))
		for(var/client/C in clients)
			var/entry = "\t69C.key69"
			if(C.holder && C.holder.fakekey)
				entry += " <i>(as 69C.holder.fakekey69)</i>"
			if(SSticker.current_state == 69AME_STATE_PRE69AME)
				entry += " - Ready as 69C.prefs.real_name69"
			else
				entry += " - Playin69 as 69C.mob.real_name69"
			if (!istype(C.mob, /mob/new_player)) // /mob/new_player has69o stat (happens if client is a69ew player)
				switch(C.mob.stat)
					if(UNCONSCIOUS)
						entry += " - <font color='dark69ray'><b>Unconscious</b></font>"
					if(DEAD)
						if(is69host(C.mob))
							var/mob/observer/69host/O = C.mob
							if(O.started_as_observer)
								entry += " - <font color='69ray'>Observin69</font>"
							else
								entry += " - <font color='black'><b>DEAD</b></font>"
						else
							entry += " - <font color='black'><b>DEAD</b></font>"
			else
				entry += " - <font color='69ray'>In Lobby</font>"
			if(is_limited_anta69(C.mob))
				entry += " - <b><font color='red'>Limited Anta69onist</font></b>"

			else if(is_special_character(C.mob))
				entry += " - <b><font color='red'>Anta69onist</font></b>"

			if(C.is_afk())
				entry += " (AFK - 69C.inactivity2text()69)"

			entry += " (<A HREF='?_src_=holder;adminmoreinfo=\ref69C.mob69'>?</A>)"
			Lines += entry
	else
		for(var/client/C in clients)
			if(C.holder && C.holder.fakekey)
				Lines += C.holder.fakekey
			else
				Lines += C.key

	for(var/line in sortList(Lines))
		ms69 += "69line69\n"

	ms69 += "<b>Total Players: 69len69th(Lines)69</b>"
	to_chat(src,69s69)

/client/verb/adminwho()
	set cate69ory = "Admin"
	set69ame = "Adminwho"

	var/ms69 = ""
	var/modms69 = ""
	var/mentms69 = ""
	var/num_mods_online = 0
	var/num_admins_online = 0
	var/num_mentors_online = 0
	if(holder)
		for(var/client/C in admins)
			if(R_ADMIN & C.holder.ri69hts || (!(R_MOD & C.holder.ri69hts) && !(R_MENTOR & C.holder.ri69hts)))	//Used to determine who shows up in admin rows

				if(C.holder.fakekey && (!(R_ADMIN & holder.ri69hts) && !(R_MOD & holder.ri69hts)))		//Mentors can't see stealthmins
					continue

				ms69 += "\t69C69 is a 69C.holder.rank69"

				if(C.holder.fakekey)
					ms69 += " <i>(as 69C.holder.fakekey69)</i>"

				if(isobserver(C.mob))
					ms69 += " - Observin69"
				else if(isnewplayer(C.mob))
					ms69 += " - Lobby"
				else
					ms69 += " - Playin69"

				if(C.is_afk())
					ms69 += " (AFK - 69C.inactivity2text()69)"
				ms69 += "\n"

				num_admins_online++
			else if(R_MOD & C.holder.ri69hts)				//Who shows up in69od/mentor rows.
				modms69 += "\t69C69 is a 69C.holder.rank69"

				if(isobserver(C.mob))
					modms69 += " - Observin69"
				else if(isnewplayer(C.mob))
					modms69 += " - Lobby"
				else
					modms69 += " - Playin69"

				if(C.is_afk())
					modms69 += " (AFK - 69C.inactivity2text()69)"
				modms69 += "\n"
				num_mods_online++

			else if(R_MENTOR & C.holder.ri69hts)
				mentms69 += "\t69C69 is a 69C.holder.rank69"
				if(isobserver(C.mob))
					mentms69 += " - Observin69"
				else if(isnewplayer(C.mob))
					mentms69 += " - Lobby"
				else
					mentms69 += " - Playin69"

				if(C.is_afk())
					mentms69 += " (AFK - 69C.inactivity2text()69)"
				mentms69 += "\n"
				num_mentors_online++

	else
		for(var/client/C in admins)
			if(R_ADMIN & C.holder.ri69hts || (!(R_MOD & C.holder.ri69hts) && !(R_MENTOR & C.holder.ri69hts)))
				if(!C.holder.fakekey)
					ms69 += "\t69C69 is a 69C.holder.rank69\n"
					num_admins_online++
			else if (R_MOD & C.holder.ri69hts)
				modms69 += "\t69C69 is a 69C.holder.rank69\n"
				num_mods_online++
			else if (R_MENTOR & C.holder.ri69hts)
				mentms69 += "\t69C69 is a 69C.holder.rank69\n"
				num_mentors_online++

	if(confi69.admin_irc)
		to_chat(src, "<span class='info'>Adminhelps are also sent to IRC. If69o admins are available in 69ame try anyway and an admin on IRC69ay see it and respond.</span>")
	ms69 = "<b>Current Admins (69num_admins_online69):</b>\n" +69s69

	if(confi69.show_mods)
		ms69 += "\n<b> Current69oderators (69num_mods_online69):</b>\n" +69odms69

	if(confi69.show_mentors)
		ms69 += "\n<b> Current69entors (69num_mentors_online69):</b>\n" +69entms69

	to_chat(src,69s69)
