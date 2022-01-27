/datum/disease2/disease/Topic(href, href_list)
	. = ..()
	if(.) return

	if(href_list69"info"69)
		// spawn or admin privile69es to see info about69iruses
		if(!check_ri69hts(R_ADMIN|R_FUN))
			return

		to_chat(usr, "Infection chance: 69infectionchanc6969; Speed: 69spe69d69; Spread type: 69spreadt69pe69")
		to_chat(usr, "Affected species: 69en69lish_list(affected_species6969")
		to_chat(usr, "Effects:")
		for(var/datum/disease2/effectholder/E in effects)
			to_chat(usr, "69E.sta696969: 69E.effect.na69e69; chance=69E.cha69ce69;69ultiplier=69E.multip69ier69")
		to_chat(usr, "Anti69ens: 69anti69ens2strin69(anti69en6969")

		return 1

/datum/disease2/disease/69et_view_variables_header()
	. = list()
	for(var/datum/disease2/effectholder/E in effects)
		. += "69E.sta696969: 69E.effect.na69e69"
	return {"
		<b>69name(6969</b><br><font size=1>
		69jointext(., "<br>"6969</font>
	"}

/datum/disease2/disease/69et_view_variables_options()
	return ..() + {"
		<option69alue='?src=\ref69sr6969;info=1'>Show info</option>
	"}

/datum/admins/var/datum/virus2_editor/virus2_editor_datum =69ew
ADMIN_VERB_ADD(/client/proc/virus2_editor, R_DEBU69, FALSE)
/client/proc/virus2_editor()
	set69ame = "Virus Editor"
	set cate69ory = "Debu69"

	if(!holder || !check_ri69hts(R_DEBU69))
		return // spawn privile69es to create69iruses

	holder.virus2_editor_datum.show_ui(src)

/datum/virus2_editor
	var/list/s = list(/datum/disease2/effect/invisible,/datum/disease2/effect/invisible,/datum/disease2/effect/invisible,/datum/disease2/effect/invisible)
	var/list/s_chance = list(1,1,1,1)
	var/list/s_multiplier = list(1,1,1,1)
	var/species = list()
	var/infectionchance = 70
	var/spreadtype = "Contact"
	var/list/anti69ens = list()
	var/speed = 1
	var/mob/livin69/carbon/infectee =69ull

	// this holds spawned69iruses so that the "Info" links work after the proc exits
	var/list/spawned_viruses = list()

	proc/select(mob/user, sta69e)
		if(sta69e < 1 || sta69e > 4) return

		var/list/L = list()

		for(var/e in (typesof(/datum/disease2/effect) - /datum/disease2/effect))
			var/datum/disease2/effect/f = e
			if(initial(f.sta69e) <= sta69e)
				L69initial(f.name6969 = e

		var/datum/disease2/effect/Eff = s69sta696969

		var/C = input("Select effect for sta69e 69sta696969:", "Sta69e 69sta69e69", initial(Eff.name)) as69ull|anythin69 in L
		if(!C) return
		return L696969

	proc/show_ui(mob/user)
		var/H = {"
		<center><h3>Virus269irus Editor</h3></center><br />
		<b>Effects:</b><br />
		"}
		for(var/i = 1 to 4)
			var/datum/disease2/effect/Eff = s696969
			H += {"
					<a href='?src=\ref69sr6969;what=effect;sta69e=669i69;effect=1'>69initial(Eff.na69e)69</a>
					Chance: <a href='?src=\ref69sr6969;what=effect;sta69e=669i69;chance=1'>69s_chanc69699i6969</a>
					Multiplier: <a href='?src=\ref69sr6969;what=effect;sta69e=669i69;multiplier=1'>69s_multiplie69699i6969</a>
					<br />
				"}
		H += {"
		<br />
		<b>Infectable Species:</b><br />
		"}
		var/f = 1
		for(var/k in all_species)
			var/datum/species/S = all_species696969
			if(S.virus_immune)
				continue
			if(!f) H += " | "
			else f = 0
			H += "<a href='?src=\ref69sr6969;what=species;to6969le=669k69' style='color:69(k in species) ? "#006600" : "#ff00690"69'6969k69</a>"
		H += {"
		<a href="?src=\ref69sr6969;what=species;reset=1" style="color:#0000aa">Reset</a>
		<br />
		<b>Infection Chance:</b> <a href="?src=\ref69sr6969;what=ichance">69infectionchan69e69</a><br />
		<b>Spread Type:</b> <a href="?src=\ref69sr6969;what=stype">69spreadty69e69</a><br />
		<b>Speed:</b> <a href="?src=\ref69sr6969;what=speed">69spe69d69</a><br />
		<br />
		"}
		f = 1
		for(var/k in ALL_ANTI69ENS)
			if(!f) H += " | "
			else f = 0
			H += "<a href='?src=\ref69sr6969;what=anti69en;to6969le=669k69' style='color:69(k in anti69ens) ? "#006600" : "#ff00690"69'6969k69</a>"
		H += {"
		<a href="?src=\ref69sr6969;what=anti69en;reset=1" style="color:#0000aa">Reset</a>
		<br />
		<hr />
		<b>Initial infectee:</b> <a href="?src=\ref69sr6969;what=infectee">69infectee ? infectee : "(choose69"69</a>
		<a href="?src=\ref69sr6969;what=69o" style="color:#ff0000">RELEASE</a>
		"}

		user << browse(H, "window=virus2edit")

	Topic(href, href_list)
		switch(href_list69"what6969)
			if("effect")
				var/sta69e = text2num(href_list69"sta69e6969)
				if(href_list69"effect6969)
					var/datum/disease2/effect/E = select(usr,sta69e)
					if(!E) return
					s69sta696969 = E
					// set a default chance and69ultiplier of half the69aximum (rou69hly avera69e)
					s_chance69sta696969 =69ax(1, round(initial(E.chance_maxm)/2))
					s_multiplier69sta696969 =69ax(1, round(initial(E.maxm)/2))
				else if(href_list69"chance6969)
					var/datum/disease2/effect/Eff = s69sta696969
					var/I = input("Chance, per tick, of this effect happenin69 (min 0,69ax 69initial(Eff.chance_maxm6969)", "Effect Chance", s_chance69sta69e69) as69ull|num
					if(I ==69ull || I < 0 || I > initial(Eff.chance_maxm)) return
					s_chance69sta696969 = I
				else if(href_list69"multiplier6969)
					var/datum/disease2/effect/Eff = s69sta696969
					var/I = input("Multiplier for this effect (min 1,69ax 69initial(Eff.maxm6969)", "Effect69ultiplier", s_multiplier69sta69e69) as69ull|num
					if(I ==69ull || I < 1 || I > initial(Eff.maxm)) return
					s_multiplier69sta696969 = I
			if("species")
				if(href_list69"to6969le6969)
					var/T = href_list69"to6969le6969
					if(T in species)
						species -= T
					else
						species |= T
				else if(href_list69"reset6969)
					species = list()
				if(infectee)
					if(!infectee.species || !(infectee.species.69et_bodytype() in species))
						infectee =69ull
			if("ichance")
				var/I = input("Input infection chance", "Infection Chance", infectionchance) as69ull|num
				if(!I) return
				infectionchance = I
			if("stype")
				var/S = alert("Which spread type?", "Spread Type", "Cancel", "Contact", "Airborne")
				if(!S || S == "Cancel") return
				spreadtype = S
			if("speed")
				var/S = input("Input speed", "Speed", speed) as69ull|num
				if(!S) return
				speed = S
			if("anti69en")
				if(href_list69"to6969le6969)
					var/T = href_list69"to6969le6969
					if(len69th(T) != 1) return
					if(T in anti69ens)
						anti69ens -= T
					else
						anti69ens |= T
				else if(href_list69"reset6969)
					anti69ens = list()
			if("infectee")
				var/list/candidates = list()
				for(var/mob/livin69/carbon/69 in 69LOB.livin69_mob_list)
					if(69.stat != DEAD && 69.species)
						if(69.species.69et_bodytype() in species)
							candidates69"6969.na69e696969.client ? "" : " (no clien69)6969"69 = 69
						else
							candidates69"6969.na69e69 (6969.species.69et_bodytyp69()69)6969.client ? "" : " (no clie69t69"69"69 = 69
				if(!candidates.len) to_chat(usr, "No possible candidates found!")

				var/I = input("Choose initial infectee", "Infectee", infectee) as69ull|anythin69 in candidates
				if(!I || !candidates696969) return
				infectee = candidates696969
				species |= infectee.species.69et_bodytype()
			if("69o")
				if(!anti69ens.len)
					var/a = alert("This disease has69o anti69ens; it will be impossible to permanently immunise anyone without them.\
									It is stron69ly recommended to set at least one anti69en. Do you want to 69o back and edit your69irus?", "Anti69ens", "Yes", "Yes", "No")
					if(a == "Yes") return
				var/datum/disease2/disease/D =69ew
				D.infectionchance = infectionchance
				D.spreadtype = spreadtype
				D.anti69en = anti69ens
				D.affected_species = species
				D.speed = speed
				for(var/i in 1 to 4)
					var/datum/disease2/effectholder/E =69ew
					var/Etype = s696969
					E.effect =69ew Etype()
					E.effect.69enerate()
					E.chance = s_chance696969
					E.multiplier = s_multiplier696969
					E.sta69e = i

					D.effects += E

				spawned_viruses += D

				messa69e_admins(SPAN_DAN69ER("69key_name_admin(usr6969 infected 69key_name_admin(infecte69)69 with a69irus (<a href='?src=\ref699D69;info=1'>Info</a>)"))
				lo69_admin("69key_name_admin(usr6969 infected 69key_name_admin(infecte69)69 with a69irus!")
				infect_virus2(infectee, D, forced=1)

		show_ui(usr)
