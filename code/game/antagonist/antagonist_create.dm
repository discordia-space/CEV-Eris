/datum/antagonist/proc/create_antagonist(var/datum/mind/target, var/datum/faction/new_faction, var/doequip = TRUE, var/announce = TRUE, var/update = TRUE)
	if(!istype(target) || !target.current)
		log_debug("ANTAGONIST Wrong target passed to create_antagonist of [id]! Target: [target == null?"NULL":target] \ref[target]")
		return FALSE

	if(!can_become_antag(target))
		log_debug("ANTAGONIST [target.name] cannot become this antag, but passed roleset candidate.")
		return FALSE

	owner = target
	target.antagonist.Add(src)

	if(outer)
		if(!ispath(mob_path))
			owner = null
			log_debug("ANTAGONIST [src.id]'s mob_path is not a path! ([mob_path])")
			target.antagonist.Remove(src)
			return FALSE

		if(update || !istype(target.current,mob_path))
			update_antag_mob()

		place_antagonist()


	current_antags.Add(src)

	special_init()

	if(new_faction)
		new_faction.add_member(src)

	//create_faction()

	if(doequip)
		equip()

	//if(announce)
	//	greet()

	return TRUE

/datum/antagonist/proc/special_init()


/datum/antagonist/proc/create_from_ghost(var/mob/observer/ghost)
	if(!istype(ghost))
		log_debug("ANTAGONIST Wrong target passed to create_from_ghost of [id]! Ghost: [ghost == null?"NULL":ghost] \ref[ghost]")
		return FALSE

	if(!can_become_antag_ghost(ghost))
		log_debug("ANTAGONIST This ghost ([ghost]) can't become [id].")
		return FALSE

	if(!ispath(mob_path))
		log_debug("ANTAGONIST mob_path in [id] is not path! ([mob_path])")
		return FALSE

	var/mob/M = new mob_path(null)
	M.client = ghost.client

	if(!M.mind)
		log_debug("ANTAGONIST mob, which created from mob_path has no mind. ([M] - \ref[M] : [mob_path])")
		M.client = ghost.client
		qdel(M)
		return FALSE

	return create_antagonist(M.mind)

/datum/antagonist/proc/create_faction()
	if(!faction && faction_id)
		faction = create_or_get_faction(faction_id)
		faction.add_member(src)

/datum/antagonist/proc/set_antag_name()
	if(!owner || !owner.current)
		return
	var/mob/living/player = owner.current
	// Choose a name, if any.
	var/newname = sanitize(input(player, "You are a [role_text]. Would you like to change your name to something else?", "Name change") as null|text, MAX_NAME_LEN)
	if (newname)
		player.real_name = newname
		player.name = player.real_name
		player.dna.real_name = newname
	if(player.mind) player.mind.name = player.name
	// Update any ID cards.
	update_access(player)


/datum/antagonist/proc/remove_antagonist()
	if(faction)
		faction.remove_member(src)
		faction = null

	if(owner.current)
		BITSET(owner.current.hud_updateflag, SPECIALROLE_HUD)
	current_antags.Remove(src)
	owner.antagonist.Remove(src)
	owner = null
	return TRUE

/datum/antagonist/proc/place_antagonist()
	if(!owner.current)
		return
	var/turf/T = pick_mobless_turf_if_exists(antag_starting_locations[id])
	owner.current.forceMove(T)

