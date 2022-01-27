/*
Research and Development (R&D) Console

This is the69ain work horse of the R&D system. It contains the69enus/controls for the Destructive Analyzer, Protolathe, and Circuit
imprinter. It also contains the /datum/research holder which handles the local research database.

Basic use: When it first is created, it will attempt to link up to related devices within 3 s69uares. It'll only link up if they
aren't already linked to another console. Any consoles it cannot link up with (either because all of a certain type are already
linked or there aren't any in range), you'll just69ot have access to that69enu. In the settings69enu, there are69enu options that
allow a player to attempt to re-sync with69earby consoles. You can also force it to disconnect from a specific console.

The imprinting and construction69enus do69OT re69uire toxins access to access but all the other69enus do. However, if you leave it
on a69enu,69othing is to stop the person from using the options on that69enu (although they won't be able to change to a different
one). You can also lock the console on the settings69enu if you're feeling paranoid and you don't want anyone69essing with it who
doesn't have toxins access.

When a R&D console is destroyed or even partially disassembled, you lose all research data on it. However, there are two ways around
this dire fate:
- The easiest way is to go to the settings69enu and select "Sync Database with69etwork." That causes it to upload
it's data to every other device in the game. Each console has a "disconnect from69etwork" option that'll will cause data base sync
operations to skip that console. This is useful if you want to69ake a "public" R&D console or, for example, give the engineers
a circuit imprinter with certain designs on it and don't want it accidentally updating. The downside of this69ethod is that you have
to have physical access to the other console to send data back.69ote: An R&D console is on CentCom so if a random griffan happens to
cause a ton of data to be lost, an admin can go send it back.
- The second69ethod is with data disks. Each of these disks can hold69ultiple technology or design datum in
it's entirety. You can then take the disk to any R&D console and upload it's data to it. This69ethod is a lot69ore secure (since it
won't update every console in existence) but it's69ore of a hassle to do. Also, the disks can be stolen.
*/

#define SCREEN_MAIN "main"
#define SCREEN_PROTO "protolathe"
#define SCREEN_IMPRINTER "circuit_imprinter"
#define SCREEN_WORKING "working"
#define SCREEN_TREES "tech_trees"
#define SCREEN_LOCKED "locked"
#define SCREEN_DISK_DESIGNS "disk_management_designs"
#define SCREEN_DISK_TECH "disk_management_tech"
#define SCREEN_DISK_DATA "disk_management_data"

/obj/machinery/computer/rdconsole
	name = "R&D control console"
	icon_keyboard = "rd_key"
	icon_screen = "rdcomp"
	light_color = COLOR_LIGHTING_PURPLE_MACHINERY
	circuit = /obj/item/electronics/circuitboard/rdconsole
	var/datum/research/files								//Stores all the collected research data.
	var/obj/item/computer_hardware/hard_drive/portable/disk =69ull	//Stores the data disk.

	var/obj/machinery/r_n_d/destructive_analyzer/linked_destroy =69ull	//Linked Destructive Analyzer
	var/obj/machinery/autolathe/rnd/protolathe/linked_lathe =69ull		//Linked Protolathe
	var/obj/machinery/autolathe/rnd/imprinter/linked_imprinter =69ull	//Linked Circuit Imprinter

	var/screen = SCREEN_MAIN	//Which screen is currently showing.
	var/id     = 0			//ID of the computer (for server restrictions).
	var/sync   = 1		//If sync = 0, it doesn't show up on Server Control Console
	var/can_research = TRUE   //Is this console capable of researching
	var/hacked = 0 // If this console has had its access re69uirements hacked or69ot.

	re69_access = list(access_research_e69uipment) //Data and setting69anipulation re69uires scientist access.

	var/datum/tech/selected_tech_tree
	var/datum/technology/selected_technology
	var/show_settings = FALSE
	var/show_link_menu = FALSE
	var/selected_protolathe_category
	var/selected_imprinter_category
	var/search_text

/obj/machinery/computer/rdconsole/proc/SyncRDevices() //Makes sure it is properly sync'ed up with the devices attached to it (if any).
	for(var/obj/machinery/r_n_d/destructive_analyzer/D in range(3, src))
		if(!isnull(D.linked_console) || D.panel_open)
			continue
		if(isnull(linked_destroy))
			linked_destroy = D
			D.linked_console = src

	for(var/obj/machinery/autolathe/rnd/D in range(3, src))
		if(!isnull(D.linked_console) || D.panel_open)
			continue

		if(istype(D, /obj/machinery/autolathe/rnd/protolathe))
			if(isnull(linked_lathe))
				linked_lathe = D
				D.linked_console = src

		else if(istype(D, /obj/machinery/autolathe/rnd/imprinter))
			if(isnull(linked_imprinter))
				linked_imprinter = D
				D.linked_console = src


/obj/machinery/computer/rdconsole/proc/griefProtection() //Have it automatically push research to the centcom server so wild griffins can't fuck up R&D's work
	for(var/obj/machinery/r_n_d/server/centcom/C in GLOB.machines)
		C.files.download_from(files)

/obj/machinery/computer/rdconsole/Initialize()
	. = ..()
	files =69ew /datum/research(src) //Setup the research data holder.
	SyncRDevices()

/obj/machinery/computer/rdconsole/Destroy()
	files =69ull
	if(linked_destroy)
		linked_destroy.linked_console =69ull
		linked_destroy =69ull
	if(linked_lathe)
		linked_lathe.linked_console =69ull
		linked_destroy =69ull
	if(linked_imprinter)
		linked_imprinter.linked_console =69ull
		linked_destroy =69ull
	return ..()

/obj/machinery/computer/rdconsole/attackby(var/obj/item/D as obj,69ar/mob/user as69ob)
	//Loading a disk into it.
	if(istype(D, /obj/item/computer_hardware/hard_drive/portable))
		if(disk)
			to_chat(user, SPAN_NOTICE("A disk is already loaded into the69achine."))
			return

		user.drop_item()
		D.forceMove(src)
		disk = D
		to_chat(user, SPAN_NOTICE("You add \the 69D69 to the69achine."))
	else if(istype(D, /obj/item/device/science_tool)) // Used when you want to upload autopsy/other scanned data to the console
		var/research_points = files.experiments.read_science_tool(D)
		if(research_points > 0)
			to_chat(user, SPAN_NOTICE("69name69 received 69research_points69 research points from uploaded data."))
			files.adjust_research_points(research_points)
		else
			to_chat(user, SPAN_NOTICE("There was69o useful data inside 69D.name69's buffer."))
	else
		//The construction/deconstruction of the console code.
		..()

	SSnano.update_uis(src)
	return

/obj/machinery/computer/rdconsole/emag_act(var/remaining_charges,69ar/mob/user)
	if(!emagged)
		playsound(loc, 'sound/effects/sparks4.ogg', 75, 1)
		emagged = TRUE
		to_chat(user, SPAN_NOTICE("You disable the security protocols."))
		return TRUE

/obj/machinery/computer/rdconsole/proc/reset_screen() // simply resets the screen to the69ain screen and updates the UIs
	screen = SCREEN_MAIN
	SSnano.update_uis(src)

/obj/machinery/computer/rdconsole/proc/handle_item_analysis(obj/item/I) // handles deconstructing items.
	files.check_item_for_tech(I)
	files.adjust_research_points(files.experiments.get_object_research_value(I))
	files.experiments.do_research_object(I)
	var/list/matter = I.get_matter()
	if(linked_lathe &&69atter)
		for(var/t in69atter)
			if(t in linked_lathe.unsuitable_materials)
				continue

			if(!linked_lathe.stored_material69t69)
				linked_lathe.stored_material69t69 = 0

			linked_lathe.stored_material69t69 +=69atter69t69 * linked_destroy.decon_mod
			linked_lathe.stored_material69t69 =69in(linked_lathe.stored_material69t69, linked_lathe.storage_capacity)

/obj/machinery/computer/rdconsole/Topic(href, href_list) // Oh boy here we go.
	if(..())
		return 1

	var/obj/machinery/autolathe/rnd/target_device
	if(screen == SCREEN_PROTO && linked_lathe)
		target_device = linked_lathe
	else if(screen == SCREEN_IMPRINTER && linked_imprinter)
		target_device = linked_imprinter

	if(href_list69"select_tech_tree"69) // User selected a tech tree.
		var/datum/tech/tech_tree = locate(href_list69"select_tech_tree"69) in files.researched_tech
		if(tech_tree && tech_tree.shown)
			selected_tech_tree = tech_tree
			selected_technology =69ull
	if(href_list69"select_technology"69) // User selected a technology69ode.
		var/tech_node = locate(href_list69"select_technology"69) in SSresearch.all_tech_nodes
		if(tech_node)
			selected_technology = tech_node
	if(href_list69"unlock_technology"69) // User attempts to unlock a technology69ode (Safeties are within UnlockTechnology)
		var/tech_node = locate(href_list69"unlock_technology"69) in SSresearch.all_tech_nodes
		if(tech_node)
			files.UnlockTechology(tech_node)
	if(href_list69"go_screen"69) // User is changing the screen.
		var/where = href_list69"go_screen"69
		if(href_list69"need_access"69)
			if(!allowed(usr) && !emagged)
				to_chat(usr, SPAN_WARNING("Unauthorized access."))
				return
		screen = where
		if(screen == SCREEN_PROTO || screen == SCREEN_IMPRINTER)
			search_text = ""
	if(href_list69"eject_disk"69) // User is ejecting the disk.
		if(disk)
			disk.forceMove(drop_location())
			disk =69ull
	if(href_list69"delete_disk_file"69) // User is attempting to delete a file from the loaded disk.
		if(disk)
			var/datum/computer_file/file = locate(href_list69"delete_disk_file"69) in disk.stored_files
			disk.remove_file(file)

	if(href_list69"download_disk_design"69) // User is attempting to download (disk->rdconsole) a design from the disk.
		if(disk)
			var/datum/computer_file/binary/design/file = locate(href_list69"download_disk_design"69) in disk.stored_files
			if(file && !file.copy_protected)
				files.AddDesign2Known(file.design)
				griefProtection() //Update CentCom too
	if(href_list69"upload_disk_design"69) // User is attempting to upload (rdconsole->disk) a design to the disk.
		if(disk)
			var/datum/design/D = locate(href_list69"upload_disk_design"69) in files.known_designs
			if(D)
				disk.store_file(D.file.clone())
	if(href_list69"download_disk_node"69) // User is attempting to download (disk->rdconsole) a technology69ode from the disk.
		if(disk)
			var/datum/computer_file/binary/tech/file = locate(href_list69"download_disk_node"69) in disk.stored_files
			if(file)
				files.UnlockTechology(file.node, TRUE)
				griefProtection()
	if(href_list69"upload_disk_node"69) // User is attempting to upload (rdconsole->disk) a technology69ode to the disk.
		if(disk)
			var/datum/technology/T = locate(href_list69"upload_disk_node"69) in files.researched_nodes
			if(T)
				var/datum/computer_file/binary/tech/tech_file =69ew
				tech_file.set_tech(T)
				disk.store_file(tech_file)
	if(href_list69"download_disk_data"69)
		if(disk)
			var/datum/computer_file/file = locate(href_list69"download_disk_data"69) in disk.stored_files
			if(file)
				files.load_file(file)
	if(href_list69"toggle_settings"69) // User wants to see the settings.
		if(allowed(usr) || emagged)
			show_settings = !show_settings
		else
			to_chat(usr, SPAN_WARNING("Unauthorized access.</span>"))
	if(href_list69"toggle_link_menu"69) // User wants to see the device linkage69enu.
		if(allowed(usr) || emagged)
			show_link_menu = !show_link_menu
		else
			to_chat(usr, SPAN_WARNING("Unauthorized access."))
	if(href_list69"sync"69) //Sync the research holder with all the R&D consoles in the game that aren't sync protected (after a 3 seconds delay).
		if(!sync)
			to_chat(usr, SPAN_WARNING("You69ust connect to the69etwork first!"))
		else
			screen = SCREEN_WORKING
			griefProtection() //Putting this here because I dont trust the sync process
			addtimer(CALLBACK(src, .proc/sync_tech), 3 SECONDS)
	if(href_list69"togglesync"69) //Prevents the console from being synced by other consoles. Can still send data.
		sync = !sync
	if(href_list69"select_category"69) // User is selecting a design category while in the protolathe/imprinter screen
		var/what_cat = href_list69"select_category"69
		if(screen == SCREEN_PROTO)
			selected_protolathe_category = what_cat
		if(screen == SCREEN_IMPRINTER)
			selected_imprinter_category = what_cat
	if(href_list69"search"69) // User is searching for a specific design.
		var/input = sanitizeSafe(input(usr, "Enter text to search", "Searching") as69ull|text,69AX_LNAME_LEN)
		search_text = input
		if(screen == SCREEN_PROTO)
			if(!search_text)
				selected_protolathe_category =69ull
			else
				selected_protolathe_category = "Search Results"
		if(screen == SCREEN_IMPRINTER)
			if(!search_text)
				selected_imprinter_category =69ull
			else
				selected_imprinter_category = "Search Results"
	if(href_list69"deconstruct"69) // User is deconstructing an item.
		if(linked_destroy)
			if(linked_destroy.deconstruct_item())
				screen = SCREEN_WORKING // Will be resetted by the linked_destroy.
	if(href_list69"eject_item"69) // User is ejecting an item from the linked_destroy.
		if(linked_destroy)
			linked_destroy.eject_item()

	if(href_list69"build"69)
		var/amount = CLAMP(text2num(href_list69"amount"69), 1, 10)
		var/datum/design/being_built = locate(href_list69"build"69) in files.known_designs
		if(being_built && target_device)
			target_device.69ueue_design(being_built.file, amount)
	if(href_list69"clear_69ueue"69) // Clearing a 69ueue
		if(target_device)
			target_device.clear_69ueue()
	if(href_list69"eject_sheet"69) // Removing69aterial sheets
		if(target_device)
			target_device.eject(href_list69"eject_sheet"69, text2num(href_list69"amount"69))

	if(href_list69"find_device"69) // Connect with the local devices
		screen = SCREEN_WORKING
		addtimer(CALLBACK(src, .proc/find_devices), 2 SECONDS)
	if(href_list69"disconnect"69) //The R&D console disconnects with a specific device.
		switch(href_list69"disconnect"69)
			if("destroy")
				linked_destroy.linked_console =69ull
				linked_destroy =69ull
			if("lathe")
				linked_lathe.linked_console =69ull
				linked_lathe =69ull
			if("imprinter")
				linked_imprinter.linked_console =69ull
				linked_imprinter =69ull
	if(href_list69"reset"69) //Reset the R&D console's database.
		griefProtection()
		var/choice = alert("R&D Console Database Reset", "Are you sure you want to reset the R&D console's database? Data lost cannot be recovered.", "Continue", "Cancel")
		if(choice == "Continue")
			log_and_message_admins("reset the R&D console's database")
			screen = SCREEN_WORKING
			69del(files)
			files =69ew /datum/research(src)
			addtimer(CALLBACK(src, .proc/reset_screen), 2 SECONDS)
	if(href_list69"lock"69) //Lock the console from use by anyone without tox access.
		if(allowed(usr) || emagged)
			screen = SCREEN_LOCKED
		else
			to_chat(usr, SPAN_WARNING("Unauthorized access."))
	if(href_list69"unlock"69) // Unlock
		if(allowed(usr) || emagged)
			screen = SCREEN_MAIN
		else
			to_chat(usr, SPAN_WARNING("Unauthorized access."))

	return TRUE

/obj/machinery/computer/rdconsole/proc/find_devices()
	SyncRDevices()
	reset_screen()

/obj/machinery/computer/rdconsole/proc/sync_tech()
	for(var/obj/machinery/r_n_d/server/S in GLOB.machines)
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


/obj/machinery/computer/rdconsole/proc/get_possible_designs_data(obj/machinery/autolathe/rnd/target_machine, category) // Builds the design list for the UI
	var/list/designs_list = list()
	for(var/datum/design/D in files.known_designs)
		if(D.build_type & target_machine.build_type)
			var/cat = "Unspecified"
			if(D.category)
				cat = D.category
			if((category == cat) || (category == "Search Results" && findtext(D.name, search_text)))
				var/list/missing_materials = list()
				var/list/missing_chemicals = list()
				var/can_build = 50
				var/can_build_temp

				for(var/material in D.materials)
					can_build_temp = target_machine.check_craftable_amount_by_material(D,69aterial)
					if(can_build_temp < 1)
						missing_materials +=69aterial
					can_build =69in(can_build, can_build_temp)

				for(var/chemical in D.chemicals)
					can_build_temp = target_machine.check_craftable_amount_by_chemical(D, chemical)
					if(can_build_temp < 1)
						missing_chemicals += chemical
					can_build =69in(can_build, can_build_temp)

				designs_list += list(list(
					"data" = D.ui_data(),
					"id" = "\ref69D69",
					"can_create" = can_build,
					"missing_materials" =69issing_materials,
					"missing_chemicals" =69issing_chemicals
				))
	return designs_list

/obj/machinery/computer/rdconsole/attack_hand(mob/user)
	if(..())
		return
	ui_interact(user)


/obj/machinery/computer/rdconsole/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui =69ull) // Here we go again
	if((screen == SCREEN_PROTO && !linked_lathe) || (screen == SCREEN_IMPRINTER && !linked_imprinter))
		screen = SCREEN_MAIN // Kick us from protolathe or imprinter screen if they were destroyed

	var/list/data = list()
	data69"screen"69 = screen
	data69"sync"69 = sync
	data69"has_disk"69 = !!disk
	if(disk)
		data69"disk_size"69 = disk.max_capacity
		data69"disk_used"69 = disk.used_capacity
		data69"disk_read_only"69 = disk.read_only

	//69ain screen69eeds info about tech levels
	if(!screen || screen == SCREEN_MAIN)
		data69"show_settings"69 = show_settings
		data69"show_link_menu"69 = show_link_menu
		data69"has_dest_analyzer"69 = !!linked_destroy
		data69"has_protolathe"69 = !!linked_lathe
		data69"has_circuit_imprinter"69 = !!linked_imprinter
		data69"can_research"69 = can_research

		var/list/tech_tree_list = list()
		for(var/tree in files.researched_tech)
			var/datum/tech/tech_tree = tree
			if(!tech_tree.shown)
				continue
			var/list/tech_tree_data = list(
				"id" =             tech_tree.type,
				"name" =           "69tech_tree.name69",
				"shortname" =      "69tech_tree.shortname69",
				"level" =          tech_tree.level,
				"maxlevel" =       tech_tree.max_level,
			)
			tech_tree_list += list(tech_tree_data)
		data69SCREEN_TREES69 = tech_tree_list

		if(linked_destroy)
			if(linked_destroy.loaded_item)
				// TODO: If you're refactoring origin_tech, remove this shit. Thank you from the past!
				var/list/tech_names = list(TECH_MATERIAL = "Materials", TECH_ENGINEERING = "Engineering", TECH_PLASMA = "Plasma", TECH_POWER = "Power", TECH_BLUESPACE = "Blue-space", TECH_BIO = "Biotech", TECH_COMBAT = "Combat", TECH_MAGNET = "Electromagnetic", TECH_DATA = "Programming", TECH_COVERT = "Covert")

				var/list/temp_tech = linked_destroy.loaded_item.origin_tech
				var/list/item_data = list()

				for(var/T in temp_tech)
					var/tech_name = tech_names69T69
					if(!tech_name)
						tech_name = T

					item_data += list(list(
						"id" =             T,
						"name" =           tech_name,
						"level" =          temp_tech69T69,
					))

				// This calculates how69uch research points we69issed because we already researched items with such orig_tech levels
				var/tech_points_mod = files.experiments.get_object_research_value(linked_destroy.loaded_item) / files.experiments.get_object_research_value(linked_destroy.loaded_item, ignoreRepeat = TRUE)

				var/list/destroy_list = list(
					"has_item" =              TRUE,
					"item_name" =             linked_destroy.loaded_item.name,
					"item_tech_points" =      files.experiments.get_object_research_value(linked_destroy.loaded_item),
					"item_tech_mod" =         round(tech_points_mod*100),
				)
				destroy_list69"tech_data"69 = item_data

				data69"destroy_data"69 = destroy_list
			else
				var/list/destroy_list = list(
					"has_item" =             FALSE,
				)
				data69"destroy_data"69 = destroy_list

	if(screen == SCREEN_DISK_DESIGNS)
		if(disk)
			var/list/disk_designs = list()
			var/list/disk_design_files = disk.find_files_by_type(/datum/computer_file/binary/design)
			for(var/f in disk_design_files)
				var/datum/computer_file/binary/design/d_file = f
				disk_designs += list(list("name" = d_file.design.name, "id" = "\ref69d_file69", "can_download" = !d_file.copy_protected))
			data69"disk_designs"69 = disk_designs
			var/list/known_designs = list()
			for(var/i in files.known_designs)
				var/datum/design/D = i
				if(!(D.starts_unlocked && !(D.build_type & (AUTOLATHE | BIOPRINTER))))
					// doesn't69ake69uch sense to copy starting designs around, unless you can use them in lathes
					known_designs += list(list("name" = D.name, "id" = "\ref69D69"))
			data69"known_designs"69 = known_designs
	if(screen == SCREEN_DISK_TECH)
		if(disk)
			var/list/disk_tech_nodes = list()
			var/list/disk_technology_files = disk.find_files_by_type(/datum/computer_file/binary/tech)
			for(var/f in disk_technology_files)
				var/datum/computer_file/binary/tech/tech_file = f
				disk_tech_nodes += list(list("name" = tech_file.node.name, "id" = "\ref69tech_file69"))
			data69"disk_tech_nodes"69 = disk_tech_nodes
			var/list/known_nodes = list()
			for(var/i in files.researched_nodes)
				var/datum/technology/T = i
				known_nodes += list(list("name" = T.name, "id" = "\ref69T69"))
			data69"known_nodes"69 = known_nodes
	if(screen == SCREEN_DISK_DATA)
		if(disk)
			var/list/disk_research_data = list()
			var/list/disk_data_files = disk.find_files_by_type(/datum/computer_file/binary)
			for(var/f in disk_data_files)
				var/datum/computer_file/binary/data_file = f
				if(!files.is_research_file_type(f))
					continue

				disk_research_data += list(list("name" = "69data_file.filename69.69data_file.filetype69", "id" = "\ref69data_file69", "can_download" = files.can_load_file(data_file)))
			data69"disk_research_data"69 = disk_research_data
	if(screen == SCREEN_PROTO || screen == SCREEN_IMPRINTER)
		var/obj/machinery/autolathe/rnd/target_device
		var/list/design_categories
		var/selected_category

		if(screen == SCREEN_PROTO && linked_lathe)
			target_device = linked_lathe
			design_categories = files.design_categories_protolathe
			selected_category = selected_protolathe_category
		else if(screen == SCREEN_IMPRINTER && linked_imprinter)
			target_device = linked_imprinter
			design_categories = files.design_categories_imprinter
			selected_category = selected_imprinter_category

		if(target_device)
			data69"search_text"69 = search_text
			data69"materials_data"69 = target_device.materials_data()

			data69"all_categories"69 = design_categories
			if(search_text)
				data69"all_categories"69 = list("Search Results") + data69"all_categories"69

			if((!selected_category || !(selected_category in data69"all_categories"69)) && design_categories.len)
				selected_category = design_categories69169

			if(selected_category)
				data69"selected_category"69 = selected_category
				data69"possible_designs"69 = get_possible_designs_data(target_device, selected_category)

			if(target_device.current_file)
				data69"device_current"69 = target_device.current_file.design.name

			data69"device_error"69 = target_device.error

			var/list/69ueue_list = list()
			for(var/f in target_device.69ueue)
				var/datum/computer_file/binary/design/file = f
				69ueue_list += file.design.name
			data69"69ueue"69 = 69ueue_list

	// All the info69eeded for displaying tech trees
	if(screen == SCREEN_TREES)
		var/list/line_list = list()

		var/list/tech_tree_list = list()
		for(var/tree in files.researched_tech)
			var/datum/tech/tech_tree = tree
			if(!tech_tree.shown)
				continue
			var/list/tech_tree_data = list(
				"id" =             "\ref69tech_tree69",
				"name" =           "69tech_tree.name69",
				"shortname" =      "69tech_tree.shortname69",
			)
			tech_tree_list += list(tech_tree_data)

		data69"tech_trees"69 = tech_tree_list

		if(!selected_tech_tree)
			selected_tech_tree = files.researched_tech69169

		var/list/tech_list = list()
		if(selected_tech_tree)
			data69"tech_tree_name"69 = selected_tech_tree.name
			data69"tech_tree_desc"69 = selected_tech_tree.desc
			data69"tech_tree_level"69 = selected_tech_tree.level

			for(var/tech in SSresearch.all_tech_trees69selected_tech_tree.type69)
				var/datum/technology/tech_node = tech
				var/list/tech_data = list(
					"id" =             "\ref69tech_node69",
					"name" =           "69tech_node.name69",
					"x" =              round(tech_node.x*100),
					"y" =              round(tech_node.y*100),
					"icon" =           "69tech_node.icon69",
					"isresearched" =   "69files.IsResearched(tech_node)69",
					"canresearch" =    "69files.CanResearch(tech_node)69",
					"description" =		"69tech_node.desc69"
				)
				tech_list += list(tech_data)

				for(var/re69_tech in tech_node.re69uired_technologies)
					var/datum/technology/other_tech = locate(re69_tech) in SSresearch.all_tech_nodes
					if(other_tech && other_tech.tech_type == tech_node.tech_type)
						var/line_x = (min(round(other_tech.x*100), round(tech_node.x*100)))
						var/line_y = (min(round(other_tech.y*100), round(tech_node.y*100)))
						var/width = (abs(round(other_tech.x*100) - round(tech_node.x*100)))
						var/height = (abs(round(other_tech.y*100) - round(tech_node.y*100)))

						var/istop = FALSE
						if(other_tech.y > tech_node.y)
							istop = TRUE
						var/isright = FALSE
						if(other_tech.x < tech_node.x)
							isright = TRUE

						var/list/line_data = list(
							"line_x" =           line_x,
							"line_y" =           line_y,
							"width" =            width,
							"height" =           height,
							"istop" =            istop,
							"isright" =          isright,
						)
						line_list += list(line_data)

		data69"techs"69 = tech_list
		data69"lines"69 = line_list
		data69"selected_tech_tree"69 = "\ref69selected_tech_tree69"
		data69"research_points"69 = files.research_points

		data69"selected_technology_id"69 = ""
		if(selected_technology)
			var/datum/technology/tech_node = selected_technology
			var/list/technology_data = list(
				"name" =           tech_node.name,
				"desc" =           tech_node.desc,
				"id" =             "\ref69tech_node69",
				"tech_type" =      tech_node.tech_type,
				"cost" =           tech_node.cost,
				"isresearched" =   files.IsResearched(tech_node),
			)
			data69"selected_technology_id"69 = "\ref69tech_node69"

			var/list/re69uirement_list = list()
			for(var/t in tech_node.re69uired_tech_levels)
				var/datum/tech/tree = locate(t) in files.researched_tech
				var/level = tech_node.re69uired_tech_levels69t69
				var/list/re69_data = list(
					"text" =           "69tree.shortname69 level 69level69",
					"isgood" =         (tree.level >= level)
				)
				re69uirement_list += list(re69_data)
			for(var/t in tech_node.re69uired_technologies)
				var/datum/technology/other_tech = locate(t) in SSresearch.all_tech_nodes
				var/list/re69_data = list(
					"text" =           "69other_tech.name69",
					"isgood" =         files.IsResearched(other_tech)
				)
				re69uirement_list += list(re69_data)
			technology_data69"re69uirements"69 = re69uirement_list

			var/list/unlock_list = list()
			for(var/T in tech_node.unlocks_designs)
				var/datum/design/D = SSresearch.get_design(T)
				if(D) // remove?
					var/list/build_types = list()
					if(D.build_type & IMPRINTER)
						build_types += "imprinter"
					if(D.build_type & PROTOLATHE)
						build_types += "protolathe"
					if(D.build_type & AUTOLATHE)
						build_types += "autolathe"
					if(D.build_type & BIOPRINTER)
						build_types += "bioprinter"
					if(D.build_type &69ECHFAB)
						build_types += "exosuit fabricator"
					if(D.build_type & ORGAN_GROWER)
						build_types += "organ grower"
					var/list/unlock_data = list(
						"text" =           "69D.name69",
						"build_types" =		english_list(build_types, "")
					)
					unlock_list += list(unlock_data)
			technology_data69"unlocks"69 = unlock_list

			data69"selected_technology"69 = technology_data

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data)
	if (!ui)
		ui =69ew(user, src, ui_key, "rdconsole.tmpl", "R&D Console", 1000, 700)

		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/rdconsole/robotics
	name = "Robotics R&D Console"
	id = 2
	re69_access = list(access_robotics)

/obj/machinery/computer/rdconsole/core
	name = "Core R&D Console"
	id = 1

#undef SCREEN_MAIN
#undef SCREEN_PROTO
#undef SCREEN_IMPRINTER
#undef SCREEN_WORKING
#undef SCREEN_TREES
#undef SCREEN_LOCKED
