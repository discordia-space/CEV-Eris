/obj/machinery/autolathe
	name = "autolathe"
	desc = "It produces items using metal and glass."
	icon_state = "autolathe"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 2000
	circuit = /obj/item/weapon/circuitboard/autolathe

	var/obj/item/weapon/disk/autolathe_disk/disk = null

	var/list/stored_material =  list()
	var/list/storage_capacity = list(DEFAULT_WALL_MATERIAL = 0, "glass" = 0)
	var/show_category = "All"

	var/hacked = 0
	var/disabled = 0
	var/shocked = 0

	var/making_left = 0
	var/making_total = 0
	var/datum/autolathe/recipe/making_recipe = null
	var/not_enough_resources = FALSE

	var/mat_efficiency = 1
	var/build_time = 50

	var/tmp/datum/wires/autolathe/wires = null


/obj/machinery/autolathe/New()
	..()
	wires = new(src)

/obj/machinery/autolathe/Destroy()
	if(wires)
		qdel(wires)
		wires = null
	return ..()


/obj/machinery/autolathe/ui_interact(mob/user, ui_key = "main",var/datum/nanoui/ui = null, var/force_open = 1)
	var/list/data = list()

	data["disk"] = null
	if(disk)
		data["disk"] = disk.category
		data["uses"] = disk.license

		var/list/L = list()
		for(var/rtype in disk.recipes)
			var/datum/autolathe/recipe/R = autolathe_recipes[rtype]
			var/list/LE = list()
			LE["name"] = R.name
			LE["enough"] = 1

			for(var/mat in R.resources)
				if(!(mat in stored_material) || R.resources[mat] > stored_material[mat])
					LE["enough"] = 0
					break
			L.Add(LE)

		data["recipes"] = L

		var/list/M = list()
		for(var/mtype in storage_capacity)
			var/list/ME = list()
			ME["name"] = mtype

			if(mtype in stored_material)
				ME["count"] = stored_material[mtype]
			else
				ME["count"] = 0

			M.Add(ME)

		data["materials"] = M

	if(making_recipe)
		var/datum/autolathe/recipe/R = making_recipe
		data["busyname"] = R.name
		data["busynow"] = making_left
		data["busytotal"] = making_total
		data["resout"] = not_enough_resources

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "autolathe.tmpl", "Autolathe", 390, 655)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()


/obj/machinery/autolathe/attackby(var/obj/item/I, var/mob/user)

	if(making_recipe && !not_enough_resources)
		user << SPAN_NOTICE("\The [src] is busy. Please wait for completion of previous operation.")
		return

	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return

	if(stat)
		return

	if(panel_open)
		//Don't eat anything used on an open lathe.
		return FALSE

	if(istype(I, /obj/item/weapon/tool))
		//Don't eat tools.
		return FALSE

	if(I.loc != user && !(istype(I,/obj/item/stack)))
		return FALSE

	if(is_robot_module(I))
		return FALSE

	if(!making_recipe && istype(I,/obj/item/weapon/disk/autolathe_disk))
		if(disk)
			user << SPAN_NOTICE("There's already a disk inside the autolathe.")
			return
		user.drop_item()
		disk = I
		I.forceMove(src)
		user << SPAN_NOTICE("You put the disk into the autolathe.")
		return

	//Resources are being loaded.
	var/obj/item/eating = I
	if(!eating.matter || !eating.matter.len)
		user << SPAN_NOTICE("\The [eating] does not contain significant amounts of useful materials and cannot be accepted.")
		return

	var/filltype = 0       // Used to determine message.
	var/total_used = 0     // Amount of material used.
	var/mass_per_sheet = 0 // Amount of material constituting one sheet.

	for(var/material in eating.matter)
		if(!(material in storage_capacity))
			continue

		if(!(material in stored_material))
			stored_material[material] = 0

		if(stored_material[material] >= storage_capacity[material])
			continue

		var/total_material = round(eating.matter[material])

		//If it's a stack, we eat multiple sheets.
		if(istype(eating,/obj/item/stack))
			var/obj/item/stack/stack = eating
			total_material *= stack.get_amount()

		if(stored_material[material] + total_material > storage_capacity[material])
			total_material = storage_capacity[material] - stored_material[material]
			filltype = 1
		else
			filltype = 2

		stored_material[material] += total_material
		total_used += total_material
		mass_per_sheet += eating.matter[material]

	if(!filltype)
		user << SPAN_NOTICE("\The [src] is full. Please remove material from the autolathe in order to insert more.")
		return
	else if(filltype == 1)
		user << SPAN_NOTICE("You fill \the [src] to capacity with \the [eating].")
	else
		user << SPAN_NOTICE("You fill \the [src] with \the [eating].")

	flick("autolathe_o", src) // Plays metal insertion animation. Work out a good way to work out a fitting animation. ~Z

	if(istype(eating,/obj/item/stack))
		var/obj/item/stack/stack = eating
		stack.use(max(1, round(total_used/mass_per_sheet))) // Always use at least 1 to prevent infinite materials.
	else
		user.remove_from_mob(I)
		qdel(I)

	if(making_recipe && making_left)
		make(making_recipe,making_left)

	nanomanager.update_uis(src)
	return

/obj/machinery/autolathe/attack_hand(mob/user as mob)
	user.set_machine(src)
	ui_interact(user)

/obj/machinery/autolathe/Topic(href, href_list)

	if(..())
		return

	add_fingerprint(usr)

	usr.set_machine(src)
	if(!making_recipe)
		if(href_list["eject_disk"] && disk)
			disk.forceMove(src.loc)
			disk = null

		if(href_list["eject_material"])
			var/material = href_list["eject_material"]
			var/obj/item/stack/material/sheetType = get_material_stack_type(material)
			var/perUnit = initial(sheetType.perunit)

			var/num = input("Enter sheets count to eject. 0-[stored_material[material]/perUnit]","Eject",0) as num
			num = min(max(num,0),stored_material[material]/perUnit)

			eject(material,num*perUnit)

		if(href_list["print_one"] && disk)
			var/recipe = disk.recipes[text2num(href_list["print_one"])]
			make(recipe,1)

		if(href_list["print_several"] && disk)
			var/recipe = disk.recipes[text2num(href_list["print_one"])]
			var/num = input("Enter items count to print.","Print") as num
			make(recipe,num)

	if(href_list["abort_print"])
		making_recipe = null
		making_left = 0
		making_total = 0

	nanomanager.update_uis(src)

/obj/machinery/autolathe/proc/make(var/recipe, var/amount)
	not_enough_resources = FALSE
	making_recipe = autolathe_recipes[recipe]
	making_total = amount

	for(making_left = amount; making_left <= 0;)
		update_use_power(2)

		if(!disk || disk.license < 0)
			return

		//Check if we still have the materials.
		for(var/material in making_recipe.resources)
			if(!isnull(stored_material[material]))
				if(stored_material[material] < round(making_recipe.resources[material] * mat_efficiency))
					not_enough_resources = TRUE
					return

		//Consume materials.
		for(var/material in making_recipe.resources)
			if(!isnull(stored_material[material]))
				stored_material[material] = max(0, stored_material[material] - round(making_recipe.resources[material] * mat_efficiency))


		//Fancy autolathe animation.
		flick("autolathe_n", src)

		if(ispath(making_recipe.path,/obj/item/stack))
			sleep(max(5,round(build_time/30)))
		else
			sleep(build_time)

		//Sanity check.
		update_use_power(1)

		if(!making_recipe || !src)
			return

		making_left--
		disk.license--

		//Create the desired item.
		if(ispath(making_recipe.path,/obj/item/stack))
			var/obj/item/stack/S = locate(making_recipe.path, loc)
			if(S && S.max_amount < S.amount)
				S.amount++
			else
				new making_recipe.path(loc)
		else
			new making_recipe.path(loc)

		nanomanager.update_uis(src)

	making_recipe = null
	making_total = 0

/obj/machinery/autolathe/proc/eject(var/material, var/amount)
	if(!(material in stored_material))
		return
	var/obj/item/stack/material/sheetType = get_material_stack_type(material)
	var/perUnit = initial(sheetType.perunit)
	var/eject = round(stored_material[material] / perUnit)
	eject = amount == -1 ? eject : min(eject, amount)
	if(eject < 1)
		return
	var/obj/item/stack/material/S = new sheetType(loc)
	S.amount = eject
	stored_material[material] -= eject * perUnit

/obj/machinery/autolathe/update_icon()
	icon_state = (panel_open ? "autolathe_t" : "autolathe")

//Updates overall lathe storage size.
/obj/machinery/autolathe/RefreshParts()
	..()
	var/mb_rating = 0
	var/man_rating = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/MB in component_parts)
		mb_rating += MB.rating
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		man_rating += M.rating

	storage_capacity[DEFAULT_WALL_MATERIAL] = mb_rating  * 25000
	storage_capacity["glass"] = mb_rating  * 12500
	build_time = 50 / man_rating
	mat_efficiency = 1.1 - man_rating * 0.1// Normally, price is 1.25 the amount of material, so this shouldn't go higher than 0.8. Maximum rating of parts is 3

/obj/machinery/autolathe/dismantle()

	for(var/mat in stored_material)
		var/material/M = get_material_by_name(mat)
		if(!istype(M))
			continue
		var/obj/item/stack/material/S = new M.stack_type(get_turf(src))
		if(stored_material[mat] > S.perunit)
			S.amount = round(stored_material[mat] / S.perunit)
		else
			qdel(S)
	..()
	return 1
