/datum/antagonist/proc/update_antag_mob(var/datum/mind/player, var/preserve_appearance)

	// Get the mob.
	if((flags & ANTAG_OVERRIDE_MOB) && (!player.current || (mob_path && !istype(player.current, mob_path))))
		var/mob/holder = player.current
		player.current = new mob_path(get_turf(player.current))
		player.transfer_to(player.current)
		if(holder) qdel(holder)
	player.original = player.current
	if(!preserve_appearance && (flags & ANTAG_SET_APPEARANCE))
		spawn(3)
			var/mob/living/carbon/human/H = player.current
			if(istype(H)) H.change_appearance(APPEARANCE_ALL, H.loc, H, valid_species, state = z_state)
	return player.current

/datum/antagonist/proc/update_access(var/mob/living/player)
	for(var/obj/item/weapon/card/id/id in player.contents)
		player.set_id_info(id)
