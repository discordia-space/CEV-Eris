var/global/list/crafting_designs

/obj/machinery/autolathe/crafting_station
	name = "Crafting Station"
	desc = "Makeshift fabrication station for home-made munitions and components of firearms and armor."
	icon = 'icons/obj/machines/crafting_station.dmi'
	icon_state = "craft"
	circuit = /obj/item/electronics/circuitboard/crafting_station
	build_type = MAKESHIFT
	unsuitable_materials = list()
	have_disk = FALSE
	have_reagents = FALSE
	have_recycling = FALSE
	use_power = NO_POWER_USE

	uses_stat = TRUE
	var/warmed_up = FALSE
	var/mob/living/Crafter
	var/list/designs = list()
	categories = list("firearm frames", "firearm grips", "firearm barrels", "pistol mechanisms", "revolver mechanisms", "pump-action mechanisms", "SMG mechanisms", "self-loading mechanisms", ".35 caliber", ".40 caliber", ".20 caliber", ".25 caliber", ".30 caliber", "shotgun shells", "special munitions", "miscellaneous")

/obj/machinery/autolathe/crafting_station/Initialize()
	. = ..()
	if(!crafting_designs)
		for(var/designpath in subtypesof(/datum/design/makeshift))
			var/datum/computer_file/binary/design/D = new
			D.set_design_type(designpath)
			if(istype(D.design))
				LAZYADD(crafting_designs, D)
			else
				log_debug("Makeshift design file \"[D]\" did not possess [designpath]")
				D.qdel_self()
	LAZYADD(designs, crafting_designs)

/obj/machinery/autolathe/crafting_station/res_load()
	flick("craft_cut", src)

/obj/machinery/autolathe/crafting_station/design_list()
	return designs

/obj/machinery/autolathe/crafting_station/nano_ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = NANOUI_FOCUS)
	..()
	Crafter = user

/obj/machinery/autolathe/crafting_station/can_print(var/datum/computer_file/binary/design/design_file)
	if(!Crafter.Adjacent(src))
		return ERR_DISTANT
	if(Crafter.incapacitated(INCAPACITATION_DEFAULT) || !(Crafter.machine == src))
		return ERR_STOPPED
	if(Crafter.stats.getStat(STAT_COG) < (design_file.design.minimum_quality * 15 + 15))
		return ERR_SKILL_ISSUE
	. = ..()

/obj/machinery/autolathe/crafting_station/get_quality()
	var/quality_level = -1
	if(istype(Crafter))
		quality_level = min(round((Crafter.stats.getStat(STAT_COG) - 15) / 15), max_quality) + (Crafter.stats.getPerk(/datum/perk/oddity/gunsmith) ? 1 : 0)
	return quality_level

/obj/machinery/autolathe/crafting_station/update_icon()
	overlays.Cut()
	icon_state = initial(icon_state)

	if(icon_off())
		icon_state = "[icon_state]_off"
		if(warmed_up)
			flick("craft_done", src)
			warmed_up = FALSE
		return

	if(working)
		if(!warmed_up)
			flick("craft_warmup", src)
			warmed_up = TRUE
		if(paused || error)
			icon_state = "[icon_state]_ready"
		else
			switch(current_file.design.category)
				if("firearm frames", "firearm grips", "miscellaneous")
					icon_state = "[icon_state]_square"
				if(".35 caliber", ".40 caliber", ".20 caliber", ".25 caliber", ".30 caliber", "shotgun shells", "special munitions")
					icon_state = "[icon_state]_points"
				if("firearm barrels", "pistol mechanisms", "revolver mechanisms", "pump-action mechanisms", "SMG mechanisms", "self-loading mechanisms")
					icon_state = "[icon_state]_cut"
	else if(warmed_up)
		flick("craft_done", src)
		warmed_up = FALSE

/obj/machinery/autolathe/crafting_station/print_pre()
	flick("craft_warmup", src)
	warmed_up = TRUE

/obj/machinery/autolathe/crafting_station/print_post()
	flick("craft_done", src)
	warmed_up = FALSE
	if(!current_file && !queue.len)
		playsound(src.loc, 'sound/machines/ping.ogg', 50, 1, -3)
		visible_message("\The [src] pings, indicating that queue is complete.")
