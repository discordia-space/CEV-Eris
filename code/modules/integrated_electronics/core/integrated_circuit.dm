/obj/item/integrated_circuit
	name = "integrated circuit"
	desc = "A tiny chip!  This one doesn't seem to do69uch, however."
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
	var/complexity = 1 				// This acts as a limitation on building69achines,69ore resource-intensive components cost69ore 'space'.
	var/size = 1					// This acts as a limitation on building69achines, bigger components cost69ore 'space'. -1 for size 0
	var/cooldown_per_use = 1		// Circuits are limited in how69any times they can be work()'d by this69ariable.
	var/ext_cooldown = 0			// Circuits are limited in how69any times they can be work()'d with external world by this69ariable.
	var/power_draw_per_use = 0 		// How69uch power is drawn when work()'d.
	var/power_draw_idle = 0			// How69uch power is drawn when doing nothing.
	var/spawn_flags					// Used for world initializing, see the #defines above.
	var/action_flags = null			// Used for telling circuits that can do certain actions from other circuits.
	var/category_text = "NO CATEGORY THIS IS A BUG"	// To show up on circuit printer, and perhaps other places.
	var/removable = TRUE 			// Determines if a circuit is removable from the assembly.
	var/displayed_name = ""
	var/demands_object_input = FALSE
	var/can_input_object_when_closed = FALSE
	var/max_allowed = 0				// The69aximum amount of components allowed inside an integrated circuit.
	var/ext_moved_triggerable = FALSE // Used to tell assembly if we need69oved event
	var/moved_event_created = FALSE // check this69ar on delete and if this69ar true delete ext_moved event
	var/atom/movable/moved_object // used for check if we already have69oved event
	var/radial_menu_icon = "" // used for radial69enu selection


/*
	Integrated circuits are essentially69odular69achines.  Each circuit has a specific function, and combining them inside Electronic Assemblies allows
a creative player the69eans to solve69any problems.  Circuits are held inside an electronic assembly, and are wired using special tools.
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

// Can be called69ia electronic_assembly/attackby()
/obj/item/integrated_circuit/proc/additem(obj/item/I,69ob/living/user)
	attackby(I, user)

// This should be used when someone is examining while the case is opened.
/obj/item/integrated_circuit/proc/internal_examine(mob/user)
	to_chat(user, "This board has 69inputs.len69 input pin\s, 69outputs.len69 output pin\s and 69activators.len69 activation pin\s.")
	for(var/k in inputs)
		var/datum/integrated_io/I = k
		if(I.linked.len)
			to_chat(user, "The '69I69' is connected to 69I.get_linked_to_desc()69.")
	for(var/k in outputs)
		var/datum/integrated_io/O = k
		if(O.linked.len)
			to_chat(user, "The '69O69' is connected to 69O.get_linked_to_desc()69.")
	for(var/k in activators)
		var/datum/integrated_io/activate/A = k
		if(A.linked.len)
			to_chat(user, "The '69A69' is connected to 69A.get_linked_to_desc()69.")
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
	if(!matter69MATERIAL_STEEL69)
		matter69MATERIAL_STEEL69 = w_class * SScircuit.cost_multiplier // Default cost.

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

	else if(istype(AM, /obj/machinery/mining/drill))
		var/obj/machinery/mining/drill/hdrill = AM
		cell = hdrill.cell

	else if(istype(AM, /obj/item/gun/energy))
		var/obj/item/gun/energy/WEP = AM
		cell = WEP.cell
		efficient = 0.6

	return list(cell, efficient)

// called when we add component to assembly
/obj/item/integrated_circuit/proc/create_moved_event()
	if(moved_event_created) // if69oved event already created, rerigester it
		GLOB.moved_event.unregister(moved_object, src)
	if(ext_moved_triggerable)
		moved_event_created = TRUE
		moved_object = get_object()
		GLOB.moved_event.register(moved_object, src, .proc/ext_moved)

/obj/item/integrated_circuit/proc/on_data_written() //Override this for special behaviour when new data gets pushed to the circuit.
	return

// called when we are remove src from assembly
// created for not to use69oved_event when we are not in assembly.
/obj/item/integrated_circuit/proc/removed_from_assembly()
	if(ext_moved_triggerable &&69oved_event_created)
		GLOB.moved_event.unregister(moved_object, src)

/obj/item/integrated_circuit/Destroy()
	. = ..()
	QDEL_CLEAR_LIST(inputs)
	QDEL_CLEAR_LIST(outputs)
	QDEL_CLEAR_LIST(activators)
	SScircuit_components.dequeue_component(src)
	if(ext_moved_triggerable &&69oved_event_created)
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
		to_chat(M, SPAN_NOTICE("The circuit '69name69' is now labeled '69input69'."))
		displayed_name = input

/obj/item/integrated_circuit/interact(mob/user)
	ui_interact(user)

/obj/item/integrated_circuit/ui_interact(mob/user)
	. = ..()
	if(!check_interactivity(user))
		return

	if(assembly)
		assembly.ui_interact(user, src)
		return

	var/table_edge_width = "30%"
	var/table_middle_width = "40%"

	var/datum/browser/popup = new(user, "scannernew", name, 800, 630) // Set up the popup browser window
	popup.add_stylesheet("scannernew", 'html/browser/assembly_ui.css')

	var/HTML = "<html><head><title>69src.displayed_name69</title></head><body> \
		<div align='center'> \
		<table border='1' style='undefined;table-layout: fixed; width: 80%'>"

	if(assembly)
		HTML += "<a href='?src=\ref69src69;return=1'>Return to Assembly</a><br>"

	HTML += "<a href='?src=\ref69src69'>Refresh</a>  |  \
		<a href='?src=\ref69src69;rename=1'>Rename</a>  |  \
		<a href='?src=\ref69src69;scan=1'>Copy Ref</a>"

	if(assembly && removable)
		HTML += "  |  <a href='?src=\ref69assembly69;component=\ref69src69;remove=1'>Remove</a>"

	HTML += "<br><colgroup> \
		<col style='width: 69table_edge_width69'> \
		<col style='width: 69table_middle_width69'> \
		<col style='width: 69table_edge_width69'> \
		</colgroup>"

	var/column_width = 3
	var/row_height =69ax(inputs.len, outputs.len, 1)

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
						words += "<b><a href='?src=\ref69src69;act=wire;pin=\ref69io69'>69io.display_pin_type()69 69io.name69</a> \
							<a href='?src=\ref69src69;act=data;pin=\ref69io69'>69io.display_data(io.data)69</a></b><br>"
						if(io.linked.len)
							words += "<ul>"
							for(var/k in io.linked)
								var/datum/integrated_io/linked = k
								words += "<li><a href='?src=\ref69src69;act=unwire;pin=\ref69io69;link=\ref69linked69'>69linked69</a> \
									@ <a href='?src=\ref69linked.holder69'>69linked.holder.displayed_name69</a></li>"
							words += "</ul>"

						if(outputs.len > inputs.len)
							height = 1
				if(2)
					if(i == 1)
						words += "69displayed_name69<br>69name != displayed_name ? "(69name69)":""69<hr>69desc69"
						height = row_height
				if(3)
					io = get_pin_ref(IC_OUTPUT, i)
					if(io)
						words += "<b><a href='?src=\ref69src69;act=wire;pin=\ref69io69'>69io.display_pin_type()69 69io.name69</a> \
							<a href='?src=\ref69src69;act=data;pin=\ref69io69'>69io.display_data(io.data)69</a></b><br>"
						if(io.linked.len)
							words += "<ul>"
							for(var/k in io.linked)
								var/datum/integrated_io/linked = k
								words += "<li><a href='?src=\ref69src69;act=unwire;pin=\ref69io69;link=\ref69linked69'>69linked69</a> \
									@ <a href='?src=\ref69linked.holder69'>69linked.holder.displayed_name69</a></li>"
							words += "</ul>"

						if(inputs.len > outputs.len)
							height = 1
			HTML += "<td align='center' rowspan='69height69'>69words69</td>"
		HTML += "</tr>"

	for(var/activator in activators)
		var/datum/integrated_io/io = activator
		var/words

		words += "<b><a href='?src=\ref69src69;act=wire;pin=\ref69io69'>69io69</a> \
			<a href='?src=\ref69src69;act=data;pin=\ref69io69'>69io.data?"\<PULSE OUT\>":"\<PULSE IN\>"69</a></b><br>"

		if(io.linked.len)
			words += "<ul>"
			for(var/k in io.linked)
				var/datum/integrated_io/linked = k
				words += "<li><a href='?src=\ref69src69;act=unwire;pin=\ref69io69;link=\ref69linked69'>69linked69</a> \
					@ <a href='?src=\ref69linked.holder69'>69linked.holder.displayed_name69</a></li>"
			words += "<ul>"

		HTML += "<tr><td colspan='3' align='center'>69words69</td></tr>"

	HTML += "</table></div> \
		<br>Complexity: 69complexity69 \
		<br>Cooldown per use: 69cooldown_per_use/1069 sec \
		69max_allowed ? "<br>Maximum per circuit: 69max_allowed69" : ""69"

	if(ext_cooldown)
		HTML += "<br>External69anipulation cooldown: 69ext_cooldown/1069 sec"
	if(power_draw_idle)
		HTML += "<br>Power Draw: 69power_draw_idle69 W (Idle)"
	if(power_draw_per_use)
		HTML += "<br>Power Draw: 69power_draw_per_use69 W (Active)" // Borgcode says that powercells' checked_use() takes joules as input.

	HTML += "<br>69extended_desc69</body></html>"

	popup.set_content(HTML)
	popup.open()

/obj/item/integrated_circuit/Topic(href, href_list, state = GLOB.physical_state)
	if(!check_interactivity(usr))
		return
	/*
	I hope state check doesn't required there because of check_interactivity do some stuff with
	checking state, if it lead to butthurt bugs, I'm sorry.
	P.S. someone who wrote proc shared_living_nano_distance should be purged
	and sorry for commented code, if you brave enough please find out where I done69istake(s).
	*/
	// if(..())
	// 	return TRUE

	var/update = TRUE
	var/update_to_assembly = FALSE

	var/obj/item/held_item = usr.get_active_hand()

	if(href_list69"rename"69)
		rename_component(usr)
		if(assembly)
			assembly.add_allowed_scanner(usr.ckey)

	if(href_list69"pin"69)
		var/datum/integrated_io/pin = locate(href_list69"pin"69) in inputs + outputs + activators
		if(pin)
			var/datum/integrated_io/linked
			var/success = TRUE
			if(href_list69"link"69)
				linked = locate(href_list69"link"69) in pin.linked

			if(istype(held_item, /obj/item/device/integrated_electronics) || isMultitool(held_item))
				update_to_assembly = pin.handle_wire(linked, held_item, href_list69"act"69, usr)
			else
				to_chat(usr, SPAN_WARNING("You can't do a whole lot without the proper tools."))
				success = FALSE
			if(success && assembly)
				assembly.add_allowed_scanner(usr.ckey)

	if(href_list69"scan"69)
		if(istype(held_item, /obj/item/device/integrated_electronics/debugger))
			var/obj/item/device/integrated_electronics/debugger/D = held_item
			if(D.accepting_refs)
				D.afterattack(src, usr, TRUE)
			else
				to_chat(usr, SPAN_WARNING("The debugger's 'ref scanner' needs to be on."))
		else
			to_chat(usr, SPAN_WARNING("You need a debugger set to 'ref'69ode to do that."))

	if(href_list69"return"69)
		update_to_assembly = TRUE

	if(href_list69"ic_window"69 && assembly && assembly.use_ui_window)
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


// Returns the object that is supposed to be used in attack69essages, location checks, etc.
/obj/item/integrated_circuit/proc/get_object()
	// If the component is located in an assembly, let assembly determine it.
	if(assembly)
		return assembly.get_object()
	else
		return src	// If not, the component is acting on its own.


// Checks if the target object is reachable. Useful for69arious69anipulators and69anipulator-like objects.
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
