
/obj/item/device/scanner/health
	name = "health analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	icon_state = "health0"
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

/*	if ((CLUMSY in user.mutations) && prob(50))
		. = list()

		user.visible_message(SPAN_NOTICE("\The [user] runs \the [scanner] over the floor."))
		. += span("highlight", "<b>Scan results for the floor:</b>")
		. += span("highlight", "Overall Status: Healthy")
		return jointext(., "<br>")
*/
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

	var/fake_oxy = max(rand(1, 40), M.getOxyLoss(), (300 - (M.getFireLoss() + M.getBruteLoss())))
	var/tox_content = M.chem_effects[CE_TOXIN] + M.chem_effects[CE_ALCOHOL_TOXIC]
	var/OX = M.getOxyLoss() > 50 	? 	"<b>[M.getOxyLoss()]</b>" 		: M.getOxyLoss()
	var/TX = tox_content			?	"<b>[tox_content]</b>"			: (tox_content ? tox_content : "0")
	var/BR = M.getBruteLoss() > 50 	? 	"<b>[M.getBruteLoss()]</b>" 	: M.getBruteLoss()
	var/BU = M.getFireLoss() > 50 	? 	"<b>[M.getFireLoss()]</b>" 		: M.getFireLoss()

	if(M.status_flags & FAKEDEATH)
		OX = fake_oxy > 50 			? 	"<b>[fake_oxy]</b>" 			: fake_oxy
		dat += "<h2>Analyzing Results for [M]:</h2>"
		dat += span("highlight", "Overall Status: dead")
	else
		dat += span("highlight", "Analyzing Results for [M]:\n\t Overall Status: [M.stat > 1 ? "dead" : "alive"]")
	dat += span("highlight", "    Key: <font color='#0080ff'>Suffocation</font>/<font color='green'>Toxin</font>/<font color='red'>Brute</font>/<font color='#FFA500'>Burns</font>")
	dat += span("highlight", "    Damage Specifics: <font color='#0080ff'>[OX]</font> - <font color='green'>[TX]</font> - <font color='red'>[BR]</font> - <font color='#FFA500'>[BU]</font>")
	dat += span("highlight", "Body Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)")
	if(M.timeofdeath && (M.stat == DEAD || (M.status_flags & FAKEDEATH)))
		dat += span("highlight", "Time of Death: [worldtime2stationtime(M.timeofdeath)]")
	if(ishuman(M) && mode == 1)
		var/mob/living/carbon/human/H = M
		var/list/damaged = H.get_damaged_organs(1, 1)
		dat += span("highlight", "Localized Damage:")
		if(length(damaged) > 0)
			for(var/obj/item/organ/external/org in damaged)
				var/brute_health = org.max_damage - org.brute_dam
				var/burn_health = org.max_damage - org.burn_dam
				var/internal_wound_severity = org.severity_internal_wounds

				if(internal_wound_severity > 0)
					if(internal_wound_severity < 4)
						internal_wound_severity = "Light"
					else if(internal_wound_severity < 7)
						internal_wound_severity = "Moderate"
					else
						internal_wound_severity = "Severe"
				else
					internal_wound_severity = null

				dat += text("<span class='highlight'>     [][]:  [] - [] - [] [] []</span>",
				capitalize(org.name),
				(BP_IS_ROBOTIC(org)) ? "(Cybernetic)" : "",
				"<font color='red'>[brute_health ? brute_health : "0"] / [org.max_damage]</font>",
				"<font color='#FFA500'>[burn_health ? burn_health : "0"] / [org.max_damage]</font>",
				(org.status & ORGAN_BLEEDING) ? "<font color='red'>\[Bleeding\]</font>" : "",
				(org.status & ORGAN_BROKEN && !(org.status & ORGAN_SPLINTED)) ? "<font color='red'>\[Broken\]</font>" : "",
				internal_wound_severity ? "<font color='red'>\[[internal_wound_severity] Organ Wounds\]</font>" : "")
		else
			dat += span("highlight", "Limbs are OK.")
	OX = M.getOxyLoss() > 50 ? 	 "<font color='#0080ff'><b>Severe oxygen deprivation detected</b></font>" 		: 	"Subject bloodstream oxygen level normal"
	TX = tox_content > 12 ? 	 "<font color='green'><b>Dangerous amount of toxins detected</b></font>" 	: 	"Subject bloodstream toxin level minimal"
	if(M.status_flags & FAKEDEATH)
		OX = fake_oxy > 50 ? SPAN_WARNING("Severe oxygen deprivation detected") : "Subject bloodstream oxygen level normal"
	dat += "[OX] | [TX]"
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

		if(H.vessel)
			var/blood_volume = H.vessel.get_reagent_amount("blood")
			var/blood_percent =  round((blood_volume / H.species.blood_volume)*100)
			var/blood_type = H.b_type
			if((blood_percent <= H.total_blood_req + BLOOD_VOLUME_SAFE_MODIFIER) && (blood_percent > H.total_blood_req + BLOOD_VOLUME_BAD_MODIFIER))
				dat += "<font color='red'>Warning: Blood Level LOW: [blood_percent]% [blood_volume]cl.</font> <span class='highlight'>Type: [blood_type]</span>"
			else if(blood_percent <= H.total_blood_req + BLOOD_VOLUME_BAD_MODIFIER)
				dat += "<font color='red'><i>Warning: Blood Level CRITICAL: [blood_percent]% [blood_volume]cl.</i></font> <span class='highlight'>Type: [blood_type]</span>"
			else
				dat += span("highlight", "Blood Level Normal: [blood_percent]% [blood_volume]cl. Type: [blood_type]")
		dat += "<span class='highlight'>Subject's pulse: <font color='[H.pulse() == PULSE_THREADY || H.pulse() == PULSE_NONE ? "red" : "#0080ff"]'>[H.get_pulse(GETPULSE_TOOL)] bpm.</font></span>"
	. = jointext(dat, "<br>")

/obj/item/device/scanner/health/cell_use_check(charge, mob/user)
	. = TRUE
	icon_state = "health"
	if(!cell || !cell.checked_use(charge))
		if(user)
			to_chat(user, SPAN_WARNING("[src] battery is dead or missing."))
		. = FALSE
		icon_state = "health0"

/obj/item/device/scanner/health/cell_check(charge, mob/user)
	. = TRUE
	icon_state = "health"
	if(!cell || !cell.check_charge(charge))
		if(user)
			to_chat(user, SPAN_WARNING("[src] battery is dead or missing."))
		. = FALSE
		icon_state = "health0"
