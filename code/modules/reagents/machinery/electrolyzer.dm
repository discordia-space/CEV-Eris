/obj/machinery/electrolyzer
	name = "electrolyzer"
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/machines/chemistry.dmi'
	icon_state = "electrolysis"
	use_power = IDLE_POWER_USE
	idle_power_usage = 40
	circuit = /obj/item/weapon/circuitboard/electrolyzer
	var/obj/item/weapon/reagent_containers/beaker
	var/obj/item/weapon/reagent_containers/separationBeaker
	var/convertion_coefficient = 2
	var/on = FALSE

/obj/item/weapon/circuitboard/electrolyzer
	name = T_BOARD("electrolyzer")
	build_path = /obj/machinery/electrolyzer
	origin_tech = list(TECH_BIO = 3)

// returns FALSE on errors TRUE on success and -1 if nothing to do
/proc/electrolysis(var/obj/item/weapon/reagent_containers/primaryBeaker, var/obj/item/weapon/reagent_containers/secondaryBeaker, var/amount)
	if(!primaryBeaker || !secondaryBeaker)
		return FALSE
	//check if has reagents
	if(!primaryBeaker.reagents.total_volume)
		return FALSE

	//check only one reagent present
	if(!primaryBeaker.reagents.reagent_list.len > 1)
		return FALSE

	var/datum/chemical_reaction/originalReaction
	var/activeReagent
	for(var/datum/reagent/R in primaryBeaker.reagents.reagent_list)
		for(var/id in GLOB.chemical_reactions_list_by_result)
			if(R.id == id)
				var/list/recipeList = GLOB.chemical_reactions_list_by_result[id]
				var/datum/chemical_reaction/recipe = recipeList[1]	// lets pick first one and hope that its the right one (this might cause problems if there is more than 1 recipe for reagent)
				if(recipe.supports_decomposition_by_electrolysis)
					activeReagent = R.id
					originalReaction = recipe
					break

	if(!istype(originalReaction))
		return -1

	var/volumeToHandle = min(originalReaction.result_amount, primaryBeaker.reagents.total_volume, amount)
	var/partVolume = volumeToHandle/originalReaction.result_amount

	if(secondaryBeaker.reagents.get_free_space() < volumeToHandle)
		return FALSE

	primaryBeaker.reagents.remove_reagent(activeReagent, volumeToHandle)
	primaryBeaker.reagents.add_reagent(originalReaction.required_reagents[1], partVolume * originalReaction.required_reagents[originalReaction.required_reagents[1]])
	for(var/i = 2 , i <= originalReaction.required_reagents.len, i++)
		secondaryBeaker.reagents.add_reagent(originalReaction.required_reagents[i], partVolume * originalReaction.required_reagents[originalReaction.required_reagents[i]])
	return TRUE


/obj/machinery/electrolyzer/Destroy()
	QDEL_NULL(beaker)
	QDEL_NULL(separationBeaker)
	return ..()

/obj/machinery/electrolyzer/update_icon()
	if(stat & NOPOWER)
		icon_state = "[initial(icon_state)]_off"
		return
	if(on)
		icon_state = "[initial(icon_state)]_working"
	else
		icon_state = initial(icon_state)

/obj/machinery/electrolyzer/RefreshParts()
	convertion_coefficient = initial(convertion_coefficient)
	for(var/obj/item/weapon/stock_parts/capacitor/C in component_parts)
		convertion_coefficient *= C.rating


/obj/machinery/electrolyzer/Process()
	..()
	if(stat & NOPOWER)
		update_icon()
		return
	if(on && beaker && beaker.reagents.total_volume)
		var/state = electrolysis(beaker, separationBeaker, convertion_coefficient)
		if(!state)
			on = FALSE
			playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, 1 -3)
			visible_message("\icon[src]\The [src] buzzes indicating that error has occured.")
		else if(state == -1)
			on = FALSE
			playsound(src.loc, 'sound/machines/ping.ogg', 50, 1 -3)
			visible_message("\icon[src]\The [src] pings indicating that process is complete.")
		update_icon()
		SSnano.update_uis(src)

/obj/machinery/electrolyzer/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return

	if(istype(I, /obj/item/weapon/reagent_containers) && I.is_open_container() && (!beaker || !separationBeaker))
		. = TRUE //no afterattack
		var/obj/item/weapon/reagent_containers/B = I
		if(!user.unEquip(B, src))
			return
		if(!beaker)
			beaker = B
		else if(!separationBeaker)
			separationBeaker = B
		to_chat(user, SPAN_NOTICE("You add [B] to [src]."))
		SSnano.update_uis(src)
		update_icon()
		return
	return ..()

/obj/machinery/electrolyzer/on_deconstruction()
	if(beaker)
		beaker.forceMove(get_turf(src))
		beaker = null
	if(separationBeaker)
		separationBeaker.forceMove(get_turf(src))
		separationBeaker = null
	..()
	

/obj/machinery/electrolyzer/attack_hand(mob/user)
	if(..())
		return TRUE

	user.set_machine(src)
	ui_interact(user)

/obj/machinery/electrolyzer/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	var/list/data = ui_data()

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "electrolyzer.tmpl", name, 550, 400)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()



/obj/machinery/electrolyzer/ui_data()
	var/data = list()
	data["on"] = on

	if(beaker)
		data["beaker"] = beaker.reagents.ui_data()
	if(separationBeaker)
		data["separationBeaker"] = separationBeaker.reagents.ui_data()
	data["has_power"] = (stat & NOPOWER) ? FALSE : TRUE
	return data


/obj/machinery/electrolyzer/Topic(href, href_list)
	if(..())
		return

	if(href_list["turn_on"])
		on = TRUE
		update_icon()

	if(href_list["turn_off"])
		on = FALSE
		update_icon()

	if(href_list["eject"] && beaker)
		on = FALSE
		if(beaker)
			beaker.forceMove(get_turf(src))
			beaker = null
			update_icon()

	if(href_list["ejectSecondary"] && beaker)
		on = FALSE
		if(separationBeaker)
			separationBeaker.forceMove(get_turf(src))
			separationBeaker = null
		update_icon()

	return 1 // update UIs attached to this object



/obj/item/device/makeshiftElectrolyser
	name = "makeshift electrolyzer"
	icon = 'icons/obj/machines/chemistry.dmi'
	icon_state = "electrolysis_makeshift"
	var/on = FALSE
	var/tick_cost = 3
	var/obj/item/weapon/cell/cell = null
	var/suitable_cell = /obj/item/weapon/cell/small
	var/obj/item/weapon/reagent_containers/beaker
	var/obj/item/weapon/reagent_containers/separationBeaker

//obj/item/device/makeshiftElectrolyser/update_icon()
//	if(on)
	/*if(beaker)
		icon_state = "mixer1b"
	else
		icon_state = "mixer0b"
	*/

/obj/item/device/makeshiftElectrolyser/Initialize()
	. = ..()

/obj/item/device/makeshiftElectrolyser/Destroy()
	QDEL_NULL(beaker)
	QDEL_NULL(cell)
	return ..()

/obj/item/device/makeshiftElectrolyser/get_cell()
	return cell

/obj/item/device/makeshiftElectrolyser/handle_atom_del(atom/A)
	..()
	if(A == cell)
		cell = null
		update_icon()
	if(A == beaker)
		beaker = null
		update_icon()

/obj/item/device/makeshiftElectrolyser/proc/turn_on(mob/user)
	if(!cell || !cell.check_charge(tick_cost))
		playsound(loc, 'sound/machines/button.ogg', 50, 1)
		user << SPAN_WARNING("[src] battery is dead or missing.")
		return FALSE
	on = TRUE
	START_PROCESSING(SSobj, src)

/obj/item/device/makeshiftElectrolyser/proc/turn_off(mob/user)
	on = FALSE
	STOP_PROCESSING(SSobj, src)
	SSnano.update_uis(src)

/obj/item/device/makeshiftElectrolyser/Process()
	if(on)
		if(!cell || !cell.checked_use(tick_cost))
			visible_message(SPAN_NOTICE("[src]'s electrodes stopped bubbling."), range = 4)
			turn_off()
		if(beaker && beaker.reagents.total_volume)
			var/state = electrolysis(beaker, separationBeaker, 2)
			if(!state || state == -1)
				turn_off()
			SSnano.update_uis(src)
			

/obj/item/device/makeshiftElectrolyser/attack_self(mob/user as mob)
	user.set_machine(src)
	ui_interact(user)
	add_fingerprint(user)

/obj/item/device/makeshiftElectrolyser/MouseDrop(over_object)
	if((src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
		cell = null
	else
		return ..()

/obj/item/device/makeshiftElectrolyser/attackby(obj/item/C, mob/living/user)
	if(istype(C, suitable_cell) && !cell && insert_item(C, user))
		to_chat(user, SPAN_NOTICE("You add [C] to [src]."))
		src.cell = C
		SSnano.update_uis(src)
		return
	if(istype(C, /obj/item/weapon/reagent_containers) && C.is_open_container() && (!beaker || !separationBeaker))
		. = TRUE //no afterattack
		var/obj/item/weapon/reagent_containers/B = C
		if(!user.unEquip(B, src))
			return
		if(!beaker)
			beaker = B
		else if(!separationBeaker)
			separationBeaker = B
		to_chat(user, SPAN_NOTICE("You add [B] to [src]."))
		SSnano.update_uis(src)
		return
	return ..()

/obj/item/device/makeshiftElectrolyser/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	var/list/data = ui_data()

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "electrolyzer.tmpl", name, 550, 400)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()



/obj/item/device/makeshiftElectrolyser/ui_data()
	var/data = list()
	data["on"] = on
	data["has_power"] = cell ? cell.check_charge(tick_cost) : FALSE

	if(beaker)
		data["beaker"] = beaker.reagents.ui_data()
	if(separationBeaker)
		data["separationBeaker"] = separationBeaker.reagents.ui_data()
	return data

/obj/item/device/makeshiftElectrolyser/attack_hand(mob/user)
	if(loc != user && ..())
		return TRUE
	user.set_machine(src)
	ui_interact(user)

/obj/item/device/makeshiftElectrolyser/Topic(href, href_list)
	if(..())
		return

	if(href_list["turn_on"])
		turn_on()

	if(href_list["turn_off"])
		turn_off()

	if(href_list["eject"] && beaker)
		turn_off()
		if(beaker)
			beaker.forceMove(get_turf(src))
			beaker = null

	if(href_list["ejectSecondary"] && separationBeaker)
		turn_off()
		if(separationBeaker)
			separationBeaker.forceMove(get_turf(src))
			separationBeaker = null

	return 1 // update UIs attached to this object

