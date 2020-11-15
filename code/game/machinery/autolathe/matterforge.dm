
#define SANITIZE_LATHE_COST(n) round(n * mat_efficiency, 0.01)

#define ERR_OK 0
#define ERR_NOTFOUND "not found"
#define ERR_NOMATERIAL "no material"
#define ERR_PAUSED "paused"

/obj/machinery/matter_nanoforge
	name = "Matter NanoForge"
	desc = "It consumes items and produces compressed matter."
	icon = 'icons/obj/machines/matterforge.dmi'
	icon_state = "techprint"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	use_power = NO_POWER_USE
	var/list/stored_material = list()
	var/obj/power_source
	var/storage_capacity = 1000
	var/unfolded
	var/show_category
	var/list/categories

	var/list/lst = list()

	var/working = FALSE
	var/paused = FALSE
	var/error
	var/progress = 0

	var/datum/design/current_design
	var/list/queue = list()
	var/queue_max = 8

	var/list/disk_list = list(
	/obj/item/weapon/computer_hardware/hard_drive/portable/design/adv_tools,
	/obj/item/weapon/computer_hardware/hard_drive/portable/design/components,
	/obj/item/weapon/computer_hardware/hard_drive/portable/design/circuits,
	/obj/item/weapon/computer_hardware/hard_drive/portable/design/conveyors,
	/obj/item/weapon/computer_hardware/hard_drive/portable/design/devices,
	/obj/item/weapon/computer_hardware/hard_drive/portable/design/misc,
	/obj/item/weapon/computer_hardware/hard_drive/portable/design/tools,
	)
	var/list/design_list = list()
	var/speed = 2
	var/mat_efficiency = 1

	var/have_disk = FALSE
	var/have_reagents = FALSE
	var/have_materials = TRUE
	var/have_design_selector = TRUE

	var/list/unsuitable_materials = list(MATERIAL_BIOMATTER)

	var/list/special_actions

	var/global/list/error_messages = list(
		ERR_NOTFOUND = "Design data not found.",
		ERR_NOMATERIAL = "Not enough materials.",
		ERR_NOREAGENT = "Not enough reagents.",
		ERR_PAUSED = "**Construction Paused**"
	)
	var/tmp/obj/effect/flicker_overlay/image_load
	var/tmp/obj/effect/flicker_overlay/image_load_material

/obj/machinery/matter_nanoforge/proc/get_designs()
	for (var/f in disk_list)
		design_list.Add(find_files_by_type(f))

/obj/machinery/matter_nanoforge/proc/find_files_by_type(typepath)
	var/list/files = list()	
	var/obj/item/weapon/computer_hardware/hard_drive/portable/design/c = new typepath
	for(var/f in c.designs)
		var/datum/design/design_object = SSresearch.get_design(f)
		var/total_mat = 0 
		var/list/ui_mats = design_object.ui_data["materials"]
		var/saved_mat = ui_mats[1]
		for(var/req_mats in ui_mats)
			total_mat += req_mats["req"]
		for(var/dmat in design_object.materials)
			total_mat = total_mat +  ((1 - lst[dmat]) * 10) * 2
		saved_mat["req"] = total_mat
		saved_mat["name"] = MATERIAL_COMPRESSED_MATTER
		ui_mats = list(1)
		ui_mats[1] = saved_mat
		design_object.ui_data["materials"] = ui_mats
		files.Add(design_object)
	qdel(c)
	return files

/obj/machinery/matter_nanoforge/proc/materials_data()
	var/list/data = list()
	data["mat_efficiency"] = mat_efficiency
	data["mat_capacity"] = storage_capacity

	var/list/M = list()
	for(var/mtype in stored_material)
		if(stored_material[mtype] <= 0)
			continue

		var/material/MAT = get_material_by_name(mtype)
		var/list/ME = list("name" = MAT.display_name, "id" = mtype, "amount" = stored_material[mtype], "ejectable" = !!MAT.stack_type)

		M.Add(list(ME))

	data["materials"] = M

	return data

/obj/machinery/matter_nanoforge/ui_data()
	var/list/data = list()

	data["have_materials"] = have_materials
	data["have_design_selector"] = have_design_selector

	data["error"] = error
	data["paused"] = paused

	data["unfolded"] = unfolded

	if(categories)
		data["categories"] = categories
		data["show_category"] = show_category

	data["special_actions"] = special_actions

	data |= materials_data()

	var/list/L = list()
	for(var/datum/design/d in design_list)
		L.Add(list(d.ui_data))
	data["designs"] = L


	if(current_design)
		data["current"] = current_design.ui_data
		data["progress"] = progress

	var/list/Q = list()
	var/qmats = stored_material[MATERIAL_COMPRESSED_MATTER]

	for(var/i = 1; i <= queue.len; i++)
		var/datum/design/picked_design = queue[i]
		var/list/QR = picked_design.ui_data

		QR["ind"] = i

		QR["error"] = 0

		for(var/rmat in picked_design.materials)
			qmats -= picked_design.materials[rmat]
			if(qmats < 0)
				QR["error"] = 1

		if(can_print(picked_design) != ERR_OK)
			QR["error"] = 2

		Q.Add(list(QR))

	data["queue"] = Q
	data["queue_max"] = queue_max

	return data

/obj/machinery/matter_nanoforge/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = NANOUI_FOCUS)
	var/list/data = ui_data(user, ui_key)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "autolathe.tmpl", capitalize(name), 600, 700)

		// template keys starting with _ are not appended to the UI automatically and have to be called manually
		ui.add_template("_materials", "autolathe_materials.tmpl")
		ui.add_template("_reagents", "autolathe_reagents.tmpl")
		ui.add_template("_designs", "matterforge_designs.tmpl")
		ui.add_template("_queue", "autolathe_queue.tmpl")

		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()

/obj/machinery/matter_nanoforge/attack_hand(mob/user)
	if(..())
		return TRUE
	matter_assoc_list()
	user.set_machine(src)
	ui_interact(user)
	if(!design_list.len)
		get_designs()

/obj/machinery/matter_nanoforge/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)

	if(href_list["category"] && categories)
		var/new_category = text2num(href_list["category"])

		if(new_category && new_category <= length(categories))
			show_category = categories[new_category]
		return 1

	if(href_list["eject_material"] && (!current_design || paused || error))
		var/material = href_list["eject_material"]
		var/material/M = get_material_by_name(MATERIAL_COMPRESSED_MATTER)

		if(!M.stack_type)
			return

		var/num = input("Enter sheets number to eject. 0-[stored_material[material]]","Eject",0) as num
		if(!CanUseTopic(usr))
			return

		num = min(max(num,0), stored_material[material])
		eject(num)
		return 1


	if(href_list["add_to_queue"])
		var/recipe = href_list["add_to_queue"]
		var/datum/design/picked_design

		for(var/datum/design/f in design_list)
			var/test = text2path((recipe))
			if(f.id == test)
				picked_design = f
				break

		if(picked_design)
			var/amount = 1

			if(href_list["several"])
				amount = input("How many \"[picked_design.id]\" you want to print ?", "Print several") as null|num
				if(!CanUseTopic(usr) || !(picked_design in design_list))
					return

			queue_design(picked_design, amount)

		return 1

	if(href_list["remove_from_queue"])
		var/ind = text2num(href_list["remove_from_queue"])
		if(ind >= 1 && ind <= queue.len)
			queue.Cut(ind, ind + 1)
		return 1

	if(href_list["move_up_queue"])
		var/ind = text2num(href_list["move_up_queue"])
		if(ind >= 2 && ind <= queue.len)
			queue.Swap(ind, ind - 1)
		return 1

	if(href_list["move_down_queue"])
		var/ind = text2num(href_list["move_down_queue"])
		if(ind >= 1 && ind <= queue.len-1)
			queue.Swap(ind, ind + 1)
		return 1


	if(href_list["abort_print"])
		abort()
		return 1

	if(href_list["pause"])
		paused = !paused
		return 1

	if(href_list["unfold"])
		if(unfolded == href_list["unfold"])
			unfolded = null
		else
			unfolded = href_list["unfold"]
		return 1

/obj/machinery/matter_nanoforge/attackby(obj/item/I, mob/user)
	if(I.GetComponent(/datum/component/inspiration))
		GET_COMPONENT_FROM(comp, /datum/component/inspiration, I)
		if(comp.power > 0)
			if(!power_source)
				user.drop_item(I)
				I.forceMove(src)
				power_source = I
			else
				user.drop_item(I)
				I.forceMove(src)
				power_source.forceMove(loc)
				power_source = I
			return

	if(power_source)
		matter_assoc_list()	
		eat(user, I)
		return
	else
		to_chat(user, SPAN_WARNING("\The [src] does not have any artifact powering it."))

/obj/machinery/matter_nanoforge/proc/eat(mob/living/user, obj/item/eating)
	var/used_sheets
	if(!eating && istype(user))
		eating = user.get_active_hand()
	if(!istype(eating))
		return FALSE
	if(stat)
		return FALSE
	if(stored_material[MATERIAL_COMPRESSED_MATTER] == storage_capacity)
		return FALSE
	if(!Adjacent(user) && !Adjacent(eating))
		return FALSE
	if(!length(eating.get_matter()))
		to_chat(user, SPAN_WARNING("\The [eating] does not contain significant amounts of useful materials and cannot be accepted."))
		return FALSE
	var/total_used = 0     // Amount of material used.
	var/mass_per_sheet = 0 // Amount of material constituting one sheet.
	var/list/total_material_gained = list()
	for(var/obj/O in eating.GetAllContents(includeSelf = TRUE))
		var/list/_matter = O.get_matter()
		if(_matter)
			for(var/material in _matter)
				if(material in unsuitable_materials)
					continue

				if(!(material in total_material_gained))
					total_material_gained[material] = 0

				var/total_material = _matter[material]
				if(istype(O, /obj/item/stack))
					var/obj/item/stack/material/stack = O
					total_material *= stack.get_amount()

				if(istype(O, /obj/item/stack/material/compressed_matter))
					to_chat(user, SPAN_NOTICE("You deposit [total_material] compressed matter into \the [src]."))
					stored_material[MATERIAL_COMPRESSED_MATTER] += total_material
					update_desc(stored_material[MATERIAL_COMPRESSED_MATTER])
					qdel(eating)
					return
				total_material_gained[material] += total_material
				total_used += total_material
				mass_per_sheet += O.matter[material]
	var/datum/component/inspiration/artifact = power_source.GetComponent(/datum/component/inspiration)
	var/gained_mats = 0
	for(var/mat in total_material_gained)
		var/added_mats = artifact.power * total_material_gained[mat] * lst[mat]
		if(added_mats + stored_material[MATERIAL_COMPRESSED_MATTER] > storage_capacity)
			added_mats = storage_capacity - stored_material[MATERIAL_COMPRESSED_MATTER]
		var/leftover_mats = (added_mats + stored_material[MATERIAL_COMPRESSED_MATTER]) - storage_capacity
		stored_material[MATERIAL_COMPRESSED_MATTER] += added_mats
		update_desc(stored_material[MATERIAL_COMPRESSED_MATTER])
		gained_mats += added_mats
		if(leftover_mats == 0)
			used_sheets = (added_mats / artifact.power) / lst[mat]
		else
			used_sheets = total_material_gained[mat]
	if(istype(eating, /obj/item/stack))
		var/obj/item/stack/stack = eating
		to_chat(user, SPAN_NOTICE("You create [gained_mats] Compressed Matter from [stack.singular_name]\s in the [src]."))

		if(!stack.use(used_sheets))
			qdel(stack)	// Protects against weirdness
	else
		to_chat(user, SPAN_NOTICE("You recycle \the [eating] in \the [src]."))
		qdel(eating)

/obj/machinery/matter_nanoforge/proc/queue_design(datum/design/picked_design, amount=1)
	if(!picked_design || !amount)
		return

	while(amount && queue.len < queue_max)
		queue.Add(picked_design)
		amount--

	if(!current_design)
		next_file()

/obj/machinery/matter_nanoforge/proc/check_craftable_amount_by_material(datum/design/design, material)
	return stored_material[MATERIAL_COMPRESSED_MATTER] / max(1, SANITIZE_LATHE_COST(design.materials[MATERIAL_COMPRESSED_MATTER])) // loaded material / required material

/obj/machinery/matter_nanoforge/proc/can_print(datum/design/picked_design)
	if(progress <= 0)
		if(!picked_design)
			return ERR_NOTFOUND

		var/datum/design/design = picked_design

		for(var/rmat in design.materials)
			if(!(stored_material[MATERIAL_COMPRESSED_MATTER] >= 0))
				return ERR_NOMATERIAL

			if(stored_material[MATERIAL_COMPRESSED_MATTER] < SANITIZE_LATHE_COST(design.materials[rmat]))
				return ERR_NOMATERIAL

	if (paused)
		return ERR_PAUSED

	return ERR_OK

/obj/machinery/matter_nanoforge/Process()

	if(current_design)
		var/err = can_print(current_design)

		if(err == ERR_OK)
			error = null

			working = TRUE
			progress += speed

		else if(err in error_messages)
			error = error_messages[err]
		else
			error = "Unknown error."

		if(current_design && progress >= current_design.time)
			finish_construction()

	else
		error = null
		working = FALSE
		next_file()

	update_icon()
	SSnano.update_uis(src)



/obj/machinery/matter_nanoforge/proc/next_file()
	current_design = null
	progress = 0
	if(queue.len)
		var/hold = queue[1]
		current_design = hold
		print_pre()
		working = TRUE
		queue.Cut(1, 2) // Cut queue[1]
	else
		working = FALSE
	update_icon()

/obj/machinery/matter_nanoforge/proc/eject(amount)

	if(!stored_material.len || stored_material[1] == 0)
		return

	if (!amount)
		return

	amount = min(amount, stored_material[MATERIAL_COMPRESSED_MATTER])

	var/whole_amount = round(amount)
	var/remainder = amount - whole_amount

	if (whole_amount)
		var/obj/item/stack/material/compressed_matter/S = new(drop_location())

		//Accounting for the possibility of too much to fit in one stack
		if (whole_amount <= S.max_amount)
			S.amount = whole_amount
			S.update_strings()
			S.update_icon()
		else
			//There's too much, how many stacks do we need
			var/fullstacks = round(whole_amount / S.max_amount)
			//And how many sheets leftover for this stack
			S.amount = whole_amount % S.max_amount

			if (!S.amount)
				qdel(S)

			for(var/i = 0; i < fullstacks; i++)
				var/obj/item/stack/material/compressed_matter/MS = new(drop_location())
				MS.amount = MS.max_amount
				MS.update_strings()
				MS.update_icon()

	//And if there's any remainder, we eject that as a shard
	if (remainder)
		new /obj/item/weapon/material/shard(drop_location(), MATERIAL_COMPRESSED_MATTER, _amount = remainder)

	//The stored material gets the amount (whole+remainder) subtracted
	stored_material[MATERIAL_COMPRESSED_MATTER] -= amount

/obj/machinery/matter_nanoforge/proc/abort()
	if(working)
		print_post()
	current_design = null
	paused = TRUE
	working = FALSE
	update_icon()

//Finishing current construction
/obj/machinery/matter_nanoforge/proc/finish_construction()
	fabricate_design(current_design)

/obj/machinery/matter_nanoforge/proc/fabricate_design(datum/design/design)
	consume_materials(design)
	design.Fabricate(drop_location(), mat_efficiency, src)

	working = FALSE
	current_design = null
	print_post()
	next_file()

/obj/machinery/matter_nanoforge/proc/consume_materials(datum/design/design)
	for(var/material in design.materials)
	// + 15 base cost for each material then * 2 
		design.materials[material] += ((1 - lst[material]) * 10) * 2
		var/material_cost = design.adjust_materials ? SANITIZE_LATHE_COST(design.materials[material]): design.materials[material]
		stored_material[MATERIAL_COMPRESSED_MATTER] = max(0, stored_material[MATERIAL_COMPRESSED_MATTER] - material_cost)

	return TRUE

#undef ERR_OK
#undef ERR_NOTFOUND
#undef ERR_NOMATERIAL
#undef SANITIZE_LATHE_COST
#undef ERR_PAUSED

/obj/machinery/matter_nanoforge/proc/update_desc(var/stored_mats)
	desc = "It consumes items and produces compressed matter. It has [stored_mats] Compressed Matter stored."

/obj/machinery/matter_nanoforge/ex_act(severity)
	return 0

/obj/machinery/matter_nanoforge/bullet_act(obj/item/projectile/P, def_zone)
	return 0

/obj/effect/flicker_overlay
	name = ""
	icon_state = ""
	// Acts like a part of the object it's created for when in vis_contents
	// Inherits everything but the icon_state
	vis_flags = VIS_INHERIT_ICON | VIS_INHERIT_DIR | VIS_INHERIT_LAYER | VIS_INHERIT_PLANE | VIS_INHERIT_ID

/obj/effect/flicker_overlay/New(atom/movable/loc)
	..()
	// Just VIS_INHERIT_ICON isn't enough: flicker() needs an actual icon to be set
	icon = loc.icon
	loc.vis_contents += src

/obj/effect/flicker_overlay/Destroy()
	if(istype(loc, /atom/movable))
		var/atom/movable/A = loc
		A.vis_contents -= src
	return ..()

/obj/machinery/matter_nanoforge/update_icon()
	overlays.Cut()

	icon_state = initial(icon_state)

	if(panel_open)
		overlays.Add(image(icon, "[icon_state]_panel"))

	if(working) // if paused, work animation looks awkward.
		if(paused || error)
			icon_state = "[icon_state]_pause"
		else
			icon_state = "[icon_state]_work"

/obj/machinery/matter_nanoforge/proc/print_pre()
	flick("[initial(icon_state)]_start", src)

/obj/machinery/matter_nanoforge/proc/print_post()
	flick("[initial(icon_state)]_finish", src)
	if(!current_design && !queue.len)
		playsound(src.loc, 'sound/machines/ping.ogg', 50, 1 -3)
		visible_message("\The [src] pings, indicating that queue is complete.")

/obj/machinery/matter_nanoforge/proc/res_load(material/material)
	flick("[initial(icon_state)]_load", image_load)
	if(material)
		image_load_material.color = material.icon_colour
		image_load_material.alpha = max(255 * material.opacity, 200) // The icons are too transparent otherwise
		flick("[initial(icon_state)]_load_m", image_load_material)


/obj/machinery/matter_nanoforge/proc/matter_assoc_list()
	lst[MATERIAL_IRON] = 0.70
	lst[MATERIAL_GLASS] = 0.50
	lst[MATERIAL_STEEL] = 0.40
	lst[MATERIAL_PLASMAGLASS] = 0.70
	lst[MATERIAL_DIAMOND] = 1
	lst[MATERIAL_PLASMA] = 0.60
	lst[MATERIAL_GOLD] = 0.70
	lst[MATERIAL_URANIUM] = 1
	lst[MATERIAL_SILVER] = 0.70
	lst[MATERIAL_PLASTEEL] = 0.70
	lst[MATERIAL_PLASTIC] = 0.50
	lst[MATERIAL_TRITIUM] = 1
	lst[MATERIAL_PLATINUM] = 1
	lst[MATERIAL_MHYDROGEN] = 1
	lst[MATERIAL_WOOD] = 0.20
	lst[MATERIAL_CLOTH] = 0.10
	lst[MATERIAL_CARDBOARD] = 0.10
	lst[MATERIAL_RGLASS] = 0.55
	lst[MATERIAL_LEATHER] = 0.10
	lst[MATERIAL_TITANIUM] = 0.70
