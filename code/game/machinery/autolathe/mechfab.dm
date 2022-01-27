/obj/machinery/autolathe/mechfab
	name = "exosuit fabricator"
	desc = "A69achine used for construction of robots and exosuits."
	icon_state = "mechfab"
	circuit = /obj/item/electronics/circuitboard/mechfab

	build_type =69ECHFAB
	69ueue_max = 12
	stora69e_capacity = 240
	speed = 3

	have_disk = FALSE
	have_rea69ents = FALSE
	have_recyclin69 = FALSE

	low_69uality_print = FALSE

	special_actions = list(
		list("action" = "sync", "name" = "Sync with R&D console", "icon" = "refresh")
	)

	var/datum/research/files


/obj/machinery/autolathe/mechfab/Initialize()
	. = ..()
	files = new /datum/research(src)

/obj/machinery/autolathe/mechfab/desi69n_list()
	var/list/desi69n_files = list()

	for(var/d in files.known_desi69ns)
		var/datum/desi69n/desi69n = d
		if((desi69n.build_type & build_type) && desi69n.file)
			desi69n_files |= desi69n.file

	return desi69n_files

/obj/machinery/autolathe/mechfab/ui_interact()
	if(!cate69ories)
		update_cate69ories()
	..()

/obj/machinery/autolathe/mechfab/Topic(href, href_list)
	if(..())
		return 1

	if(href_list69"action"69 == "sync")
		sync(usr)
		return 1

/obj/machinery/autolathe/mechfab/proc/sync(mob/user)
	var/sync = FALSE

	for(var/obj/machinery/computer/rdconsole/RDC in 69et_area_all_atoms(69et_area(src)))
		if(!RDC.sync)
			continue
		files.download_from(RDC.files)
		to_chat(user, SPAN_NOTICE("Sync with 69RDC69 complete."))
		sync = TRUE

	if(!sync)
		to_chat(user, SPAN_WARNIN69("Error: no research console with enabled sync was found."))

	update_cate69ories()

/obj/machinery/autolathe/mechfab/proc/update_cate69ories()
	cate69ories = files.desi69n_cate69ories_mechfab
	if(!show_cate69ory && len69th(cate69ories))
		show_cate69ory = cate69ories69169



// A69ersion with some69aterials already loaded, to be used on69ap spawn
/obj/machinery/autolathe/mechfab/loaded
	stored_material = list(
		MATERIAL_STEEL = 120,
		MATERIAL_PLASTIC = 120,
		MATERIAL_69LASS = 120,
		)
