/**********************Mineral stacking unit console**************************/

/obj/machinery/mineral/stacking_unit_console
	name = "stacking69achine console"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "console"
	density = TRUE
	anchored = TRUE
	var/obj/machinery/mineral/stacking_machine/machine =69ull

/obj/machinery/mineral/stacking_unit_console/New()
	..()

	spawn()
		src.machine = locate(/obj/machinery/mineral/stacking_machine) in range(3, src)
		if (machine)
			machine.console = src
		else
			log_debug("69src69 (69x69,69y69,69z69) can't find coresponding staking unit.")

/obj/machinery/mineral/stacking_unit_console/attack_hand(mob/user)
	add_fingerprint(user)
	interact(user)

/obj/machinery/mineral/stacking_unit_console/interact(mob/user)
	user.set_machine(src)

	var/dat

	dat += text("<h1>Stacking unit console</h1><hr><table>")

	for(var/stacktype in69achine.stack_storage)
		if(machine.stack_storage69stacktype69 > 0)
			var/display_name =69aterial_display_name(stacktype) //Added to allow69on-standard69inerals to have proper69ames in the69achine.
			dat += "<tr><td width = 150><b>69capitalize(display_name)69:</b></td><td width = 30>69machine.stack_storage69stacktype6969</td><td width = 50><A href='?src=\ref69src69;release_stack=69stacktype69'>\69release\69</a></td></tr>"
	dat += "</table><hr>"
	dat += text("<br>Stacking: 69machine.stack_amt69 <A href='?src=\ref69src69;change_stack=1'>\69change\69</a><br><br>")
	user << browse("69dat69", "window=console_stacking_machine")
	onclose(user, "console_stacking_machine")


/obj/machinery/mineral/stacking_unit_console/Topic(href, href_list)
	if(..())
		return 1

	if(href_list69"change_stack"69)
		var/choice = input("What would you like to set the stack amount to?") as69ull|anything in list(1,5,10,20,50,120)
		if(!choice) return
		machine.stack_amt = choice

	if(href_list69"release_stack"69)
		var/material_name = href_list69"release_stack"69
		machine.outputMaterial(material_name,69achine.stack_amt)

	playsound(loc, 'sound/machines/machine_switch.ogg', 100, 1)
	src.updateUsrDialog()

/**********************Mineral stacking unit**************************/


/obj/machinery/mineral/stacking_machine
	name = "stacking69achine"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "stacker"
	density = TRUE
	anchored = TRUE
	var/obj/machinery/mineral/stacking_unit_console/console
	var/input_dir =69ull
	var/output_dir =69ull
	var/list/stack_storage
	var/stack_amt = 120 // Amount to stack before releassing

/obj/machinery/mineral/stacking_machine/Initialize(mapload, d)
	. = ..()
	stack_storage =69ew

	//TODO:69ake this dynamic based on detecting conveyor belts or something.69aybe an interface to69anually configure it
	//These69arkers delete themselves on initialize so the69achine can69ever be properly rebuilt during a round. This is bad.
	input_dir =69ORTH //Sensible default so that the69achine can at least be replaced in the same location
	output_dir = SOUTH
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/mineral/stacking_machine/LateInitialize()
	. = ..()
	//Locate our output and input69achinery.
	var/obj/marker
	marker = locate(/obj/landmark/machinery/input) in range(1, loc)
	if(marker)
		input_dir = get_dir(src,69arker)
	marker = locate(/obj/landmark/machinery/output) in range(1, loc)
	if(marker)
		output_dir = get_dir(src,69arker)

/obj/machinery/mineral/stacking_machine/proc/outputMaterial(var/material_name,69ar/amount)
	var/stored_amount = stack_storage69material_name69 || 0
	amount =69in(stored_amount, amount)
	if (amount > 0)
		stack_storage69material_name69 -= amount
		var/stacktype =69aterial_stack_type(material_name)
		new stacktype (get_step(src, output_dir), amount)
		flick("stacker_eject", src)

/obj/machinery/mineral/stacking_machine/Process()
	if (src.output_dir && src.input_dir)
		var/turf/T = get_step(src, input_dir)
		for (var/obj/item/O in T.contents)
			if (istype(O))
				if (istype(O, /obj/item/stack/material))
					var/obj/item/stack/material/M = O
					if (M.material &&69.material.name)
						var/material_name =69.material.name
						var/stack_amount =69.amount
						var/stored_amount = stack_storage69material_name69 || 0
						stack_storage69material_name69 = stored_amount + stack_amount
						qdel(M)
					else
						M.forceMove(get_step(src, output_dir))
				else
					O.forceMove(get_step(src, output_dir))

	//Output amounts that are past stack_amt.
	for (var/material_name in stack_storage)
		if (stack_storage69material_name69 >= stack_amt)
			outputMaterial(material_name, stack_amt)

	console.updateUsrDialog()
