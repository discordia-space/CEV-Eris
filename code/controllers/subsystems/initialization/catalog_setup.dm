

SUBSYSTEM_DEF(catalog_setup)
	name = "Catalog Setup"
	init_order = INIT_ORDER_LATELOAD
	flags = SS_NO_FIRE
	var/list/initialized_atoms_types = list()


/datum/controller/subsystem/catalog_setup/Initialize() // the rest atoms
	// Atoms
	// Entries for atoms created when they initialized
	var/list/types_to_create = subtypesof(/atom)	// OOF
	var/list/inited_types = list()
	for(var/_type in initialized_atoms_types)
		inited_types += _type
	types_to_create.Remove(inited_types)
	types_to_create.Remove(typesof(/obj/screen))
	types_to_create.Remove(typesof(/obj/effect))
	types_to_create.Remove(typesof(/obj/random))
	types_to_create.Remove(typesof(/obj/landmark))
	types_to_create.Remove(typesof(/turf))
	types_to_create.Remove(typesof(/atom/movable/lighting_overlay))
	types_to_create.Remove(typesof(/obj/map_data))
	types_to_create.Remove(typesof(/area))
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
							/obj/fire,
							/atom/movable/overlay,
							/stat_client_preference,
							/stat_rig_module,
							/stat_silicon_subsystem,
							/atom/movable)

	
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
	