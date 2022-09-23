/obj/item/integrated_circuit
	name = "integrated circuit"
	desc = "A tiny chip!  This one doesn't seem to do much, however."
	icon = 'icons/obj/assemblies/electronic_components.dmi'
	icon_state = "template"
	w_class = ITEM_SIZE_TINY
	matter = list()				// To be filled later
	var/obj/item/device/electronic_assembly/assembly // Reference to the assembly holding this circuit, if any.
	var/extended_desc
	var/list/inputs = list()
	var/list/inputs_default = list()// Assoc list which will fill a pin with data upon creation.  e.g. "2" = 0 will set input pin 2 to equal 0 instead of null.
	var/list/outputs = list()
	var/list/outputs_default =list()// Ditto, for output.
	var/list/activators = list()
	var/next_use = 0 				// Uses world.time
	var/complexity = 1 				// This acts as a limitation on building machines, more resource-intensive components cost more 'space'.
	var/size = 1					// This acts as a limitation on building machines, bigger components cost more 'space'. -1 for size 0
	var/cooldown_per_use = 1		// Circuits are limited in how many times they can be work()'d by this variable.
	var/ext_cooldown = 0			// Circuits are limited in how many times they can be work()'d with external world by this variable.
	var/power_draw_per_use = 0 		// How much power is drawn when work()'d.
	var/power_draw_idle = 0			// How much power is drawn when doing nothing.
	var/spawn_flags					// Used for world initializing, see the #defines above.
	var/action_flags = null			// Used for telling circuits that can do certain actions from other circuits.
	var/category_text = "NO CATEGORY THIS IS A BUG"	// To show up on circuit printer, and perhaps other places.
	var/removable = TRUE 			// Determines if a circuit is removable from the assembly.
	var/displayed_name = ""
	var/demands_object_input = FALSE
	var/can_input_object_when_closed = FALSE
	var/max_allowed = 0				// The maximum amount of components allowed inside an integrated circuit.
	var/ext_moved_triggerable = FALSE // Used to tell assembly if we need moved event
	var/moved_event_created = FALSE // check this var on delete and if this var true delete ext_moved event
	var/atom/movable/moved_object // used for check if we already have moved event
	var/radial_menu_icon = "" // used for radial menu selection


/*
	Integrated circuits are essentially modular machines.  Each circuit has a specific function, and combining them inside Electronic Assemblies allows
a creative player the means to solve many problems.  Circuits are held inside an electronic assembly, and are wired using special tools.
*/

/obj/item/integrated_circuit/examine(mob/user)
	interact(user)
	external_examine(user)
	. = ..()

/obj/item/integrated_circuit/attack_self(mob/user)
	if(isrobot(user))
		interact(user)
	..()

/obj/item/integrated_circuit/attack_hand(mob/user)
	// if in assembly override putting src into user hands
	if(istype(assembly))
		attack_self(user)
	else
		..()

// Can be called via electronic_assembly/attackby()
/obj/item/integrated_circuit/proc/additem(obj/item/I, mob/living/user)
	attackby(I, user)

// This should be used when someone is examining while the case is opened.
/obj/item/integrated_circuit/proc/internal_examine(mob/user)
	to_chat(user, "This board has [inputs.len] input pin\s, [outputs.len] output pin\s and [activators.len] activation pin\s.")
	for(var/k in inputs)
		var/datum/integrated_io/I = k
		if(I.linked.len)
			to_chat(user, "The '[I]' is connected to [I.get_linked_to_desc()].")
	for(var/k in outputs)
		var/datum/integrated_io/O = k
		if(O.linked.len)
			to_chat(user, "The '[O]' is connected to [O.get_linked_to_desc()].")
	for(var/k in activators)
		var/datum/integrated_io/activate/A = k
		if(A.linked.len)
			to_chat(user, "The '[A]' is connected to [A.get_linked_to_desc()].")
	any_examine(user)
	interact(user)

// This should be used when someone is examining from an 'outside' perspective, e.g. reading a screen or LED.
/obj/item/integrated_circuit/proc/external_examine(mob/user)
	any_examine(user)

/obj/item/integrated_circuit/proc/any_examine(mob/user)
	return

/obj/item/integrated_circuit/proc/attackby_react(atom/movable/A,mob/user)
	return

/obj/item/integrated_circuit/proc/sense(atom/movable/A,mob/user,prox)
	return

/obj/item/integrated_circuit/proc/check_interactivity(mob/user)
	if(assembly)
		return assembly.check_interactivity(user)
	else
		if(isrobot(user))
			return TRUE
		return CanUseTopic(user)

/obj/item/integrated_circuit/Initialize()
	. = ..()
	displayed_name = name
	setup_io(inputs, /datum/integrated_io, inputs_default, IC_INPUT)
	setup_io(outputs, /datum/integrated_io, outputs_default, IC_OUTPUT)
	setup_io(activators, /datum/integrated_io/activate, null, IC_ACTIVATOR)
	if(!matter[MATERIAL_STEEL])
		matter[MATERIAL_STEEL] = w_class * SScircuit.cost_multiplier // Default cost.

/obj/item/integrated_circuit/proc/get_power_cell(atom/movable/AM)
	var/efficient = 1
	var/obj/item/cell/small/cell
	// add below cell getting code from device to get correct cell
	if(isrobot(AM))
		var/mob/living/silicon/robot/R = AM
		efficient = 0.9
		cell = R.cell

	else if(istype(AM, /obj/item/cell/small))
		cell = AM

	else if(istype(AM, /obj/machinery/power/apc))
		var/obj/machinery/power/apc/A = AM
		cell = A.cell

	else if(istype(AM, /obj/machinery/mining/deep_drill))
		var/obj/machinery/mining/deep_drill/hdrill = AM
		cell = hdrill.cell

	else if(istype(AM, /obj/item/gun/energy))
		var/obj/item/gun/energy/WEP = AM
		cell = WEP.cell
		efficient = 0.6

	return list(cell, efficient)

// called when we add component to assembly
/obj/item/integrated_circuit/proc/create_moved_event()
	if(moved_event_created) // if moved event already created, rerigester it
		GLOB.moved_event.unregister(moved_object, src)
	if(ext_moved_triggerable)
		moved_event_created = TRUE
		moved_object = get_object()
		GLOB.moved_event.register(moved_object, src, .proc/ext_moved)

/obj/item/integrated_circuit/proc/on_data_written() //Override this for special behaviour when new data gets pushed to the circuit.
	return

// called when we are remove src from assembly
// created for not to use moved_event when we are not in assembly.
/obj/item/integrated_circuit/proc/removed_from_assembly()
	if(ext_moved_triggerable && moved_event_created)
		GLOB.moved_event.unregister(moved_object, src)

/obj/item/integrated_circuit/Destroy()
	. = ..()
	QDEL_LIST(inputs)
	QDEL_LIST(outputs)
	QDEL_LIST(activators)
	SScircuit_components.dequeue_component(src)
	if(ext_moved_triggerable && moved_event_created)
		GLOB.moved_event.unregister(moved_object, src)

/obj/item/integrated_circuit/emp_act(severity)
	for(var/k in inputs)
		var/datum/integrated_io/I = k
		I.scramble()
	for(var/k in outputs)
		var/datum/integrated_io/O = k
		O.scramble()
	for(var/k in activators)
		var/datum/integrated_io/activate/A = k
		A.scramble()


/obj/item/integrated_circuit/verb/rename_component()
	set name = "Rename Circuit"
	set category = "Object"
	set desc = "Rename your circuit, useful to stay organized."

	var/mob/M = usr
	if(!check_interactivity(M))
		return

	var/input = sanitizeName(input(M, "What do you want to name this?", "Rename", name) as null|text, allow_numbers = TRUE)
	if(check_interactivity(M))
		if(!input)
			input = name
		to_chat(M, SPAN_NOTICE("The circuit '[name]' is now labeled '[input]'."))
		displayed_name = input

/obj/item/integrated_circuit/interact(mob/user)
	nano_ui_interact(user)

/obj/item/integrated_circuit/nano_ui_interact(mob/user)
	. = ..()
	if(!check_interactivity(user))
		return

	if(assembly)
		assembly.nano_ui_interact(user, src)
		return

	var/table_edge_width = "30%"
	var/table_middle_width = "40%"

	var/datum/browser/popup = new(user, "scannernew", name, 800, 630) // Set up the popup browser window
	popup.add_stylesheet("scannernew", 'html/browser/assembly_ui.css')

	var/HTML = "<html><head><title>[src.displayed_name]</title></head><body> \
		<div align='center'> \
		<table border='1' style='undefined;table-layout: fixed; width: 80%'>"

	if(assembly)
		HTML += "<a href='?src=\ref[src];return=1'>Return to Assembly</a><br>"

	HTML += "<a href='?src=\ref[src]'>Refresh</a>  |  \
		<a href='?src=\ref[src];rename=1'>Rename</a>  |  \
		<a href='?src=\ref[src];scan=1'>Copy Ref</a>"

	if(assembly && removable)
		HTML += "  |  <a href='?src=\ref[assembly];component=\ref[src];remove=1'>Remove</a>"

	HTML += "<br><colgroup> \
		<col style='width: [table_edge_width]'> \
		<col style='width: [table_middle_width]'> \
		<col style='width: [table_edge_width]'> \
		</colgroup>"

	var/column_width = 3
	var/row_height = max(inputs.len, outputs.len, 1)

	for(var/i = 1 to row_height)
		HTML += "<tr>"
		for(var/j = 1 to column_width)
			var/datum/integrated_io/io = null
			var/words
			var/height = 1
			switch(j)
				if(1)
					io = get_pin_ref(IC_INPUT, i)
					if(io)
						words += "<b><a href='?src=\ref[src];act=wire;pin=\ref[io]'>[io.display_pin_type()] [io.name]</a> \
							<a href='?src=\ref[src];act=data;pin=\ref[io]'>[io.display_data(io.data)]</a></b><br>"
						if(io.linked.len)
							words += "<ul>"
							for(var/k in io.linked)
								var/datum/integrated_io/linked = k
								words += "<li><a href='?src=\ref[src];act=unwire;pin=\ref[io];link=\ref[linked]'>[linked]</a> \
									@ <a href='?src=\ref[linked.holder]'>[linked.holder.displayed_name]</a></li>"
							words += "</ul>"

						if(outputs.len > inputs.len)
							height = 1
				if(2)
					if(i == 1)
						words += "[displayed_name]<br>[name != displayed_name ? "([name])":""]<hr>[desc]"
						height = row_height
				if(3)
					io = get_pin_ref(IC_OUTPUT, i)
					if(io)
						words += "<b><a href='?src=\ref[src];act=wire;pin=\ref[io]'>[io.display_pin_type()] [io.name]</a> \
							<a href='?src=\ref[src];act=data;pin=\ref[io]'>[io.display_data(io.data)]</a></b><br>"
						if(io.linked.len)
							words += "<ul>"
							for(var/k in io.linked)
								var/datum/integrated_io/linked = k
								words += "<li><a href='?src=\ref[src];act=unwire;pin=\ref[io];link=\ref[linked]'>[linked]</a> \
									@ <a href='?src=\ref[linked.holder]'>[linked.holder.displayed_name]</a></li>"
							words += "</ul>"

						if(inputs.len > outputs.len)
							height = 1
			HTML += "<td align='center' rowspan='[height]'>[words]</td>"
		HTML += "</tr>"

	for(var/activator in activators)
		var/datum/integrated_io/io = activator
		var/words

		words += "<b><a href='?src=\ref[src];act=wire;pin=\ref[io]'>[io]</a> \
			<a href='?src=\ref[src];act=data;pin=\ref[io]'>[io.data?"\<PULSE OUT\>":"\<PULSE IN\>"]</a></b><br>"

		if(io.linked.len)
			words += "<ul>"
			for(var/k in io.linked)
				var/datum/integrated_io/linked = k
				words += "<li><a href='?src=\ref[src];act=unwire;pin=\ref[io];link=\ref[linked]'>[linked]</a> \
					@ <a href='?src=\ref[linked.holder]'>[linked.holder.displayed_name]</a></li>"
			words += "<ul>"

		HTML += "<tr><td colspan='3' align='center'>[words]</td></tr>"

	HTML += "</table></div> \
		<br>Complexity: [complexity] \
		<br>Cooldown per use: [cooldown_per_use/10] sec \
		[max_allowed ? "<br>Maximum per circuit: [max_allowed]" : ""]"

	if(ext_cooldown)
		HTML += "<br>External manipulation cooldown: [ext_cooldown/10] sec"
	if(power_draw_idle)
		HTML += "<br>Power Draw: [power_draw_idle] W (Idle)"
	if(power_draw_per_use)
		HTML += "<br>Power Draw: [power_draw_per_use] W (Active)" // Borgcode says that powercells' checked_use() takes joules as input.

	HTML += "<br>[extended_desc]</body></html>"

	popup.set_content(HTML)
	popup.open()

/obj/item/integrated_circuit/Topic(href, href_list, state = GLOB.physical_state)
	if(!check_interactivity(usr))
		return
	/*
	I hope state check doesn't required there because of check_interactivity do some stuff with
	checking state, if it lead to butthurt bugs, I'm sorry.
	P.S. someone who wrote proc shared_living_nano_distance should be purged
	and sorry for commented code, if you brave enough please find out where I done mistake(s).
	*/
	// if(..())
	// 	return TRUE

	var/update = TRUE
	var/update_to_assembly = FALSE

	var/obj/item/held_item = usr.get_active_hand()

	if(href_list["rename"])
		rename_component(usr)
		if(assembly)
			assembly.add_allowed_scanner(usr.ckey)

	if(href_list["pin"])
		var/datum/integrated_io/pin = locate(href_list["pin"]) in inputs + outputs + activators
		if(pin)
			var/datum/integrated_io/linked
			var/success = TRUE
			if(href_list["link"])
				linked = locate(href_list["link"]) in pin.linked

			if(istype(held_item, /obj/item/device/integrated_electronics) || isMultitool(held_item))
				update_to_assembly = pin.handle_wire(linked, held_item, href_list["act"], usr)
			else
				to_chat(usr, SPAN_WARNING("You can't do a whole lot without the proper tools."))
				success = FALSE
			if(success && assembly)
				assembly.add_allowed_scanner(usr.ckey)

	if(href_list["scan"])
		if(istype(held_item, /obj/item/device/integrated_electronics/debugger))
			var/obj/item/device/integrated_electronics/debugger/D = held_item
			if(D.accepting_refs)
				D.afterattack(src, usr, TRUE)
			else
				to_chat(usr, SPAN_WARNING("The debugger's 'ref scanner' needs to be on."))
		else
			to_chat(usr, SPAN_WARNING("You need a debugger set to 'ref' mode to do that."))

	if(href_list["return"])
		update_to_assembly = TRUE

	if(href_list["ic_window"] && assembly && assembly.use_ui_window)
		. = OnICTopic(href_list, usr)

	if(assembly && !assembly.opened && update)
		update = FALSE

	if(update)
		if(assembly && (update_to_assembly || . == IC_TOPIC_REFRESH))
			assembly.interact(usr, src)
		else
			interact(usr) // To refresh the UI.

/obj/item/integrated_circuit/proc/push_data()
	for(var/k in outputs)
		var/datum/integrated_io/O = k
		O.push_data()

/obj/item/integrated_circuit/proc/pull_data()
	for(var/k in inputs)
		var/datum/integrated_io/I = k
		I.push_data()

/obj/item/integrated_circuit/proc/draw_idle_power()
	if(assembly)
		return assembly.draw_power(power_draw_idle)

/obj/item/integrated_circuit/proc/OnICTopic(href_list, user)
	return

/obj/item/integrated_circuit/proc/get_topic_data(mob/user)
	return

// Override this for special behaviour when there's no power left.
/obj/item/integrated_circuit/proc/power_fail()
	return

// Returns true if there's enough power to work().
/obj/item/integrated_circuit/proc/check_power()
	if(!assembly)
		return FALSE // Not in an assembly, therefore no power.
	if(assembly.draw_power(power_draw_per_use))
		return TRUE // Battery has enough.
	return FALSE // Not enough power.

/obj/item/integrated_circuit/proc/check_then_do_work(ord,var/ignore_power = FALSE)
	if(world.time < next_use) 	// All intergrated circuits have an internal cooldown, to protect from spam.
		return FALSE
	if(assembly && ext_cooldown && (world.time < assembly.ext_next_use)) 	// Some circuits have external cooldown, to protect from spam.
		return FALSE
	if(power_draw_per_use && !ignore_power)
		if(!check_power())
			power_fail()
			return FALSE
	next_use = world.time + cooldown_per_use
	if(assembly)
		assembly.ext_next_use = world.time + ext_cooldown
	do_work(ord)
	return TRUE

/obj/item/integrated_circuit/proc/do_work(ord)
	return

/obj/item/integrated_circuit/proc/disconnect_all()
	var/datum/integrated_io/I

	for(var/i in inputs)
		I = i
		I.disconnect_all()

	for(var/i in outputs)
		I = i
		I.disconnect_all()

	for(var/i in activators)
		I = i
		I.disconnect_all()

/obj/item/integrated_circuit/proc/ext_moved()
	if(assembly)
		assembly.update_light() //Update lighting objects (From light circuits).
	return


// Returns the object that is supposed to be used in attack messages, location checks, etc.
/obj/item/integrated_circuit/proc/get_object()
	// If the component is located in an assembly, let assembly determine it.
	if(assembly)
		return assembly.get_object()
	else
		return src	// If not, the component is acting on its own.


// Checks if the target object is reachable. Useful for various manipulators and manipulator-like objects.
/obj/item/integrated_circuit/proc/check_target(atom/target, exclude_contents = FALSE, exclude_components = FALSE, exclude_self = FALSE)
	if(!target)
		return FALSE

	var/atom/movable/acting_object = get_object()

	if(exclude_self && target == acting_object)
		return FALSE

	if(exclude_components && assembly)
		if(target in assembly.assembly_components)
			return FALSE

		if(target == assembly.battery)
			return FALSE

	if(target.Adjacent(acting_object) && isturf(target.loc))
		return TRUE

	if(!exclude_contents && (target in acting_object.GetAllContents()))
		return TRUE

	if(target in acting_object.loc)
		return TRUE

	return FALSE
