/**
  * The root perk datum. All perks inherit properties from this one.
  *
  * A perk is basically a talent that livings may have. This talent could be something like damage reduction, or some other passive benefit.
  * Some jobs have perks that are assigned to the human during role assignment.
  * Perks can be assigned or removed. To handle this, use the mob stats datum, with the helper procs addPerk, removePerk and getPerk.
  * The static effects are given in assign, and removed in remove.
  * Perks are stored in a list within a stat_holder datum.
  */
/datum/perk
	var/name = "Perk"
	var/desc = ""
	var/icon = 'icons/effects/perks.dmi'
	var/icon_state = ""
	var/mob/living/carbon/human/holder
	var/gain_text
	var/lose_text
	var/perk_shared_ability

	// perk conflict handling
	var/list/conflicting_perks_types = list()

/datum/perk/Destroy()
	if(holder)
		holder.update_client_colour() //Handle the activation of the colourblindness on the mob.
		to_chat(holder, SPAN_NOTICE("[lose_text]"))
	holder = null
	return ..()

/// Proc called in human life. Should be the first thing to be called.
/datum/perk/proc/on_process()
	//SIGNAL_HANDLER
	SHOULD_CALL_PARENT(TRUE)
	if(!holder)
		return FALSE
	if(holder.stat == DEAD)
		return FALSE
	return TRUE

/// Proc called when the perk is assigned to a human. Should be the first thing to be called.
/datum/perk/proc/assign(mob/living/carbon/human/H)
	if(istype(H))
		SHOULD_CALL_PARENT(TRUE)
		holder = H
		RegisterSignal(holder, COMSIG_MOB_LIFE, PROC_REF(on_process))
		to_chat(holder, SPAN_NOTICE("[gain_text]"))
		handle_conflicts(check_conflicts())
		return TRUE

// Proc called to check if there are any conflicts with other perks
/datum/perk/proc/check_conflicts()
	if(!istype(holder))
		return
	var/list/conflicting_perks = list()
	for(var/datum/perk/other_perk in holder.stats.perks)
		if(other_perk.type in conflicting_perks_types)
			conflicting_perks += other_perk
	if(length(conflicting_perks) > 0)
		return conflicting_perks
	return null

// Proc called to handle conflicts with other perks via deletion of the conflicting perks
/datum/perk/proc/handle_conflicts(list/conflicting_perks)
	if(!istype(holder) || !length(conflicting_perks))
		return
	for(var/datum/perk/conflicting_perk in conflicting_perks)
		holder.stats.removePerk(conflicting_perk.type)

/// Proc called when the perk is removed from a human. Obviously, in your perks, you should call parent as the last thing you do, since it deletes the perk itself.
/datum/perk/proc/remove()
	UnregisterSignal(holder, COMSIG_MOB_LIFE, PROC_REF(on_process))
	SHOULD_CALL_PARENT(TRUE)
	qdel(src)

/// Proc called , a bitflag is always expected.
/datum/perk/proc/check_shared_ability(ability_bitflag)
	if(!(perk_shared_ability & ability_bitflag))
		return FALSE
	return TRUE

/* Uncomment this when  more shared abilities are
/datum/perk/proc/check_shared_abilities(list/ability_bitflags)
	var/accumulated_bitflags = 0
	for(var/bitflag in ability_bitflags)
		if(!check_shared_ability(bitflag))
			continue
		accumulated_bitflags++
	return ability_bitflags.len == accumulated_bitflags ? TRUE : FALSE
*/
