/obj/machinery/autolathe/organ_fabricator
	name = "Organ Fabricator"
	desc = "Moebius machine for printing organs using biotic substrate."
	description_info = "Quick Guide to Organs:\n\n\
						Print an organ scaffold\n\
						Print an input, process, and output teratoma\n\
						Use a laser scalpel to remove the organoid from each teratoma\n\
						(Optional) Use a laser scalpel on an organoid to modify its behavior\n\
						Attach all three organoids to the scaffold\n\
						Insert the newly crafted organ into self or another person\n\
						OR\n\
						Store it in the organ fridge for later use"
	icon_state = "organ_fabricator"
	circuit = /obj/item/electronics/circuitboard/organ_fabricator
	build_type = ORGAN_GROWER			// Should not be able to use church disks
	unsuitable_materials = list()		// Allows biomatter to be used (reskinned as "biotic substrate")
	storage_capacity = 480
	have_disk = TRUE
	have_reagents = TRUE
	have_recycling = FALSE
	speed = 6

	selectively_recycled_types = list(
		/obj/item/fleshcube
	)

	special_actions = list(
		list("action" = "rip", "name" = "Rip OMG! designs", "icon" = "document")
	)

	var/datum/research/files
	var/list/ripped_categories = list()		// For sanitizing categories

/obj/machinery/autolathe/organ_fabricator/loaded
	stored_material = list(MATERIAL_BIOMATTER = 480)

/obj/machinery/autolathe/organ_fabricator/Initialize()
	. = ..()
	files = new /datum/research(src)

	// Remove when actual organ research is made
	for(var/obj/machinery/reagentgrinder/industrial/disgorger/D in get_area_all_atoms(get_area(src)))
		for(var/design in D.knowledge.known_designs)
			files.AddDesign2Known(design)

/obj/machinery/autolathe/organ_fabricator/res_load()
	if(working || paused || error)
		flick("[initial(icon_state)]_load_working", image_load)
	else
		flick("[initial(icon_state)]_load", src)

/obj/machinery/autolathe/organ_fabricator/proc/rip_disk()
	if(!disk)
		return
	if(!istype(disk, /obj/item/computer_hardware/hard_drive/portable/design/omg))
		return

	for(var/design_file in disk.find_files_by_type(/datum/computer_file/binary/design))
		var/datum/computer_file/binary/design/DF = design_file
		var/datum/design/D = DF.design
		if(D && D.build_type == build_type)
			files.AddDesign2Known(D)
			ripped_categories |= D.category

	audible_message(SPAN_NOTICE("The contents of \the [disk] have been saved to \the [src]'s drive."))

/obj/machinery/autolathe/organ_fabricator/insert_disk(mob/living/user, obj/item/computer_hardware/hard_drive/portable/inserted_disk)
	. = ..()
	for(var/design_file in disk.find_files_by_type(/datum/computer_file/binary/design))
		var/datum/computer_file/binary/design/DF = design_file
		var/datum/design/D = DF.design
		categories |= D.category

/obj/machinery/autolathe/organ_fabricator/eject_disk(mob/living/user)
	. = ..()
	// Sanitize categories
	categories = files.design_categories_organfab
	categories |= ripped_categories

	SSnano.update_uis(src)

/obj/machinery/autolathe/organ_fabricator/design_list()
	var/list/design_files = list()

	if(disk)
		design_files |= disk.find_files_by_type(/datum/computer_file/binary/design)

	for(var/d in files.known_designs)
		var/datum/design/design = d
		if((design.build_type & build_type) && design.file)
			design_files |= design.file

	return design_files

/obj/machinery/autolathe/organ_fabricator/nano_ui_interact()
	if(!islist(categories))		// Runtime occured when the categories var was 0, but the null check wasn't catching it.
		categories = list()
	if(!categories.len)
		categories = files.design_categories_organfab
	if(!disk && !show_category && categories.len)
		show_category = categories[1]
	..()

/obj/machinery/autolathe/organ_fabricator/Topic(href, href_list)
	if(..())
		return TRUE

	if(href_list["action"] == "rip")
		rip_disk()
		return TRUE

/obj/machinery/autolathe/organ_fabricator/attackby(obj/item/I, mob/user)
	// Warn about deconstruction
	if(panel_open)
		var/tool_type = I.get_tool_type(user, list(QUALITY_PRYING), src)
		if(tool_type == QUALITY_PRYING)
			var/starting_loc = user.loc		// Save location so user can't magically deconstruct it from a distance
			var/choice = alert("If you deconstruct this machine, the biotic substrate inside will be destroyed. Are you sure you want to continue?", "Deconstruction Warning", "Deconstruct", "Leave it alone")
			if(choice != "Deconstruct" || starting_loc != user.loc)
				return

	// Eat cube
	if(istype(I, /obj/item/fleshcube))
		eat(user, I)
		return

	// Reject stack
	if(istype(I, /obj/item/stack))
		to_chat(user, SPAN_NOTICE("You don't see a way to insert \the [I] into \the [src]."))
		return

	..()

/obj/machinery/autolathe/organ_fabricator/on_deconstruction(obj/item/I, mob/user)
	stored_material[MATERIAL_BIOMATTER] = 0

	..()

/obj/machinery/autolathe/organ_fabricator/eject(material, amount)
	var/material/M = get_material_by_name(material)
	if(M.stack_type == /obj/item/stack/material/biomatter)
		visible_message(SPAN_WARNING("Biotic substrate cannot be removed from this machine."))
		return
	..()

/obj/machinery/autolathe/organ_fabricator/materials_data()
	var/list/data = list()

	data["mat_efficiency"] = mat_efficiency
	data["mat_capacity"] = storage_capacity

	data["container"] = !!container
	if(container && container.reagents)
		var/list/L = list()
		for(var/datum/reagent/R in container.reagents.reagent_list)
			var/list/LE = list("name" = R.name, "amount" = R.volume)
			L.Add(list(LE))

		data["reagents"] = L

	var/list/M = list()
	for(var/mtype in stored_material)
		if(stored_material[mtype] <= 0)
			continue

		var/material/MAT = get_material_by_name(mtype)
		var/material_name = MAT.display_name == MATERIAL_BIOMATTER ? "biotic substrate" : MAT.display_name
		var/list/ME = list("name" = material_name, "id" = mtype, "amount" = stored_material[mtype], "ejectable" = !!MAT.stack_type)

		M.Add(list(ME))

	data["materials"] = M

	return data

/obj/item/electronics/circuitboard/organ_fabricator
	name = T_BOARD("organ fabricator")
	spawn_blacklisted = TRUE
	build_path = /obj/machinery/autolathe/organ_fabricator
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 2, TECH_BIO = 2)
	req_components = list(
		/obj/item/stock_parts/matter_bin = 3,
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/stock_parts/console_screen = 1
	)
