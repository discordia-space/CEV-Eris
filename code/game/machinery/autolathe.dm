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
	var/storage_capacity = 120

	var/obj/item/weapon/reagent_containers/glass/container = null
	var/show_category = "All"

	var/hacked = 0
	var/disabled = 0
	var/shocked = 0

	var/making_left = 0
	var/making_total = 0
	var/datum/autolathe/recipe/making_recipe = null
	var/not_enough_resources = FALSE
	var/disk_error = FALSE

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
	data["uses"] = 0
	if(disk)
		data["disk"] = disk.category
		data["uses"] = disk.license

		var/list/L = list()
		for(var/rtype in disk.recipes)
			var/datum/autolathe/recipe/R = autolathe_recipes[rtype]
			var/list/LE = list("name" = capitalize(R.name), "type" = "[rtype]")

			L.Add(list(LE))

		data["recipes"] = L

	data["container"] = FALSE
	if(container)
		data["container"] = TRUE
		if(container.reagents)
			var/list/L = list()
			for(var/datum/reagent/R in container.reagents.reagent_list)
				var/list/LE = list("name" = R.name, "count" = "[R.volume]")

				L.Add(list(LE))

			data["reagents"] = L

	var/list/M = list()
	for(var/mtype in stored_material)
		if(stored_material[mtype] <= 0)
			continue

		var/list/ME = list("name" = mtype, "count" = stored_material[mtype], "ejectable" = TRUE)

		var/material/MAT = get_material_by_name(mtype)
		if(!MAT.stack_type)
			ME["ejectable"] = FALSE

		M.Add(list(ME))

	data["materials"] = M

	data["busy"] = FALSE
	if(making_recipe)
		data["busy"] = TRUE
		var/datum/autolathe/recipe/R = making_recipe
		data["busyname"] = capitalize(R.name)
		data["busynow"] = making_total - making_left + 1
		data["busytotal"] = making_total
		data["resout"] = not_enough_resources
		data["diskerr"] = disk_error

		var/list/RS = list()
		for(var/mat in R.resources)
			RS.Add(list(list("name" = mat, "req" = round(R.resources[mat] * mat_efficiency))))

		data["req_materials"] = RS

		RS = list()
		for(var/reg in R.reagents)
			var/datum/reagent/RG = chemical_reagents_list[reg]
			if(RG)
				RS.Add(list(list("name" = RG.name, "req" = R.reagents[reg])))
			else
				RS.Add(list(list("name" = "UNKNOWN", "req" = R.reagents[reg])))

		data["req_reagents"] = RS

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "autolathe.tmpl", "Autolathe", 450, 655)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()


/obj/machinery/autolathe/attackby(var/obj/item/I, var/mob/user)
	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return

	user.set_machine(src)
	ui_interact(user)


/obj/machinery/autolathe/attack_hand(mob/user as mob)
	if(..())
		return TRUE

	user.set_machine(src)
	ui_interact(user)

/obj/machinery/autolathe/Topic(href, href_list)
	add_fingerprint(usr)

	usr.set_machine(src)

	if(href_list["eject_disk"] && disk)
		disk.forceMove(src.loc)

		if(isliving(usr))
			var/mob/living/L = usr
			if(istype(L))
				L.put_in_active_hand(disk)

		disk = null

	if(href_list["insert"])
		eat(usr)

	if(href_list["insert_disk"])
		insert_disk(usr)

	if(href_list["insert_beaker"])
		insert_beaker(usr)

	if(!making_recipe)
		if(href_list["eject_material"])
			var/material = href_list["eject_material"]
			var/material/M = get_material_by_name(material)

			if(!M.stack_type)
				return

			var/num = input("Enter sheets count to eject. 0-[stored_material[material]]","Eject",0) as num

			if(!Adjacent(usr))
				return

			num = min(max(num,0), stored_material[material])

			eject(material, num)

		if(href_list["eject_container"])
			container.forceMove(src.loc)

			if(isliving(usr))
				var/mob/living/L = usr
				if(istype(L))
					L.put_in_active_hand(container)

			container = null

		if(href_list["print_one"] && disk)
			if(!making_recipe)
				make(text2path(href_list["print_one"]),1)

		if(href_list["print_several"] && disk)
			if(!making_recipe)
				var/num = input("Enter items count to print.","Print") as num
				make(text2path(href_list["print_several"]),num)

	if(href_list["abort_print"])
		making_recipe = null
		making_left = 0
		making_total = 0
		disk_error = FALSE
		not_enough_resources = FALSE

	nanomanager.update_uis(src)

/obj/machinery/autolathe/proc/insert_disk(var/mob/living/user)
	if(!istype(user))
		return

	var/obj/item/eating = user.get_active_hand()

	if(!istype(eating))
		return

	if(istype(eating,/obj/item/weapon/disk/autolathe_disk))
		if(disk)
			user << SPAN_NOTICE("There's already \a [disk] inside the autolathe.")
			return
		user.unEquip(eating, src)
		disk = eating
		user << SPAN_NOTICE("You put \the [eating] into the autolathe.")
		nanomanager.update_uis(src)
		if(making_recipe && making_left)
			make(making_recipe.type,making_left)


/obj/machinery/autolathe/proc/insert_beaker(var/mob/living/user)
	if(!istype(user))
		return

	var/obj/item/eating = user.get_active_hand()

	if(!istype(eating))
		return

	if(istype(eating,/obj/item/weapon/reagent_containers/glass))
		if(container)
			user << SPAN_NOTICE("There's already \a [container] inside the autolathe.")
			return
		user.unEquip(eating, src)
		container = eating
		user << SPAN_NOTICE("You put \the [eating] into the autolathe.")
		nanomanager.update_uis(src)
		if(making_recipe && making_left)
			make(making_recipe.type,making_left)


/obj/machinery/autolathe/proc/eat(var/mob/living/user)
	if(!istype(user))
		return

	var/obj/item/eating = user.get_active_hand()

	if(!istype(eating))
		return

	if(stat)
		return

	if(eating.loc != user && !(istype(eating,/obj/item/stack)))
		return FALSE

	if(is_robot_module(eating))
		return FALSE

	if(!eating.matter || !eating.matter.len)
		user << SPAN_NOTICE("\The [eating] does not contain significant amounts of useful materials and cannot be accepted.")
		return

	var/filltype = 0       // Used to determine message.
	var/total_used = 0     // Amount of material used.
	var/mass_per_sheet = 0 // Amount of material constituting one sheet.

	for(var/material in eating.matter)
		if(!(material in stored_material))
			stored_material[material] = 0

		if(stored_material[material] >= storage_capacity)
			continue

		var/total_material = round(eating.matter[material])

		//If it's a stack, we eat multiple sheets.
		if(istype(eating,/obj/item/stack))
			var/obj/item/stack/material/stack = eating
			total_material *= stack.get_amount()

		if(stored_material[material] + total_material > storage_capacity)
			total_material = storage_capacity - stored_material[material]
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

	if(eating.matter_reagents)
		if(container)
			var/datum/reagents/RG = new(0)
			for(var/r in eating.matter_reagents)
				RG.maximum_volume += eating.matter_reagents[r]
				RG.add_reagent(r ,eating.matter_reagents[r])

			RG.trans_to(container, RG.total_volume)
			user << SPAN_NOTICE("Some liquid flowed to \the [container].")
		else
			user << SPAN_NOTICE("Some liquid flowed to the floor from autolathe beaker slot.")

	if(eating.reagents && container)
		eating.reagents.trans_to(container,eating.reagents.total_volume)

	flick("autolathe_o", src) // Plays metal insertion animation. Work out a good way to work out a fitting animation. ~Z

	if(istype(eating,/obj/item/stack))
		var/obj/item/stack/stack = eating
		stack.use(max(1, round(total_used/mass_per_sheet))) // Always use at least 1 to prevent infinite materials.
	else
		user.remove_from_mob(eating)
		qdel(eating)

	if(making_recipe && making_left)
		make(making_recipe.type,making_left)

/obj/machinery/autolathe/proc/make(var/recipe, var/amount)
	disk_error = FALSE
	not_enough_resources = FALSE

	if(!(recipe in autolathe_recipes))
		return

	making_recipe = autolathe_recipes[recipe]
	making_total = amount
	making_left = amount

	for(making_left = amount; making_left > 0;)
		nanomanager.update_uis(src)
		update_use_power(2)

		if(stat)
			break

		if(!disk || !(making_recipe.type in disk.recipes))
			disk_error = TRUE

		//Check if we have enough materials.
		for(var/material in making_recipe.resources)
			if(isnull(stored_material[material]) || stored_material[material] < round(making_recipe.resources[material] * mat_efficiency))
				not_enough_resources = TRUE
				break

		if(making_recipe.reagents && making_recipe.reagents.len)
			if(!container || !container.reagents || !container.is_open_container())
				not_enough_resources = TRUE
			else
				for(var/reagent in making_recipe.reagents)
					if(!container.reagents.has_reagent(reagent, making_recipe.reagents[reagent]))
						not_enough_resources = TRUE
						break

		if(disk_error || not_enough_resources || disk.license == 0)
			return

		//Consume materials.
		for(var/material in making_recipe.resources)
			stored_material[material] = max(0, stored_material[material] - round(making_recipe.resources[material] * mat_efficiency))


		for(var/reagent in making_recipe.reagents)
			container.reagents.remove_reagent(reagent, making_recipe.reagents[reagent])

		//Fancy autolathe animation.
		flick("autolathe_n", src)

		if(ispath(making_recipe.path,/obj/item/stack))
			sleep(max(5,round(build_time/30)))
		else
			sleep(build_time)

		update_use_power(1)

		//Sanity check.
		if(!making_recipe || !src)
			return

		if(!disk || !(making_recipe.type in disk.recipes))
			disk_error = TRUE

		if(disk_error || disk.license == 0)
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
	making_left = 0
	nanomanager.update_uis(src)

/obj/machinery/autolathe/proc/eject(var/material, var/amount)
	if(!(material in stored_material))
		return

	var/material/M = get_material_by_name(material)

	if(!M.stack_type)
		return

	var/eject = stored_material[material]
	eject = amount == -1 ? eject : min(eject, amount)
	if(eject < 1)
		return
	var/obj/item/stack/material/S = new M.stack_type(loc)
	S.amount = eject
	stored_material[material] -= eject

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

	storage_capacity = round(initial(storage_capacity)*(mb_rating/3))

	build_time = 50 / man_rating
	mat_efficiency = 1.1 - man_rating * 0.1// Normally, price is 1.25 the amount of material, so this shouldn't go higher than 0.8. Maximum rating of parts is 3

/obj/machinery/autolathe/dismantle()

	for(var/mat in stored_material)
		var/material/M = get_material_by_name(mat)
		if(!istype(M) || stored_material[mat] <= 0)
			continue

		var/obj/item/stack/material/S = new M.stack_type(get_turf(src))

		if(S.max_amount <= stored_material[mat])
			S.amount = stored_material[mat]
		else
			var/fullstacks = stored_material[mat] / S.max_amount
			S.amount = stored_material[mat] % S.max_amount
			for(var/i = 0; i < fullstacks; i++)
				var/obj/item/stack/material/MS = new M.stack_type(get_turf(src))
				MS.amount = MS.max_amount

	..()
	return 1
