/datum/antagonist/proc/create_antagonist(var/datum/mind/target, var/datum/faction/new_faction, var/doequip = TRUE)
	if(!istype(target) || !target.current)
		log_debug("ANTAGONIST Wrong target passed to create_antagonist of [id]! Target: [target == null?"NULL":target]")
		return FALSE

	if(!can_become_antag(target))
		log_debug("ANTAGONIST [target.name] cannot become this antag, but passed roleset candidate.")
		return FALSE

	target.antagonist.Add(src)
	owner = target

	if(new_faction)
		new_faction.add_member(src)

	create_faction()

	if(!objectives || !objectives.len)
		create_objectives()

	if(doequip)
		equip()

	if(outer)
		set_antag_name()

	greet()
	return TRUE

/datum/antagonist/proc/create_faction()
	if(!faction && faction_type)
		faction = create_or_get_faction(faction_type)
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
	return TRUE

/datum/antagonist/proc/place_antagonist()
	if(!owner.current)
		return
	var/turf/T = pick_mobless_turf_if_exists(antag_starting_locations[id])
	owner.current.forceMove(T)

