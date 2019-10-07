/obj/machinery/smelter
	name = "smelter"
	icon = 'icons/obj/machines/sorter.dmi' //placeholder
	icon_state = "sorter" //placeholder
	density = TRUE
	anchored = TRUE
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 2000

	circuit = /obj/item/weapon/circuitboard/smelter

	// based on levels of manipulators
	var/speed = 5

	var/list/stored_material = list()

	var/output_side = null //by default it will be reversed smelter's dir

	var/progress = 0

	var/obj/item/current_item

	var/forbidden_materials = list(MATERIAL_CARDBOARD,MATERIAL_WOOD,MATERIAL_BIOMATTER)

/obj/machinery/smelter/Initialize()
	. = ..()
	if(!output_side)
		output_side = reverse_direction(dir)


/obj/machinery/smelter/Destroy()
	if(current_item)
		current_item.forceMove(get_turf(src))
	return ..()


/obj/machinery/smelter/update_icon()
	..()
	if(progress)
		icon_state = "sorter-process" //placeholder
	else
		icon_state = "sorter" //placeholder


/obj/machinery/smelter/Process()
	if(stat & BROKEN || stat & NOPOWER)
		progress = 0
		use_power(0)
		update_icon()
		return

	if(current_item)
		use_power(2)
		progress += speed
		if(progress >= 100)
			smelt()
			progress = 0
			use_power(1)
		update_icon()
	else
		grab()


/obj/machinery/smelter/proc/grab()
	for(var/obj/item/I in get_step(src, dir))
		if(I.anchored)
			continue
		I.forceMove(src)
		var/list/materials = result_materials(I)
		if(!materials?.len || !are_valid_materials(materials))
			eject(I)
			return
		current_item = I
		return


/obj/machinery/smelter/proc/smelt()
	smelt_item(current_item)
	current_item = null

	for(var/material in stored_material)
		var/obj/item/stack/material/stack_type = material_stack_type(material)
		var/stack_size = initial(stack_type.max_amount)
		while(stored_material[material] >= 1)
			var/ejected_amount = min(stack_size, round(stored_material[material]))
			var/obj/item/stack/material/S = new stack_type(src, ejected_amount)
			eject(S)
			stored_material[material] -= ejected_amount


/obj/machinery/smelter/proc/smelt_item(obj/smelting)
	var/list/materials = result_materials(smelting)

	if(materials)
		if(!are_valid_materials(materials))
			eject(smelting)
			return

		for(var/material in materials)
			if(!(material in stored_material))
				stored_material[material] = 0

			var/total_material = materials[material]

			if(istype(smelting,/obj/item/stack))
				var/obj/item/stack/material/S = smelting
				total_material *= S.get_amount()

			stored_material[material] += total_material

	for(var/obj/O in smelting.contents)
		smelt_item(O)

	qdel(smelting)


/obj/machinery/smelter/proc/are_valid_materials(list/materials)
	for(var/material in forbidden_materials)
		if(material in materials)
			return FALSE
	return TRUE


/obj/machinery/smelter/proc/result_materials(obj/O)
	if(istype(O, /obj/item/weapon/ore))
		var/obj/item/weapon/ore/ore = O
		var/ore/data = ore_data[ore.material]
		. = list()
		if(data.smelts_to)
			.[data.smelts_to] = 1
		return
	return O.get_matter()


/obj/machinery/smelter/proc/eject(obj/O)
	O.forceMove(get_step(src, output_side))


/obj/machinery/smelter/RefreshParts()
	..()

	var/manipulator_rating = 0
	var/manipulator_count = 0
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		manipulator_rating += M.rating
		++manipulator_count
	speed = initial(speed)*(manipulator_rating/manipulator_count)


/obj/machinery/smelter/attackby(var/obj/item/I, var/mob/user)
	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return

	..()


/obj/machinery/smelter/attack_hand(mob/user as mob)
	return ui_interact(user)


/obj/machinery/smelter/ui_data()
	var/list/data = list()
	data["currentItem"] = current_item?.name
	data["progress"] = progress

	return data


/obj/machinery/smelter/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	var/list/data = ui_data()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "smelter.tmpl", src.name, 600, 400)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
