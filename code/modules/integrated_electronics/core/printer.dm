#define69AX_CIRCUIT_CLONE_TIME 369INUTES //circuit slow-clones can only take up this amount of time to complete

/obj/item/device/integrated_circuit_printer
	name = "integrated circuit printer"
	desc = "A portable(ish)69achine69ade to print tiny69odular circuitry out of69etal."
	icon = 'icons/obj/assemblies/electronic_tools.dmi'
	icon_state = "circuit_printer"
	w_class = ITEM_SIZE_BULKY
	matter = list(MATERIAL_STEEL = 5,69ATERIAL_GLASS = 3,69ATERIAL_SILVER = 3)
	var/upgraded = FALSE		// When hit with an upgrade disk, will turn true, allowing it to print the higher tier circuits.
	var/can_clone = TRUE		// Allows the printer to clone circuits, either instantly or over time depending on upgrade. Set to FALSE to disable entirely.
	var/fast_clone = FALSE		// If this is false, then cloning will take an amount of deciseconds equal to the69etal cost divided by 100.
	var/debug = FALSE			// If it's upgraded and can clone, even without config settings.
	var/current_category = null
	var/cloning = FALSE			// If the printer is currently creating a circuit
	var/recycling = FALSE		// If an assembly is being emptied into this printer
	var/list/program			// Currently loaded save, in form of list
	var/materials = list(MATERIAL_STEEL = 0)
	var/metal_max = 25 * SHEET_MATERIAL_AMOUNT
	var/weakref/idlock = null

/obj/item/device/integrated_circuit_printer/proc/check_interactivity(mob/user)
	return CanUseTopic(user) && (get_dist(src, user) < 2)

/obj/item/device/integrated_circuit_printer/upgraded
	upgraded = TRUE
	can_clone = TRUE
	fast_clone = TRUE

/obj/item/device/integrated_circuit_printer/cyborg
	name = "cyborg integrated circuit printer"
	upgraded = TRUE
	fast_clone = TRUE
	spawn_blacklisted = TRUE

/obj/item/device/integrated_circuit_printer/debug //translation: "integrated_circuit_printer/local_server"
	name = "debug circuit printer"
	debug = TRUE
	upgraded = TRUE
	can_clone = TRUE
	fast_clone = TRUE
	spawn_blacklisted = TRUE
	w_class = ITEM_SIZE_TINY

/obj/item/device/integrated_circuit_printer/cyborg/afterattack(atom/target,69ob/user, proximity)
	if(proximity && istype(target, /obj/item/stack/material))
		var/obj/item/stack/material/O = target
		attackby(O, user)
	if(proximity && istype(target, /obj/item/device/electronic_assembly))
		var/obj/item/device/electronic_assembly/O = target
		attackby(O, user)
	if(istype(target, /obj/item/integrated_circuit))
		var/obj/item/integrated_circuit/O = target
		recycle(O, user)

/obj/item/device/integrated_circuit_printer/proc/print_program(mob/user)
	if(!cloning)
		return

	visible_message(SPAN_NOTICE("69src69 has finished printing its assembly!"))
	playsound(src, 'sound/items/poster_being_created.ogg', 50, TRUE)
	var/obj/item/device/electronic_assembly/assembly = SScircuit.load_electronic_assembly(get_turf(src), program)
	if(idlock)
		assembly.idlock = idlock
	assembly.creator = key_name(user)
	assembly.investigate_log("was printed by 69assembly.creator69.", INVESTIGATE_CIRCUIT)
	cloning = FALSE

/obj/item/device/integrated_circuit_printer/proc/recycle(obj/item/O,69ob/user, obj/item/device/electronic_assembly/assembly)
	if(!O.canremove) //in case we have an augment circuit
		return
	for(var/material in O.matter)
		if(materials69material69 + O.matter69material69 >69etal_max)
			// TODO69V69 change that after port of69aterials subsystem
			var/material/material_datum = capitalize(material)
			if(material_datum)
				to_chat(user, SPAN_NOTICE("69src69 can't hold any69ore 69material_datum69!"))
			return
	for(var/material in O.matter)
		materials69material69 += O.matter69material69
	if(assembly)
		assembly.remove_component(O)
	if(user)
		to_chat(user, SPAN_NOTICE("You recycle 69O69!"))
	qdel(O)
	return TRUE

/obj/item/device/integrated_circuit_printer/attackby(obj/item/O,69ob/user)
	if(istype(O, /obj/item/stack/material))
		var/obj/item/stack/material/M = O
		var/amt =69.amount
		if(materials69M.material.name69 ==69etal_max)
			return
		if(amt * SHEET_MATERIAL_AMOUNT +69aterials69M.material.name69 >69etal_max)
			amt = -round(-(metal_max -69aterials69M.material.name69) / SHEET_MATERIAL_AMOUNT) //round up
		if(M.use(amt))
			materials69M.material.name69 =69in(metal_max,69aterials69M.material.name69 + amt * SHEET_MATERIAL_AMOUNT)
			to_chat(user, SPAN_WARNING("You insert 69M.material.display_name69 into \the 69src69."))

	if(istype(O, /obj/item/disk/integrated_circuit/upgrade/advanced))
		if(upgraded)
			to_chat(user, SPAN_WARNING("69src69 already has this upgrade."))
			return TRUE
		to_chat(user, SPAN_NOTICE("You install 69O69 into 69src69."))
		upgraded = TRUE
		return TRUE

	if(istype(O, /obj/item/disk/integrated_circuit/upgrade/clone))
		if(fast_clone)
			to_chat(user, SPAN_WARNING("69src69 already has this upgrade."))
			return TRUE
		to_chat(user, SPAN_NOTICE("You install 69O69 into 69src69. Circuit cloning will now be instant."))
		fast_clone = TRUE
		return TRUE

	if(istype(O, /obj/item/device/electronic_assembly))
		var/obj/item/device/electronic_assembly/EA = O //microtransactions not included
		if(EA.battery)
			to_chat(user, SPAN_WARNING("Remove 69EA69's power cell first!"))
			return
		if(EA.assembly_components.len)
			if(recycling)
				return
			if(!EA.opened)
				to_chat(user, SPAN_WARNING("You can't reach 69EA69's components to remove them!"))
				return
			for(var/V in EA.assembly_components)
				var/obj/item/integrated_circuit/IC =69
				if(!IC.removable)
					to_chat(user, SPAN_WARNING("69EA69 has irremovable components in the casing, preventing you from emptying it."))
					return
			to_chat(user, SPAN_NOTICE("You begin recycling 69EA69's components..."))
			playsound(src, 'sound/items/electronic_assembly_emptying.ogg', 50, TRUE)
			if(!do_after(user, 30, target = src) || recycling) //short channel so you don't accidentally start emptying out a complex assembly
				return
			recycling = TRUE
			for(var/V in EA.assembly_components)
				var/obj/item/integrated_circuit/IC =69
				recycle(IC, user, EA)
			to_chat(user, SPAN_NOTICE("You recycle all the components69EA.assembly_components.len ? " you could " : " "69from 69EA69!"))
			playsound(src, 'sound/items/electronic_assembly_empty.ogg', 50, TRUE)
			recycling = FALSE
			return TRUE
		else
			return recycle(EA, user)

	if(istype(O, /obj/item/integrated_circuit))
		return recycle(O, user)

	if(istype(O, /obj/item/device/integrated_electronics/debugger))
		var/obj/item/device/integrated_electronics/debugger/debugger = O
		if(!debugger.idlock)
			return

		if(!idlock)
			idlock = debugger.idlock
			debugger.idlock = null
			to_chat(user, SPAN_NOTICE("You set \the 69src69 to print out id-locked assemblies only."))
			return

		if(debugger.idlock.resolve() == idlock.resolve())
			idlock = null
			debugger.idlock = null
			to_chat(user, SPAN_NOTICE("You reset \the 69src69's protection settings."))
			return

	return ..()

/obj/item/device/integrated_circuit_printer/attack_self(mob/user)
	interact(user)

/obj/item/device/integrated_circuit_printer/interact(mob/user)
	if(!(in_range(src, user) || issilicon(user)))
		return

	if(isnull(current_category))
		current_category = SScircuit.circuit_fabricator_recipe_list69169

	//Preparing the browser
	var/datum/browser/popup = new(user, "printernew", "Integrated Circuit Printer", 800, 630) // Set up the popup browser window

	var/HTML = "<center><h2>Integrated Circuit Printer</h2></center><br>"
	if(!SScircuit_components.can_fire)
		HTML += "<center><h3>INTEGRATED CIRCUITS DISABLED BY LAW-2 SECTION SMART-PEOPLE-NOT-ALLOWED. Please contact your system administrator for instructions on how to resolve this issue.</h3></center>"
		popup.set_content(HTML)
		popup.open()
		return

	if(debug)
		HTML += "<center><h3>DEBUG PRINTER -- Infinite69aterials. Cloning available.</h3></center>"
	else
		HTML += "Materials: "
		var/list/dat = list()
		for(var/material in69aterials)
			// TODO69V69 change that after port of69aterials subsystem
			// Not today, sir!
			var/material/material_datum = capitalize(material)
			dat += "69materials69material6969/69metal_max69 69material_datum69"
		HTML += jointext(dat, "; ")
		HTML += ".<br><br>"

	HTML += "Identity-lock: "
	if(idlock)
		var/obj/item/card/id/id = idlock.resolve()
		HTML+= "69id.name69 | <A href='?src=\ref69src69;id-lock=TRUE'>Reset</a><br>"
	else
		HTML += "None | Reset<br>"

	if(config.allow_ic_printing || debug)
		HTML += "Assembly cloning: 69can_clone ? (fast_clone ? "Instant" : "Available") : "Unavailable"69.<br>"

	HTML += "Circuits available: 69upgraded || debug ? "Advanced":"Regular"69."
	if(!upgraded)
		HTML += "<br>Crossed out circuits69ean that the printer is not sufficiently upgraded to create that circuit."

	HTML += "<hr>"
	if((can_clone && config.allow_ic_printing) || debug)
		HTML += "Here you can load script for your assembly.<br>"
		if(!cloning)
			HTML += " <A href='?src=\ref69src69;print=load'>Load Program</a> "
		else
			HTML += " Load Program"
		if(!program)
			HTML += " 69fast_clone ? "Print" : "Begin Printing"69 Assembly"
		else if(cloning)
			HTML += " <A href='?src=\ref69src69;print=cancel'>Cancel Print</a>"
		else
			HTML += " <A href='?src=\ref69src69;print=print'>69fast_clone ? "Print" : "Begin Printing"69 Assembly</a>"

		HTML += "<br><hr>"
	HTML += "Categories:"
	for(var/category in SScircuit.circuit_fabricator_recipe_list)
		if(category != current_category)
			HTML += " <a href='?src=\ref69src69;category=69category69'>69category69</a> "
		else // Bold the button if it's already selected.
			HTML += " <b>69category69</b> "
	HTML += "<hr>"
	HTML += "<center><h4>69current_category69</h4></center>"

	var/list/current_list = SScircuit.circuit_fabricator_recipe_list69current_category69
	for(var/path in current_list)
		var/obj/O = path
		var/can_build = TRUE
		if(ispath(path, /obj/item/integrated_circuit))
			var/obj/item/integrated_circuit/IC = path
			if((initial(IC.spawn_flags) & IC_SPAWN_RESEARCH) && (!(initial(IC.spawn_flags) & IC_SPAWN_DEFAULT)) && !upgraded)
				can_build = FALSE
		if(can_build)
			HTML += "<a href='?src=\ref69src69;build=69path69'>69initial(O.name)69</a>: 69initial(O.desc)69<br>"
		else
			HTML += "<s>69initial(O.name)69</s>: 69initial(O.desc)69<br>"

	popup.set_content(HTML)
	popup.open()

/obj/item/device/integrated_circuit_printer/Topic(href, href_list)
	if(!check_interactivity(usr))
		return
	if(..())
		return TRUE
	add_fingerprint(usr)

	if(!SScircuit_components.can_fire)
		return TRUE

	if(href_list69"id-lock"69)
		idlock = null

	if(href_list69"category"69)
		current_category = href_list69"category"69

	if(href_list69"build"69)
		var/build_type = text2path(href_list69"build"69)
		if(!build_type || !ispath(build_type))
			return TRUE

		var/list/cost
		if(ispath(build_type, /obj/item/device/electronic_assembly))
			var/obj/item/device/electronic_assembly/E = SScircuit.cached_assemblies69build_type69
			cost = E.matter
		else if(ispath(build_type, /obj/item/integrated_circuit))
			var/obj/item/integrated_circuit/IC = SScircuit.cached_components69build_type69
			cost = IC.matter
		else if(ispath(build_type, /obj/item/implant/integrated_circuit))
			var/obj/item/device/electronic_assembly/implant/E = SScircuit.cached_assemblies69/obj/item/device/electronic_assembly/implant69
			cost = E.matter
		else if(!(build_type in SScircuit.circuit_fabricator_recipe_list69"Tools"69))
			log_href_exploit(usr)
			return

		if(!debug && !subtract_material_costs(cost, usr))
			return

		var/obj/item/built = new build_type(get_turf(src))
		usr.put_in_hands(built)

		if(istype(built, /obj/item/device/electronic_assembly) || istype(built, /obj/item/implant/integrated_circuit))
			var/obj/item/device/electronic_assembly/E
			if(istype(built, /obj/item/implant/integrated_circuit))
				var/obj/item/implant/integrated_circuit/IC = built
				E = IC.IC
			else
				E = built
			E.creator = key_name(usr)
			E.opened = TRUE
			E.update_icon()
			E.investigate_log("was printed by 69E.creator69.", INVESTIGATE_CIRCUIT)

		to_chat(usr, SPAN_NOTICE("69capitalize(built.name)69 printed."))
		playsound(src, 'sound/items/jaws_pry.ogg', 50, TRUE)

	if(href_list69"print"69)
		if(!config.allow_ic_printing && !debug)
			to_chat(usr, SPAN_WARNING("CentCom has disabled printing of custom circuitry due to recent allegations of copyright infringement."))
			return
		if(!can_clone) // Copying and printing ICs is cloning
			to_chat(usr, SPAN_WARNING("This printer does not have the cloning upgrade."))
			return
		switch(href_list69"print"69)
			if("load")
				if(cloning)
					return
				var/input = sanitize(input(usr, "Put your code there:", "loading"),69ax_length =69AX_SIZE_CIRCUIT, encode = FALSE)
				if(!check_interactivity(usr) || cloning)
					return
				if(!input)
					program = null
					return

				var/validation = SScircuit.validate_electronic_assembly(input)

				//69alidation error codes are returned as text.
				if(istext(validation))
					to_chat(usr, SPAN_WARNING("Error: 69validation69"))
					return
				else if(islist(validation))
					program =69alidation
					to_chat(usr, SPAN_NOTICE("This is a69alid program for 69program69"assembly"6969"type"6969."))
					if(program69"requires_upgrades"69)
						if(upgraded)
							to_chat(usr, SPAN_NOTICE("It uses advanced component designs."))
						else
							to_chat(usr, SPAN_WARNING("It uses unknown component designs. Printer upgrade is required to proceed."))
					if(program69"unsupported_circuit"69)
						to_chat(usr, SPAN_WARNING("This program uses components not supported by the specified assembly. Please change the assembly type in the save file to a supported one."))
					to_chat(usr, SPAN_NOTICE("Used space: 69program69"used_space"6969/69program69"max_space"6969."))
					to_chat(usr, SPAN_NOTICE("Complexity: 69program69"complexity"6969/69program69"max_complexity"6969."))
					to_chat(usr, SPAN_NOTICE("Cost: 69json_encode(program69"cost"69)69."))

			if("print")
				if(!program || cloning)
					return

				if(program69"requires_upgrades"69 && !upgraded && !debug)
					to_chat(usr, SPAN_WARNING("This program uses unknown component designs. Printer upgrade is required to proceed."))
					return
				if(program69"unsupported_circuit"69 && !debug)
					to_chat(usr, SPAN_WARNING("This program uses components not supported by the specified assembly. Please change the assembly type in the save file to a supported one."))
					return
				else if(fast_clone)
					var/list/cost = program69"cost"69
					if(debug || subtract_material_costs(cost, usr))
						cloning = TRUE
						print_program(usr)
				else
					var/list/cost = program69"cost"69
					if(!subtract_material_costs(cost, usr))
						return
					var/cloning_time = 0
					for(var/material in cost)
						cloning_time += cost69material69
					cloning_time = round(cloning_time/15)
					cloning_time =69in(cloning_time,69AX_CIRCUIT_CLONE_TIME)
					cloning = TRUE
					to_chat(usr, SPAN_NOTICE("You begin printing a custom assembly. This will take approximately 69round(cloning_time/10)69 seconds. You can still print off normal parts during this time."))
					playsound(src, 'sound/items/poster_being_created.ogg', 50, TRUE)
					addtimer(CALLBACK(src, .proc/print_program, usr), cloning_time)

			if("cancel")
				if(!cloning || !program)
					return

				to_chat(usr, SPAN_NOTICE("Cloning has been canceled.69aterial cost has been refunded."))
				cloning = FALSE
				var/cost = program69"cost"69
				for(var/material in cost)
					materials69material69 =69in(metal_max,69aterials69material69 + cost69material69)

	interact(usr)

/obj/item/device/integrated_circuit_printer/proc/subtract_material_costs(list/cost,69ob/user)
	for(var/material in cost)
		if(materials69material69 < cost69material69)
			// TODO69V69 change that after port of69aterials subsystem
			var/material/material_datum = capitalize(material)
			to_chat(user, SPAN_WARNING("You need 69cost69material6969 69material_datum69 to build that!"))
			return FALSE
	for(var/material in cost) //Iterate twice to69ake sure it's going to work before deducting
		materials69material69 -= cost69material69
	return TRUE

// FUKKEN UPGRADE DISKS
/obj/item/disk/integrated_circuit/upgrade
	name = "integrated circuit printer upgrade disk"
	desc = "Install this into your integrated circuit printer to enhance it."
	icon = 'icons/obj/assemblies/electronic_tools.dmi'
	icon_state = "upgrade_disk"
	item_state = "card-id"
	w_class = ITEM_SIZE_SMALL

/obj/item/disk/integrated_circuit/upgrade/advanced
	name = "integrated circuit printer upgrade disk - advanced designs"
	desc = "Install this into your integrated circuit printer to enhance it.  This one adds new, advanced designs to the printer."

/obj/item/disk/integrated_circuit/upgrade/clone
	name = "integrated circuit printer upgrade disk - instant cloner"
	desc = "Install this into your integrated circuit printer to enhance it.  This one allows the printer to duplicate assemblies instantaneously."
	icon_state = "upgrade_disk_clone"
