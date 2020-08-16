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

/datum/perk/Destroy()
	if(holder)
		holder.update_client_colour() //Handle the activation of the colourblindness on the mob.
		to_chat(holder, SPAN_NOTICE("[lose_text]"))
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
	to_chat(holder, SPAN_NOTICE("[gain_text]"))

/// Proc called when the perk is removed from a human. Obviously, in your perks, you should call parent as the last thing you do, since it deletes the perk itself.
/datum/perk/proc/remove()
	SHOULD_CALL_PARENT(TRUE)
	qdel(src)
