
//moved these here from code/defines/obj/weapon.dm
//please preference put stuff where it's easy to find - C

/obj/item/autopsy_scanner
	name = "autopsy scanner"
	desc = "Extracts information on wounds."
	icon = 'icons/obj/autopsy_scanner.dmi'
	icon_state = ""
	flags = CONDUCT
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 1)
	rarity_value = 50
	var/list/datum/autopsy_data_scanner/wdata = list()
	var/list/datum/autopsy_data_scanner/chemtraces = list()
	var/target_name
	var/timeofdeath

/obj/item/paper/autopsy_report
	var/list/autopsy_data

/datum/autopsy_data_scanner
	var/weapon // this is the DEFINITE weapon type that was used
	var/list/organs_scanned = list() // this69aps a number of scanned organs to
									 // the wounds to those organs with this data's weapon type
	var/organ_names = ""

/datum/autopsy_data
	var/weapon
	var/pretend_weapon
	var/damage = 0
	var/hits = 0
	var/time_inflicted = 0

	proc/copy()
		var/datum/autopsy_data/W = new()
		W.weapon = weapon
		W.pretend_weapon = pretend_weapon
		W.damage = damage
		W.hits = hits
		W.time_inflicted = time_inflicted
		return W

/obj/item/autopsy_scanner/proc/add_data(var/obj/item/organ/external/O,69ob/living/carbon/user)
	if(!O.autopsy_data.len && !O.trace_chemicals.len) return

	for(var/V in O.autopsy_data)
		var/datum/autopsy_data/W = O.autopsy_data69V69

		if(!W.pretend_weapon)
			var/error_chance = (user.stats.getStat(STAT_BIO) * 4) //always success at BIO 25
			if(prob(error_chance))
				W.pretend_weapon = W.weapon
			else
				W.pretend_weapon = pick("mechanical toolbox", "wirecutters", "revolver", "crowbar", "fire extinguisher", "tomato soup", "oxygen tank", "emergency oxygen tank", "laser", "bullet")


		var/datum/autopsy_data_scanner/D = wdata69V69
		if(!D)
			D = new()
			D.weapon = W.weapon
			wdata69V69 = D

		if(!D.organs_scanned69O.name69)
			if(D.organ_names == "")
				D.organ_names = O.name
			else
				D.organ_names += ", 69O.name69"

		69del(D.organs_scanned69O.name69)
		D.organs_scanned69O.name69 = W.copy()

	for(var/V in O.trace_chemicals)
		if(O.trace_chemicals69V69 > 0 && !chemtraces.Find(V))
			chemtraces +=69

/obj/item/autopsy_scanner/verb/print_data()
	set category = "Object"
	set src in69iew(usr, 1)
	set name = "Print Data"
	if(usr.stat)
		to_chat(usr, "You69ust be conscious to do that!")
		return

	if (!usr.IsAdvancedToolUser())
		return

	var/scan_data = ""

	if(timeofdeath)
		scan_data += "<b>Time of death:</b> 69worldtime2stationtime(timeofdeath)69<br><br>"

	var/n = 1
	for(var/wdata_idx in wdata)
		var/datum/autopsy_data_scanner/D = wdata69wdata_idx69
		var/total_hits = 0
		var/total_score = 0
		var/list/weapon_chances = list() //69aps weapon names to a score
		var/age = 0

		for(var/wound_idx in D.organs_scanned)
			var/datum/autopsy_data/W = D.organs_scanned69wound_idx69
			total_hits += W.hits

			var/wname = W.pretend_weapon

			if(wname in weapon_chances) weapon_chances69wname69 += W.damage
			else weapon_chances69wname69 =69ax(W.damage, 1)
			total_score+=W.damage


			var/wound_age = W.time_inflicted
			age =69ax(age, wound_age)

		var/damage_desc

		var/damaging_weapon = (total_score != 0)

		// total score happens to be the total damage
		switch(total_score)
			if(0)
				damage_desc = "Unknown"
			if(1 to 5)
				damage_desc = "<font color='green'>negligible</font>"
			if(5 to 15)
				damage_desc = "<font color='green'>light</font>"
			if(15 to 30)
				damage_desc = "<font color='orange'>moderate</font>"
			if(30 to 1000)
				damage_desc = "<font color='red'>severe</font>"

		if(!total_score) total_score = D.organs_scanned.len

		scan_data += "<b>Weapon #69n69</b><br>"
		if(damaging_weapon)
			scan_data += "Severity: 69damage_desc69<br>"
			scan_data += "Hits by weapon: 69total_hits69<br>"
		scan_data += "Approximate time of wound infliction: 69worldtime2stationtime(age)69<br>"
		scan_data += "Affected limbs: 69D.organ_names69<br>"
		scan_data += "Possible weapons:<br>"
		for(var/weapon_name in weapon_chances)
			scan_data += "\t69100*weapon_chances69weapon_name69/total_score69% 69weapon_name69<br>"

		scan_data += "<br>"

		n++

	if(chemtraces.len)
		scan_data += "<b>Trace Chemicals: </b><br>"
		for(var/chemID in chemtraces)
			scan_data += chemID
			scan_data += "<br>"

	for(var/mob/O in69iewers(usr))
		O.show_message(SPAN_NOTICE("\The 69src69 rattles and prints out a sheet of paper."), 1)

	sleep(10)

	var/obj/item/paper/autopsy_report/P = new(usr.loc)
	P.name = "Autopsy Data (69target_name69)"
	P.info = "<tt>69scan_data69</tt>"
	P.autopsy_data = list() // Copy autopsy data for science tool
	for(var/wdata_idx in wdata)
		var/datum/autopsy_data_scanner/D = wdata69wdata_idx69
		for(var/wound_idx in D.organs_scanned)
			var/datum/autopsy_data/W = D.organs_scanned69wound_idx69
			P.autopsy_data += W.copy()
	P.icon_state = "paper_words"

	// place the item in the usr's hand if possible
	usr.put_in_hands(P)
	usr.setClickCooldown(DEFAULT_ATTACK_COOLDOWN*4) //To stop people spamclicking and generating tons of paper

/obj/item/autopsy_scanner/attack(mob/living/carbon/human/M,69ob/living/carbon/user)
	if(!istype(M))
		return

	if(!can_operate(M, user) == CAN_OPERATE_ALL)
		to_chat(user, SPAN_WARNING("You need to lay the cadaver down on a table first!"))
		return

	if(target_name !=69.name)
		target_name =69.name
		src.wdata = list()
		src.chemtraces = list()
		src.timeofdeath = null
		to_chat(user, SPAN_NOTICE("A new patient has been registered. Purging data for previous patient."))

	src.timeofdeath =69.timeofdeath

	var/obj/item/organ/external/S =69.get_organ(user.targeted_organ)
	if(!S)
		to_chat(usr, SPAN_WARNING("You can't scan this body part."))
		return
	if(!S.open)
		to_chat(usr, SPAN_WARNING("You have to cut the limb open first!"))
		return
	for(var/mob/O in69iewers(M))
		O.show_message(SPAN_NOTICE("\The 69user69 scans the wounds on 69M.name69's 69S.name69 with \the 69src69"), 1)
	SEND_SIGNAL(user, COMSING_AUTOPSY,69)
	if(user.mind && user.mind.assigned_job && (user.mind.assigned_job.department in GLOB.department_moebius))
		GLOB.moebius_autopsies_mobs |=69
	src.add_data(S, user)

	return 1

/obj/item/autopsy_scanner/attack_self()
	print_data()
