#define ORE_STORING 0
#define ORE_SMELTING 1
#define ORE_COMPRESSING 2
#define ORE_ALLOYING 3

/**********************Mineral processing unit console**************************/

/obj/machinery/mineral/processing_unit_console
	name = "production machine console"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "console"
	density = TRUE
	anchored = TRUE

	var/obj/machinery/mineral/processing_unit/machine = null
	var/show_all_ores = 0

/obj/machinery/mineral/processing_unit_console/New()
	..()
	spawn()
		src.machine = locate(/obj/machinery/mineral/processing_unit) in range(3, src)
		if (machine)
			machine.console = src
		else
			log_debug("[src] ([x],[y],[z]) can't find coresponding processing unit.")

/obj/machinery/mineral/processing_unit_console/attack_hand(mob/user)
	add_fingerprint(user)
	interact(user)

/obj/machinery/mineral/processing_unit_console/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Processor")
		ui.open()

/obj/machinery/mineral/processing_unit_console/ui_data(mob/user)
	var/list/data = list()
	data["machine"] = !!machine
	if(!machine)
		return data
	data["materials_data"] = list()
	for(var/ore in ore_data)
		var/list/ore_list = list()
		var/ore/ore_thing = ore_data[ore]
		ore_list["name"] = ore_thing.display_name
		ore_list["id"] = ore
		ore_list["current_action"] = machine.ores_processing[ore]
		ore_list["amount"] = machine.ores_stored[ore]
		switch(machine.ores_processing[ore])
			if(ORE_STORING)
				ore_list["current_action_string"] = "Storing"
			if(ORE_SMELTING)
				ore_list["current_action_string"] = "Smelting"
			if(ORE_COMPRESSING)
				ore_list["current_action_string"] = "Compressing"
			if(ORE_ALLOYING)
				ore_list["current_action_string"] = "Alloying"
		data["materials_data"] += list(ore_list)
	data["alloy_data"] = list()
	for(var/datum/alloy/alloy in machine.alloy_data)
		var/list/alloy_list = list()
		alloy_list["name"] = alloy.name
		alloy_list["creating"] = TRUE
		data["alloy_data"] += list(alloy_list)
	data["currently_alloying"] = machine.selected_alloy
	data["running"] = machine.active
	data["sheet_rate"] = machine.sheets_per_tick
	return data

/obj/machinery/mineral/processing_unit_console/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return
	if(action == "set_alloying")
		var/target_name = params["id"]
		for(var/datum/alloy/the_alloy in machine.alloy_data)
			if(target_name == the_alloy.name)
				machine.selected_alloy = the_alloy
				for(var/required in machine.selected_alloy.requires)
					machine.ores_processing[required] = ORE_ALLOYING
		return TRUE
	if(action == "set_smelting")
		var/target_material = params["id"]
		var/processing_type = params["action_type"]
		if(processing_type > ORE_ALLOYING)
			processing_type = ORE_STORING
		machine.ores_processing[target_material] = processing_type
		return TRUE
	if(action == "set_running")
		machine.active = !(machine.active)
		return TRUE
	if(action == "set_rate")
		machine.sheets_per_tick = params["sheets"]
		return TRUE
	if(action == "machine_link")
		machine = locate(/obj/machinery/mineral/processing_unit) in range(3, src)
		if (machine)
			machine.console = src
		return TRUE



/obj/machinery/mineral/processing_unit_console/interact(mob/user)
	if(..())
		return
	if(!allowed(user))
		to_chat(user, "\red Access denied.")
		return
	ui_interact(user)

/**********************Mineral processing unit**************************/


/obj/machinery/mineral/processing_unit
	name = "material processor" //This isn't actually a goddamn furnace, we're in space and it's processing platinum and flammable plasma...
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "furnace"
	density = TRUE
	anchored = TRUE
	light_range = 3

	var/obj/machinery/mineral/console = null
	var/sheets_per_tick = 10
	var/list/ores_processing
	var/list/ores_stored
	var/static/list/alloy_data
	var/datum/alloy/selected_alloy = null
	var/active = 0
	var/input_dir = 0
	var/output_dir = 0

/obj/machinery/mineral/processing_unit/New()
	..()

	ores_processing = list()
	ores_stored = list()

	// initialize static alloy_data list
	if(!alloy_data)
		alloy_data = list()
		for(var/alloytype in typesof(/datum/alloy)-/datum/alloy)
			alloy_data += new alloytype()

	if(!ore_data || !ore_data.len)
		for(var/oretype in typesof(/ore)-/ore)
			var/ore/OD = new oretype()
			ore_data[OD.name] = OD
			ores_processing[OD.name] = 0
			ores_stored[OD.name] = 0

	spawn()
		//Locate our output and input machinery.
		var/obj/marker = null
		marker = locate(/obj/landmark/machinery/input) in range(1, loc)
		if(marker)
			input_dir = get_dir(src, marker)
		marker = locate(/obj/landmark/machinery/output) in range(1, loc)
		if(marker)
			output_dir = get_dir(src, marker)

/obj/machinery/mineral/processing_unit/update_icon()
	icon_state = "furnace[active ? "_on" : ""]"

/obj/machinery/mineral/processing_unit/Process()

	if(!output_dir || !input_dir)
		return
	//Grab some more ore to process this tick.
	for(var/obj/item/ore/O in get_step(src, input_dir))
		if(!isnull(ores_stored[O.material]))
			ores_stored[O.material]++
		qdel(O)
	if(!active)
		return
	//Process our stored ores and spit out sheets.
	var/sheets_to_process = sheets_per_tick
	// So it doesn't get changed mid-process and leads to funny glitches / dupings by switching it mid-process
	var/datum/alloy/cur_alloy = selected_alloy
	var/produced_sheets = 0
	while(sheets_to_process && cur_alloy)
		var/valid = TRUE
		for(var/required_ore in cur_alloy.requires)
			if(ores_processing[required_ore] != ORE_ALLOYING)
				valid = FALSE
				break
			if(ores_stored[required_ore] < cur_alloy.requires[required_ore])
				valid = FALSE
				break
		if(!valid)
			break
		for(var/required_ore in cur_alloy.requires)
			ores_stored[required_ore] -= cur_alloy.requires[required_ore]
		produced_sheets += cur_alloy.product_mod * cur_alloy.ore_input
		sheets_to_process--
	sheets_to_process = sheets_per_tick - round(produced_sheets)
	while(round(produced_sheets) > 0)
		new cur_alloy.product(get_step(src, output_dir))
		produced_sheets--
	for(var/ore in ores_processing)
		if(sheets_to_process < 1)
			break
		if(ores_processing[ore] == ORE_ALLOYING)
			continue
		if(ores_processing[ore] == ORE_STORING)
			continue
		/// Would've named this ore_data , but it gives infinite cross reference ( and also conflicts with the global version)
		var/ore/stored_ore_data = ore_data[ore]
		if(ores_processing[ore] == ORE_SMELTING && stored_ore_data.smelts_to)
			if(ores_stored[ore] < 1)
				continue
			var/sheet_amount = min(round(ores_stored[ore]), sheets_per_tick)
			sheet_amount = min(sheet_amount, sheets_to_process)
			sheets_to_process -= sheet_amount
			var/material/product = get_material_by_name(stored_ore_data.smelts_to)
			while(sheet_amount)
				new product.stack_type(get_step(src, output_dir))
				sheet_amount--
				ores_stored[ore]--
		if(ores_processing[ore] == ORE_COMPRESSING && stored_ore_data.compresses_to)
			if(ores_stored[ore] < 2)
				continue
			var/sheet_amount = min(round(ores_stored[ore] / 2), round(sheets_per_tick / 2))
			sheet_amount = min(sheet_amount, sheets_to_process)
			sheets_to_process -= sheet_amount
			var/material/product = get_material_by_name(stored_ore_data.compresses_to)
			while(sheet_amount)
				new product.stack_type(get_step(src, output_dir))
				sheet_amount--
				ores_stored[ore] -= 2
	return

