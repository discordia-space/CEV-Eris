/*	Note from Carnie:
		The way datum/mind stuff works has been changed a lot.
		Minds now represent IC characters rather than following a client around constantly.

	Guidelines for using69inds properly:

	-	Never69ind.transfer_to(ghost). The69ar/current and69ar/original of a69ind69ust always be of type69ob/living!
		ghost.mind is however used as a reference to the ghost's corpse

	-	When creating a new69ob for an existing IC character (e.g. cloning a dead guy or borging a brain of a human)
		the existing69ind of the old69ob should be transfered to the new69ob like so:

			mind.transfer_to(new_mob)

	-	You69ust not assign key= or ckey= after transfer_to() since the transfer_to transfers the client for you.
		By setting key or ckey explicitly after transfering the69ind with transfer_to you will cause bugs like DCing
		the player.

	-	IMPORTANT NOTE 2, if you want a player to become a ghost, use69ob.ghostize() It does all the hard work for you.

	-	When creating a new69ob which will be a new IC character (e.g. putting a shade in a construct or randomly selecting
		a ghost to become a xeno during an event). Simply assign the key or ckey like you've always done.
696969'
			new_mob.key = key

		The Login proc will handle69aking a new69ob for that69obtype (including setting up stuff like69ind.name). Simple!
		However if you want that69ind to have any special properties like being a contractor etc you will have to do that
		yourself.

*/

/datum/mind
	var/key
	var/name				//replaces69ob/var/original_name
	var/mob/living/current
	var/mob/living/original	//TODO: remove.not used in any69eaningful way ~Carn. First I'll need to tweak the way silicon-mobs handle69inds.
	var/active = FALSE



	var/memory

	var/assigned_role
	var/role_alt_title
	var/list/antagonist = list()

	var/datum/job/assigned_job


	var/has_been_rev = FALSE	//Tracks if this69ind has been a rev or not


	var/rev_cooldown = 0

	// the world.time since the69ob has been brigged, or -1 if not at all
	var/brigged_since = -1

	//put this here for easier tracking ingame
	var/datum/money_account/initial_account

	var/list/known_connections //list of known (RNG) relations between people
	var/gen_relations_info

	var/list/initial_email_login = list("login" = "", "password" = "")

	var/last_activity = 0

	var/list/knownCraftRecipes = list()
	/*
		The world time when this69ind was last in a69ob, controlled by a client which did something.
		Only updated once per69inute, set by the inactivity subsystem
		If this is 0, the69ind has never had a cliented69ob
	*/

	var/creation_time = 0 //World time when this datum was New'd. Useful to tell how long since a character spawned

/datum/mind/New(var/key)
	src.key = key
	creation_time = world.time
	..()

/datum/mind/proc/transfer_to(mob/living/new_character)
	if(!istype(new_character))
		log_world("## DEBUG: transfer_to(): Some idiot has tried to transfer_to() a non69ob/living69ob. Please inform Carn")
	if(current)					//remove ourself from our old body's69ind69ariable
		current.mind = null

		SSnano.user_transferred(current, new_character) // transfer active NanoUI instances to new user

		if(current.client)
			current.client.destroy_UI()

	if(new_character.mind)		//remove any69ind currently in our new body's69ind69ariable
		new_character.mind.current = null

	current = new_character		//link ourself to our new body
	new_character.mind = src	//and link our new body to ourself


	if(active)
		new_character.key = key		//now transfer the key to link the client to our new body
		last_activity = world.time
	if(new_character.client)
		new_character.client.create_UI(new_character.type)
		if(new_character.client.get_preference_value(/datum/client_preference/stay_in_hotkey_mode) == GLOB.PREF_YES)
			winset(new_character.client, null, "mainwindow.macro=hotkeymode hotkey_toggle.is-checked=true69apwindow.map.focus=true input.background-color=#F0F0F0")
			if(istype(new_character, /mob/living/silicon/robot))
				winset(new_character.client, null, "mainwindow.macro=borgmacro")

/datum/mind/proc/store_memory(new_text)
	memory += "69new_text69<BR>"

/datum/mind/proc/print_individualobjectives()
	var/output
	if(LAZYLEN(individual_objectives))
		output += "<HR><B>Your individual objectives:</B><UL>"
		var/obj_count = 1
		var/la_explanation
		for(var/datum/individual_objective/objective in individual_objectives)
			output += "<br><b>#69obj_count69 69objective.name6969objective.limited_antag ? " 69objective.show_la69" : ""69</B>: 69objective.get_description()69</b>"
			obj_count++
			if(objective.limited_antag)
				la_explanation = objective.la_explanation
		output += "</UL>"
		if(la_explanation)
			output += la_explanation
	return output

/datum/mind/proc/show_memory(mob/recipient)
	var/output = "<B>69current.real_name69's69emory</B><HR>"
	output +=69emory

	for(var/datum/antagonist/A in antagonist)
		if(!A.objectives.len)
			break
		if(A.faction)
			output += "<br><b>Your 69A.faction.name69 faction objectives:</b>"
		else
			output += "<br><b>Your 69A.role_text69 objectives:</b>"
		output += "69A.print_objectives(FALSE)69"
	output += print_individualobjectives()
	recipient << browse(output, "window=memory")

/datum/mind/proc/edit_memory()
	if(SSticker.current_state != GAME_STATE_PLAYING)
		alert("Not before round-start!", "Alert")
		return

	var/out = "<B>69name69</B>69(current&&(current.real_name!=name))?" (as 69current.real_name69)":""69<br>"
	out += "Mind currently owned by key: 69key69 69active?"(synced)":"(not synced)"69<br>"
	out += "Assigned role: 69assigned_role69. <a href='?src=\ref69src69;role_edit=1'>Edit</a><br>"
	out += "<hr>"
	out += "Special roles:<br><table>"

	out += "<b>Make_antagonist: </b><br>"
	for(var/A in GLOB.all_antag_selectable_types)
		var/datum/antagonist/antag = GLOB.all_antag_selectable_types69A69
		var/antag_name = (antag.bantype in GLOB.all_antag_selectable_types) ? antag.bantype : "<font color='red'>69antag.bantype69</font>"
		out += "<a href='?src=\ref69src69;add_antagonist=69antag.bantype69'>69antag_name69</a><br>"
	out += "<br>"

	for(var/datum/antagonist/antag in antagonist)
		out += "<br><b>69antag.role_text69</b> <a href='?src=\ref69antag69'>\69EDIT\69</a> <a href='?src=\ref69antag69;remove_antagonist=1'>\69DEL\69</a>"
	out += "</table><hr>"
	out += "<br>69memory69"

	out += print_individualobjectives()

	out += "<br><a href='?src=\ref69src69;edit_memory=1'>"
	usr << browse(out, "window=edit_memory69src69")

/datum/mind/Topic(href, href_list)
	if(!check_rights(R_ADMIN))
		return

	if(href_list69"add_antagonist"69)
		var/datum/antagonist/antag = GLOB.all_antag_types69href_list69"add_antagonist"6969
		if(antag)
			var/ok = FALSE
			if(antag.outer && active)
				var/answer = alert("69antag.role_text69 is an outer antagonist. 69name69 will be taken from the current69ob and spawned as antagonist. Continue?","Confirmation", "No","Yes")
				ok = (answer == "Yes")
			else
				var/answer = alert("Are you sure you want to69ake 69name69 the 69antag.role_text69","Confirmation","No","Yes")
				ok = (answer == "Yes")

			if(!ok)
				return

			if(antag.outer)
				//Outer antags are created from ghosts, we69ust69ake a ghost first
				var/mob/observer/ghost/ghost = current.ghostize(FALSE)
				antag.create_from_ghost(ghost, announce = FALSE)
				qdel(current) //Delete our old body
				antag.greet()

			else
				if(antag.create_antagonist(src))
					log_admin("69key_name_admin(usr)6969ade 69key_name(src)69 into a 69antag.role_text69.")
				else
					to_chat(usr, SPAN_WARNING("69src69 could not be69ade into a 69antag.role_text69!"))

	else if(href_list69"role_edit"69)
		var/new_role = input("Select new role", "Assigned role", assigned_role) as null|anything in GLOB.joblist
		if (!new_role) return
		var/datum/job/job = SSjob.GetJob(new_role)
		if(job)
			assigned_role = job.title
			role_alt_title = new_role

	else if(href_list69"memory_edit"69)
		var/new_memo = sanitize(input("Write new69emory", "Memory",69emory) as null|message)
		if (isnull(new_memo)) return
		memory = new_memo

	else if(href_list69"silicon"69)
		BITSET(current.hud_updateflag, SPECIALROLE_HUD)
		switch(href_list69"silicon"69)

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
					log_admin("69key_name_admin(usr)69 has unemag'ed 69R69.")

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
					log_admin("69key_name_admin(usr)69 has unemag'ed 69ai69's Cyborgs.")

	else if(href_list69"common"69)
		switch(href_list69"common"69)
			if("undress")
				for(var/obj/item/W in current)
					current.drop_from_inventory(W)
			if("takeuplink")
				take_uplink()
				memory = null//Remove any69emory they69ay have had.
			if("crystals")
				if (usr.client.holder.rights & R_FUN)
					var/obj/item/device/uplink/hidden/suplink = find_syndicate_uplink()
					var/crystals
					if (suplink)
						crystals = suplink.uses
					crystals = input("Amount of telecrystals for 69key69", "Operative uplink", crystals) as null|num
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


// check whether this69ind's69ob has been brigged for the given duration
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
	return role &&69ind && player_is_antag_id(mind, role)

//Initialisation procs
/mob/living/proc/mind_initialize()
	if(mind)
		mind.key = key
	else
		mind = new /datum/mind(key)
		mind.original = src
		SSticker.minds +=69ind
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
	if (inactive_time >= 6069INUTES)
		return null //The server hasn't seen us alive in an hour.
		//We will not show on the69anifest at all

	//Ok we're definitely going to show on the69anifest, lets see if any status is set for us in the records
	var/status = CR.get_status()
	.=status //We'll return the status as a fallback

	//If the records have a specific status set, we'll return that
	//Active is the default state, it69eans nothing else has specifically been set.
	if (status != "Active")
		return


	//Ok the records say active, that69eans nothing.
	//In that case we'll show as inactive if the69ob has been inactive longer than 1569inutes
	if (inactive_time >= 1569INUTES)
		return "Inactive"
