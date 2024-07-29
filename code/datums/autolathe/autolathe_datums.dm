/datum/design						//Datum for object designs, used in construction
	var/name					//Name of the created object. If null, it will be 'guessed' from build_path if possible.
	var/item_name			//An item name before it is modified by various name-modifying procs
	var/name_category		//If set, name is modified into "[name_category] ([item_name])"
	var/desc					//Description of the created object. If null, it will use group_desc and name where applicable.
	var/id					//ID of the created object for easy refernece. If null, uses typepath instead.
	var/sort_string = "ZZZZZ"		//Sorting order

	var/list/materials = list()		//List of materials. Format: "id" = amount.
	var/list/chemicals = list()		//List of reagents. Format: "id" = amount.
	var/adjust_materials = TRUE		//Whether material efficiency applies to this design
	var/build_path			//The path of the object that gets created.
	var/build_type = NONE			//Flag as to what kind machine the design is built in. See defines.
	var/category 			//Primarily used for Mech Fabricators, but can be used for anything.
	var/time = 0					//How many ticks it requires to build. If 0, calculated from the amount of materials used.
	var/starts_unlocked = FALSE		//If the design starts unlocked.
	var/list/factions = list()				//What faction the design is tied to, currently only used so the NT autolathe can print NT designs perfectly.
	var/olddesign = FALSE
	var/quality = 0 // Quality rating of the design, determines max quality
	var/minimum_quality = -INFINITY // Minimum quality required

	var/list/nano_ui_data			//Pre-generated UI data, to be sent into NanoUI/TGUI interfaces.

	// An MPC file containing this design. You can use it directly, but only if it doesn't interact with the rest of MPC system. If it does, use copies.
	var/datum/computer_file/binary/design/file



//These procs are used in subtypes for assigning names and descriptions dynamically
/datum/design/proc/AssembleDesignInfo(atom/temp_atom)
	if(build_path)
		var/delete_atom = FALSE
		if(!temp_atom)
			temp_atom = Fabricate(null, 1, null)
			delete_atom = TRUE
		AssembleDesignName(temp_atom)
		AssembleDesignMaterials(temp_atom)
		if(delete_atom)
			qdel(temp_atom)

	AssembleDesignTime()
	AssembleDesignDesc()
	AssembleDesignId()
	AssembleDesignUIData()

//Get name from build path if possible
/datum/design/proc/AssembleDesignName(atom/temp_atom)
	if(!name && temp_atom)
		name = temp_atom.name

	item_name = name

	if(name_category)
		name = "[name_category] ([item_name])"

	name = capitalize(name)

	if(quality)
		name = (quality > 0) ? "(+[quality]) ([item_name])" : "([quality]) [item_name]"

//Try to make up a nice description if we don't have one
/datum/design/proc/AssembleDesignDesc()
	if(desc)
		return
	if(name_category)
		desc = "Allows for the construction of \a [item_name] [name_category]."
	else
		desc = "Allows for the construction of \a [item_name]."

//Extract matter and reagent requirements from the target object and any objects inside it.
//Any materials specified in these designs are extras, added on top of what is extracted.
/datum/design/proc/AssembleDesignMaterials(atom/temp_atom)
	if(istype(temp_atom, /obj))
		for(var/obj/O in temp_atom.GetAllContents(includeSelf = TRUE))
			AddObjectMaterials(O)

//Add materials and reagents from object to the recipe
/datum/design/proc/AddObjectMaterials(obj/O)
	var/multiplier = 1
	var/is_stack = FALSE

	// If stackable, we want to multiply materials by the stack amount
	if(istype(O, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/casing = O
		multiplier = casing.amount
		if(casing.amount > 1 || casing.maxamount > 1)
			is_stack = TRUE

	var/list/mats = O.get_matter()
	if(length(mats))
		// We don't want material efficiency to factor in for stacks, to prevent material dupe bugs
		if(is_stack)
			adjust_materials = FALSE

		for(var/a in mats)
			var/amount = mats[a]
			if(amount)
				LAZYAPLUS(materials, a, amount)

	mats = O.matter_reagents
	if (mats && mats.len)
		for(var/a in mats)
			var/amount = mats[a] * multiplier
			if(amount)
				LAZYAPLUS(chemicals, a, amount)


//Calculate design time from the amount of materials and chemicals used.
/datum/design/proc/AssembleDesignTime()
	if(time)
		return

	var/total_materials = 0
	var/total_reagents = 0

	for(var/m in materials)
		total_materials += materials[m]

	for(var/c in chemicals)
		total_reagents += chemicals[c]

	time = 5 + total_materials + (total_reagents / 5)
	time = max(round(time), 5)

// By default, ID is just design's type.
/datum/design/proc/AssembleDesignId()
	if(id)
		return
	id = type

/datum/design/proc/AssembleDesignUIData()
	nano_ui_data = list(
		"id" = "[id]", "name" = name, "desc" = desc, "time" = time,
		"category" = category, "adjust_materials" = adjust_materials, "minimum_quality" = minimum_quality
	)

	if(length(materials))
		var/list/RS = list()

		for(var/material in materials)
			var/material/material_datum = get_material_by_name(material)
			RS.Add(list(list("id" = material, "name" = material_datum.display_name, "req" = materials[material])))

		nano_ui_data["materials"] = RS

	if(length(chemicals))
		var/list/RS = list()

		for(var/reagent in chemicals)
			var/datum/reagent/reagent_datum = GLOB.chemical_reagents_list[reagent]
			RS.Add(list(list("id" = reagent, "name" = reagent_datum.name, "req" = chemicals[reagent])))

		nano_ui_data["chemicals"] = RS


/datum/design/nano_ui_data()
	RETURN_TYPE(/list)
	return nano_ui_data

//Returns a new instance of the item for this design
//This is to allow additional initialization to be performed, including possibly additional contructor arguments.
/datum/design/proc/Fabricate(newloc, mat_efficiency, var/obj/machinery/autolathe/fabricator, oldify_result, high_quality_print, machine_rating)
	if(!build_path)
		return

	var/atom/A = new build_path(newloc)
	A.Created()

	if(mat_efficiency != 1 && adjust_materials)
		for(var/obj/O in A.GetAllContents(includeSelf = TRUE))
			if(length(O.matter))
				for(var/i in O.matter)
					O.matter[i] = round(O.matter[i] * mat_efficiency, 0.01)

	if(oldify_result && fabricator.low_quality_print)
		var/obj/O = A
		if(istype(O))
			O.make_old(TRUE)

	if(high_quality_print && fabricator.extra_quality_print)
		var/obj/O = A
		if(istype(O))
			O.give_positive_attachment()

	if(min(quality, machine_rating)) // Only call set_quality() if the resulting quality is non-zero
		var/obj/O = A
		if(istype(O))
			O.set_quality(min(quality, machine_rating))

	return A

/datum/design/autolathe
	build_type = AUTOLATHE

/datum/design/autolathe/corrupted
	name = "ERROR"
	build_path = /obj/item/material/shard/shrapnel/scrap
