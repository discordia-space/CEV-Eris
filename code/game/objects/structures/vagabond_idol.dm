GLOBAL_LIST_EMPTY(vagabond_idols)
/obj/vagabond_idol
	name = "Vagabond Idol"
	desc = "Ghosts can possess this to be reformed into a Vagabond."
	anchored = TRUE
	icon = 'icons/obj/items.dmi'
	icon_state = "vagabond_idol"

/obj/vagabond_idol/New()
	GLOB.vagabond_idols.Add(src)
	. = ..()

/obj/vagabond_idol/Destroy()
	. = ..()
	GLOB.vagabond_idols.Remove(src)

/obj/vagabond_idol/proc/spawn_ghost(mob/observer/ghosttospawn)
	announce_ghost_joinleave(ghosttospawn, 0, "They have respawned as a vagabond.")
	var/mob/living/carbon/human/newhuman = new /mob/living/carbon/human(get_turf(src)) // we remake vagabonds from scratch, the normal procs expect choice
	var/datum/preferences/preference = SScharacter_setup.preferences_datums[ghosttospawn.ckey] // ha, ghosts don't have rights here, they're lucky they got to choose the first time
	if(ghosttospawn.mind) ghosttospawn.mind.reset()
	newhuman.ckey = ghosttospawn.ckey
	ghosttospawn.mind.transfer_to(newhuman)
	newhuman.gender = preference.gender
	newhuman.real_name = preference.real_first_name + " " + preference.real_last_name
	newhuman.dna.ready_dna(newhuman)
	newhuman.force_update_limbs()
	newhuman.update_eyes()
	newhuman.mind.assigned_role = ASSISTANT_TITLE
	newhuman = SSjob.EquipRank(newhuman, ASSISTANT_TITLE)
	newhuman.equip_to_storage(new /obj/item/tool/crowbar(src))
	newhuman.lastarea = get_area(src)
	visible_message("[newhuman] steps out of [src].")

/mob/observer/ghost/verb/join_as_vagabond()
	set category = "Ghost"
	set name = "Respawn as Vagabond"
	set desc = "If there is a vagabond idol in the game world, join as a vagabond."
	var/obj/vagabond_idol/idol = pick(GLOB.vagabond_idols)
	if(idol)
		idol.spawn_ghost(src)
