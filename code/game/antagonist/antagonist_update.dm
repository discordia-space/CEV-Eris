/datum/antagonist/outer/proc/update_antag_mob()

	// Get the mob.
	if(owner.current)
		var/mob/holder = owner.current
		owner.current = new mob_path(get_turf(owner.current))
		owner.transfer_to(owner.current)
		if(holder)
			qdel(holder)
		owner.original = owner.current
		spawn(3)
			var/mob/living/carbon/human/H = owner.current
			if(istype(H))
				H.change_appearance(APPEARANCE_ALL, H.loc, H, valid_species, state = z_state)
		return owner.current

/datum/antagonist/proc/update_access()
	if(!owner || !owner.current)
		return
	for(var/obj/item/weapon/card/id/id in owner.current.contents)
		owner.current.set_id_info(id)
