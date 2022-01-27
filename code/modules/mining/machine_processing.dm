/**********************Mineral processing unit console**************************/

/obj/machinery/mineral/processing_unit_console
	name = "production69achine console"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "console"
	density = TRUE
	anchored = TRUE

	var/obj/machinery/mineral/processing_unit/machine =69ull
	var/show_all_ores = 0

/obj/machinery/mineral/processing_unit_console/New()
	..()
	spawn()
		src.machine = locate(/obj/machinery/mineral/processing_unit) in range(3, src)
		if (machine)
			machine.console = src
		else
			log_debug("69src69 (69x69,69y69,69z69) can't find coresponding processing unit.")

/obj/machinery/mineral/processing_unit_console/attack_hand(mob/user)
	add_fingerprint(user)
	interact(user)

/obj/machinery/mineral/processing_unit_console/interact(mob/user)

	if(..())
		return

	if(!allowed(user))
		to_chat(user, "\red Access denied.")
		return

	user.set_machine(src)

	var/dat = "<h1>Ore processor console</h1>"
	dat += "Currently processing <A href='?src=\ref69src69;change_sheetspertick=1'>69machine.sheets_per_tick69</a> sheets per processing cycle."
	dat += "<hr><table>"

	for(var/ore in69achine.ores_processing)

		if(!machine.ores_stored69ore69 && !show_all_ores) continue
		var/ore/O = ore_data69ore69
		if(!O) continue
		dat += "<tr><td width = 40><b>69capitalize(O.display_name)69</b></td><td width = 30>69machine.ores_stored69ore6969</td><td width = 100>"
		if(machine.ores_processing69ore69)
			switch(machine.ores_processing69ore69)
				if(0)
					dat += "<font color='red'>not processing</font>"
				if(1)
					dat += "<font color='orange'>smelting</font>"
				if(2)
					dat += "<font color='blue'>compressing</font>"
				if(3)
					dat += "<font color='gray'>alloying</font>"
		else
			dat += "<font color='red'>not processing</font>"
		dat += ".</td><td width = 30><a href='?src=\ref69src69;toggle_smelting=69ore69'>\69change\69</a></td></tr>"

	dat += "</table><hr>"
	dat += "Currently displaying 69show_all_ores ? "all ore types" : "only available ore types"69. <A href='?src=\ref69src69;toggle_ores=1'>\6969show_all_ores ? "show less" : "show69ore"69\69</a></br>"
	dat += "The ore processor is currently <A href='?src=\ref69src69;toggle_power=1'>69(machine.active ? "<font color='green'>processing</font>" : "<font color='red'>disabled</font>")69</a>."
	user << browse(dat, "window=processor_console;size=400x500")
	onclose(user, "processor_console")
	return

/obj/machinery/mineral/processing_unit_console/Topic(href, href_list)
	if(..())
		return 1
	usr.set_machine(src)

	if(href_list69"change_sheetspertick"69)
		var/spt_value = input(usr, "How69any sheets do you want to process per cycle? (max 60, default 10)", "Material Processing Rate", 10) as69ull|num
		if(!isnum(spt_value))
			return
		spt_value = clamp(spt_value, 1, 60)
		var/area/refinery_area = get_area(src)
		for(var/obj/machinery/mineral/unloading_machine/unloader in refinery_area.contents)
			unloader.unload_amt = spt_value
		machine.sheets_per_tick = spt_value
	if(href_list69"toggle_smelting"69)
		var/choice = input("What setting do you wish to use for processing 69href_list69"toggle_smelting"6969?") as69ull|anything in list("Smelting","Compressing","Alloying","Nothing")
		if(!choice) return

		switch(choice)
			if("Nothing") choice = 0
			if("Smelting") choice = 1
			if("Compressing") choice = 2
			if("Alloying") choice = 3

		machine.ores_processing69href_list69"toggle_smelting"6969 = choice

	if(href_list69"toggle_power"69)
		machine.active = !machine.active
		machine.update_icon()

	if(href_list69"toggle_ores"69)
		show_all_ores = !show_all_ores

	playsound(loc, 'sound/machines/machine_switch.ogg', 100, 1)
	src.updateUsrDialog()


/**********************Mineral processing unit**************************/


/obj/machinery/mineral/processing_unit
	name = "material processor" //This isn't actually a goddamn furnace, we're in space and it's processing platinum and flammable plasma...
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "furnace"
	density = TRUE
	anchored = TRUE
	light_range = 3
	var/obj/machinery/mineral/console =69ull
	var/sheets_per_tick = 10
	var/list/ores_processing
	var/list/ores_stored
	var/static/list/alloy_data
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
			alloy_data +=69ew alloytype()

	if(!ore_data || !ore_data.len)
		for(var/oretype in typesof(/ore)-/ore)
			var/ore/OD =69ew oretype()
			ore_data69OD.name69 = OD
			ores_processing69OD.name69 = 0
			ores_stored69OD.name69 = 0

	spawn()
		//Locate our output and input69achinery.
		var/obj/marker =69ull
		marker = locate(/obj/landmark/machinery/input) in range(1, loc)
		if(marker)
			input_dir = get_dir(src,69arker)
		marker = locate(/obj/landmark/machinery/output) in range(1, loc)
		if(marker)
			output_dir = get_dir(src,69arker)

/obj/machinery/mineral/processing_unit/update_icon()
	icon_state = "furnace69active ? "_on" : ""69"

/obj/machinery/mineral/processing_unit/Process()

	if(!output_dir || !input_dir)
		return

	var/list/tick_alloys = list()

	//Grab some69ore ore to process this tick.
	for(var/obj/item/ore/O in get_step(src, input_dir))
		if(!isnull(ores_stored69O.material69))
			ores_stored69O.material69++
		qdel(O)

	if(!active)
		return

	//Process our stored ores and spit out sheets.
	var/sheets = 0
	for(var/metal in ores_stored)

		if(sheets >= sheets_per_tick) break

		if(ores_stored69metal69 > 0 && ores_processing69metal69 != 0)

			var/ore/O = ore_data69metal69

			if(!O) continue

			if(ores_processing69metal69 == 3 && O.alloy) //Alloying.

				for(var/datum/alloy/A in alloy_data)

					if(A.metaltag in tick_alloys)
						continue

					tick_alloys += A.metaltag
					var/enough_metal

					if(!isnull(A.requires69metal69) && ores_stored69metal69 >= A.requires69metal69) //We have enough of our first69etal, we're off to a good start.

						enough_metal = 1

						for(var/needs_metal in A.requires)
							//Check if we're alloying the69eeded69etal and have it stored.
							if(ores_processing69needs_metal69 != 3 || ores_stored69needs_metal69 < A.requires69needs_metal69)
								enough_metal = 0
								break

					if(!enough_metal)
						continue
					else
						var/total
						for(var/needs_metal in A.requires)
							ores_stored69needs_metal69 -= A.requires69needs_metal69
							total += A.requires69needs_metal69
							total =69ax(1,round(total*A.product_mod)) //Always get at least one sheet.
							sheets += total-1

						for(var/i=0,i<total,i++)
							new A.product(get_step(src, output_dir))

			else if(ores_processing69metal69 == 2 && O.compresses_to) //Compressing.

				var/can_make = CLAMP(ores_stored69metal69,0,sheets_per_tick-sheets)
				if(can_make%2>0) can_make--

				var/material/M = get_material_by_name(O.compresses_to)

				if(!istype(M) || !can_make || ores_stored69metal69 < 1)
					continue

				for(var/i=0,i<can_make,i+=2)
					ores_stored69metal69-=2
					sheets+=2
					new69.stack_type(get_step(src, output_dir))

			else if(ores_processing69metal69 == 1 && O.smelts_to) //Smelting.

				var/can_make = CLAMP(ores_stored69metal69,0,sheets_per_tick-sheets)

				var/material/M = get_material_by_name(O.smelts_to)
				if(!istype(M) || !can_make || ores_stored69metal69 < 1)
					continue

				for(var/i=0,i<can_make,i++)
					ores_stored69metal69--
					sheets++
					new69.stack_type(get_step(src, output_dir))
			else
				ores_stored69metal69--
				sheets++
				new /obj/item/ore/slag(get_step(src, output_dir))
		else
			continue
	console.updateUsrDialog()
