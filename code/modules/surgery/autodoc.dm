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
	var/processing_speed = 30 SECONDS
	var/current_step = null
	var/start_op_time
	var/mob/living/carbon/human/patient = null
	var/list/possible_operations = list(AUTODOC_DAMAGE, AUTODOC_EMBED_OBJECT, AUTODOC_FRACTURE, AUTODOC_OPEN_WOUNDS, AUTODOC_TOXIN, AUTODOC_DIALYSIS)

/datum/autodoc/proc/scan_user(var/mob/living/carbon/human/human)
	if(active)
		to_chat(usr, SPAN_WARNING("Autodoc already in use"))
		return
	start_op_time = world.time
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
		for(var/obj/item/organ/internal/internal in patient.internal_organs)
			if(internal.damage)
				var/datum/autodoc_patchnote/patchnote = new()
				patchnote.organ = internal
				patchnote.surgery_operations |= AUTODOC_DAMAGE
				scanned_patchnotes.Add(patchnote)
				picked_patchnotes.Add(patchnote.Copy())

	for(var/obj/item/organ/external/external in patient.bad_external_organs)
		var/datum/autodoc_patchnote/patchnote = new()
		patchnote.organ = external
		if(AUTODOC_DAMAGE in possible_operations)
			if(external.brute_dam || external.burn_dam)
				if(external.robotic)
					continue
				patchnote.surgery_operations |= AUTODOC_DAMAGE
		
		if(AUTODOC_FRACTURE in possible_operations)
			if(external.status & ORGAN_BROKEN)
				patchnote.surgery_operations |= AUTODOC_FRACTURE
		if(AUTODOC_EMBED_OBJECT in possible_operations)
			if(external.implants)
				if(/obj/item/weapon/material/shard/shrapnel in external.implants)
					patchnote.surgery_operations |= AUTODOC_EMBED_OBJECT

		if(external.wounds.len)
			for(var/datum/wound/wound in external.wounds)
				if(wound.internal)
					if(AUTODOC_IB in possible_operations)
						patchnote.surgery_operations |= AUTODOC_IB
				else 
					if(AUTODOC_OPEN_WOUNDS in possible_operations)
						patchnote.surgery_operations |= AUTODOC_OPEN_WOUNDS
		if(patchnote.surgery_operations)
			scanned_patchnotes.Add(patchnote)
			picked_patchnotes.Add(patchnote.Copy())
	active = 0

/datum/autodoc/proc/process_note(var/datum/autodoc_patchnote/patchnote)
	var/obj/item/organ/external/external = patchnote.organ
	if(!patchnote.organ)
		if(patchnote.surgery_operations & AUTODOC_TOXIN)
			patient.adjustToxLoss(-damage_heal_amount)
			if(!patient.getToxLoss())
				patchnote.surgery_operations &= ~AUTODOC_TOXIN

		else if(patchnote.surgery_operations & AUTODOC_DIALYSIS)
			var/pumped = 0
			for(var/datum/reagent/x in patient.reagents.reagent_list)
				patient.reagents.remove_any(AUTODOC_DIALYSIS_AMOUNT)
				pumped+=AUTODOC_DIALYSIS_AMOUNT
			patient.vessel.remove_any(pumped + 1)
			if(!pumped)
				patchnote.surgery_operations &= ~AUTODOC_DIALYSIS

	else if(patchnote.surgery_operations & AUTODOC_DAMAGE)
		world<<"damage"
		if(istype(patchnote.organ, /obj/item/organ/internal))
			world<<"internal"
			var/obj/item/organ/internal/internal = patchnote.organ
			internal.damage -= damage_heal_amount
			if(internal.damage < 0) internal.damage = 0
			if(!internal.damage) patchnote.surgery_operations &= ~AUTODOC_DAMAGE
			return !internal.damage
		
		external.heal_damage(damage_heal_amount, damage_heal_amount)
		if(!external.brute_dam && !external.burn_dam) patchnote.surgery_operations &= ~AUTODOC_DAMAGE

	else if(patchnote.surgery_operations & AUTODOC_EMBED_OBJECT)
		for(var/obj/item/weapon/material/shard/shrapnel/shrapnel in external.implants)
			external.implants -= shrapnel
			shrapnel.loc = get_turf(patient)
		patchnote.surgery_operations &= ~AUTODOC_EMBED_OBJECT

	else if(patchnote.surgery_operations & AUTODOC_OPEN_WOUNDS)
		for(var/datum/wound/wound in external.wounds)
			if(!wound.internal)
				wound.bandaged = 1
				wound.clamped = 1
				wound.salved = 1
				wound.disinfected = 1
				wound.germ_level = 0
		patchnote.surgery_operations &= ~AUTODOC_OPEN_WOUNDS

	else if(patchnote.surgery_operations & AUTODOC_FRACTURE)
		external.mend_fracture()
		patchnote.surgery_operations &= ~AUTODOC_FRACTURE

	else if(patchnote.surgery_operations & AUTODOC_IB)
		for(var/datum/wound/wound in external.wounds)
			if(wound.internal)
				external.wounds -= wound
				qdel(wound)
				external.update_damages()
		patchnote.surgery_operations &= ~AUTODOC_IB
	return patchnote.surgery_operations == 0

/datum/autodoc/Process()
	if(!active)
		return FALSE
	if( current_step > picked_patchnotes.len )
		active = FALSE
		scan_user(patient)
		//TODO: report task is done
		return
	if( start_op_time + processing_speed < world.time )
		if(process_note(picked_patchnotes[current_step]))
			current_step++
		start_op_time = world.time
		patient.updatehealth()

/datum/autodoc/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 2, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = list()

	data["active"] = active
	data["progress"] = (world.time - start_op_time) / processing_speed
	data["over_brute"] = patient.getBruteLoss()
	data["over_burn"] = patient.getFireLoss()
	data["over_oxy"] = patient.getOxyLoss()
	data["over_tox"] = patient.getToxLoss()

	var/list/organs = list()
	
	var/i = 0
	for(var/datum/autodoc_patchnote/note in scanned_patchnotes)
		i++
		var/list/organ = list()
		organ["id"] = i
		if(!note.organ)
			data["antitox"] = note.surgery_operations & AUTODOC_TOXIN
			data["antitox_picked"] = picked_patchnotes[i].surgery_operations & AUTODOC_TOXIN

			data["dialysis"] = note.surgery_operations & AUTODOC_DIALYSIS
			data["dialysis_picked"] = picked_patchnotes[i].surgery_operations & AUTODOC_DIALYSIS
			continue
		
		if(istype(note.organ, /obj/item/organ/internal))
			var/obj/item/organ/internal/internal = note.organ
			organ["name"] = internal.name
			organ["internal"] = TRUE
			organ["inner_damage"] = internal.damage

			organ["damage"] = note.surgery_operations & AUTODOC_DAMAGE
			organ["damage_picked"] = picked_patchnotes[i].surgery_operations & AUTODOC_DAMAGE
		else
			var/obj/item/organ/external/external = note.organ
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

			organ["ib"] = note.surgery_operations & AUTODOC_IB
			organ["ib_picked"] = picked_patchnotes[i].surgery_operations & AUTODOC_IB
		organs+= list(organ)
	data["organs"] = organs

	ui = SSnano.try_update_ui(user, holder, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, holder, ui_key, "autodoc.tmpl", "Autodoc", 600, 480, state=state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/autodoc/proc/stop()
	active = 0
	picked_patchnotes = list()

/datum/autodoc/Topic(href, href_list)
	if(href_list["scan"])
		scan_user(patient)
	if(href_list["picked"])
		current_step = 1
		active = TRUE
	if(href_list["full"])
		scan_user(patient)
		current_step = 1
		active = TRUE
		picked_patchnotes = scanned_patchnotes.Copy()
	if(href_list["stop"])
		stop()
	if(href_list["toggle"])
		if(active)
			return
		var/op = 0
		var/id = text2num(href_list["id"])
		switch(href_list["toggle"])
			if("damage")
				op = AUTODOC_DAMAGE
			if("wound")
				op = AUTODOC_OPEN_WOUNDS
			if("ib")
				op = AUTODOC_IB
			if("fracture")
				op = AUTODOC_FRACTURE
			if("shrapnel")
				op = AUTODOC_EMBED_OBJECT
			if("dialysis")
				op = AUTODOC_DIALYSIS
			if("antitox")
				op = AUTODOC_TOXIN
		if(picked_patchnotes[id].surgery_operations & op)
			picked_patchnotes[id].surgery_operations &= ~op
		else
			picked_patchnotes[id].surgery_operations |= op
	return TRUE
	
