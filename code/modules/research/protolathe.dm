/obj/machinery/r_n_d/protolathe
	name = "\improper Protolathe"
	icon_state = "protolathe"
	reagent_flags = OPENCONTAINER
	circuit = /obj/item/weapon/circuitboard/protolathe

	use_power = TRUE
	idle_power_usage = 30
	active_power_usage = 5000

	var/max_material_storage = 120

	var/list/datum/design/queue = list()
	var/progress = 0

	var/speed = 1

/obj/machinery/r_n_d/protolathe/New()
	materials = default_material_composition.Copy()
	..()

/obj/machinery/r_n_d/protolathe/Process()
	..()
	if(stat)
		update_icon()
		return
	if(queue.len == 0)
		busy = FALSE
		update_icon()
		return
	var/datum/design/D = queue[1]
	if(canBuild(D))
		if(progress == 0)
			print_pre(D)
		busy = TRUE
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
			busy = FALSE
			update_icon()

/obj/machinery/r_n_d/protolathe/proc/TotalMaterials() //returns the total of all the stored materials. Makes code neater.
	var/t = 0
	for(var/f in materials)
		t += materials[f]
	return t

/obj/machinery/r_n_d/protolathe/RefreshParts()
	var/T = 0
	for(var/obj/item/weapon/reagent_containers/glass/G in component_parts)
		T += G.reagents.maximum_volume
	create_reagents(T)
	max_material_storage = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/M in component_parts)
		max_material_storage += M.rating * 60
	T = 0
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		T += M.rating
	speed = T / 2

/obj/machinery/r_n_d/protolathe/dismantle()
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

/obj/machinery/r_n_d/protolathe/update_icon()
	overlays.Cut()
	if(panel_open)
		icon_state = "protolathe_t"
	else if(busy)
		icon_state = "protolathe_n"
	else
		icon_state = "protolathe"

/obj/machinery/r_n_d/protolathe/attackby(var/obj/item/I, var/mob/user as mob)
	if(busy)
		user << SPAN_NOTICE("\icon[src]\The [src] is busy. Please wait for completion of previous operation.")
		return TRUE

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
					linked_console.linked_lathe = null
					linked_console = null
				panel_open = !panel_open
				user << SPAN_NOTICE("You [panel_open ? "open" : "close"] the maintenance hatch of \the [src] with [I].")
				update_icon()
				return

		if(ABORT_CHECK)
			return

	if(default_part_replacement(I, user))
		return
	if(I.is_drainable())
		return FALSE
	if(panel_open)
		user << SPAN_NOTICE("You can't load \the [src] while it's opened.")
		return TRUE
	if(!linked_console)
		user << SPAN_NOTICE("\icon[src]\The [src] must be linked to an R&D console first!")
		return TRUE
	if(is_robot_module(I))
		return FALSE
	if (user.a_intent != I_HURT)
		loadMaterials(I, user)
	else
		return ..()

/obj/machinery/r_n_d/protolathe/proc/loadMaterials(var/obj/item/stack/material/S, var/mob/user)
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

	busy = TRUE
	use_power(1000)
	var/material = S.get_material_name()
	if(material)
		if(do_after(usr, 16, src))
			res_load(material)
			if(S.use(amount))
				materials[material] += amount
				user << SPAN_NOTICE("You add [amount] [material] sheet\s to \the [src]. Material storage is [TotalMaterials()]/[max_material_storage] full.")

	busy = FALSE
	linked_console.updateUsrDialog()
	return TRUE

/obj/machinery/r_n_d/protolathe/examine(mob/user)
	..()
	user << "Material storage is [TotalMaterials()]/[max_material_storage] full."

/obj/machinery/r_n_d/protolathe/proc/res_load(var/name)
	var/obj/effect/temp_visual/resourceInsertion/protolathe/effect = new(src.loc)
	effect.setMaterial(name)

/obj/machinery/r_n_d/protolathe/proc/addToQueue(var/datum/design/D)
	queue += D
	return

/obj/machinery/r_n_d/protolathe/proc/removeFromQueue(var/index)
	queue.Cut(index, index + 1)
	return

/obj/machinery/r_n_d/protolathe/proc/canBuild(var/datum/design/D)
	for(var/M in D.materials)
		if(materials[M] < D.materials[M])
			return FALSE
	for(var/C in D.chemicals)
		if(!reagents.has_reagent(C, D.chemicals[C]))
			return FALSE
	return TRUE

/obj/machinery/r_n_d/protolathe/proc/getLackingMaterials(var/datum/design/D)
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

/obj/machinery/r_n_d/protolathe/proc/build(var/datum/design/D)
	var/power = active_power_usage
	for(var/M in D.materials)
		power += round(D.materials[M] / 5, 0.01)
	power = max(active_power_usage, power)
	use_power(power)
	for(var/M in D.materials)
		materials[M] = max(0, materials[M] - D.materials[M])
	for(var/C in D.chemicals)
		reagents.remove_reagent(C, D.chemicals[C])

	if(D.build_path)
		var/obj/new_item = D.Fabricate(src, src)
		new_item.loc = loc
		new_item.Created()

/obj/machinery/r_n_d/protolathe/proc/print_pre(var/datum/design/D)
	return

/obj/machinery/r_n_d/protolathe/proc/print_post(var/datum/design/D)
	visible_message("\icon[src]\The [src] flashes, indicating that \the [D] is complete.", range = 3)
	if(!queue.len)
		playsound(src.loc, 'sound/machines/ping.ogg', 50, 1 -3)
		visible_message("\icon[src]\The [src] pings indicating that queue is complete.")
	return