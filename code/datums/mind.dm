/*	Note from Carnie:
		The way datum/mind stuff works has been changed a lot.
		Minds now represent IC characters rather than following a client around constantly.

	Guidelines for using minds properly:

	-	Never mind.transfer_to(ghost). The var/current and var/original of a mind must always be of type mob/living!
		ghost.mind is however used as a reference to the ghost's corpse

	-	When creating a new mob for an existing IC character (e.g. cloning a dead guy or borging a brain of a human)
		the existing mind of the old mob should be transfered to the new mob like so:

			mind.transfer_to(new_mob)

	-	You must not assign key= or ckey= after transfer_to() since the transfer_to transfers the client for you.
		By setting key or ckey explicitly after transfering the mind with transfer_to you will cause bugs like DCing
		the player.

	-	IMPORTANT NOTE 2, if you want a player to become a ghost, use mob.ghostize() It does all the hard work for you.

	-	When creating a new mob which will be a new IC character (e.g. putting a shade in a construct or randomly selecting
		a ghost to become a xeno during an event). Simply assign the key or ckey like you've always done.
[]['
			new_mob.key = key

		The Login proc will handle making a new mob for that mobtype (including setting up stuff like mind.name). Simple!
		However if you want that mind to have any special properties like being a traitor etc you will have to do that
		yourself.

*/

/datum/mind
	var/key
	var/name				//replaces mob/var/original_name
	var/mob/living/current
	var/mob/living/original	//TODO: remove.not used in any meaningful way ~Carn. First I'll need to tweak the way silicon-mobs handle minds.
	var/active = FALSE



	var/memory

	var/assigned_role
	var/role_alt_title
	var/list/antagonist = list()

	var/datum/job/assigned_job


	var/has_been_rev = FALSE	//Tracks if this mind has been a rev or not


	var/rev_cooldown = 0

	// the world.time since the mob has been brigged, or -1 if not at all
	var/brigged_since = -1

	//put this here for easier tracking ingame
	var/datum/money_account/initial_account

	var/list/known_connections //list of known (RNG) relations between people
	var/gen_relations_info

	var/list/initial_email_login = list("login" = "", "password" = "")

	var/last_activity = 0

	var/list/knownCraftRecipes = list()
	/*
		The world time when this mind was last in a mob, controlled by a client which did something.
		Only updated once per minute, set by the inactivity subsystem
		If this is 0, the mind has never had a cliented mob
	*/

	var/creation_time = 0 //World time when this datum was New'd. Useful to tell how long since a character spawned

/datum/mind/New(var/key)
	src.key = key
	creation_time = world.time
	..()

/datum/mind/proc/transfer_to(mob/living/new_character)
	if(!istype(new_character))
		log_world("## DEBUG: transfer_to(): Some idiot has tried to transfer_to() a non mob/living mob. Please inform Carn")
	if(current)					//remove ourself from our old body's mind variable
		current.mind = null

		SSnano.user_transferred(current, new_character) // transfer active NanoUI instances to new user

		if(current.client)
			current.client.destroy_UI()

	if(new_character.mind)		//remove any mind currently in our new body's mind variable
		new_character.mind.current = null

	current = new_character		//link ourself to our new body
	new_character.mind = src	//and link our new body to ourself


	if(active)
		new_character.key = key		//now transfer the key to link the client to our new body
		last_activity = world.time
	if(new_character.client)
		new_character.client.create_UI(new_character.type)

/datum/mind/proc/store_memory(new_text)
	memory += "[new_text]<BR>"

/datum/mind/proc/print_individualobjectives()
	var/output
	if(LAZYLEN(individual_objectives))
		output += "<HR><B>Your individual objectives:</B><UL>"
		var/obj_count = 1
		var/la_explanation
		for(var/datum/individual_objective/objective in individual_objectives)
			output += "<br><b>#[obj_count] [objective.name][objective.limited_antag ? " [objective.show_la]" : ""]</B>: [objective.get_description()]</b>"
			obj_count++
			if(objective.limited_antag)
				la_explanation = objective.la_explanation
		output += "</UL>"
		if(la_explanation)
			output += la_explanation
	return output

/datum/mind/proc/show_memory(mob/recipient)
	var/output = "<B>[current.real_name]'s Memory</B><HR>"
	output += memory

	for(var/datum/antagonist/A in antagonist)
		if(!A.objectives.len)
			break
		if(A.faction)
			output += "<br><b>Your [A.faction.name] faction objectives:</b>"
		else
			output += "<br><b>Your [A.role_text] objectives:</b>"
		output += "[A.print_objectives(FALSE)]"
	output += print_individualobjectives()
	recipient << browse(output, "window=memory")

/datum/mind/proc/edit_memory()
	if(SSticker.current_state != GAME_STATE_PLAYING)
		alert("Not before round-start!", "Alert")
		return

	var/out = "<B>[name]</B>[(current&&(current.real_name!=name))?" (as [current.real_name])":""]<br>"
	out += "Mind currently owned by key: [key] [active?"(synced)":"(not synced)"]<br>"
	out += "Assigned role: [assigned_role]. <a href='?src=\ref[src];role_edit=1'>Edit</a><br>"
	out += "<hr>"
	out += "Special roles:<br><table>"

	out += "<b>Make_antagonist: </b><br>"
	for(var/A in GLOB.all_antag_selectable_types)
		var/datum/antagonist/antag = GLOB.all_antag_selectable_types[A]
		var/antag_name = (antag.bantype in GLOB.all_antag_selectable_types) ? antag.bantype : "<font color='red'>[antag.bantype]</font>"
		out += "<a href='?src=\ref[src];add_antagonist=[antag.bantype]'>[antag_name]</a><br>"
	out += "<br>"

	for(var/datum/antagonist/antag in antagonist)
		out += "<br><b>[antag.role_text]</b> <a href='?src=\ref[antag]'>\[EDIT\]</a> <a href='?src=\ref[antag];remove_antagonist=1'>\[DEL\]</a>"
	out += "</table><hr>"
	out += "<br>[memory]"

	out += print_individualobjectives()

	out += "<br><a href='?src=\ref[src];edit_memory=1'>"
	usr << browse(out, "window=edit_memory[src]")

/datum/mind/Topic(href, href_list)
	if(!check_rights(R_ADMIN))
		return

	if(href_list["add_antagonist"])
		var/datum/antagonist/antag = GLOB.all_antag_types[href_list["add_antagonist"]]
		if(antag)
			var/ok = FALSE
			if(antag.outer && active)
				var/answer = alert("[antag.role_text] is an outer antagonist. [name] will be taken from the current mob and spawned as antagonist. Continue?","Confirmation", "No","Yes")
				ok = (answer == "Yes")
			else
				var/answer = alert("Are you sure you want to make [name] the [antag.role_text]","Confirmation","No","Yes")
				ok = (answer == "Yes")

			if(!ok)
				return

			if(antag.outer)
				//Outer antags are created from ghosts, we must make a ghost first
				var/mob/observer/ghost/ghost = current.ghostize(FALSE)
				antag.create_from_ghost(ghost, announce = FALSE)
				qdel(current) //Delete our old body
				antag.greet()

			else
				if(antag.create_antagonist(src))
					log_admin("[key_name_admin(usr)] made [key_name(src)] into a [antag.role_text].")
				else
					to_chat(usr, SPAN_WARNING("[src] could not be made into a [antag.role_text]!"))

	else if(href_list["role_edit"])
		var/new_role = input("Select new role", "Assigned role", assigned_role) as null|anything in GLOB.joblist
		if (!new_role) return
		var/datum/job/job = SSjob.GetJob(new_role)
		if(job)
			assigned_role = job.title
			role_alt_title = new_role

	else if(href_list["memory_edit"])
		var/new_memo = sanitize(input("Write new memory", "Memory", memory) as null|message)
		if (isnull(new_memo)) return
		memory = new_memo

	else if(href_list["silicon"])
		BITSET(current.hud_updateflag, SPECIALROLE_HUD)
		switch(href_list["silicon"])

			if("unemag")
				var/mob/living/silicon/robot/R = current
				if (istype(R))
					R.emagged = 0
					if (R.activated(R.module.emag))
						R.module_active = null
					if(R.module_state_1 == R.module.emag)
						R.module_state_1 = null
						R.contents -= R.module.emag
					else if(R.module_state_2 == R.module.emag)
						R.module_state_2 = null
						R.contents -= R.module.emag
					else if(R.module_state_3 == R.module.emag)
						R.module_state_3 = null
						R.contents -= R.module.emag
					log_admin("[key_name_admin(usr)] has unemag'ed [R].")

			if("unemagcyborgs")
				if (isAI(current))
					var/mob/living/silicon/ai/ai = current
					for (var/mob/living/silicon/robot/R in ai.connected_robots)
						R.emagged = 0
						if (R.module)
							if (R.activated(R.module.emag))
								R.module_active = null
							if(R.module_state_1 == R.module.emag)
								R.module_state_1 = null
								R.contents -= R.module.emag
							else if(R.module_state_2 == R.module.emag)
								R.module_state_2 = null
								R.contents -= R.module.emag
							else if(R.module_state_3 == R.module.emag)
								R.module_state_3 = null
								R.contents -= R.module.emag
					log_admin("[key_name_admin(usr)] has unemag'ed [ai]'s Cyborgs.")

	else if(href_list["common"])
		switch(href_list["common"])
			if("undress")
				for(var/obj/item/W in current)
					current.drop_from_inventory(W)
			if("takeuplink")
				take_uplink()
				memory = null//Remove any memory they may have had.
			if("crystals")
				if (usr.client.holder.rights & R_FUN)
					var/obj/item/device/uplink/hidden/suplink = find_syndicate_uplink()
					var/crystals
					if (suplink)
						crystals = suplink.uses
					crystals = input("Amount of telecrystals for [key]", "Operative uplink", crystals) as null|num
					if (!isnull(crystals))
						if (suplink)
							suplink.uses = crystals

	edit_memory()

/datum/mind/proc/find_syndicate_uplink()
	var/list/L = current.get_contents()
	for (var/obj/item/I in L)
		if (I.hidden_uplink)
			return I.hidden_uplink
	return null

/datum/mind/proc/take_uplink()
	var/obj/item/device/uplink/hidden/H = find_syndicate_uplink()
	if(H)
		qdel(H)


// check whether this mind's mob has been brigged for the given duration
// have to call this periodically for the duration to work properly
/datum/mind/proc/is_brigged(duration)
	var/turf/T = current.loc
	if(!istype(T))
		brigged_since = -1
		return 0
	var/is_currently_brigged = 0
	if(istype(T.loc,/area/eris/security/brig))
		is_currently_brigged = 1
		if(current.GetIdCard())
			is_currently_brigged = 0

	if(!is_currently_brigged)
		brigged_since = -1
		return 0

	if(brigged_since == -1)
		brigged_since = world.time

	return (duration <= world.time - brigged_since)

/datum/mind/proc/reset()
	assigned_role =   null
	//role_alt_title =  null
	assigned_job =    null
	//faction =       null //Uncommenting this causes a compile error due to 'undefined type', fucked if I know.
	role_alt_title =  null
	initial_account = null
	has_been_rev =    0
	rev_cooldown =    0
	brigged_since =   -1

//Antagonist role check
/mob/living/proc/check_special_role(role)
	return role && mind && player_is_antag_id(mind, role)

//Initialisation procs
/mob/living/proc/mind_initialize()
	if(mind)
		mind.key = key
	else
		mind = new /datum/mind(key)
		mind.original = src
		SSticker.minds += mind
	if(!mind.name)	mind.name = real_name
	mind.current = src

//HUMAN
/mob/living/carbon/human/mind_initialize()
	..()
	if(!mind.assigned_role)	mind.assigned_role = ASSISTANT_TITLE	//defualt

//slime
/mob/living/carbon/slime/mind_initialize()
	..()
	mind.assigned_role = "slime"

//AI
/mob/living/silicon/ai/mind_initialize()
	..()
	mind.assigned_role = "AI"

//BORG
/mob/living/silicon/robot/mind_initialize()
	..()
	mind.assigned_role = "Robot"

//PAI
/mob/living/silicon/pai/mind_initialize()
	..()
	mind.assigned_role = "pAI"

//Animals
/mob/living/simple_animal/mind_initialize()
	..()
	mind.assigned_role = "Animal"

/mob/living/simple_animal/corgi/mind_initialize()
	..()
	mind.assigned_role = "Corgi"



/datum/mind/proc/manifest_status(var/datum/computer_file/report/crew_record/CR)
	var/inactive_time = world.time - last_activity
	if (inactive_time >= 60 MINUTES)
		return null //The server hasn't seen us alive in an hour.
		//We will not show on the manifest at all

	//Ok we're definitely going to show on the manifest, lets see if any status is set for us in the records
	var/status = CR.get_status()
	.=status //We'll return the status as a fallback

	//If the records have a specific status set, we'll return that
	//Active is the default state, it means nothing else has specifically been set.
	if (status != "Active")
		return


	//Ok the records say active, that means nothing.
	//In that case we'll show as inactive if the mob has been inactive longer than 15 minutes
	if (inactive_time >= 15 MINUTES)
		return "Inactive"
