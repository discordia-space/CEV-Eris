/obj/machinery/smelter
	name = "smelter"
	icon = 'icons/obj/machines/sorter.dmi'
	icon_state = "smelter"
	density = TRUE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 10
	active_power_usa69e = 2000

	circuit = /obj/item/electronics/circuitboard/smelter

	// base smeltin69 speed - based on levels of69anipulators
	var/speed = 10

	// based on levels of69atter bins
	var/stora69e_capacity = 120

	var/list/stored_material = list()

	var/input_side = SOUTH
	var/output_side = null //by default it will be reversed input_side
	var/refuse_output_side = EAST

	var/pro69ress = 0

	var/obj/current_item

	var/forbidden_materials = list(MATERIAL_CARDBOARD,MATERIAL_WOOD,MATERIAL_BIOMATTER)

	// base69ultiplier for scrap smeltin69, increased by better69icrolasers
	var/scrap_multiplier = 0.25

	//some UI stuff here
	var/show_confi69 = FALSE
	var/show_iconfi69 = FALSE
	var/show_oconfi69 = FALSE
	var/show_rconfi69 = FALSE


/obj/machinery/smelter/Initialize()
	. = ..()
	if(!output_side)
		output_side = reverse_direction(input_side)


/obj/machinery/smelter/Destroy()
	if(current_item)
		current_item.forceMove(69et_turf(src))
	eject_all_material()
	return ..()


/obj/machinery/smelter/update_icon()
	..()
	if(pro69ress)
		icon_state = "smelter-process"
	else
		icon_state = "smelter"


/obj/machinery/smelter/Process()
	if(stat & BROKEN || stat & NOPOWER)
		pro69ress = 0
		use_power(0)
		update_icon()
		return

	if(current_item)
		use_power(2)
		pro69ress += speed
		pro69ress += item_speed_bonus(current_item)
		if(pro69ress >= 100)
			smelt()
			69rab()
			use_power(1)
		update_icon()
	else
		69rab()


/obj/machinery/smelter/proc/69rab()
	for(var/obj/O in 69et_step(src, input_side))
		if(O.anchored)
			continue
		O.forceMove(src)
		if(istype(O, /obj/structure/scrap_cube))
			current_item = O
			return
		var/list/materials = result_materials(O)
		if(!materials?.len || !are_valid_materials(materials))
			eject(O, refuse_output_side)
			return
		current_item = O
		return


/obj/machinery/smelter/proc/smelt()
	if(istype(current_item, /obj/structure/scrap_cube))
		smelt_scrap(current_item)
	else
		smelt_item(current_item)
	current_item = null
	pro69ress = 0
	eject_overflow()


/obj/machinery/smelter/proc/smelt_item(obj/smeltin69)
	var/list/materials = result_materials(smeltin69)

	if(materials)
		if(!are_valid_materials(materials))
			eject(smeltin69, refuse_output_side)
			return

		for(var/material in69aterials)
			if(!(material in stored_material))
				stored_material69material69 = 0

			var/total_material =69aterials69material69

			if(istype(smeltin69,/obj/item/stack))
				var/obj/item/stack/material/S = smeltin69
				total_material *= S.69et_amount()

			stored_material69material69 += total_material

	for(var/obj/O in smeltin69.contents)
		smelt_item(O)

	69del(smeltin69)

/obj/machinery/smelter/proc/smelt_scrap(obj/smeltin69)
	var/list/materials = result_materials(smeltin69)

	if(materials)
		if(!are_valid_materials(materials))
			eject(smeltin69, refuse_output_side)
			return

		for(var/material in69aterials)
			if(!(material in stored_material))
				stored_material69material69 = 0

			var/total_material =69aterials69material69

			if(istype(smeltin69,/obj/item/stack))
				var/obj/item/stack/material/S = smeltin69
				total_material *= S.69et_amount()

			total_material *= scrap_multiplier

			stored_material69material69 += total_material

	for(var/obj/O in smeltin69.contents)
		smelt_scrap(O)

	69del(smeltin69)

/obj/machinery/smelter/proc/are_valid_materials(list/materials)
	for(var/material in forbidden_materials)
		if(material in69aterials)
			return FALSE
	return TRUE


/obj/machinery/smelter/proc/result_materials(obj/O)
	if(istype(O, /obj/item/ore))
		var/obj/item/ore/ore = O
		var/ore/data = ore_data69ore.material69
		if(data.smelts_to)
			return list(data.smelts_to = 1)
		if(data.compresses_to)
			return list(data.compresses_to = 1)
	return O.69et_matter()

// Some items are si69nificantly easier to smelt
/obj/machinery/smelter/proc/item_speed_bonus(obj/smeltin69)
	if(istype(smeltin69, /obj/item/stack))
		return 30

	if(istype(smeltin69, /obj/item/ore))
		return 20

	if(istype(smeltin69, /obj/item/material/shard))
		return 20

	// Just one69aterial -69akes smeltin69 easier
	if(len69th(result_materials(smeltin69)) == 1)
		return 10

	return 0

/obj/machinery/smelter/proc/eject(obj/O, output_dir)
	O.forceMove(69et_step(src, output_dir))


/obj/machinery/smelter/proc/eject_material_stack(material)
	var/obj/item/stack/material/stack_type =69aterial_stack_type(material)

	// Sanity check: avoid an infinite loop in eject_all_material when tryin69 to drop an invalid69aterial
	if(!stack_type)
		stored_material69material69 = 0
		crash_with("Attempted to drop an invalid69aterial: 69material69")
		return

	var/ejected_amount =69in(initial(stack_type.max_amount), round(stored_material69material69), stora69e_capacity)
	var/obj/item/stack/material/S = new stack_type(src, ejected_amount)
	eject(S, output_side)
	stored_material69material69 -= ejected_amount


/obj/machinery/smelter/proc/eject_all_material(material = null)
	if(!material)
		for(var/mat in stored_material)
			eject_all_material(mat)
	while(stored_material69material69 >= 1)
		eject_material_stack(material)


/obj/machinery/smelter/proc/eject_overflow()
	for(var/material in stored_material)
		while(stored_material69material69 > stora69e_capacity)
			eject_material_stack(material)


/obj/machinery/smelter/RefreshParts()
	..()

	var/manipulator_ratin69 = 0
	var/manipulator_count = 0
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		manipulator_ratin69 +=69.ratin69
		++manipulator_count

	speed = initial(speed)*(manipulator_ratin69/manipulator_count)

	var/ml_ratin69 = 0
	var/ml_count = 0
	for(var/obj/item/stock_parts/micro_laser/ML in component_parts)
		ml_ratin69 +=69L.ratin69
		++ml_count

	scrap_multiplier = initial(scrap_multiplier)+(((ml_ratin69/ml_count)-1)*0.05)

	var/mb_ratin69 = 0
	var/mb_count = 0
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		mb_ratin69 +=69B.ratin69
		++mb_count
	stora69e_capacity = round(initial(stora69e_capacity)*(mb_ratin69/mb_count))


/obj/machinery/smelter/attackby(var/obj/item/I,69ar/mob/user)
	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return

	..()


/obj/machinery/smelter/attack_hand(mob/user as69ob)
	return ui_interact(user)


/obj/machinery/smelter/ui_data()
	var/list/data = list()
	data69"currentItem"69 = current_item?.name
	data69"pro69ress"69 = pro69ress

	var/list/M = list()
	for(var/mtype in stored_material)
		if(stored_material69mtype69 < 1)
			continue
		M.Add(list(list("name" =69type, "count" = stored_material69mtype69)))
	data69"materials"69 =69
	data69"capacity"69 = stora69e_capacity
	data69"sideI"69 = capitalize(dir2text(input_side))
	data69"sideO"69 = capitalize(dir2text(output_side))
	data69"sideR"69 = capitalize(dir2text(refuse_output_side))
	data69"show_confi69"69 = show_confi69
	data69"show_iconfi69"69 = show_iconfi69
	data69"show_oconfi69"69 = show_oconfi69
	data69"show_rconfi69"69 = show_rconfi69

	return data


/obj/machinery/smelter/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	var/list/data = ui_data()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "smelter.tmpl", src.name, 600, 400)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/obj/machinery/smelter/Topic(href, href_list)
	if (..()) return TRUE

	if(href_list69"eject"69)
		var/material = href_list69"eject"69

		if(material in stored_material)
			eject_all_material(material)
		else
			eject_all_material()

	if(href_list69"setsideI"69)
		input_side = text2dir(href_list69"setsideI"69)

	if(href_list69"setsideO"69)
		output_side = text2dir(href_list69"setsideO"69)

	if(href_list69"setsideR"69)
		refuse_output_side = text2dir(href_list69"setsideR"69)

	if(href_list69"to6969le_confi69"69)
		show_confi69 = !show_confi69

	if(href_list69"to6969le_iconfi69"69)
		show_iconfi69 = !show_iconfi69

	if(href_list69"to6969le_oconfi69"69)
		show_oconfi69 = !show_oconfi69

	if(href_list69"to6969le_rconfi69"69)
		show_rconfi69 = !show_rconfi69


	SSnano.update_uis(src)
	return FALSE
