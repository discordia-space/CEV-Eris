/datum/autodoc_patchnote
	var/surgery_operations = 0
	var/obj/item/organ/organ = null
/datum/autodoc_patchnote/proc/Copy(var/blank = TRUE)
	var/datum/autodoc_patchnote/copy = new()
	copy.organ = organ
	if(!blank)
		copy.surgery_operations = surgery_operations
	return copy
/datum/autodoc
	var/list/scanned_patchnotes = list()
	var/list/picked_patchnotes = list()
	var/obj/holder
	var/active = 0
	var/damage_heal_amount = 30
	var/processing_speed = 30
	var/current_step = null
	var/mob/living/carbon/human/patient = null
	var/list/possible_operations = list(AUTODOC_DAMAGE, AUTODOC_EMBED_OBJECT, AUTODOC_FRACTURE, AUTODOC_OPEN_WOUNDS, AUTODOC_TOXIN, AUTODOC_DIALYSIS)

/datum/autodoc/proc/scan_user(var/mob/living/carbon/human/human)
	if(active)
		to_chat(usr, SPAN_WARNING("Autodoc already in use"))
		return
	active = 1
	patient = human
	scanned_patchnotes = new()
	picked_patchnotes = new()

	var/datum/autodoc_patchnote/toxnote = new()
	if(patient.getToxLoss())
		toxnote.surgery_operations |= AUTODOC_TOXIN
	if(patient.reagents.reagent_list.len)
		toxnote.surgery_operations |= AUTODOC_DIALYSIS
	if(toxnote.surgery_operations)
		scanned_patchnotes.Add(toxnote)
		picked_patchnotes.Add(toxnote.Copy())

	if(AUTODOC_DAMAGE in possible_operations)
		world << "AUTODOC_DAMAGE"
		for(var/obj/item/organ/internal/internal in patient.internal_organs)
			if(internal.damage)
				world << "AUTODOC_DAMAGE - got internal organ"
				var/datum/autodoc_patchnote/patchnote = new()
				patchnote.organ = internal
				patchnote.surgery_operations |= AUTODOC_DAMAGE
				scanned_patchnotes.Add(patchnote)
				picked_patchnotes.Add(patchnote.Copy())

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
		if(patchnote.surgery_operations)
			scanned_patchnotes.Add(patchnote)
			picked_patchnotes.Add(patchnote.Copy())
	active = 0

/datum/autodoc/proc/process(var/datum/autodoc_patchnote/patchnote)
	var/obj/item/organ/internal/internal = patchnote.organ
	var/obj/item/organ/external/external = patchnote.organ
	if(!patchnote.organ)
		if(patchnote.surgery_operations & AUTODOC_TOXIN)
			patient.adjustToxLoss(-damage_heal_amount)
			if(!patient.getToxLoss())
				patchnote.surgery_operations &= ~AUTODOC_TOXIN

		if(patchnote.surgery_operations & AUTODOC_DIALYSIS)
			var/pumped = 0
			for(var/datum/reagent/x in patient.reagents.reagent_list)
				patient.reagents.remove_any(AUTODOC_DIALYSIS_AMOUNT)
				pumped+=AUTODOC_DIALYSIS_AMOUNT
			patient.vessel.remove_any(pumped + 1)
			if(!pumped)
				patchnote.surgery_operations &= ~AUTODOC_DIALYSIS

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

/datum/autodoc/proc/process_full_queue()
	if(active)
		return FALSE
	picked_patchnotes = scanned_patchnotes.Copy()
	active = TRUE
	for(var/datum/autodoc_patchnote/note in picked_patchnotes)
		if( do_after(patient, processing_speed, holder, incapacitation_flags = 0) )
			process(picked_patchnotes[1])
		else
			world << "Failure"
			active = FALSE
			return
	active = FALSE

/datum/autodoc/ui_interact(mob/user, ui_key = "autodoc", var/datum/nanoui/ui = null)
	var/list/data = new()

	data["locked"] = active
	data["over_brute"] = patient.getBruteLoss()
	data["over_burn"] = patient.getFireLoss()
	data["over_oxy"] = patient.getOxyLoss()
	data["over_tox"] = patient.getToxLoss()

	var/list/organs = new()
	var/i = 0
	for(var/datum/autodoc_patchnote/note in scanned_patchnotes)
		i++
		var/list/organ = new()
		var/obj/item/organ/internal/internal = note.organ
		var/obj/item/organ/external/external = note.organ
		organ["id"] = i
		if(!note.organ)
			data["antitox"] = note.surgery_operations & AUTODOC_TOXIN
			data["antitox_picked"] = picked_patchnotes[i].surgery_operations & AUTODOC_TOXIN
			data["dialysis"] = note.surgery_operations & AUTODOC_DIALYSIS
			data["dialysis_picked"] = picked_patchnotes[i].surgery_operations & AUTODOC_DIALYSIS
			continue		
		if(internal)
			organ["name"] = internal.name
			organ["internal"] = TRUE
			organ["inner_damage"] = internal.damage
			organ["damage"] = note.surgery_operations & AUTODOC_DAMAGE
			organ["damage_picked"] = picked_patchnotes[i].surgery_operations & AUTODOC_DAMAGE
		else
			organ["name"] = external.name
			organ["brute_damage"] = external.brute_dam
			organ["burn_damage"] = external.burn_dam
			organ["fracture"] = note.surgery_operations & AUTODOC_FRACTURE
			organ["fracture_picked"] = picked_patchnotes[i].surgery_operations & AUTODOC_FRACTURE
			organ["shrapnel"] = note.surgery_operations & AUTODOC_EMBED_OBJECT
			organ["shrapnel_picked"] = picked_patchnotes[i].surgery_operations & AUTODOC_EMBED_OBJECT
			organ["damage"] = note.surgery_operations & AUTODOC_DAMAGE
			organ["damage_picked"] = picked_patchnotes[i].surgery_operations & AUTODOC_DAMAGE
			organ["wound"] = note.surgery_operations & AUTODOC_OPEN_WOUNDS
			organ["wound_picked"] = picked_patchnotes[i].surgery_operations & AUTODOC_OPEN_WOUNDS
		organs.Add(organ)

	data["organs"] = organs

	world << data
	ui = SSnano.try_update_ui(user, holder, ui_key, ui, data)
	if (!ui)
		ui = new(user, holder, ui_key, "autodoc.tmpl", "Autodoc", 600, 480, state = GLOB.default_state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/autodoc/Topic(href, href_list)
	world << href_list
	if(href_list["rescan"])
		scan_user(patient)
	if(href_list["start"])
		process_full_queue()
	if(href_list["full"])
		scan_user(patient)
		picked_patchnotes = scanned_patchnotes.Copy()
		process_full_queue()
	if(href_list["toggle"])
		var/op = 0
		switch(href_list["toggle"])
			if("damage")
				op = AUTODOC_DAMAGE
			if("wound")
				op = AUTODOC_OPEN_WOUNDS
			if("fracture")
				op = AUTODOC_FRACTURE
			if("shrapnel")
				op = AUTODOC_EMBED_OBJECT
			if("dialysis")
				op = AUTODOC_DIALYSIS
			if("antitox")
				op = AUTODOC_TOXIN
		if(picked_patchnotes[href_list["id"]].possible_operations & op)
			picked_patchnotes[href_list["id"]].possible_operations &= ~op
		else
			picked_patchnotes[href_list["id"]].possible_operations |= op
	
