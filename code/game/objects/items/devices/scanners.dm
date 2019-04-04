/*
CONTAINS:
T-RAY
DETECTIVE SCANNER
HEALTH ANALYZER
GAS ANALYZER
MASS SPECTROMETER
REAGENT SCANNER
*/
/obj/item/device/scanner
	name = "scanner"
	desc = "basic scanner unit"
	icon_state = "multitool"
	item_state = null
	flags = CONDUCT
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_SMALL
	throwforce = WEAPON_FORCE_HARMLESS
	throw_speed = 4
	throw_range = 20

	origin_tech = null

	var/obj/item/weapon/cell/cell = null
	var/suitable_cell = /obj/item/weapon/cell/small

//slime

	throw_speed = 3
	throw_range = 7

	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)
	origin_tech = list(TECH_BIO = 1)

/obj/item/device/scanner/proc/cell_check()
	if(!cell && suitable_cell)
		cell = new suitable_cell(src)

//all user was replased on usr
/obj/item/device/scanner/proc/cell_use_check(charge)
	. = TRUE
	if(!cell || !cell.checked_use(charge))
		usr << SPAN_WARNING("[src] battery is dead or missing.")
		. = FALSE

/obj/item/device/scanner/New()
	..()
	cell_check()

/obj/item/device/scanner/healthanalyzer
	name = "health analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	icon_state = "health"
	item_state = "analyzer"
	throw_speed = 5
	throw_range = 10

	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)
	origin_tech = list(TECH_MAGNET = 1, TECH_BIO = 1)

	var/mode = 1

/obj/item/device/scanner/healthanalyzer/attack(mob/living/M, mob/living/user)
	if(!cell_use_check(3))
		return
	if(user.incapacitated())
		return
	if ((CLUMSY in user.mutations) && prob(50))
		user << SPAN_WARNING("You try to analyze the floor's vitals!")
		for(var/mob/O in viewers(M, null))
			O.show_message(SPAN_WARNING("\The [user] has analyzed the floor's vitals!"), 1)
		user.show_message(SPAN_NOTICE("Analyzing Results for The floor:"), 1)
		user.show_message("Overall Status: Healthy</span>", 1)
		user.show_message(SPAN_NOTICE("    Damage Specifics: 0-0-0-0"), 1)
		user.show_message(SPAN_NOTICE("Key: Suffocation/Toxin/Burns/Brute"), 1)
		user.show_message(SPAN_NOTICE("Body Temperature: ???"), 1)
		return
	if(!user.IsAdvancedToolUser())
		return
	flick("health2", src)
	user.visible_message(SPAN_NOTICE("[user] has analyzed [M]'s vitals."),SPAN_NOTICE("You have analyzed [M]'s vitals."))

	if (!ishuman(M) || M.isSynthetic())
		//these sensors are designed for organic life
		user.show_message(SPAN_NOTICE("Analyzing Results for ERROR:\n\t Overall Status: ERROR"))
		user.show_message(SPAN_NOTICE("    Key: <font color='blue'>Suffocation</font>/<font color='green'>Toxin</font>/<font color='#FFA500'>Burns</font>/<font color='red'>Brute</font>"), 1)
		user.show_message(SPAN_NOTICE("    Damage Specifics: <font color='blue'>?</font> - <font color='green'>?</font> - <font color='#FFA500'>?</font> - <font color='red'>?</font>"))
		user.show_message(SPAN_NOTICE("Body Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)"), 1)
		user.show_message(SPAN_WARNING("Warning: Blood Level ERROR: --% --cl.</span> <span class='notice'>Type: ERROR"))
		user.show_message(SPAN_NOTICE("Subject's pulse: <font color='red'>-- bpm.</font>"))
		return

	var/fake_oxy = max(rand(1, 40), M.getOxyLoss(), (300 - (M.getToxLoss() + M.getFireLoss() + M.getBruteLoss())))
	var/OX = M.getOxyLoss() > 50 	? 	"<b>[M.getOxyLoss()]</b>" 		: M.getOxyLoss()
	var/TX = M.getToxLoss() > 50 	? 	"<b>[M.getToxLoss()]</b>" 		: M.getToxLoss()
	var/BU = M.getFireLoss() > 50 	? 	"<b>[M.getFireLoss()]</b>" 		: M.getFireLoss()
	var/BR = M.getBruteLoss() > 50 	? 	"<b>[M.getBruteLoss()]</b>" 	: M.getBruteLoss()
	if(M.status_flags & FAKEDEATH)
		OX = fake_oxy > 50 			? 	"<b>[fake_oxy]</b>" 			: fake_oxy
		user.show_message(SPAN_NOTICE("Analyzing Results for [M]:"))
		user.show_message(SPAN_NOTICE("Overall Status: dead"))
	else
		user.show_message("<span class='notice'>Analyzing Results for [M]:\n\t Overall Status: [M.stat > 1 ? "dead" : "[round(M.health/M.maxHealth*100)]% healthy"]</span>")
	user.show_message(SPAN_NOTICE("    Key: <font color='blue'>Suffocation</font>/<font color='green'>Toxin</font>/<font color='#FFA500'>Burns</font>/<font color='red'>Brute</font>"), 1)
	user.show_message(SPAN_NOTICE("    Damage Specifics: <font color='blue'>[OX]</font> - <font color='green'>[TX]</font> - <font color='#FFA500'>[BU]</font> - <font color='red'>[BR]</font>"))
	user.show_message(SPAN_NOTICE("Body Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)"), 1)
	if(M.tod && (M.stat == DEAD || (M.status_flags & FAKEDEATH)))
		user.show_message(SPAN_NOTICE("Time of Death: [M.tod]"))
	if(ishuman(M) && mode == 1)
		var/mob/living/carbon/human/H = M
		var/list/damaged = H.get_damaged_organs(1, 1)
		user.show_message(SPAN_NOTICE("Localized Damage, Brute/Burn:"), 1)
		if(length(damaged) > 0)
			for(var/obj/item/organ/external/org in damaged)
				user.show_message(text("<span class='notice'>     [][]: [][] - []</span>",
				capitalize(org.name),
				(org.robotic >= ORGAN_ROBOT) ? "(Cybernetic)" : "",
				(org.brute_dam > 0) ? SPAN_WARNING("[org.brute_dam]") : 0,
				(org.status & ORGAN_BLEEDING)?SPAN_DANGER("\[Bleeding\]"):"",
				(org.burn_dam > 0) ? "<font color='#FFA500'>[org.burn_dam]</font>" : 0), 1)
		else
			user.show_message(SPAN_NOTICE("    Limbs are OK."), 1)

	OX = M.getOxyLoss() > 50 ? 	 "<font color='blue'><b>Severe oxygen deprivation detected</b></font>" 		: 	"Subject bloodstream oxygen level normal"
	TX = M.getToxLoss() > 50 ? 	 "<font color='green'><b>Dangerous amount of toxins detected</b></font>" 	: 	"Subject bloodstream toxin level minimal"
	BU = M.getFireLoss() > 50 ?  "<font color='#FFA500'><b>Severe burn damage detected</b></font>" 			:	"Subject burn injury status O.K"
	BR = M.getBruteLoss() > 50 ? "<font color='red'><b>Severe anatomical damage detected</b></font>" 		: 	"Subject brute-force injury status O.K"
	if(M.status_flags & FAKEDEATH)
		OX = fake_oxy > 50 ? SPAN_WARNING("Severe oxygen deprivation detected") : "Subject bloodstream oxygen level normal"
	user.show_message("[OX] | [TX] | [BU] | [BR]")
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(C.reagents.total_volume)
			var/unknown = 0
			var/reagentdata[0]
			for(var/A in C.reagents.reagent_list)
				var/datum/reagent/R = A
				if(R.scannable)
					reagentdata["[R.id]"] = SPAN_NOTICE("    [round(C.reagents.get_reagent_amount(R.id), 1)]u [R.name]")
				else
					unknown++
			if(reagentdata.len)
				user.show_message(SPAN_NOTICE("Beneficial reagents detected in subject's blood:"))
				for(var/d in reagentdata)
					user.show_message(reagentdata[d])
			if(unknown)
				user.show_message("<span class='warning'>Warning: Unknown substance[(unknown>1)?"s":""] detected in subject's blood.</span>")
		if(C.ingested && C.ingested.total_volume)
			var/unknown = 0
			for(var/datum/reagent/R in C.ingested.reagent_list)
				if(R.scannable)
					user << SPAN_NOTICE("[R.name] found in subject's stomach.")
				else
					++unknown
			if(unknown)
				user << "<span class='warning'>Non-medical reagent[(unknown > 1)?"s":""] found in subject's stomach.</span>"
		if(C.virus2.len)
			for (var/ID in C.virus2)
				if (ID in virusDB)
					var/datum/data/record/V = virusDB[ID]
					user.show_message("<span class='warning'>Warning: Pathogen [V.fields["name"]] detected in subject's blood. Known antigen : [V.fields["antigen"]]</span>")
	if (M.getCloneLoss())
		user.show_message(SPAN_WARNING("Subject appears to have been imperfectly cloned."))
	if (M.has_brain_worms())
		user.show_message(SPAN_WARNING("Subject suffering from aberrant brain activity. Recommend further scanning."))
	else if (M.getBrainLoss() >= 60 || !M.has_brain())
		user.show_message(SPAN_WARNING("Subject is brain dead."))
	else if (M.getBrainLoss() >= 25)
		user.show_message(SPAN_WARNING("Severe brain damage detected. Subject likely to have a traumatic brain injury."))
	else if (M.getBrainLoss() >= 10)
		user.show_message(SPAN_WARNING("Significant brain damage detected. Subject may have had a concussion."))
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
						user << SPAN_WARNING("Unsecured fracture in subject [E]. Splinting recommended for transport.")
					else
						foundUnlocatedFracture = TRUE
			if(E.has_infected_wound())
				user << SPAN_WARNING("Infected wound detected in subject [E]. Disinfection recommended.")

		if(foundUnlocatedFracture)
			user.show_message(SPAN_WARNING("Bone fractures detected. Advanced scanner required for location."), 1)

		for(var/obj/item/organ/external/e in H.organs)
			if(!e)
				continue
			for(var/datum/wound/W in e.wounds) if(W.internal)
				user.show_message(text(SPAN_WARNING("Internal bleeding detected. Advanced scanner required for location.")), 1)
				break
		if(H.vessel)
			var/blood_volume = H.vessel.get_reagent_amount("blood")
			var/blood_percent =  round((blood_volume / H.species.blood_volume)*100)
			var/blood_type = H.dna.b_type
			if((blood_percent <= BLOOD_VOLUME_SAFE) && (blood_percent > BLOOD_VOLUME_BAD))
				user.show_message(SPAN_DANGER("Warning: Blood Level LOW: [blood_percent]% [blood_volume]cl.</span> <span class='notice'>Type: [blood_type]"))
			else if(blood_percent <= BLOOD_VOLUME_BAD)
				user.show_message(SPAN_DANGER("<i>Warning: Blood Level CRITICAL: [blood_percent]% [blood_volume]cl.</i></span> <span class='notice'>Type: [blood_type]"))
			else
				user.show_message(SPAN_NOTICE("Blood Level Normal: [blood_percent]% [blood_volume]cl. Type: [blood_type]"))
		user.show_message("<span class='notice'>Subject's pulse: <font color='[H.pulse() == PULSE_THREADY || H.pulse() == PULSE_NONE ? "red" : "blue"]'>[H.get_pulse(GETPULSE_TOOL)] bpm.</font></span>")
	src.add_fingerprint(user)

/obj/item/device/scanner/healthanalyzer/verb/toggle_mode()
	set name = "Switch Verbosity"
	set category = "Object"

	mode = !mode
	switch (mode)
		if(1)
			usr << "The scanner now shows specific limb damage."
		if(0)
			usr << "The scanner no longer shows limb damage."

/obj/item/device/scanner/healthanalyzer/MouseDrop(over_object)
	if((src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
		cell = null

/obj/item/device/scanner/healthanalyzer/attackby(obj/item/C, mob/living/user)
	if(istype(C, suitable_cell) && !cell && insert_item(C, user))
		src.cell = C


/obj/item/device/scanner/analyzer
	name = "analyzer"
	desc = "A hand-held environmental scanner which reports current gas levels."
	icon_state = "atmos"
	item_state = "analyzer"

	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)
	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)

/obj/item/device/scanner/analyzer/attack_self(mob/user as mob)
	if (!user.IsAdvancedToolUser())
		return
	if(!cell_use_check(3))
		return
	flick("atmos2", src)
	analyze_gases(user.loc, user)

/obj/item/device/scanner/analyzer/MouseDrop(over_object)
	if((src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
		cell = null

/obj/item/device/scanner/analyzer/attackby(obj/item/C, mob/living/user)
	if(istype(C, suitable_cell) && !cell && insert_item(C, user))
		src.cell = C

/obj/item/device/scanner/analyzer/afterattack(obj/O, mob/user, proximity)
	if(!proximity)
		return
	if (!user.IsAdvancedToolUser())
		return
	if(!(istype(O) && O.simulated))
		return
	if(!cell_use_check(5))
		return
	flick("atmos2", src)
	analyze_gases(O, user)


/obj/item/device/scanner/mass_spectrometer
	name = "mass spectrometer"
	desc = "A hand-held mass spectrometer which identifies trace chemicals in a blood sample."
	icon_state = "spectrometer"
	item_state = "analyzer"
	flags = CONDUCT
	reagent_flags = OPENCONTAINER

	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)

	var/details = 0
	var/recent_fail = 0

/obj/item/device/scanner/mass_spectrometer/New()
	..()
	var/datum/reagents/R = new/datum/reagents(5)
	reagents = R
	R.my_atom = src

/obj/item/device/scanner/mass_spectrometer/on_reagent_change()
	if(reagents.total_volume)
		icon_state = initial(icon_state) + "_s"
	else
		icon_state = initial(icon_state)

/obj/item/device/scanner/mass_spectrometer/attack_self(mob/user as mob)
	if(!cell_use_check(7))
		return
	if (user.incapacitated())
		return
	if (!user.IsAdvancedToolUser())
		return
	if(reagents.total_volume)
		var/list/blood_traces = list()
		for(var/datum/reagent/R in reagents.reagent_list)
			if(R.id != "blood")
				reagents.clear_reagents()
				user << SPAN_WARNING("The sample was contaminated! Please insert another sample")
				return
			else
				blood_traces = params2list(R.data["trace_chem"])
				break
		var/dat = "Trace Chemicals Found: "
		for(var/R in blood_traces)
			if(details)
				dat += "[R] ([blood_traces[R]] units) "
			else
				dat += "[R] "
		user << "[dat]"
		reagents.clear_reagents()

/obj/item/device/scanner/mass_spectrometer/MouseDrop(over_object)
	if((src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
		cell = null

/obj/item/device/scanner/mass_spectrometer/attackby(obj/item/C, mob/living/user)
	if(istype(C, suitable_cell) && !cell && insert_item(C, user))
		src.cell = C


/obj/item/device/scanner/mass_spectrometer/adv
	name = "advanced mass spectrometer"
	icon_state = "adv_spectrometer"
	details = 1
	origin_tech = list(TECH_MAGNET = 4, TECH_BIO = 2)


/obj/item/device/scanner/reagent_scanner
	name = "reagent scanner"
	desc = "A hand-held reagent scanner which identifies chemical agents."
	icon_state = "spectrometer"
	item_state = "analyzer"
	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)

	var/details = 0
	var/recent_fail = 0

/obj/item/device/scanner/reagent_scanner/afterattack(obj/O, mob/user as mob, proximity)
	if(!cell_use_check(7))
		return
	if(!proximity)
		return
	if (user.incapacitated())
		return
	if (!user.IsAdvancedToolUser())
		return
	if(!istype(O))
		return
	if(!isnull(O.reagents))
		var/dat = ""
		if(O.reagents.reagent_list.len > 0)
			var/one_percent = O.reagents.total_volume / 100
			for (var/datum/reagent/R in O.reagents.reagent_list)
				dat += "\n \t <span class='notice'>[R][details ? ": [R.volume / one_percent]%" : ""]"
		if(dat)
			user << SPAN_NOTICE("Chemicals found: [dat]")
		else
			user << SPAN_NOTICE("No active chemical agents found in [O].")
	else
		user << SPAN_NOTICE("No significant chemical agents found in [O].")

/obj/item/device/scanner/reagent_scanner/MouseDrop(over_object)
	if((src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
		cell = null

/obj/item/device/scanner/reagent_scanner/attackby(obj/item/C, mob/living/user)
	if(istype(C, suitable_cell) && !cell && insert_item(C, user))
		src.cell = C


/obj/item/device/scanner/reagent_scanner/adv
	name = "advanced reagent scanner"
	icon_state = "adv_spectrometer"
	details = 1
	origin_tech = list(TECH_MAGNET = 4, TECH_BIO = 2)


/obj/item/device/scanner/slime_scanner
	name = "slime scanner"
	icon_state = "adv_spectrometer"
	item_state = "analyzer"
	throw_speed = 3
	throw_range = 7

	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)
	origin_tech = list(TECH_BIO = 1)

/obj/item/device/scanner/slime_scanner/attack(mob/living/M as mob, mob/living/user as mob)
	if(!cell_use_check(7))
		return
	if(user.incapacitated())
		return
	if (!isslime(M))
		user << "<B>This device can only scan slimes!</B>"
		return
	var/mob/living/carbon/slime/T = M
	user.show_message("Slime scan results:")
	user.show_message(text("[T.colour] [] slime", T.is_adult ? "adult" : "baby"))
	user.show_message(text("Nutrition: [T.nutrition]/[]", T.get_max_nutrition()))
	if (T.nutrition < T.get_starve_nutrition())
		user.show_message("<span class='alert'>Warning: slime is starving!</span>")
	else if (T.nutrition < T.get_hunger_nutrition())
		user.show_message(SPAN_WARNING("Warning: slime is hungry"))
	user.show_message("Electric change strength: [T.powerlevel]")
	user.show_message("Health: [T.health]")
	if (T.slime_mutation[4] == T.colour)
		user.show_message("This slime does not evolve any further")
	else
		if (T.slime_mutation[3] == T.slime_mutation[4])
			if (T.slime_mutation[2] == T.slime_mutation[1])
				user.show_message(text("Possible mutation: []", T.slime_mutation[3]))
				user.show_message("Genetic destability: [T.mutation_chance/2]% chance of mutation on splitting")
			else
				user.show_message(text("Possible mutations: [], [], [] (x2)", T.slime_mutation[1], T.slime_mutation[2], T.slime_mutation[3]))
				user.show_message("Genetic destability: [T.mutation_chance]% chance of mutation on splitting")
		else
			user.show_message(text("Possible mutations: [], [], [], []", T.slime_mutation[1], T.slime_mutation[2], T.slime_mutation[3], T.slime_mutation[4]))
			user.show_message("Genetic destability: [T.mutation_chance]% chance of mutation on splitting")
	if (T.cores > 1)
		user.show_message("Anomalious slime core amount detected")
	user.show_message("Growth progress: [T.amount_grown]/10")


/obj/item/device/scanner/slime_scanner/MouseDrop(over_object)
	if((src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
		cell = null

/obj/item/device/scanner/slime_scanner/attackby(obj/item/C, mob/living/user)
	if(istype(C, suitable_cell) && !cell && insert_item(C, user))
		src.cell = C
