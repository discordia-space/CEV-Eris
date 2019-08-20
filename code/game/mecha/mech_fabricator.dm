/obj/machinery/mecha_part_fabricator
	name = "exosuit fabricator"
	desc = "A machine used for construction of robots and mechas."
	icon = 'icons/obj/robotics.dmi'
	icon_state = "fab-idle"
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 20
	active_power_usage = 5000
	circuit = /obj/item/weapon/circuitboard/mechfab

	var/speed = 1
	var/mat_efficiency = 1
	var/list/materials = list(MATERIAL_STEEL = 0, MATERIAL_GLASS = 0, MATERIAL_PLASTIC = 0)
	var/res_max_amount = 240

	var/datum/research/files
	var/list/datum/design/queue = list()
	var/progress = 0
	var/busy = 0

	var/list/categories = list()
	var/category = null
	var/sync_message = ""

/obj/machinery/mecha_part_fabricator/Initialize()
	. = ..()
	files = new /datum/research(src)

/obj/machinery/mecha_part_fabricator/Process()
	..()
	if(stat)
		return
	if(busy)
		use_power = 2
		progress += speed
		check_build()
	else
		use_power = 1
	update_icon()

/obj/machinery/mecha_part_fabricator/on_deconstruction()
	for(var/f in materials)
		eject_materials(f, -1)
	..()

/obj/machinery/mecha_part_fabricator/RefreshParts()
	res_max_amount = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/M in component_parts)
		res_max_amount += M.rating * 120
	var/T = 0
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		T += M.rating
	mat_efficiency = 1 - (T - 1) / 4 // 1 -> 0.5
	for(var/obj/item/weapon/stock_parts/micro_laser/M in component_parts) // Not resetting T is intended; speed is affected by both
		T += M.rating
	speed = T / 2 // 1 -> 3

/obj/machinery/mecha_part_fabricator/attack_hand(var/mob/user)
	if(..())
		return
	ui_interact(user)

/obj/machinery/mecha_part_fabricator/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = NANOUI_FOCUS)
	var/data[0]

	if(!length(categories))
		update_categories()

	var/datum/design/current = queue.len ? queue[1] : null
	if(current)
		data["current"] = current.name
	data["queue"] = get_queue_names()
	data["buildable"] = get_build_options(user)
	data["category"] = category
	data["categories"] = categories
	data["materials"] = get_materials()
	data["maxres"] = res_max_amount
	data["sync"] = sync_message
	if(current)
		data["builtperc"] = round((progress / current.time) * 100)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "mechfab.tmpl", "Exosuit Fabricator UI", 900, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/mecha_part_fabricator/Topic(href, href_list)
	if(..())
		return

	if(href_list["build"])
		var/datum/design/D = locate(href_list["build"]) in files.known_designs
		if(D)
			add_to_queue(D)

	if(href_list["remove"])
		var/num = text2num(href_list["remove"])
		if(num)
			num = CLAMP(num, 1, queue.len)
			remove_from_queue(num)

	if(href_list["category"])
		if(href_list["category"] in categories)
			category = href_list["category"]

	if(href_list["eject"])
		eject_materials(href_list["eject"], text2num(href_list["amount"]))

	if(href_list["sync"])
		sync()
	else
		sync_message = ""

	return 1

/obj/machinery/mecha_part_fabricator/attackby(obj/item/I, mob/user)
	if(busy)
		to_chat(user, SPAN_NOTICE("\icon[src]\The [src] is busy. Please wait for completion of previous operation."))
		return TRUE

	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return

	if (user.a_intent != I_HURT)
		loadMaterials(I, user)
	else
		return ..()

/obj/machinery/mecha_part_fabricator/proc/loadMaterials(obj/item/stack/material/S, mob/user)
	if(!istype(user))
		return

	if(!istype(S, /obj/item/stack/material))
		to_chat(user, SPAN_NOTICE("You cannot insert this item into \the [src]!"))
		return

	var/material = S.get_material_name()

	if(!material)
		return ..()

	if(materials[material] >= res_max_amount)
		to_chat(user, "\icon[src]\The [src] cannot hold more [material].")

	var/amount = round(input("How many sheets do you want to add?") as num)

	if(!Adjacent(user))
		return
	if(!S)
		return
	if(amount <= 0)//No negative numbers
		return
	if(amount > S.get_amount())
		amount = S.get_amount()
	if(res_max_amount - materials[material] < amount) //Can't overfill
		amount = min(S.get_amount(), res_max_amount - materials[material])

	use_power(1000)
	if(do_after(usr, 16, src))
		res_load(material)
		if(S.use(amount))
			to_chat(user, SPAN_NOTICE("You add [amount] [material] sheet\s to \the [src]."))
			if(!(material in materials))
				materials[material] = 0
			materials[material] += amount
	update_busy()
	return TRUE

/obj/machinery/mecha_part_fabricator/proc/res_load(var/name)
	var/obj/effect/temp_visual/resourceInsertion/mechfab/effect = new(src.loc)
	effect.setMaterial(name)

/obj/machinery/mecha_part_fabricator/update_icon()
	overlays.Cut()
	if(panel_open)
		icon_state = "fab-o"
	else
		icon_state = "fab-idle"
	if(busy)
		overlays += "fab-active"

/obj/machinery/mecha_part_fabricator/proc/update_busy()
	if(queue.len)
		busy = can_build(queue[1])
	else
		busy = FALSE

/obj/machinery/mecha_part_fabricator/proc/add_to_queue(datum/design/D)
	queue += D
	update_busy()

/obj/machinery/mecha_part_fabricator/proc/remove_from_queue(var/index)
	if(index == 1)
		progress = 0
	queue.Cut(index, index + 1)
	update_busy()

/obj/machinery/mecha_part_fabricator/proc/can_build(datum/design/D)
	for(var/M in D.materials)
		if(materials[M] < round(D.materials[M] * mat_efficiency, 0.01))
			return FALSE
	return TRUE

/obj/machinery/mecha_part_fabricator/proc/check_build()
	if(!queue.len)
		progress = 0
		return
	var/datum/design/D = queue[1]
	if(!can_build(D))
		progress = 0
		return
	if(progress == 0)
		print_pre(D)
	if(D.time > progress)
		return
	for(var/M in D.materials)
		materials[M] = max(0, round(materials[M] - D.materials[M] * mat_efficiency, 0.01))

	D.Fabricate(get_turf(src), mat_efficiency, src)

	remove_from_queue(1)
	print_post(D)

/obj/machinery/mecha_part_fabricator/proc/get_queue_names()
	. = list()
	for(var/i = 2 to queue.len)
		var/datum/design/D = queue[i]
		. += D.name

/obj/machinery/mecha_part_fabricator/proc/get_build_options(var/mob/user)
	. = list()
	for(var/i in files.known_designs)
		var/datum/design/D = i
		if(!(D.build_type & MECHFAB))
			continue
		. += list(list("name" = D.name, "id" = "\ref[D]", "category" = D.category, "resources" = get_design_resources(D), "time" = get_design_time(D), "icon" = getAtomCacheFilename(D.build_path)))

/obj/machinery/mecha_part_fabricator/proc/get_design_resources(datum/design/D)
	var/list/F = list()
	for(var/T in D.materials)
		F += "[capitalize(T)]: [D.materials[T] * mat_efficiency]"
	return english_list(F, and_text = ", ")

/obj/machinery/mecha_part_fabricator/proc/get_design_time(datum/design/D)
	return time2text(round(10 * D.time / speed), "mm:ss")

/obj/machinery/mecha_part_fabricator/proc/update_categories()
	categories = list()
	for(var/datum/design/D in files.known_designs)
		if(!(D.build_type & MECHFAB))
			continue
		categories |= D.category

	if((!category || !(category in categories)) && length(categories))
		category = categories[1]

/obj/machinery/mecha_part_fabricator/proc/get_materials()
	. = list()
	for(var/T in materials)
		. += list(list("mat" = capitalize(T), "amt" = materials[T]))

/obj/machinery/mecha_part_fabricator/proc/eject_materials(var/material, var/amount) // 0 amount = 0 means ejecting a full stack; -1 means eject everything
	material = lowertext(material)
	var/recursive = amount == -1
	var/mattype = material_stack_type(material)

	var/obj/item/stack/material/S = new mattype(loc)
	if(amount <= 0)
		amount = S.max_amount
	var/ejected = min(materials[material], amount)
	S.amount = ejected
	if(S.amount <= 0)
		qdel(S)
		return
	materials[material] -= ejected
	if(recursive && materials[material] > 0)
		eject_materials(material, -1)
	update_busy()

/obj/machinery/mecha_part_fabricator/proc/sync()
	sync_message = "Error: no console found."
	for(var/obj/machinery/computer/rdconsole/RDC in get_area_all_atoms(get_area(src)))
		if(!RDC.sync)
			continue
		files.download_from(RDC.files)
		sync_message = "Sync complete."
	update_categories()

/obj/machinery/mecha_part_fabricator/proc/print_pre(datum/design/D)
	return

/obj/machinery/mecha_part_fabricator/proc/print_post(datum/design/D)
	visible_message("\icon[src]\The [src] flashes, indicating that \the [D] is complete.", range = 3)
	if(!queue.len)
		playsound(src.loc, 'sound/machines/ping.ogg', 50, 1 -3)
		visible_message("\icon[src]\The [src] pings indicating that queue is complete.")
