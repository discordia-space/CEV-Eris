/proc/cmd_registrate_verb(var/verb_path, var/rights, var/not_hideable)
	if(!not_hideable)
		admin_verbs["hideable"] += verb_path
	if(!rights)
		admin_verbs["default"] += verb_path
	else
		var/right = 1
		while(right <= R_MAXPERMISSION)
			if(rights | right++)
				var/text_rigth = num2text(right)
				if(!islist(admin_verbs[text_rigth]))
					admin_verbs[text_rigth] = list()
				admin_verbs[text_rigth] += verb_path

/hook/startup/proc/registrate_verbs()
	world.registrate_verbs()
	return TRUE

/world/proc/registrate_verbs()


var/list/admin_verbs = list("default" = list(), "hideable" = list())

/client/proc/add_admin_verbs()
	if(holder)
		verbs += admin_verbs["default"]
		for(var/text_right in admin_verbs)
			if(text2num(text_right) & holder.rights)
				verbs += admin_verbs[text_right]

		if(check_rights(config.profiler_permission))
			control_freak = 0 // enable profiler

/client/proc/remove_admin_verbs()
	for(var/right in admin_verbs)
		verbs.Remove(admin_verbs[right])
	control_freak = initial(control_freak)

ADMIN_VERB_ADD(/client/proc/hide_most_verbs, null, FALSE)
//hides all our hideable adminverbs
//Allows you to keep some functionality while hiding some verbs
/client/proc/hide_most_verbs()
	set name = "Adminverbs - Hide Most"
	set category = "Admin"

	verbs.Remove(/client/proc/hide_most_verbs, admin_verbs["hideable"])
	verbs += /client/proc/show_verbs

	to_chat(src, "<span class='interface'>Most of your adminverbs have been hidden.</span>")


ADMIN_VERB_ADD(/client/proc/hide_verbs, null, TRUE)
//hides all our adminverbs
/client/proc/hide_verbs()
	set name = "Adminverbs - Hide All"
	set category = "Admin"

	remove_admin_verbs()
	verbs += /client/proc/show_verbs

	to_chat(src, "<span class='interface'>Almost all of your adminverbs have been hidden.</span>")

	return

/client/proc/show_verbs()
	set name = "Adminverbs - Show"
	set category = "Admin"

	verbs -= /client/proc/show_verbs
	add_admin_verbs()

	to_chat(src, "<span class='interface'>All of your adminverbs are now visible.</span>")




ADMIN_VERB_ADD(/client/proc/admin_ghost, R_ADMIN|R_MOD, TRUE)
//allows us to ghost/reenter body at will
/client/proc/admin_ghost()
	set category = "Admin"
	set name = "Aghost"
	if(!holder)	return
	if(isghost(mob))
		//re-enter
		var/mob/observer/ghost/ghost = mob
		if(!is_mentor(usr.client))
			ghost.can_reenter_corpse = 1
		if(ghost.can_reenter_corpse)
			ghost.reenter_corpse()
		else
			to_chat(ghost, "<font color='red'>Error:  Aghost:  Can't reenter corpse, mentors that use adminHUD while aghosting are not permitted to enter their corpse again</font>")
			return



	else if(isnewplayer(mob))
		to_chat(src, "<font color='red'>Error: Aghost: Can't admin-ghost whilst in the lobby. Join or Observe first.</font>")
	else
		//ghostize
		var/mob/body = mob
		var/mob/observer/ghost/ghost = body.ghostize(1)
		ghost.admin_ghosted = 1
		if(body)
			body.teleop = ghost
			if(!body.key)
				body.key = "@[key]"	//Haaaaaaaack. But the people have spoken. If it breaks; blame adminbus


ADMIN_VERB_ADD(/client/proc/invisimin, R_ADMIN, TRUE)
//allows our mob to go invisible/visible
/client/proc/invisimin()
	set name = "Invisimin"
	set category = "Admin"
	set desc = "Toggles ghost-like invisibility (Don't abuse this)"
	if(holder && mob)
		if(mob.invisibility == INVISIBILITY_OBSERVER)
			mob.invisibility = initial(mob.invisibility)
			to_chat(mob, "\red <b>Invisimin off. Invisibility reset.</b>")
			mob.alpha = max(mob.alpha + 100, 255)
		else
			mob.invisibility = INVISIBILITY_OBSERVER
			to_chat(mob, "\blue <b>Invisimin on. You are now as invisible as a ghost.</b>")
			mob.alpha = max(mob.alpha - 100, 0)


ADMIN_VERB_ADD(/client/proc/player_panel_new, R_ADMIN, TRUE)
//shows an interface for all players, with links to various panels
/client/proc/player_panel_new()
	set name = "Player Panel"
	set category = "Admin"
	if(holder)
		holder.player_panel_new()


ADMIN_VERB_ADD(/client/proc/storyteller_panel, R_ADMIN|R_MOD, TRUE)
/client/proc/storyteller_panel()
	set name = "Storyteller Panel"
	set category = "Admin"
	if(holder)
		holder.storyteller_panel()


ADMIN_VERB_ADD(/client/proc/unban_panel, R_ADMIN, TRUE)
/client/proc/unban_panel()
	set name = "Unban Panel"
	set category = "Admin"
	if(holder)
		if(config.ban_legacy_system)
			holder.unbanpanel()
		else
			holder.DB_ban_panel()


ADMIN_VERB_ADD(/client/proc/game_panel, R_ADMIN, FALSE)
//game panel, allows to change game-mode etc
/client/proc/game_panel()
	set name = "Game Panel"
	set category = "Admin"
	if(holder)
		holder.Game()


ADMIN_VERB_ADD(/client/proc/secrets, R_ADMIN, FALSE)
/client/proc/secrets()
	set name = "Secrets"
	set category = "Admin"
	if (holder)
		holder.Secrets()


ADMIN_VERB_ADD(/client/proc/colorooc, R_ADMIN, FALSE)
//allows us to set a custom colour for everythign we say in ooc
/client/proc/colorooc()
	set category = "Fun"
	set name = "OOC Text Color"
	if(!holder)	return
	var/response = alert(src, "Please choose a distinct color that is easy to read and doesn't mix with all the other chat and radio frequency colors.", "Change own OOC color", "Pick new color", "Reset to default", "Cancel")
	if(response == "Pick new color")
		prefs.ooccolor = input(src, "Please select your OOC colour.", "OOC colour") as color
	else if(response == "Reset to default")
		prefs.ooccolor = initial(prefs.ooccolor)
	prefs.save_preferences()


ADMIN_VERB_ADD(/client/proc/stealth, R_ADMIN, TRUE)
/client/proc/stealth()
	set category = "Admin"
	set name = "Stealth Mode"
	if(holder)
		if(holder.fakekey)
			holder.fakekey = null
		else
			var/new_key = ckeyEx(input("Enter your desired display name.", "Fake Key", key) as text|null)
			if(!new_key)	return
			if(length(new_key) >= 26)
				new_key = copytext(new_key, 1, 26)
			holder.fakekey = new_key
		log_admin("[key_name(usr)] has turned stealth mode [holder.fakekey ? "ON" : "OFF"]")
		message_admins("[key_name_admin(usr)] has turned stealth mode [holder.fakekey ? "ON" : "OFF"]", 1)


ADMIN_VERB_ADD(/client/proc/hivemind_panel, R_FUN, TRUE)
/client/proc/hivemind_panel()
	set category = "Fun"
	set name = "Hivemind Panel"
	if(holder && GLOB.hivemind_panel)
		var/datum/hivemind_panel/H = GLOB.hivemind_panel
		H.main_interact()


#define MAX_WARNS 3
#define AUTOBANTIME 10

/client/proc/warn(warned_ckey)
	if(!check_rights(R_ADMIN))	return

	if(!warned_ckey || !istext(warned_ckey))	return
	if(warned_ckey in admin_datums)
		to_chat(usr, "<font color='red'>Error: warn(): You can't warn admins.</font>")
		return

	var/datum/preferences/D
	var/client/C = directory[warned_ckey]
	if(C)	D = C.prefs
	else	D = SScharacter_setup.preferences_datums[warned_ckey]

	if(!D)
		to_chat(src, "<font color='red'>Error: warn(): No such ckey found.</font>")
		return

	if(++D.warns >= MAX_WARNS)					//uh ohhhh...you'reee iiiiin trouuuubble O:)
		ban_unban_log_save("[ckey] warned [warned_ckey], resulting in a [AUTOBANTIME] minute autoban.")
		if(C)
			message_admins("[key_name_admin(src)] has warned [key_name_admin(C)] resulting in a [AUTOBANTIME] minute ban.")
			to_chat(C, "<font color='red'><BIG><B>You have been autobanned due to a warning by [ckey].</B></BIG><br>This is a temporary ban, it will be removed in [AUTOBANTIME] minutes.</font>")
			del(C)
		else
			message_admins("[key_name_admin(src)] has warned [warned_ckey] resulting in a [AUTOBANTIME] minute ban.")
		AddBan(warned_ckey, D.last_id, "Autobanning due to too many formal warnings", ckey, 1, AUTOBANTIME)

	else
		var/warns_remain = MAX_WARNS - D.warns
		if(C)
			to_chat(C, "<font color='red'><BIG><B>You have been formally warned by an administrator.</B></BIG><br>Further warnings will result in an autoban.</font>")
			message_admins("[key_name_admin(src)] has warned [key_name_admin(C)]. They have [warns_remain] strikes remaining.")
		else
			message_admins("[key_name_admin(src)] has warned [warned_ckey] (DC). They have [warns_remain] strikes remaining.")



#undef MAX_WARNS
#undef AUTOBANTIME

ADMIN_VERB_ADD(/client/proc/drop_bomb, R_FUN, FALSE)
/client/proc/drop_bomb() // Some admin dickery that can probably be done better -- TLE
	set category = "Special Verbs"
	set name = "Drop Bomb"
	set desc = "Cause an explosion of varying strength at your location."

	var/turf/epicenter = mob.loc
	var/list/choices = list("Small Bomb", "Medium Bomb", "Big Bomb", "Custom Bomb")
	var/choice = input("What size explosion would you like to produce?") in choices
	switch(choice)
		if(null)
			return 0
		if("Small Bomb")
			explosion(epicenter, 300, 50)
		if("Medium Bomb")
			explosion(epicenter, 600, 50)
		if("Big Bomb")
			explosion(epicenter, 900, 50)
		if("Custom Bomb")
			var/explosion_power = input("Explosion Power:") as num
			var/explosion_falloff = input("Explosion falloff:") as num
			var/additive_falloff = input("Additive falloff for this explosion?") as num
			var/multiplicative_falloff = input("Multiplicative falloff for this explosion?") as num
			var/eflags = additive_falloff ? EFLAG_ADDITIVEFALLOFF : 0 | multiplicative_falloff ? EFLAG_EXPONENTIALFALLOFF : 0
			explosion(epicenter, explosion_power, explosion_falloff, eflags)
	message_admins("\blue [ckey] created an admin explosion at [epicenter.loc].")



ADMIN_VERB_ADD(/client/proc/make_sound, R_FUN, FALSE)
/client/proc/make_sound(var/obj/O in range(world.view)) // -- TLE
	set category = "Special Verbs"
	set name = "Make Sound"
	set desc = "Display a message to everyone who can hear the target"
	if(O)
		var/message = sanitize(input("What do you want the message to be?", "Make Sound") as text|null)
		if(!message)
			return
		for (var/mob/V in hearers(O))
			V.show_message(message, 2)
		log_admin("[key_name(usr)] made [O] at [O.x], [O.y], [O.z]. make a sound")
		message_admins("\blue [key_name_admin(usr)] made [O] at [O.x], [O.y], [O.z]. make a sound", 1)


ADMIN_VERB_ADD(/client/proc/togglebuildmodeself, R_ADMIN, FALSE)
/client/proc/togglebuildmodeself()
	set name = "Toggle Build Mode Self"
	set category = "Special Verbs"

	if(!check_rights(R_ADMIN))
		return

	if(src.mob)
		togglebuildmode(src.mob)


ADMIN_VERB_ADD(/client/proc/object_talk, R_FUN, FALSE)
/client/proc/object_talk(var/msg as text) // -- TLE
	set category = "Special Verbs"
	set name = "oSay"
	set desc = "Display a message to everyone who can hear the target"
	if(mob.control_object)
		if(!msg)
			return
		for (var/mob/V in hearers(mob.control_object))
			V.show_message("<b>[mob.control_object.name]</b> says: \"" + msg + "\"", 2)

ADMIN_VERB_ADD(/client/proc/enable_profiler, R_DEBUG, FALSE)
/client/proc/enable_profiler() // -- TLE
	set category = "Debug"
	set name = "Enable Profiler"
	set desc = "Access BYOND's proc performance profiler"

	if(!check_rights(R_DEBUG))
		return

	log_admin("[key_name(usr)] has enabled performance profiler. This may cause lag.")
	message_admins("[key_name_admin(usr)] has enabled performance profiler. This may cause lag.", 1)

	// Give profiler access
	world.SetConfig("APP/admin", ckey, "role=admin")
	to_chat(src, "Press <a href='?debug=profile'>here</a> to access profiler panel. It will replace verb panel, and you may have to wait a couple of seconds for it to display.")

ADMIN_VERB_ADD(/client/proc/kill_air, R_DEBUG, FALSE)
/client/proc/kill_air() // -- TLE
	set category = "Debug"
	set name = "Kill Air"
	set desc = "Toggle Air Processing"

	SSair.can_fire = !SSair.can_fire

	var/msg = "[SSair.can_fire ? "Enabled" : "Disabled"] SSair processing."
	log_admin("[key_name(usr)] used 'kill air'. [msg]")
	message_admins("\blue [key_name_admin(usr)] used 'kill air'. [msg]", 1)

/client/proc/readmin_self()
	set name = "Re-Admin self"
	set category = "Admin"

	if(deadmin_holder)
		deadmin_holder.reassociate()
		log_admin("[src] re-admined themself.")
		message_admins("[src] re-admined themself.", 1)
		to_chat(src, "<span class='interface'>You now have the keys to control the planet, or atleast a small space station</span>")
		verbs -= /client/proc/readmin_self


ADMIN_VERB_ADD(/client/proc/deadmin_self, null, TRUE)
//destroys our own admin datum so we can play as a regular player
/client/proc/deadmin_self()
	set name = "De-admin self"
	set category = "Admin"

	if(holder)
		if(alert("Confirm self-deadmin for the round? You can re-admin yourself at any time.",,"Yes","No") == "Yes")
			log_admin("[src] deadmined themself.")
			message_admins("[src] deadmined themself.", 1)
			deadmin()
			to_chat(src, "<span class='interface'>You are now a normal player.</span>")
			verbs |= /client/proc/readmin_self


ADMIN_VERB_ADD(/client/proc/toggle_log_hrefs, R_SERVER, FALSE)
/client/proc/toggle_log_hrefs()
	set name = "Toggle href logging"
	set category = "Server"
	if(!holder)	return
	if(config)
		if(config.log_hrefs)
			config.log_hrefs = 0
			to_chat(src, "<b>Stopped logging hrefs</b>")
		else
			config.log_hrefs = 1
			to_chat(src, "<b>Started logging hrefs</b>")

ADMIN_VERB_ADD(/client/proc/check_ai_laws, R_ADMIN, TRUE)
//shows AI and borg laws
/client/proc/check_ai_laws()
	set name = "Check AI Laws"
	set category = "Admin"
	if(holder)
		src.holder.output_ai_laws()

ADMIN_VERB_ADD(/client/proc/rename_silicon, R_ADMIN, FALSE)
//properly renames silicons
/client/proc/rename_silicon()
	set name = "Rename Silicon"
	set category = "Special Verbs"

	if(!check_rights(R_ADMIN)) return

	var/mob/living/silicon/S = input("Select silicon.", "Rename Silicon.") as null|anything in GLOB.silicon_mob_list
	if(!S) return

	var/new_name = sanitizeSafe(input(src, "Enter new name. Leave blank or as is to cancel.", "[S.real_name] - Enter new silicon name", S.real_name))
	if(new_name && new_name != S.real_name)
		log_and_message_admins("has renamed the silicon '[S.real_name]' to '[new_name]'")
		S.SetName(new_name)


ADMIN_VERB_ADD(/client/proc/manage_silicon_laws, R_ADMIN, TRUE)
// Allows viewing and editing silicon laws.
/client/proc/manage_silicon_laws()
	set name = "Manage Silicon Laws"
	set category = "Admin"

	if(!check_rights(R_ADMIN)) return

	var/mob/living/silicon/S = input("Select silicon.", "Manage Silicon Laws") as null|anything in GLOB.silicon_mob_list
	if(!S) return

	var/datum/nano_module/law_manager/L = new(S)
	L.nano_ui_interact(usr, state = GLOB.admin_state)
	log_and_message_admins("has opened [S]'s law manager.")


ADMIN_VERB_ADD(/client/proc/change_human_appearance_admin, R_ADMIN, FALSE)
// Allows an admin to change the basic appearance of human-based mobs
/client/proc/change_human_appearance_admin()
	set name = "Change Mob Appearance - Admin"
	set desc = "Allows you to change the mob appearance"
	set category = "Fun"

	if(!check_rights(R_FUN)) return

	var/mob/living/carbon/human/H = input("Select mob.", "Change Mob Appearance - Admin") as null|anything in GLOB.human_mob_list
	if(!H) return

	log_and_message_admins("is altering the appearance of [H].")
	H.change_appearance(APPEARANCE_ALL, usr, usr, check_species_whitelist = 0, state = GLOB.admin_state)


ADMIN_VERB_ADD(/client/proc/change_human_appearance_self, R_ADMIN, FALSE)
// Allows the human-based mob itself change its basic appearance
/client/proc/change_human_appearance_self()
	set name = "Change Mob Appearance - Self"
	set desc = "Allows the mob to change its appearance"
	set category = "Fun"

	if(!check_rights(R_FUN)) return

	var/mob/living/carbon/human/H = input("Select mob.", "Change Mob Appearance - Self") as null|anything in GLOB.human_mob_list
	if(!H) return

	if(!H.client)
		to_chat(usr, "Only mobs with clients can alter their own appearance.")
		return

	switch(alert("Do you wish for [H] to be allowed to select non-whitelisted races?","Alter Mob Appearance","Yes","No","Cancel"))
		if("Yes")
			log_and_message_admins("has allowed [H] to change \his appearance, including races that requires whitelisting")
			H.change_appearance(APPEARANCE_ALL, H.loc, check_species_whitelist = 0)
		if("No")
			log_and_message_admins("has allowed [H] to change \his appearance, excluding races that requires whitelisting.")
			H.change_appearance(APPEARANCE_ALL, H.loc, check_species_whitelist = 1)


ADMIN_VERB_ADD(/client/proc/change_security_level, R_ADMIN, FALSE)
/client/proc/change_security_level()
	set name = "Set security level"
	set desc = "Sets the ship security level"
	set category = "Admin"

	if(!check_rights(R_ADMIN))	return

	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.maps_data.security_state)
	var/decl/security_level/new_security_level = input(usr, "It's currently [security_state.current_security_level.name].", "Select Security Level")  as null|anything in (security_state.all_security_levels - security_state.current_security_level)
	if(!new_security_level)
		return

	if(alert("Switch from code [security_state.current_security_level.name] to [new_security_level.name]?","Change security level?","Yes","No") == "Yes")
		security_state.set_security_level(new_security_level, TRUE)
		log_admin("[key_name(usr)] changed the security level to code [new_security_level].")


//---- bs12 verbs ----
/*
/client/proc/mod_panel()
	set name = "Moderator Panel"
	set category = "Admin"
	if(holder)
		holder.mod_panel()
*/

ADMIN_VERB_ADD(/client/proc/free_slot, R_ADMIN, FALSE)
//frees slot for chosen job
/client/proc/free_slot()
	set name = "Free Job Slot"
	set category = "Admin"
	if(holder)
		var/list/jobs = list()
		for (var/datum/job/J in SSjob.occupations)
			if (J.current_positions >= J.total_positions && J.total_positions != -1)
				jobs += J.title
		if (!jobs.len)
			to_chat(usr, "There are no fully staffed jobs.")
			return
		var/job = input("Please select job slot to free", "Free job slot")  as null|anything in jobs
		if (job)
			SSjob.FreeRole(job)
			message_admins("A job slot for [job] has been opened by [key_name_admin(usr)]")
			return

ADMIN_VERB_ADD(/client/proc/toggledrones, R_ADMIN, FALSE)
/client/proc/toggledrones()
	set name = "Toggle maintenance drones"
	set category = "Server"
	if(!holder)	return
	if(config)
		if(config.allow_drone_spawn)
			config.allow_drone_spawn = 0
			to_chat(src, "<b>Disallowed maint drones.</b>")
			message_admins("Admin [key_name_admin(usr)] has disabled maint drones.", 1)
		else
			config.allow_drone_spawn = 1
			to_chat(src, "<b>Enabled maint drones.</b>")
			message_admins("Admin [key_name_admin(usr)] has enabled maint drones.", 1)


ADMIN_VERB_ADD(/client/proc/man_up, R_ADMIN, FALSE)
/client/proc/man_up(mob/T as mob in SSmobs.mob_list | SShumans.mob_list)
	set category = "Fun"
	set name = "Man Up"
	set desc = "Tells mob to man up and deal with it."

	to_chat(T, SPAN_NOTICE("<b><font size=3>Man up and deal with it.</font></b>"))
	to_chat(T, SPAN_NOTICE("Move on."))

	log_admin("[key_name(usr)] told [key_name(T)] to man up and deal with it.")
	message_admins("\blue [key_name_admin(usr)] told [key_name(T)] to man up and deal with it.", 1)

ADMIN_VERB_ADD(/client/proc/global_man_up, R_ADMIN, FALSE)
/client/proc/global_man_up()
	set category = "Fun"
	set name = "Man Up Global"
	set desc = "Tells everyone to man up and deal with it."

	for (var/mob/T as mob in SSmobs.mob_list | SShumans.mob_list)
		to_chat(T, "<br><center><span class='notice'><b><font size=4>Man up.<br> Deal with it.</font></b><br>Move on.</span></center><br>")
		T << 'sound/voice/ManUp1.ogg'

	log_admin("[key_name(usr)] told everyone to man up and deal with it.")
	message_admins("\blue [key_name_admin(usr)] told everyone to man up and deal with it.", 1)

ADMIN_VERB_ADD(/client/proc/skill_issue, R_ADMIN, FALSE)
/client/proc/skill_issue(mob/T as mob in SSmobs.mob_list | SShumans.mob_list)
	set category = "Fun"
	set name = "Skill Issue"
	set desc = "Tells mob that it is a skill issue and to git gud."

	to_chat(T, SPAN_NOTICE("<b><font size=3>Diagnosis: skill issue.</font></b>"))
	to_chat(T, SPAN_NOTICE("Git gud."))

	log_admin("[key_name(usr)] told [key_name(T)] that it is a skill issue and to git gud.")
	message_admins("\blue [key_name_admin(usr)] told [key_name(T)] that it is a skill issue and to git gud.", 1)

ADMIN_VERB_ADD(/client/proc/toggleUIDebugMode, R_DEBUG, FALSE)
/client/proc/toggleUIDebugMode()
	set category = "Debug"
	set name = "UI Debug Mode"
	set desc = "Toggle UI Debug Mode"

	if(UI)
		UI.toggleDebugMode()
	else
		log_debug("This mob has no UI.")

ADMIN_VERB_ADD(/client/proc/create_portals, R_ADMIN, FALSE)
/client/proc/create_portals()
	set category = "Fun"
	set name = "Create Portals"
	set desc = "Create bi-directional portals between two locations."

	var/x_1 = input(src, "X Coordinate", "First Portal Location") as null|num
	if(!x_1)
		return
	var/y_1 = input(src, "Y Coordinate", "First Portal Location") as null|num
	if(!y_1)
		return
	var/z_1 = input(src, "Z Coordinate", "First Portal Location") as null|num
	if(!z_1)
		return

	var/x_2 = input(src, "X Coordinate", "Second Portal Location") as null|num
	if(!x_2)
		return
	var/y_2 = input(src, "Y Coordinate", "Second Portal Location") as null|num
	if(!y_2)
		return
	var/z_2 = input(src, "Z Coordinate", "Second Portal Location") as null|num
	if(!z_2)
		return

	// Spawning perfect portals
	var/obj/effect/portal/perfect/portal_1 = new /obj/effect/portal/perfect(locate(x_1, y_1, z_1))  // First location
	var/obj/effect/portal/perfect/portal_2 = new /obj/effect/portal/perfect(locate(x_2, y_2, z_2))  // Second location
	portal_1.set_target(get_turf(portal_2))  // Link the two portals
	portal_2.set_target(get_turf(portal_1))

	log_admin("[key_name(usr)] created portals from ([x_1],[y_1],[z_1]) to ([x_2],[y_2],[z_2]).")
	message_admins("\blue [key_name_admin(usr)] created portals from ([x_1],[y_1],[z_1]) to ([x_2],[y_2],[z_2]).", 1)


ADMIN_VERB_ADD(/client/proc/manage_custom_kits, R_FUN, FALSE)
/client/proc/manage_custom_kits()
	set category = "Fun"
	set name = "Manage Custom Kits"

	var/const/header = "Custom kit management"
	var/groundhog_day = TRUE
	var/mob/user = ismob(usr) ? usr : src.mob
	var/iterations_count = 0

	while(groundhog_day && iterations_count < 100)
		iterations_count++
		var/action = alert(user, "Currently existing kits: [LAZYLEN(GLOB.custom_kits)]", "[header]", "Spawn", "Create or edit", "Cancel")
		switch(action)
			if("Spawn")
				var/kit_of_choice = input(user, "Choose a kit", "[header]") as null|anything in GLOB.custom_kits
				if(kit_of_choice)
					var/severity_of_adminbus = input(user, "How many?", "[header]") as null|num
					if(severity_of_adminbus)
						var/storage_path = GLOB.custom_kits[kit_of_choice][1]
						var/turf/location = get_turf(user)
						for(var/I in 1 to severity_of_adminbus)
							var/obj/item/storage/storage = new storage_path(location)
							for(var/i in 2 to LAZYLEN(GLOB.custom_kits[kit_of_choice]))
								var/item_path = GLOB.custom_kits[kit_of_choice][i]
								new item_path(storage)
						log_and_message_admins("[ckey] spawned custom kit at [admin_jump_link(location, src)]")
			if("Create or edit")
				var/do_what_exactly = alert(user, "What do?", "[header]", "Create", "Edit", "Cancel")
				switch(do_what_exactly)
					if("Create")
						var/perfectly_descriptive_name = input(user, "Give it a name", "[header]") as null|text
						if(perfectly_descriptive_name)
							if(isnum(perfectly_descriptive_name))
								perfectly_descriptive_name = num2text(perfectly_descriptive_name)
							var/path_of_choice
							switch(alert(user, "Kit would need a storage.", "[header]", "Enter path", "Pick path", "Cancel"))
								if("Enter path")
									path_of_choice = text2path(input(user, "It better be subtype of /obj/item/storage or other type of container.", "[header]") as null|text)
								if("Pick path")
									path_of_choice = input(user, "Pick a storage for the kit.", "[header]") as null|anything in typesof(/obj/item/storage)
							if(path_of_choice)
								GLOB.custom_kits += perfectly_descriptive_name
								GLOB.custom_kits[perfectly_descriptive_name] = list(1)
								GLOB.custom_kits[perfectly_descriptive_name][1] = path_of_choice
								to_chat(user, SPAN_DANGER("Kit \"[perfectly_descriptive_name]\" created, now edit it."))
							else
								to_chat(user, SPAN_DANGER("Invalid storage type."))
					if("Edit")
						var/kit_of_choice = input(user, "Choose a kit", "[header]") as null|anything in GLOB.custom_kits
						if(kit_of_choice)
							switch(alert(user, "What do?", "[header]", "Add or remove items", "Delete", "Cancel"))
								if("Add or remove items")
									var/dream_within_a_dream = TRUE
									while(dream_within_a_dream)
										switch(alert(user, "What do?", "[header]", "Add item", "Remove item", "Cancel"))
											if("Add item")
												var/dream_within_a_dream_within_a_dream = TRUE
												while(dream_within_a_dream_within_a_dream)
													switch(alert(user, "Add item to the kit.", "[header]", "Enter path", "Enough"))
														if("Enter path")
															var/new_path = input(user, "Enter an item path.", "[header]") as null|text
															if(new_path)
																GLOB.custom_kits[kit_of_choice] += new_path
														else
															dream_within_a_dream_within_a_dream = FALSE
											if("Remove item")
												var/dream_within_a_dream_within_a_dream = TRUE
												while(dream_within_a_dream_within_a_dream)
													var/list/list_of_stuff = GLOB.custom_kits[kit_of_choice] - GLOB.custom_kits[kit_of_choice][1]
													if(!LAZYLEN(list_of_stuff))
														to_chat(user, SPAN_DANGER("There is nothing left."))
														dream_within_a_dream_within_a_dream = FALSE
													else
														var/item_to_remove = input(user, "Pick a path to remove", "[header]") as null|anything in list_of_stuff
														if(item_to_remove)
															GLOB.custom_kits[kit_of_choice] -= item_to_remove
														else
															dream_within_a_dream_within_a_dream = FALSE
											else
												dream_within_a_dream = FALSE
								if("Delete")
									GLOB.custom_kits -= kit_of_choice
			else
				groundhog_day = FALSE
