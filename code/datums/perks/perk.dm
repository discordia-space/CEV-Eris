/**
  * The root perk datum. All perks inherit properties from this one.
  *
  * A perk is basically a talent that livings69ay have. This talent could be something like damage reduction, or some other passive benefit.
  * Some jobs have perks that are assigned to the human during role assignment.
  * Perks can be assigned or removed. To handle this, use the69ob stats datum, with the helper procs addPerk, removePerk and getPerk.
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

/datum/perk/Destroy()
	if(holder)
		holder.update_client_colour() //Handle the activation of the colourblindness on the69ob.
		to_chat(holder, SPAN_NOTICE("69lose_text69"))
	holder = null
	return ..()

/// Proc called in human life. Should be the first thing to be called.
/datum/perk/proc/on_process()
	SHOULD_CALL_PARENT(TRUE)
	if(!holder)
		return FALSE
	if(holder.stat == DEAD)
		return FALSE
	return TRUE

/// Proc called when the perk is assigned to a human. Should be the first thing to be called.
/datum/perk/proc/assign(mob/living/carbon/human/H)
	SHOULD_CALL_PARENT(TRUE)
	holder = H
	RegisterSignal(holder, COMSIG_MOB_LIFE, .proc/on_process)
	to_chat(holder, SPAN_NOTICE("69gain_text69"))

/// Proc called when the perk is removed from a human. Obviously, in your perks, you should call parent as the last thing you do, since it deletes the perk itself.
/datum/perk/proc/remove()
	SHOULD_CALL_PARENT(TRUE)
	qdel(src)

/// Proc called , a bitflag is always expected.
/datum/perk/proc/check_shared_ability(ability_bitflag)
	if(!(perk_shared_ability & ability_bitflag))
		return FALSE
	return TRUE

/* Uncomment this when 69ore shared abilities are
/datum/perk/proc/check_shared_abilities(list/ability_bitflags)
	var/accumulated_bitflags = 0
	for(var/bitflag in ability_bitflags)
		if(!check_shared_ability(bitflag))
			continue
		accumulated_bitflags++
	return ability_bitflags.len == accumulated_bitflags ? TRUE : FALSE
*/
