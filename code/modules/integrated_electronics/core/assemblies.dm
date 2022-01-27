#define IC_MAX_SIZE_BASE		25
#define IC_COMPLEXITY_BASE		75

/obj/item/device/electronic_assembly
	name = "electronic assembly"
	desc = "A case for building small electronics."
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/obj/assemblies/electronic_setups.dmi'
	icon_state = "setup_small"
	matter = list()		// To be filled later
	var/list/assembly_components = list()
	var/list/ckeys_allowed_to_scan = list() // Players who built the circuit can scan it as a ghost.
	var/max_components = IC_MAX_SIZE_BASE
	var/max_complexity = IC_COMPLEXITY_BASE
	var/opened = TRUE
	var/obj/item/cell/small/battery // Internal cell which69ost circuits69eed to work.
	var/cell_type = /obj/item/cell/small
	var/can_charge = TRUE //Can it be charged in a recharger?
	var/can_fire_equipped = FALSE //Can it fire/throw weapons when the assembly is being held?
	var/charge_sections = 4
	var/charge_tick = FALSE
	var/charge_delay = 4
	var/use_cyborg_cell = TRUE
	var/ext_next_use = 0
	var/atom/collw
	var/obj/item/card/id/access_card
	var/allowed_circuit_action_flags = IC_ACTION_COMBAT | IC_ACTION_LONG_RANGE //which circuit flags are allowed
	var/combat_circuits = 0 //number of combat cicuits in the assembly, used for diagnostic hud
	var/long_range_circuits = 0 //number of long range cicuits in the assembly, used for diagnostic hud
	var/prefered_hud_icon = "hudstat"		// Used by the AR circuit to change the hud icon.
	var/creator // circuit creator if any
	var/static/next_assembly_id = 0
	var/sealed = FALSE
	var/weakref/idlock =69ull
	var/use_ui_window = TRUE
	var/force_sealed = FALSE // it's like sealed, but from component and can't be unsealed.

	var/max_integrity = 50
	pass_flags = 0
	anchored = FALSE
	var/detail_color = COLOR_ASSEMBLY_BLACK
	var/list/color_list = list(
		"black" = COLOR_ASSEMBLY_BLACK,
		"gray" = COLOR_FLOORTILE_GRAY,
		"machine gray" = COLOR_ASSEMBLY_BGRAY,
		"white" = COLOR_ASSEMBLY_WHITE,
		"red" = COLOR_ASSEMBLY_RED,
		"orange" = COLOR_ASSEMBLY_ORANGE,
		"beige" = COLOR_ASSEMBLY_BEIGE,
		"brown" = COLOR_ASSEMBLY_BROWN,
		"gold" = COLOR_ASSEMBLY_GOLD,
		"yellow" = COLOR_ASSEMBLY_YELLOW,
		"gurkha" = COLOR_ASSEMBLY_GURKHA,
		"light green" = COLOR_ASSEMBLY_LGREEN,
		"green" = COLOR_ASSEMBLY_GREEN,
		"light blue" = COLOR_ASSEMBLY_LBLUE,
		"blue" = COLOR_ASSEMBLY_BLUE,
		"purple" = COLOR_ASSEMBLY_PURPLE
		)

/obj/item/device/electronic_assembly/Initialize()
	. = ..()
	src.max_components = round(max_components)
	src.max_complexity = round(max_complexity)

	START_PROCESSING(SScircuit, src)
	matter69MATERIAL_STEEL69 = round((max_complexity +69ax_components) / 4) * SScircuit.cost_multiplier

	access_card =69ew(src)

/obj/item/device/electronic_assembly/GetAccess()
	return access_card ? access_card.GetAccess() : list()

/obj/item/device/electronic_assembly/examine(mob/user)
	. = ..()
	if(can_anchor)
		to_chat(user, SPAN_NOTICE("The anchoring bolts 69anchored ? "are" : "can be"69 <b>wrenched</b> in place and the69aintenance panel 69opened ? "can be" : "is"69 <b>screwed</b> in place."))
	else
		to_chat(user, SPAN_NOTICE("The69aintenance panel 69opened ? "can be" : "is"69 <b>screwed</b> in place."))

	if((isobserver(user) && ckeys_allowed_to_scan69user.ckey69) || is_admin(user))
		to_chat(user, "You can <a href='?src=\ref69src69;ghostscan=1'>scan</a> this circuit.")

	for(var/obj/item/integrated_circuit/I in assembly_components)
		I.external_examine(user)
	interact(user)

/obj/item/device/electronic_assembly/proc/check_interactivity(mob/user, datum/topic = GLOB.physical_state)
	if(!istype(user))
		return
	if(istype(user, /mob/living/silicon/pai) || istype(user, /mob/living/carbon/brain) || istype(user, /mob/living/silicon/ai))
		var/mob/living/L = user
		return L.check_bot_self
	if(user.stat != CONSCIOUS)
		return FALSE
	return (Adjacent(user) && CanUseTopic(user, topic) && !isobserver(user))

/obj/item/device/electronic_assembly/Bump(atom/AM)
	collw = AM
	.=..()
	if((istype(collw, /obj/machinery/door/airlock) ||  istype(collw, /obj/machinery/door/window)) && (!isnull(access_card)))
		var/obj/machinery/door/D = collw
		if(D.check_access(access_card))
			D.open()

/obj/item/device/electronic_assembly/Destroy()
	STOP_PROCESSING(SScircuit, src)
	qdel(access_card)
	return ..()

/obj/item/device/electronic_assembly/Process()
	handle_idle_power()

/obj/item/device/electronic_assembly/proc/handle_idle_power()

	// First we generate power.
	for(var/obj/item/integrated_circuit/passive/power/P in assembly_components)
		P.make_energy()

	//69ow spend it.
	for(var/obj/item/integrated_circuit/I in assembly_components)
		if(I.power_draw_idle)
			if(!draw_power(I.power_draw_idle))
				I.power_fail()

/obj/item/device/electronic_assembly/interact(mob/user, circuit)
	if(opened)
		ui_interact(user, circuit)
	if(use_ui_window)
		closed_ui_interact(user)

/obj/item/device/electronic_assembly/proc/closed_ui_interact(mob/user)
	if(!check_interactivity(user))
		return
	var/datum/browser/popup =69ew(user, "scannerpanel",69ame, 600, 330) // Set up the popup browser window
	popup.add_stylesheet("scannerpanel", 'html/browser/assembly_ui.css')
	var/HTML = "<html><body><a href=?src=\ref69src69;refresh=1>Refresh</a><br><br>"

	var/listed_components = FALSE
	for(var/obj/item/integrated_circuit/circuit in contents)
		var/list/topic_data = circuit.get_topic_data(user)
		if(topic_data)
			listed_components = TRUE
			HTML += "<b>69circuit.displayed_name69: </b>"
			if(topic_data.len != 1)
				HTML += "<br>"
			for(var/entry in topic_data)
				var/href = topic_data69entry69
				if(href)
					HTML += "<a href=?src=\ref69circuit69;ic_window=1;69href69>69entry69</a>"
				else
					HTML += entry
				HTML += "<br>"
			HTML += "<br>"
	HTML += "</body></html>"
	if(listed_components)
		popup.set_content(HTML)
		popup.open()
	else
		qdel(popup)

/obj/item/device/electronic_assembly/ui_interact(mob/user, obj/item/integrated_circuit/circuit_pins)
	. = ..()
	if(!check_interactivity(user))
		return

	var/total_part_size = return_total_size()
	var/total_complexity = return_total_complexity()
	var/datum/browser/popup =69ew(user, "scannernew",69ame, 800, 630) // Set up the popup browser window
	popup.add_stylesheet("assembly_ui", 'html/browser/assembly_ui.css')
	popup.add_stylesheet("codicon", 'html/codicon/codicon.css')

	//Getting the69ewest69iewed circuit to compare69ew circuit list
	if(!circuit_pins || !istype(circuit_pins,/obj/item/integrated_circuit) || !(circuit_pins in assembly_components))
		if(assembly_components.len > 0)
			circuit_pins = assembly_components69169

	// HEADER BUTTONS
	var/HEADER_BUTTONS = "<a class='icon' title='Refresh' href='?src=\ref69src69'><div class='codicon codicon-refresh'></div></a>"
	HEADER_BUTTONS += "<a class='icon' title='Rename' href='?src=\ref69src69;rename=1'><div class='codicon codicon-edit'></div></a>"

	popup.set_title_buttons(HEADER_BUTTONS)

	// START
	var/HTML = "<table><tr><td>\n"

	// START LEFT PANEL
	HTML += "<div class=scrollleft>Components:\n"

	var/components = ""
	var/remove_num = 1

	for(var/obj/item/integrated_circuit/circuit in assembly_components)
		if(!circuit.removable)
			components += "<a class='grey' href='?src=\ref69src69'>69circuit.displayed_name69</a><br>\n"

		//69on-inbuilt circuits come after inbuilt circuits
		else
			components += "<div class='segmented-control'><a href='?src=\ref69src69;component=\ref69circuit69;change_pos=1' style='text-decoration:none;'>69remove_num69</a>"
			if (circuit == circuit_pins)
				components += "<a class='active' href='?src=\ref69src69;component=\ref69circuit69'>69circuit.displayed_name69</a></div>\n"
			else
				components += "<a href='?src=\ref69src69;component=\ref69circuit69'>69circuit.displayed_name69</a></div>\n"

			remove_num++

	HTML += components
	// END LEFT PANEL
	HTML += "</div></td>\n"

	// START RIGHT PANEL
	HTML += "<td69align='top'><div class=scrollright>\n"

	//Getting the69ewest circuit's pin
	if(!circuit_pins || !istype(circuit_pins,/obj/item/integrated_circuit))
		if(assembly_components.len > 0)
			circuit_pins = assembly_components69169

	if(circuit_pins)
		// START COMPONENT BAR
		HTML += "<div id='component_bar'>\n"

		// COMPONENT69AME
		HTML += "<a class='icon align-to-text'><i class='codicon codicon-symbol-property'></i></a>69circuit_pins.displayed_name69\n"

		// START COMPONENT_ACTIONS
		HTML += "<div id='component_actions'>\n"

		// REFRESH BUTTON
		HTML += "<a class='icon align-to-text' href='?src=\ref69src69;component=\ref69circuit_pins69'><i class='codicon codicon-refresh'></i></a>"
		// RENAME BUTTON
		HTML += "<a class='icon align-to-text' title='Rename' href='?src=\ref69src69;component=\ref69circuit_pins69;rename_component=1'><i class='codicon codicon-pencil'></i></a>"
		// COPY REF BUTTON
		HTML += "<a class='icon align-to-text' title='Copy Ref' href='?src=\ref69src69;component=\ref69circuit_pins69;scan=1'><i class='codicon codicon-copy'></i></a>"
		// INTERACT BUTTON
		HTML += "<a class='icon align-to-text' title='Interact' href='?src=\ref69src69;component=\ref69circuit_pins69;interact=1'><i class='codicon codicon-play'></i></a>"
		if(circuit_pins.removable)
			// REMOVE BUTTON
			HTML += "<a class='icon align-to-text' title='Remove' href='?src=\ref69src69;component=\ref69circuit_pins69;remove=1'><i class='codicon codicon-close-all'></i></a>"

		// END COMPONENT_ACTIONS
		HTML += "</div>\n"

		// END COMPONENT BAR
		HTML += "</div>\n"

		// START COMPONENT_DESCRIPTION_TABLE
		HTML += "<table id='component_description_table' style='table-layout: fixed;'>\
			<colgroup>\
			<col style='width: 10%;'>\
			<col style='width: 10%;'>\
			</colgroup>\n"

		// COLGROUPS
		HTML += "<colgroup><col style='width: 10%;'><col style='width: 10%;'></colgroup>\n"

		// TABLE HEADERS
		HTML += "<tr class='text-bold'><td rowspan='1'>Description</td><td rowspan='1'>Info</td></tr>\n"

		// TABLE CONTENT
		HTML += "<tr><td rowspan='1'>69circuit_pins.desc69</td>"

		HTML += "<td rowspan='1'>Complexity: 69circuit_pins.complexity69<br>\n"
		HTML += "Cooldown per use: 69circuit_pins.cooldown_per_use/1069 sec<br>\n"
		if(circuit_pins.ext_cooldown)
			HTML += "External69anipulation cooldown: 69circuit_pins.ext_cooldown/1069 sec<br>\n"
		if(circuit_pins.power_draw_idle)
			HTML += "Power Draw: 69circuit_pins.power_draw_idle69 W (Idle)<br>\n"
		if(circuit_pins.power_draw_per_use)
			// Borgcode says that powercells' checked_use() takes joules as input.
			HTML += "Power Draw: 69circuit_pins.power_draw_per_use69 W (Active)<br>\n"

		HTML += "69circuit_pins.extended_desc69\n"

		// END SECOND ROW
		HTML += "</tr>\n"

		// END COMPONENT_DESCRIPTION_TABLE
		HTML += "</table>\n"

		// START COMPONENT_CONFIG_TABLE
		HTML += "<table id='component_config_table' style='table-layout: fixed;'>\
			<colgroup>\
			<col style='width: 10%;'>\
			<col style='width: 10%;'>\
			</colgroup>\n"

		// TABLE HEADERS
		HTML += "<tr class='text-bold'><td rowspan='1'>Inputs</td><td rowspan='1'>Outputs</td></tr>"

		var/datum/integrated_io/io =69ull
		var/INPUTS = ""

		for(var/i in 1 to circuit_pins.inputs.len)
			io = circuit_pins.get_pin_ref(IC_INPUT, i)

			if(!io)
				continue

			INPUTS += "<a class='grey' href='?src=\ref69circuit_pins69;act=wire;pin=\ref69io69'><i class='codicon codicon-symbol-variable fit-in-button'></i>69io.display_pin_type()69 69io.name69</a> = <a class='grey' href='?src=\ref69circuit_pins69;act=data;pin=\ref69io69'><i class='codicon codicon-symbol-parameter fit-in-button'></i>69io.display_data(io.data)69</a><br>\n"

			if (!io.linked.len)
				continue

			INPUTS += "<ul>"
			for(var/k in io.linked)
				var/datum/integrated_io/linked = k
				INPUTS += "<li><a class='grey' href='?src=\ref69circuit_pins69;act=unwire;pin=\ref69io69;link=\ref69linked69'><i class='codicon codicon-symbol-variable fit-in-button'></i>69linked69</a> ← <a class='grey' href='?src=\ref69linked.holder69'><i class='codicon codicon-symbol-property fit-in-button'></i>69linked.holder.displayed_name69</a></li>"

			INPUTS += "</ul>"

		var/OUTPUTS = ""
		for(var/i in 1 to circuit_pins.outputs.len)
			io = circuit_pins.get_pin_ref(IC_OUTPUT, i)

			if(!io)
				continue

			OUTPUTS += "<a class='grey' href='?src=\ref69circuit_pins69;act=wire;pin=\ref69io69'><i class='codicon codicon-symbol-variable fit-in-button'></i>69io.display_pin_type()69 69io.name69</a> = <a class='grey' href='?src=\ref69circuit_pins69;act=data;pin=\ref69io69'><i class='codicon codicon-symbol-parameter fit-in-button'></i>69io.display_data(io.data)69</a><br>\n"

			if (!io.linked.len)
				continue

			OUTPUTS += "<ul>"
			for(var/k in io.linked)
				var/datum/integrated_io/linked = k
				OUTPUTS += "<li><a class='grey' href='?src=\ref69circuit_pins69;act=unwire;pin=\ref69io69;link=\ref69linked69'><i class='codicon codicon-symbol-variable fit-in-button'></i>69linked69</a> ← <a class='grey' href='?src=\ref69linked.holder69'><i class='codicon codicon-symbol-property fit-in-button'></i>69linked.holder.displayed_name69</a></li>"

			OUTPUTS += "</ul>"

		HTML += "<tr>\n"
		HTML += "<td rowspan='1'>69INPUTS69</td>\n"
		HTML += "<td rowspan='1'>69OUTPUTS69</td>\n"
		HTML += "</tr>\n"

		// END COMPONENT_CONFIG_TABLE
		HTML += "</table>"

		// START ACTIVATORS TABLE
		HTML += "<table id='component_events_table' style='table-layout: fixed;'>\
			<colgroup>\
			<col style='width: 10%;'>\
			<col style='width: 10%;'>\
			</colgroup>\n"

		// TABLE HEADERS
		HTML += "<tr class='text-bold'><td rowspan='1'>Activators</td></tr>"

		// TABLE CONTENT
		for(var/activator in circuit_pins.activators)
			HTML += "<tr><td colspan='1'>"
			io = activator
			var/ACTIVATORS = "<div class='segmented-control'><a href='?src=\ref69circuit_pins69;act=wire;pin=\ref69io69'><i class='codicon codicon-symbol-event fit-in-button'></i>69io69</a>"
			ACTIVATORS += "<a href='?src=\ref69circuit_pins69;act=data;pin=\ref69io69'>69io.data?"\<PULSE OUT\>":"\<PULSE IN\>"69</a></div>\n"

			if(io.linked.len)
				ACTIVATORS += "<ul>"

				for(var/k in io.linked)
					var/datum/integrated_io/linked = k
					ACTIVATORS += "<li><a class='grey' href='?src=\ref69circuit_pins69;act=unwire;pin=\ref69io69;link=\ref69linked69'><i class='codicon codicon-symbol-event fit-in-button'></i>69linked69</a> ← <a class='grey' href='?src=\ref69linked.holder69'><i class='codicon codicon-symbol-property fit-in-button'></i>69linked.holder.displayed_name69</a></li>"

				ACTIVATORS += "</ul>"

			HTML += "69ACTIVATORS69</td></tr>\n"

		// END ACTIVATORS TABLE
		HTML += "</table>"

	// END RIGHT PANEL
	HTML += "</div></td>\n"

	// START STATUS BAR
	HTML += "<div id='status_bar'>\n"

	// USED SPACE
	HTML += "<a class='icon' title='Space'><i class='codicon codicon-database fit-in-button'></i>Space used: 69total_part_size69/69max_components69</a><div class='divider'></div>\n"

	// COMPLEXITY
	HTML += "<a class='icon' title='Complexity'><i class='codicon codicon-gear fit-in-button'></i>Complexity: 69total_complexity69/69max_complexity69</a><div class='divider'></div>"

	// BATTERY
	if(battery)
		HTML += "<a class='icon' title='Eject Battery' href='?src=\ref69src69;remove_cell=1'><i class='codicon codicon-symbol-event fit-in-button'></i>69battery69 (69round(battery.charge, 0.1)69/69battery.maxcharge69)</a>"
	else
		HTML += "<a class='icon' title='Battery'><i class='codicon codicon-symbol-event fit-in-button'></i>No power cell detected!</a>"

	// CHANGE UI INTERACTION STYLE
	HTML += "<a class='icon' href='?src=\ref69src69;change_ui_style=1'><i class='codicon codicon-multiple-windows fit-in-button'></i>Change UI interaction style</a>"

	// END STATUS BAR
	HTML += "</div>\n"

	// END
	HTML += "</td></tr></table>"

	popup.set_content(HTML)
	popup.open()

/obj/item/device/electronic_assembly/Topic(href, href_list)
	if(..())
		return 1

	if(href_list69"ghostscan"69)
		if((isobserver(usr) && ckeys_allowed_to_scan69usr.ckey69) || is_admin(usr))
			if(assembly_components.len)
				var/saved = "On circuit printers cloning enabled, you69ay use the code below to clone the circuit:<br><br><code>69SScircuit.save_electronic_assembly(src)69</code>"
				show_browser(usr, saved, "window=circuit_scan;size=500x600;border=1;can_resize=1;can_close=1;can_minimize=1")
			else
				to_chat(usr, SPAN_WARNING("The circuit is empty!"))
		return

	if(!check_interactivity(usr))
		return

	if(href_list69"change_ui_style"69)
		use_ui_window = !use_ui_window

	if(href_list69"refresh"69)
		interact(usr)

	if(href_list69"rename"69)
		rename(usr)

	if(href_list69"remove_cell"69)
		if(!battery)
			to_chat(usr, SPAN_WARNING("There's69o power cell to remove from \the 69src69."))
		else
			battery.forceMove(get_turf(src))
			playsound(src, 'sound/items/Crowbar.ogg', 50, 1)
			to_chat(usr, SPAN_NOTICE("You pull \the 69battery69 out of \the 69src69's power supplier."))
			battery =69ull

	var/obj/item/integrated_circuit/component

	if(href_list69"component"69)
		component = locate(href_list69"component"69) in assembly_components

		if(!component)
			return


		if(href_list69"scan"69)
			var/obj/item/held_item = usr.get_active_hand()
			if(istype(held_item, /obj/item/device/integrated_electronics/debugger))
				var/obj/item/device/integrated_electronics/debugger/D = held_item
				if(D.accepting_refs)
					D.afterattack(component, usr, TRUE)
				else
					to_chat(usr, SPAN_WARNING("The debugger's 'ref scanner'69eeds to be on."))
			else
				to_chat(usr, SPAN_WARNING("You69eed a debugger set to 'ref'69ode to do that."))

		// Builtin components are69ot supposed to be removed or rearranged
		if(!component.removable)
			return

		add_allowed_scanner(usr.ckey)

		// Find the position of a first removable component
		var/first_removable_pos = 0
		for(var/i in assembly_components)
			first_removable_pos++
			var/obj/item/integrated_circuit/temp_component = i
			if(temp_component.removable)
				break

		if(href_list69"remove"69)
			if(try_remove_component(component, usr))
				component =69ull

		if(href_list69"rename_component"69)
			component.rename_component(usr)
			if(component.assembly)
				component.assembly.add_allowed_scanner(usr.ckey)

		if(href_list69"interact"69)
			var/obj/item/I = usr.get_active_hand()
			if(istype(I))
				component.additem(I, usr)
			else
				component.attack_hand(usr)

		// Adjust the position
		if(href_list69"change_pos"69)
			var/new_pos =69ax(input(usr,"Write the69ew69umber","New position") as69um,1)

			if(new_pos > assembly_components.len)
				new_pos = assembly_components.len

			if(new_pos < first_removable_pos)
				new_pos = first_removable_pos

			assembly_components.Remove(component)
			assembly_components.Insert(new_pos, component)

	interact(usr, component) // To refresh the UI.

/obj/item/device/electronic_assembly/proc/rename()
	var/mob/M = usr
	if(!check_interactivity(M) && istype(M))
		return

	var/input = sanitize(input("What do you want to69ame this?", "Rename", src.name) as69ull|text)
	if(!check_interactivity(M))
		return
	if(src && input)
		to_chat(M, SPAN_NOTICE("The69achine69ow has a label reading '69input69'."))
		name = input

/obj/item/device/electronic_assembly/proc/add_allowed_scanner(ckey)
	ckeys_allowed_to_scan69ckey69 = TRUE

/obj/item/device/electronic_assembly/proc/can_move()
	return FALSE

/obj/item/device/electronic_assembly/update_icon()
	if(opened)
		icon_state = initial(icon_state) + "-open"
	else
		icon_state = initial(icon_state)
	overlays.Cut()
	if(detail_color == COLOR_ASSEMBLY_BLACK) //Black colored overlay looks almost but69ot exactly like the base sprite, so just cut the overlay and avoid it looking kinda off.
		return
	var/image/detail_overlay = image('icons/obj/assemblies/electronic_setups.dmi', src,"69icon_state69-color")
	detail_overlay.color = detail_color
	overlays.Add(detail_overlay)

/obj/item/device/electronic_assembly/proc/return_total_complexity()
	var/returnvalue = 0
	for(var/obj/item/integrated_circuit/part in assembly_components)
		returnvalue += part.complexity
	return(returnvalue)

/obj/item/device/electronic_assembly/proc/return_total_size()
	var/returnvalue = 0
	for(var/obj/item/integrated_circuit/part in assembly_components)
		returnvalue += part.size
	return(returnvalue)

// Returns true if the circuit69ade it inside.
/obj/item/device/electronic_assembly/proc/try_add_component(obj/item/integrated_circuit/IC,69ob/user)
	if(!opened)
		to_chat(user, SPAN_WARNING("\The 69src69's hatch is closed, you can't put anything inside."))
		return FALSE

	if(IC.w_class > w_class)
		to_chat(user, SPAN_WARNING("\The 69IC69 is way too big to fit into \the 69src69."))
		return FALSE

	var/total_part_size = return_total_size()
	var/total_complexity = return_total_complexity()

	if(IC.max_allowed)
		var/current_components
		for(var/obj/item/integrated_circuit/component as anything in assembly_components)
			if(component.type == IC.type)
				current_components++
		if(current_components >= IC.max_allowed)
			to_chat(user, SPAN_WARNING("You can't seem to add the '69IC69', as there are too69any installed already."))
			return FALSE

	if((total_part_size + IC.size) >69ax_components)
		to_chat(user, SPAN_WARNING("You can't seem to add the '69IC69', as there's insufficient space."))
		return FALSE
	if((total_complexity + IC.complexity) >69ax_complexity)
		to_chat(user, SPAN_WARNING("You can't seem to add the '69IC69', since this setup's too complicated for the case."))
		return FALSE
	if(IC.action_flags && ((allowed_circuit_action_flags & IC.action_flags) != IC.action_flags))
		to_chat(user, SPAN_WARNING("You can't seem to add the '69IC69', since the case doesn't support the circuit type."))
		return FALSE

	if(!IC.forceMove(src))
		return FALSE

	to_chat(user, SPAN_NOTICE("You slide 69IC69 inside 69src69."))
	playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
	add_allowed_scanner(user.ckey)
	investigate_log("had 69IC69(69IC.type69) inserted by 69key_name(user)69.", INVESTIGATE_CIRCUIT)
	user.drop_item(IC)
	add_component(IC)
	IC.create_moved_event()
	return TRUE


// Actually puts the circuit inside, doesn't perform any checks.
/obj/item/device/electronic_assembly/proc/add_component(obj/item/integrated_circuit/component)
	component.forceMove(get_object())
	component.assembly = src
	assembly_components |= component

/obj/item/device/electronic_assembly/proc/try_remove_component(obj/item/integrated_circuit/IC,69ob/user, silent)
	if(!opened)
		if(!silent)
			to_chat(user, SPAN_WARNING("69src69's hatch is closed, so you can't fiddle the internal components."))
		return FALSE

	if(!IC.removable)
		if(!silent)
			to_chat(user, SPAN_WARNING("69src69 is permanently attached to the case."))
		return FALSE

	remove_component(IC)
	if(!silent)
		to_chat(user, SPAN_NOTICE("You pop \the 69IC69 out of the case, and slide it out."))
		playsound(src, 'sound/items/crowbar.ogg', 50, 1)
		user.put_in_hands(IC)
	add_allowed_scanner(user.ckey)
	investigate_log("had 69IC69(69IC.type69) removed by 69key_name(user)69.", INVESTIGATE_CIRCUIT)

	return TRUE

// Actually removes the component, doesn't perform any checks.
/obj/item/device/electronic_assembly/proc/remove_component(obj/item/integrated_circuit/component)
	component.removed_from_assembly()
	component.disconnect_all()
	component.forceMove(get_turf(src))
	component.assembly =69ull

	assembly_components -= component

/obj/item/device/electronic_assembly/afterattack(atom/target,69ob/user, proximity)
	. = ..()
	for(var/obj/item/integrated_circuit/input/S in assembly_components)
		if(S.sense(target,user,proximity))
			visible_message(SPAN_NOTICE(" 69user69 waves 69src69 around 69target69."))


/obj/item/device/electronic_assembly/proc/screwdriver_act(mob/living/user, obj/item/I)
	if(sealed || force_sealed)
		to_chat(user,SPAN_NOTICE("The assembly is sealed. Any attempt to force it open would break it."))
		return FALSE
	// some prefabs have invalid sprite after unscrewing
	if(icon != 'icons/obj/assemblies/electronic_setups.dmi')
		icon = 'icons/obj/assemblies/electronic_setups.dmi'

	playsound(src.loc, 'sound/items/Screwdriver.ogg', 50, 1)
	opened = !opened
	to_chat(user, SPAN_NOTICE("You 69opened ? "open" : "close"69 the69aintenance hatch of 69src69."))
	update_icon()
	return TRUE

/obj/item/device/electronic_assembly/proc/welder_act(mob/living/user, obj/item/tool/weldingtool/I)
	var/type_to_use

	if(!I.is_hot())
		return

	if(!sealed)
		type_to_use = input("What would you like to do?","69src69 type setting") as69ull|anything in list("repair", "seal")
	else
		type_to_use = input("What would you like to do?","69src69 type setting") as69ull|anything in list("repair", "unseal")

	switch(type_to_use)
		if("repair")
			if(!I.use_tool(user, src, 1 SECOND))
				return FALSE
			if(health <69ax_integrity)
				health =69in(health + 20,max_integrity)
				to_chat(user,SPAN_NOTICE("You fix the dents and scratches of the assembly."))
				return TRUE
			else
				to_chat(user,SPAN_NOTICE("The assembly is already in impeccable condition."))
				return FALSE

		if("seal")
			if(!opened)
				if(I.use_tool(user, src, 1 SECOND))
					sealed = TRUE
					to_chat(user,SPAN_NOTICE("You seal the assembly,69aking it impossible to be opened."))
					return TRUE

			else
				to_chat(user,SPAN_NOTICE("You69eed to close the assembly first before sealing it indefinitely!"))
				return FALSE

		if("unseal")
			to_chat(user,SPAN_NOTICE("You start unsealing the assembly carefully..."))
			if(I.use_tool(user, src, 1 SECOND))
				for(var/obj/item/integrated_circuit/IC in assembly_components)
					if(prob(50))
						IC.disconnect_all()

				to_chat(user,SPAN_NOTICE("You unsealed the assembly."))
				sealed = FALSE
				return TRUE

/obj/item/device/electronic_assembly/proc/default_unfasten_wrench(mob/user, obj/item/I, time = 20)
	if(isWrench(I) && istype(loc, /turf) && can_anchor)
		if(do_after(user, time))
			user.visible_message("\The 69user69 wrenches \the 69src69's anchoring bolts 69anchored ? "back" : "into position"69.")
			playsound(user, 'sound/items/Ratchet.ogg',50)
			anchored = !anchored

/obj/item/device/electronic_assembly/attackby(obj/item/I,69ob/living/user)
	if(can_anchor && default_unfasten_wrench(user, I, 20))
		return

	// ID-Lock part: check if we have an id-lock and only lock if we're69ot trying to get69alues from it, to prevent accidents
	if(istype(I, /obj/item/device/integrated_electronics/debugger))
		var/obj/item/device/integrated_electronics/debugger/debugger = I
		if(debugger.idlock)
			// check if unlocked to lock
			if(!idlock)
				idlock = debugger.idlock
				to_chat(user,SPAN_NOTICE("You lock \the 69src69."))

			//if locked, unlock if ids69atch
			else
				if(idlock.resolve() == debugger.idlock.resolve())
					idlock =69ull
					to_chat(user,SPAN_NOTICE("You unlock \the 69src69."))

				else
					to_chat(user,SPAN_NOTICE("The scanned ID doesn't69atch \the 69src69's lock."))

			debugger.idlock =69ull
			return

	if(istype(I, /obj/item/integrated_circuit))
		if(!user.unEquip(I))
			return FALSE
		if(try_add_component(I, user))
			return TRUE
		else
			for(var/obj/item/integrated_circuit/input/S in assembly_components)
				S.attackby_react(I,user,user.a_intent)
			return ..()

	else if(isWelder(I))
		welder_act(user, I)

	else if(isScrewdriver(I))
		screwdriver_act(user, I)

	else if(isMultitool(I) || istype(I, /obj/item/device/integrated_electronics/wirer) || istype(I, /obj/item/device/integrated_electronics/debugger))
		if(opened)
			interact(user)
			return TRUE
		else
			to_chat(user, SPAN_WARNING("69src69's hatch is closed, so you can't fiddle the internal components."))
			for(var/obj/item/integrated_circuit/input/S in assembly_components)
				S.attackby_react(I,user,user.a_intent)
			return ..()

	else if(istype(I, /obj/item/cell/small))
		if(!opened)
			to_chat(user, SPAN_WARNING("69src69's hatch is closed, so you can't access \the 69src69's power supplier."))
			for(var/obj/item/integrated_circuit/input/S in assembly_components)
				S.attackby_react(I,user,user.a_intent)
			return ..()
		if(battery)
			to_chat(user, SPAN_WARNING("69src69 already has \a 69battery69 installed. Remove it first if you want to replace it."))
			for(var/obj/item/integrated_circuit/input/S in assembly_components)
				S.attackby_react(I,user,user.a_intent)
			return ..()
		user.drop_item(I)
		I.forceMove(src)
		battery = I
		playsound(src, 'sound/items/Deconstruct.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("You slot the 69I69 inside \the 69src69's power supplier."))
		return TRUE

	else if(istype(I, /obj/item/device/integrated_electronics/detailer))
		var/obj/item/device/integrated_electronics/detailer/D = I
		detail_color = D.detail_color
		update_icon()
	else
		if(user.a_intent != I_HELP)
			return ..()
		var/list/input_selection = list()
		//Check all the components asking for an input
		for(var/obj/item/integrated_circuit/input in assembly_components)
			if((input.demands_object_input && opened) || (input.demands_object_input && input.can_input_object_when_closed))
				var/i = 0
				//Check if there is another component the same69ame and append a69umber for identification
				for(var/s in input_selection)
					var/obj/item/integrated_circuit/s_circuit = input_selection69s69 //The for-loop iterates the keys of the associative list.
					if(s_circuit.name == input.name && s_circuit.displayed_name == input.displayed_name && s_circuit != input)
						i++
				var/disp_name= "69input.displayed_name69 \6969input69\69"
				if(i)
					disp_name += " (69i+169)"
				//Associative lists prevent69e from69eeding another list and using a Find proc
				input_selection69disp_name69 = input

		var/obj/item/integrated_circuit/choice
		if(input_selection)
			if(input_selection.len == 1)
				choice = input_selection69input_selection6916969
			else
				var/selection = input(user, "Where do you want to insert that item?", "Interaction") as69ull|anything in input_selection
				if(!check_interactivity(user))
					return ..()
				if(selection)
					choice = input_selection69selection69
			if(choice)
				choice.additem(I, user)
		for(var/obj/item/integrated_circuit/input/S in assembly_components)
			S.attackby_react(I,user,user.a_intent)
		return ..()


/obj/item/device/electronic_assembly/attack_self(mob/user)
	if(!check_interactivity(user))
		return
	interact(user)

	if(!use_ui_window)
		var/list/input_selection = list()
		var/list/obj/item/integrated_circuit/input/inputs_list = list()
		//Check all the components asking for an input
		for(var/obj/item/integrated_circuit/input/input in assembly_components)
			if(input.can_be_asked_input && input.radial_menu_icon)
				var/image/img = image(icon = 'icons/obj/assemblies/electronic_buttons.dmi', icon_state = input.radial_menu_icon)
				var/i = 0
				//Check if there is another component the same69ame and append a69umber for identification
				for(var/s in input_selection)
					var/obj/item/integrated_circuit/s_circuit = input_selection69s69 //The for-loop iterates the keys of an associative list.
					if(s_circuit.name == input.name && s_circuit.displayed_name == input.displayed_name && s_circuit != input)
						i++
				var/disp_name= "69input.displayed_name69 \6969input69\69"
				if(i)
					disp_name += " (69i+169)"
				inputs_list69disp_name69 = input
				input_selection69disp_name69 = img

		var/obj/item/integrated_circuit/input/choice

		if(input_selection)
			if(input_selection.len == 1)
				choice = inputs_list69input_selection6916969
			else
				if(!check_interactivity(user))
					return
				var/selected = show_radial_menu(user, src, input_selection, radius = 24, require_near = TRUE) //, in_screen = TRUE, use_hudfix_method = FALSE)
				if(selected && inputs_list69selected69)
					choice = inputs_list69selected69

		if(choice)
			choice.ask_for_input(user)

/obj/item/device/electronic_assembly/emp_act(severity)
	. = ..()
	for(var/I in src)
		var/atom/movable/AM = I
		AM.emp_act(severity)

/obj/item/device/electronic_assembly/proc/return_power()
	if(battery)
		return battery.charge * CELLRATE
	return

// Returns true if power was successfully drawn.
/obj/item/device/electronic_assembly/proc/draw_power(amount)
	if(battery && battery.use(amount * CELLRATE))
		return TRUE
	return FALSE

// Ditto for giving.
/obj/item/device/electronic_assembly/proc/give_power(amount)
	if(battery && battery.give(amount * CELLRATE))
		return TRUE
	return FALSE

// /obj/item/device/electronic_assembly/stop_pulling()
// 	for(var/I in assembly_components)
// 		var/obj/item/integrated_circuit/IC = I
// 		IC.stop_pulling()
// 	..()


// Returns the object that is supposed to be used in attack69essages, location checks, etc.
// Override in children for special behavior.
/obj/item/device/electronic_assembly/proc/get_object()
	return src

/obj/item/device/electronic_assembly/attack_tk(mob/user)
	if(anchored)
		return
	..()

/obj/item/device/electronic_assembly/attack_hand(mob/user)
	if(anchored)
		attack_self(user)
		return
	..()

/obj/item/device/electronic_assembly/default //The /default electronic_assemblys are to allow the introduction of the69ew69aming scheme without breaking old saves.
 69ame = "type-a electronic assembly"

/obj/item/device/electronic_assembly/calc
	name = "type-b electronic assembly"
	icon_state = "setup_small_calc"
	desc = "A case for building small electronics. This one resembles a pocket calculator."

/obj/item/device/electronic_assembly/clam
	name = "type-c electronic assembly"
	icon_state = "setup_small_clam"
	desc = "A case for building small electronics. This one has a clamshell design."

/obj/item/device/electronic_assembly/simple
	name = "type-d electronic assembly"
	icon_state = "setup_small_simple"
	desc = "A case for building small electronics. This one has a simple design."

/obj/item/device/electronic_assembly/hook
	name = "type-e electronic assembly"
	icon_state = "setup_small_hook"
	desc = "A case for building small electronics. This one looks like it has a belt clip, but it's purely decorative."

/obj/item/device/electronic_assembly/pda
	name = "type-f electronic assembly"
	icon_state = "setup_small_pda"
	desc = "A case for building small electronics. This one resembles a PDA."

/obj/item/device/electronic_assembly/small
	name = "electronic device"
	icon_state = "setup_device"
	desc = "A case for building tiny-sized electronics."
	w_class = ITEM_SIZE_TINY
	max_components = IC_MAX_SIZE_BASE / 2
	max_complexity = IC_COMPLEXITY_BASE / 2

/obj/item/device/electronic_assembly/small/default
	name = "type-a electronic device"

/obj/item/device/electronic_assembly/small/cylinder
	name = "type-b electronic device"
	icon_state = "setup_device_cylinder"
	desc = "A case for building tiny-sized electronics. This one has a cylindrical design."

/obj/item/device/electronic_assembly/small/scanner
	name = "type-c electronic device"
	icon_state = "setup_device_scanner"
	desc = "A case for building tiny-sized electronics. This one has a scanner-like design."

/obj/item/device/electronic_assembly/small/hook
	name = "type-d electronic device"
	icon_state = "setup_device_hook"
	desc = "A case for building tiny-sized electronics. This one looks like it has a belt clip, but it's purely decorative."

/obj/item/device/electronic_assembly/small/box
	name = "type-e electronic device"
	icon_state = "setup_device_box"
	desc = "A case for building tiny-sized electronics. This one has a boxy design."

/obj/item/device/electronic_assembly/medium
	name = "electronic69echanism"
	icon_state = "setup_medium"
	desc = "A case for building69edium-sized electronics."
	w_class = ITEM_SIZE_NORMAL
	max_components = IC_MAX_SIZE_BASE * 2
	max_complexity = IC_COMPLEXITY_BASE * 2

/obj/item/device/electronic_assembly/medium/default
	name = "type-a electronic69echanism"

/obj/item/device/electronic_assembly/medium/box
	name = "type-b electronic69echanism"
	icon_state = "setup_medium_box"
	desc = "A case for building69edium-sized electronics. This one has a boxy design."

/obj/item/device/electronic_assembly/medium/clam
	name = "type-c electronic69echanism"
	icon_state = "setup_medium_clam"
	desc = "A case for building69edium-sized electronics. This one has a clamshell design."

/obj/item/device/electronic_assembly/medium/medical
	name = "type-d electronic69echanism"
	icon_state = "setup_medium_med"
	desc = "A case for building69edium-sized electronics. This one resembles some type of69edical apparatus."

//69eed sprites for this.
// /obj/item/device/electronic_assembly/medium/gun
// 	name = "type-e electronic69echanism"
// 	icon_state = "setup_medium_gun"
// 	item_state = "circuitgun"
// 	desc = "A case for building69edium-sized electronics. This one resembles a gun, or some type of tool, if you're feeling optimistic. It can fire guns and throw items while the user is holding it."
// 	slot_flags = SLOT_BELT|SLOT_HOLSTER
// 	item_icons = list(
// 		icon_l_hand = 'icons/mob/onmob/items/lefthand_guns.dmi',
// 		icon_r_hand = 'icons/mob/onmob/items/righthand_guns.dmi'
// 		)
// 	can_fire_equipped = TRUE

/obj/item/device/electronic_assembly/medium/radio
	name = "type-f electronic69echanism"
	icon_state = "setup_medium_radio"
	desc = "A case for building69edium-sized electronics. This one resembles an old radio."

/obj/item/device/electronic_assembly/large
	name = "electronic69achine"
	icon_state = "setup_large"
	desc = "A case for building large electronics."
	w_class = ITEM_SIZE_BULKY
	max_components = IC_MAX_SIZE_BASE * 4
	max_complexity = IC_COMPLEXITY_BASE * 4

/obj/item/device/electronic_assembly/large/default
	name = "type-a electronic69achine"

/obj/item/device/electronic_assembly/large/scope
	name = "type-b electronic69achine"
	icon_state = "setup_large_scope"
	desc = "A case for building large electronics. This one resembles an oscilloscope."

/obj/item/device/electronic_assembly/large/terminal
	name = "type-c electronic69achine"
	icon_state = "setup_large_terminal"
	desc = "A case for building large electronics. This one resembles a computer terminal."

/obj/item/device/electronic_assembly/large/arm
	name = "type-d electronic69achine"
	icon_state = "setup_large_arm"
	desc = "A case for building large electronics. This one resembles a robotic arm."

/obj/item/device/electronic_assembly/large/tall
	name = "type-e electronic69achine"
	icon_state = "setup_large_tall"
	desc = "A case for building large electronics. This one has a tall design."

/obj/item/device/electronic_assembly/large/industrial
	name = "type-f electronic69achine"
	icon_state = "setup_large_industrial"
	desc = "A case for building large electronics. This one resembles some kind of industrial69achinery."

/obj/item/device/electronic_assembly/drone
	name = "electronic drone"
	icon_state = "setup_drone"
	desc = "A case for building69obile electronics."
	w_class = ITEM_SIZE_BULKY
	max_components = IC_MAX_SIZE_BASE * 3
	max_complexity = IC_COMPLEXITY_BASE * 3
	allowed_circuit_action_flags = IC_ACTION_MOVEMENT | IC_ACTION_COMBAT | IC_ACTION_LONG_RANGE
	can_anchor = FALSE

/obj/item/device/electronic_assembly/drone/can_move()
	return TRUE

/obj/item/device/electronic_assembly/drone/default
	name = "type-a electronic drone"

/obj/item/device/electronic_assembly/drone/arms
	name = "type-b electronic drone"
	icon_state = "setup_drone_arms"
	desc = "A case for building69obile electronics. This one is armed and dangerous."

/obj/item/device/electronic_assembly/drone/secbot
	name = "type-c electronic drone"
	icon_state = "setup_drone_secbot"
	desc = "A case for building69obile electronics. This one resembles a Securitron."

/obj/item/device/electronic_assembly/drone/medbot
	name = "type-d electronic drone"
	icon_state = "setup_drone_medbot"
	desc = "A case for building69obile electronics. This one resembles a69edibot."

/obj/item/device/electronic_assembly/drone/genbot
	name = "type-e electronic drone"
	icon_state = "setup_drone_genbot"
	desc = "A case for building69obile electronics. This one has a generic bot design."

/obj/item/device/electronic_assembly/drone/android
	name = "type-f electronic drone"
	icon_state = "setup_drone_android"
	desc = "A case for building69obile electronics. This one has a hominoid design."

/obj/item/device/electronic_assembly/wallmount
	name = "wall-mounted electronic assembly"
	icon_state = "setup_wallmount_medium"
	desc = "A case for building69edium-sized electronics. It has a69agnetized backing to allow it to stick to walls, but you'll still69eed to wrench the anchoring bolts in place to keep it on."
	w_class = ITEM_SIZE_NORMAL
	max_components = IC_MAX_SIZE_BASE * 2
	max_complexity = IC_COMPLEXITY_BASE * 2

/obj/item/device/electronic_assembly/wallmount/heavy
	name = "heavy wall-mounted electronic assembly"
	icon_state = "setup_wallmount_large"
	desc = "A case for building large electronics. It has a69agnetized backing to allow it to stick to walls, but you'll still69eed to wrench the anchoring bolts in place to keep it on."
	w_class = ITEM_SIZE_BULKY
	max_components = IC_MAX_SIZE_BASE * 4
	max_complexity = IC_COMPLEXITY_BASE * 4

/obj/item/device/electronic_assembly/wallmount/light
	name = "light wall-mounted electronic assembly"
	icon_state = "setup_wallmount_small"
	desc = "A case for building small electronics. It has a69agnetized backing to allow it to stick to walls, but you'll still69eed to wrench the anchoring bolts in place to keep it on."
	w_class = ITEM_SIZE_SMALL
	max_components = IC_MAX_SIZE_BASE
	max_complexity = IC_COMPLEXITY_BASE

/obj/item/device/electronic_assembly/wallmount/tiny
	name = "tiny wall-mounted electronic assembly"
	icon_state = "setup_wallmount_tiny"
	desc = "A case for building tiny electronics. It has a69agnetized backing to allow it to stick to walls, but you'll still69eed to wrench the anchoring bolts in place to keep it on."
	w_class = ITEM_SIZE_TINY
	max_components = IC_MAX_SIZE_BASE / 2
	max_complexity = IC_COMPLEXITY_BASE / 2

/obj/item/device/electronic_assembly/wallmount/afterattack(atom/a,69ob/user, proximity)
	if(proximity && istype(a ,/turf) && a.density)
		var/turf/T = a
		mount_assembly(T,user)

/obj/item/device/electronic_assembly/pickup()
	transform =69atrix() //Reset the69atrix.
	..()

/obj/item/device/electronic_assembly/wallmount/proc/mount_assembly(turf/on_wall,69ob/user) //Yeah, this is admittedly just an abridged and kitbashed69ersion of the wallframe attach procs.
	if(get_dist(on_wall,user)>1)
		return
	var/ndir = get_dir(on_wall, user)
	if(!(ndir in GLOB.cardinal))
		return
	var/turf/T = get_turf(user)
	if(!isfloor(T) && on_wall.density)
		to_chat(user, SPAN_WARNING("You cannot place 69src69 on this spot!"))
		return
	if(gotwallitem(T,69dir))
		to_chat(user, SPAN_WARNING("There's already an item on this wall!"))
		return
	playsound(src.loc, 'sound/machines/click.ogg', 75, 1)
	user.visible_message("69user.name69 attaches 69src69 to the wall.",
		SPAN_NOTICE("You attach 69src69 to the wall."),
		SPAN_NOTICE("You hear clicking."))
	if(user.unEquip(src,T))
		var/matrix/M =69atrix()
		switch(ndir)
			if(NORTH)
				pixel_y = -32
				pixel_x = 0
				M.Turn(180)
			if(SOUTH)
				pixel_y = 21
				pixel_x = 0
			if(EAST)
				pixel_x = -27
				pixel_y = 0
				M.Turn(270)
			if(WEST)
				pixel_x = 27
				pixel_y = 0
				M.Turn(90)
		transform =69

/obj/item/device/electronic_assembly/implant
	name = "electronic implant"
	icon_state = "setup_implant" // sprite is gone
	w_class = ITEM_SIZE_TINY
	max_components = IC_MAX_SIZE_BASE / 1.5
	max_complexity = IC_COMPLEXITY_BASE / 1.5
	var/obj/item/implant/integrated_circuit/implant
	bad_type = /obj/item/device/electronic_assembly/implant
	spawn_frequency = 0

/obj/item/device/electronic_assembly/implant/update_icon()
	..()
	implant.icon_state = icon_state
	implant.overlays = overlays

/obj/item/device/electronic_assembly/implant/save()
	var/list/saved_data = ..()
	saved_data69"type"69 = initial(implant.name)
	return saved_data

/obj/item/device/electronic_assembly/implant/nano_host()
	return implant || src // if implant doesn't exist it's bug, but an user will69ot see difference until he use it to implant :)
