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

	if(!role_text_plural)
		role_text_plural = role_text
	if(config.protect_roles_from_antagonist)
		restricted_jobs |= protected_jobs
	/*if(antaghud_indicator)
		if(!hud_icon_reference)
			hud_icon_reference = list()
		if(role_text)
			hud_icon_reference[role_text] = antaghud_indicator
	*/
