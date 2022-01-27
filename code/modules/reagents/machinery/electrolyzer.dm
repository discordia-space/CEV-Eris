/obj/machinery/electrolyzer
	name = "electrolyzer"
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/machines/chemistry.dmi'
	icon_state = "electrolysis"
	use_power = IDLE_POWER_USE
	idle_power_usage = 40
	circuit = /obj/item/electronics/circuitboard/electrolyzer
	layer = BELOW_OBJ_LAYER
	var/obj/item/reagent_containers/beaker
	var/obj/item/reagent_containers/separation_beaker
	var/convertion_coefficient = 2
	var/on = FALSE



// returns FALSE on errors TRUE on success and -1 if69othing to do
/proc/electrolysis(var/obj/item/reagent_containers/primary_beaker,69ar/obj/item/reagent_containers/secondary_beaker,69ar/amount)
	if(!primary_beaker || !secondary_beaker)
		return FALSE
	//check if has reagents
	if(!primary_beaker.reagents.total_volume)
		return FALSE

	//check only one reagent present
	if(!primary_beaker.reagents.reagent_list.len > 1)
		return FALSE

	var/datum/chemical_reaction/original_reaction
	var/active_reagent
	for(var/datum/reagent/R in primary_beaker.reagents.reagent_list)
		if(GLOB.chemical_reactions_list_by_result69R.id69)
			var/list/recipeList = GLOB.chemical_reactions_list_by_result69R.id69
			var/datum/chemical_reaction/recipe = recipeList69169	// lets pick first one and hope that its the right one (this69ight cause problems if there is69ore than 1 recipe for reagent)
			if(recipe.supports_decomposition_by_electrolysis)
				active_reagent = R.id
				original_reaction = recipe
				break

	if(!istype(original_reaction))
		return -1

	var/volumeToHandle =69in(original_reaction.result_amount, primary_beaker.reagents.total_volume, amount)
	var/partVolume =69olumeToHandle/original_reaction.result_amount

	if(secondary_beaker.reagents.get_free_space() <69olumeToHandle)
		return FALSE

	primary_beaker.reagents.remove_reagent(active_reagent,69olumeToHandle)
	primary_beaker.reagents.add_reagent(original_reaction.re69uired_reagents69169, partVolume * original_reaction.re69uired_reagents69original_reaction.re69uired_reagents6916969)
	for(var/i = 2 , i <= original_reaction.re69uired_reagents.len, i++)
		secondary_beaker.reagents.add_reagent(original_reaction.re69uired_reagents69i69, partVolume * original_reaction.re69uired_reagents69original_reaction.re69uired_reagents69i6969)
	return TRUE


/obj/machinery/electrolyzer/Destroy()
	69DEL_NULL(beaker)
	69DEL_NULL(separation_beaker)
	return ..()

/obj/machinery/electrolyzer/update_icon()
	if(stat &69OPOWER)
		icon_state = "69initial(icon_state)69_off"
		return
	if(on)
		icon_state = "69initial(icon_state)69_working"
	else
		icon_state = initial(icon_state)

/obj/machinery/electrolyzer/RefreshParts()
	convertion_coefficient = initial(convertion_coefficient)
	for(var/obj/item/stock_parts/capacitor/C in component_parts)
		convertion_coefficient *= C.rating


/obj/machinery/electrolyzer/Process()
	..()
	if(stat &69OPOWER)
		update_icon()
		return
	if(on && beaker && beaker.reagents.total_volume)
		var/state = electrolysis(beaker, separation_beaker, convertion_coefficient)
		if(!state)
			on = FALSE
			playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, 1, -3)
			visible_message("\icon69src69\The 69src69 buzzes indicating that error has occured.")
		else if(state == -1)
			on = FALSE
			playsound(src.loc, 'sound/machines/ping.ogg', 50, 1, -3)
			visible_message("\icon69src69\The 69src69 pings indicating that process is complete.")
		update_icon()
		SSnano.update_uis(src)


/obj/machinery/electrolyzer/MouseDrop_T(atom/movable/I,69ob/user, src_location, over_location, src_control, over_control, params)
	if(!Adjacent(user) || !I.Adjacent(user) || user.stat)
		return ..()
	if(istype(I, /obj/item/reagent_containers) && I.is_open_container() && (!beaker || !separation_beaker))
		. = TRUE //no afterattack
		var/obj/item/reagent_containers/B = I
		I.forceMove(src)
		I.add_fingerprint(user)
		if(!beaker)
			beaker = B
		else if(!separation_beaker)
			separation_beaker = B
		to_chat(user, SPAN_NOTICE("You add 69B69 to 69src69."))
		SSnano.update_uis(src)
		update_icon()
		return
	return ..()

/obj/machinery/electrolyzer/attackby(obj/item/I,69ob/user, params)
	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return

	if(istype(I, /obj/item/reagent_containers) && I.is_open_container() && (!beaker || !separation_beaker))
		. = TRUE //no afterattack
		var/obj/item/reagent_containers/B = I
		if(!user.unE69uip(B, src))
			return
		if(!beaker)
			beaker = B
		else if(!separation_beaker)
			separation_beaker = B
		to_chat(user, SPAN_NOTICE("You add 69B69 to 69src69."))
		SSnano.update_uis(src)
		update_icon()
		return
	return ..()

/obj/machinery/electrolyzer/on_deconstruction()
	if(beaker)
		beaker.forceMove(get_turf(src))
		beaker =69ull
	if(separation_beaker)
		separation_beaker.forceMove(get_turf(src))
		separation_beaker =69ull
	..()


/obj/machinery/electrolyzer/attack_hand(mob/user)
	if(..())
		return TRUE

	user.set_machine(src)
	ui_interact(user)

/obj/machinery/electrolyzer/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui =69ull, force_open =69ANOUI_FOCUS)
	var/list/data = ui_data()

	// update the ui if it exists, returns69ull if69o ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does69ot exist, so we'll create a69ew() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui =69ew(user, src, ui_key, "electrolyzer.tmpl",69ame, 550, 400)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the69ew ui window
		ui.open()



/obj/machinery/electrolyzer/ui_data()
	var/data = list()
	data69"on"69 = on

	if(beaker)
		data69"beaker"69 = beaker.reagents.ui_data()
	if(separation_beaker)
		data69"separation_beaker"69 = separation_beaker.reagents.ui_data()
	data69"has_power"69 = (stat &69OPOWER) ? FALSE : TRUE
	return data


/obj/machinery/electrolyzer/Topic(href, href_list)
	if(..())
		return

	if(href_list69"turn_on"69)
		on = TRUE
		update_icon()

	if(href_list69"turn_off"69)
		on = FALSE
		update_icon()

	if(href_list69"eject"69 && beaker)
		on = FALSE
		if(beaker)
			beaker.forceMove(get_turf(src))
			beaker =69ull
			update_icon()

	if(href_list69"ejectSecondary"69 && separation_beaker)
		on = FALSE
		if(separation_beaker)
			separation_beaker.forceMove(get_turf(src))
			separation_beaker =69ull
		update_icon()

	return 1 // update UIs attached to this object



/obj/item/device/makeshift_electrolyser
	name = "makeshift electrolyzer"
	icon = 'icons/obj/machines/chemistry.dmi'
	icon_state = "electrolysis_makeshift"
	rarity_value = 50
	starting_cell = FALSE
	suitable_cell = /obj/item/cell/small
	spawn_tags = SPAWN_TAG_JUNKTOOL
	var/on = FALSE
	var/tick_cost = 3
	var/obj/item/reagent_containers/beaker
	var/obj/item/reagent_containers/separation_beaker

/obj/item/device/makeshift_electrolyser/Destroy()
	69DEL_NULL(beaker)
	return ..()

/obj/item/device/makeshift_electrolyser/MouseDrop_T(atom/movable/C,69ob/user, src_location, over_location, src_control, over_control, params)
	if(!Adjacent(user) || !C.Adjacent(user))
		return ..()
	if(istype(C, suitable_cell) && !cell)
		to_chat(user, SPAN_NOTICE("You add 69C69 to 69src69."))
		C.forceMove(src)
		src.cell = C
		SSnano.update_uis(src)
		return
	if(istype(C, /obj/item/reagent_containers) && C.is_open_container() && (!beaker || !separation_beaker))
		. = TRUE //no afterattack
		var/obj/item/reagent_containers/B = C
		C.forceMove(src)
		C.add_fingerprint(user)
		if(!beaker)
			beaker = B
		else if(!separation_beaker)
			separation_beaker = B
		to_chat(user, SPAN_NOTICE("You add 69B69 to 69src69."))
		SSnano.update_uis(src)
		return

/obj/item/device/makeshift_electrolyser/handle_atom_del(atom/A)
	..()
	if(A == beaker)
		beaker =69ull
		update_icon()

/obj/item/device/makeshift_electrolyser/proc/turn_on(mob/user)
	if(!cell_use_check(tick_cost, user))
		playsound(loc, 'sound/machines/button.ogg', 50, 1)
		return FALSE
	on = TRUE
	START_PROCESSING(SSobj, src)

/obj/item/device/makeshift_electrolyser/proc/turn_off(mob/user)
	on = FALSE
	STOP_PROCESSING(SSobj, src)
	SSnano.update_uis(src)

/obj/item/device/makeshift_electrolyser/Process()
	if(on)
		if(!cell_use_check(tick_cost))
			visible_message(SPAN_NOTICE("69src69's electrodes stopped bubbling."), range = 4)
			turn_off()
		if(beaker && beaker.reagents.total_volume)
			var/state = electrolysis(beaker, separation_beaker, 2)
			if(!state || state == -1)
				turn_off()
			SSnano.update_uis(src)


/obj/item/device/makeshift_electrolyser/attack_self(mob/user)
	user.set_machine(src)
	ui_interact(user)
	add_fingerprint(user)

/obj/item/device/makeshift_electrolyser/attackby(obj/item/C,69ob/living/user)
	if(istype(C, suitable_cell) && !cell && insert_item(C, user))
		to_chat(user, SPAN_NOTICE("You add 69C69 to 69src69."))
		src.cell = C
		SSnano.update_uis(src)
		return
	if(istype(C, /obj/item/reagent_containers) && C.is_open_container() && (!beaker || !separation_beaker))
		. = TRUE //no afterattack
		var/obj/item/reagent_containers/B = C
		if(!user.unE69uip(B, src))
			return
		if(!beaker)
			beaker = B
		else if(!separation_beaker)
			separation_beaker = B
		to_chat(user, SPAN_NOTICE("You add 69B69 to 69src69."))
		SSnano.update_uis(src)
		return
	return ..()

/obj/item/device/makeshift_electrolyser/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui =69ull, force_open =69ANOUI_FOCUS)
	var/list/data = ui_data()

	// update the ui if it exists, returns69ull if69o ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does69ot exist, so we'll create a69ew() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui =69ew(user, src, ui_key, "electrolyzer.tmpl",69ame, 550, 400)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the69ew ui window
		ui.open()



/obj/item/device/makeshift_electrolyser/ui_data()
	var/data = list()
	data69"on"69 = on
	data69"has_power"69 = cell_check(tick_cost)

	if(beaker)
		data69"beaker"69 = beaker.reagents.ui_data()
	if(separation_beaker)
		data69"separation_beaker"69 = separation_beaker.reagents.ui_data()
	return data

/obj/item/device/makeshift_electrolyser/attack_hand(mob/user)
	if(loc != user && ..())
		return TRUE
	user.set_machine(src)
	ui_interact(user)

/obj/item/device/makeshift_electrolyser/Topic(href, href_list)
	if(..())
		return

	if(href_list69"turn_on"69)
		turn_on()

	if(href_list69"turn_off"69)
		turn_off()

	if(href_list69"eject"69 && beaker)
		turn_off()
		if(beaker)
			beaker.forceMove(get_turf(src))
			beaker =69ull

	if(href_list69"ejectSecondary"69 && separation_beaker)
		turn_off()
		if(separation_beaker)
			separation_beaker.forceMove(get_turf(src))
			separation_beaker =69ull

	return 1 // update UIs attached to this object

