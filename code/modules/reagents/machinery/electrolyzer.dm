/obj/machinery/electrolyzer
	name = "electrolyzer"
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0b"
	use_power = IDLE_POWER_USE
	idle_power_usage = 40
	//resistance_flags = FIRE_PROOF | ACID_PROOF
	//circuit = /obj/item/weapon/circuitboard/electrolyzer
	var/obj/item/weapon/reagent_containers/beaker
	var/convertion_coefficient = 2
	var/on = FALSE

/obj/machinery/electrolyzer/Destroy()
	QDEL_NULL(beaker)
	return ..()

/obj/machinery/electrolyzer/update_icon()
//	if(on)
	if(beaker)
		icon_state = "mixer1b"
	else
		icon_state = "mixer0b"

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
		beaker.reagents.adjust_thermal_energy((350 - beaker.reagents.chem_temp) * 0.05 * SPECIFIC_HEAT_DEFAULT * beaker.reagents.total_volume)
		beaker.reagents.isElectrolysed = TRUE
		beaker.reagents.handle_reactions()
		SSnano.update_uis(src)

/obj/machinery/electrolyzer/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return


	if(istype(I, /obj/item/weapon/reagent_containers) && I.is_open_container())
		. = TRUE //no afterattack
		var/obj/item/weapon/reagent_containers/B = I
		if(!user.unEquip(B, src))
			return
		beaker = B
		to_chat(user, SPAN_NOTICE("You add [B] to [src]."))
		updateUsrDialog()
		update_icon()
		return
	return ..()

/obj/machinery/electrolyzer/on_deconstruction()
	if(beaker)
		beaker.forceMove(get_turf(src))
		beaker = null
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
		ui = new(user, src, ui_key, "electrolyzer.tmpl", name, 275, 400)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()



/obj/machinery/electrolyzer/ui_data()
	var/data = list()
	data["on"] = on

	if(beaker)
		data["beaker"] = beaker.reagents.ui_data()
	return data


/obj/machinery/electrolyzer/Topic(href, href_list)
	if(..())
		return

	if(href_list["power"])
		on = !on

	if(href_list["eject"] && beaker)
		on = FALSE
		beaker.forceMove(get_turf(src))

	return 1 // update UIs attached to this object



/obj/item/device/makeshiftElectrolyser
	name = "makeshift electrolyzer"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0b"
	var/on = FALSE
	var/tick_cost = 30
	var/obj/item/weapon/cell/cell = null
	var/suitable_cell = /obj/item/weapon/cell/small
	var/obj/item/weapon/reagent_containers/beaker

/obj/item/device/makeshiftElectrolyser/update_icon()
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
	. = ..()

/obj/item/device/makeshiftElectrolyser/proc/turn_off(mob/user)
	. = ..()
	if(. && user)
		user.update_action_buttons()

/obj/item/device/makeshiftElectrolyser/Process()
	if(on)
		if(!cell || !cell.checked_use(tick_cost))
			visible_message(SPAN_NOTICE("[src]'s electrodes stopped bubbling."), range = 4)
			turn_off()
		if(beaker && beaker.reagents.total_volume)
			beaker.reagents.isElectrolysed = TRUE
			beaker.reagents.handle_reactions()
			SSnano.update_uis(src)

/obj/item/device/makeshiftElectrolyser/MouseDrop(over_object)
	if((src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
		cell = null
	else
		return ..()

/obj/item/device/makeshiftElectrolyser/attackby(obj/item/C, mob/living/user)
	if(istype(C, suitable_cell) && !cell && insert_item(C, user))
		to_chat(user, SPAN_NOTICE("You add [C] to [src]."))
		src.cell = C
