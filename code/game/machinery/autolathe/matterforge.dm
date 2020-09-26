
#define SANITIZE_LATHE_COST(n) round(n * mat_efficiency, 0.01)

#define ERR_OK 0
#define ERR_NOTFOUND "not found"
#define ERR_NOMATERIAL "no material"
#define ERR_NOREAGENT "no reagent"
#define ERR_PAUSED "paused"

/obj/machinery/matter_nanoforge
	name = "Matter NanoForge"
	desc = "It consumes items and produces compressed matter."
	icon = 'icons/obj/machines/autolathe.dmi'
	icon_state = "autolathe"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	use_power = NO_POWER_USE
	var/list/stored_material = list()
	var/obj/power_source = null

	var/unfolded = null
	var/show_category
	var/list/categories

	var/working = FALSE
	var/paused = FALSE
	var/error = null
	var/progress = 0

	var/datum/computer_file/binary/design/current_file = null
	var/list/queue = list()
	var/queue_max = 8

	var/list/typepath_list = list(
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

	var/list/suitable_materials = list(MATERIAL_COMPRESSED_MATTER)

	var/list/special_actions

	var/global/list/error_messages = list(
		ERR_NOTFOUND = "Design data not found.",
		ERR_NOMATERIAL = "Not enough materials.",
		ERR_NOREAGENT = "Not enough reagents.",
		ERR_PAUSED = "**Construction Paused**"
	)
	var/tmp/obj/effect/flicker_overlay/image_load
	var/tmp/obj/effect/flicker_overlay/image_load_material

/*/obj/machinery/matter_nanoforge/attack_hand(mob/user)
*	if(..())
*		return TRUE
*	var/requested_amount = input(user, "How much Compressed Matter do you want to take out?", "Extracting Compressed Matter") as num|null
*	if(isnull(requested_amount) || requested_amount <=0)
*		return
*	if(requested_amount > 120)
*		to_chat(user, SPAN_WARNING("\The [src] can only deposit 120 Compressed Matter at a time."))
*		return
*	stored_material[MATERIAL_COMPRESSED_MATTER] -= requested_amount
*	update_desc(stored_material[MATERIAL_COMPRESSED_MATTER])
*	var/obj/item/stack/material/compressed_matter/MS = new(drop_location())
*	MS.amount = requested_amount
*	MS.update_strings()
*	MS.update_icon()
*/
/obj/machinery/matter_nanoforge/Initialize()
	. = ..()
	for (var/f in typepath_list)
		design_list.Add(find_files_by_type(f))

/obj/machinery/matter_nanoforge/proc/find_files_by_type(typepath)
	var/list/files
	var/obj/item/weapon/computer_hardware/hard_drive/portable/design/c = new typepath
	files = c.designs
	qdel(c)
	return files

/obj/machinery/matter_nanoforge/proc/materials_data()
	var/list/data = list()
	data["mat_efficiency"] = mat_efficiency

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

	data["speed"] = speed

	if(categories)
		data["categories"] = categories
		data["show_category"] = show_category

	data["special_actions"] = special_actions

	data |= materials_data()

	var/list/L = list()
	for(var/d in design_list)
		var/datum/design/type =  SSresearch.get_design(d)
		L.Add(list(type.ui_data))
	data["designs"] = L


	if(current_file)
		data["current"] = current_file.ui_data()
		data["progress"] = progress

	var/list/Q = list()
	var/list/qmats = stored_material.Copy()

	for(var/i = 1; i <= queue.len; i++)
		var/datum/computer_file/binary/design/design_file = queue[i]
		var/list/QR = design_file.ui_data()

		QR["ind"] = i

		QR["error"] = 0

		for(var/rmat in design_file.design.materials)
			if(!(rmat in qmats))
				qmats[rmat] = 0

			qmats[rmat] -= design_file.design.materials[rmat]
			if(qmats[rmat] < 0)
				QR["error"] = 1

		if(can_print(design_file) != ERR_OK)
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
		ui.add_template("_designs", "autolathe_designs.tmpl")
		ui.add_template("_queue", "autolathe_queue.tmpl")

		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()

/obj/machinery/matter_nanoforge/attack_hand(mob/user)
	if(..())
		return TRUE

	user.set_machine(src)
	ui_interact(user)

/obj/machinery/matter_nanoforge/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)

	if(href_list["category"] && categories)
		var/new_category = text2num(href_list["category"])

		if(new_category && new_category <= length(categories))
			show_category = categories[new_category]
		return 1

	if(href_list["eject_material"] && (!current_file || paused || error))
		var/material = href_list["eject_material"]
		var/material/M = get_material_by_name(material)

		if(!M.stack_type)
			return

		var/num = input("Enter sheets number to eject. 0-[stored_material[material]]","Eject",0) as num
		if(!CanUseTopic(usr))
			return

		num = min(max(num,0), stored_material[material])
		eject(num)
		return 1


	if(href_list["add_to_queue"])
		var/recipe_filename = href_list["add_to_queue"]
		var/datum/computer_file/binary/design/design_file

		for(var/f in design_list)
			var/datum/computer_file/temp_file = f
			if(temp_file.filename == recipe_filename)
				design_file = temp_file
				break

		if(design_file)
			var/amount = 1

			if(href_list["several"])
				amount = input("How many \"[design_file.design.name]\" you want to print ?", "Print several") as null|num
				if(!CanUseTopic(usr) || !(design_file in design_list))
					return

			queue_design(design_file, amount)

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
	if(istype(I, /obj/item/weapon/oddity))
		var/obj/item/weapon/oddity/ps = I
		if(ps.oddity_stats[STAT_MEC]> 0)
			if(!power_source)
				user.drop_item(I)
				I.forceMove(src)
				power_source = ps

			else
				user.drop_item(I)
				I.forceMove(src)
				power_source.forceMove(loc)
				power_source = ps
			return

	if(power_source)
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
				var/total_material = _matter[material]
				if(istype(O, /obj/item/stack))
					var/obj/item/stack/material/stack = O
					var/lst = matter_assoc_list()
					total_material *= stack.get_amount() * lst[stack.type]
				if(istype(O, /obj/item/stack/material/compressed_matter))
					to_chat(user, SPAN_NOTICE("You deposit [total_material] compressed matter into \the [src]."))
					stored_material[MATERIAL_COMPRESSED_MATTER] += total_material
					update_desc(stored_material[MATERIAL_COMPRESSED_MATTER])
					qdel(eating)
					return
				total_material_gained[material] += total_material
				total_used += total_material
				mass_per_sheet += O.matter[material]
	var/datum/component/artifact_power/artifact = power_source.GetComponent(/datum/component/artifact_power)
	for(var/material in total_material_gained)
		stored_material[MATERIAL_COMPRESSED_MATTER] += (artifact.power * total_material_gained[material])
		update_desc(stored_material[MATERIAL_COMPRESSED_MATTER])
		used_sheets = total_material_gained[material] * artifact.power
	if(istype(eating, /obj/item/stack))
		var/obj/item/stack/stack = eating

		to_chat(user, SPAN_NOTICE("You create [used_sheets] Compressed Matter from [stack.singular_name]\s in the [src]."))

		if(!stack.use(used_sheets))
			qdel(stack)	// Protects against weirdness
	else
		to_chat(user, SPAN_NOTICE("You recycle \the [eating] in \the [src]."))
		qdel(eating)
/obj/machinery/matter_nanoforge/proc/update_desc(var/stored_mats)
	desc = "It consumes items and produces compressed matter. It has [stored_mats] Compressed Matter stored."

/obj/machinery/matter_nanoforge/ex_act(severity)
	return 0

/obj/machinery/matter_nanoforge/bullet_act(obj/item/projectile/P, def_zone)
	return 0

/obj/machinery/matter_nanoforge/proc/queue_design(datum/computer_file/binary/design/design_file, amount=1)
	if(!design_file || !amount)
		return

	// Copy the designs that are not copy protected so they can be printed even if the disk is ejected.
	if(!design_file.copy_protected)
		design_file = design_file.clone()

	while(amount && queue.len < queue_max)
		queue.Add(design_file)
		amount--

	if(!current_file)
		next_file()

/obj/machinery/matter_nanoforge/proc/clear_queue()
	queue.Cut()

/obj/machinery/matter_nanoforge/proc/check_craftable_amount_by_material(datum/design/design, material)
	return stored_material[MATERIAL_COMPRESSED_MATTER] / max(1, SANITIZE_LATHE_COST(design.materials[MATERIAL_COMPRESSED_MATTER])) // loaded material / required material

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
	if(!current_file && !queue.len)
		playsound(src.loc, 'sound/machines/ping.ogg', 50, 1 -3)
		visible_message("\The [src] pings, indicating that queue is complete.")

/obj/machinery/matter_nanoforge/proc/res_load(material/material)
	flick("[initial(icon_state)]_load", image_load)
	if(material)
		image_load_material.color = material.icon_colour
		image_load_material.alpha = max(255 * material.opacity, 200) // The icons are too transparent otherwise
		flick("[initial(icon_state)]_load_m", image_load_material)

/obj/machinery/matter_nanoforge/proc/can_print(datum/computer_file/binary/design/design_file)
	if(progress <= 0)
		if(!design_file || !design_file.design)
			return ERR_NOTFOUND

		var/datum/design/design = design_file.design

		for(var/rmat in design.materials)
			if(!(rmat in stored_material))
				return ERR_NOMATERIAL

			if(stored_material[rmat] < SANITIZE_LATHE_COST(design.materials[rmat]))
				return ERR_NOMATERIAL

	if (paused)
		return ERR_PAUSED

	return ERR_OK

/obj/machinery/matter_nanoforge/Process()

	if(current_file)
		var/err = can_print(current_file)

		if(err == ERR_OK)
			error = null

			working = TRUE
			progress += speed

		else if(err in error_messages)
			error = error_messages[err]
		else
			error = "Unknown error."

		if(current_file.design && progress >= current_file.design.time)
			finish_construction()

	else
		error = null
		working = FALSE
		next_file()

	update_icon()
	SSnano.update_uis(src)

/obj/machinery/matter_nanoforge/proc/consume_materials(datum/design/design)
	for(var/material in design.materials)
		var/material_cost = design.adjust_materials ? SANITIZE_LATHE_COST(design.materials[MATERIAL_COMPRESSED_MATTER]) : design.materials[MATERIAL_COMPRESSED_MATTER]
		stored_material[material] = max(0, stored_material[MATERIAL_COMPRESSED_MATTER] - material_cost)

	return TRUE

/obj/machinery/matter_nanoforge/proc/next_file()
	current_file = null
	progress = 0
	if(queue.len)
		current_file = queue[1]
		print_pre()
		working = TRUE
		queue.Cut(1, 2) // Cut queue[1]
	else
		working = FALSE
	update_icon()
/obj/machinery/matter_nanoforge/proc/eject(amount)
	if (!amount)
		return

	var/material/M = MATERIAL_COMPRESSED_MATTER

	if(!M.stack_type)
		return
	amount = min(amount, stored_material[MATERIAL_COMPRESSED_MATTER])

	var/whole_amount = round(amount)
	var/remainder = amount - whole_amount

	if (whole_amount)
		var/obj/item/stack/material/S = new M.stack_type(drop_location())

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
				var/obj/item/stack/material/MS = new M.stack_type(drop_location())
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
	current_file = null
	paused = TRUE
	working = FALSE
	update_icon()

//Finishing current construction
/obj/machinery/matter_nanoforge/proc/finish_construction()
	fabricate_design(current_file.design)

/obj/machinery/matter_nanoforge/proc/fabricate_design(datum/design/design)
	consume_materials(design)
	design.Fabricate(drop_location(), mat_efficiency, src)

	working = FALSE
	current_file = null
	print_post()
	next_file()


#undef ERR_OK
#undef ERR_NOTFOUND
#undef ERR_NOMATERIAL
#undef ERR_NOREAGENT
#undef SANITIZE_LATHE_COST

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

/obj/machinery/matter_nanoforge/proc/matter_assoc_list()
	var/list/lst = new/list()
	lst[/obj/item/stack/material/iron] = 0.70
	lst[/obj/item/stack/material/glass] = 0.50
	lst[/obj/item/stack/material/steel] = 0.40
	lst[/obj/item/stack/material/glass/plasmaglass] = 0.70
	lst[/obj/item/stack/material/diamond] = 1
	lst[/obj/item/stack/material/plasma] = 0.60
	lst[/obj/item/stack/material/gold] = 0.70
	lst[/obj/item/stack/material/uranium] = 1
	lst[/obj/item/stack/material/silver] = 0.70
	lst[/obj/item/stack/material/plasteel] = 0.70
	lst[/obj/item/stack/material/plastic] = 0.50
	lst[/obj/item/stack/material/tritium] = 1
	lst[/obj/item/stack/material/osmium] = 1
	lst[/obj/item/stack/material/mhydrogen] = 1
	lst[/obj/item/stack/material/wood] = 0.20
	lst[/obj/item/stack/material/cloth] = 0.10
	lst[/obj/item/stack/material/cardboard] = 0.10
	lst[/obj/item/stack/material/glass/reinforced] = 0.55
	return lst