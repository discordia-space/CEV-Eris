
/obj/item/device/scanner/health
	name = "health analyzer"
	desc = "A hand-held body scanner able to distin69uish69ital si69ns of the subject."
	icon_state = "health"
	item_state = "analyzer"
	throw_speed = 5
	throw_ran69e = 10

	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_69LASS = 1)
	ori69in_tech = list(TECH_MA69NET = 1, TECH_BIO = 1)
	rarity_value = 16.66

	var/mode = 1

	window_width = 600
	window_hei69ht = 400

/obj/item/device/scanner/health/is_valid_scan_tar69et(atom/O)
	return istype(O, /mob/livin69) || istype(O, /obj/structure/closet/body_ba69)

/obj/item/device/scanner/health/scan(atom/A,69ob/user)
	scan_data =69edical_scan_action(A, user, src,69ode)
	scan_title = "Health scan - 69A69"
	show_results(user)
	flick("health2", src)

/obj/item/device/scanner/health/verb/to6969le_mode()
	set name = "Switch69erbosity"
	set cate69ory = "Object"

	mode = !mode
	switch (mode)
		if(1)
			to_chat(usr, "The scanner now shows specific limb dama69e.")
		if(0)
			to_chat(usr, "The scanner no lon69er shows limb dama69e.")

/proc/medical_scan_action(atom/tar69et,69ob/livin69/user, obj/scanner,69ar/mode)
	if (!user.IsAdvancedToolUser())
		to_chat(user, SPAN_WARNIN69("You are not nimble enou69h to use this device."))
		return

	if ((CLUMSY in user.mutations) && prob(50))
		. = list()

		user.visible_messa69e(SPAN_NOTICE("\The 69user69 runs \the 69scanner69 over the floor."))
		. += span("hi69hli69ht", "<b>Scan results for the floor:</b>")
		. += span("hi69hli69ht", "Overall Status: Healthy")
		return jointext(., "<br>")

	var/mob/livin69/carbon/human/scan_subject = null
	if (istype(tar69et, /mob/livin69/carbon/human))
		scan_subject = tar69et
	else if (istype(tar69et, /obj/structure/closet/body_ba69))
		var/obj/structure/closet/body_ba69/B = tar69et
		if(!B.opened)
			var/list/scan_content = list()
			for(var/mob/livin69/L in B.contents)
				scan_content.Add(L)

			if (scan_content.len == 1)
				for(var/mob/livin69/carbon/human/L in scan_content)
					scan_subject = L
			else if (scan_content.len > 1)
				to_chat(user, SPAN_WARNIN69("\The 69scanner69 picks up69ultiple readin69s inside \the 69tar69et69, too close to69ether to scan properly."))
				return
			else
				to_chat(user, "\The 69scanner69 does not detect anyone inside \the 69tar69et69.")
				return

	if(!scan_subject)
		return

	if (scan_subject.isSynthetic())
		to_chat(user, SPAN_WARNIN69("\The 69scanner69 is desi69ned for or69anic humanoid patients only."))
		return

	user.visible_messa69e(SPAN_NOTICE("69user69 has analyzed 69tar69et69's69itals."),SPAN_NOTICE("You have analyzed 69tar69et69's69itals."))
	. =69edical_scan_results(scan_subject,69ode)

/proc/medical_scan_results(var/mob/livin69/M,69ar/mode)
	. = list()
	var/dat = list()
	if (!ishuman(M) ||69.isSynthetic())
		//these sensors are desi69ned for or69anic life
		. += "<h2>Analyzin69 Results for ERROR:\n\t Overall Status: ERROR</h2>"
		. += span("hi69hli69ht", "    Key: <font color='#0080ff'>Suffocation</font>/<font color='69reen'>Toxin</font>/<font color='#FFA500'>Burns</font>/<font color='red'>Brute</font>")
		. += span("hi69hli69ht", "    Dama69e Specifics: <font color='#0080ff'>?</font> - <font color='69reen'>?</font> - <font color='#FFA500'>?</font> - <font color='red'>?</font>")
		. += span("hi69hli69ht", "Body Temperature: 69M.bodytemperature-T0C69&de69;C (69M.bodytemperature*1.8-459.6769&de69;F)")
		. += SPAN_WARNIN69("Warnin69: Blood Level ERROR: --% --cl.</span> <span class='notice'>Type: ERROR")
		. += span("hi69hli69ht", "Subject's pulse: <font color='red'>-- bpm.</font>")
		return

	var/fake_oxy =69ax(rand(1, 40),69.69etOxyLoss(), (300 - (M.69etToxLoss() +69.69etFireLoss() +69.69etBruteLoss())))
	var/OX =69.69etOxyLoss() > 50 	? 	"<b>69M.69etOxyLoss()69</b>" 		:69.69etOxyLoss()
	var/TX =69.69etToxLoss() > 50 	? 	"<b>69M.69etToxLoss()69</b>" 		:69.69etToxLoss()
	var/BU =69.69etFireLoss() > 50 	? 	"<b>69M.69etFireLoss()69</b>" 		:69.69etFireLoss()
	var/BR =69.69etBruteLoss() > 50 	? 	"<b>69M.69etBruteLoss()69</b>" 	:69.69etBruteLoss()
	if(M.status_fla69s & FAKEDEATH)
		OX = fake_oxy > 50 			? 	"<b>69fake_oxy69</b>" 			: fake_oxy
		dat += "<h2>Analyzin69 Results for 69M69:</h2>"
		dat += span("hi69hli69ht", "Overall Status: dead")
	else
		dat += span("hi69hli69ht", "Analyzin69 Results for 69M69:\n\t Overall Status: 69M.stat > 1 ? "dead" : "69round(M.health/M.maxHealth*100)69% healthy"69")
	dat += span("hi69hli69ht", "    Key: <font color='#0080ff'>Suffocation</font>/<font color='69reen'>Toxin</font>/<font color='#FFA500'>Burns</font>/<font color='red'>Brute</font>")
	dat += span("hi69hli69ht", "    Dama69e Specifics: <font color='#0080ff'>69OX69</font> - <font color='69reen'>69TX69</font> - <font color='#FFA500'>69BU69</font> - <font color='red'>69BR69</font>")
	dat += span("hi69hli69ht", "Body Temperature: 69M.bodytemperature-T0C69&de69;C (69M.bodytemperature*1.8-459.6769&de69;F)")
	if(M.timeofdeath && (M.stat == DEAD || (M.status_fla69s & FAKEDEATH)))
		dat += span("hi69hli69ht", "Time of Death: 69worldtime2stationtime(M.timeofdeath)69")
	if(ishuman(M) &&69ode == 1)
		var/mob/livin69/carbon/human/H =69
		var/list/dama69ed = H.69et_dama69ed_or69ans(1, 1)
		dat += span("hi69hli69ht", "Localized Dama69e, Brute/Burn:")
		if(len69th(dama69ed) > 0)
			for(var/obj/item/or69an/external/or69 in dama69ed)
				dat += text("<span class='hi69hli69ht'>     69696969: 69696969 - 6969</span>",
				capitalize(or69.name),
				(BP_IS_ROBOTIC(or69)) ? "(Cybernetic)" : "",
				(or69.brute_dam > 0) ? SPAN_WARNIN69("69or69.brute_dam69") : 0,
				(or69.status & OR69AN_BLEEDIN69)?SPAN_DAN69ER("\69Bleedin69\69"):"",
				(or69.burn_dam > 0) ? "<font color='#FFA500'>69or69.burn_dam69</font>" : 0)
		else
			dat += span("hi69hli69ht", "    Limbs are OK.")

	OX =69.69etOxyLoss() > 50 ? 	 "<font color='#0080ff'><b>Severe oxy69en deprivation detected</b></font>" 		: 	"Subject bloodstream oxy69en level normal"
	TX =69.69etToxLoss() > 50 ? 	 "<font color='69reen'><b>Dan69erous amount of toxins detected</b></font>" 	: 	"Subject bloodstream toxin level69inimal"
	BU =69.69etFireLoss() > 50 ?  "<font color='#FFA500'><b>Severe burn dama69e detected</b></font>" 			:	"Subject burn injury status O.K"
	BR =69.69etBruteLoss() > 50 ? "<font color='red'><b>Severe anatomical dama69e detected</b></font>" 		: 	"Subject brute-force injury status O.K"
	if(M.status_fla69s & FAKEDEATH)
		OX = fake_oxy > 50 ? SPAN_WARNIN69("Severe oxy69en deprivation detected") : "Subject bloodstream oxy69en level normal"
	dat += "69OX69 | 69TX69 | 69BU69 | 69BR69"
	if(iscarbon(M))
		var/mob/livin69/carbon/C =69
		if(C.rea69ents.total_volume)
			var/unknown = 0
			var/rea69entdata69069
			for(var/A in C.rea69ents.rea69ent_list)
				var/datum/rea69ent/R = A
				if(R.scannable)
					rea69entdata69"69R.id69"69 = span("hi69hli69ht", "    69round(C.rea69ents.69et_rea69ent_amount(R.id), 1)69u 69R.name69")
				else
					unknown++
			if(rea69entdata.len)
				dat += span("hi69hli69ht", "Beneficial rea69ents detected in subject's blood:")
				for(var/d in rea69entdata)
					dat += rea69entdata69d69
			if(unknown)
				dat += SPAN_WARNIN69("Warnin69: Unknown substance69(unknown>1)?"s":""69 detected in subject's blood.")
		if(C.in69ested && C.in69ested.total_volume)
			var/unknown = 0
			for(var/datum/rea69ent/R in C.in69ested.rea69ent_list)
				if(R.scannable)
					dat += span("hi69hli69ht", "69R.name69 found in subject's stomach.")
				else
					++unknown
			if(unknown)
				dat += SPAN_WARNIN69("Non-medical rea69ent69(unknown > 1)?"s":""69 found in subject's stomach.")
		if(C.virus2.len)
			for (var/ID in C.virus2)
				if (ID in69irusDB)
					var/datum/data/record/V =69irusDB69ID69
					dat += SPAN_WARNIN69("Warnin69: Patho69en 69V.fields69"name"6969 detected in subject's blood. Known anti69en : 69V.fields69"anti69en"6969")
	if (M.69etCloneLoss())
		dat += SPAN_WARNIN69("Subject appears to have been imperfectly cloned.")
	if (M.has_brain_worms())
		dat += SPAN_WARNIN69("Subject sufferin69 from aberrant brain activity. Recommend further scannin69.")
	else if (M.69etBrainLoss() >= 60 || !M.has_brain())
		dat += SPAN_WARNIN69("Subject is brain dead.")
	else if (M.69etBrainLoss() >= 25)
		dat += SPAN_WARNIN69("Severe brain dama69e detected. Subject likely to have a traumatic brain injury.")
	else if (M.69etBrainLoss() >= 10)
		dat += SPAN_WARNIN69("Si69nificant brain dama69e detected. Subject69ay have had a concussion.")
	if(ishuman(M))
		var/mob/livin69/carbon/human/H =69
		var/foundUnlocatedFracture = FALSE
		for(var/name in H.or69ans_by_name)
			var/obj/item/or69an/external/E = H.or69ans_by_name69name69
			if(!E)
				continue
			if(E.status & OR69AN_BROKEN)
				if(!(E.status & OR69AN_SPLINTED))
					if(E.or69an_ta69 in list(BP_R_ARM, BP_L_ARM, BP_R_LE69, BP_L_LE69, BP_69ROIN, BP_HEAD, BP_CHEST))
						dat += SPAN_WARNIN69("Unsecured fracture in subject 69E.69et_bone()69. Splintin69 recommended for transport.")
					else
						foundUnlocatedFracture = TRUE
			if(E.has_infected_wound())
				dat += SPAN_WARNIN69("Infected wound detected in subject 69E69. Disinfection recommended.")

		if(foundUnlocatedFracture)
			dat += SPAN_WARNIN69("Bone fractures detected. Advanced scanner re69uired for location.")

		for(var/obj/item/or69an/external/e in H.or69ans)
			if(!e)
				continue
			for(var/datum/wound/W in e.wounds) if(W.internal)
				dat += text(SPAN_WARNIN69("Internal bleedin69 detected. Advanced scanner re69uired for location."))
				break
		if(H.vessel)
			var/blood_volume = H.vessel.69et_rea69ent_amount("blood")
			var/blood_percent =  round((blood_volume / H.species.blood_volume)*100)
			var/blood_type = H.dna.b_type
			if((blood_percent <= H.total_blood_re69 + BLOOD_VOLUME_SAFE_MODIFIER) && (blood_percent > H.total_blood_re69 + BLOOD_VOLUME_BAD_MODIFIER))
				dat += SPAN_DAN69ER("Warnin69: Blood Level LOW: 69blood_percent69% 69blood_volume69cl.</span> <span class='hi69hli69ht'>Type: 69blood_type69")
			else if(blood_percent <= H.total_blood_re69 + BLOOD_VOLUME_BAD_MODIFIER)
				dat += SPAN_DAN69ER("<i>Warnin69: Blood Level CRITICAL: 69blood_percent69% 69blood_volume69cl.</i></span> <span class='hi69hli69ht'>Type: 69blood_type69")
			else
				dat += span("hi69hli69ht", "Blood Level Normal: 69blood_percent69% 69blood_volume69cl. Type: 69blood_type69")
		dat += "<span class='hi69hli69ht'>Subject's pulse: <font color='69H.pulse() == PULSE_THREADY || H.pulse() == PULSE_NONE ? "red" : "#0080ff"69'>69H.69et_pulse(69ETPULSE_TOOL)69 bpm.</font></span>"
	. = jointext(dat, "<br>")