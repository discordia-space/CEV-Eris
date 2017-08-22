/datum/antagonist

	// Base vars
	var/list/objectives = list()
	var/datum/mind/owner = null

	var/list/restricted_jobs =     list()   // Jobs that technically cannot be this antagonist (like AI-changeling)
	var/list/protected_jobs =      list()   // As above, but this jobs are rewstricted ideologically (like Security Officer-traitor)

	// Strings.
	var/welcome_text = "Cry havoc and let slip the dogs of war!"

	// Role data.
	var/id = "traitor"                      // Unique datum identifier.
	var/role_type                           // Preferences option for this role. Defaults to the id if unset
	var/role_text = "Traitor"               // special_role text.
	var/role_text_plural = "Traitors"       // As above but plural.

	// Visual references.
	var/antaghud_indicator = "hudsyndicate" // Used by the ghost antagHUD.
	var/antag_indicator                     // icon_state for icons/mob/mob.dm visual indicator.

	// Faction data.
	var/datum/faction/faction = null
	var/faction_type = null

	// Misc.
	var/bantype = "Syndicate"               // Ban to check when spawning this antag.
	var/list/uplinks = list()

	// Used for setting appearance.
	var/list/valid_species =       list("Human")


/datum/antagonist/New()
	..()
	if(!role_type)
		role_type = id

	get_starting_locations()
	if(!role_text_plural)
		role_text_plural = role_text
	if(config.protect_roles_from_antagonist)
		restricted_jobs |= protected_jobs
	if(antaghud_indicator)
		if(!hud_icon_reference)
			hud_icon_reference = list()
		if(role_text) hud_icon_reference[role_text] = antaghud_indicator
		if(faction_role_text) hud_icon_reference[faction_role_text] = antaghud_indicator

/datum/antagonist/proc/tick()
	return 1

// Get the raw list of potential players.
/datum/antagonist/proc/build_candidate_list()
	candidates = list() // Clear.

	// Prune restricted status. Broke it up for readability.
	for(var/mob/player in player_list)
		if(!player.mind || isnewplayer(player))
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They don't have a mind or not a character!")
			continue
		if(isouter() && !(isghost(player) /*|| isangel(player) */))
			log_debug("[key_name(player)] is not eligible to become a [role_text]: Only ghosts and angels may join as this role!")
			continue
		if(!(role_type in player.client.prefs.be_special_role))
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They don't select this role in prefs!")
			continue
		if(player.current && jobban_isbanned(player, bantype))
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They are jobbanned from this role!")
			continue

		var/datum/mind/mind = player.mind

		if(!can_become_antag(mind))
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They are blacklisted for this role!")
			continue
		if(player_is_antag(mind))
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They are already an antagonist!")
			continue

		candidates += player

	return candidates


//Selects players that will be spawned in the antagonist role from the potential candidates
//Selected players are added to the pending_antagonists lists.
//Attempting to spawn an antag role with ANTAG_OVERRIDE_JOB should be done before jobs are assigned,
//so that they do not occupy regular job slots. All other antag roles should be spawned after jobs are
//assigned, so that job restrictions can be respected.
/datum/antagonist/proc/attempt_spawn(var/spawn_target = null)
	if(spawn_target == null)
		spawn_target = initial_spawn_target

	// Update our boundaries.
	if(!candidates.len)
		return 0

	//Grab candidates randomly until we have enough.
	while(candidates.len && pending_antagonists.len < spawn_target)
		var/datum/mind/player = pick(candidates)
		candidates -= player
		draft_antagonist(player)

	return 1

/datum/antagonist/proc/draft_antagonist(var/datum/mind/player)
	//Check if the player can join in this antag role, or if the player has already been given an antag role.
	if(!can_become_antag(player))
		log_debug("[player.key] was selected for [role_text] by lottery, but is not allowed to be that role.")
		return 0
	if(player.special_role)
		log_debug("[player.key] was selected for [role_text] by lottery, but they already have a special role.")
		return 0
	if(!(flags & ANTAG_OVERRIDE_JOB) && (!player.current || isnewplayer(player.current)))
		log_debug("[player.key] was selected for [role_text] by lottery, but they have not joined the game.")
		return 0

	pending_antagonists |= player
	log_debug("[player.key] has been selected for [role_text] by lottery.")

	//Ensure that antags with ANTAG_OVERRIDE_JOB do not occupy job slots.
	if(flags & ANTAG_OVERRIDE_JOB)
		player.assigned_role = role_text

	//Ensure that a player cannot be drafted for multiple antag roles, taking up slots for antag roles that they will not fill.
	player.special_role = role_text

	return 1
