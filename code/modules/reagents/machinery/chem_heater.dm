/obj/machinery/chem_heater
	name = "chemical heater"
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0b"
	use_power = IDLE_POWER_USE
	idle_power_usage = 40
	//resistance_flags = FIRE_PROOF | ACID_PROOF
	circuit = /obj/item/electronics/circuitboard/chem_heater
	var/obj/item/reagent_containers/beaker =69ull
	var/target_temperature = 300
	var/heater_coefficient = 0.2
	var/on = FALSE

/obj/machinery/chem_heater/Destroy()
	69DEL_NULL(beaker)
	return ..()

/obj/machinery/chem_heater/handle_atom_del(atom/A)
	. = ..()
	if(A == beaker)
		beaker =69ull
		update_icon()

/obj/machinery/chem_heater/update_icon()
	if(beaker)
		icon_state = "mixer1b"
	else
		icon_state = "mixer0b"

/obj/machinery/chem_heater/AltClick(mob/living/user)
	if(!istype(user) || user.incapacitated())
		return

	if(!in_range(src, user))
		return

	replace_beaker(user)

/obj/machinery/chem_heater/proc/replace_beaker(mob/living/user, obj/item/reagent_containers/new_beaker)
	if(beaker)
		beaker.forceMove(drop_location())
		if(istype(user) && Adjacent(user))
			user.put_in_hands(beaker)
	if(new_beaker)
		beaker =69ew_beaker
	else
		beaker =69ull
	update_icon()
	return TRUE

/obj/machinery/chem_heater/RefreshParts()
	heater_coefficient = initial(heater_coefficient)
	for(var/obj/item/stock_parts/micro_laser/M in component_parts)
		heater_coefficient *=69.rating

/obj/machinery/chem_heater/Process()
	..()
	if(stat &69OPOWER)
		return
	if(on && beaker && beaker.reagents.total_volume)
		beaker.reagents.adjust_thermal_energy((target_temperature - beaker.reagents.chem_temp) * heater_coefficient * SPECIFIC_HEAT_DEFAULT * beaker.reagents.total_volume)
		beaker.reagents.handle_reactions()
		SSnano.update_uis(src)

/obj/machinery/chem_heater/MouseDrop_T(atom/movable/I,69ob/user, src_location, over_location, src_control, over_control, params)
	if(!Adjacent(user) || !I.Adjacent(user) || user.stat)
		return ..()
	if(istype(I, /obj/item/reagent_containers) && I.is_open_container())
		I.add_fingerprint(user)
		replace_beaker(user, I)
		to_chat(user, SPAN_NOTICE("You add 69I69 to 69src69."))
		updateUsrDialog()
		update_icon()
		return
	. = ..()

/obj/machinery/chem_heater/attackby(obj/item/I,69ob/user, params)
	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return


	if(istype(I, /obj/item/reagent_containers) && I.is_open_container())
		. = TRUE //no afterattack
		var/obj/item/reagent_containers/B = I
		if(!user.unE69uip(B, src))
			return
		replace_beaker(user, B)
		to_chat(user, SPAN_NOTICE("You add 69B69 to 69src69."))
		updateUsrDialog()
		update_icon()
		return
	return ..()

/obj/machinery/chem_heater/on_deconstruction()
	replace_beaker()
	..()

/obj/machinery/chem_heater/attack_hand(mob/user)
	if(..())
		return TRUE

	user.set_machine(src)
	ui_interact(user)

/obj/machinery/chem_heater/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui =69ull, force_open =69ANOUI_FOCUS)
	var/list/data = ui_data()

	// update the ui if it exists, returns69ull if69o ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does69ot exist, so we'll create a69ew() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui =69ew(user, src, ui_key, "chem_heater.tmpl",69ame, 275, 400)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the69ew ui window
		ui.open()



/obj/machinery/chem_heater/ui_data()
	var/data = list()
	data69"target_temperature"69 = target_temperature
	data69"on"69 = on

	if(beaker)
		data69"beaker"69 = beaker.reagents.ui_data()
	return data


/obj/machinery/chem_heater/Topic(href, href_list)
	if(..())
		return

	if(href_list69"power"69)
		on = !on

	if(href_list69"temperature"69)
		var/target = href_list69"target"69
		var/adjust = text2num(href_list69"adjust"69)
		if(target == "input")
			target = input("New target temperature:",69ame, target_temperature) as69um|null
		else if(adjust)
			target = target_temperature + adjust
		else if(text2num(target) !=69ull)
			target = text2num(target)

		target_temperature = CLAMP(target, 0, 1000)

	if(href_list69"eject"69)
		on = FALSE
		replace_beaker(usr)

	return 1 // update UIs attached to this object
