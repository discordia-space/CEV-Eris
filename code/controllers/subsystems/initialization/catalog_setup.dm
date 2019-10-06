GLOBAL_LIST_EMPTY(catalogs)
GLOBAL_LIST_EMPTY(all_catalog_entries_by_type)

SUBSYSTEM_DEF(catalog_setup)
	name = "Catalog Setup"
	init_order = INIT_ORDER_LATELOAD
	flags = SS_NO_FIRE
	var/list/initialized_atoms_types = list()


/datum/controller/subsystem/catalog_setup/Initialize() // the rest atoms
	// Atoms
	// Entries for atoms created when they initialized
	var/list/types_to_create = subtypesof(/obj)	// OOF
	var/list/inited_types = list()
	for(var/_type in initialized_atoms_types)
		inited_types += _type
	types_to_create.Remove(inited_types)
	types_to_create.Remove(typesof(/obj/screen))
	types_to_create.Remove(typesof(/obj/effect))
	types_to_create.Remove(typesof(/obj/random))
	types_to_create.Remove(typesof(/obj/landmark))
	types_to_create.Remove(typesof(/obj/map_data))
	types_to_create.Remove(typesof(/mob))
	types_to_create.Remove(typesof(/obj/test))
	types_to_create.Remove(typesof(/obj/item/craft))
	types_to_create.Remove(typesof(/HUD_element))
	types_to_create.Remove(/obj/parallax_screen,
							/obj/parallax,
							/obj/randomcatcher,
							/obj/cleanbot_listener,
							/obj/secbot_listener,
							/obj/singularity,
							/obj/skeleton,
							/obj/fire)

	
	for(var/type in types_to_create)
		// if you came here looking why your object runtimes at roundstart here is solution for you
		// first of all, move all your initialisation code from New() to Initialize()
		// if base call of Initialize has returned INITIALIZE_HINT_NO_LOC then this means it was created in nullspace
		// if object havent found itself a place after LateInitialize() it got qdeled later
		// you need to add check that will break your init if object created in nullspace 
		//	. = ..()
		//	if(.) 
		//		return
		// or just add get_turf(src) check, i dont care
		// if your object is supposed to be created in null space change atom's var can_be_created_in_nullspace to TRUE
		var/atom/A = new type()
		if(A)
			register_atom(A)
			if(!QDESTROYING(A))
				// we need to wait otherwise references are broken immediately
				spawn(10)
					qdel(A)
	send_assets()
	. = ..()

/datum/controller/subsystem/catalog_setup/proc/register_atom(var/atom/A)
	if(A && !is_registered(A.type))
		A.catalog_initialize()
		initialized_atoms_types[A.type] = TRUE

/datum/controller/subsystem/catalog_setup/proc/is_registered(var/_type)
	if(initialized_atoms_types[_type])
		return TRUE



/hook/startup/proc/createCatalogs()
	// Reagents
	for(var/V in chemical_reagents_list)
		var/datum/reagent/D = chemical_reagents_list[V]
		if(D.appear_in_default_catalog)
			create_catalog_entry(D, CATALOG_REAGENTS)
			create_catalog_entry(D, CATALOG_ALL)
			if(istype(D, /datum/reagent/drink) || istype(D, /datum/reagent/ethanol))
				if(D.type == /datum/reagent/ethanol)
					create_catalog_entry(D, CATALOG_CHEMISTRY)
				create_catalog_entry(D, CATALOG_DRINKS)
			else
				create_catalog_entry(D, CATALOG_CHEMISTRY)
	// second run to add decompose results
	for(var/V in chemical_reagents_list)
		var/datum/reagent/D = chemical_reagents_list[V]	
		if(D.heating_products && D.heating_point)
			for(var/id in D.heating_products)
				var/datum/catalog_entry/reagent/E = get_catalog_entry(get_reagent_type_by_id(id))
				if(E)
					E.add_decomposition_from(D.type)

		if(D.chilling_products && D.chilling_point)
			for(var/id in D.chilling_point)
				var/datum/catalog_entry/reagent/E = get_catalog_entry(D.type)
				if(E)
					E.add_decomposition_from(D.type)
			
	var/datum/catalog/C = GLOB.catalogs[CATALOG_REAGENTS]
	C.associated_template = "catalog_list_reagents.tmpl"
	C.entry_list = sortTim(C.entry_list, /proc/cmp_catalog_entry_asc)
	C = GLOB.catalogs[CATALOG_CHEMISTRY]
	C.associated_template = "catalog_list_reagents.tmpl"
	C.entry_list = sortTim(C.entry_list, /proc/cmp_catalog_entry_asc)
	C = GLOB.catalogs[CATALOG_DRINKS]
	C.associated_template = "catalog_list_drinks.tmpl"
	C.entry_list = sortTim(C.entry_list, /proc/cmp_catalog_entry_asc)
	C = GLOB.catalogs[CATALOG_ALL]
	C.associated_template = "catalog_list_general.tmpl"
	C.entry_list = sortTim(C.entry_list, /proc/cmp_catalog_entry_asc)
	return 1

/proc/create_catalog_entry(var/datum/thing, var/catalog_id)
	if(catalog_id && !GLOB.catalogs[catalog_id])
		GLOB.catalogs[catalog_id] = new /datum/catalog(catalog_id)
	if(!GLOB.all_catalog_entries_by_type[thing.type])
		if(istype(thing, /datum/reagent))
			if(istype(thing, /datum/reagent/drink) || (istype(thing, /datum/reagent/ethanol) && thing.type != /datum/reagent/ethanol))
				GLOB.all_catalog_entries_by_type[thing.type] = new /datum/catalog_entry/drink(thing)
			else
				GLOB.all_catalog_entries_by_type[thing.type] = new /datum/catalog_entry/reagent(thing)
		else if(istype(thing, /atom))
			GLOB.all_catalog_entries_by_type[thing.type] = new /datum/catalog_entry/atom(thing)
		else
			if(!GLOB.catalogs[catalog_id].len)
				qdel(GLOB.catalogs[catalog_id])
				GLOB.catalogs.Remove(catalog_id)
				return FALSE
			error("Unsupported type passed to /proc/create_catalog_entry()")
			return FALSE
		if(catalog_id)
			var/datum/catalog/C = GLOB.catalogs[catalog_id]
			C.add_entry(GLOB.all_catalog_entries_by_type[thing.type])
	else if(catalog_id)
		var/datum/catalog/C = GLOB.catalogs[catalog_id]
		if(!C.entry_list.Find(GLOB.all_catalog_entries_by_type[thing.type]))
			C.add_entry(GLOB.all_catalog_entries_by_type[thing.type])
	return TRUE

/proc/get_catalog_entry(var/type)
	if(GLOB.all_catalog_entries_by_type[type])
		return GLOB.all_catalog_entries_by_type[type]
	error("Catalog Entry with type [type] was not found.")