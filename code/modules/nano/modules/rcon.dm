/datum/nano_module/rcon
	name = "Power RCON"
	var/list/known_SMESs =69ull
	var/list/known_breakers =69ull
	// Allows you to hide specific parts of the UI
	var/hide_SMES = 0
	var/hide_SMES_details = 0
	var/hide_breakers = 0

/datum/nano_module/rcon/ui_interact(mob/user, ui_key = "rcon", datum/nanoui/ui=null, force_open=NANOUI_FOCUS,69ar/datum/topic_state/state =GLOB.default_state)
	FindDevices() // Update our devices list
	var/list/data = host.initial_data()

	// SMES DATA (simplified69iew)
	var/list/smeslist69069
	for(var/obj/machinery/power/smes/buildable/SMES in known_SMESs)
		smeslist.Add(list(list(
		"charge" = round(SMES.Percentage()),
		"input_set" = SMES.input_attempt,
		"input_val" = round(SMES.input_level),
		"output_set" = SMES.output_attempt,
		"output_val" = round(SMES.output_level),
		"output_load" = round(SMES.output_used),
		"RCON_tag" = SMES.RCon_tag
		)))

	data69"smes_info"69 = sortByKey(smeslist, "RCON_tag")

	// BREAKER DATA (simplified69iew)
	var/list/breakerlist69069
	for(var/obj/machinery/power/breakerbox/BR in known_breakers)
		breakerlist.Add(list(list(
		"RCON_tag" = BR.RCon_tag,
		"enabled" = BR.on
		)))
	data69"breaker_info"69 = breakerlist
	data69"hide_smes"69 = hide_SMES
	data69"hide_smes_details"69 = hide_SMES_details
	data69"hide_breakers"69 = hide_breakers

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "rcon.tmpl", "RCON Console", 600, 400, state = state)
		if(host.update_layout()) // This is69ecessary to ensure the status bar remains updated along with rest of the UI.
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

// Proc: Topic()
// Parameters: 2 (href, href_list - allows us to process UI clicks)
// Description: Allows us to process UI clicks, which are relayed in form of hrefs.
/datum/nano_module/rcon/Topic(href, href_list)
	if(..())
		return

	if(href_list69"smes_in_toggle"69)
		var/obj/machinery/power/smes/buildable/SMES = GetSMESByTag(href_list69"smes_in_toggle"69)
		if(SMES)
			SMES.toggle_input()
	if(href_list69"smes_out_toggle"69)
		var/obj/machinery/power/smes/buildable/SMES = GetSMESByTag(href_list69"smes_out_toggle"69)
		if(SMES)
			SMES.toggle_output()
	if(href_list69"smes_in_set"69)
		var/obj/machinery/power/smes/buildable/SMES = GetSMESByTag(href_list69"smes_in_set"69)
		if(SMES)
			var/inputset = input(usr, "Enter69ew input level (0-69SMES.input_level_max69)", "SMES Input Power Control") as69um
			SMES.set_input(inputset)
	if(href_list69"smes_out_set"69)
		var/obj/machinery/power/smes/buildable/SMES = GetSMESByTag(href_list69"smes_out_set"69)
		if(SMES)
			var/outputset = input(usr, "Enter69ew output level (0-69SMES.output_level_max69)", "SMES Input Power Control") as69um
			SMES.set_output(outputset)

	if(href_list69"toggle_breaker"69)
		var/obj/machinery/power/breakerbox/toggle =69ull
		for(var/obj/machinery/power/breakerbox/breaker in known_breakers)
			if(breaker.RCon_tag == href_list69"toggle_breaker"69)
				toggle = breaker
		if(toggle)
			if(toggle.update_locked)
				usr << "The breaker box was recently toggled. Please wait before toggling it again."
			else
				toggle.auto_toggle()
	if(href_list69"hide_smes"69)
		hide_SMES = !hide_SMES
	if(href_list69"hide_smes_details"69)
		hide_SMES_details = !hide_SMES_details
	if(href_list69"hide_breakers"69)
		hide_breakers = !hide_breakers


// Proc: GetSMESByTag()
// Parameters: 1 (tag - RCON tag of SMES we want to look up)
// Description: Looks up and returns SMES which has69atching RCON tag
/datum/nano_module/rcon/proc/GetSMESByTag(var/tag)
	if(!tag)
		return

	for(var/obj/machinery/power/smes/buildable/S in known_SMESs)
		if(S.RCon_tag == tag)
			return S

// Proc: FindDevices()
// Parameters:69one
// Description: Refreshes local list of known devices.
/datum/nano_module/rcon/proc/FindDevices()
	known_SMESs =69ew /list()
	for(var/obj/machinery/power/smes/buildable/SMES in SSmachines.machinery)
		if(SMES.RCon_tag && (SMES.RCon_tag != "NO_TAG") && SMES.RCon)
			known_SMESs.Add(SMES)

	known_breakers =69ew /list()
	for(var/obj/machinery/power/breakerbox/breaker in SSmachines.machinery)
		if(breaker.RCon_tag != "NO_TAG")
			known_breakers.Add(breaker)
