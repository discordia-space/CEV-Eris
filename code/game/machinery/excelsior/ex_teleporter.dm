var/list/global/excelsior_teleporters = list() //This list is used to make turrets more efficient

/obj/machinery/complant_teleporter
	name = "excelsior long-range teleporter"
	desc = "a powerful one way teleporter that allows shipping in construction materials. Takes a long time to charge"
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/machines/excelsior/teleporter.dmi'
	icon_state = "idle"
	use_power = 1
	idle_power_usage = 40
	active_power_usage = 15000
	circuit = /obj/item/weapon/circuitboard/excelsior_teleporter

	var/energy = 0
	var/max_energy = 100
	var/recharged = 20 // counts to 0, regenerates energy a bit and resets to initial value.
	var/processing_order = FALSE

	var/list/buy_list = list(
		MATERIAL_STEEL = list("amount" = 30, "price" = 10),
		MATERIAL_WOOD = list("amount" = 30, "price" = 10),
		MATERIAL_PLASTIC = list("amount" = 30, "price" = 10),
		MATERIAL_GLASS = list("amount" = 30, "price" = 10),
		MATERIAL_PLASTEEL = list("amount" = 10, "price" = 30),
		MATERIAL_URANIUM = list("amount" = 10, "price" = 40),
		MATERIAL_DIAMOND = list("amount" = 10, "price" = 50),
		MATERIAL_SILVER = list("amount" = 15, "price" = 30),
		MATERIAL_GOLD = list("amount" = 10, "price" = 30),
		)

/obj/machinery/complant_teleporter/Initialize()
	excelsior_teleporters |= src
	.=..()

/obj/machinery/complant_teleporter/Destroy()
	excelsior_teleporters -= src
	.=..()

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

	use_power = (energy < max_energy) ? 2 : 1

	recharged--
	if(!recharged)
		recharged = initial(recharged)
		var/addenergy = 1
		var/oldenergy = energy
		energy = min(energy + addenergy, max_energy)
		if(energy != oldenergy)
			SSnano.update_uis(src)

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
/obj/machinery/complant_teleporter/ui_interact(mob/user, ui_key = "main",var/datum/nanoui/ui = null, var/force_open = NANOUI_FOCUS)
	if(stat & (BROKEN|NOPOWER)) return
	if(user.stat || user.restrained()) return

	// this is the data which will be sent to the ui
	var/data[0]
	//data["amount"] = amount
	data["energy"] = round(energy)
	data["maxEnergy"] = round(max_energy)

	var/order_list[0]
	for (var/item in buy_list)
		order_list += list(
			list(
				"title" = material_display_name(item),
				"amount" = buy_list[item]["amount"],
				"price" = buy_list[item]["price"],
				"commands" = list("order" = item)
				)
			) // list in a list because Byond merges the first list...

	data["buy_list"] = order_list

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "excelsior_teleporter.tmpl", name, 390, 450)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/complant_teleporter/Topic(href, href_list)
	if(stat & (NOPOWER|BROKEN))
		return 0 // don't update UIs attached to this object

	if(processing_order)
		return 0

	if(href_list["order"])
		var/ordered_item = href_list["order"]
		if (buy_list.Find(ordered_item))
			var/order_energy_cost = buy_list[ordered_item]["price"]
			if(order_energy_cost > energy)
				to_chat(usr, SPAN_WARNING("Not enough energy."))
				return 0

			processing_order = TRUE
			energy = max(energy - order_energy_cost, 0)

			var/order_path = material_stack_type(ordered_item)
			var/order_amount = buy_list[ordered_item]["amount"]

			flick("teleporting", src)
			spawn(17)
				complete_order(order_path, order_amount)

	add_fingerprint(usr)
	return 1 // update UIs attached to this object

/obj/machinery/complant_teleporter/proc/complete_order(order_path, amount)
	use_power(active_power_usage * 3)
	new order_path(loc, amount)
	processing_order = FALSE

/obj/machinery/complant_teleporter/attack_ai(mob/user)
	return src.attack_hand(user)

/obj/machinery/complant_teleporter/attack_hand(mob/user)
	if(stat & BROKEN)
		return
	ui_interact(user)
