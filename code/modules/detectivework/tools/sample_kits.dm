/obj/item/sample
	name = "forensic sample"
	icon = 'icons/obj/forensics.dmi'
	w_class = ITEM_SIZE_TINY
	var/list/evidence = list()

/obj/item/sample/New(var/newloc, var/atom/supplied)
	..(newloc)
	if(supplied)
		copy_evidence(supplied)
		name = "[initial(name)] (\the [supplied])"

/obj/item/sample/print/New(var/newloc, var/atom/supplied)
	..(newloc, supplied)
	if(evidence && evidence.len)
		icon_state = "fingerprint1"

/obj/item/sample/proc/copy_evidence(var/atom/supplied)
	if(supplied.suit_fibers && supplied.suit_fibers.len)
		evidence = supplied.suit_fibers.Copy()
		supplied.suit_fibers.Cut()

/obj/item/sample/proc/merge_evidence(var/obj/item/sample/supplied, var/mob/user)
	if(!supplied.evidence || !supplied.evidence.len)
		return 0
	evidence |= supplied.evidence
	name = "[initial(name)] (combined)"
	to_chat(user, SPAN_NOTICE("You transfer the contents of \the [supplied] into \the [src]."))
	return 1

/obj/item/sample/print/merge_evidence(var/obj/item/sample/supplied, var/mob/user)
	if(!supplied.evidence || !supplied.evidence.len)
		return 0
	for(var/print in supplied.evidence)
		if(evidence[print])
			evidence[print] = stringmerge(evidence[print],supplied.evidence[print])
		else
			evidence[print] = supplied.evidence[print]
	name = "[initial(name)] (combined)"
	to_chat(user, SPAN_NOTICE("You overlay \the [src] and \the [supplied], combining the print records."))
	return 1

/obj/item/sample/attackby(var/obj/O, var/mob/user)
	if(O.type == src.type)
		user.unEquip(O)
		if(merge_evidence(O, user))
			qdel(O)
		return 1
	return ..()

/obj/item/sample/fibers
	name = "fiber bag"
	desc = "Used to hold fiber evidence for the detective."
	icon_state = "fiberbag"

/obj/item/sample/print
	name = "fingerprint card"
	desc = "Records a set of fingerprints."
	icon = 'icons/obj/card.dmi'
	icon_state = "fingerprint0"
	item_state = "paper"

/obj/item/sample/print/attack_self(var/mob/user)
	if(evidence && evidence.len)
		return
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.gloves)
		to_chat(user, SPAN_WARNING("Take \the [H.gloves] off first."))
		return

	to_chat(user, SPAN_NOTICE("You firmly press your fingertips onto the card."))
	var/fullprint = H.get_full_print()
	evidence[fullprint] = fullprint
	name = "[initial(name)] (\the [H])"
	icon_state = "fingerprint1"

/obj/item/sample/print/attack(var/mob/living/M, var/mob/user)

	if(!ishuman(M))
		return ..()

	if(evidence && evidence.len)
		return 0

	var/mob/living/carbon/human/H = M

	if(H.gloves)
		to_chat(user, SPAN_WARNING("\The [H] is wearing gloves."))
		return 1

	if(user != H && H.a_intent != I_HELP && !H.lying)
		user.visible_message(SPAN_DANGER("\The [user] tries to take prints from \the [H], but they move away."))
		return 1

	if(user.targeted_organ == BP_R_ARM || user.targeted_organ == BP_L_ARM)
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
			return 1
		user.visible_message("[user] takes a copy of \the [H]'s fingerprints.")
		var/fullprint = H.get_full_print()
		evidence[fullprint] = fullprint
		copy_evidence(src)
		name = "[initial(name)] (\the [H])"
		icon_state = "fingerprint1"
		return 1
	return 0

/obj/item/sample/print/copy_evidence(var/atom/supplied)
	if(supplied.fingerprints && supplied.fingerprints.len)
		for(var/print in supplied.fingerprints)
			evidence[print] = supplied.fingerprints[print]
		supplied.fingerprints.Cut()

/obj/item/forensics/sample_kit
	name = "fiber collection kit"
	desc = "A magnifying glass and tweezers. Used to lift suit fibers."
	icon_state = "m_glass"
	w_class = ITEM_SIZE_SMALL
	var/evidence_type = "fiber"
	var/evidence_path = /obj/item/sample/fibers

/obj/item/forensics/sample_kit/proc/can_take_sample(var/mob/user, var/atom/supplied)
	return (supplied.suit_fibers && supplied.suit_fibers.len)

/obj/item/forensics/sample_kit/proc/take_sample(var/mob/user, var/atom/supplied)
	var/obj/item/sample/S = new evidence_path(get_turf(user), supplied)
	to_chat(user, "<span class='notice'>You transfer [S.evidence.len] [S.evidence.len > 1 ? "[evidence_type]s" : "[evidence_type]"] to \the [S].</span>")

/obj/item/forensics/sample_kit/afterattack(var/atom/A, var/mob/user, var/proximity)
	if(!proximity)
		return
	add_fingerprint(user)
	if(can_take_sample(user, A))
		take_sample(user,A)
		return 1
	else
		to_chat(user, SPAN_WARNING("You are unable to locate any [evidence_type]s on \the [A]."))
		return ..()

/obj/item/forensics/sample_kit/powder
	name = "fingerprint powder"
	desc = "A jar containing aluminum powder and a specialized brush."
	icon_state = "dust"
	evidence_type = "fingerprint"
	evidence_path = /obj/item/sample/print

/obj/item/forensics/sample_kit/powder/can_take_sample(var/mob/user, var/atom/supplied)
	return (supplied.fingerprints && supplied.fingerprints.len)
