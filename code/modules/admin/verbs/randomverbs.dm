/client/proc/cmd_admin_drop_everything(mob/M as69ob in SSmobs.mob_list)
	set category = null
	set name = "Drop Everything"
	if(!holder)
		to_chat(src, "Only administrators69ay use this command.")
		return

	var/confirm = alert(src, "Make 69M69 drop everything?", "Message", "Yes", "No")
	if(confirm != "Yes")
		return

	for(var/obj/item/W in69)
		if(W.is_equipped())
			M.drop_from_inventory(W)

	log_admin("69key_name(usr)6969ade 69key_name(M)69 drop everything!")
	message_admins("69key_name_admin(usr)6969ade 69key_name_admin(M)69 drop everything!", 1)

ADMIN_VERB_ADD(/client/proc/cmd_admin_subtle_message, R_ADMIN, FALSE)
//send an69essage to somebody as a 'voice in their head'
/client/proc/cmd_admin_subtle_message(mob/M as69ob in SSmobs.mob_list)
	set category = "Special69erbs"
	set name = "Subtle69essage"

	if(!ismob(M))	return
	if (!holder)
		to_chat(src, "Only administrators69ay use this command.")
		return

	var/msg = sanitize(input("Message:", text("Subtle PM to 69M.key69")) as text)

	if (!msg)
		return
	if(usr)
		if (usr.client)
			if(usr.client.holder)
				to_chat(M, "\bold You hear a69oice in your head... \italic 69msg69")

	log_admin("SubtlePM: 69key_name(usr)69 -> 69key_name(M)69 : 69msg69")
	message_admins("\blue \bold SubtleMessage: 69key_name_admin(usr)69 -> 69key_name_admin(M)69 : 69msg69", 1)


ADMIN_VERB_ADD(/client/proc/cmd_admin_world_narrate, R_ADMIN, FALSE)
//sends text to all players with no padding
/client/proc/cmd_admin_world_narrate() // Allows administrators to fluff events a little easier -- TLE
	set category = "Special69erbs"
	set name = "Global Narrate"

	if (!holder)
		to_chat(src, "Only administrators69ay use this command.")
		return

	var/msg = sanitize(input("Message:", text("Enter the text you wish to appear to everyone:")) as text)

	if (!msg)
		return
	to_chat(world, "69msg69")
	log_admin("GlobalNarrate: 69key_name(usr)69 : 69msg69")
	message_admins("\blue \bold GlobalNarrate: 69key_name_admin(usr)69 : 69msg69<BR>", 1)


ADMIN_VERB_ADD(/client/proc/cmd_admin_direct_narrate, R_ADMIN, FALSE)
//send text directly to a player with no padding. Useful for narratives and fluff-text
/client/proc/cmd_admin_direct_narrate(var/mob/M)	// Targetted narrate -- TLE
	set category = "Special69erbs"
	set name = "Direct Narrate"

	if(!holder)
		to_chat(src, "Only administrators69ay use this command.")
		return

	if(!M)
		M = input("Direct narrate to who?", "Active Players") as null|anything in get_mob_with_client_list()

	if(!M)
		return

	var/msg = sanitize(input("Message:", text("Enter the text you wish to appear to your target:")) as text)

	if( !msg )
		return

	to_chat(M,69sg)
	log_admin("DirectNarrate: 69key_name(usr)69 to (69M.name69/69M.key69): 69msg69")
	message_admins("\blue \bold DirectNarrate: 69key_name(usr)69 to (69M.name69/69M.key69): 69msg69<BR>", 1)


/client/proc/cmd_admin_godmode(mob/M as69ob in SSmobs.mob_list)
	set category = "Special69erbs"
	set name = "Godmode"
	if(!holder)
		to_chat(src, "Only administrators69ay use this command.")
		return
	M.status_flags ^= GODMODE
	to_chat(usr, "\blue Toggled 69(M.status_flags & GODMODE) ? "ON" : "OFF"69")

	log_admin("69key_name(usr)69 has toggled 69key_name(M)69's nodamage to 69(M.status_flags & GODMODE) ? "On" : "Off"69")
	message_admins("69key_name_admin(usr)69 has toggled 69key_name_admin(M)69's nodamage to 69(M.status_flags & GODMODE) ? "On" : "Off"69", 1)



proc/cmd_admin_mute(mob/M as69ob,69ute_type, automute = 0)
	if(automute)
		if(!config.automute_on)	return
	else
		if(!usr || !usr.client)
			return
		if(!usr.client.holder)
			to_chat(usr, "<font color='red'>Error: cmd_admin_mute: You don't have permission to do this.</font>")
			return
		if(!M.client)
			to_chat(usr, "<font color='red'>Error: cmd_admin_mute: This69ob doesn't have a client tied to it.</font>")
		if(M.client.holder)
			to_chat(usr, "<font color='red'>Error: cmd_admin_mute: You cannot69ute an admin/mod.</font>")
	if(!M.client)		return
	if(M.client.holder)	return

	var/muteunmute
	var/mute_string

	switch(mute_type)
		if(MUTE_IC)			mute_string = "IC (say and emote)"
		if(MUTE_OOC)		mute_string = "OOC"
		if(MUTE_PRAY)		mute_string = "pray"
		if(MUTE_ADMINHELP)	mute_string = "adminhelp, admin PM and ASAY"
		if(MUTE_DEADCHAT)	mute_string = "deadchat and DSAY"
		if(MUTE_ALL)		mute_string = "everything"
		else				return

	if(automute)
		muteunmute = "auto-muted"
		M.client.prefs.muted |=69ute_type
		log_admin("SPAM AUTOMUTE: 69muteunmute69 69key_name(M)69 from 69mute_string69")
		message_admins("SPAM AUTOMUTE: 69muteunmute69 69key_name_admin(M)69 from 69mute_string69.", 1)
		to_chat(M, "<span class='alert'>You have been 69muteunmute69 from 69mute_string69 by the SPAM AUTOMUTE system. Contact an admin.</span>")

		return

	if(M.client.prefs.muted &69ute_type)
		muteunmute = "unmuted"
		M.client.prefs.muted &= ~mute_type
	else
		muteunmute = "muted"
		M.client.prefs.muted |=69ute_type

	log_admin("69key_name(usr)69 has 69muteunmute69 69key_name(M)69 from 69mute_string69")
	message_admins("69key_name_admin(usr)69 has 69muteunmute69 69key_name_admin(M)69 from 69mute_string69.", 1)
	to_chat(M, "<span class = 'alert'>You have been 69muteunmute69 from 69mute_string69.</span>")


ADMIN_VERB_ADD(/client/proc/cmd_admin_add_random_ai_law, R_FUN, FALSE)
/client/proc/cmd_admin_add_random_ai_law()
	set category = "Fun"
	set name = "Add Random AI Law"
	if(!holder)
		to_chat(src, "Only administrators69ay use this command.")
		return
	var/confirm = alert(src, "You sure?", "Confirm", "Yes", "No")
	if(confirm != "Yes") return
	log_admin("69key_name(src)69 has added a random AI law.")
	message_admins("69key_name_admin(src)69 has added a random AI law.", 1)

	var/show_log = alert(src, "Show ion69essage?", "Message", "Yes", "No")
	if(show_log == "Yes")
		command_announcement.Announce("Ion storm detected near the ship. Please check all AI-controlled equipment for errors.", "Anomaly Alert", new_sound = 'sound/AI/ionstorm.ogg')

	IonStorm(0)


/*
Allow admins to set players to be able to respawn/bypass 3069in wait, without the admin having to edit69ariables directly
Ccomp's first proc.
*/

/client/proc/get_ghosts(var/notify = 0,var/what = 2)
	// what = 1, return ghosts ass list.
	// what = 2, return69ob list

	var/list/mobs = list()
	var/list/ghosts = list()
	var/list/sortmob = sortNames(SSmobs.mob_list)                           // get the69ob list.
	var/any=0
	for(var/mob/observer/ghost/M in sortmob)
		mobs.Add(M)                                             //filter it where it's only ghosts
		any = 1                                                 //if no ghosts show up, any will just be 0
	if(!any)
		if(notify)
			to_chat(src, "There doesn't appear to be any ghosts for you to select.")
		return

	for(var/mob/M in69obs)
		var/name =69.name
		ghosts69name69 =69                                        //get the name of the69ob for the popup list
	if(what==1)
		return ghosts
	else
		return69obs


ADMIN_VERB_ADD(/client/proc/allow_character_respawn, R_ADMIN, FALSE)
// Allows a ghost to respawn
/client/proc/allow_character_respawn()
	set category = "Special69erbs"
	set name = "Allow player to respawn"
	set desc = "Let's the player bypass the 3069inute wait to respawn or allow them to re-enter their corpse."
	if(!holder)
		to_chat(src, "Only administrators69ay use this command.")
	var/list/ghosts= get_ghosts(1,1)

	var/target = input("Please, select a ghost!", "COME BACK TO LIFE!", null, null) as null|anything in ghosts
	if(!target)
		to_chat(src, "Hrm, appears you didn't select a ghost"		) // Sanity check, if no ghosts in the list we don't want to edit a null69ariable and cause a runtime error.
		return

	var/mob/observer/ghost/G = ghosts69target69
	if(G.has_enabled_antagHUD && config.antag_hud_restricted)
		var/response = alert(src, "Are you sure you wish to allow this individual to play?","Ghost has used AntagHUD","Yes","No")
		if(response == "No") return
	G.timeofdeath=-19999						/* time of death is checked in /mob/verb/abandon_mob() which is the Respawn69erb.
									   timeofdeath is used for bodies on autopsy but since we're69essing with a ghost I'm pretty sure
									   there won't be an autopsy.
									*/

	var/datum/preferences/P

	if (G.client)
		P = G.client.prefs
	else if (G.ckey)
		P = SScharacter_setup.preferences_datums69G.ckey69
	else
		to_chat(src, "Something went wrong, couldn't find the target's preferences datum")
		return 0

	for (var/entry in P.time_of_death)//Set all the prefs' times of death to a huge negative69alue so any respawn timers will be fine
		P.time_of_death69entry69 = -99999


	G.has_enabled_antagHUD = 2
	G.can_reenter_corpse = 1
	G << 'sound/effects/magic/blind.ogg' //Play this sound to a player whenever their respawn time gets reduced
	G:show_message(text("\blue <B>You69ay now respawn.  You should roleplay as if you learned nothing about the round during your time with the dead.</B>"), 1)
	log_admin("69key_name(usr)69 allowed 69key_name(G)69 to bypass the 3069inute respawn limit")
	message_admins("Admin 69key_name_admin(usr)69 allowed 69key_name_admin(G)69 to bypass the 3069inute respawn limit", 1)


ADMIN_VERB_ADD(/client/proc/toggle_antagHUD_use, R_ADMIN, FALSE)
/client/proc/toggle_antagHUD_use()
	set category = "Server"
	set name = "Toggle antagHUD usage"
	set desc = "Toggles antagHUD usage for observers"

	if(!holder)
		to_chat(src, "Only administrators69ay use this command.")
	var/action=""
	if(config.antag_hud_allowed)
		for(var/mob/observer/ghost/g in get_ghosts())
			if(!g.client.holder)						//Remove the69erb from non-admin ghosts
				g.verbs -= /mob/observer/ghost/verb/toggle_antagHUD
			if(g.antagHUD)
				g.antagHUD = 0						// Disable it on those that have it enabled
				g.has_enabled_antagHUD = 2				// We'll allow them to respawn
				to_chat(g, "\red <B>The Administrator has disabled AntagHUD </B>")
		config.antag_hud_allowed = 0
		to_chat(src, "\red <B>AntagHUD usage has been disabled</B>")
		action = "disabled"
	else
		for(var/mob/observer/ghost/g in get_ghosts())
			if(!g.client.holder)						// Add the69erb back for all non-admin ghosts
				g.verbs += /mob/observer/ghost/verb/toggle_antagHUD
			to_chat(g, "\blue <B>The Administrator has enabled AntagHUD </B>"	) // Notify all observers they can now use AntagHUD
		config.antag_hud_allowed = 1
		action = "enabled"
		to_chat(src, "\blue <B>AntagHUD usage has been enabled</B>")


	log_admin("69key_name(usr)69 has 69action69 antagHUD usage for observers")
	message_admins("Admin 69key_name_admin(usr)69 has 69action69 antagHUD usage for observers", 1)


ADMIN_VERB_ADD(/client/proc/toggle_antagHUD_restrictions, R_ADMIN, FALSE)
/client/proc/toggle_antagHUD_restrictions()
	set category = "Server"
	set name = "Toggle antagHUD Restrictions"
	set desc = "Restricts players that have used antagHUD from being able to join this round."
	if(!holder)
		to_chat(src, "Only administrators69ay use this command.")
	var/action=""
	if(config.antag_hud_restricted)
		for(var/mob/observer/ghost/g in get_ghosts())
			to_chat(g, "\blue <B>The administrator has lifted restrictions on joining the round if you use AntagHUD</B>")
		action = "lifted restrictions"
		config.antag_hud_restricted = 0
		to_chat(src, "\blue <B>AntagHUD restrictions have been lifted</B>")
	else
		for(var/mob/observer/ghost/g in get_ghosts())
			to_chat(g, "\red <B>The administrator has placed restrictions on joining the round if you use AntagHUD</B>")
			to_chat(g, "\red <B>Your AntagHUD has been disabled, you69ay choose to re-enabled it but will be under restrictions </B>")
			g.antagHUD = 0
			g.has_enabled_antagHUD = 0
		action = "placed restrictions"
		config.antag_hud_restricted = 1
		to_chat(src, "\red <B>AntagHUD restrictions have been enabled</B>")

	log_admin("69key_name(usr)69 has 69action69 on joining the round if they use AntagHUD")
	message_admins("Admin 69key_name_admin(usr)69 has 69action69 on joining the round if they use AntagHUD", 1)

/*
If a guy was gibbed and you want to revive him, this is a good way to do so.
Works kind of like entering the game with a new character. Character receives a new69ind if they didn't have one.
Contractors and the like can also be revived with the previous role69ostly intact.
/N */
ADMIN_VERB_ADD(/client/proc/respawn_character, R_FUN, FALSE)
/client/proc/respawn_character()
	set category = "Special69erbs"
	set name = "Respawn Character"
	set desc = "Respawn a person that has been gibbed/dusted/killed. They69ust be a ghost for this to work and preferably should not have a body to go back into."
	if(!holder)
		to_chat(src, "Only administrators69ay use this command.")
		return
	var/input = ckey(input(src, "Please specify which key will be respawned.", "Key", ""))
	if(!input)
		return

	var/mob/observer/ghost/G_found
	for(var/mob/observer/ghost/G in GLOB.player_list)
		if(G.ckey == input)
			G_found = G
			break

	if(!G_found)//If a ghost was not found.
		to_chat(usr, "<font color='red'>There is no active key like that in the game or the person is not currently a ghost.</font>")
		return

	var/mob/living/carbon/human/new_character = new()//The69ob being spawned.

	var/datum/data/record/record_found			//Referenced to later to either randomize or not randomize the character.
	if(G_found.mind && !G_found.mind.active)	//mind isn't currently in use by someone/something
		/*Try and locate a record for the person being respawned through data_core.
		This isn't an exact science but it does the trick69ore often than not.*/
		var/id =69d5("69G_found.real_name6969G_found.mind.assigned_role69")
		for(var/datum/data/record/t in data_core.locked)
			if(t.fields69"id"69==id)
				record_found = t//We shall now reference the record.
				break

	if(record_found)//If they have a record we can determine a few things.
		new_character.real_name = record_found.fields69"name"69
		new_character.gender = record_found.fields69"sex"69
		new_character.age = record_found.fields69"age"69
		new_character.b_type = record_found.fields69"b_type"69
	else
		new_character.gender = pick(MALE,FEMALE)
		var/datum/preferences/A = new()
		A.randomize_appearance_and_body_for(new_character)
		new_character.real_name = G_found.real_name

	if(!new_character.real_name)
		if(new_character.gender ==69ALE)
			new_character.real_name = capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))
		else
			new_character.real_name = capitalize(pick(GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
	new_character.name = new_character.real_name

	if(G_found.mind && !G_found.mind.active)
		G_found.mind.transfer_to(new_character)	//be careful when doing stuff like this! I've already checked the69ind isn't in use
	else
		new_character.mind_initialize()
	if(!new_character.mind.assigned_role)	new_character.mind.assigned_role = ASSISTANT_TITLE//If they somehow got a null assigned role.

	//DNA
	if(record_found)//Pull up their name from database records if they did have a69ind.
		new_character.dna = new()//Let's first give them a new DNA.
		new_character.dna.unique_enzymes = record_found.fields69"b_dna"69//Enzymes are based on real name but we'll use the record for conformity.

		// I HATE BYOND.  HATE.  HATE. - N3X
		var/list/newSE= record_found.fields69"enzymes"69
		var/list/newUI = record_found.fields69"identity"69
		new_character.dna.SE = newSE.Copy() //This is the default of enzymes so I think it's safe to go with.
		new_character.dna.UpdateSE()
		new_character.UpdateAppearance(newUI.Copy())//Now we configure their appearance based on their unique identity, same as with a DNA69achine or somesuch.
	else//If they have no records, we just do a random DNA for them, based on their random appearance/savefile.
		new_character.dna.ready_dna(new_character)

	new_character.key = G_found.key

	/*
	The code below functions with the assumption that the69ob is already a contractor if they have a special role.
	So all it does is re-equip the69ob with powers and/or items. Or not, if they have no special role.
	If they don't have a69ind, they obviously don't have a special role.
	*/

	//Two69ariables to properly announce later on.
	var/admin = key_name_admin(src)
	var/player_key = G_found.key

	var/datum/spawnpoint/spawnpoint = SSjob.get_spawnpoint_for(new_character.client, new_character.mind.assigned_role)
	if (!spawnpoint.put_mob(new_character))
		message_admins("\blue 69admin69 has tried to respawn 69player_key69 as 69new_character.real_name69 but they declined to spawn in harmful environment.", 1)
		return

	//Now for special roles and equipment.
	SSjob.EquipRank(new_character, new_character.mind.assigned_role)

	//Announces the character on all the systems, based on the record.
	if(!issilicon(new_character))//If they are not a cyborg/AI.
		if(!record_found && !player_is_antag(new_character.mind, only_offstation_roles = 1)) //If there are no records for them. If they have a record, this info is already in there.69ODE people are not announced anyway.
			//Power to the user!
			if(alert(new_character,"Warning: No data core entry detected. Would you like to announce the arrival of this character by adding them to69arious databases, such as69edical records?",,"No","Yes")=="Yes")
				data_core.manifest_inject(new_character)

			if(alert(new_character,"Would you like an active AI to announce this character?",,"No","Yes")=="Yes")
				call(/proc/AnnounceArrival)(new_character, new_character.mind.assigned_role)

	message_admins("\blue 69admin69 has respawned 69player_key69 as 69new_character.real_name69.", 1)

	to_chat(new_character, "You have been fully respawned. Enjoy the game.")
	AnnounceArrival(new_character, new_character.mind.assigned_role, spawnpoint.message)	//will not broadcast if there is no69essage
	return new_character

ADMIN_VERB_ADD(/client/proc/cmd_admin_add_freeform_ai_law, R_FUN, FALSE)
/client/proc/cmd_admin_add_freeform_ai_law()
	set category = "Fun"
	set name = "Add Custom AI law"
	if(!holder)
		to_chat(src, "Only administrators69ay use this command.")
		return
	var/input = sanitize(input(usr, "Please enter anything you want the AI to do. Anything. Serious.", "What?", "") as text|null)
	if(!input)
		return
	for(var/mob/living/silicon/ai/M in SSmobs.mob_list)
		if (M.stat == 2)
			to_chat(usr, "Upload failed. No signal is being detected from the AI.")
		else if (M.see_in_dark == 0)
			to_chat(usr, "Upload failed. Only a faint signal is being detected from the AI, and it is not responding to our requests. It69ay be low on power.")
		else
			M.add_ion_law(input)
			for(var/mob/living/silicon/ai/O in SSmobs.mob_list)
				to_chat(O, "\red " + input + "\red...LAWS UPDATED")
				O.show_laws()

	log_admin("Admin 69key_name(usr)69 has added a new AI law - 69input69")
	message_admins("Admin 69key_name_admin(usr)69 has added a new AI law - 69input69", 1)

	var/show_log = alert(src, "Show ion69essage?", "Message", "Yes", "No")
	if(show_log == "Yes")
		command_announcement.Announce("Ion storm detected near the ship. Please check all AI-controlled equipment for errors.", "Anomaly Alert", new_sound = 'sound/AI/ionstorm.ogg')


ADMIN_VERB_ADD(/client/proc/cmd_admin_rejuvenate, R_ADMIN, FALSE)
/client/proc/cmd_admin_rejuvenate(mob/living/M as69ob in SSmobs.mob_list)
	set category = "Special69erbs"
	set name = "Rejuvenate"
	if(!holder)
		to_chat(src, "Only administrators69ay use this command.")
		return
	if(!mob)
		return
	if(!istype(M))
		alert("Cannot revive a ghost")
		return

	M.revive()

	log_admin("69key_name(usr)69 healed / revived 69key_name(M)69")
	message_admins("\red Admin 69key_name_admin(usr)69 healed / revived 69key_name_admin(M)69!", 1)


ADMIN_VERB_ADD(/client/proc/cmd_admin_create_centcom_report, R_ADMIN, FALSE)
/client/proc/cmd_admin_create_centcom_report()
	set category = "Special69erbs"
	set name = "Create Command Report"
	if(!holder)
		to_chat(src, "Only administrators69ay use this command.")
		return
	var/input = sanitize(input(usr, "Please enter anything you want. Anything. Serious.", "What?", "") as69essage|null, extra = 0)
	var/customname = sanitizeSafe(input(usr, "Pick a title for the report.", "Title") as text|null)
	if(!input)
		return
	if(!customname)
		customname = "69command_name()69 Update"

	//New69essage handling
	post_comm_message(customname, replacetext(input, "\n", "<br/>"))

	switch(alert("Should this be announced to the general population?",,"Yes","No"))
		if("Yes")
			command_announcement.Announce(input, customname, new_sound = 'sound/AI/commandreport.ogg',69sg_sanitized = 1);
		if("No")
			to_chat(world, "\red New 69company_name69 Update available at all communication consoles.")
			world << sound('sound/AI/commandreport.ogg')

	log_admin("69key_name(src)69 has created a command report: 69input69")
	message_admins("69key_name_admin(src)69 has created a command report", 1)


ADMIN_VERB_ADD(/client/proc/cmd_admin_delete, R_ADMIN|R_SERVER|R_DEBUG, FALSE)
//delete an instance/object/mob/etc
/client/proc/cmd_admin_delete(atom/O as obj|mob|turf in range(world.view))
	set category = "Admin"
	set name = "Delete"

	if (!holder)
		to_chat(src, "Only administrators69ay use this command.")
		return

	if (alert(src, "Are you sure you want to delete:\n69O69\nat (69O.x69, 69O.y69, 69O.z69)?", "Confirmation", "Yes", "No") == "Yes")
		log_admin("69key_name(usr)69 deleted 69O69 at (69O.x69,69O.y69,69O.z69)")
		message_admins("69key_name_admin(usr)69 deleted 69O69 at (69O.x69,69O.y69,69O.z69)", 1)

		qdel(O)

ADMIN_VERB_ADD(/client/proc/cmd_admin_list_open_jobs, R_DEBUG, FALSE)
/client/proc/cmd_admin_list_open_jobs()
	set category = "Admin"
	set name = "List free slots"

	if (!holder)
		to_chat(src, "Only administrators69ay use this command.")
		return
	for(var/datum/job/job in SSjob.occupations)
		to_chat(src, "69job.title69: 69job.total_positions69")


/client/proc/cmd_admin_explosion(atom/O as obj|mob|turf in range(world.view))
	set category = "Special69erbs"
	set name = "Explosion"

	if(!check_rights(R_DEBUG|R_FUN))	return

	var/devastation = input("Range of total devastation. -1 to none", text("Input"))  as num|null
	if(devastation == null) return
	var/heavy = input("Range of heavy impact. -1 to none", text("Input"))  as num|null
	if(heavy == null) return
	var/light = input("Range of light impact. -1 to none", text("Input"))  as num|null
	if(light == null) return
	var/flash = input("Range of flash. -1 to none", text("Input"))  as num|null
	if(flash == null) return

	if ((devastation != -1) || (heavy != -1) || (light != -1) || (flash != -1))
		if ((devastation > 20) || (heavy > 20) || (light > 20))
			if (alert(src, "Are you sure you want to do this? It will laaag.", "Confirmation", "Yes", "No") == "No")
				return

		explosion(O, devastation, heavy, light, flash)
		log_admin("69key_name(usr)69 created an explosion (69devastation69,69heavy69,69light69,69flash69) at (69O.x69,69O.y69,69O.z69)")
		message_admins("69key_name_admin(usr)69 created an explosion (69devastation69,69heavy69,69light69,69flash69) at (69O.x69,69O.y69,69O.z69)", 1)

		return
	else
		return

/client/proc/cmd_admin_emp(atom/O as obj|mob|turf in range(world.view))
	set category = "Special69erbs"
	set name = "EM Pulse"

	if(!check_rights(R_DEBUG|R_FUN))	return

	var/heavy = input("Range of heavy pulse.", text("Input"))  as num|null
	if(heavy == null) return
	var/light = input("Range of light pulse.", text("Input"))  as num|null
	if(light == null) return

	if (heavy || light)

		empulse(O, heavy, light)
		log_admin("69key_name(usr)69 created an EM Pulse (69heavy69,69light69) at (69O.x69,69O.y69,69O.z69)")
		message_admins("69key_name_admin(usr)69 created an EM PUlse (69heavy69,69light69) at (69O.x69,69O.y69,69O.z69)", 1)


		return
	else
		return

/client/proc/cmd_admin_gib(mob/M as69ob in SSmobs.mob_list)
	set category = "Special69erbs"
	set name = "Gib"

	if(!check_rights(R_ADMIN|R_FUN))	return

	var/confirm = alert(src, "You sure?", "Confirm", "Yes", "No")
	if(confirm != "Yes") return
	//Due to the delay here its easy for something to have happened to the69ob
	if(!M)	return

	log_admin("69key_name(usr)69 has gibbed 69key_name(M)69")
	message_admins("69key_name_admin(usr)69 has gibbed 69key_name_admin(M)69", 1)

	if(isobserver(M))
		gibs(M.loc)
		return

	M.gib()


ADMIN_VERB_ADD(/client/proc/cmd_admin_gib_self, R_FUN, FALSE)
/client/proc/cmd_admin_gib_self()
	set name = "Gibself"
	set category = "Fun"

	var/confirm = alert(src, "You sure?", "Confirm", "Yes", "No")
	if(confirm == "Yes")
		if (isobserver(mob)) // so they don't spam gibs everywhere
			return
		else
			mob.gib()

		log_admin("69key_name(usr)69 used gibself.")
		message_admins("\blue 69key_name_admin(usr)69 used gibself.", 1)

/*
/client/proc/cmd_manual_ban()
	set name = "Manual Ban"
	set category = "Special69erbs"
	if(!authenticated || !holder)
		to_chat(src, "Only administrators69ay use this command.")
		return
	var/mob/M = null
	switch(alert("How would you like to ban someone today?", "Manual Ban", "Key List", "Enter69anually", "Cancel"))
		if("Key List")
			var/list/keys = list()
			for(var/mob/M in world)
				keys +=69.client
			var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in keys
			if(!selection)
				return
			M = selection:mob
			if ((M.client &&69.client.holder && (M.client.holder.level >= holder.level)))
				alert("You cannot perform this action. You69ust be of a higher administrative rank!")
				return

	switch(alert("Temporary Ban?",,"Yes","No"))
	if("Yes")
		var/mins = input(usr,"How long (in69inutes)?","Ban time",1440) as num
		if(!mins)
			return
		if(mins >= 525600)69ins = 525599
		var/reason = input(usr,"Reason?","reason","Griefer") as text
		if(!reason)
			return
		if(M)
			AddBan(M.ckey,69.computer_id, reason, usr.ckey, 1,69ins)
			to_chat(M, "\red<BIG><B>You have been banned by 69usr.client.ckey69.\nReason: 69reason69.</B></BIG>")
			to_chat(M, "\red This is a temporary ban, it will be removed in 69mins6969inutes.")
			to_chat(M, "\red To try to resolve this69atter head to http://ss13.donglabs.com/forum/")
			log_admin("69usr.client.ckey69 has banned 69M.ckey69.\nReason: 69reason69\nThis will be removed in 69mins6969inutes.")
			message_admins("\blue69usr.client.ckey69 has banned 69M.ckey69.\nReason: 69reason69\nThis will be removed in 69mins6969inutes.")
			world.Export("http://216.38.134.132/adminlog.php?type=ban&key=69usr.client.key69&key2=69M.key69&msg=69html_decode(reason)69&time=69mins69&server=69replacetext(config.server_name, "#", "")69")
			del(M.client)
			qdel(M)
		else

	if("No")
		var/reason = input(usr,"Reason?","reason","Griefer") as text
		if(!reason)
			return
		AddBan(M.ckey,69.computer_id, reason, usr.ckey, 0, 0)
		to_chat(M, "\red<BIG><B>You have been banned by 69usr.client.ckey69.\nReason: 69reason69.</B></BIG>")
		to_chat(M, "\red This is a permanent ban.")
		to_chat(M, "\red To try to resolve this69atter head to http://ss13.donglabs.com/forum/")
		log_admin("69usr.client.ckey69 has banned 69M.ckey69.\nReason: 69reason69\nThis is a permanent ban.")
		message_admins("\blue69usr.client.ckey69 has banned 69M.ckey69.\nReason: 69reason69\nThis is a permanent ban.")
		world.Export("http://216.38.134.132/adminlog.php?type=ban&key=69usr.client.key69&key2=69M.key69&msg=69html_decode(reason)69&time=perma&server=69replacetext(config.server_name, "#", "")69")
		del(M.client)
		qdel(M)
*/

/client/proc/update_world()
	// If I see anyone granting powers to specific keys like the code that was here,
	// I will both remove their SVN access and permanently ban them from69y servers.
	return

ADMIN_VERB_ADD(/client/proc/cmd_admin_check_contents, R_ADMIN, FALSE)
//displays the contents of an instance
/client/proc/cmd_admin_check_contents(mob/living/M as69ob in SSmobs.mob_list)
	set category = "Special69erbs"
	set name = "Check Contents"

	var/list/L =69.get_contents()
	for(var/t in L)
		to_chat(usr, "69t69")


/* This proc is DEFERRED. Does not do anything.
/client/proc/cmd_admin_remove_plasma()
	set category = "Debug"
	set name = "Stabilize Atmos."
	if(!holder)
		to_chat(src, "Only administrators69ay use this command.")
		return

// DEFERRED
	spawn(0)
		for(var/turf/T in69iew())
			T.poison = 0
			T.oldpoison = 0
			T.tmppoison = 0
			T.oxygen = 755985
			T.oldoxy = 755985
			T.tmpoxy = 755985
			T.co2 = 14.8176
			T.oldco2 = 14.8176
			T.tmpco2 = 14.8176
			T.n2 = 2.844e+006
			T.on2 = 2.844e+006
			T.tn2 = 2.844e+006
			T.tsl_gas = 0
			T.osl_gas = 0
			T.sl_gas = 0
			T.temp = 293.15
			T.otemp = 293.15
			T.ttemp = 293.15
*/

ADMIN_VERB_ADD(/client/proc/toggle_view_range, R_ADMIN, FALSE)
//changes how far we can see
/client/proc/toggle_view_range()
	set category = "Special69erbs"
	set name = "Change69iew Range"
	set desc = "switches between 1x and custom69iews"

	if(view == world.view)
		view = input("Select69iew range:", "FUCK YE", 7) in list(1,2,3,4,5,6,7,8,9,10,11,12,13,14,128)
	else
		view = world.view
	if(mob)
		mob.parallax.update()
	log_admin("69key_name(usr)69 changed their69iew range to 69view69.")
	//message_admins("\blue 69key_name_admin(usr)69 changed their69iew range to 69view69.", 1)	//why? removed by order of XSI



ADMIN_VERB_ADD(/client/proc/admin_call_shuttle, R_ADMIN, FALSE)
//allows us to call the emergency shuttle
/client/proc/admin_call_shuttle()

	set category = "Admin"
	set name = "Call Evacuation"

	if(!evacuation_controller)
		return

	if(!check_rights(R_ADMIN))	return

	if(alert(src, "Are you sure?", "Confirm", "Yes", "No") != "Yes") return


	var/choice = input("Is this an emergency evacuation or a crew transfer?") in list("Emergency", "Crew Transfer")
	evacuation_controller.call_evacuation(usr, (choice == "Emergency"))

	log_admin("69key_name(usr)69 admin-called the emergency shuttle.")
	message_admins("\blue 69key_name_admin(usr)69 admin-called the emergency shuttle.", 1)
	return

ADMIN_VERB_ADD(/client/proc/admin_cancel_shuttle, R_ADMIN, FALSE)
//allows us to cancel the emergency shuttle, sending it back to centcom
/client/proc/admin_cancel_shuttle()
	set category = "Admin"
	set name = "Cancel Evacuation"

	if(!check_rights(R_ADMIN))	return

	if(alert(src, "You sure?", "Confirm", "Yes", "No") != "Yes") return

	if(!evacuation_controller)
		return

	evacuation_controller.cancel_evacuation()

	log_admin("69key_name(usr)69 admin-recalled the emergency shuttle.")
	message_admins("\blue 69key_name_admin(usr)69 admin-recalled the emergency shuttle.", 1)

	return

/client/proc/admin_deny_shuttle()
	set category = "Admin"
	set name = "Toggle Deny Evac"

	if (!evacuation_controller)
		return

	if(!check_rights(R_ADMIN))	return

	evacuation_controller.deny = !evacuation_controller.deny

	log_admin("69key_name(src)69 has 69evacuation_controller.deny ? "denied" : "allowed"69 the shuttle to be called.")
	message_admins("69key_name_admin(usr)69 has 69evacuation_controller.deny ? "denied" : "allowed"69 the shuttle to be called.")

/client/proc/cmd_admin_attack_log(mob/M as69ob in SSmobs.mob_list)
	set category = "Special69erbs"
	set name = "Attack Log"

	to_chat(usr, text("\red <b>Attack Log for 6969</b>",69ob))
	for(var/t in69.attack_log)
		to_chat(usr, t)


ADMIN_VERB_ADD(/client/proc/everyone_random, R_FUN, FALSE)
/client/proc/everyone_random()
	set category = "Fun"
	set name = "Make Everyone Random"
	set desc = "Make everyone have a random appearance. You can only use this before rounds!"

	if(!check_rights(R_FUN))	return

	if (SSticker.current_state != GAME_STATE_PREGAME)
		to_chat(usr, "Nope you can't do this, the game's already started. This only works before rounds!")
		return

	if(SSticker.random_players)
		SSticker.random_players = 0
		message_admins("Admin 69key_name_admin(usr)69 has disabled \"Everyone is Special\"69ode.", 1)
		to_chat(usr, "Disabled.")
		return


	var/notifyplayers = alert(src, "Do you want to notify the players?", "Options", "Yes", "No", "Cancel")
	if(notifyplayers == "Cancel")
		return

	log_admin("Admin 69key_name(src)69 has forced the players to have random appearances.")
	message_admins("Admin 69key_name_admin(usr)69 has forced the players to have random appearances.", 1)

	if(notifyplayers == "Yes")
		to_chat(world, "\blue <b>Admin 69usr.key69 has forced the players to have completely random identities!</b>")

	to_chat(usr, "<i>Remember: you can always disable the randomness by using the69erb again, assuming the round hasn't started yet</i>.")

	SSticker.random_players = 1


ADMIN_VERB_ADD(/client/proc/toggle_random_events, R_SERVER, FALSE)
/client/proc/toggle_random_events()
	set category = "Server"
	set name = "Toggle random events on/off"

	set desc = "Toggles random events such as69eteors, black holes, blob (but not space dust) on/off"
	if(!check_rights(R_SERVER))	return

	if(!config.allow_random_events)
		config.allow_random_events = 1
		to_chat(usr, "Random events enabled")
		message_admins("Admin 69key_name_admin(usr)69 has enabled random events.", 1)
	else
		config.allow_random_events = 0
		to_chat(usr, "Random events disabled")
		message_admins("Admin 69key_name_admin(usr)69 has disabled random events.", 1)
