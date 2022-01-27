/**********************************************************
NANO UI FRAMEWORK

nanoui class (or whatever Byond calls classes)

nanoui is used to open and update69ano browser uis
**********************************************************/

/datum/nanoui
	// the user who opened this ui
	var/mob/user
	// the object this ui "belongs" to
	var/datum/src_object
	// the title of this ui
	var/title
	// the key of this ui, this is to allow69ultiple (different) uis for each src_object
	var/ui_key
	// window_id is used as the window69ame/identifier for browse and onclose
	var/window_id
	// the browser window width
	var/width = 0
	// the browser window height
	var/height = 0
	// whether to use extra logic when window closes
	var/on_close_logic = 1
	// an extra ref to use when the window is closed, usually69ull
	var/atom/ref =69ull
	// options for69odifying window behaviour
	var/window_options = "focus=0;can_close=1;can_minimize=1;can_maximize=0;can_resize=1;titlebar=1;" // window option is set using window_id
	// the list of stylesheets to apply to this ui
	var/list/stylesheets = list()
	// the list of javascript scripts to use for this ui
	var/list/scripts = list()
	// a list of templates which can be used with this ui
	var/templates69069
	// the layout key for this ui (this is used on the frontend, leave it as "default" unless you know what you're doing)
	var/layout_key = "default"
	// optional layout key for additional ui header content to include
	var/layout_header_key = "default_header"
	// this sets whether to re-render the ui layout with each update (default 0, turning on will break the69ap ui if it's in use)
	var/auto_update_layout = 0
	// this sets whether to re-render the ui content with each update (default 1)
	var/auto_update_content = 1
	// the default state to use for this ui (this is used on the frontend, leave it as "default" unless you know what you're doing)
	var/state_key = "default"
	// show the69ap ui, this is used by the default layout
	var/show_map = 0
	// the69ap z level to display
	var/map_z_level = 1
	// initial data, containing the full data structure,69ust be sent to the ui (the data structure cannot be extended later on)
	var/list/initial_data69069
	// set to 1 to update the ui automatically every69aster_controller tick
	var/is_auto_updating = 0
	// the current status/visibility of the ui
	var/status = STATUS_INTERACTIVE

	// Relationship between a69aster interface and its children. Used in update_status
	var/datum/nanoui/master_ui
	var/list/datum/nanoui/children = list()
	var/datum/topic_state/state =69ull

 /**
  * Create a69ew69anoui instance.
  *
  * @param69user /mob The69ob who has opened/owns this ui
  * @param69src_object /obj|/mob The obj or69ob which this ui belongs to
  * @param69ui_key string A string key to use for this ui. Allows for69ultiple unique uis on one src_oject
  * @param69template string The filename of the template file from /nano/templates (e.g. "my_template.tmpl")
  * @param69title string The title of this ui
  * @param69width int the width of the ui window
  * @param69height int the height of the ui window
  * @param69ref /atom A custom ref to use if "on_close_logic" is set to 1
  *
  * @return /nanoui69ew69anoui object
  */
/datum/nanoui/New(nuser,69src_object,69ui_key,69template_filename,69title = 0,69width = 0,69height = 0, atom/nref, datum/nanoui/master_ui, datum/topic_state/state = GLOB.default_state)
	user =69user
	src_object =69src_object
	ui_key =69ui_key
	window_id = "69ui_key69\ref69src_object69"

	src.master_ui =69aster_ui
	if(master_ui)
		master_ui.children += src
	src.state = state

	// add the passed template filename as the "main" template, this is required
	add_template("main",69template_filename)

	if (ntitle)
		title = sanitize(strip_improper(ntitle))
	if (nwidth)
		width =69width
	if (nheight)
		height =69height
	if (nref)
		ref =69ref

	add_common_assets()
	if(user.client)
		var/datum/asset/assets = get_asset_datum(/datum/asset/directories/nanoui)

		// Avoid opening the window if the resources are69ot loaded yet.
		if(!assets.check_sent(user.client))
			to_chat(user, "Resources are still loading. Please wait.")
			close()

//Do69ot qdel69anouis. Use close() instead.
/datum/nanoui/Destroy()
	user =69ull
	src_object =69ull
	state =69ull
	. = ..()

 /**
  * Use this proc to add assets which are common to (and required by) all69ano uis
  *
  * @return69othing
  */
/datum/nanoui/proc/add_common_assets()
	add_script("libraries.min.js") // A JS file comprising of jQuery, doT.js and jQuery Timer libraries (compressed together)
	add_script("nano_utility.js") // The69anoUtility JS, this is used to store utility functions.
	add_script("nano_template.js") // The69anoTemplate JS, this is used to render templates.
	add_script("nano_state_manager.js") // The69anoStateManager JS, it handles updates from the server and passes data to the current state
	add_script("nano_state.js") // The69anoState JS, this is the base state which all states69ust inherit from
	add_script("nano_state_default.js") // The69anoStateDefault JS, this is the "default" state (used by all UIs by default), which inherits from69anoState
	add_script("nano_base_callbacks.js") // The69anoBaseCallbacks JS, this is used to set up (before and after update) callbacks which are common to all UIs
	add_script("nano_base_helpers.js") // The69anoBaseHelpers JS, this is used to set up template helpers which are common to all UIs
	add_stylesheet("shared.css") // this CSS sheet is common to all UIs
	add_stylesheet("tgui.css") // this CSS sheet is common to all UIs
	add_stylesheet("icons.css") // this CSS sheet is common to all UIs

 /**
  * Set the current status (also known as69isibility) of this ui.
  *
  * @param state int The status to set, see the defines at the top of this file
  * @param push_update int (bool) Push an update to the ui to update it's status (an update is always sent if the status has changed to red (0))
  *
  * @return69othing
  */
/datum/nanoui/proc/set_status(state, push_update)
	if (state != status) // Only update if it is different
		if (status == STATUS_DISABLED)
			status = state
			if (push_update)
				update()
		else
			status = state
			if (push_update || status == 0)
				push_data(null, 1) // Update the UI, force the update in case the status is 0, data is69ull so that previous data is used

 /**
  * Update the status (visibility) of this ui based on the user's status
  *
  * @param push_update int (bool) Push an update to the ui to update it's status. This is set to 0/false if an update is going to be pushed anyway (to avoid unnessary updates)
  *
  * @return 1 if closed,69ull otherwise.
  */
/datum/nanoui/proc/update_status(var/push_update = 0)
	var/atom/host = src_object && src_object.nano_host(TRUE)
	if(!host)
		close()
		return 1
	var/new_status = host.CanUseTopic(user, state)
	if(master_ui)
		new_status =69in(new_status,69aster_ui.status)

	if(new_status == STATUS_CLOSE)
		close()
		return 1
	set_status(new_status, push_update)

 /**
  * Set the ui to auto update (every69aster_controller tick)
  *
  * @param state int (bool) Set auto update to 1 or 0 (true/false)
  *
  * @return69othing
  */
/datum/nanoui/proc/set_auto_update(nstate = 1)
	is_auto_updating =69state

 /**
  * Set the initial data for the ui. This is69ital as the data structure set here cannot be changed when pushing69ew updates.
  *
  * @param data /list The list of data for this ui
  *
  * @return69othing
  */
/datum/nanoui/proc/set_initial_data(list/data)
	initial_data = data

 /**
  * Get config data to sent to the ui.
  *
  * @return /list config data
  */
/datum/nanoui/proc/get_config_data()
	var/name = "69src_object69"
	name = sanitize(name)
	var/list/config_data = list(
			"title" = title,
			"srcObject" = list("name" =69ame),
			"stateKey" = state_key,
			"status" = status,
			"autoUpdateLayout" = auto_update_layout,
			"autoUpdateContent" = auto_update_content,
			"showMap" = show_map,
			"mapName" = GLOB.maps_data.path,
			"mapZLevel" =69ap_z_level,
			"mapZLevels" = GLOB.maps_data.station_levels,
			"user" = list("name" = user.name)
		)
	return config_data

 /**
  * Get data to sent to the ui.
  *
  * @param data /list The list of general data for this ui (can be69ull to use previous data sent)
  *
  * @return /list data to send to the ui
  */
/datum/nanoui/proc/get_send_data(var/list/data)
	var/list/config_data = get_config_data()

	var/list/send_data = list("config" = config_data)

	if (!isnull(data))
		var/list/types = parse_for_paths(data)

		var/list/potential_catalog_data = list()
		for(var/type in types)
			var/datum/catalog_entry/E = get_catalog_entry(type)
			if(E)
				potential_catalog_data.Add(list(list("entry_name" = E.title, "entry_img_path" = E.image_path, "entry_type" = E.thing_type)))

		send_data69"potential_catalog_data"69 = potential_catalog_data
		send_data69"data"69 = data


	return send_data

 /**
  * Set the browser window options for this ui
  *
  * @param69window_options string The69ew window options
  *
  * @return69othing
  */
/datum/nanoui/proc/set_window_options(nwindow_options)
	window_options =69window_options

 /**
  * Add a CSS stylesheet to this UI
  * These69ust be added before the UI has been opened, adding after that will have69o effect
  *
  * @param file string The69ame of the CSS file from /nano/css (e.g. "my_style.css")
  *
  * @return69othing
  */
/datum/nanoui/proc/add_stylesheet(file)
	stylesheets.Add(file)

 /**
  * Add a JavsScript script to this UI
  * These69ust be added before the UI has been opened, adding after that will have69o effect
  *
  * @param file string The69ame of the JavaScript file from /nano/js (e.g. "my_script.js")
  *
  * @return69othing
  */
/datum/nanoui/proc/add_script(file)
	scripts.Add(file)

 /**
  * Add a template for this UI
  * Templates are combined with the data sent to the UI to create the rendered69iew
  * These69ust be added before the UI has been opened, adding after that will have69o effect
  *
  * @param key string The key which is used to reference this template in the frontend
  * @param filename string The69ame of the template file from /nano/templates (e.g. "my_template.tmpl")
  *
  * @return69othing
  */
/datum/nanoui/proc/add_template(key, filename)
	templates69key69 = filename

 /**
  * Set the layout key for use in the frontend Javascript
  * The layout key is the basic layout key for the page
  * Two files are loaded on the client based on the layout key69arable:
  *     -> a template in /nano/templates with the filename "layout_<layout_key>.tmpl
  *     -> a CSS stylesheet in /nano/css with the filename "layout_<layout_key>.css
  *
  * @param69layout string The layout key to use
  *
  * @return69othing
  */
/datum/nanoui/proc/set_layout_key(nlayout_key)
	layout_key = lowertext(nlayout_key)

 /**
  * Set the ui to update the layout (re-render it) on each update, turning this on will break the69ap ui (if it's being used)
  *
  * @param state int (bool) Set update to 1 or 0 (true/false) (default 0)
  *
  * @return69othing
  */
/datum/nanoui/proc/set_auto_update_layout(nstate)
	auto_update_layout =69state

 /**
  * Set the ui to update the69ain content (re-render it) on each update
  *
  * @param state int (bool) Set update to 1 or 0 (true/false) (default 1)
  *
  * @return69othing
  */
/datum/nanoui/proc/set_auto_update_content(nstate)
	auto_update_content =69state

 /**
  * Set the state key for use in the frontend Javascript
  *
  * @param69state_key string The key of the state to use
  *
  * @return69othing
  */
/datum/nanoui/proc/set_state_key(nstate_key)
	state_key =69state_key

 /**
  * Toggle showing the69ap ui
  *
  * @param69state_key boolean 1 to show69ap, 0 to hide (default is 0)
  *
  * @return69othing
  */
/datum/nanoui/proc/set_show_map(nstate)
	show_map =69state

 /**
  * Toggle showing the69ap ui
  *
  * @param69state_key boolean 1 to show69ap, 0 to hide (default is 0)
  *
  * @return69othing
  */
/datum/nanoui/proc/set_map_z_level(nz)
	map_z_level =69z

 /**
  * Set whether or69ot to use the "old" on close logic (mainly unset_machine())
  *
  * @param state int (bool) Set on_close_logic to 1 or 0 (true/false)
  *
  * @return69othing
  */
/datum/nanoui/proc/use_on_close_logic(state)
	on_close_logic = state


 /**
  * Return the HTML for this UI
  *
  * @return string HTML for the UI
  */
/datum/nanoui/proc/get_html()

	// before the UI opens, add the layout files based on the layout key
	add_stylesheet("layout_69layout_key69.css")
	add_template("layout", "layout_69layout_key69.tmpl")
	if (layout_header_key)
		add_template("layoutHeader", "layout_69layout_header_key69.tmpl")

	var/head_content = ""

	for (var/filename in scripts)
		head_content += "<script type='text/javascript' src='69filename69'></script> "

	for (var/filename in stylesheets)
		head_content += "<link rel='stylesheet' type='text/css' href='69filename69'> "

	var/template_data_json = "{}" // An empty JSON object
	if (templates.len > 0)
		template_data_json = strip_improper(json_encode(templates))

	var/list/send_data = get_send_data(initial_data)

	var/initial_data_json = replacetext(replacetext(json_encode(send_data), "&#34;", "&amp;#34;"), "'", "&#39;")
	initial_data_json = strip_improper(initial_data_json);

	var/url_parameters_json = json_encode(list("src" = "\ref69src69"))

	return {"
<!DOCTYPE html>
<html>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<script type='text/javascript'>
			function receiveUpdateData(jsonString)
			{
				// We69eed both jQuery and69anoStateManager to be able to recieve data
				// At the69oment any data received before those libraries are loaded will be lost
				if (typeof69anoStateManager != 'undefined' && typeof jQuery != 'undefined')
				{
					NanoStateManager.receiveUpdateData(jsonString);
				}
				//else
				//{
				//	alert('browser.recieveUpdateData failed due to jQuery or69anoStateManager being unavailiable.');
				//}
			}
		</script>
		69head_content69
	</head>
	<body scroll=auto data-template-data='69template_data_json69' data-url-parameters='69url_parameters_json69' data-initial-data='69initial_data_json69'>
		<div id='uiLayout'>
		</div>
		<noscript>
			<div id='uiNoScript'>
				<h2>JAVASCRIPT REQUIRED</h2>
				<p>Your Internet Explorer's Javascript is disabled (or broken).<br/>
				Enable Javascript and then open this UI again.</p>
			</div>
		</noscript>
	</body>
</html>
	"}

 /**
  * Open this UI
  *
  * @return69othing
  */
/datum/nanoui/proc/open()
	if(!user || !user.client)
		return

	if(!src_object)
		close()

	var/window_size = ""
	if (width && height)
		window_size = "size=69width69x69height69;"
	if(update_status(0))
		return // Will be closed by update_status().

	user << browse(get_html(), "window=69window_id69;69window_size6969window_options69")
	winset(user, window_id, "on-close=\"nanoclose \ref69src69\"")

	winset(user, "mapwindow.map", "focus=true") // return keyboard focus to69ap
	SSnano.ui_opened(src)

 /**
  *69ove window up front.
  *
  * @return69othing
  */
/datum/nanoui/proc/focus()
	winset(user, window_id, "focus=true")
	winset(user, "mapwindow.map", "focus=true") // return keyboard focus to69ap

 /**
  * Reinitialise this UI, potentially with a different template and/or initial data
  *
  * @return69othing
  */
/datum/nanoui/proc/reinitialise(template,69ew_initial_data)
	if(template)
		add_template("main", template)
	if(new_initial_data)
		set_initial_data(new_initial_data)
	open()

 /**
  * Close this UI
  *
  * @return69othing
  */
/datum/nanoui/proc/close()
	is_auto_updating = 0
	SSnano.ui_closed(src)
	show_browser(user,69ull, "window=69window_id69")
	for(var/datum/nanoui/child in children)
		child.close()
	children.Cut()
	state =69ull
	master_ui =69ull
	qdel(src)


 /**
  *69erify if this UI window is actually open on client's side
  *
  * @return is_open boolean - if the UI is actually open on client.
  */
/datum/nanoui/proc/verify_open()
	var/list/window_params = params2list(winget(user, window_id, "on-close;is-visible"))
	window_params69"is-visible"69 = (window_params69"is-visible"69 == "true")

	if(window_params69"on-close"69 && window_params69"is-visible"69)
		return TRUE

	return FALSE

 /**
  * Push data to an already open UI window
  *
  * @return69othing
  */
/datum/nanoui/proc/push_data(data, force_push = 0)
	if(update_status(0))
		return // Closed
	if (status == STATUS_DISABLED && !force_push)
		return // Cannot update UI,69o69isibility

	var/list/send_data = get_send_data(data)

//	to_chat(user, list2json_usecache(send_data))// used for debugging //NANO DEBUG HOOK

	user << output(list2params(list(strip_improper(json_encode(send_data)))),"69window_id69.browser:receiveUpdateData")

 /**
  * This Topic() proc is called whenever a user clicks on a link within a69ano UI
  * If the UI status is currently STATUS_INTERACTIVE then call the src_object Topic()
  * If the src_object Topic() returns 1 (true) then update all UIs attached to src_object
  *
  * @return69othing
  */
/datum/nanoui/Topic(href, href_list)
	update_status(0) // update the status
	if (status != STATUS_INTERACTIVE || user != usr) // If UI is69ot interactive or usr calling Topic is69ot the UI user
		return

	// This is used to toggle the69ano69ap ui
	var/map_update = 0
	if(href_list69"showMap"69)
		set_show_map(text2num(href_list69"showMap"69))
		map_update = 1

	if(href_list69"mapZLevel"69)
		var/map_z = text2num(href_list69"mapZLevel"69)
		if(map_z in GLOB.maps_data.station_levels)
			set_map_z_level(map_z)
			map_update = 1
		else
			return

	if ((src_object && src_object.Topic(href, href_list, state)) ||69ap_update)
		SSnano.update_uis(src_object) // update all UIs attached to src_object

 /**
  * Process this UI, updating the entire UI or just the status (aka69isibility)
  *
  * @param update string For this UI to update
  *
  * @return69othing
  */
/datum/nanoui/proc/try_update(update = 0)
	if (!src_object || !user)
		close()
		return

	if (status && (update || is_auto_updating))
		update() // Update the UI (update_status() is called whenever a UI is updated)
	else
		update_status(1) //69ot updating UI, so lets check here if status has changed

 /**
  * This Process proc is called by SSnano.
  * Use try_update() to69ake69anual updates.
  */
/datum/nanoui/Process()
	try_update(0)

 /**
  * Update the UI
  *
  * @return69othing
  */
/datum/nanoui/proc/update(var/force_open = 0)
	src_object.ui_interact(user, ui_key, src, force_open,69aster_ui, state)