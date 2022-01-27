//Additional helper procs found in /code/modules/integrated_electgronics/core/saved_circuits.dm

PROCESSING_SUBSYSTEM_DEF(circuit)
	name = "Circuit"
	priority = SS_PRIORITY_CIRCUIT
	init_order = INIT_ORDER_CIRCUIT
	flags = SS_BACKGROUND

	var/cipherkey

	var/list/all_components = list()                 // Associative list of 69component_name69:69component_path69 pairs
	var/list/cached_components = list()              // Associative list of 69component_path69:69component69 pairs
	var/list/all_assemblies = list()                 // Associative list of 69assembly_name69:69assembly_path69 pairs
	var/list/cached_assemblies = list()              // Associative list of 69assembly_path69:69assembly69 pairs
	var/list/all_circuits = list()                   // Associative list of 69circuit_name69:69circuit_path69 pairs
	var/list/circuit_fabricator_recipe_list = list() // Associative list of 69category_name69:69list_of_circuit_paths69 pairs
	var/cost_multiplier = SHEET_MATERIAL_AMOUNT / 10 // Each circuit cost unit is 200cm3

/datum/controller/subsystem/processing/circuit/Initialize()
	SScircuit.cipherkey = generateRandomString(2000+rand(0,10))
	circuits_init()
	. = ..()

/datum/controller/subsystem/processing/circuit/proc/circuits_init()
	//Cached lists for free performance
	var/atom/def = /obj/item/integrated_circuit
	var/default_name = initial(def.name)
	for(var/path in typesof(/obj/item/integrated_circuit))
		var/obj/item/integrated_circuit/IC = path
		var/name = initial(IC.name)
		if(name == default_name)
			continue
		all_components69name69 = path // Populating the component lists
		cached_components69IC69 = new path

		if(!(initial(IC.spawn_flags) & (IC_SPAWN_DEFAULT | IC_SPAWN_RESEARCH)))
			continue

		var/category = initial(IC.category_text)
		if(!circuit_fabricator_recipe_list69category69)
			circuit_fabricator_recipe_list69category69 = list()
		var/list/category_list = circuit_fabricator_recipe_list69category69
		category_list += IC // Populating the fabricator categories

	for(var/path in typesof(/obj/item/device/electronic_assembly))
		var/obj/item/device/electronic_assembly/A = path
		var/name = initial(A.name)
		all_assemblies69name69 = path
		cached_assemblies69A69 = new path
	for(var/path in typesof(/obj/item/implant/integrated_circuit))
		var/obj/item/implant/integrated_circuit/I = path
		var/name = initial(I.name)
		all_assemblies69name69 = path
		cached_assemblies69I69 = new path

	circuit_fabricator_recipe_list69"Assemblies"69 = subtypesof(/obj/item/device/electronic_assembly) - list(/obj/item/device/electronic_assembly/medium, /obj/item/device/electronic_assembly/large, /obj/item/device/electronic_assembly/drone, /obj/item/device/electronic_assembly/wallmount)
	
	circuit_fabricator_recipe_list69"Assemblies"69 -= typesof(/obj/item/device/electronic_assembly/implant)
	circuit_fabricator_recipe_list69"Assemblies"69 += typesof(/obj/item/implant/integrated_circuit)

	circuit_fabricator_recipe_list69"Tools"69 = list(
		/obj/item/device/integrated_electronics/wirer,
		/obj/item/device/integrated_electronics/debugger,
		/obj/item/device/integrated_electronics/analyzer,
		/obj/item/device/integrated_electronics/detailer,
		/obj/item/card/data
		)
