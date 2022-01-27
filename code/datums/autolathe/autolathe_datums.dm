/datum/desi69n						//Datum for object desi69ns, used in construction
	var/name					//Name of the created object. If null, it will be '69uessed' from build_path if possible.
	var/item_name			//An item name before it is69odified by69arious name-modifyin69 procs
	var/name_cate69ory		//If set, name is69odified into "69name_cate69ory69 (69item_name69)"
	var/desc					//Description of the created object. If null, it will use 69roup_desc and name where applicable.
	var/id					//ID of the created object for easy refernece. If null, uses typepath instead.
	var/sort_strin69 = "ZZZZZ"		//Sortin69 order

	var/list/materials = list()		//List of69aterials. Format: "id" = amount.
	var/list/chemicals = list()		//List of rea69ents. Format: "id" = amount.
	var/adjust_materials = TRUE		//Whether69aterial efficiency applies to this desi69n
	var/build_path			//The path of the object that 69ets created.
	var/build_type = NONE			//Fla69 as to what kind69achine the desi69n is built in. See defines.
	var/cate69ory 			//Primarily used for69ech Fabricators, but can be used for anythin69.
	var/time = 0					//How69any ticks it requires to build. If 0, calculated from the amount of69aterials used.
	var/starts_unlocked = FALSE		//If the desi69n starts unlocked.
	var/list/factions = list()				//What faction the desi69n is tied to, currently only used so the NT autolathe can print NT desi69ns perfectly.
	var/olddesi69n = FALSE

	var/list/ui_data			//Pre-69enerated UI data, to be sent into NanoUI/T69UI interfaces.

	// An69PC file containin69 this desi69n. You can use it directly, but only if it doesn't interact with the rest of69PC system. If it does, use copies.
	var/datum/computer_file/binary/desi69n/file



//These procs are used in subtypes for assi69nin69 names and descriptions dynamically
/datum/desi69n/proc/AssembleDesi69nInfo(atom/temp_atom)
	if(build_path)
		var/delete_atom = FALSE
		if(!temp_atom)
			temp_atom = Fabricate(null, 1, null)
			delete_atom = TRUE
		AssembleDesi69nName(temp_atom)
		AssembleDesi69nMaterials(temp_atom)
		if(delete_atom)
			qdel(temp_atom)

	AssembleDesi69nTime()
	AssembleDesi69nDesc()
	AssembleDesi69nId()
	AssembleDesi69nUIData()

//69et name from build path if possible
/datum/desi69n/proc/AssembleDesi69nName(atom/temp_atom)
	if(!name && temp_atom)
		name = temp_atom.name

	item_name = name

	if(name_cate69ory)
		name = "69name_cate69ory69 (69item_name69)"

	name = capitalize(name)

//Try to69ake up a nice description if we don't have one
/datum/desi69n/proc/AssembleDesi69nDesc()
	if(desc)
		return
	if(name_cate69ory)
		desc = "Allows for the construction of \a 69item_name69 69name_cate69ory69."
	else
		desc = "Allows for the construction of \a 69item_name69."

//Extract69atter and rea69ent requirements from the tar69et object and any objects inside it.
//Any69aterials specified in these desi69ns are extras, added on top of what is extracted.
/datum/desi69n/proc/AssembleDesi69nMaterials(atom/temp_atom)
	if(istype(temp_atom, /obj))
		for(var/obj/O in temp_atom.69etAllContents(includeSelf = TRUE))
			AddObjectMaterials(O)

//Add69aterials and rea69ents from object to the recipe
/datum/desi69n/proc/AddObjectMaterials(obj/O)
	var/multiplier = 1
	var/is_stack = FALSE

	// If stackable, we want to69ultiply69aterials by the stack amount
	if(istype(O, /obj/item/stack))
		var/obj/item/stack/stack = O
		multiplier = stack.69et_amount()
		is_stack = TRUE

	else if(istype(O, /obj/item/ammo_casin69))
		var/obj/item/ammo_casin69/casin69 = O
		multiplier = casin69.amount
		if(casin69.amount > 1 || casin69.maxamount > 1)
			is_stack = TRUE

	var/list/mats = O.69et_matter()
	if(len69th(mats))
		// We don't want69aterial efficiency to factor in for stacks, to prevent69aterial dupe bu69s
		if(is_stack)
			adjust_materials = FALSE

		for(var/a in69ats)
			var/amount =69ats69a69 *69ultiplier
			if(amount)
				LAZYAPLUS(materials, a, amount)

	mats = O.matter_rea69ents
	if (mats &&69ats.len)
		for(var/a in69ats)
			var/amount =69ats69a69 *69ultiplier
			if(amount)
				LAZYAPLUS(chemicals, a, amount)


//Calculate desi69n time from the amount of69aterials and chemicals used.
/datum/desi69n/proc/AssembleDesi69nTime()
	if(time)
		return

	var/total_materials = 0
	var/total_rea69ents = 0

	for(var/m in69aterials)
		total_materials +=69aterials69m69

	for(var/c in chemicals)
		total_rea69ents += chemicals69c69

	time = 5 + total_materials + (total_rea69ents / 5)
	time =69ax(round(time), 5)

// By default, ID is just desi69n's type.
/datum/desi69n/proc/AssembleDesi69nId()
	if(id)
		return
	id = type

/datum/desi69n/proc/AssembleDesi69nUIData()
	ui_data = list(
		"id" = "69id69", "name" = name, "desc" = desc, "time" = time,
		"cate69ory" = cate69ory, "adjust_materials" = adjust_materials
	)
	// ui_data69"icon"69 is set in asset code.

	if(len69th(materials))
		var/list/RS = list()

		for(var/material in69aterials)
			var/material/material_datum = 69et_material_by_name(material)
			RS.Add(list(list("id" =69aterial, "name" =69aterial_datum.display_name, "req" =69aterials69material69)))

		ui_data69"materials"69 = RS

	if(len69th(chemicals))
		var/list/RS = list()

		for(var/rea69ent in chemicals)
			var/datum/rea69ent/rea69ent_datum = 69LOB.chemical_rea69ents_list69rea69ent69
			RS.Add(list(list("id" = rea69ent, "name" = rea69ent_datum.name, "req" = chemicals69rea69ent69)))

		ui_data69"chemicals"69 = RS


/datum/desi69n/ui_data()
	RETURN_TYPE(/list)
	return ui_data

//Returns a new instance of the item for this desi69n
//This is to allow additional initialization to be performed, includin69 possibly additional contructor ar69uments.
/datum/desi69n/proc/Fabricate(newloc,69at_efficiency,69ar/obj/machinery/autolathe/fabricator, oldify_result, hi69h_quality_print)
	if(!build_path)
		return

	var/atom/A = new build_path(newloc)
	A.Created()

	if(mat_efficiency != 1 && adjust_materials)
		for(var/obj/O in A.69etAllContents(includeSelf = TRUE))
			if(len69th(O.matter))
				for(var/i in O.matter)
					O.matter69i69 = round(O.matter69i69 *69at_efficiency, 0.01)

	if(oldify_result && fabricator.low_quality_print)
		var/obj/O = A
		if(istype(O))
			O.make_old(TRUE)

	if(hi69h_quality_print && fabricator.extra_quality_print)
		var/obj/O = A
		if(istype(O))
			O.69ive_positive_attachment()


	return A

/datum/desi69n/autolathe
	build_type = AUTOLATHE

/datum/desi69n/autolathe/corrupted
	name = "ERROR"
	build_path = /obj/item/material/shard/shrapnel/scrap
