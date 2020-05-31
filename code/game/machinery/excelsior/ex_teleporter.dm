var/list/global/excelsior_teleporters = list() //This list is used to make turrets more efficient
var/global/excelsior_energy
var/global/excelsior_max_energy //Maximaum combined energy of all teleporters

/obj/machinery/complant_teleporter
	name = "excelsior long-range teleporter"
	desc = "A powerful one way teleporter that allows shipping in construction materials. Takes a long time to charge."
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/machines/excelsior/teleporter.dmi'
	icon_state = "idle"
	use_power = IDLE_POWER_USE
	idle_power_usage = 40
	active_power_usage = 15000
	circuit = /obj/item/weapon/circuitboard/excelsior_teleporter

	var/max_energy = 100
	var/energy_gain = 1
	var/processing_order = FALSE
	var/nanoui_menu = 0 	// Based on Uplink
	var/mob/current_user 
	var/time_until_scan

	var/list/nanoui_data = list()			// Additional data for NanoUI use
	var/list/buy_list = list(
		MATERIAL_STEEL = list("amount" = 30, "price" = 100), //base prices doubled untill new item are in
		MATERIAL_WOOD = list("amount" = 30, "price" = 100),
		MATERIAL_PLASTIC = list("amount" = 30, "price" = 100),
		MATERIAL_GLASS = list("amount" = 30, "price" = 100),
		MATERIAL_SILVER = list("amount" = 10, "price" = 200),
		MATERIAL_PLASTEEL = list("amount" = 10, "price" = 400),
		MATERIAL_GOLD = list("amount" = 10, "price" = 400),
		MATERIAL_URANIUM = list("amount" = 10, "price" = 600),
		MATERIAL_DIAMOND = list("amount" = 10, "price" = 800),
		)

/obj/machinery/complant_teleporter/Initialize()
	excelsior_teleporters |= src
	.=..()

/obj/machinery/complant_teleporter/Destroy()
	excelsior_teleporters -= src
	RefreshParts() // To avoid energy overfills if a teleporter gets destroyed
	.=..()

/obj/machinery/complant_teleporter/RefreshParts()
	var/man_rating = 0
	var/man_amount = 0
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		man_rating += M.rating
		man_amount++

	// +50% speed for each upgrade tier
	var/coef = 1 + (((man_rating / man_amount) - 1) / 2)

	energy_gain = initial(energy_gain) * coef
	active_power_usage = initial(active_power_usage) * coef

	var/obj/item/weapon/cell/C = locate() in component_parts
	if(C)
		max_energy = C.maxcharge //Big buff for max energy
		excelsior_max_energy = 0
		for (var/obj/machinery/complant_teleporter/t in excelsior_teleporters)
			excelsior_max_energy += t.max_energy
		excelsior_energy = min(excelsior_energy, excelsior_max_energy)
		if(C.autorecharging)
			energy_gain *= 2


/obj/machinery/complant_teleporter/update_icon()
	overlays.Cut()

	if(panel_open)
		overlays += image("panel")

	if(stat & (BROKEN|NOPOWER))
		icon_state = "off"
	else
		icon_state = initial(icon_state)


/obj/machinery/complant_teleporter/attackby(obj/item/I, mob/user)
	if(default_deconstruction(I, user))
		return
	..()

/obj/machinery/complant_teleporter/power_change()
	..()
	SSnano.update_uis(src) // update all UIs attached to src

/obj/machinery/complant_teleporter/Process()
	if(stat & (BROKEN|NOPOWER))
		return

	if(excelsior_energy < (excelsior_max_energy - energy_gain))
		excelsior_energy += energy_gain
		SSnano.update_uis(src)
		use_power = ACTIVE_POWER_USE
	else
		excelsior_energy = excelsior_max_energy
		use_power = IDLE_POWER_USE


/obj/machinery/complant_teleporter/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return


 /**
  * The ui_interact proc is used to open and update Nano UIs
  * If ui_interact is not used then the UI will not update correctly
  * ui_interact is currently defined for /atom/movable
  *
  * @param user /mob The mob who is interacting with this ui
  * @param ui_key string A string key to use for this ui. Allows for multiple unique uis on one obj/mob (defaut value "main")
  *
  * @return nothing
  */
/obj/machinery/complant_teleporter/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	if(stat & (BROKEN|NOPOWER)) return
	if(user.stat || user.restrained()) return

	var/list/data = ui_data()

	time_until_scan = time2text((1800 - ((world.time - round_start_time) % 1800)), "mm:ss")

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "excelsior_teleporter.tmpl", name, 390, 450)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/complant_teleporter/ui_data()
	var/list/data = list()
	data["energy"] = round(excelsior_energy)
	data["maxEnergy"] = round(excelsior_max_energy)
	data["menu"] = nanoui_menu
	data["excel_user"] = is_excelsior(current_user)
	data["time_until_scan"] = time_until_scan
	data += nanoui_data

	var/list/order_list = list()
	for(var/item in buy_list)
		order_list += list(
			list(
				"title" = material_display_name(item),
				"amount" = buy_list[item]["amount"],
				"price" = buy_list[item]["price"],
				"commands" = list("order" = item)
				)
			) // list in a list because Byond merges the first list...

	data["buy_list"] = order_list

	return data


/obj/machinery/complant_teleporter/Topic(href, href_list)
	if(stat & (NOPOWER|BROKEN))
		return 0 // don't update UIs attached to this object

	if(processing_order)
		return 0

	if(href_list["order"])
		var/ordered_item = href_list["order"]
		if (buy_list.Find(ordered_item))
			var/order_energy_cost = buy_list[ordered_item]["price"]
			if(order_energy_cost > excelsior_energy)
				to_chat(usr, SPAN_WARNING("Not enough energy."))
				return 0

			processing_order = TRUE
			excelsior_energy = max(excelsior_energy - order_energy_cost, 0)

			var/order_path = material_stack_type(ordered_item)
			var/order_amount = buy_list[ordered_item]["amount"]

			flick("teleporting", src)
			spawn(17)
				complete_order(order_path, order_amount)

	if(href_list["open_menu"])
		nanoui_menu = 1

	if(href_list["close_menu"])
		nanoui_menu = 0

	add_fingerprint(usr)
	update_nano_data()
	return 1 // update UIs attached to this object


/obj/machinery/complant_teleporter/proc/update_nano_data()
	nanoui_data["menu"] = nanoui_menu
	if (nanoui_menu == 1)
		var/list/available_mandates = list()
		var/list/completed_mandates = list()
		for(var/datum/antag_contract/M in GLOB.excel_antag_contracts)
			var/list/entry = list(list(
				"name" = M.name,
				"desc" = M.desc,
				"reward" = M.reward,
				"status" = M.completed ? "Fulfilled" : "Available"
			))
			if(!M.completed)
				available_mandates.Add(entry)
			else
				completed_mandates.Add(entry)
		nanoui_data["available_mandates"] = available_mandates
		nanoui_data["completed_mandates"] = completed_mandates

/obj/machinery/complant_teleporter/proc/complete_order(order_path, amount)
	use_power(active_power_usage * 3)
	new order_path(loc, amount)
	processing_order = FALSE

/obj/machinery/complant_teleporter/attackby(obj/item/I, mob/user)
	for(var/datum/antag_contract/excel/appropriate/M in GLOB.excel_antag_contracts)
		if(M.completed)
			continue
		if(M.target_type == I.type)
			I.Destroy()
			M.complete(user)
			flick("teleporting", src)
	..()

/obj/machinery/complant_teleporter/attack_hand(mob/user)
	if(stat & BROKEN)
		return
	current_user = user
	ui_interact(user)

/obj/machinery/complant_teleporter/affect_grab(var/mob/user, var/mob/target)
	try_put_inside(target, user)
	return TRUE

/obj/machinery/complant_teleporter/MouseDrop_T(var/mob/living/L, mob/living/user)
	if(istype(L) && istype(user))
		try_put_inside(L, user)

/obj/machinery/complant_teleporter/proc/try_put_inside(var/mob/living/affecting, var/mob/living/user) //Based on crypods

	if(!ismob(affecting) || !Adjacent(affecting) || !Adjacent(user))
		return

	visible_message("[user] starts stuffing [affecting] into \the [src].")
	src.add_fingerprint(user)

	if(!do_after(user, 20, src))
		return
	if(!user || !Adjacent(user))
		return
	if(!affecting || !Adjacent(affecting) )
		return
	if (affecting.stat == DEAD)
		to_chat(user, SPAN_WARNING("[affecting] is dead, and can't be teleported"))
		return

	for(var/datum/antag_contract/excel/targeted/M in GLOB.excel_antag_contracts) // All targeted objectives can be completed by stuffing the target in the teleporter
		if(M.completed)
			continue
		if(affecting == M.target_mind.current)
			M.complete(user)
			flick("teleporting", src)
			to_chat(affecting, SPAN_NOTICE("You have been teleported to haven, your crew respawn time is reduced by 15 minutes."))
			visible_message("\the [src] teleporter closes and [affecting] disapears.")
			affecting.set_respawn_bonus("TELEPORTED_TO_EXCEL", 15 MINUTES)
			affecting << 'sound/effects/magic/blind.ogg'  //Play this sound to a player whenever their respawn time gets reduced
			qdel(affecting)
			return
	
	visible_message("\the [src] blinks, refusing [affecting].")
	playsound(src.loc, 'sound/machines/ping.ogg', 50, 1 -3)
