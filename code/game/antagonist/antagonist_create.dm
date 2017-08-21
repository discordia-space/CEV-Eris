/datum/antagonist/proc/create_antagonist(var/datum/mind/target, var/datum/faction/new_faction)
	if(!istype(target) || !can_become_antag(target))
		return FALSE

	target.antagonist.Add(src)
	owner = target

	if(new_faction)
		new_faction.add_member(src)

	create_faction()

	if(!objectives || !objectives.len)
		create_objectives()

	update_icons_added(target)
	equip()
	BITSET(player.current.hud_updateflag, SPECIALROLE_HUD)
	greet()

/datum/antagonist/proc/create_faction()
	if(!faction && faction_type)
		faction = new faction_type
		faction.add_leader(src)


/datum/antagonist/proc/set_antag_name(var/mob/living/player)
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

