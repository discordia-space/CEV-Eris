/datum/autodoc_patchnote
	var/surgery_operations = 0
	var/obj/item/organ/organ = null

/datum/autodoc
	var/list/patchnotes
	var/list/picked_patchnotes
	var/active = 0
	var/current_step = null
	var/mob/living/carbon/human/patient = null
	var/possible_operations = (	AUTODOC_DAMAGE, AUTODOC_EMBED_OBJECT, AUTODOC_FRACTURE, AUTODOC_OPEN_WOUNDS,
								AUTODOC_TOXIN, AUTODOC_DIALYSIS)
/datum/autodoc/proc/pre_check()
/datum/autodoc/proc/scan_user(var/mob/living/carbon/human/human)
	if(!pre_check())
		CRASH()
	if(!patient)
		to_chat(usr, SPAN_WARNING("There is nobody."))
	if(active)
		to_chat(usr, SPAN_WARNING("Autodoc already in use"))
	active = 1
	patient = human
	patchnotes = new()


	var/datum/autodoc_patchnote/toxnote = new()
	if(patient.getToxLoss())
		toxnote.surgery_operations |= AUTODOC_TOXIN
	if(patient.reagents.reagent_list.len)
		toxnote.surgery_operations |= AUTODOC_DIALYSIS
	if(toxnote.surgery_operations)
		patchnotes.Add(toxnote)

	for(var/obj/item/organ/internal in patient.internal_organs)

		if((AUTODOC_DAMAGE in possible_operations) && internal.damage)
			var/datum/autodoc_patchnote/patchnote = new()
			patchnote.organ = internal
			patchnote.surgery_operations |= AUTODOC_DAMAGE
			patchnotes.Add(patchnote)

	for(var/obj/item/organ/external in patient.bad_external_organs)
		var/datum/autodoc_patchnote/patchnote = new()
		if((AUTODOC_DAMAGE in possible_operations) && (external.brute_dam || external.burn_damn))
			//if(external.robotic)
			//	continue
			patchnote.organ = external
			patchnote.surgery_operations |= AUTODOC_DAMAGE
		if((AUTODOC_FRACTURE in possible_operations) && (external.status & ORGAN_BROKEN))
			patchnote.organ = external
			patchnote.surgery_operations |= AUTODOC_FRACTURE
		if((AUTODOC_EMBED_OBJECT in possible_operations) && (external.implants))
			for(var/obj/item/weapon/material/shard/shrapnel/shrapnel in external.implants)
				if(shrapnel)
					patchnote.organ = external
					patchnote.surgery_operations |= AUTODOC_EMBED_OBJECT

		if((AUTODOC_IB in possible_operations) && (external.wounds.len))
			for(var/datum/wound/wound in external.wounds)
				if(wound.internal)
					patchnote.organ = external
					patchnote.surgery_operations |= AUTODOC_IB
				else if(AUTODOC_OPEN_WOUNDS in possible_operations)
					patchnote.organ = external
					patchnote.surgery_operations |= AUTODOC_OPEN_WOUNDS
		if((AUTODOC_OPEN_WOUNDS in possible_operations) && (external.brute_dam || external.burn_damn))
			patchnote.organ = internal
			patchnote.surgery_operations |= AUTODOC_BRUTE_N_BURN
	active = 0

/datum/autodoc/proc/process(var/datum/autodoc_patchnote/patchnote, var/healing_amount = 50)
	if(!pre_check())
		CRASH()
	if(patchnote.surgery_operations & AUTODOC_TOXIN)
		patient.adjustToxLoss(-healing_amount)
		if(!patient.getToxLoss())patchnotes -= patchnote
		return

	if(patchnote.surgery_operations & AUTODOC_DIALYSIS)
		var/pumped = 0
		for(var/datum/reagent/x in patient.reagents.reagent_list)
			patient.reagents.remove_any(AUTODOC_DIALYSIS_AMOUNT)
			pumped+=AUTODOC_DIALYSIS_AMOUNT
		patient.vessel.remove_any(pumped + 1)
		if(!qoccupant.reagents.len)
			patchnotes -= patchnote
		return

	if(patchnote.surgery_operations & AUTODOC_INNER_DAMAGE)
		patchnote.organ.damage = 0
		patchnotes -= patchnote
		return

	if(patchnote.surgery_operations & AUTODOC_EMBED_OBJECT)
		for(var/obj/item/weapon/material/shard/shrapnel/shrapnel in patchnote.organ.implants)
			patchnote.organ.implants -= implant
			implant.loc = get_turf(patient)
		patchnote.surgery_operations &= ~AUTODOC_EMBED_OBJECT

	if(patchnote.surgery_operations & AUTODOC_OPEN_WOUNDS)
		for(var/datum/wound/wound in patchnote.organ.wounds)
			if(!wound.internal)
				wound.heal_damage(healing_amount)
				wound.bandaged = 1
				wound.clamped = 1
				wound.salved = 1
				wound.disinfected = 1
				wound.germ_level = 0

	if(patchnote.surgery_operations & AUTODOC_BRUTE_N_BURN)
		patchnote.organ.heal_damage(healing_amount,healing_amount)
		patchnotes -= patchnote
		if(!patchnote.organ.brute_dam && !patchnote.organ.burn_dam)
			patchnote.surgery_operations &= ~AUTODOC_BRUTE_N_BURN

	if(patchnote.surgery_operations & AUTODOC_FRACTURE)
		patchnote.organ.mend_fracture()
		patchnote.surgery_operations &= ~AUTODOC_FRACTURE

	if(patchnote.surgery_operations & AUTODOC_IB) //because it needs its own job, yes.
		for(var/datum/wound/wound in patchnote.organ.wounds)
			if(wound.internal)
				patchnote.organ.wounds -= wound
				qdel(wound)
				ex_organ.update_damages()
		patchnote.surgery_operations &= ~AUTODOC_IB

/datum/autodoc/proc/process_first_one(var/process_timer = 30)
	if(!pre_check())
		CRASH()
	if(active)
		return 0
	if(!picked_patchnotes.len)
		to_chat(usr, SPAN_NOTICE("No operations picked"))
	active = 1
	if(patient.do_after(patient, process_timer, src, incapacitation_flags = 0))
		process(picked_patchnotes[1])
	else
		world << "Failure"
		return -1
	return 1

/datum/autodoc/proc/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = NANOUI_FOCUS, var/datum/topic_state/state =GLOB.outside_state)
	var/data[0]

	data["locked"] = active
	data["over_brute"] = holder.wearer.getBruteLoss()
	data["over_burn"] = holder.wearer.getFireLoss()
	data["over_oxy"] = holder.wearer.getOxyLoss()
	data["over_tox"] = holder.wearer.getToxLoss()

	var/list/organs[0]
	var/i = 0
	for(var/datum/autodoc_patchnote/note in notes)
		i++
		var/list/organ[0]
		if(!note.organ)
			data["surgery_antitox"] = note.surgery_operations & AUTODOC_TOXIN
			data["surgery_dialysis"] = note.surgery_operations & AUTODOC_DIALYSIS
			continue
		organ["id"]
		organ["name"] = note.organ.name
		organ["internal"] = note.organ.internal
		if(note.organ.internal)
			organ["inner_damage"] = note.organ.damage
			organ["surgery_damage"] = note.surgery_operations & AUTODOC_DAMAGE
		else
			organ["brute_damage"] = note.organ.brute.dam
			organ["burn_damage"] = note.organ.brute.dam
			organ["surgery_fracture"] = note.surgery_operations & AUTODOC_FRACTURE
			organ["surgery_shrapnel"] = note.surgery_operations & AUTODOC_EMBED_OBJECT
			organ["surgery_damage"] = note.surgery_operations & AUTODOC_DAMAGE
			organ["surgery_wound"] = note.surgery_operations & AUTODOC_OPEN_WOUNDS
		organs.Add(organ)

	data["organs"] = organs

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	ui = new(user, src, ui_key, "autodoc.tmpl", "Autodoc UI", 400, 700, state = state)
	ui.set_initial_data(data)
	ui.open()
	ui.set_auto_update(1)

/datum/autodoc/proc/Topic(href, href_list)
	if(href_list["rescan"])
		inner_machine.scan_user(patient)

	if(href_list["toggle"])

	if(href_list["start"])
		for(patch in picked_patchnotes)
			process_first_one()
	if(href_list["full"])
		picked_patchnotes = patchnotes.Copy()
		for(patch in picked_patchnotes)
			process_first_one()