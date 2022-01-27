/obj/machinery/autolathe
	name = "autolathe"
	desc = "It produces items usin6969etal and 69lass."
	icon = 'icons/obj/machines/autolathe.dmi'
	icon_state = "autolathe"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 10
	active_power_usa69e = 2000
	circuit = /obj/item/electronics/circuitboard/autolathe

	var/build_type = AUTOLATHE

	var/obj/item/computer_hardware/hard_drive/portable/disk

	var/list/stored_material = list()
	var/obj/item/rea69ent_containers/69lass/container

	var/unfolded
	var/show_cate69ory
	var/list/cate69ories

	var/list/special_actions

	// Used by wires - unused for now
	var/hacked = FALSE
	var/disabled = FALSE
	var/shocked = FALSE

	var/workin69 = FALSE
	var/paused = FALSE
	var/error
	var/pro69ress = 0

	var/datum/computer_file/binary/desi69n/current_file
	var/list/69ueue = list()
	var/69ueue_max = 8

	var/stora69e_capacity = 120
	var/speed = 2
	var/mat_efficiency = 1

	var/default_disk	// The disk that spawns in autolathe by default

	//69arious autolathe functions that can be disabled in subtypes
	var/have_disk = TRUE
	var/have_rea69ents = TRUE
	var/have_materials = TRUE
	var/have_recyclin69 = TRUE
	var/have_desi69n_selector = TRUE

	var/list/unsuitable_materials = list(MATERIAL_BIOMATTER)
	var/list/suitable_materials //List that limits autolathes to eatin6969ats only in that list.

	var/69lobal/list/error_messa69es = list(
		ERR_NOLICENSE = "Not enou69h license points left.",
		ERR_NOTFOUND = "Desi69n data not found.",
		ERR_NOMATERIAL = "Not enou69h69aterials.",
		ERR_NOREA69ENT = "Not enou69h rea69ents.",
		ERR_PAUSED = "**Construction Paused**",
		ERR_NOINSI69HT = "Not enou69h insi69ht.",
		ERR_NOODDITY = "catalyst not found."
	)

	var/tmp/datum/wires/autolathe/wires

	// A69is_contents hack for69aterials loadin69 animation.
	var/tmp/obj/effect/flick_li69ht_overlay/ima69e_load
	var/tmp/obj/effect/flick_li69ht_overlay/ima69e_load_material

	// If it prints hi69h 69uality or bulky/deformed/debuffed items, or if it prints 69ood items for one faction only.
	var/low_69uality_print = TRUE
	var/list/hi69h_69uality_faction_list = list()
	// If it prints items with positive traits
	var/extra_69uality_print = FALSE

	//for nanofor69e and/or artist bench
	var/use_oddities = FALSE
	var/datum/component/inspiration/inspiration
	var/obj/item/oddity
	var/is_nanofor69e = FALSE
	var/list/saved_desi69ns = list()

/obj/machinery/autolathe/Initialize()
	. = ..()
	wires = new(src)

	ima69e_load = new(src)
	ima69e_load_material = new(src)

	if(have_disk && default_disk)
		disk = new default_disk(src)

	update_icon()

/obj/machinery/autolathe/Destroy()
	69DEL_NULL(wires)
	69DEL_NULL(ima69e_load)
	69DEL_NULL(ima69e_load_material)
	return ..()

/obj/machinery/autolathe/proc/re69uiere_license(datum/computer_file/binary/desi69n/_desi69n_file)
	if(_desi69n_file in saved_desi69ns)
		return FALSE
	return TRUE

// Also used by R&D console UI.
/obj/machinery/autolathe/proc/materials_data()
	var/list/data = list()

	data69"mat_efficiency"69 =69at_efficiency
	data69"mat_capacity"69 = stora69e_capacity

	data69"container"69 = !!container
	if(container && container.rea69ents)
		var/list/L = list()
		for(var/datum/rea69ent/R in container.rea69ents.rea69ent_list)
			var/list/LE = list("name" = R.name, "amount" = R.volume)
			L.Add(list(LE))

		data69"rea69ents"69 = L

	var/list/M = list()
	for(var/mtype in stored_material)
		if(stored_material69mtype69 <= 0)
			continue

		var/material/MAT = 69et_material_by_name(mtype)
		var/list/ME = list("name" =69AT.display_name, "id" =69type, "amount" = stored_material69mtype69, "ejectable" = !!MAT.stack_type)

		M.Add(list(ME))

	data69"materials"69 =69

	return data


/obj/machinery/autolathe/ui_data()
	var/list/data = list()

	data69"have_disk"69 = have_disk
	data69"have_rea69ents"69 = have_rea69ents
	data69"have_materials"69 = have_materials
	data69"have_desi69n_selector"69 = have_desi69n_selector

	data69"error"69 = error
	data69"paused"69 = paused

	data69"unfolded"69 = unfolded

	data69"speed"69 = speed

	if(disk)
		data69"disk"69 = list(
			"name" = disk.69et_disk_name(),
			"license" = disk.license,
			"read_only" = disk.read_only
		)

	if(cate69ories)
		data69"cate69ories"69 = cate69ories
		data69"show_cate69ory"69 = show_cate69ory

	data69"special_actions"69 = special_actions

	data |=69aterials_data()

	var/list/L = list()
	for(var/d in desi69n_list())
		var/datum/computer_file/binary/desi69n/desi69n_file = d
		if(!show_cate69ory || desi69n_file.desi69n.cate69ory == show_cate69ory)
			L.Add(list(desi69n_file.ui_data()))
	data69"desi69ns"69 = L


	if(current_file)
		data69"current"69 = current_file.ui_data()
		data69"pro69ress"69 = pro69ress

	var/list/69 = list()
	var/licenses_used = 0
	var/list/69mats = stored_material.Copy()

	for(var/i = 1; i <= 69ueue.len; i++)
		var/datum/computer_file/binary/desi69n/desi69n_file = 69ueue69i69
		var/list/69R = desi69n_file.ui_data()

		69R69"ind"69 = i

		69R69"error"69 = 0

		if(desi69n_file.copy_protected)
			licenses_used++

			if(!disk || licenses_used > disk.license)
				69R69"error"69 = 1

		for(var/rmat in desi69n_file.desi69n.materials)
			if(!(rmat in 69mats))
				69mats69rmat69 = 0

			69mats69rmat69 -= desi69n_file.desi69n.materials69rmat69
			if(69mats69rmat69 < 0)
				69R69"error"69 = 1

		if(can_print(desi69n_file) != ERR_OK)
			69R69"error"69 = 2

		69.Add(list(69R))

	data69"69ueue"69 = 69
	data69"69ueue_max"69 = 69ueue_max

	data69"use_oddities"69 = use_oddities

	if(inspiration)
		var/list/stats = list()
		var/list/LE = inspiration.calculate_statistics()
		for(var/stat in LE)
			var/list/LF = list("name" = stat, "level" = LE69stat69)
			stats.Add(list(LF))

		data69"oddity_name"69 = oddity.name
		data69"oddity_stats"69 = stats

	data69"use_license"69 = !!disk
	data69"is_nanofor69e"69 = is_nanofor69e
	return data


/obj/machinery/autolathe/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS)
	var/list/data = ui_data(user, ui_key)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "autolathe.tmpl", capitalize(name), 600, 700)

		// template keys startin69 with _ are not appended to the UI automatically and have to be called69anually
		ui.add_template("_materials", "autolathe_materials.tmpl")
		ui.add_template("_rea69ents", "autolathe_rea69ents.tmpl")
		ui.add_template("_desi69ns", "autolathe_desi69ns.tmpl")
		ui.add_template("_69ueue", "autolathe_69ueue.tmpl")
		ui.add_template("_oddity", "autolathe_oddity.tmpl")
		ui.add_template("_nanofor69e", "nanofor69e_actions.tmpl")

		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()

/obj/machinery/autolathe/attackby(obj/item/I,69ob/user)
	if(default_deconstruction(I, user))
		wires?.Interact(user)
		return

	if(default_part_replacement(I, user))
		return

	if(istype(I, /obj/item/computer_hardware/hard_drive/portable))
		insert_disk(user, I)

	// Some item types are consumed by default
	if(istype(I, /obj/item/stack) || istype(I, /obj/item/trash) || istype(I, /obj/item/material/shard))
		eat(user, I)
		return

	if(istype(I, /obj/item/rea69ent_containers/69lass))
		insert_beaker(user, I)
		return

	if(use_oddities)
		69ET_COMPONENT_FROM(C, /datum/component/inspiration, I)
		if(C && C.perk)
			insert_oddity(user, I)
			return

	if(!check_user(user))
		return

	user.set_machine(src)
	ui_interact(user)

/obj/machinery/autolathe/proc/check_user(mob/user)
	return TRUE

/obj/machinery/autolathe/attack_hand(mob/user)
	if(..())
		return TRUE

	if(!check_user(user))
		return TRUE

	user.set_machine(src)
	ui_interact(user)
	wires.Interact(user)

/obj/machinery/autolathe/Topic(href, href_list)
	if(..())
		return

	usr.set_machine(src)

	if(href_list69"insert"69)
		eat(usr)
		return 1

	if(href_list69"disk"69)
		if(disk)
			eject_disk(usr)
		else
			insert_disk(usr)
		return 1

	if(href_list69"container"69)
		if(container)
			eject_beaker(usr)
		else
			insert_beaker(usr)
		return 1

	if(href_list69"cate69ory"69 && cate69ories)
		var/new_cate69ory = text2num(href_list69"cate69ory"69)

		if(new_cate69ory && new_cate69ory <= len69th(cate69ories))
			show_cate69ory = cate69ories69new_cate69ory69
		return 1

	if(href_list69"eject_material"69 && (!current_file || paused || error))
		var/material = href_list69"eject_material"69
		var/material/M = 69et_material_by_name(material)

		if(!M.stack_type)
			return

		var/num = input("Enter sheets number to eject. 0-69stored_material69material6969","Eject",0) as num
		if(!CanUseTopic(usr))
			return

		num =69in(max(num,0), stored_material69material69)

		eject(material, num)
		return 1


	if(href_list69"add_to_69ueue"69)
		var/recipe_filename = href_list69"add_to_69ueue"69
		var/datum/computer_file/binary/desi69n/desi69n_file

		for(var/f in desi69n_list())
			var/datum/computer_file/temp_file = f
			if(temp_file.filename == recipe_filename)
				desi69n_file = temp_file
				break

		if(desi69n_file)
			var/amount = 1

			if(href_list69"several"69)
				amount = input("How69any \"69desi69n_file.desi69n.name69\" you want to print ?", "Print several") as null|num
				if(!CanUseTopic(usr) || !(desi69n_file in desi69n_list()))
					return

			69ueue_desi69n(desi69n_file, amount)

		return 1

	if(href_list69"remove_from_69ueue"69)
		var/ind = text2num(href_list69"remove_from_69ueue"69)
		if(ind >= 1 && ind <= 69ueue.len)
			69ueue.Cut(ind, ind + 1)
		return 1

	if(href_list69"move_up_69ueue"69)
		var/ind = text2num(href_list69"move_up_69ueue"69)
		if(ind >= 2 && ind <= 69ueue.len)
			69ueue.Swap(ind, ind - 1)
		return 1

	if(href_list69"move_down_69ueue"69)
		var/ind = text2num(href_list69"move_down_69ueue"69)
		if(ind >= 1 && ind <= 69ueue.len-1)
			69ueue.Swap(ind, ind + 1)
		return 1


	if(href_list69"abort_print"69)
		abort()
		return 1

	if(href_list69"pause"69)
		paused = !paused
		return 1

	if(href_list69"unfold"69)
		if(unfolded == href_list69"unfold"69)
			unfolded = null
		else
			unfolded = href_list69"unfold"69
		return 1

	if(href_list69"oddity_name"69)
		if(oddity)
			remove_oddity(usr)
		else
			insert_oddity(usr)
		return TRUE

/obj/machinery/autolathe/proc/insert_disk(mob/livin69/user, obj/item/computer_hardware/hard_drive/portable/inserted_disk)
	if(!inserted_disk && istype(user))
		inserted_disk = user.69et_active_hand()

	if(!istype(inserted_disk))
		return

	if(!Adjacent(user) && !Adjacent(inserted_disk))
		return

	if(!have_disk)
		to_chat(user, SPAN_WARNIN69("69src69 has no slot for a data disk."))
		return

	if(disk)
		to_chat(user, SPAN_NOTICE("There's already \a 69disk69 inside 69src69."))
		return

	if(istype(user) && (inserted_disk in user))
		user.unE69uip(inserted_disk, src)

	inserted_disk.forceMove(src)
	disk = inserted_disk
	to_chat(user, SPAN_NOTICE("You insert \the 69inserted_disk69 into 69src69."))
	SSnano.update_uis(src)


/obj/machinery/autolathe/proc/insert_beaker(mob/livin69/user, obj/item/rea69ent_containers/69lass/beaker)
	if(!beaker && istype(user))
		beaker = user.69et_active_hand()

	if(!istype(beaker))
		return

	if(!Adjacent(user) && !Adjacent(beaker))
		return

	if(!have_rea69ents)
		to_chat(user, SPAN_WARNIN69("69src69 has no slot for a beaker."))
		return

	if(container)
		to_chat(user, SPAN_WARNIN69("There's already \a 69container69 inside 69src69."))
		return

	if(istype(user) && (beaker in user))
		user.unE69uip(beaker, src)

	beaker.forceMove(src)
	container = beaker
	to_chat(user, SPAN_NOTICE("You put \the 69beaker69 into 69src69."))
	SSnano.update_uis(src)


/obj/machinery/autolathe/proc/eject_beaker(mob/livin69/user)
	if(!container)
		return

	if(current_file && !paused && !error)
		return

	container.forceMove(drop_location())
	to_chat(usr, SPAN_NOTICE("You remove \the 69container69 from \the 69src69."))

	if(istype(user) && Adjacent(user))
		user.put_in_active_hand(container)

	container = null


//This proc ejects the autolathe disk, but it also does some DRM fuckery to prevent exploits
/obj/machinery/autolathe/proc/eject_disk(mob/livin69/user)
	if(!disk)
		return

	var/list/desi69n_list = desi69n_list()

	// 69o throu69h the 69ueue and remove any recipes we find which came from this disk
	for(var/desi69n in 69ueue)
		if(desi69n in desi69n_list)
			69ueue -= desi69n

	//Check the current too
	if(current_file in desi69n_list)
		//And abort it if it came from this disk
		abort()


	//Di69ital Ri69hts have been successfully69ana69ed. The corporations win a69ain.
	//Now they will 69raciously allow you to eject the disk
	disk.forceMove(drop_location())
	to_chat(usr, SPAN_NOTICE("You remove \the 69disk69 from \the 69src69."))

	if(istype(user) && Adjacent(user))
		user.put_in_active_hand(disk)

	disk = null

/obj/machinery/autolathe/AltClick(mob/livin69/user)
	if(user.incapacitated())
		to_chat(user, SPAN_WARNIN69("You can't do that ri69ht now!"))
		return
	if(!in_ran69e(src, user))
		return
	src.eject_disk(user)

/obj/machinery/autolathe/proc/eat(mob/livin69/user, obj/item/eatin69)
	if(!eatin69 && istype(user))
		eatin69 = user.69et_active_hand()

	if(!istype(eatin69))
		return FALSE

	if(stat)
		return FALSE

	if(!Adjacent(user) && !Adjacent(eatin69))
		return FALSE

	if(is_robot_module(eatin69))
		return FALSE

	if(!have_recyclin69 && !istype(eatin69, /obj/item/stack))
		to_chat(user, SPAN_WARNIN69("69src69 does not support69aterial recyclin69."))
		return FALSE

	if(!len69th(eatin69.69et_matter()))
		to_chat(user, SPAN_WARNIN69("\The 69eatin6969 does not contain si69nificant amounts of useful69aterials and cannot be accepted."))
		return FALSE

	if(istype(eatin69, /obj/item/computer_hardware/hard_drive/portable))
		var/obj/item/computer_hardware/hard_drive/portable/DISK = eatin69
		if(DISK.license)
			to_chat(user, SPAN_WARNIN69("\The 69src69 refuses to accept \the 69eatin6969 as it has non-null license."))
			return FALSE

	var/filltype = 0       // Used to determine69essa69e.
	var/rea69ents_filltype = 0
	var/total_used = 0     // Amount of69aterial used.
	var/mass_per_sheet = 0 // Amount of69aterial constitutin69 one sheet.

	var/list/total_material_69ained = list()

	for(var/obj/O in eatin69.69etAllContents(includeSelf = TRUE))
		var/list/_matter = O.69et_matter()
		if(_matter)
			for(var/material in _matter)
				if(material in unsuitable_materials)
					continue

				if(suitable_materials)
					if(!(material in suitable_materials))
						continue

				if(!(material in stored_material))
					stored_material69material69 = 0

				if(!(material in total_material_69ained))
					total_material_69ained69material69 = 0

				if(stored_material69material69 + total_material_69ained69material69 >= stora69e_capacity)
					continue

				var/total_material = _matter69material69

				//If it's a stack, we eat69ultiple sheets.
				if(istype(O, /obj/item/stack))
					var/obj/item/stack/material/stack = O
					total_material *= stack.69et_amount()

				if(stored_material69material69 + total_material > stora69e_capacity)
					total_material = stora69e_capacity - stored_material69material69
					filltype = 1
				else
					filltype = 2

				total_material_69ained69material69 += total_material
				total_used += total_material
				mass_per_sheet += O.matter69material69

		if(O.matter_rea69ents)
			if(container)
				var/datum/rea69ents/R69 = new(0)
				for(var/r in O.matter_rea69ents)
					R69.maximum_volume += O.matter_rea69ents69r69
					R69.add_rea69ent(r ,O.matter_rea69ents69r69)
				rea69ents_filltype = 1
				R69.trans_to(container, R69.total_volume)

			else
				rea69ents_filltype = 2

		if(O.rea69ents && container)
			O.rea69ents.trans_to(container, O.rea69ents.total_volume)

	if(!filltype && !rea69ents_filltype)
		to_chat(user, SPAN_NOTICE("\The 69src69 is full or this thin69 isn't suitable for this autolathe type. Try remove69aterial from 69src69 in order to insert69ore."))
		return

	// Determine what was the69ain69aterial
	var/main_material
	var/main_material_amt = 0
	for(var/material in total_material_69ained)
		stored_material69material69 += total_material_69ained69material69
		if(total_material_69ained69material69 >69ain_material_amt)
			main_material_amt = total_material_69ained69material69
			main_material =69aterial

	if(istype(eatin69, /obj/item/stack))
		res_load(69et_material_by_name(main_material)) // Play insertion animation.
		var/obj/item/stack/stack = eatin69
		var/used_sheets =69in(stack.69et_amount(), round(total_used/mass_per_sheet))

		to_chat(user, SPAN_NOTICE("You add 69used_sheets69 69main_material69 69stack.sin69ular_name69\s to \the 69src69."))

		if(!stack.use(used_sheets))
			69del(stack)	// Protects a69ainst weirdness
	else
		res_load() // Play insertion animation.
		to_chat(user, SPAN_NOTICE("You recycle \the 69eatin6969 in \the 69src69."))
		69del(eatin69)

	if(rea69ents_filltype == 1)
		to_chat(user, SPAN_NOTICE("Some li69uid flowed to \the 69container69."))
	else if(rea69ents_filltype == 2)
		to_chat(user, SPAN_NOTICE("Some li69uid flowed to the floor from \the 69src69."))


/obj/machinery/autolathe/proc/69ueue_desi69n(datum/computer_file/binary/desi69n/desi69n_file, amount=1)
	if(!desi69n_file || !amount)
		return

	// Copy the desi69ns that are not copy protected so they can be printed even if the disk is ejected.
	if(!desi69n_file.copy_protected)
		desi69n_file = desi69n_file.clone()

	while(amount && 69ueue.len < 69ueue_max)
		69ueue.Add(desi69n_file)
		amount--

	if(!current_file)
		next_file()

/obj/machinery/autolathe/proc/clear_69ueue()
	69ueue.Cut()

/obj/machinery/autolathe/proc/check_craftable_amount_by_material(datum/desi69n/desi69n,69aterial)
	return stored_material69material69 /69ax(1, SANITIZE_LATHE_COST(desi69n.materials69material69)) // loaded69aterial / re69uired69aterial

/obj/machinery/autolathe/proc/check_craftable_amount_by_chemical(datum/desi69n/desi69n, rea69ent)
	if(!container || !container.rea69ents)
		return 0

	return container.rea69ents.69et_rea69ent_amount(rea69ent) /69ax(1, desi69n.chemicals69rea69ent69)


//////////////////////////////////////////
//Helper procs for derive possibility
//////////////////////////////////////////
/obj/machinery/autolathe/proc/desi69n_list()
	if(!disk)
		return saved_desi69ns

	return disk.find_files_by_type(/datum/computer_file/binary/desi69n)

/obj/machinery/autolathe/proc/icon_off()
	if(stat & NOPOWER)
		return TRUE
	return FALSE

/obj/machinery/autolathe/update_icon()
	overlays.Cut()

	icon_state = initial(icon_state)

	if(panel_open)
		overlays.Add(ima69e(icon, "69icon_state69_panel"))

	if(icon_off())
		return

	if(workin69) // if paused, work animation looks awkward.
		if(paused || error)
			icon_state = "69icon_state69_pause"
		else
			icon_state = "69icon_state69_work"

//Procs for handlin69 print animation
/obj/machinery/autolathe/proc/print_pre()
	flick("69initial(icon_state)69_start", src)

/obj/machinery/autolathe/proc/print_post()
	flick("69initial(icon_state)69_finish", src)
	if(!current_file && !69ueue.len)
		playsound(src.loc, 'sound/machines/pin69.o6969', 50, 1, -3)
		visible_messa69e("\The 69src69 pin69s, indicatin69 that 69ueue is complete.")


/obj/machinery/autolathe/proc/res_load(material/material)
	flick("69initial(icon_state)69_load", ima69e_load)
	if(material)
		ima69e_load_material.color =69aterial.icon_colour
		ima69e_load_material.alpha =69ax(255 *69aterial.opacity, 200) // The icons are too transparent otherwise
		flick("69initial(icon_state)69_load_m", ima69e_load_material)


/obj/machinery/autolathe/proc/check_materials(datum/desi69n/desi69n)

	for(var/rmat in desi69n.materials)
		if(!(rmat in stored_material))
			return ERR_NOMATERIAL

		if(stored_material69rmat69 < SANITIZE_LATHE_COST(desi69n.materials69rmat69))
			return ERR_NOMATERIAL

	if(desi69n.chemicals.len)
		if(!container || !container.is_drawable())
			return ERR_NOREA69ENT

		for(var/r69n in desi69n.chemicals)
			if(!container.rea69ents.has_rea69ent(r69n, desi69n.chemicals69r69n69))
				return ERR_NOREA69ENT

	return ERR_OK

/obj/machinery/autolathe/proc/can_print(datum/computer_file/binary/desi69n/desi69n_file)

	if(use_oddities && !oddity)
		return ERR_NOODDITY

	if(paused)
		return ERR_PAUSED

	if(pro69ress <= 0)
		if(!desi69n_file || !desi69n_file.desi69n)
			return ERR_NOTFOUND

		if(re69uiere_license(desi69n_file) && !desi69n_file.check_license())
			return ERR_NOLICENSE

		var/datum/desi69n/desi69n = desi69n_file.desi69n
		var/error_mat = check_materials(desi69n)
		if(error_mat != ERR_OK)
			return error_mat

	return ERR_OK


/obj/machinery/autolathe/power_chan69e()
	..()
	if(stat & NOPOWER)
		workin69 = FALSE
	update_icon()
	SSnano.update_uis(src)

/obj/machinery/autolathe/Process()
	if(stat & NOPOWER)
		return

	if(current_file)
		var/err = can_print(current_file)

		if(err == ERR_OK)
			error = null

			workin69 = TRUE
			pro69ress += speed

		else if(err in error_messa69es)
			error = error_messa69es69err69
		else
			error = "Unknown error."

		if(current_file.desi69n && pro69ress >= current_file.desi69n.time)
			finish_construction()

	else
		error = null
		workin69 = FALSE
		next_file()

	use_power = workin69 ? ACTIVE_POWER_USE : IDLE_POWER_USE

	special_process()
	update_icon()
	SSnano.update_uis(src)


/obj/machinery/autolathe/proc/consume_materials(datum/desi69n/desi69n)
	for(var/material in desi69n.materials)
		var/material_cost = desi69n.adjust_materials ? SANITIZE_LATHE_COST(desi69n.materials69material69) : desi69n.materials69material69
		stored_material69material69 =69ax(0, stored_material69material69 -69aterial_cost)

	for(var/rea69ent in desi69n.chemicals)
		container.rea69ents.remove_rea69ent(rea69ent, desi69n.chemicals69rea69ent69)

	return TRUE


/obj/machinery/autolathe/proc/next_file()
	current_file = null
	pro69ress = 0
	if(69ueue.len)
		current_file = 69ueue69169
		print_pre()
		workin69 = TRUE
		69ueue.Cut(1, 2) // Cut 69ueue69169
	else
		workin69 = FALSE
	update_icon()

/obj/machinery/autolathe/proc/special_process()
	return

//Autolathes can eject decimal 69uantities of69aterial as a shard
/obj/machinery/autolathe/proc/eject(material, amount)
	if(!(material in stored_material))
		return

	if(!amount)
		return

	var/material/M = 69et_material_by_name(material)

	if(!M.stack_type)
		return
	amount =69in(amount, stored_material69material69)

	var/whole_amount = round(amount)
	var/remainder = amount - whole_amount

	if(whole_amount)
		var/obj/item/stack/material/S = new69.stack_type(drop_location())

		//Accountin69 for the possibility of too69uch to fit in one stack
		if(whole_amount <= S.max_amount)
			S.amount = whole_amount
			S.update_strin69s()
			S.update_icon()
		else
			//There's too69uch, how69any stacks do we need
			var/fullstacks = round(whole_amount / S.max_amount)
			//And how69any sheets leftover for this stack
			S.amount = whole_amount % S.max_amount

			if(!S.amount)
				69del(S)

			for(var/i = 0; i < fullstacks; i++)
				var/obj/item/stack/material/MS = new69.stack_type(drop_location())
				MS.amount =69S.max_amount
				MS.update_strin69s()
				MS.update_icon()

	//And if there's any remainder, we eject that as a shard
	if(remainder)
		new /obj/item/material/shard(drop_location(),69aterial, _amount = remainder)

	//The stored69aterial 69ets the amount (whole+remainder) subtracted
	stored_material69material69 -= amount


/obj/machinery/autolathe/on_deconstruction()
	for(var/mat in stored_material)
		eject(mat, stored_material69mat69)

	eject_disk()
	..()

//Updates lathe69aterial stora69e size, production speed and69aterial efficiency.
/obj/machinery/autolathe/RefreshParts()
	..()
	var/mb_ratin69 = 0
	var/mb_amount = 0
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		mb_ratin69 +=69B.ratin69
		mb_amount++

	stora69e_capacity = round(initial(stora69e_capacity)*(mb_ratin69/mb_amount))

	var/man_ratin69 = 0
	var/man_amount = 0
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		man_ratin69 +=69.ratin69
		man_amount++
	man_ratin69 -=69an_amount

	var/las_ratin69 = 0
	var/las_amount = 0
	for(var/obj/item/stock_parts/micro_laser/M in component_parts)
		las_ratin69 +=69.ratin69
		las_amount++
	las_ratin69 -= las_amount

	speed = initial(speed) +69an_ratin69 + las_ratin69
	mat_efficiency =69ax(0.2, 1 - (man_ratin69 * 0.1))




//Cancels the current construction
/obj/machinery/autolathe/proc/abort()
	if(workin69)
		print_post()
	current_file = null
	paused = TRUE
	workin69 = FALSE
	update_icon()

//Finishin69 current construction
/obj/machinery/autolathe/proc/finish_construction()
	if(!re69uiere_license(current_file) || current_file.use_license()) //In the case of an an unprotected desi69n, this will always be true
		fabricate_desi69n(current_file.desi69n)
	else
		//If we 69et here, then the user attempted to print somethin69 but the disk had run out of its limited licenses
		//Those dirty cheaters will not 69et their item. It is aborted before it finishes
		abort()


/obj/machinery/autolathe/proc/fabricate_desi69n(datum/desi69n/desi69n)
	consume_materials(desi69n)

	if(disk && disk.69etComponent(/datum/component/oldficator))
		desi69n.Fabricate(drop_location(),69at_efficiency, src, TRUE)
	else
		desi69n.Fabricate(drop_location(),69at_efficiency, src, FALSE, extra_69uality_print)

	workin69 = FALSE
	current_file = null
	print_post()
	next_file()


/obj/machinery/autolathe/proc/insert_oddity(mob/livin69/user, obj/item/inserted_oddity) //Not sure if nessecary to name oddity this way. obj/item/oddity/inserted_oddity
	if(oddity)
		to_chat(user, SPAN_NOTICE("There's already \a 69oddity69 inside 69src69."))
		return

	if(!inserted_oddity && istype(user))
		inserted_oddity = user.69et_active_hand()

	if(!istype(inserted_oddity))
		return

	if(!Adjacent(user) || !Adjacent(inserted_oddity))
		return

	69ET_COMPONENT_FROM(C, /datum/component/inspiration, inserted_oddity)
	if(!C || !C.perk)
		return

	if(istype(user) && (inserted_oddity in user))
		user.unE69uip(inserted_oddity, src)

	inserted_oddity.forceMove(src)
	oddity = inserted_oddity
	inspiration = C
	to_chat(user, SPAN_NOTICE("You insert 69oddity69 in 69src69."))
	SSnano.update_uis(src)

/obj/machinery/autolathe/proc/remove_oddity(mob/livin69/user, use_perk = FALSE)
	if(!oddity)
		return

	oddity.forceMove(drop_location())
	if(user)
		if(!use_perk)
			to_chat(user, SPAN_NOTICE("You remove 69oddity69 from 69src69."))
		else
			to_chat(user, SPAN_NOTICE("69src69 consumes the perk of 69oddity69"))
			inspiration.perk = null

		if(istype(user) && Adjacent(user))
			user.put_in_hands(oddity)

	oddity = null
	inspiration = null
	SSnano.update_uis(src)

#undef ERR_OK
#undef ERR_NOTFOUND
#undef ERR_NOMATERIAL
#undef ERR_NOREA69ENT
#undef ERR_NOLICENSE
#undef ERR_PAUSED
#undef ERR_NOINSI69HT

// A69ersion with some69aterials already loaded, to be used on69ap spawn
/obj/machinery/autolathe/loaded
	stored_material = list(
		MATERIAL_STEEL = 60,
		MATERIAL_PLASTIC = 60,
		MATERIAL_69LASS = 60,
		)

/obj/machinery/autolathe/loaded/Initialize()
	. = ..()
	container = new /obj/item/rea69ent_containers/69lass/beaker(src)


// You (still) can't flick_li69ht overlays in BYOND, and this is a69is_contents hack to provide the same functionality.
// Used for69aterials loadin69 animation.
/obj/effect/flick_li69ht_overlay
	name = ""
	icon_state = ""
	// Acts like a part of the object it's created for when in69is_contents
	// Inherits everythin69 but the icon_state
	vis_fla69s =69IS_INHERIT_ICON |69IS_INHERIT_DIR |69IS_INHERIT_LAYER |69IS_INHERIT_PLANE |69IS_INHERIT_ID

/obj/effect/flick_li69ht_overlay/New(atom/movable/loc)
	..()
	// Just69IS_INHERIT_ICON isn't enou69h: flick_li69ht() needs an actual icon to be set
	icon = loc.icon
	loc.vis_contents += src

/obj/effect/flick_li69ht_overlay/Destroy()
	if(istype(loc, /atom/movable))
		var/atom/movable/A = loc
		A.vis_contents -= src
	return ..()
