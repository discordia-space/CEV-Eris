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


/obj/structure/filingcabinet/filingcabinet	//not changing the path to avoid unecessary map issues, but please don't name stuff like this in the future -Pete
	icon_state = "tallcabinet"


/obj/structure/filingcabinet/Initialize()
	. = ..()
	for(var/obj/item/I in loc)
		if(is_type_in_list(I, can_hold))
			I.forceMove(src)


/obj/structure/filingcabinet/attackby(obj/item/I, mob/user)
	if(is_type_in_list(I, can_hold))
		to_chat(user, SPAN_NOTICE("You put [I] in [src]."))
		user.drop_item()
		I.loc = src
		flick("[initial(icon_state)]-open",src)
		updateUsrDialog()
	else if(I.get_tool_type(usr, list(QUALITY_BOLT_TURNING), src))
		if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_BOLT_TURNING, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
			anchored = !anchored
			to_chat(user, "<span class='notice'>You [anchored ? "wrench" : "unwrench"] \the [src].</span>")
	else
		to_chat(user, SPAN_NOTICE("You can't put [I] in [src]!"))


/obj/structure/filingcabinet/attack_hand(mob/user as mob)
	if(contents.len <= 0)
		to_chat(user, SPAN_NOTICE("\The [src] is empty."))
		return

	user.set_machine(src)
	var/dat = list("<center><table>")
	for(var/obj/item/P in src)
		dat += "<tr><td><a href='?src=\ref[src];retrieve=\ref[P]'>[P.name]</a></td></tr>"
	dat += "</table></center>"
	user << browse("<html><head><title>[name]</title></head><body>[jointext(dat,null)]</body></html>", "window=filingcabinet;size=350x300")

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
			to_chat(user, SPAN_NOTICE("You pull \a [I] out of [src] at random."))
			return
	to_chat(user, SPAN_NOTICE("You find nothing in [src]."))

/obj/structure/filingcabinet/Topic(href, href_list)
	if(href_list["retrieve"])
		usr << browse("", "window=filingcabinet") // Close the menu

		//var/retrieveindex = text2num(href_list["retrieve"])
		var/obj/item/P = locate(href_list["retrieve"])//contents[retrieveindex]
		if(istype(P) && (P.loc == src) && src.Adjacent(usr))
			usr.put_in_hands(P)
			updateUsrDialog()
			flick("[initial(icon_state)]-open",src)

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
		for(var/datum/computer_file/report/crew_record/G in GLOB.all_crew_records)
			var/obj/item/paper/P = new /obj/item/paper(src)
			P.info = "<CENTER><B>Security Record</B></CENTER><BR>"
			P.info += "Name: [G.get_name()]<BR>\nSex: [G.get_sex()]<BR>\nAge: [G.get_age()]<BR>\nFingerprint: [G.get_fingerprint()]<BR>"
			P.info += "</TT>"
			P.name = "Security Record ([G.get_name()])"
			virgin = 0	//tabbing here is correct- it's possible for people to try and use it
						//before the records have been generated, so we do this inside the loop.

/obj/structure/filingcabinet/security/attack_hand()
	populate()
	..()

/obj/structure/filingcabinet/security/attack_tk()
	populate()
	..()

/*
 * Medical Record Cabinets
 */
/obj/structure/filingcabinet/medical
	var/virgin = 1

/obj/structure/filingcabinet/medical/populate()
	if(virgin)
		for(var/datum/computer_file/report/crew_record/G in GLOB.all_crew_records)
			var/datum/report_field/arrayclump/M = G.get_linkage_medRecord()
			if(M)
				var/obj/item/paper/P = new /obj/item/paper(src)
				var/list/infostoadd = list()
				infostoadd += "<CENTER><B>Medical Record</B></CENTER><BR>"
				infostoadd += "Name: [G.get_name()] <BR>\nSex: [G.get_sex()]<BR>\nAge: [G.get_age()]<BR>"

				infostoadd += "<BR>\n<CENTER><B>Medical Data</B></CENTER><BR>\nBlood Type: [G.get_bloodtype()]<BR>\nDNA: [G.get_dna()]<BR>"
				infostoadd += "<BR>\nProsthetics: [M.value["prosthetics"]]<BR>\nWounds: [M.value["wounds"]]<BR>\n<BR>\nAutopsy: [M.value["Body state"]]<BR>"
				infostoadd +="<BR>\nChemical History: [M.value["chemhistory"]]<BR>\nPsychological Profile: [M.value["psychological"]]<BR>"
				
				infostoadd += "</TT>"
				P.name = "Medical Record ([G.get_name()])"
				P.info = infostoadd.Join() // minor optimization
			virgin = 0	//tabbing here is correct- it's possible for people to try and use it
						//before the records have been generated, so we do this inside the loop.

/obj/structure/filingcabinet/medical/attack_hand()
	populate()
	..()

/obj/structure/filingcabinet/medical/attack_tk()
	populate()
	..()
