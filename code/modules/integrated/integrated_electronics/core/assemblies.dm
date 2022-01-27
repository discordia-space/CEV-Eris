#define IC_COMPONENTS_BASE		20
#define IC_COMPLEXITY_BASE		80

/obj/item/device/electronic_assembly
	name = "electronic assembly"
	desc = "A case for building electronics."
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "setup_small"
	matter = list(MATERIAL_STEEL = 4)
	var/max_components = IC_COMPONENTS_BASE
	var/max_complexity = IC_COMPLEXITY_BASE
	var/opened = 0
	var/obj/item/cell/small/battery // Internal cell which69ost circuits need to work.

/obj/item/device/electronic_assembly/medium
	name = "electronic69echanism"
	icon_state = "setup_medium"
	w_class = ITEM_SIZE_NORMAL
	max_components = IC_COMPONENTS_BASE * 2
	max_complexity = IC_COMPLEXITY_BASE * 2

/obj/item/device/electronic_assembly/large
	name = "electronic69achine"
	icon_state = "setup_large"
	w_class = ITEM_SIZE_BULKY
	max_components = IC_COMPONENTS_BASE * 4
	max_complexity = IC_COMPLEXITY_BASE * 4

/obj/item/device/electronic_assembly/drone
	name = "electronic drone"
	icon_state = "setup_drone"
	w_class = ITEM_SIZE_NORMAL
	max_components = IC_COMPONENTS_BASE * 1.5
	max_complexity = IC_COMPLEXITY_BASE * 1.5

/obj/item/device/electronic_assembly/implant
	name = "electronic implant"
	icon_state = "setup_implant"
	w_class = ITEM_SIZE_TINY
	max_components = IC_COMPONENTS_BASE / 2
	max_complexity = IC_COMPLEXITY_BASE / 2
	var/obj/item/implant/integrated_circuit/implant
	bad_type = /obj/item/device/electronic_assembly/implant
	spawn_frequency = 0

/obj/item/device/electronic_assembly/New()
	..()
	battery = new(src)
	START_PROCESSING(SSobj, src)

/obj/item/device/electronic_assembly/Destroy()
	battery = null
	STOP_PROCESSING(SSobj, src)
	for(var/atom/movable/AM in contents)
		qdel(AM)
	. = ..()

/obj/item/device/electronic_assembly/Process()
	handle_idle_power()

/obj/item/device/electronic_assembly/proc/handle_idle_power()
	// First we generate power.
	for(var/obj/item/integrated_circuit/passive/power/P in contents)
		P.make_energy()

	// Now spend it.
	for(var/obj/item/integrated_circuit/IC in contents)
		if(IC.power_draw_idle)
			if(!draw_power(IC.power_draw_idle))
				IC.power_fail()

/obj/item/device/electronic_assembly/implant/update_icon()
	..()
	implant.icon_state = icon_state


/obj/item/device/electronic_assembly/implant/nano_host()
	return implant

/obj/item/device/electronic_assembly/proc/resolve_nano_host()
	return src

/obj/item/device/electronic_assembly/implant/resolve_nano_host()
	return implant

/obj/item/device/electronic_assembly/interact(mob/user)
	if(!CanInteract(user,GLOB.physical_state))
		return

	var/total_parts = 0
	var/total_complexity = 0
	for(var/obj/item/integrated_circuit/part in contents)
		total_parts++
		total_complexity = total_complexity + part.complexity
	var/HTML = list()

	HTML += "<html><head><title>69src.name69</title></head><body>"
	HTML += "<br><a href='?src=\ref69src69'>\69Refresh\69</a>  |  "
	HTML += "<a href='?src=\ref69src69;rename=1'>\69Rename\69</a><br>"
	HTML += "69total_parts69/69max_components69 (69round((total_parts /69ax_components) * 100, 0.1)69%) space taken up in the assembly.<br>"
	HTML += "69total_complexity69/69max_complexity69 (69round((total_complexity /69ax_complexity) * 100, 0.1)69%)69aximum complexity.<br>"
	if(battery)
		HTML += "69round(battery.charge, 0.1)69/69battery.maxcharge69 (69round(battery.percent(), 0.1)69%) cell charge. <a href='?src=\ref69src69;remove_cell=1'>\69Remove\69</a>"
	else
		HTML += SPAN_DANGER("No powercell detected!")
	HTML += "<br><br>"
	HTML += "Components;<br>"
	for(var/obj/item/integrated_circuit/circuit in contents)
		HTML += "<a href=?src=\ref69circuit69;examine=1>69circuit.name69</a> | "
		HTML += "<a href=?src=\ref69circuit69;rename=1>\69Rename\69</a> | "
		HTML += "<a href=?src=\ref69circuit69;scan=1>\69Scan with Debugger\69</a> | "
		if(circuit.removable)
			HTML += "<a href=?src=\ref69circuit69;remove=1>\69Remove\69</a>"
		HTML += "<br>"

	HTML += "</body></html>"
	user << browse(jointext(HTML,null), "window=assembly-\ref69src69;size=600x350;border=1;can_resize=1;can_close=1;can_minimize=1")

/obj/item/device/electronic_assembly/Topic(href, href_list6969)
	if(..())
		return 1

	if(href_list69"rename"69)
		rename(usr)

	if(href_list69"remove_cell"69)
		if(!battery)
			to_chat(usr, SPAN_WARNING("There's no power cell to remove from \the 69src69."))
		else
			var/turf/T = get_turf(src)
			battery.forceMove(T)
			playsound(T, 'sound/items/Crowbar.ogg', 50, 1)
			to_chat(usr, SPAN_NOTICE("You pull \the 69battery69 out of \the 69src69's power supplier."))
			battery = null

	interact(usr) // To refresh the UI.

/obj/item/device/electronic_assembly/verb/rename()
	set name = "Rename Circuit"
	set category = "Object"
	set desc = "Rename your circuit, useful to stay organized."

	var/mob/M = usr
	if(!CanInteract(M,GLOB.physical_state))
		return

	var/input = sanitizeSafe(input("What do you want to name this?", "Rename", src.name) as null|text,69AX_NAME_LEN)
	if(src && input && CanInteract(M,GLOB.physical_state))
		to_chat(M, SPAN_NOTICE("The69achine now has a label reading '69input69'."))
		name = input

/obj/item/device/electronic_assembly/proc/can_move()
	return FALSE

/obj/item/device/electronic_assembly/drone/can_move()
	return TRUE

/obj/item/device/electronic_assembly/update_icon()
	if(opened)
		icon_state = initial(icon_state) + "-open"
	else
		icon_state = initial(icon_state)

/obj/item/device/electronic_assembly/GetAccess()
	. = list()
	for(var/obj/item/integrated_circuit/part in contents)
		. |= part.GetAccess()

/obj/item/device/electronic_assembly/GetIdCard()
	. = list()
	for(var/obj/item/integrated_circuit/part in contents)
		var/id_card = part.GetIdCard()
		if(id_card)
			return id_card

/obj/item/device/electronic_assembly/examine(mob/user)
	. = ..(user, 1)
	if(.)
		for(var/obj/item/integrated_circuit/IC in contents)
			IC.external_examine(user)
	//	for(var/obj/item/integrated_circuit/output/screen/S in contents)
	//		if(S.stuff_to_display)
	//			to_chat(user, "There's a little screen labeled '69S.name69', which displays '69S.stuff_to_display69'.")
		if(opened)
			interact(user)

/obj/item/device/electronic_assembly/proc/get_part_complexity()
	. = 0
	for(var/obj/item/integrated_circuit/part in contents)
		. += part.complexity

/obj/item/device/electronic_assembly/proc/get_part_size()
	. = 0
	for(var/obj/item/integrated_circuit/part in contents)
		. += part.w_class

// Returns true if the circuit69ade it inside.
/obj/item/device/electronic_assembly/proc/add_circuit(var/obj/item/integrated_circuit/IC,69ar/mob/user)
	if(!opened)
		to_chat(user, SPAN_WARNING("\The 69src69 isn't opened, so you can't put anything inside.  Try using a crowbar."))
		return FALSE

	if(IC.w_class > src.w_class)
		to_chat(user, SPAN_WARNING("\The 69IC69 is way too big to fit into \the 69src69."))
		return FALSE

	var/total_part_size = get_part_size()
	var/total_complexity = get_part_complexity()

	if((total_part_size + IC.w_class) >69ax_components)
		to_chat(user, SPAN_WARNING("You can't seem to add the '69IC.name69', as there's insufficient space."))
		return FALSE
	if((total_complexity + IC.complexity) >69ax_complexity)
		to_chat(user, SPAN_WARNING("You can't seem to add the '69IC.name69', since this setup's too complicated for the case."))
		return FALSE

	if(!IC.forceMove(src))
		return FALSE

	IC.assembly = src

	return TRUE

/obj/item/device/electronic_assembly/afterattack(atom/target,69ob/user, proximity)
	if(proximity)
		var/scanned = FALSE
		for(var/obj/item/integrated_circuit/input/sensor/S in contents)
//			S.set_pin_data(IC_OUTPUT, 1, weakref(target))
//			S.check_then_do_work()
			if(S.scan(target))
				scanned = TRUE
		if(scanned)
			visible_message(SPAN_NOTICE("\The 69user69 waves \the 69src69 around 69target69."))

/obj/item/device/electronic_assembly/attackby(var/obj/item/I,69ar/mob/user)
	if(istype(I, /obj/item/integrated_circuit))
		if(!user.unEquip(I))
			return 0
		if(add_circuit(I, user))
			to_chat(user, SPAN_NOTICE("You slide \the 69I69 inside \the 69src69."))
			playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
			interact(user)
	if(QUALITY_PRYING in I.tool_qualities)
		if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, QUALITY_PRYING, FAILCHANCE_EASY, required_stat = STAT_MEC))
			opened = !opened
			to_chat(user, "<span class='notice'>You 69opened ? "opened" : "closed"69 \the 69src69.</span>")
			update_icon()
	else if(istype(I, /obj/item/device/electronics/integrated/wirer) || istype(I, /obj/item/device/electronics/integrated/debugger) || istype(I, /obj/item/tool/screwdriver))
		if(opened)
			interact(user)
		else
			to_chat(user, SPAN_WARNING("\The 69src69 isn't opened, so you can't fiddle with the internal components.  \
			Try using a crowbar."))
	else if(istype(I, /obj/item/cell/small))
		if(!opened)
			to_chat(user, SPAN_WARNING("\The 69src69 isn't opened, so you can't put anything inside.  Try using a crowbar."))
			return FALSE
		if(battery)
			to_chat(user, SPAN_WARNING("\The 69src69 already has \a 69battery69 inside.  Remove it first if you want to replace it."))
			return FALSE
		var/obj/item/cell/small/cell = I
		user.drop_item(cell)
		cell.forceMove(src)
		battery = cell
		playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("You slot \the 69cell69 inside \the 69src69's power supplier."))
		interact(user)

	else
		return ..()

/obj/item/device/electronic_assembly/attack_self(mob/user)
	if(opened)
		interact(user)

	var/list/available_inputs = list()
	for(var/obj/item/integrated_circuit/input/input in contents)
		if(input.can_be_asked_input)
			available_inputs.Add(input)
	var/obj/item/integrated_circuit/input/choice = input(user, "What do you want to interact with?", "Interaction") as null|anything in available_inputs
	if(choice && CanInteract(user,GLOB.physical_state))
		choice.ask_for_input(user)

/obj/item/device/electronic_assembly/emp_act(severity)
	..()
	for(var/atom/movable/AM in contents)
		AM.emp_act(severity)

// Returns true if power was successfully drawn.
/obj/item/device/electronic_assembly/proc/draw_power(amount)
	if(battery && battery.checked_use(amount * CELLRATE))
		return TRUE
	return FALSE

// Ditto for giving.
/obj/item/device/electronic_assembly/proc/give_power(amount)
	if(battery && battery.give(amount * CELLRATE))
		return TRUE
	return FALSE