/mob/living
	var/datum/psi_complexus/psi

/mob/living/Login()
	. = ..()
	if(psi)
		psi.update(TRUE)
		if(!psi.suppressed)
			psi.show_auras()

/mob/living/Destroy()
	QDEL_NULL(psi)
	. = ..()

/mob/living/proc/set_psi_rank(faculty, rank, take_larger, defer_update, temporary)
	if(!src.targeted_organ) // What is this for?
		to_chat(src, SPAN_NOTICE("You feel something strange brush against your mind... but your brain is not able to grasp it."))
		return
	if(!psi)
		psi = new(src)
	var/current_rank = psi.get_rank(faculty)
	if(current_rank != rank && (!take_larger || current_rank < rank))
		psi.set_rank(faculty, rank, defer_update, temporary)

/mob/living/proc/set_psi_power(amount = 0, additive = FALSE, defer_update = FALSE)
	if(!src.targeted_organ) // What is this for? x2
		to_chat(src, SPAN_NOTICE("You feel something strange brush against your mind... but your brain is not able to grasp it."))
		return
	if(!psi)
		psi = new(src)
	psi.set_power(amount, additive, defer_update)

/mob/living/proc/deflect_psionic_attack(attacker)

/* TODO: replace with our version of psi protection, taking NT into account
	var/blocked = 100 * get_blocked_ratio(null, PSY)
	if(prob(blocked))
		if(attacker)
			to_chat(attacker, SPAN_WARNING("Your mental attack is deflected by \the [src]'s defenses!"))
			to_chat(src, SPAN_DANGER("\The [attacker] strikes out with a mental attack, but you deflect it!"))
		return TRUE
*/
	return FALSE

// TODO: design objective for breaking X amount of people's minds. Until then this just reports to admins.
/mob/living/proc/reg_break(mob/living/carbon/human/victim)
	log_admin("LOG: [src] ([src.ckey]) broke the mind of [victim] using psionic powers.")
	message_admins("LOG: [src] ([src.ckey]) broke the mind of [victim] using psionic powers.")
/*
	if(victim.get_species() != SPECIES_HUMAN)
		return

	if(!contract)
		return

	if(victim == src)
		return

	// Give a signal that the break was registred and counted towards objective
	to_chat(src, SPAN_DANGER("[src] you feel you've succeeded in your goal."))

	victims |= victim

	if(contract.completed)
		to_chat(owner.current, SPAN_DANGER("Somebody all ready have comleted targeted contract."))
		contract = null
		START_PROCESSING(SSobj, src)

	else if(victims.len >= contract.count)
		contract.report(src)
		contract = null
		START_PROCESSING(SSobj, src)
*/
