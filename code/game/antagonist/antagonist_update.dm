/datum/antagonist/proc/update_antag_mob(var/transfer_mind = TRUE)
	// Get the mob.
	if(owner.current && ispath(mob_path))
		var/mob/holder = owner.current

		if(transfer_mind)
			owner.current = new mob_path(get_turf(owner.current))
			owner.transfer_to(owner.current)
			owner.original = owner.current
		else
			var/mob/M = new mob_path(get_turf(owner.current))
			M.key = owner.current.key
			owner = M.mind

		if(holder)
			qdel(holder)
		spawn(3)
			var/mob/living/carbon/human/H = owner.current
			if(istype(H))
				H.change_appearance(APPEARANCE_ALL, H.loc, H, list("Human"), state = z_state)
		return owner.current

/datum/antagonist/proc/update_access()
	if(!owner || !owner.current)
		return
	for(var/obj/item/weapon/card/id/id in owner.current.contents)
		owner.current.set_id_info(id)
