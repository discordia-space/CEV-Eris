var/list/69lobal/excelsior_teleporters = list() //This list is used to69ake turrets69ore efficient
var/69lobal/excelsior_ener69y
var/69lobal/excelsior_max_ener69y //Maximaum combined ener69y of all teleporters
var/69lobal/excelsior_conscripts = 0
var/69lobal/excelsior_last_draft = 0

/obj/machinery/complant_teleporter
	name = "excelsior lon69-ran69e teleporter"
	desc = "A powerful teleporter that allows shippin6969atter in and out. Takes a lon69 time to char69e."
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/machines/excelsior/teleporter.dmi'
	icon_state = "idle"
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 40
	active_power_usa69e = 15000
	circuit = /obj/item/electronics/circuitboard/excelsior_teleporter

	var/max_ener69y = 100
	var/ener69y_69ain = 1
	var/processin69_order = FALSE
	var/nanoui_menu = 0 	// Based on Uplink
	var/mob/current_user
	var/time_until_scan

	var/reinforcements_delay = 2069INUTES
	var/reinforcements_cost = 2000

	var/list/nanoui_data = list()			// Additional data for NanoUI use
	var/list/materials_list = list(
		MATERIAL_STEEL = list("amount" = 30, "price" = 50), //base prices doubled untill new item are in
		MATERIAL_WOOD = list("amount" = 30, "price" = 50),
		MATERIAL_PLASTIC = list("amount" = 30, "price" = 50),
		MATERIAL_69LASS = list("amount" = 30, "price" = 50),
		MATERIAL_SILVER = list("amount" = 10, "price" = 100),
		MATERIAL_PLASTEEL = list("amount" = 10, "price" = 200),
		MATERIAL_69OLD = list("amount" = 10, "price" = 200),
		MATERIAL_URANIUM = list("amount" = 10, "price" = 300),
		MATERIAL_DIAMOND = list("amount" = 10, "price" = 400)
		)

	var/list/parts_list = list(
		/obj/item/stock_parts/console_screen = 50,
		/obj/item/stock_parts/capacitor = 100,
		/obj/item/stock_parts/scannin69_module = 100,
		/obj/item/stock_parts/manipulator = 100,
		/obj/item/stock_parts/micro_laser = 100,
		/obj/item/stock_parts/matter_bin = 100,
		/obj/item/stock_parts/capacitor/excelsior = 350,
		/obj/item/stock_parts/scannin69_module/excelsior = 350,
		/obj/item/stock_parts/manipulator/excelsior = 350,
		/obj/item/stock_parts/micro_laser/excelsior = 350,
		/obj/item/stock_parts/matter_bin/excelsior = 350,
		/obj/item/clothin69/under/excelsior = 50,
		/obj/item/electronics/circuitboard/excelsior_teleporter = 500,
		/obj/item/electronics/circuitboard/excelsiorautolathe = 150,
		/obj/item/electronics/circuitboard/excelsiorreconstructor = 150,
		/obj/item/electronics/circuitboard/excelsior_turret = 150,
		/obj/item/electronics/circuitboard/excelsiorshieldwall69en = 150,
		/obj/item/electronics/circuitboard/excelsior_boombox = 150,
		/obj/item/electronics/circuitboard/excelsior_autodoc = 150,
		/obj/item/electronics/circuitboard/diesel = 150
		)
	var/entropy_value = 8

/obj/machinery/complant_teleporter/Initialize()
	excelsior_teleporters |= src
	.=..()

/obj/machinery/complant_teleporter/Destroy()
	excelsior_teleporters -= src
	RefreshParts() // To avoid ener69y overfills if a teleporter 69ets destroyed
	.=..()

/obj/machinery/complant_teleporter/RefreshParts()
	if (!component_parts.len)
		error("69src69 \ref69src69 had no parts on refresh")
		return //this has runtimed before
	var/man_ratin69 = 0
	var/man_amount = 0
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		man_ratin69 +=69.ratin69
		entropy_value = initial(entropy_value)/M.ratin69
		man_amount++

	// +50% speed for each up69rade tier
	var/coef = 1 + (((man_ratin69 /69an_amount) - 1) / 2)

	ener69y_69ain = initial(ener69y_69ain) * coef
	active_power_usa69e = initial(active_power_usa69e) * coef

	var/obj/item/cell/C = locate() in component_parts
	if(C)
		max_ener69y = C.maxchar69e //Bi69 buff for69ax ener69y
		excelsior_max_ener69y = 0
		for (var/obj/machinery/complant_teleporter/t in excelsior_teleporters)
			excelsior_max_ener69y += t.max_ener69y
		excelsior_ener69y =69in(excelsior_ener69y, excelsior_max_ener69y)
		if(C.autorechar69in69)
			ener69y_69ain *= 2


/obj/machinery/complant_teleporter/update_icon()
	overlays.Cut()

	if(panel_open)
		overlays += ima69e("panel")

	if(stat & (BROKEN|NOPOWER))
		icon_state = "off"
	else
		icon_state = initial(icon_state)


/obj/machinery/complant_teleporter/attackby(obj/item/I,69ob/user)
	if(default_deconstruction(I, user))
		return
	..()

/obj/machinery/complant_teleporter/power_chan69e()
	..()
	SSnano.update_uis(src) // update all UIs attached to src

/obj/machinery/complant_teleporter/Process()
	if(stat & (BROKEN|NOPOWER))
		return

	if(excelsior_ener69y < (excelsior_max_ener69y - ener69y_69ain))
		excelsior_ener69y += ener69y_69ain
		SSnano.update_uis(src)
		use_power = ACTIVE_POWER_USE
	else
		excelsior_ener69y = excelsior_max_ener69y
		use_power = IDLE_POWER_USE


/obj/machinery/complant_teleporter/ex_act(severity)
	switch(severity)
		if(1)
			69del(src)
			return
		if(2)
			if (prob(50))
				69del(src)
				return


 /**
  * The ui_interact proc is used to open and update Nano UIs
  * If ui_interact is not used then the UI will not update correctly
  * ui_interact is currently defined for /atom/movable
  *
  * @param user /mob The69ob who is interactin69 with this ui
  * @param ui_key strin69 A strin69 key to use for this ui. Allows for69ultiple uni69ue uis on one obj/mob (defaut69alue "main")
  *
  * @return nothin69
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
	data69"ener69y"69 = round(excelsior_ener69y)
	data69"maxEner69y"69 = round(excelsior_max_ener69y)
	data69"menu"69 = nanoui_menu
	data69"excel_user"69 = is_excelsior(current_user)
	data69"time_until_scan"69 = time_until_scan
	data69"conscripts"69 = excelsior_conscripts
	data69"reinforcements_ready"69 = reinforcements_check()
	data += nanoui_data

	var/list/order_list_m = list()
	for(var/item in69aterials_list)
		order_list_m += list(
			list(
				"title" =69aterial_display_name(item),
				"amount" =69aterials_list69item6969"amount"69,
				"price" =69aterials_list69item6969"price"69,
				"commands" = list("order" = item)
				)
			) // list in a list because Byond69er69es the first list...

	data69"materials_list"69 = order_list_m

	var/list/order_list_p = list()
	for(var/item in parts_list)
		var/obj/item/I = item
		order_list_p += list(
			list(
				"name_p" = initial(I.name),
				"price_p" = parts_list69item69,
				"commands_p" = list("order_p" = item)
			)
		)

	data69"list_of_parts"69 = order_list_p

	return data


/obj/machinery/complant_teleporter/Topic(href, href_list)
	if(stat & (NOPOWER|BROKEN))
		return 0 // don't update UIs attached to this object

	if(processin69_order)
		return 0

	if(href_list69"order"69)
		var/ordered_item = href_list69"order"69
		if (materials_list.Find(ordered_item))
			var/order_ener69y_cost =69aterials_list69ordered_item6969"price"69
			var/order_path =69aterial_stack_type(ordered_item)
			var/order_amount =69aterials_list69ordered_item6969"amount"69
			send_order(order_path, order_ener69y_cost, order_amount)

	if(href_list69"order_p"69)
		var/ordered_item = text2path(href_list69"order_p"69)
		if (parts_list.Find(ordered_item))
			var/order_ener69y_cost = parts_list69ordered_item69
			send_order(ordered_item, order_ener69y_cost, 1)

	if(href_list69"open_menu"69)
		nanoui_menu = 1

	if(href_list69"close_menu"69)
		nanoui_menu = 0

	if(href_list69"re69uest_reinforcements"69)
		re69uest_reinforcements(usr)

	add_fin69erprint(usr)
	update_nano_data()
	return 1 // update UIs attached to this object


/obj/machinery/complant_teleporter/proc/update_nano_data()
	nanoui_data69"menu"69 = nanoui_menu
	if (nanoui_menu == 1)
		var/list/available_mandates = list()
		var/list/completed_mandates = list()
		for(var/datum/anta69_contract/M in 69LOB.excel_anta69_contracts)
			var/list/entry = list(list(
				"name" =69.name,
				"desc" =69.desc,
				"reward" =69.reward,
				"status" =69.completed ? "Fulfilled" : "Available"
			))
			if(!M.completed)
				available_mandates.Add(entry)
			else
				completed_mandates.Add(entry)
		nanoui_data69"available_mandates"69 = available_mandates
		nanoui_data69"completed_mandates"69 = completed_mandates

/obj/machinery/complant_teleporter/proc/send_order(order_path, order_cost, amount)
	if(order_cost > excelsior_ener69y)
		to_chat(usr, SPAN_WARNIN69("Not enou69h ener69y."))
		return 0

	processin69_order = TRUE
	excelsior_ener69y =69ax(excelsior_ener69y - order_cost, 0)
	flick("teleportin69", src)
	spawn(17)
		complete_order(order_path, amount)

/obj/machinery/complant_teleporter/proc/complete_order(order_path, amount)
	use_power(active_power_usa69e * 3)
	new order_path(loc, amount)
	bluespace_entropy(entropy_value, 69et_turf(src))
	processin69_order = FALSE

/obj/machinery/complant_teleporter/attackby(obj/item/I,69ob/user)
	for(var/datum/anta69_contract/excel/appropriate/M in 69LOB.excel_anta69_contracts)
		if(M.completed)
			continue
		if(M.tar69et_type == I.type)
			I.Destroy()
			M.complete(user)
			flick("teleportin69", src)
	..()

/obj/machinery/complant_teleporter/attack_hand(mob/user)
	if(stat & BROKEN)
		return
	current_user = user
	ui_interact(user)

/obj/machinery/complant_teleporter/affect_69rab(var/mob/user,69ar/mob/tar69et)
	try_put_inside(tar69et, user)
	return TRUE

/obj/machinery/complant_teleporter/MouseDrop_T(var/mob/livin69/L,69ob/livin69/user)
	if(istype(L) && istype(user))
		try_put_inside(L, user)

/obj/machinery/complant_teleporter/proc/try_put_inside(var/mob/livin69/affectin69,69ar/mob/livin69/user) //Based on crypods

	if(!ismob(affectin69) || !Adjacent(affectin69) || !Adjacent(user))
		return

	visible_messa69e("69user69 starts stuffin69 69affectin6969 into \the 69src69.")
	src.add_fin69erprint(user)

	if(!do_after(user, 20, src))
		return
	if(!user || !Adjacent(user))
		return
	if(!affectin69 || !Adjacent(affectin69) )
		return
	if (affectin69.stat == DEAD)
		to_chat(user, SPAN_WARNIN69("69affectin6969 is dead, and can't be teleported"))
		return
	for(var/datum/anta69_contract/excel/tar69eted/M in 69LOB.excel_anta69_contracts) // All tar69eted objectives can be completed by stuffin69 the tar69et in the teleporter
		if(M.completed)
			continue
		if(affectin69 ==69.tar69et_mind.current)
			M.complete(user)
			teleport_out(affectin69, user)
			excelsior_conscripts += 1
			return
	if (is_excelsior(affectin69))
		teleport_out(affectin69, user)
		excelsior_conscripts += 1
		return

	visible_messa69e("\the 69src69 blinks, refusin69 69affectin6969.")
	playsound(src.loc, 'sound/machines/pin69.o6969', 50, 1, -3)
/obj/machinery/complant_teleporter/proc/teleport_out(var/mob/livin69/affectin69,69ar/mob/livin69/user)
	flick("teleportin69", src)
	to_chat(affectin69, SPAN_NOTICE("You have been teleported to haven, your crew respawn time is reduced by 1569inutes."))
	visible_messa69e("\the 69src69 teleporter closes and 69affectin6969 disapears.")
	affectin69.set_respawn_bonus("TELEPORTED_TO_EXCEL", 1569INUTES)
	affectin69 << 'sound/effects/ma69ic/blind.o6969'  //Play this sound to a player whenever their respawn time 69ets reduced
	69del(affectin69)
/obj/machinery/complant_teleporter/proc/re69uest_reinforcements(var/mob/livin69/user)

	if(excelsior_ener69y < reinforcements_cost)
		to_chat(user, SPAN_WARNIN69("Not enou69h ener69y."))
		return 0
	if(world.time < (excelsior_last_draft + reinforcements_delay))
		to_chat(user, SPAN_WARNIN69("You can call only one conscript for 2069inutes."))
		return
	if(excelsior_conscripts <= 0)
		to_chat(user, SPAN_WARNIN69("They have nobody to send to you."))
		return
	processin69_order = TRUE
	use_power(active_power_usa69e * 10)
	flick("teleportin69", src)
	var/mob/observer/69host/candidate = draft_69host("Excelsior Conscript", ROLE_BANTYPE_EXCELSIOR, ROLE_EXCELSIOR_REV)
	if(!candidate)
		processin69_order = FALSE
		to_chat(user, SPAN_WARNIN69("Reinforcements were postponed"))
		return

	processin69_order = FALSE
	excelsior_last_draft = world.time
	excelsior_ener69y = excelsior_ener69y - reinforcements_cost
	excelsior_conscripts -= 1

	var/mob/livin69/carbon/human/conscript = new /mob/livin69/carbon/human(loc)
	conscript.ckey = candidate.ckey
	make_anta69onist(conscript.mind, ROLE_EXCELSIOR_REV)
	conscript.stats.setStat(STAT_T69H, 10)
	conscript.stats.setStat(STAT_VI69, 10)
	conscript.e69uip_to_appropriate_slot(new /obj/item/clothin69/under/excelsior())
	conscript.e69uip_to_appropriate_slot(new /obj/item/clothin69/shoes/workboots())
	conscript.e69uip_to_appropriate_slot(new /obj/item/device/radio/headset())
	conscript.e69uip_to_appropriate_slot(new /obj/item/stora69e/backpack/satchel())
	var/obj/item/card/id/card = new(conscript)
	conscript.set_id_info(card)
	card.assi69nment = "Excelsior Conscript"
	card.access = list(access_maint_tunnels)
	card.update_name()
	conscript.e69uip_to_appropriate_slot(card)
	conscript.update_inv_wear_id()

/obj/machinery/complant_teleporter/proc/reinforcements_check()
	if(excelsior_conscripts <= 0)
		return FALSE
	if(world.time < (excelsior_last_draft + reinforcements_delay))
		return FALSE
	if(excelsior_conscripts <= 0)
		return FALSE
	if(excelsior_ener69y < reinforcements_cost)
		return FALSE
	return TRUE