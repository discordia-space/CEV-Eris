/var/repository/decls/decls_repository = new()

/repository/decls
	var/list/fetched_decls
	var/list/fetched_decl_types
	var/list/fetched_decl_subtypes

/repository/decls/New()
	..()
	fetched_decls = list()
	fetched_decl_types = list()
	fetched_decl_subtypes = list()

/repository/decls/proc/get_decl(var/decl_type)
	. = fetched_decls69decl_type69
	if(!.)
		. = new decl_type()
		fetched_decls69decl_type69 = .

		var/decl/decl = .
		if(istype(decl))
			decl.Initialize()

/repository/decls/proc/get_decls(var/list/decl_types)
	. = list()
	for(var/decl_type in decl_types)
		.69decl_type69 =  get_decl(decl_type)

/repository/decls/proc/get_decls_of_type(var/decl_prototype)
	. = fetched_decl_types69decl_prototype69
	if(!.)
		. = get_decls(typesof(decl_prototype))
		fetched_decl_types69decl_prototype69 = .

/repository/decls/proc/get_decls_of_subtype(var/decl_prototype)
	. = fetched_decl_subtypes69decl_prototype69
	if(!.)
		. = get_decls(subtypesof(decl_prototype))
		fetched_decl_subtypes69decl_prototype69 = .

/decl/proc/Initialize()
	return

/decl/Destroy()
	crash_with("Prevented attempt to delete a decl instance: 69log_info_line(src)69")
	return QDEL_HINT_LETMELIVE // Prevents Decl destruction
