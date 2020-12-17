
/obj/item/device/scanner/health
	name = "health analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	icon_state = "health"
	item_state = "analyzer"
	throw_speed = 5
	throw_range = 10

	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)
	origin_tech = list(TECH_MAGNET = 1, TECH_BIO = 1)
	rarity_value = 16.66

	var/mode = 1

	window_width = 600
	window_height = 400

/obj/item/device/scanner/health/is_valid_scan_target(atom/O)
	return istype(O, /mob/living) || istype(O, /obj/structure/closet/body_bag)

/obj/item/device/scanner/health/scan(atom/A, mob/user)
	scan_data = medical_scan_action(A, user, src, mode)
	scan_title = "Health scan - [A]"
	show_results(user)
	flick("health2", src)

/obj/item/device/scanner/health/verb/toggle_mode()
	set name = "Switch Verbosity"
	set category = "Object"

	mode = !mode
	switch (mode)
		if(1)
			to_chat(usr, "The scanner now shows specific limb damage.")
		if(0)
			to_chat(usr, "The scanner no longer shows limb damage.")

/proc/medical_scan_action(atom/target, mob/living/user, obj/scanner, var/mode)
	if (!user.IsAdvancedToolUser())
		to_chat(user, SPAN_WARNING("You are not nimble enough to use this device."))
		return

	if ((CLUMSY in user.mutations) && prob(50))
		. = list()

		user.visible_message(SPAN_NOTICE("\The [user] runs \the [scanner] over the floor."))
		. += span("highlight", "<b>Scan results for the floor:</b>")
		. += span("highlight", "Overall Status: Healthy")
		return jointext(., "<br>")

	var/mob/living/carbon/human/scan_subject = null
	if (istype(target, /mob/living/carbon/human))
		scan_subject = target
	else if (istype(target, /obj/structure/closet/body_bag))
		var/obj/structure/closet/body_bag/B = target
		if(!B.opened)
			var/list/scan_content = list()
			for(var/mob/living/L in B.contents)
				scan_content.Add(L)

			if (scan_content.len == 1)
				for(var/mob/living/carbon/human/L in scan_content)
					scan_subject = L
			else if (scan_content.len > 1)
				to_chat(user, SPAN_WARNING("\The [scanner] picks up multiple readings inside \the [target], too close together to scan properly."))
				return
			else
				to_chat(user, "\The [scanner] does not detect anyone inside \the [target].")
				return

	if(!scan_subject)
		return

	if (scan_subject.isSynthetic())
		to_chat(user, SPAN_WARNING("\The [scanner] is designed for organic humanoid patients only."))
		return

	user.visible_message(SPAN_NOTICE("[user] has analyzed [target]'s vitals."),SPAN_NOTICE("You have analyzed [target]'s vitals."))
	. = medical_scan_results(scan_subject, mode)

/proc/medical_scan_results(var/mob/living/M, var/mode)
	. = list()
	var/dat = list()
	if (!ishuman(M) || M.isSynthetic())
		//these sensors are designed for organic life
		. += "<h2>Analyzing Results for ERROR:\n\t Overall Status: ERROR</h2>"
		. += span("highlight", "    Key: <font color='#0080ff'>Suffocation</font>/<font color='green'>Toxin</font>/<font color='#FFA500'>Burns</font>/<font color='red'>Brute</font>")
		. += span("highlight", "    Damage Specifics: <font color='#0080ff'>?</font> - <font color='green'>?</font> - <font color='#FFA500'>?</font> - <font color='red'>?</font>")
		. += span("highlight", "Body Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)")
		. += SPAN_WARNING("Warning: Blood Level ERROR: --% --cl.</span> <span class='notice'>Type: ERROR")
		. += span("highlight", "Subject's pulse: <font color='red'>-- bpm.</font>")
		return

	var/fake_oxy = max(rand(1, 40), M.getOxyLoss(), (300 - (M.getToxLoss() + M.getFireLoss() + M.getBruteLoss())))
	var/OX = M.getOxyLoss() > 50 	? 	"<b>[M.getOxyLoss()]</b>" 		: M.getOxyLoss()
	var/TX = M.getToxLoss() > 50 	? 	"<b>[M.getToxLoss()]</b>" 		: M.getToxLoss()
	var/BU = M.getFireLoss() > 50 	? 	"<b>[M.getFireLoss()]</b>" 		: M.getFireLoss()
	var/BR = M.getBruteLoss() > 50 	? 	"<b>[M.getBruteLoss()]</b>" 	: M.getBruteLoss()
	if(M.status_flags & FAKEDEATH)
		OX = fake_oxy > 50 			? 	"<b>[fake_oxy]</b>" 			: fake_oxy
		dat += "<h2>Analyzing Results for [M]:</h2>"
		dat += span("highlight", "Overall Status: dead")
	else
		dat += span("highlight", "Analyzing Results for [M]:\n\t Overall Status: [M.stat > 1 ? "dead" : "[round(M.health/M.maxHealth*100)]% healthy"]")
	dat += span("highlight", "    Key: <font color='#0080ff'>Suffocation</font>/<font color='green'>Toxin</font>/<font color='#FFA500'>Burns</font>/<font color='red'>Brute</font>")
	dat += span("highlight", "    Damage Specifics: <font color='#0080ff'>[OX]</font> - <font color='green'>[TX]</font> - <font color='#FFA500'>[BU]</font> - <font color='red'>[BR]</font>")
	dat += span("highlight", "Body Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)")
	if(M.timeofdeath && (M.stat == DEAD || (M.status_flags & FAKEDEATH)))
		dat += span("highlight", "Time of Death: [worldtime2stationtime(M.timeofdeath)]")
	if(ishuman(M) && mode == 1)
		var/mob/living/carbon/human/H = M
		var/list/damaged = H.get_damaged_organs(1, 1)
		dat += span("highlight", "Localized Damage, Brute/Burn:")
		if(length(damaged) > 0)
			for(var/obj/item/organ/external/org in damaged)
				dat += text("<span class='highlight'>     [][]: [][] - []</span>",
				capitalize(org.name),
				(BP_IS_ROBOTIC(org)) ? "(Cybernetic)" : "",
				(org.brute_dam > 0) ? SPAN_WARNING("[org.brute_dam]") : 0,
				(org.status & ORGAN_BLEEDING)?SPAN_DANGER("\[Bleeding\]"):"",
				(org.burn_dam > 0) ? "<font color='#FFA500'>[org.burn_dam]</font>" : 0)
		else
			dat += span("highlight", "    Limbs are OK.")

	OX = M.getOxyLoss() > 50 ? 	 "<font color='#0080ff'><b>Severe oxygen deprivation detected</b></font>" 		: 	"Subject bloodstream oxygen level normal"
	TX = M.getToxLoss() > 50 ? 	 "<font color='green'><b>Dangerous amount of toxins detected</b></font>" 	: 	"Subject bloodstream toxin level minimal"
	BU = M.getFireLoss() > 50 ?  "<font color='#FFA500'><b>Severe burn damage detected</b></font>" 			:	"Subject burn injury status O.K"
	BR = M.getBruteLoss() > 50 ? "<font color='red'><b>Severe anatomical damage detected</b></font>" 		: 	"Subject brute-force injury status O.K"
	if(M.status_flags & FAKEDEATH)
		OX = fake_oxy > 50 ? SPAN_WARNING("Severe oxygen deprivation detected") : "Subject bloodstream oxygen level normal"
	dat += "[OX] | [TX] | [BU] | [BR]"
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(C.reagents.total_volume)
			var/unknown = 0
			var/reagentdata[0]
			for(var/A in C.reagents.reagent_list)
				var/datum/reagent/R = A
				if(R.scannable)
					reagentdata["[R.id]"] = span("highlight", "    [round(C.reagents.get_reagent_amount(R.id), 1)]u [R.name]")
				else
					unknown++
			if(reagentdata.len)
				dat += span("highlight", "Beneficial reagents detected in subject's blood:")
				for(var/d in reagentdata)
					dat += reagentdata[d]
			if(unknown)
				dat += SPAN_WARNING("Warning: Unknown substance[(unknown>1)?"s":""] detected in subject's blood.")
		if(C.ingested && C.ingested.total_volume)
			var/unknown = 0
			for(var/datum/reagent/R in C.ingested.reagent_list)
				if(R.scannable)
					dat += span("highlight", "[R.name] found in subject's stomach.")
				else
					++unknown
			if(unknown)
				dat += SPAN_WARNING("Non-medical reagent[(unknown > 1)?"s":""] found in subject's stomach.")
		if(C.virus2.len)
			for (var/ID in C.virus2)
				if (ID in virusDB)
					var/datum/data/record/V = virusDB[ID]
					dat += SPAN_WARNING("Warning: Pathogen [V.fields["name"]] detected in subject's blood. Known antigen : [V.fields["antigen"]]")
	if (M.getCloneLoss())
		dat += SPAN_WARNING("Subject appears to have been imperfectly cloned.")
	if (M.has_brain_worms())
		dat += SPAN_WARNING("Subject suffering from aberrant brain activity. Recommend further scanning.")
	else if (M.getBrainLoss() >= 60 || !M.has_brain())
		dat += SPAN_WARNING("Subject is brain dead.")
	else if (M.getBrainLoss() >= 25)
		dat += SPAN_WARNING("Severe brain damage detected. Subject likely to have a traumatic brain injury.")
	else if (M.getBrainLoss() >= 10)
		dat += SPAN_WARNING("Significant brain damage detected. Subject may have had a concussion.")
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/foundUnlocatedFracture = FALSE
		for(var/name in H.organs_by_name)
			var/obj/item/organ/external/E = H.organs_by_name[name]
			if(!E)
				continue
			if(E.status & ORGAN_BROKEN)
				if(!(E.status & ORGAN_SPLINTED))
					if(E.organ_tag in list(BP_R_ARM, BP_L_ARM, BP_R_LEG, BP_L_LEG))
						dat += SPAN_WARNING("Unsecured fracture in subject [E.get_bone()]. Splinting recommended for transport.")
					else
						foundUnlocatedFracture = TRUE
			if(E.has_infected_wound())
				dat += SPAN_WARNING("Infected wound detected in subject [E]. Disinfection recommended.")

		if(foundUnlocatedFracture)
			dat += SPAN_WARNING("Bone fractures detected. Advanced scanner required for location.")

		for(var/obj/item/organ/external/e in H.organs)
			if(!e)
				continue
			for(var/datum/wound/W in e.wounds) if(W.internal)
				dat += text(SPAN_WARNING("Internal bleeding detected. Advanced scanner required for location."))
				break
		if(H.vessel)
			var/blood_volume = H.vessel.get_reagent_amount("blood")
			var/blood_percent =  round((blood_volume / H.species.blood_volume)*100)
			var/blood_type = H.dna.b_type
			if((blood_percent <= BLOOD_VOLUME_SAFE) && (blood_percent > BLOOD_VOLUME_BAD))
				dat += SPAN_DANGER("Warning: Blood Level LOW: [blood_percent]% [blood_volume]cl.</span> <span class='highlight'>Type: [blood_type]")
			else if(blood_percent <= BLOOD_VOLUME_BAD)
				dat += SPAN_DANGER("<i>Warning: Blood Level CRITICAL: [blood_percent]% [blood_volume]cl.</i></span> <span class='highlight'>Type: [blood_type]")
			else
				dat += span("highlight", "Blood Level Normal: [blood_percent]% [blood_volume]cl. Type: [blood_type]")
		dat += "<span class='highlight'>Subject's pulse: <font color='[H.pulse() == PULSE_THREADY || H.pulse() == PULSE_NONE ? "red" : "#0080ff"]'>[H.get_pulse(GETPULSE_TOOL)] bpm.</font></span>"
	. = jointext(dat, "<br>")