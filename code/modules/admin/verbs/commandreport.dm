/// Preset central command names to chose from for centcom reports.
#define CUSTOM_PRESET "Custom Command Name"

// Command reports
#define DEFAULT_ALERT1 "default_alert1"
#define DEFAULT_ALERT2 "default_alert2"
#define DEFAULT_ALERT3 "default_alert3"
#define NO_SOUND ""
#define CUSTOM_ALERT_SOUND "custom_alert"
/// Verb to change the global command name.
/client/proc/cmd_change_command_name()
	set category = "Admin"
	set name = "Change Command Name"

	if(!check_rights(R_ADMIN))
		return

	var/input = input(usr, "Please input a new name for Central Command.", "What?", "") as text|null
	if(!input)
		return
	change_command_name(input)
	message_admins("[key_name_admin(src)] has changed Central Command's name to [input]")
	log_admin("[key_name(src)] has changed the Central Command name to: [input]")

/// Verb to open the create command report window and send command reports.
/client/proc/cmd_admin_create_centcom_report()
	set category = "Admin"
	set name = "Create Command Report"

	if(!check_rights(R_ADMIN))
		return

	// SSblackbox.record_feedback("tally", "admin_verb", 1, "Create Command Report") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	var/datum/command_report_menu/tgui = new(usr)
	tgui.ui_interact(usr)

/// Datum for holding the TGUI window for command reports.
/datum/command_report_menu
	/// The mob using the UI.
	var/mob/ui_user
	/// The name of central command that will accompany our report
	var/command_name = ""
	/// Whether we are using a custom name instead of a preset.
	var/custom_name
	/// The actual contents of the report we're going to send.
	var/command_report_content
	/// Whether or not the announcement should be for all mobs, or just those in GLOB.player_list
	var/announce_to_all_mobs = FALSE
	/// The sound that's going to accompany our message.
	var/played_sound = DEFAULT_ALERT1
	/// The colour of the announcement when sent
	var/announcement_color = "default"
	/// The subheader to include when sending the announcement. Keep blank to not include a subheader
	var/subheader = ""
	/// A static list of preset names that can be chosen.
	var/list/preset_names = list(CUSTOM_PRESET)
	var/append_update_name = TRUE
	var/sanitize_content = TRUE
	var/custom_played_sound

/datum/command_report_menu/New(mob/user)
	ui_user = user
	command_name = station_name()
	preset_names.Insert(1, system_name())
	preset_names.Insert(1, command_name())
	preset_names.Insert(1, station_name())

/datum/command_report_menu/ui_state(mob/user)
	return GLOB.admin_state

/datum/command_report_menu/ui_close()
	qdel(src)

/datum/command_report_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CommandReport")
		ui.open()

/datum/command_report_menu/ui_data(mob/user)
	var/list/data = list()
	data["command_name"] = command_name
	data["custom_name"] = custom_name
	data["command_report_content"] = command_report_content
	data["announce_to_all_mobs"] = announce_to_all_mobs
	data["played_sound"] = played_sound
	data["announcement_color"] = announcement_color
	data["subheader"] = subheader
	data["append_update_name"] = append_update_name
	data["sanitize_content"] = sanitize_content

	return data

/datum/command_report_menu/ui_static_data(mob/user)
	var/list/data = list()
	data["command_name_presets"] = preset_names
	data["announcer_sounds"] = list(DEFAULT_ALERT1, DEFAULT_ALERT2, DEFAULT_ALERT3, NO_SOUND, CUSTOM_ALERT_SOUND)
	data["announcement_colors"] = ANNOUNCEMENT_COLORS

	return data

/datum/command_report_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("update_command_name")
			if(params["updated_name"] == CUSTOM_PRESET)
				custom_name = TRUE
			else if (params["updated_name"] in preset_names)
				custom_name = FALSE

			command_name = params["updated_name"]
		if("set_report_sound")
			if (params["picked_sound"] == CUSTOM_ALERT_SOUND)
				var/soundInput = input(ui_user, "Please pick a sound file to play when you create the command report.", "Pick a Sound File") as null|sound
				if (isnull(soundInput))
					to_chat(ui_user, span_danger("No file was selected."))
					custom_played_sound = null
					played_sound = DEFAULT_ALERT1
				else
					custom_played_sound = soundInput
					played_sound = CUSTOM_ALERT_SOUND
			else
				played_sound = params["picked_sound"]
		if("toggle_mob_announce")
			announce_to_all_mobs = !announce_to_all_mobs
		if("update_announcement_color")
			var/colors = ANNOUNCEMENT_COLORS
			var/chosen_color = params["updated_announcement_color"]
			if(chosen_color in colors)
				announcement_color = chosen_color
		if("set_subheader")
			subheader = params["new_subheader"]
		if("submit_report")
			if(!command_name)
				to_chat(ui_user, span_danger("You can't send a report with no command name."))
				return
			if(!params["report"])
				to_chat(ui_user, span_danger("You can't send a report with no contents."))
				return
			command_report_content = params["report"]
			var/is_preview = params["preview"]
			send_announcement(is_preview)
		if("toggle_update_append")
			append_update_name = !append_update_name
		if("toggle_sanitization")
			sanitize_content = !sanitize_content
		if("preview_sound")
			preview_sound()

	return TRUE

/*
 * The actual proc that sends the priority announcement and reports
 *
 * Uses the variables set by the user on our datum as the arguments for the report.
 */
/datum/command_report_menu/proc/send_announcement(preview = FALSE)
	/// The sound we're going to play on report.
	var/report_sound = played_sound
	switch(played_sound)
		if (DEFAULT_ALERT1)
			report_sound = 'sound/misc/notice2.ogg'
		if (DEFAULT_ALERT2)
			report_sound = 'sound/misc/notice1.ogg'
		if (DEFAULT_ALERT3)
			report_sound = 'sound/misc/announce_dig.ogg'
		if (CUSTOM_ALERT_SOUND)
			if (!isnull(custom_played_sound))
				report_sound = custom_played_sound
			else
				to_chat(ui_user, span_danger("The custom sound you selected was not able to be played. Aborting..."))
				played_sound = DEFAULT_ALERT1
				return

	var/chosen_color = announcement_color
	if(chosen_color == "default")
		if(command_name == command_name())
			chosen_color = "orange"

	if (preview)
		to_chat(ui_user, "The following is a preview of what the command report will look like for other players.")
		priority_announce(command_report_content, subheader == ""? null : subheader, report_sound, has_important_message = TRUE, sender_override = command_name, color_override = chosen_color, append_update = append_update_name, encode_title = sanitize_content, encode_text = sanitize_content, players = list(ui_user))
		return

	var/players = (announce_to_all_mobs ? GLOB.mob_list : GLOB.player_list)
	priority_announce(command_report_content, subheader == ""? null : subheader, report_sound, has_important_message = TRUE, sender_override = command_name, color_override = chosen_color, append_update = append_update_name, encode_title = sanitize_content, encode_text = sanitize_content, players = players)

	if (!preview)
		log_admin("[key_name(ui_user)] has created a command report: \"[command_report_content]\", sent from \"[command_name]\" with the sound \"[played_sound]\".")
		message_admins("[key_name_admin(ui_user)] has created a command report, sent from \"[command_name]\" with the sound \"[played_sound]\"")

/datum/command_report_menu/proc/preview_sound()
	switch(played_sound)
		if (NO_SOUND)
			// no sound
		if (DEFAULT_ALERT1)
			SEND_SOUND(ui_user, sound('sound/misc/notice2.ogg', volume = 25))
		if (DEFAULT_ALERT2)
			SEND_SOUND(ui_user, sound('sound/misc/notice1.ogg', volume = 25))
		if (DEFAULT_ALERT3)
			SEND_SOUND(ui_user, sound('sound/misc/announce_dig.ogg', volume = 25))
		if(CUSTOM_ALERT_SOUND)
			if (isnull(custom_played_sound))
				to_chat(ui_user, span_danger("There's no custom alert loaded! Cannot preview."))
				return
			SEND_SOUND(ui_user, sound(custom_played_sound, volume = 25))
		else
			to_chat(ui_user, span_danger("No sound available for [played_sound]"))

#undef DEFAULT_ALERT1
#undef DEFAULT_ALERT2
#undef DEFAULT_ALERT3
#undef NO_SOUND
#undef CUSTOM_PRESET
#undef CUSTOM_ALERT_SOUND
