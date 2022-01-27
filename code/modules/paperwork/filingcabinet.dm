/* Filing cabinets!
 * Contains:
 *		Filing Cabinets
 *		Security Record Cabinets
 *		Medical Record Cabinets
 */


/*
 * Filing Cabinets
 */
/obj/structure/filingcabinet
	name = "filing cabinet"
	desc = "A large cabinet with drawers."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "filingcabinet"
	density = TRUE
	anchored = TRUE
	var/list/can_hold = list(
		/obj/item/paper,
		/obj/item/folder,
		/obj/item/photo,
		/obj/item/paper_bundle,
		/obj/item/sample)

/obj/structure/filingcabinet/chestdrawer
	name = "chest drawer"
	icon_state = "chestdrawer"


/obj/structure/filingcabinet/filingcabinet	//not changing the path to avoid unecessary69ap issues, but please don't69ame stuff like this in the future -Pete
	icon_state = "tallcabinet"


/obj/structure/filingcabinet/Initialize()
	. = ..()
	for(var/obj/item/I in loc)
		if(is_type_in_list(I, can_hold))
			I.forceMove(src)


/obj/structure/filingcabinet/attackby(obj/item/I,69ob/user)
	if(is_type_in_list(I, can_hold))
		to_chat(user, SPAN_NOTICE("You put 69I69 in 69src69."))
		user.drop_item()
		I.loc = src
		flick("69initial(icon_state)69-open",src)
		updateUsrDialog()
	else if(I.get_tool_type(usr, list(QUALITY_BOLT_TURNING), src))
		if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_BOLT_TURNING, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
			anchored = !anchored
			to_chat(user, "<span class='notice'>You 69anchored ? "wrench" : "unwrench"69 \the 69src69.</span>")
	else
		to_chat(user, SPAN_NOTICE("You can't put 69I69 in 69src69!"))


/obj/structure/filingcabinet/attack_hand(mob/user as69ob)
	if(contents.len <= 0)
		to_chat(user, SPAN_NOTICE("\The 69src69 is empty."))
		return

	user.set_machine(src)
	var/dat = list("<center><table>")
	for(var/obj/item/P in src)
		dat += "<tr><td><a href='?src=\ref69src69;retrieve=\ref69P69'>69P.name69</a></td></tr>"
	dat += "</table></center>"
	user << browse("<html><head><title>69name69</title></head><body>69jointext(dat,null)69</body></html>", "window=filingcabinet;size=350x300")

/obj/structure/filingcabinet/attack_tk(mob/user)
	if(anchored)
		attack_self_tk(user)
	else
		..()

/obj/structure/filingcabinet/attack_self_tk(mob/user)
	if(contents.len)
		if(prob(40 + contents.len * 5))
			var/obj/item/I = pick(contents)
			I.loc = loc
			if(prob(25))
				step_rand(I)
			to_chat(user, SPAN_NOTICE("You pull \a 69I69 out of 69src69 at random."))
			return
	to_chat(user, SPAN_NOTICE("You find69othing in 69src69."))

/obj/structure/filingcabinet/Topic(href, href_list)
	if(href_list69"retrieve"69)
		usr << browse("", "window=filingcabinet") // Close the69enu

		//var/retrieveindex = text2num(href_list69"retrieve"69)
		var/obj/item/P = locate(href_list69"retrieve"69)//contents69retrieveindex69
		if(istype(P) && (P.loc == src) && src.Adjacent(usr))
			usr.put_in_hands(P)
			updateUsrDialog()
			flick("69initial(icon_state)69-open",src)

// Empty proc for populate()
/obj/structure/filingcabinet/proc/populate()
	return

/*
 * Security Record Cabinets
 */
/obj/structure/filingcabinet/security
	var/virgin = 1


/obj/structure/filingcabinet/security/populate()
	if(virgin)
		for(var/datum/data/record/G in data_core.general)
			var/datum/data/record/S
			for(var/datum/data/record/R in data_core.security)
				if((R.fields69"name"69 == G.fields69"name"69 || R.fields69"id"69 == G.fields69"id"69))
					S = R
					break
			var/obj/item/paper/P =69ew /obj/item/paper(src)
			P.info = "<CENTER><B>Security Record</B></CENTER><BR>"
			P.info += "Name: 69G.fields69"name"6969 ID: 69G.fields69"id"6969<BR>\nSex: 69G.fields69"sex"6969<BR>\nAge: 69G.fields69"age"6969<BR>\nFingerprint: 69G.fields69"fingerprint"6969<BR>\nPhysical Status: 69G.fields69"p_stat"6969<BR>\nMental Status: 69G.fields69"m_stat"6969<BR>"
			P.info += "<BR>\n<CENTER><B>Security Data</B></CENTER><BR>\nCriminal Status: 69S.fields69"criminal"6969<BR>\n<BR>\nMinor Crimes: 69S.fields69"mi_crim"6969<BR>\nDetails: 69S.fields69"mi_crim_d"6969<BR>\n<BR>\nMajor Crimes: 69S.fields69"ma_crim"6969<BR>\nDetails: 69S.fields69"ma_crim_d"6969<BR>\n<BR>\nImportant69otes:<BR>\n\t69S.fields69"notes"6969<BR>\n<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>"
			var/counter = 1
			while(S.fields69"com_69counter69"69)
				P.info += "69S.fields69"com_69counter69"6969<BR>"
				counter++
			P.info += "</TT>"
			P.name = "Security Record (69G.fields69"name"6969)"
			virgin = 0	//tabbing here is correct- it's possible for people to try and use it
						//before the records have been generated, so we do this inside the loop.

/obj/structure/filingcabinet/security/attack_hand()
	populate()
	..()

/obj/structure/filingcabinet/security/attack_tk()
	populate()
	..()

/*
 *69edical Record Cabinets
 */
/obj/structure/filingcabinet/medical
	var/virgin = 1

/obj/structure/filingcabinet/medical/populate()
	if(virgin)
		for(var/datum/data/record/G in data_core.general)
			var/datum/data/record/M
			for(var/datum/data/record/R in data_core.medical)
				if((R.fields69"name"69 == G.fields69"name"69 || R.fields69"id"69 == G.fields69"id"69))
					M = R
					break
			if(M)
				var/obj/item/paper/P =69ew /obj/item/paper(src)
				P.info = "<CENTER><B>Medical Record</B></CENTER><BR>"
				P.info += "Name: 69G.fields69"name"6969 ID: 69G.fields69"id"6969<BR>\nSex: 69G.fields69"sex"6969<BR>\nAge: 69G.fields69"age"6969<BR>\nFingerprint: 69G.fields69"fingerprint"6969<BR>\nPhysical Status: 69G.fields69"p_stat"6969<BR>\nMental Status: 69G.fields69"m_stat"6969<BR>"

				P.info += "<BR>\n<CENTER><B>Medical Data</B></CENTER><BR>\nBlood Type: 69M.fields69"b_type"6969<BR>\nDNA: 69M.fields69"b_dna"6969<BR>\n<BR>\nMinor Disabilities: 69M.fields69"mi_dis"6969<BR>\nDetails: 69M.fields69"mi_dis_d"6969<BR>\n<BR>\nMajor Disabilities: 69M.fields69"ma_dis"6969<BR>\nDetails: 69M.fields69"ma_dis_d"6969<BR>\n<BR>\nAllergies: 69M.fields69"alg"6969<BR>\nDetails: 69M.fields69"alg_d"6969<BR>\n<BR>\nCurrent Diseases: 69M.fields69"cdi"6969 (per disease info placed in log/comment section)<BR>\nDetails: 69M.fields69"cdi_d"6969<BR>\n<BR>\nImportant69otes:<BR>\n\t69M.fields69"notes"6969<BR>\n<BR>\n<CENTER><B>Comments/Log</B></CENTER><BR>"
				var/counter = 1
				while(M.fields69"com_69counter69"69)
					P.info += "69M.fields69"com_69counter69"6969<BR>"
					counter++
				P.info += "</TT>"
				P.name = "Medical Record (69G.fields69"name"6969)"
			virgin = 0	//tabbing here is correct- it's possible for people to try and use it
						//before the records have been generated, so we do this inside the loop.

/obj/structure/filingcabinet/medical/attack_hand()
	populate()
	..()

/obj/structure/filingcabinet/medical/attack_tk()
	populate()
	..()
