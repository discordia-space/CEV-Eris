/datum/antagonist/proc/create_antagonist(datum/mind/target, datum/faction/new_faction, doe69uip = TRUE, announce = TRUE, update = TRUE, check = TRUE)
	if(!istype(target) || !target.current)
		log_debug("ANTAGONIST Wrong target passed to create_antagonist of 69id69! Target: 69target == null?"NULL":target69 \ref69target69")
		return FALSE

	if(check && !can_become_antag(target))
		log_debug("ANTAGONIST 69target.name69 cannot become this antag, but passed roleset candidate.")
		return FALSE

	owner = target
	target.antagonist.Add(src)
	if(outer)
		if(!ispath(mob_path))
			owner = null
			log_debug("ANTAGONIST 69src.id69's69ob_path is not a path! (69mob_path69)")
			target.antagonist.Remove(src)
			return FALSE

		if(update || !istype(target.current,mob_path))
			update_antag_mob()

		place_antagonist()

		if (appearance_editor)
			spawn(3)
				var/mob/living/carbon/human/H = owner.current
				if(istype(H))
					H.change_appearance(APPEARANCE_ALL, H.loc, H, TRUE, list(SPECIES_HUMAN), state = GLOB.z_state)

	GLOB.current_antags.Add(src)
	special_init()

	if(new_faction)
		new_faction.add_member(src)

	create_faction()

	if(doe69uip)
		e69uip()

	if(announce)
		greet()

	return TRUE

/datum/antagonist/proc/special_init()


/datum/antagonist/proc/create_from_ghost(mob/observer/ghost, datum/faction/new_faction, doe69uip = TRUE, announce = TRUE, update = TRUE)
	if(!istype(ghost))
		log_debug("ANTAGONIST Wrong target passed to create_from_ghost of 69id69! Ghost: 69ghost == null?"NULL":ghost69 \ref69ghost69")
		return FALSE

	if(!can_become_antag_ghost(ghost))
		log_debug("ANTAGONIST This ghost (69ghost69) can't become 69id69.")
		return FALSE

	if(!ispath(mob_path))
		log_debug("ANTAGONIST69ob_path in 69id69 is not path! (69mob_path69)")
		return FALSE


	var/mob/M = new69ob_path(null)
	M.client = ghost.client

	//Load your character setup onto the new69ob, only if human
	if (load_character && ishuman(M))

		var/datum/preferences/P =69.client.prefs
		P.copy_to(M, FALSE)



	if(!M.mind)
		log_debug("ANTAGONIST69ob, which created from69ob_path has no69ind. (69M69 - \ref69M69 : 69mob_path69)")
		M.client = ghost.client
		69del(M)
		return FALSE

	return create_antagonist(M.mind, new_faction, doe69uip, announce, update = FALSE)

/datum/antagonist/proc/create_faction()
	if(!faction && faction_id)
		faction = create_or_get_faction(faction_id)
		faction.add_member(src)
		faction.create_objectives()

/datum/antagonist/proc/set_antag_name()
	if(!owner || !owner.current)
		return
	var/mob/living/player = owner.current
	// Choose a name, if any.
	var/newname = sanitize(input(player, "You are a 69role_text69. Would you like to change your name to something else?", "Name change") as null|text,69AX_NAME_LEN)
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

	GLOB.current_antags.Remove(src)
	if (!owner)
		return //This can happen with some spamclicking
	if(owner.current)
		BITSET(owner.current.hud_updateflag, SPECIALROLE_HUD)

	owner.antagonist.Remove(src)
	owner = null
	return TRUE

/datum/antagonist/proc/place_antagonist()
	if(!owner.current)
		return
	var/turf/T = pick_mobless_turf_if_exists(GLOB.antag_starting_locations69id69)
	owner.current.forceMove(T)
