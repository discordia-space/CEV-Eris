/**********************Mineral stacking unit console**************************/

/obj/machinery/mineral/stacking_unit_console
	name = "stacking machine console"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "console"
	density = 1
	anchored = 1
	var/obj/machinery/mineral/stacking_machine/machine = null

/obj/machinery/mineral/stacking_unit_console/New()
	..()

	spawn()
		src.machine = locate(/obj/machinery/mineral/stacking_machine) in range(3, src)
		if (machine)
			machine.console = src
		else
			log_debug("[src] ([x],[y],[z]) can't find coresponding staking unit.")

/obj/machinery/mineral/stacking_unit_console/attack_hand(mob/user)
	add_fingerprint(user)
	interact(user)

/obj/machinery/mineral/stacking_unit_console/interact(mob/user)
	user.set_machine(src)

	var/dat

	dat += text("<h1>Stacking unit console</h1><hr><table>")

	for(var/stacktype in machine.stack_storage)
		if(machine.stack_storage[stacktype] > 0)
			dat += "<tr><td width = 150><b>[capitalize(stacktype)]:</b></td><td width = 30>[machine.stack_storage[stacktype]]</td><td width = 50><A href='?src=\ref[src];release_stack=[stacktype]'>\[release\]</a></td></tr>"
	dat += "</table><hr>"
	dat += text("<br>Stacking: [machine.stack_amt] <A href='?src=\ref[src];change_stack=1'>\[change\]</a><br><br>")
	user << browse("[dat]", "window=console_stacking_machine")
	onclose(user, "console_stacking_machine")


/obj/machinery/mineral/stacking_unit_console/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["change_stack"])
		var/choice = input("What would you like to set the stack amount to?") as null|anything in list(1,5,10,20,50,120)
		if(!choice) return
		machine.stack_amt = choice

	if(href_list["release_stack"])
		var/material_name = href_list["release_stack"]
		machine.outputMaterial(material_name, machine.stack_amt)

	playsound(loc, 'sound/machines/machine_switch.ogg', 100, 1)
	src.updateUsrDialog()

/**********************Mineral stacking unit**************************/


/obj/machinery/mineral/stacking_machine
	name = "stacking machine"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "stacker"
	density = 1
	anchored = 1.0
	var/obj/machinery/mineral/stacking_unit_console/console
	var/input_dir = null
	var/output_dir = null
	var/list/stack_storage
	var/stack_amt = 120 // Amount to stack before releassing

/obj/machinery/mineral/stacking_machine/New()
	stack_storage = new

	//TODO: Make this dynamic based on detecting conveyor belts or something. Maybe an interface to manually configure it
	//These markers delete themselves on initialize so the machine can never be properly rebuilt during a round. This is bad.
	input_dir = NORTH //Sensible default so that the machine can at least be replaced in the same location
	output_dir = SOUTH
	spawn()
		//Locate our output and input machinery.
		var/obj/marker = null
		marker = locate(/obj/landmark/machinery/input) in range(1, loc)
		if(marker)
			input_dir = get_dir(src, marker)
		marker = locate(/obj/landmark/machinery/output) in range(1, loc)
		if(marker)
			output_dir = get_dir(src, marker)

/obj/machinery/mineral/stacking_machine/proc/outputMaterial(var/material_name, var/amount)
	var/stored_amount = stack_storage[material_name] || 0
	amount = min(stored_amount, amount)
	if (amount > 0)
		stack_storage[material_name] -= amount
		var/stacktype = material_stack_type(material_name)
		new stacktype (get_step(src, output_dir), amount)

/obj/machinery/mineral/stacking_machine/Process()
	if (src.output_dir && src.input_dir)
		var/turf/T = get_step(src, input_dir)
		for (var/obj/item/O in T.contents)
			if (istype(O))
				if (istype(O, /obj/item/stack/material))
					var/obj/item/stack/material/M = O
					if (M.material && M.material.name)
						var/material_name = M.material.name
						var/stack_amount = M.amount
						var/stored_amount = stack_storage[material_name] || 0
						stack_storage[material_name] = stored_amount + stack_amount
						qdel(M)
					else
						M.forceMove(get_step(src, output_dir))
				else
					O.forceMove(get_step(src, output_dir))

	//Output amounts that are past stack_amt.
	for (var/material_name in stack_storage)
		if (stack_storage[material_name] >= stack_amt)
			outputMaterial(material_name, stack_amt)

	console.updateUsrDialog()