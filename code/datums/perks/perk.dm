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
	var/human_only = TRUE
	var/mob/living/carbon/human/holder
	var/gain_text
	var/lose_text

/datum/perk/New(mob/living/perk_holder)
	..()
	if(!perk_holder || qualify(perk_holder))
		qdel(src)
		return
	src.holder = perk_holder
	to_chat(holder, gain_text)
	on_add()

/datum/perk/proc/qualify(mob/living/try_holder)
	if(try_holder.stats.getPerk(type))
		return FALSE
	if(human_only && !ishuman(try_holder))
		return FALSE
	return TRUE

/datum/perk/Destroy()
	if(holder)
		to_chat(holder, lose_text)
	on_remove()
	holder = null
	return ..()

/// Proc called when the perk is removed from a human. Obviously, in your perks, you should call parent as the last thing you do, since it deletes the perk itself.
/datum/perk/proc/remove()
	SHOULD_CALL_PARENT(TRUE)
	qdel(src)

/datum/perk/Process()
	if(QDELETED(holder))
		remove()
		return
	if(holder.stat == DEAD)
		return
	on_process()

/datum/perk/proc/on_process()
/datum/perk/proc/on_add()
/datum/perk/proc/on_remove()
