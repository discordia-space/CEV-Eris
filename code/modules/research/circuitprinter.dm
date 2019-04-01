/*///////////////Circuit Imprinter (By Darem)////////////////////////
	Used to print new circuit boards (for computers and similar systems) and AI modules. Each circuit board pattern are stored in
a /datum/desgin on the linked R&D console. You can then print them out in a fasion similar to a regular lathe. However, instead of
using metal and glass, it uses glass and reagents (usually sulphuric acid).
*/

/obj/machinery/r_n_d/circuit_imprinter
	name = "\improper Circuit Imprinter"
	icon_state = "circuit_imprinter"
	reagent_flags = OPENCONTAINER
	var/list/datum/design/queue = list()
	var/progress = 0
	circuit = /obj/item/weapon/circuitboard/circuit_imprinter

	var/max_material_storage = 120
	var/speed = 1

	use_power = 1
	idle_power_usage = 30
	active_power_usage = 2500

/obj/machinery/r_n_d/circuit_imprinter/New()
	materials = default_material_composition.Copy()
	..()

/obj/machinery/r_n_d/circuit_imprinter/Process()
	..()
	if(stat)
		update_icon()
		return
	if(queue.len == 0)
		busy = 0
		update_icon()
		return
	var/datum/design/D = queue[1]
	if(canBuild(D))
		if(progress == 0)
			print_pre(D)
		busy = 1
		progress += speed
		if(progress >= D.time)
			build(D)
			progress = 0
			removeFromQueue(1)
			if(linked_console)
				linked_console.updateUsrDialog()
			print_post(D)
		update_icon()
	else
		if(busy)
			visible_message(SPAN_NOTICE("\icon[src]\The [src] flashes: insufficient materials: [getLackingMaterials(D)]."))
			busy = 0
			update_icon()

/obj/machinery/r_n_d/circuit_imprinter/RefreshParts()
	var/T = 0
	for(var/obj/item/weapon/reagent_containers/glass/G in component_parts)
		T += G.reagents.maximum_volume
	create_reagents(T)
	max_material_storage = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/M in component_parts)
		max_material_storage += M.rating * 25
	T = 0
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		T += M.rating
	speed = T

/obj/machinery/r_n_d/circuit_imprinter/update_icon()
	if(panel_open)
		icon_state = "circuit_imprinter_t"
	else if(busy)
		icon_state = "circuit_imprinter_ani"
	else
		icon_state = "circuit_imprinter"

/obj/machinery/r_n_d/circuit_imprinter/proc/TotalMaterials()
	var/t = 0
	for(var/f in materials)
		t += materials[f]
	return t

/obj/machinery/r_n_d/circuit_imprinter/dismantle()
	for(var/obj/I in component_parts)
		if(istype(I, /obj/item/weapon/reagent_containers/glass/beaker))
			reagents.trans_to_obj(I, reagents.total_volume)
	for(var/f in materials)
		if(materials[f] > 0)
			var/path = material_stack_type(f)
			if(path)
				var/obj/item/stack/S = new f(loc)
				S.amount = materials[f]
	..()

/obj/machinery/r_n_d/circuit_imprinter/attackby(var/obj/item/I, var/mob/user as mob)
	if(busy)
		user << SPAN_NOTICE("\icon[src]\The [src] is busy. Please wait for completion of previous operation.")
		return 1

	var/tool_type = I.get_tool_type(user, list(QUALITY_PRYING, QUALITY_SCREW_DRIVING), src)
	switch(tool_type)

		if(QUALITY_PRYING)
			if(!panel_open)
				user << SPAN_NOTICE("You cant get to the components of \the [src], remove the cover.")
				return
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
				user << SPAN_NOTICE("You remove the components of \the [src] with [I].")
				dismantle()
				return

		if(QUALITY_SCREW_DRIVING)
			var/used_sound = panel_open ? 'sound/machines/Custom_screwdriveropen.ogg' :  'sound/machines/Custom_screwdriverclose.ogg'
			if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC, instant_finish_tier = 30, forced_sound = used_sound))
				if(linked_console)
					linked_console.linked_imprinter = null
					linked_console = null
				panel_open = !panel_open
				user << SPAN_NOTICE("You [panel_open ? "open" : "close"] the maintenance hatch of \the [src] with [I].")
				update_icon()
				return

		if(ABORT_CHECK)
			return

	if(default_part_replacement(I, user))
		return
	if(panel_open)
		user << SPAN_NOTICE("You can't load \the [src] while it's opened.")
		return 1
	if(!linked_console)
		user << "\icon[src]\The [src] must be linked to an R&D console first."
		return 1
	if(I.is_drainable())
		return 0
	if(is_robot_module(I))
		return 0
	
	if(stat)
		return 1

	if (user.a_intent != I_HURT)
		loadMaterials(I, user)
	else
		return ..()

/obj/machinery/r_n_d/circuit_imprinter/proc/loadMaterials(var/obj/item/stack/material/S, var/mob/user)
	if(!istype(user))
		return

	if(!istype(S, /obj/item/stack/material))
		user << SPAN_NOTICE("You cannot insert this item into \the [src]!")
		return

	if(TotalMaterials() + 1 > max_material_storage)
		user << SPAN_NOTICE("\icon[src]\The [src]'s material bin is full. Please remove material before adding more.")
		return

	var/amount = round(input("How many sheets do you want to add?") as num)

	if(!Adjacent(user))
		return
	if(!S)
		return
	if(amount <= 0)//No negative numbers
		return
	if(amount > S.get_amount())
		amount = S.get_amount()
	if(max_material_storage - TotalMaterials() < amount) //Can't overfill
		amount = min(S.get_amount(), max_material_storage - TotalMaterials())

	busy = 1
	use_power(1000)
	var/material = S.get_material_name()
	if(material)
		res_load(material)
		if(do_after(usr, 16, src))
			if(S.use(amount))
				materials[material] += amount
				user << SPAN_NOTICE("You add [amount] [material] sheet\s to \the [src]. Material storage is [TotalMaterials()]/[max_material_storage] full.")
	busy = 0
	linked_console.updateUsrDialog()
	return TRUE

/obj/machinery/r_n_d/circuit_imprinter/examine(mob/user)
	..()
	user << "Material storage is [TotalMaterials()]/[max_material_storage] full."

/obj/machinery/r_n_d/circuit_imprinter/proc/res_load(var/name)
	// Will be here untill someone decided to draw insert animation
	//flick("protolathe_[]", src)

/obj/machinery/r_n_d/circuit_imprinter/proc/addToQueue(var/datum/design/D)
	queue += D
	return

/obj/machinery/r_n_d/circuit_imprinter/proc/removeFromQueue(var/index)
	queue.Cut(index, index + 1)
	return

/obj/machinery/r_n_d/circuit_imprinter/proc/canBuild(var/datum/design/D)
	for(var/M in D.materials)
		if(materials[M] < D.materials[M])
			return 0
	for(var/C in D.chemicals)
		if(!reagents.has_reagent(C, D.chemicals[C]))
			return 0
	return 1

/obj/machinery/r_n_d/circuit_imprinter/proc/getLackingMaterials(var/datum/design/D)
	var/ret = ""
	for(var/M in D.materials)
		if(materials[M] < D.materials[M])
			if(ret != "")
				ret += ", "
			ret += "[D.materials[M] - materials[M]] [M]"
	for(var/C in D.chemicals)
		if(!reagents.has_reagent(C, D.chemicals[C]))
			if(ret != "")
				ret += ", "
			ret += C
	return ret

/obj/machinery/r_n_d/circuit_imprinter/proc/build(var/datum/design/D)
	var/power = active_power_usage
	for(var/M in D.materials)
		power += round(D.materials[M] / 5)
	power = max(active_power_usage, power)
	use_power(power)
	for(var/M in D.materials)
		materials[M] = max(0, materials[M] - D.materials[M])
	for(var/C in D.chemicals)
		reagents.remove_reagent(C, D.chemicals[C])

	if(D.build_path)
		var/obj/new_item = D.Fabricate(src, src)
		new_item.loc = loc

/obj/machinery/r_n_d/circuit_imprinter/proc/print_pre(var/datum/design/D)
	return

/obj/machinery/r_n_d/circuit_imprinter/proc/print_post(var/datum/design/D)
	visible_message("\icon[src]\The [src] flashes, indicating that \the [D] is complete.", range = 3)
	if(!queue.len)
		playsound(src.loc, 'sound/machines/ping.ogg', 50, 1 -3)
		visible_message("\icon[src]\The [src] pings indicating that queue is complete.")
	return