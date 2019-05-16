/datum/autodoc_patchnote
	var/surgery_operations = 0
	var/obj/item/organ/organ = null

/datum/autodoc
	var/list/patchnotes = list()
	var/list/picked_patchnotes = list()
	var/active = 0
	var/damage_heal_amount = 30
	var/current_step = null
	var/mob/living/carbon/human/patient = null
	var/list/possible_operations = list(AUTODOC_DAMAGE, AUTODOC_EMBED_OBJECT, AUTODOC_FRACTURE, AUTODOC_OPEN_WOUNDS, AUTODOC_TOXIN, AUTODOC_DIALYSIS)
/datum/autodoc/proc/scan_user(var/mob/living/carbon/human/human)
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

	if(AUTODOC_DAMAGE in possible_operations)
		world << "AUTODOC_DAMAGE"
		for(var/obj/item/organ/internal/internal in patient.internal_organs)
			if(internal.damage)
				world << "AUTODOC_DAMAGE - got internal organ"
				var/datum/autodoc_patchnote/patchnote = new()
				patchnote.organ = internal
				patchnote.surgery_operations |= AUTODOC_DAMAGE
				patchnotes.Add(patchnote)

	for(var/obj/item/organ/external/external in patient.bad_external_organs)
		world << "BAD EXTERNAL"
		var/datum/autodoc_patchnote/patchnote = new()
		patchnote.organ = external
		if(AUTODOC_DAMAGE in possible_operations)
			world << "DAMAGE OP READY"
			if(external.brute_dam || external.burn_dam)
				world << "DAMAGE FOUND"
				if(external.robotic)
					world << "ROBOTIC FOUND"
					continue
				patchnote.surgery_operations |= AUTODOC_DAMAGE
				world << "DAMAGE ADDED"
		
		if(AUTODOC_FRACTURE in possible_operations)
			world << "FRACTURE OP READY"
			if(external.status & ORGAN_BROKEN)
				world << "FOUND BROKEN"
				patchnote.surgery_operations |= AUTODOC_FRACTURE
		if(AUTODOC_EMBED_OBJECT in possible_operations)
			world << "SHRAPNEL OP READY"
			if(external.implants)
				world << "FOUND EMBED"
				if(/obj/item/weapon/material/shard/shrapnel in external.implants)
					world << "FOUND SHRAPNEL"
					patchnote.surgery_operations |= AUTODOC_EMBED_OBJECT

		if(external.wounds.len)
			world << "FOUND WOUND"
			for(var/datum/wound/wound in external.wounds)
				if(wound.internal)
					if(AUTODOC_IB in possible_operations)
						world << "IB OP READY"
						patchnote.surgery_operations |= AUTODOC_IB
				else 
					if(AUTODOC_OPEN_WOUNDS in possible_operations)
						world << "WOUND OP READY"
						patchnote.surgery_operations |= AUTODOC_OPEN_WOUNDS
		patchnotes.Add(patchnote)
	active = 0

/datum/autodoc/proc/process(var/datum/autodoc_patchnote/patchnote)
	var/obj/item/organ/internal/internal = patchnote.organ
	var/obj/item/organ/external/external = patchnote.organ
	if(patchnote.surgery_operations & AUTODOC_TOXIN)
		patient.adjustToxLoss(-damage_heal_amount)
		if(!patient.getToxLoss())patchnotes -= patchnote
		return

	if(patchnote.surgery_operations & AUTODOC_DIALYSIS)
		var/pumped = 0
		for(var/datum/reagent/x in patient.reagents.reagent_list)
			patient.reagents.remove_any(AUTODOC_DIALYSIS_AMOUNT)
			pumped+=AUTODOC_DIALYSIS_AMOUNT
		patient.vessel.remove_any(pumped + 1)
		if(!pumped)
			patchnotes -= patchnote
		return

	if(patchnote.surgery_operations & AUTODOC_DAMAGE)
		if(internal)
			internal.damage -= damage_heal_amount
			if(internal.damage < 0) internal.damage = 0
			if(!internal.damage) patchnote.surgery_operations &= ~AUTODOC_DAMAGE
		if(external)
			external.heal_damage(damage_heal_amount, damage_heal_amount)
			if(!external.brute_dam && !external.burn_dam) patchnote.surgery_operations &= ~AUTODOC_DAMAGE

	if(patchnote.surgery_operations & AUTODOC_EMBED_OBJECT)
		for(var/obj/item/weapon/material/shard/shrapnel/shrapnel in external.implants)
			external.implants -= shrapnel
			shrapnel.loc = get_turf(patient)
		patchnote.surgery_operations &= ~AUTODOC_EMBED_OBJECT

	if(patchnote.surgery_operations & AUTODOC_OPEN_WOUNDS)
		for(var/datum/wound/wound in external.wounds)
			if(!wound.internal)
				wound.heal_damage(damage_heal_amount)
				wound.bandaged = 1
				wound.clamped = 1
				wound.salved = 1
				wound.disinfected = 1
				wound.germ_level = 0

	if(patchnote.surgery_operations & AUTODOC_FRACTURE)
		external.mend_fracture()
		patchnote.surgery_operations &= ~AUTODOC_FRACTURE

	if(patchnote.surgery_operations & AUTODOC_IB) //because it needs its own job, yes.
		for(var/datum/wound/wound in external.wounds)
			if(wound.internal)
				external.wounds -= wound
				qdel(wound)
				external.update_damages()
		patchnote.surgery_operations &= ~AUTODOC_IB

	if(!patchnote.surgery_operations)
		picked_patchnotes -= patchnote

/datum/autodoc/proc/process_first_one(var/process_timer = 30)
	if(active)
		return 0
	if(!picked_patchnotes.len)
		to_chat(usr, SPAN_NOTICE("No operations picked"))
	active = 1
	if( do_after(patient, process_timer, src, FALSE, 0) )
		process(picked_patchnotes[1])
	else
		world << "Failure"
		return -1
	return 1

/datum/autodoc/proc/process_full_queue(var/process_timer = 30)
	if(active)
		return 0
	picked_patchnotes = patchnotes.Copy()
	active = 1
	for(var/datum/autodoc_patchnote/note in picked_patchnotes)
		process_first_one(process_timer)
	return 1
/datum/autodoc/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null)
	var/list/data = new()

	data["locked"] = active
	data["over_brute"] = patient.getBruteLoss()
	data["over_burn"] = patient.getFireLoss()
	data["over_oxy"] = patient.getOxyLoss()
	data["over_tox"] = patient.getToxLoss()

	var/list/organs[0]
	var/i = 0
	for(var/datum/autodoc_patchnote/note in patchnotes)
		i++
		var/organ[0]
		var/obj/item/organ/internal/internal = note.organ
		var/obj/item/organ/external/external = note.organ
		organ["id"] = i
		if(!note.organ)
			data["surgery_antitox"] = note.surgery_operations & AUTODOC_TOXIN
			data["surgery_dialysis"] = note.surgery_operations & AUTODOC_DIALYSIS
			continue		
		if(internal)
			organ["name"] = internal.name
			organ["internal"] = TRUE
			organ["inner_damage"] = internal.damage
			organ["surgery_damage"] = note.surgery_operations & AUTODOC_DAMAGE
		else
			organ["name"] = external.name
			organ["brute_damage"] = external.brute_dam
			organ["burn_damage"] = external.burn_dam
			organ["surgery_fracture"] = note.surgery_operations & AUTODOC_FRACTURE
			organ["surgery_shrapnel"] = note.surgery_operations & AUTODOC_EMBED_OBJECT
			organ["surgery_damage"] = note.surgery_operations & AUTODOC_DAMAGE
			organ["surgery_wound"] = note.surgery_operations & AUTODOC_OPEN_WOUNDS
		organs.Add(organ)

	data["organs"] = organs

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, 2)
	if (!ui)
		ui = new(user, src, ui_key, "autodoc.tmpl", "Autodoc", 470, 290)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/autodoc/Topic(href, href_list)
	if(href_list["rescan"])
		scan_user(patient)

	if(href_list["toggle"])
		world << href_list
		world << "////////"
	if(href_list["start"])
		process_first_one()
	if(href_list["full"])
		process_full_queue()