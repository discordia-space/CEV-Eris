/datum/antagonist

	// Base vars
	var/list/objectives = list()
	var/mob/living/owner = null

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

	// Misc.
	var/bantype = "Syndicate"               // Ban to check when spawning this antag.
	var/flags = 0                           // Various runtime options.
	var/selectable = FALSE					// Is this antag type present in character antag setup?

	// Used for setting appearance.
	var/list/valid_species =       list("Human")


/datum/antagonist/New()
	..()
	if(!role_type)
		role_type = id

	cur_max = hard_cap
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
/datum/antagonist/proc/build_candidate_list(var/ghosts_only)
	candidates = list() // Clear.

	// Prune restricted status. Broke it up for readability.
	// Note that this is done before jobs are handed out.
	for(var/datum/mind/player in ticker.mode.get_players_for_role(role_type, id))
		if(ghosts_only && !isghost(player.current))
			log_debug("[key_name(player)] is not eligible to become a [role_text]: Only ghosts may join as this role!")
		else if(config.use_age_restriction_for_antags && player.current.client.player_age < minimum_player_age)
			log_debug("[key_name(player)] is not eligible to become a [role_text]: Is only [player.current.client.player_age] day\s old, has to be [minimum_player_age] day\s!")
		else if(player.special_role)
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They already have a special role ([player.special_role])!")
		else if (player in pending_antagonists)
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They have already been selected for this role!")
		else if(!can_become_antag(player))
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They are blacklisted for this role!")
		else if(player_is_antag(player))
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They are already an antagonist!")
		else
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

//Spawns all pending_antagonists. This is done separately from attempt_spawn in case the game mode setup fails.
/datum/antagonist/proc/finalize_spawn()
	if(!pending_antagonists)
		return

	for(var/datum/mind/player in pending_antagonists)
		pending_antagonists -= player
		add_antagonist(player,0,0,1)

	reset_antag_selection()

//Resets the antag selection, clearing all pending_antagonists and their special_role
//(and assigned_role if ANTAG_OVERRIDE_JOB is set) as well as clearing the candidate list.
//Existing antagonists are left untouched.
/datum/antagonist/proc/reset_antag_selection()
	for(var/datum/mind/player in pending_antagonists)
		if(flags & ANTAG_OVERRIDE_JOB)
			player.assigned_role = null
		player.special_role = null
	pending_antagonists.Cut()
	candidates.Cut()
