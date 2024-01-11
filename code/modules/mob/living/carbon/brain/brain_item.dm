/obj/item/organ/internal/vital/brain
	name = "brain"
	desc = "A piece of juicy meat found in a person's head."
	organ_efficiency = list(BP_BRAIN = 100)
	parent_organ_base = BP_HEAD
	unique_tag = BP_BRAIN
	vital = 1
	icon_state = "brain2"
	force = 1
	w_class = ITEM_SIZE_SMALL
	specific_organ_size = 2
	throwforce = 1
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_BIO = 3)
	attack_verb = list("attacked", "slapped", "whacked")
	price_tag = 900
	blood_req = 8
	max_blood_storage = 80
	oxygen_req = 8
	nutriment_req = 6
	health = 50		// Must be depleted before normal wounds can be applied
	var/mob/living/carbon/brain/brainmob = null
	var/timer_id
	max_damage = IORGAN_VITAL_HEALTH + 2 // We want this to be very tanky
	min_bruised_damage = IORGAN_VITAL_BRUISE
	min_broken_damage = IORGAN_VITAL_BREAK

/obj/item/organ/internal/vital/brain/New()
	..()
	timer_id = addtimer(CALLBACK(src, PROC_REF(clear_hud)), 5, TIMER_STOPPABLE)

/obj/item/organ/internal/vital/brain/Destroy()
	if(timer_id)
		deltimer(timer_id)
	if(brainmob)
		qdel(brainmob)
		brainmob = null
	. = ..()

/obj/item/organ/internal/vital/brain/take_damage(amount, damage_type = BRUTE, wounding_multiplier = 1, sharp = FALSE, edge = FALSE, silent = FALSE)
	if(!damage_type || status & ORGAN_DEAD)
		return

	health -= amount * wounding_multiplier

	if(health < 0)
		var/wound_damage = -health
		health = 0
		..(wound_damage, damage_type, wounding_multiplier, sharp, edge, silent)

/obj/item/organ/internal/vital/brain/get_possible_wounds(damage_type, sharp, edge)
	var/list/possible_wounds = list()

	// Determine possible wounds based on nature and damage type
	var/is_robotic = BP_IS_ROBOTIC(src)
	var/is_organic = BP_IS_ORGANIC(src) || BP_IS_ASSISTED(src)

	switch(damage_type)
		if(BRUTE)
			if(!edge)
				if(sharp) // dont even fucking ask whats the difference between this and eyes get_possible_wounds. I dont know, I wont tell you. 
					if(is_organic)
						LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/organic/brain_sharp))
					if(is_robotic)
						LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/robotic/brain_sharp))
				else
					if(is_organic)
						LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/organic/brain_blunt))
					if(is_robotic)
						LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/robotic/brain_blunt))
			else
				if(is_organic)
					LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/organic/brain_edge))
				if(is_robotic)
					LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/robotic/brain_edge))
		if(BURN)
			if(is_organic)
				LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/organic/brain_burn))
			if(is_robotic)
				LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/robotic/brain_emp_burn))
		if(TOX)
			if(is_organic)
				LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/organic/poisoning))
			//if(is_robotic)
			//	LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/robotic/poisoning))
		if(CLONE)
			if(is_organic)
				LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/organic/radiation))
		if(PSY)
			if(is_organic)
				LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/organic/sanity))
			if(is_robotic)
				LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/robotic/sanity))

	return possible_wounds

/// Brain blood oxygenation is handled via oxyloss
/obj/item/organ/internal/vital/brain/handle_blood()
	if(BP_IS_ROBOTIC(src) || !owner)
		return
	if(!blood_req)
		return

	current_blood = max_blood_storage

/obj/item/organ/internal/vital/brain/proc/clear_hud()
	if(brainmob && brainmob.client)
		brainmob.client.screen.len = null //clear the hud
	timer_id = null

/obj/item/organ/internal/vital/brain/proc/transfer_identity(mob/living/carbon/H)
	name = "\the [H]'s [initial(src.name)]"
	brainmob = new(src)
	brainmob.name = H.real_name
	brainmob.real_name = H.real_name
	brainmob.b_type = H.b_type
	brainmob.dna_trace = H.dna_trace
	brainmob.fingers_trace = H.fingers_trace
	brainmob.timeofhostdeath = H.timeofdeath
	if(H.mind)
		H.mind.transfer_to(brainmob)

	to_chat(brainmob, SPAN_NOTICE("You feel slightly disoriented. That's normal when you're just a [initial(src.name)]."))
	callHook("debrain", list(brainmob))

/obj/item/organ/internal/vital/brain/examine(mob/user) // -- TLE
	..(user)
	if(brainmob && brainmob.client)//if thar be a brain inside... the brain.
		to_chat(user, "You can feel the small spark of life still left in this one.")
	else
		to_chat(user, "This one seems particularly lifeless. Perhaps it will regain some of its luster later..")

/obj/item/organ/internal/vital/brain/removed_mob(mob/living/user)
	name = "[owner.real_name]'s brain"

	if(!(owner.status_flags & REBUILDING_ORGANS))
		var/mob/living/simple_animal/borer/borer = owner.get_brain_worms()
		if(borer)
			borer.detach() //Should remove borer if the brain is removed - RR

		var/obj/item/organ/internal/carrion/core/C = owner.random_organ_by_process(BP_SPCORE)
		if(C)
			C.removed()
			qdel(src)
			return

		transfer_identity(owner)

	..()

/obj/item/organ/internal/vital/brain/replaced_mob(mob/living/carbon/target)
	..()
	if(owner.key && !(owner.status_flags & REBUILDING_ORGANS))
		owner.ghostize()

	if(brainmob)
		if(brainmob.mind)
			brainmob.mind.transfer_to(owner)
		else
			owner.key = brainmob.key

/obj/item/organ/internal/vital/brain/slime
	name = "slime core"
	desc = "A complex, organic knot of jelly and crystalline particles."
	icon = 'icons/mob/slimes.dmi'
	icon_state = "green slime extract"

/obj/item/organ/internal/vital/brain/golem
	name = "chem"
	desc = "A tightly furled roll of paper, covered with indecipherable runes."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "scroll"
