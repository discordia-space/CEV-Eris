#define SCREEN_SETTINGS		"settings"
#define SCREEN_DNALIST		"dnalist"
#define SCREEN_WORKING		"working"
#define SCREEN_RESEARCH		"research"
#define SCREEN_LOCKED		"locked"

/datum/computer_file/program/dna_analyzer
	filename = "dnaAnalyzer"
	filedesc = "DNA Analyzing program"
	extended_desc = "This program allows analyze of deoxyribonucleic acid. This program can not be run without DNA processor installed."
	required_access = access_genetics
	program_icon_state = "dna"
	program_key_state = "med_key"
	program_menu_icon = "link"
	usage_flags = PROGRAM_CONSOLE
	size = 1
	requires_ntnet = 0
	available_on_ntnet = 1
	nanomodule_path = /datum/nano_module/program/dna_analyzer

/datum/nano_module/program/dna_analyzer
	name = "DNA Analyzer"

	var/list/available_mutations_for_research
	var/datum/mutation/researched_mutation
	var/obj/machinery/r_n_d/dna_imprinter/linked_imprinter
	var/obj/item/weapon/computer_hardware/dna_processor/linked_dna_processor
	var/show_spaces = FALSE
	var/list/samples_list = list()
	
	var/datum/research/files
	var/screen = SCREEN_SETTINGS
	var/show_topnav = TRUE
	var/sync = TRUE
	var/id = 1

/datum/nano_module/program/dna_analyzer/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_REINITIALIZE, state = GLOB.default_state)
	var/list/data = ui_data(user)

	data["screen"] = screen
	data["sync"] = sync
	data["has_dna_imprinter"] = !!linked_imprinter
	data["show_topnav"] = show_topnav
	if(screen == SCREEN_DNALIST)
		var/index = 1
		var/list/mutations_list
		for(var/M in samples_list)
			var/datum/mutation/mutation = M
			var/entry = list()
			entry["name"] = mutation.name
			entry["tier"] = mutation.tier
			entry["genocode1"] = mutation.genocode1
			entry["genocode2"] = mutation.genocode2
			entry["index"] = index
			index++
			mutations_list += list(entry)
		data["mutations_list"] = mutations_list
	if(screen == SCREEN_RESEARCH)
		var/index = 1
		var/list/mutations_list
		for(var/M in available_mutations_for_research)
			var/datum/mutation/mutation = M
			var/entry = list()
			entry["genocode1"] = mutation.genocode1
			entry["genocode2"] = mutation.genocode2
			entry["index"] = index
			index++
			mutations_list += list(entry)
		data["available_mutations"] = mutations_list

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "dna_analyzer.tmpl", name, 640, 700, state = state)
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/dna_analyzer/proc/update_samples_list()
	var/list/mutations = list()
	var/list/files = program.computer.hard_drive.find_files_by_type(/datum/computer_file/binary/dna_sample)
	for(var/file in files)
		var/datum/computer_file/binary/dna_sample/sample = file
		mutations.Add(sample.stored_mutation)
	samples_list = mutations

/datum/nano_module/program/dna_analyzer/proc/InitializeResearch()

/datum/nano_module/program/dna_analyzer/Topic(href, href_list)
	if(..())
		return

	if(href_list["change_screen"])
		screen = href_list["change_screen"]
		if(screen == SCREEN_DNALIST)
			update_samples_list()

	if(href_list["sync"])
		if(!sync)
			to_chat(usr, SPAN_WARNING("You must connect to the network first!"))
		else
			show_topnav = FALSE
			screen = SCREEN_WORKING
			addtimer(CALLBACK(src, .proc/sync_tech), 3 SECONDS)

	if(href_list["togglesync"])
		sync = !sync

	if(href_list["find_device"])
		show_topnav = FALSE
		screen = SCREEN_WORKING
		addtimer(CALLBACK(src, .proc/find_devices), 2 SECONDS)

	if(href_list["disconnect"])
		linked_imprinter.linked_console = null
		linked_imprinter = null

	if(href_list["reset"])
		var/choice = alert("Are you sure you want to reset the DNA Analyze console's database? Data lost cannot be recovered.", "DNA Analyze Console Database Reset", "Continue", "Cancel")
		if(choice == "Continue")
			show_topnav = FALSE
			screen = SCREEN_WORKING
			qdel(files)
			files = new /datum/research(src)
			addtimer(CALLBACK(src, .proc/reset_screen), 2 SECONDS)

	if(href_list["lock"])
		if(check_access(usr, access_genetics) || program.computer_emagged)
			show_topnav = FALSE
			screen = SCREEN_LOCKED
		else
			to_chat(usr, SPAN_WARNING("Unauthorized access."))

	if(href_list["unlock"])
		if(check_access(usr, access_genetics) || program.computer_emagged)
			show_topnav = TRUE
			screen = SCREEN_RESEARCH
		else
			to_chat(usr, SPAN_WARNING("Unauthorized access."))

	if(href_list["research"])
		var/index = href_list["research"]
		researched_mutation = listgetindex(samples_list, index)
		available_mutations_for_research = samples_list.Copy()
		available_mutations_for_research.Remove(researched_mutation)
		screen = SCREEN_RESEARCH
		

	if(href_list["pick"])
		show_spaces = TRUE

/datum/nano_module/program/dna_analyzer/proc/reset_screen()
	screen = SCREEN_DNALIST
	show_topnav = TRUE
	SSnano.update_uis(src)

/datum/nano_module/program/dna_analyzer/proc/find_devices()
	SyncDevices()
	reset_screen()

/datum/nano_module/program/dna_analyzer/proc/SyncDevices()
	for(var/obj/machinery/r_n_d/D in range(3, src))
		if(!isnull(D.linked_console) || D.panel_open)
			continue
		if(istype(D, /obj/machinery/r_n_d/dna_imprinter))
			if(isnull(linked_imprinter))
				linked_imprinter = D
				D.linked_console = src

/datum/nano_module/program/dna_analyzer/proc/sync_tech()
	for(var/obj/machinery/r_n_d/server/S in SSmachines.machinery)
		var/server_processed = FALSE
		if((id in S.id_with_upload) || istype(S, /obj/machinery/r_n_d/server/centcom))
			S.files.download_from(files)
			server_processed = TRUE
		if(((id in S.id_with_download) && !istype(S, /obj/machinery/r_n_d/server/centcom)))
			files.download_from(S.files)
			server_processed = TRUE
		if(!istype(S, /obj/machinery/r_n_d/server/centcom) && server_processed)
			S.produce_heat(100)
	reset_screen()

#undef SCREEN_SETTINGS
#undef SCREEN_DNALIST
#undef SCREEN_WORKING
#undef SCREEN_RESEARCH
#undef SCREEN_LOCKED