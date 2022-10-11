/datum/job

	//The name of the job
	var/title = "NOPE"
	var/list/access = list()				// Useful for servers which either have fewer players, so each person needs to fill more than one role, or servers which like to give more access, so players can't hide forever in their super secure departments (I'm looking at you, chemistry!)
	var/list/cruciform_access = list()		// Assign this access into cruciform if target has it
	var/security_clearance = CLEARANCE_NONE	// Cruciform-specific access type, used by Neotheology doors
	var/list/software_on_spawn = list()		// Defines the software files that spawn on tablets and labtops
	var/list/core_upgrades = list()			// Defines the upgrades that would be installed into core implant on spawn, if any.
	var/flag = NONE							// Bitflags for the job
	var/department_flag = NONE
	var/faction = "None"					// Players will be allowed to spawn in as jobs that are set to "Station"
	var/total_positions = 0					// How many players can be this job
	var/spawn_positions = 0					// How many players can spawn in as this job
	var/current_positions = 0				// How many players have this job
	var/supervisors							// Supervisors, who this person answers to directly
	var/selection_color = "#ffffff"			// Selection screen color
	var/list/alt_titles
	var/list/datum/job_flavor/random_flavors = list(null)

	var/req_admin_notify					// If this is set to 1, a text is printed to the player when jobs are assigned, telling him that he should let admins know that he has to disconnect.
	var/department							// Does this position have a department tag?
	var/head_position = FALSE				// Is this position Command?
	var/aster_guild_member = FALSE			// If this person's account authorized to register new accounts
	var/department_account_access = FALSE	// Can this position access the department acount, even if they're not a head?
	var/minimum_character_age = 0
	var/ideal_character_age = 30
	var/create_record = 1					// Do we announce/make records for people who spawn on this job?
	var/list/also_known_languages = list()	// additional chance based languages to all jobs.

	var/account_allowed = 1					// Does this job type come with a station account?
	var/wage = WAGE_LABOUR					// How much base wage does this job recieve per payday
	var/initial_balance	=	-1				// If set to a value other than -1, overrides the wage based initial balance calculation

	var/outfit_type							// The outfit the employee will be dressed in, if any

	var/loadout_allowed = TRUE				// Does this job allows loadout ?
	var/description = ""
	var/duties = ""
	var/loyalties = ""

	var/setup_restricted = FALSE

	//Character stats modifers
	var/list/stat_modifiers = list()

	var/list/perks = list()

/datum/job/proc/equip(var/mob/living/carbon/human/H, var/alt_title)
	var/decl/hierarchy/outfit/outfit = get_outfit()
	if(!outfit)
		return FALSE
	. = outfit.equip(H, title, alt_title)

/datum/job/proc/get_outfit(var/alt_title)
	if(alt_title && alt_titles)
		. = alt_titles[alt_title]
	. = . || outfit_type
	. = outfit_by_type(.)

/datum/job/proc/add_stats(var/mob/living/carbon/human/target, datum/job_flavor/flavor)
	if(!istype(target))
		return FALSE

	if(flavor)
		for(var/name in flavor.stat_modifiers)
			target.stats.changeStat(name, flavor.stat_modifiers[name])
	else
		for(var/name in src.stat_modifiers)
			target.stats.changeStat(name, stat_modifiers[name])

	for(var/perk in perks)
		target.stats.addPerk(perk)

	return TRUE

/datum/job/proc/add_additiional_language(var/mob/living/carbon/human/target)
	if(!ishuman(target))
		return FALSE

	var/mob/living/carbon/human/H = target

	if(!also_known_languages.len)
		return FALSE

	var/i

	for(i in also_known_languages)
		if(prob(also_known_languages[i]))
			H.add_language(i)

	return TRUE

/datum/job/proc/setup_account(var/mob/living/carbon/human/H)
	if(!account_allowed || (H.mind && H.mind.initial_account))
		return

	//give them an account in the station database
	if(H.job == "Vagabond") // Vagabound do not get an account.
		H.mind.store_memory("As a freelancer you do not have a bank account.")
		return
	var/species_modifier = (H.species ? economic_species_modifier[H.species.type] : 2)
	if(!species_modifier)
		species_modifier = economic_species_modifier[/datum/species/human]

	var/money_amount = one_time_payment(species_modifier)
	var/datum/money_account/M = create_account(H.real_name, money_amount, null, department, wage, aster_guild_member)
	if(H.mind)
		var/remembered_info = ""
		remembered_info += "<b>Your account number is:</b> #[M.account_number]<br>"
		remembered_info += "<b>Your account pin is:</b> [M.remote_access_pin]<br>"
		remembered_info += "<b>Your account funds are:</b> [M.money][CREDS]<br>"

		if(M.transaction_log.len)
			var/datum/transaction/T = M.transaction_log[1]
			remembered_info += "<b>Your account was created:</b> [T.time], [T.date] at [T.source_terminal]<br>"
		H.mind.store_memory(remembered_info)

		H.mind.initial_account = M

	to_chat(H, SPAN_NOTICE("<b>Your account number is: [M.account_number], your account pin is: [M.remote_access_pin]</b>"))

// overrideable separately so AIs/borgs can have cardborg hats without unneccessary new()/qdel()
/datum/job/proc/equip_preview(mob/living/carbon/human/H, var/alt_title, var/datum/branch, var/additional_skips)
	var/decl/hierarchy/outfit/outfit = get_outfit(H, alt_title)
	if(!outfit)
		return FALSE
	. = outfit.equip(H, title, alt_title, OUTFIT_ADJUSTMENT_SKIP_POST_EQUIP|OUTFIT_ADJUSTMENT_SKIP_ID_PDA|additional_skips)

/datum/job/proc/get_access()
	return src.access.Copy()

/datum/job/proc/apply_fingerprints(var/mob/living/carbon/human/target)
	if(!istype(target))
		return 0
	for(var/obj/item/item in target.contents)
		apply_fingerprints_to_item(target, item)
	return 1
/*
//If the configuration option is set to require players to be logged as old enough to play certain jobs, then this proc checks that they are, otherwise it just returns 1
/datum/job/proc/player_old_enough(client/C)
	return (available_in_days(C) == 0) //Available in 0 days = available right now = player is old enough to play.

/datum/job/proc/available_in_days(client/C)
	if(C && config.use_age_restriction_for_jobs && isnull(C.holder) && isnum(C.player_age) && isnum(minimal_player_age))
		return max(0, minimal_player_age - C.player_age)
	return 0
*/
/datum/job/proc/apply_fingerprints_to_item(var/mob/living/carbon/human/holder, var/obj/item/item)
	item.add_fingerprint(holder,1)
	if(item.contents.len)
		for(var/obj/item/sub_item in item.contents)
			apply_fingerprints_to_item(holder, sub_item)

/datum/job/proc/is_position_available()
	return (current_positions < total_positions) || (total_positions == -1)

/datum/job/proc/is_restricted(datum/preferences/prefs, feedback)
	if(is_setup_restricted(prefs.setup_options))
		to_chat(feedback, "<span class='boldannounce'>[setup_restricted ? "The job requires you to pick a specific setup option." : "The job conflicts with one of your setup options."]</span>")
		return TRUE

	if(minimum_character_age && (prefs.age < minimum_character_age))
		to_chat(feedback, "<span class='boldannounce'>Not old enough. Minimum character age is [minimum_character_age].</span>")
		return TRUE

	return FALSE

/datum/job/proc/is_setup_restricted(list/options)
	. = setup_restricted
	for(var/category in options)
		var/datum/category_item/setup_option/option = SScharacter_setup.setup_options[category][options[category]]
		if(!option)
			continue
		if(type in option.restricted_jobs)
			return TRUE
		if(type in option.allowed_jobs)
			. = FALSE

//	Creates mannequin with equipment for current job and stores it for future reference
//	used for preview
//	You can use getflaticon(mannequin) to get icon out of it
/datum/job/proc/get_job_mannequin()
	if(!SSjob.job_mannequins[title])
		var/mob/living/carbon/human/dummy/mannequin/mannequin = get_mannequin("#job_icon_[title]")
		dress_mannequin(mannequin)

		SSjob.job_mannequins[title] = mannequin
	return SSjob.job_mannequins[title]

/datum/job/proc/get_description_blurb()
	var/job_desc = ""
	//Here's the actual content of the description
	if (description)
		job_desc += "<h1>Overview:</h1>"
		job_desc += "<hr>"
		job_desc += description
		job_desc += "<br>"

	if (duties)
		job_desc += "<h1>Duties:</h1>"
		job_desc += "<hr>"
		job_desc += duties
		job_desc += "<br>"

	if (loyalties)
		job_desc += "<h1>Loyalties:</h1>"
		job_desc += "<hr>"
		job_desc += loyalties
		job_desc += "<br>"

	return job_desc

/datum/job/proc/dress_mannequin(var/mob/living/carbon/human/dummy/mannequin/mannequin)
	mannequin.delete_inventory(TRUE)
	equip_preview(mannequin, additional_skips = OUTFIT_ADJUSTMENT_SKIP_BACKPACK|OUTFIT_ADJUSTMENT_SKIP_SURVIVAL_GEAR)
