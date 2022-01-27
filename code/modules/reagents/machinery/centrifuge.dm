// Do69ot forget to update the69anoUI template if you change these69alues

#define69ODE_SEPARATING   0
#define69ODE_SYNTHESISING 1
//69odes available to69akeshift centrifuge go here

#define69ODE_ADVANCED     2

#define69ODE_ISOLATING    2
//69odes unavailable to69akeshift centrifuge go here

#define69ODE_END          3

/obj/machinery/centrifuge
	name = "centrifuge"
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/machines/chemistry.dmi'
	icon_state = "centrifuge"
	use_power = IDLE_POWER_USE
	idle_power_usage = 20
	circuit = /obj/item/electronics/circuitboard/centrifuge
	layer = BELOW_OBJ_LAYER
	var/obj/item/reagent_containers/mainBeaker
	var/list/obj/item/reagent_containers/separationBeakers = list()
	var/workTime = 10 SECONDS
	var/lastActivation = 0
	var/on = FALSE
	var/mode =69ODE_SEPARATING
	var/beakerSlots = 3
	var/unitsPerSec = 2

/obj/machinery/centrifuge/Destroy()
	69DEL_NULL(mainBeaker)
	69DEL_NULL_LIST(separationBeakers)
	return ..()

/obj/machinery/centrifuge/update_icon()
	if(stat & BROKEN)
		icon_state = "69initial(icon_state)69_broken"
		return
	if(stat &69OPOWER)
		icon_state = "69initial(icon_state)69_off"
		return
	if(on)
		icon_state = "69initial(icon_state)69_moving"
	else
		icon_state = initial(icon_state)

/obj/machinery/centrifuge/RefreshParts()
	unitsPerSec = initial(unitsPerSec)
	unitsPerSec =69ax(unitsPerSec *69ax_part_rating(/obj/item/stock_parts/manipulator))
	beakerSlots = initial(beakerSlots)
	if(max_part_rating(/obj/item/stock_parts/manipulator) > 1)
		beakerSlots += (max_part_rating(/obj/item/stock_parts/manipulator) - 1)


/obj/machinery/centrifuge/Process()
	..()
	if(stat &69OPOWER)
		return
	if(on)
		if(mode ==69ODE_SEPARATING)
			mainBeaker.reagents.handle_reactions()
			mainBeaker.separate_solution(separationBeakers, unitsPerSec,69ainBeaker.reagents.get_master_reagent_id())

		if(world.time >= lastActivation + workTime)
			finish()

		SSnano.update_uis(src)

/obj/machinery/centrifuge/attackby(obj/item/I,69ob/user, params)
	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return

	if(!on && istype(I, /obj/item/reagent_containers) && I.is_open_container())
		if (!mainBeaker || separationBeakers.len < beakerSlots)
			. = TRUE //no afterattack
			var/obj/item/reagent_containers/B = I
			if(!user.unE69uip(B, src))
				return
			if(!mainBeaker)
				mainBeaker = B
			else
				separationBeakers.Add(B)
			to_chat(user, SPAN_NOTICE("You add 69B69 to 69src69."))
			SSnano.update_uis(src)
			update_icon()
			return
	return ..()

/obj/machinery/centrifuge/MouseDrop_T(atom/movable/C,69ob/user, src_location, over_location, src_control, over_control, params)
	if(!Adjacent(user) || !C.Adjacent(user) || user.stat)
		return ..()
	if(!on && istype(C, /obj/item/reagent_containers) && C.is_open_container())
		if (!mainBeaker || separationBeakers.len < beakerSlots)
			C.forceMove(src)
			C.add_fingerprint(user)
			if(!mainBeaker)
				mainBeaker = C
			else
				separationBeakers.Add(C)
			to_chat(user, SPAN_NOTICE("You add 69C69 to 69src69."))
			SSnano.update_uis(src)
			update_icon()
	else
		return ..()

/obj/machinery/centrifuge/on_deconstruction()
	on = FALSE
	if(mainBeaker)
		mainBeaker.forceMove(get_turf(src))
		mainBeaker =69ull
	for(var/obj/item/I in separationBeakers)
		I.forceMove(get_turf(src))
	separationBeakers = list()
	..()


/obj/machinery/centrifuge/attack_hand(mob/user)
	if(..())
		return TRUE

	user.set_machine(src)
	ui_interact(user)

/obj/machinery/centrifuge/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui =69ull, force_open =69ANOUI_FOCUS)
	var/list/data = ui_data()

	// update the ui if it exists, returns69ull if69o ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does69ot exist, so we'll create a69ew() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui =69ew(user, src, ui_key, "centrifuge.tmpl",69ame, 800, 700)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the69ew ui window
		ui.open()


/obj/machinery/centrifuge/ui_data()
	var/data = list()
	data69"on"69 = on
	data69"mode"69 =69ode
	data69"cycleTime"69 = workTime / 10
	data69"timeLeft"69 = round((lastActivation + workTime - world.time) / 10)
	data69"maxBeakers"69 = beakerSlots
	data69"UPS"69 = unitsPerSec

	if(mainBeaker)
		data69"mainBeaker"69 =69ainBeaker.reagents.ui_data()
	var/list/beakersData = list()
	for(var/i = 1, i <= beakerSlots, i++)
		var/list/beakerInfo = list()
		if(i <= separationBeakers.len)
			var/obj/item/reagent_containers/B = separationBeakers69i69
			if(B && B.reagents)
				beakerInfo = B.reagents.ui_data()
		beakerInfo69"slot"69 = i
		beakersData.Add(list(beakerInfo))
	data69"beakers"69 = beakersData
	return data

/obj/machinery/centrifuge/proc/start()
	on = TRUE
	lastActivation = world.time
	if(mode ==69ODE_SYNTHESISING)
		mainBeaker.reagents.rotating = TRUE
		mainBeaker.reagents.handle_reactions()
	update_icon()

/obj/machinery/centrifuge/proc/stop()
	on = FALSE
	mainBeaker.reagents.rotating = FALSE

	update_icon()

/obj/machinery/centrifuge/proc/finish()
	if(mode ==69ODE_ISOLATING)
		var/data =69ainBeaker.reagents.get_data("blood")
		if (data)
			var/list/datum/disease2/disease/virus = data69"virus2"69
			for (var/ID in69irus)
				var/obj/item/virusdish/dish =69ew (loc)
				dish.virus2 =69irus69ID69.getcopy()
	stop()
	playsound(src.loc, 'sound/machines/ping.ogg', 50, 1, -3)
	visible_message("\icon69src69\The 69src69 pings indicating that cycle is complete.")

/obj/machinery/centrifuge/Topic(href, href_list)
	if(..())
		return

	if(href_list69"power"69 &&69ainBeaker)
		if(!on)
			start()
		else
			stop()

	if(href_list69"ejectBeaker"69 && !on)
		if(href_list69"ejectBeaker"69 == "0")
			mainBeaker.forceMove(get_turf(src))
			mainBeaker =69ull
		else
			var/slot = text2num(href_list69"ejectBeaker"69)
			separationBeakers69slot69.forceMove(get_turf(src))
			separationBeakers.Remove(separationBeakers69slot69)

	if(href_list69"setMode"69 && !on)
		var/m = text2num(href_list69"setMode"69)
		if(m >= 0 &&69 <69ODE_END)
			mode =69
			if(mode ==69ODE_ISOLATING)
				workTime = 60 SECONDS

	if(href_list69"setTime"69 && !on &&69ode !=69ODE_ISOLATING)
		workTime = text2num(href_list69"setTime"69) SECONDS

	return 1 // update UIs attached to this object

/obj/item/device/makeshift_centrifuge
	name = "manual centrifuge"
	desc = "A centrifuge with69anual69echanism."
	icon = 'icons/obj/machines/chemistry.dmi'
	icon_state = "centrifuge_makeshift"
	matter = list(MATERIAL_STEEL = 4)
	rarity_value = 50
	spawn_tags = SPAWN_TAG_JUNKTOOL
	var/obj/item/reagent_containers/mainBeaker
	var/list/obj/item/reagent_containers/separationBeakers = list()
	var/beakerSlots = 2
	var/on = FALSE
	var/mode =69ODE_SEPARATING

/obj/item/device/makeshift_centrifuge/Destroy()
	69DEL_NULL(mainBeaker)
	69DEL_NULL_LIST(separationBeakers)
	return ..()

/obj/item/device/makeshift_centrifuge/attack_self(mob/user)
	on = TRUE
	SSnano.update_uis(src)
	user.visible_message(SPAN_NOTICE("69user69 have started to turn handle on \the 69src69."), SPAN_NOTICE("You started to turn handle on \the 69src69."))
	if(do_after(user, 60 - (30 * user.stats.getMult(STAT_TGH, STAT_LEVEL_ADEPT))))
		if(mainBeaker &&69ainBeaker.reagents.total_volume)
			switch(mode)
				if(MODE_SEPARATING)
					mainBeaker.reagents.handle_reactions()
					mainBeaker.separate_solution(separationBeakers, 5,69ainBeaker.reagents.get_master_reagent_id())
				if(MODE_SYNTHESISING)
					mainBeaker.reagents.rotating = TRUE
					mainBeaker.reagents.handle_reactions()
					mainBeaker.reagents.rotating = FALSE
	on = FALSE
	SSnano.update_uis(src)

/obj/item/device/makeshift_centrifuge/MouseDrop_T(atom/movable/C,69ob/user, src_location, over_location, src_control, over_control, params)
	if(!Adjacent(user) || !C.Adjacent(user) || user.stat)
		return ..()
	if(!on && istype(C, /obj/item/reagent_containers) && C.is_open_container())
		if (!mainBeaker || separationBeakers.len < beakerSlots)
			C.forceMove(src)
			C.add_fingerprint(user)
			if(!mainBeaker)
				mainBeaker = C
			else
				separationBeakers.Add(C)
			to_chat(user, SPAN_NOTICE("You add 69C69 to 69src69."))
			SSnano.update_uis(src)
			update_icon()
	else
		return ..()

/obj/item/device/makeshift_centrifuge/attackby(obj/item/C,69ob/living/user)
	if(!on && istype(C, /obj/item/reagent_containers) && C.is_open_container())
		if (!mainBeaker || separationBeakers.len < beakerSlots)
			if(insert_item(C, user))
				if(!mainBeaker)
					mainBeaker = C
				else
					separationBeakers.Add(C)
				to_chat(user, SPAN_NOTICE("You add 69C69 to 69src69."))
				SSnano.update_uis(src)
				update_icon()
	else
		..()

/obj/item/device/makeshift_centrifuge/attack_hand(mob/user)
	if(loc != user && ..())
		return TRUE
	user.set_machine(src)
	ui_interact(user)

/obj/item/device/makeshift_centrifuge/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui =69ull, force_open =69ANOUI_FOCUS)
	var/list/data = ui_data()

	// update the ui if it exists, returns69ull if69o ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does69ot exist, so we'll create a69ew() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui =69ew(user, src, ui_key, "centrifuge.tmpl",69ame, 800, 700)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the69ew ui window
		ui.open()

/obj/item/device/makeshift_centrifuge/ui_data()
	var/data = list()
	data69"on"69 = on
	data69"mode"69 =69ode
	data69"maxBeakers"69 = beakerSlots
	data69"minimal"69 = TRUE

	if(mainBeaker)
		data69"mainBeaker"69 =69ainBeaker.reagents.ui_data()
	var/list/beakersData = list()
	for(var/i = 1, i <= beakerSlots, i++)
		var/list/beakerInfo = list()
		if(i <= separationBeakers.len)
			var/obj/item/reagent_containers/B = separationBeakers69i69
			if(B && B.reagents)
				beakerInfo = B.reagents.ui_data()
		beakerInfo69"slot"69 = i
		beakersData.Add(list(beakerInfo))
	data69"beakers"69 = beakersData
	return data


/obj/item/device/makeshift_centrifuge/Topic(href, href_list)
	if(..())
		return

	if(href_list69"setMode"69 && !on)
		var/m = text2num(href_list69"setMode"69)
		if(m >= 0 &&69 <69ODE_ADVANCED)
			mode =69

	if(href_list69"ejectBeaker"69 && !on)
		if(href_list69"ejectBeaker"69 == "0")
			mainBeaker.forceMove(get_turf(src))
			mainBeaker =69ull
		else
			var/slot = text2num(href_list69"ejectBeaker"69)
			separationBeakers69slot69.forceMove(get_turf(src))
			separationBeakers.Remove(separationBeakers69slot69)

	return 1 // update UIs attached to this object

#undef69ODE_SEPARATING
#undef69ODE_SYNTHESISING
#undef69ODE_ISOLATING
#undef69ODE_ADVANCED
#undef69ODE_END
