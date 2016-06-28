// This is the window/UI manager for Nano UI
// There should only ever be one (global) instance of nanomanger
/datum/nanomanager
	// a list of current open /nanoui UIs, grouped by src_object and ui_key
	var/open_uis[0]
	// a list of current open /nanoui UIs, not grouped, for use in processing
	var/list/processing_uis = list()
	// a list of asset filenames which are to be sent to the client on user logon
	var/list/asset_files = list()

 /**
  * Create a new nanomanager instance.
  * This proc generates a list of assets which are to be sent to each client on connect
  *
  * @return /nanomanager new nanomanager object
  */
/datum/nanomanager/New()
	asset_files = list(
		'nano/css/icons.css',
		'nano/css/layout_basic.css',
		'nano/css/layout_default.css',
		'nano/css/shared.css',
		'nano/images/c_charging.gif',
		'nano/images/c_discharging.gif',
		'nano/images/c_max.gif',
		'nano/images/nanomapBackground.png',
		'nano/images/nanomap_z1.png',
		'nano/images/uiBackground-Syndicate.png',
		'nano/images/uiBackground.png',
		'nano/images/uiBasicBackground.png',
		'nano/images/uiIcons16.png',
		'nano/images/uiIcons16Green.png',
		'nano/images/uiIcons16Red.png',
		'nano/images/uiIcons24.png',
		'nano/images/uiLinkPendingIcon.gif',
		'nano/images/uiMaskBackground.png',
		'nano/images/uiNoticeBackground.jpg',
		'nano/images/uiTitleFluff-Syndicate.png',
		'nano/images/uiTitleFluff.png',
		'nano/images/source/icon-eye.xcf',
		'nano/images/source/NTLogoRevised.fla',
		'nano/images/source/uiBackground-Syndicate.xcf',
		'nano/images/source/uiBackground.fla',
		'nano/images/source/uiBackground.xcf',
		'nano/images/source/uiBasicBackground.xcf',
		'nano/images/source/uiIcons16Green.xcf',
		'nano/images/source/uiIcons16Red.xcf',
		'nano/images/source/uiIcons24.xcf',
		'nano/images/source/uiNoticeBackground.xcf',
		'nano/images/source/uiTitleBackground.xcf',
		'nano/images/status_icons/alarm_green.gif',
		'nano/images/status_icons/alarm_red.gif',
		'nano/images/status_icons/batt_100.gif',
		'nano/images/status_icons/batt_20.gif',
		'nano/images/status_icons/batt_40.gif',
		'nano/images/status_icons/batt_5.gif',
		'nano/images/status_icons/batt_60.gif',
		'nano/images/status_icons/batt_80.gif',
		'nano/images/status_icons/charging.gif',
		'nano/images/status_icons/downloader_finished.gif',
		'nano/images/status_icons/downloader_running.gif',
		'nano/images/status_icons/ntnrc_idle.gif',
		'nano/images/status_icons/ntnrc_new.gif',
		'nano/images/status_icons/power_norm.gif',
		'nano/images/status_icons/power_warn.gif',
		'nano/images/status_icons/sig_high.gif',
		'nano/images/status_icons/sig_lan.gif',
		'nano/images/status_icons/sig_low.gif',
		'nano/images/status_icons/sig_none.gif',
		'nano/js/libraries.min.js',
		'nano/js/nano_base_callbacks.js',
		'nano/js/nano_base_helpers.js',
		'nano/js/nano_state.js',
		'nano/js/nano_state_default.js',
		'nano/js/nano_state_manager.js',
		'nano/js/nano_template.js',
		'nano/js/nano_utility.js',
		'nano/js/libraries/doT.js',
		'nano/js/libraries/jquery-ui.js',
		'nano/js/libraries/jquery.js',
		'nano/js/libraries/jquery.timers.js',
		'nano/templates/accounts_terminal.tmpl',
		'nano/templates/advanced_airlock_console.tmpl',
		'nano/templates/agent_id_card.tmpl',
		'nano/templates/aicard.tmpl',
		'nano/templates/air_alarm.tmpl',
		'nano/templates/alarm_monitor.tmpl',
		'nano/templates/apc.tmpl',
		'nano/templates/appearance_changer.tmpl',
		'nano/templates/atmos_alert.tmpl',
		'nano/templates/atmos_control.tmpl',
		'nano/templates/botany_editor.tmpl',
		'nano/templates/botany_isolator.tmpl',
		'nano/templates/canister.tmpl',
		'nano/templates/chem_disp.tmpl',
		'nano/templates/communication.tmpl',
		'nano/templates/computer_fabricator.tmpl',
		'nano/templates/crew_monitor.tmpl',
		'nano/templates/crew_monitor_map_content.tmpl',
		'nano/templates/crew_monitor_map_header.tmpl',
		'nano/templates/cryo.tmpl',
		'nano/templates/disease_splicer.tmpl',
		'nano/templates/dish_incubator.tmpl',
		'nano/templates/dnaforensics.tmpl',
		'nano/templates/dna_modifier.tmpl',
		'nano/templates/docking_airlock_console.tmpl',
		'nano/templates/door_access_console.tmpl',
		'nano/templates/door_control.tmpl',
		'nano/templates/engines_control.tmpl',
		'nano/templates/escape_pod_berth_console.tmpl',
		'nano/templates/escape_pod_console.tmpl',
		'nano/templates/escape_shuttle_control_console.tmpl',
		'nano/templates/file_manager.tmpl',
		'nano/templates/freezer.tmpl',
		'nano/templates/gas_pump.tmpl',
		'nano/templates/generator.tmpl',
		'nano/templates/geoscanner.tmpl',
		'nano/templates/hardsuit.tmpl',
		'nano/templates/helm.tmpl',
		'nano/templates/identification_computer.tmpl',
		'nano/templates/isolation_centrifuge.tmpl',
		'nano/templates/janitorcart.tmpl',
		'nano/templates/jukebox.tmpl',
		'nano/templates/laptop_configuration.tmpl',
		'nano/templates/laptop_mainscreen.tmpl',
		'nano/templates/law_manager.tmpl',
		'nano/templates/layout_basic.tmpl',
		'nano/templates/layout_default.tmpl',
		'nano/templates/mechfab.tmpl',
		'nano/templates/multi_docking_console.tmpl',
		'nano/templates/news_browser.tmpl',
		'nano/templates/ntnet_chat.tmpl',
		'nano/templates/ntnet_dos.tmpl',
		'nano/templates/ntnet_downloader.tmpl',
		'nano/templates/ntnet_monitor.tmpl',
		'nano/templates/ntnet_relay.tmpl',
		'nano/templates/ntnet_transfer.tmpl',
		'nano/templates/nuclear_bomb.tmpl',
		'nano/templates/omni_filter.tmpl',
		'nano/templates/omni_mixer.tmpl',
		'nano/templates/pacman.tmpl',
		'nano/templates/pai_atmosphere.tmpl',
		'nano/templates/pai_directives.tmpl',
		'nano/templates/pai_doorjack.tmpl',
		'nano/templates/pai_interface.tmpl',
		'nano/templates/pai_manifest.tmpl',
		'nano/templates/pai_medrecords.tmpl',
		'nano/templates/pai_messenger.tmpl',
		'nano/templates/pai_radio.tmpl',
		'nano/templates/pai_secrecords.tmpl',
		'nano/templates/pai_signaller.tmpl',
		'nano/templates/pathogenic_isolator.tmpl',
		'nano/templates/pda.tmpl',
		'nano/templates/portpump.tmpl',
		'nano/templates/portscrubber.tmpl',
		'nano/templates/power_monitor.tmpl',
		'nano/templates/pressure_regulator.tmpl',
		'nano/templates/radio_basic.tmpl',
		'nano/templates/rcon.tmpl',
		'nano/templates/request_console.tmpl',
		'nano/templates/revelation.tmpl',
		'nano/templates/robot_control.tmpl',
		'nano/templates/sec_camera.tmpl',
		'nano/templates/sec_camera_map_content.tmpl',
		'nano/templates/sec_camera_map_header.tmpl',
		'nano/templates/shuttle_control_console.tmpl',
		'nano/templates/shuttle_control_console_exploration.tmpl',
		'nano/templates/simple_airlock_console.tmpl',
		'nano/templates/simple_docking_console.tmpl',
		'nano/templates/simple_docking_console_pod.tmpl',
		'nano/templates/sleeper.tmpl',
		'nano/templates/smartfridge.tmpl',
		'nano/templates/smes.tmpl',
		'nano/templates/supermatter_crystal.tmpl',
		'nano/templates/tanks.tmpl',
		'nano/templates/telescience_console.tmpl',
		'nano/templates/TemplatesGuide.txt',
		'nano/templates/transfer_valve.tmpl',
		'nano/templates/turret_control.tmpl',
		'nano/templates/uplink.tmpl',
		'nano/templates/vending_machine.tmpl'
	)
	return

 /**
  * Get an open /nanoui ui for the current user, src_object and ui_key and try to update it with data
  *
  * @param user /mob The mob who opened/owns the ui
  * @param src_object /obj|/mob The obj or mob which the ui belongs to
  * @param ui_key string A string key used for the ui
  * @param ui /datum/nanoui An existing instance of the ui (can be null)
  * @param data list The data to be passed to the ui, if it exists
  * @param force_open boolean The ui is being forced to (re)open, so close ui if it exists (instead of updating)
  *
  * @return /nanoui Returns the found ui, for null if none exists
  */
/datum/nanomanager/proc/try_update_ui(var/mob/user, src_object, ui_key, var/datum/nanoui/ui, data, var/force_open = 0)
	if (isnull(ui)) // no ui has been passed, so we'll search for one
	{
		ui = get_open_ui(user, src_object, ui_key)
	}
	if (!isnull(ui))
		// The UI is already open
		if (!force_open)
			ui.push_data(data)
			return ui
		else
			ui.reinitialise(new_initial_data=data)
			return ui

	return null

 /**
  * Get an open /nanoui ui for the current user, src_object and ui_key
  *
  * @param user /mob The mob who opened/owns the ui
  * @param src_object /obj|/mob The obj or mob which the ui belongs to
  * @param ui_key string A string key used for the ui
  *
  * @return /nanoui Returns the found ui, or null if none exists
  */
/datum/nanomanager/proc/get_open_ui(var/mob/user, src_object, ui_key)
	var/src_object_key = "\ref[src_object]"
	if (isnull(open_uis[src_object_key]) || !istype(open_uis[src_object_key], /list))
		//testing("nanomanager/get_open_ui mob [user.name] [src_object:name] [ui_key] - there are no uis open")
		return null
	else if (isnull(open_uis[src_object_key][ui_key]) || !istype(open_uis[src_object_key][ui_key], /list))
		//testing("nanomanager/get_open_ui mob [user.name] [src_object:name] [ui_key] - there are no uis open for this object")
		return null

	for (var/datum/nanoui/ui in open_uis[src_object_key][ui_key])
		if (ui.user == user)
			return ui

	//testing("nanomanager/get_open_ui mob [user.name] [src_object:name] [ui_key] - ui not found")
	return null

 /**
  * Update all /nanoui uis attached to src_object
  *
  * @param src_object /obj|/mob The obj or mob which the uis are attached to
  *
  * @return int The number of uis updated
  */
/datum/nanomanager/proc/update_uis(src_object)
	var/src_object_key = "\ref[src_object]"
	if (isnull(open_uis[src_object_key]) || !istype(open_uis[src_object_key], /list))
		return 0

	var/update_count = 0
	for (var/ui_key in open_uis[src_object_key])
		for (var/datum/nanoui/ui in open_uis[src_object_key][ui_key])
			if(ui && ui.src_object && ui.user && ui.src_object.nano_host())
				ui.process(1)
				update_count++
	return update_count

 /**
  * Close all /nanoui uis attached to src_object
  *
  * @param src_object /obj|/mob The obj or mob which the uis are attached to
  *
  * @return int The number of uis close
  */
/datum/nanomanager/proc/close_uis(src_object)
	var/src_object_key = "\ref[src_object]"
	if (isnull(open_uis[src_object_key]) || !istype(open_uis[src_object_key], /list))
		return 0

	var/close_count = 0
	for (var/ui_key in open_uis[src_object_key])
		for (var/datum/nanoui/ui in open_uis[src_object_key][ui_key])
			if(ui && ui.src_object && ui.user && ui.src_object.nano_host())
				ui.close()
				close_count++
	return close_count

 /**
  * Update /nanoui uis belonging to user
  *
  * @param user /mob The mob who owns the uis
  * @param src_object /obj|/mob If src_object is provided, only update uis which are attached to src_object (optional)
  * @param ui_key string If ui_key is provided, only update uis with a matching ui_key (optional)
  *
  * @return int The number of uis updated
  */
/datum/nanomanager/proc/update_user_uis(var/mob/user, src_object = null, ui_key = null)
	if (isnull(user.open_uis) || !istype(user.open_uis, /list) || open_uis.len == 0)
		return 0 // has no open uis

	var/update_count = 0
	for (var/datum/nanoui/ui in user.open_uis)
		if ((isnull(src_object) || !isnull(src_object) && ui.src_object == src_object) && (isnull(ui_key) || !isnull(ui_key) && ui.ui_key == ui_key))
			ui.process(1)
			update_count++

	return update_count

 /**
  * Close /nanoui uis belonging to user
  *
  * @param user /mob The mob who owns the uis
  * @param src_object /obj|/mob If src_object is provided, only close uis which are attached to src_object (optional)
  * @param ui_key string If ui_key is provided, only close uis with a matching ui_key (optional)
  *
  * @return int The number of uis closed
  */
/datum/nanomanager/proc/close_user_uis(var/mob/user, src_object = null, ui_key = null)
	if (isnull(user.open_uis) || !istype(user.open_uis, /list) || open_uis.len == 0)
		//testing("nanomanager/close_user_uis mob [user.name] has no open uis")
		return 0 // has no open uis

	var/close_count = 0
	for (var/datum/nanoui/ui in user.open_uis)
		if ((isnull(src_object) || !isnull(src_object) && ui.src_object == src_object) && (isnull(ui_key) || !isnull(ui_key) && ui.ui_key == ui_key))
			ui.close()
			close_count++

	//testing("nanomanager/close_user_uis mob [user.name] closed [open_uis.len] of [close_count] uis")

	return close_count

 /**
  * Add a /nanoui ui to the list of open uis
  * This is called by the /nanoui open() proc
  *
  * @param ui /nanoui The ui to add
  *
  * @return nothing
  */
/datum/nanomanager/proc/ui_opened(var/datum/nanoui/ui)
	var/src_object_key = "\ref[ui.src_object]"
	if (isnull(open_uis[src_object_key]) || !istype(open_uis[src_object_key], /list))
		open_uis[src_object_key] = list(ui.ui_key = list())
	else if (isnull(open_uis[src_object_key][ui.ui_key]) || !istype(open_uis[src_object_key][ui.ui_key], /list))
		open_uis[src_object_key][ui.ui_key] = list();

	ui.user.open_uis |= ui
	var/list/uis = open_uis[src_object_key][ui.ui_key]
	uis |= ui
	processing_uis |= ui
	//testing("nanomanager/ui_opened mob [ui.user.name] [ui.src_object:name] [ui.ui_key] - user.open_uis [ui.user.open_uis.len] | uis [uis.len] | processing_uis [processing_uis.len]")

 /**
  * Remove a /nanoui ui from the list of open uis
  * This is called by the /nanoui close() proc
  *
  * @param ui /nanoui The ui to remove
  *
  * @return int 0 if no ui was removed, 1 if removed successfully
  */
/datum/nanomanager/proc/ui_closed(var/datum/nanoui/ui)
	var/src_object_key = "\ref[ui.src_object]"
	if (isnull(open_uis[src_object_key]) || !istype(open_uis[src_object_key], /list))
		return 0 // wasn't open
	else if (isnull(open_uis[src_object_key][ui.ui_key]) || !istype(open_uis[src_object_key][ui.ui_key], /list))
		return 0 // wasn't open

	processing_uis.Remove(ui)
	if(ui.user)	// Sanity check in case a user has been deleted (say a blown up borg watching the alarm interface)
		ui.user.open_uis.Remove(ui)
	var/list/uis = open_uis[src_object_key][ui.ui_key]
	uis.Remove(ui)

	//testing("nanomanager/ui_closed mob [ui.user.name] [ui.src_object:name] [ui.ui_key] - user.open_uis [ui.user.open_uis.len] | uis [uis.len] | processing_uis [processing_uis.len]")

	return 1

 /**
  * This is called on user logout
  * Closes/clears all uis attached to the user's /mob
  *
  * @param user /mob The user's mob
  *
  * @return nothing
  */

//
/datum/nanomanager/proc/user_logout(var/mob/user)
	//testing("nanomanager/user_logout user [user.name]")
	return close_user_uis(user)

 /**
  * This is called when a player transfers from one mob to another
  * Transfers all open UIs to the new mob
  *
  * @param oldMob /mob The user's old mob
  * @param newMob /mob The user's new mob
  *
  * @return nothing
  */
/datum/nanomanager/proc/user_transferred(var/mob/oldMob, var/mob/newMob)
	//testing("nanomanager/user_transferred from mob [oldMob.name] to mob [newMob.name]")
	if (!oldMob || isnull(oldMob.open_uis) || !istype(oldMob.open_uis, /list) || open_uis.len == 0)
		//testing("nanomanager/user_transferred mob [oldMob.name] has no open uis")
		return 0 // has no open uis

	if (isnull(newMob.open_uis) || !istype(newMob.open_uis, /list))
		newMob.open_uis = list()

	for (var/datum/nanoui/ui in oldMob.open_uis)
		ui.user = newMob
		newMob.open_uis.Add(ui)

	oldMob.open_uis.Cut()

	return 1 // success
