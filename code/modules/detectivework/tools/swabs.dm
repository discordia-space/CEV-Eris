/obj/item/forensics/swab
	name = "swab kit"
	desc = "A sterilized cotton swab and vial used to take forensic samples."
	icon_state = "swab"
	price_tag = 5
	var/gsr = 0
	var/list/dna
	var/used

/obj/item/forensics/swab/proc/is_used()
	return used

/obj/item/forensics/swab/attack(var/mob/living/M, var/mob/user)

	if(!ishuman(M))
		return ..()

	if(is_used())
		return FALSE

	var/mob/living/carbon/human/H = M
	var/sample_type

	if(H.wear_mask)
		to_chat(user, SPAN_WARNING("\The [H] is wearing a mask."))
		return FALSE

	if(!H.dna_trace)
		to_chat(user, SPAN_WARNING("They don't seem to have DNA!"))
		return FALSE

	if(user != H && H.a_intent != I_HELP && !H.lying)
		user.visible_message(SPAN_DANGER("\The [user] tries to take a swab sample from \the [H], but they move away."))
		return FALSE

	if(user.targeted_organ == BP_MOUTH)
		if(!H.organs_by_name[BP_HEAD])
			to_chat(user, SPAN_WARNING("They don't have a head."))
			return FALSE
		if(!H.check_has_mouth())
			to_chat(user, SPAN_WARNING("They don't have a mouth."))
			return FALSE
		user.visible_message("[user] swabs \the [H]'s mouth for a saliva sample.")
		dna = list(H.dna_trace)
		sample_type = "DNA"

	else if(user.targeted_organ == BP_R_ARM || user.targeted_organ == BP_L_ARM)
		var/has_hand
		var/obj/item/organ/external/O = H.organs_by_name[BP_R_ARM]
		if(istype(O) && !O.is_stump())
			has_hand = 1
		else
			O = H.organs_by_name[BP_L_ARM]
			if(istype(O) && !O.is_stump())
				has_hand = 1
		if(!has_hand)
			to_chat(user, SPAN_WARNING("They don't have any hands."))
			return FALSE
		user.visible_message("[user] swabs [H]'s palm for a sample.")
		sample_type = "GSR"
		gsr = H.gunshot_residue
	else
		return FALSE

	if(sample_type)
		set_used(sample_type, H)
		return TRUE
	return FALSE

/obj/item/forensics/swab/afterattack(var/atom/A, var/mob/user, var/proximity)

	if(!proximity || istype(A, /obj/machinery/dnaforensics))
		return

	if(is_used())
		to_chat(user, SPAN_WARNING("This swab has already been used."))
		return

	add_fingerprint(user)

	var/list/choices = list()
	if(A.blood_DNA)
		choices |= "Blood"
	if(istype(A, /obj/item/clothing))
		choices |= "Gunshot Residue"
	if(istype(A, /obj/item/reagent_containers))
		choices |= "Check reagents for DNA"


	var/choice
	if(!choices.len)
		to_chat(user, SPAN_WARNING("There is no evidence on \the [A]."))
		return
	else if(choices.len == 1)
		choice = choices[1]
	else
		choice = input("What kind of evidence are you looking for?","Evidence Collection") as null|anything in choices

	if(!choice)
		return

	var/sample_type
	switch(choice)
		if("Blood")
			if(!A.blood_DNA || !A.blood_DNA.len)
				return FALSE
			dna = A.blood_DNA.Copy()
			sample_type = "blood"

		if("Gunshot Residue")
			var/obj/item/clothing/B = A
			if(!istype(B) || !B.gunshot_residue)
				to_chat(user, SPAN_WARNING("There is no residue on \the [A]."))
				return FALSE
			gsr = B.gunshot_residue
			sample_type = "residue"

		if("Check reagents for DNA")
			var/obj/item/reagent_containers/container = A
			var/blood = container.reagents.get_master_reagent_id()
			if(blood != "blood")
				to_chat(user, SPAN_NOTICE("There is no blood in \the [src] or its not pure enough to be swabbed!"))
				return FALSE
			var/list/blood_data = container.reagents.get_data("blood")
			if(blood_data["blood_DNA"])
				dna = list(blood_data["blood_DNA"]) // NEEDS TO BE A LIST FOR REASONS BEYOND MY KNOWLEDGE
				sample_type = "blood"
			else
				to_chat(user, SPAN_NOTICE("This blood has no DNA!"))

	if(sample_type)
		user.visible_message("\The [user] swabs \the [A] for a sample.", "You swab \the [A] for a sample.")
		set_used(sample_type, A)

/obj/item/forensics/swab/proc/set_used(var/sample_str, var/atom/source)
	name = "[initial(name)] ([sample_str] - [source])"
	desc = "[initial(desc)] The label on the vial reads 'Sample of [sample_str] from [source].'."
	icon_state = "swab_used"
	used = TRUE
