
/obj/machinery/complant_teleporter
	name = "excelsior long-range teleporter"
	desc = "A powerful teleporter that allows shipping matter in and out. Takes a long time to charge."
	description_info = "A highly illegal teleporter. Uses huge amounts of power and will always show in the powergrid monitor"
	description_antag = "The excelcior's main way of obtaining resources, calling reinforcements and unleashing the revolution"
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/machines/excelsior/teleporter.dmi'
	icon_state = "idle"
	use_power = IDLE_POWER_USE
	idle_power_usage = 40
	active_power_usage = 15000
	circuit = /obj/item/electronics/circuitboard/excelsior_teleporter
	shipside_only = TRUE

	var/max_energy = 100
	var/energy_gain = 1
	var/processing_order = FALSE
	var/nanoui_menu = 0 	// Based on Uplink
	var/mob/current_user
	var/time_until_scan
	var/old_energy			//energy difference aka energy gain (used for debug but I guess some might like it)

	var/reinforcements_delay = 5 MINUTES
	var/reinforcements_cost = 2000

	var/list/nanoui_data = list()			// Additional data for NanoUI use

	/* WARNING, READ IF YOU REALLY WANNA KNOW HOW I COUNTED PRICES
		> OR SKIP UNTIL COMMENTS END
	******************************************************************************************
	# Wall street economics here before we begin with the list:
		1 node produces 1 energy per tick(which is 2 sec) ONLY IF all 169 influence tiles are activated
			- 30 energy/minute PER node



	# All prices came with the following principles established:
		1. Excelsior wins after 2 hours with TOUGH FIGHT, they'll own 50%~ of the ship tiles in that time
		2. Excelsior received 1 node per EX_NODE_SPAWN_COOLDOWN [3 mins as of now]
		3. Expected early game 						is 1 node
		4. Expected "normal game begins" prices 	is 5 nodes
		5. Expected "say your GGs" 					is 20 nodes



	# 1 resource = x energy

		wood per 1 = 0.16
		glass per 1 = 0.16
		plastic per 1 = 0.16
		steel per 1 = 0.33
		silver per 1 = 5
		plasteel per 1 = 5
		gold per 1 = 5
		diamond per 1 = 5
		uranium per 1 = 10
		---
		biomatter 1 = 1

		cardboard 1 = 1
	******************************************************************************************/

	// Wait for the second update, prices are somewhat low with intent, unabusable and calculated unless you tell me something I didn't account for.
	var/list/materials_list = list(
		MATERIAL_WOOD = list("amount" = 30, "price" = 5),
		MATERIAL_GLASS = list("amount" = 30, "price" = 5),
		MATERIAL_PLASTIC = list("amount" = 30, "price" = 5),
		MATERIAL_STEEL = list("amount" = 30, "price" = 10),
		/obj/item/stack/cable_coil/orange = list("amount" = 30, "price" = 30),
		MATERIAL_BIOMATTER = list("amount" = 30, "price" = 30),
		MATERIAL_CARDBOARD = list("amount" = 30, "price" = 30),
		MATERIAL_PLASTEEL = list("amount" = 30, "price" = 150),
		MATERIAL_SILVER = list("amount" = 30, "price" = 150),
		MATERIAL_GOLD = list("amount" = 30, "price" = 150),
		MATERIAL_DIAMOND = list("amount" = 30, "price" = 150),	// NOTE: no artificial scarcity means industrial diamonds
		MATERIAL_URANIUM = list("amount" = 30, "price" = 300),
		)

	var/list/parts_list = list(
		// # Computer parts
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/computer_hardware/processor_unit/adv = 25,		// exists only for redirector here consider removing
		/obj/item/computer_hardware/hard_drive/advanced = 25,		// exists only for redirector here consider removing
		/obj/item/stock_parts/capacitor/excelsior = 25,				//
		/obj/item/stock_parts/scanning_module/excelsior = 25,		//
		/obj/item/stock_parts/manipulator/excelsior = 25,			//
		/obj/item/stock_parts/micro_laser/excelsior = 25,			//
		/obj/item/stock_parts/matter_bin/excelsior = 25,			//
		)
	var/list/circuits = list(
		/obj/item/electronics/circuitboard/excelsior_teleporter = 10,			//
		/obj/item/electronics/circuitboard/excelsiorautolathe = 10,				//
		/obj/item/electronics/circuitboard/excelsior_boombox = 10,				//
		/obj/item/electronics/circuitboard/diesel = 10,							//
		/obj/item/electronics/circuitboard/excelsiorreconstructor = 25,			//
		/obj/item/electronics/circuitboard/excelsiorshieldwallgen = 25,			//
		/obj/item/electronics/circuitboard/excelsior_autodoc = 25,				//
		/obj/item/electronics/circuitboard/excelsior_turret = 50,				//
		/obj/item/electronics/circuitboard/excelsior_navigation_cracker = 2000,	//
		)
	var/list/excelsior_kits = list(
		/*		[?]"Factual" means how many energy we woulda spent for 1 material instead of 30. 1:1 cost in other words. [line 48]
						> We set prices bigger than factual otherwise goodbye economy
		*/
		/obj/item/clothing/glasses/hud/excelsior = 1,			// factual <1 I am not going below 1 anywhere anyhow
		/obj/item/clothing/under/excelsior = 15,				// TODO: recycle is 15 biomatter ughh FUCK check this later cuz we dont know if excels ""can have"" biomatter at all so its 1:1 now)
		/obj/item/storage/deferred/crate/excel_conscript = 150,	// factual 122 with prices at the moment
		/obj/item/storage/deferred/crate/excel_shock_kit = 175,	// factual 144 with prices atm
		/obj/item/storage/deferred/crate/excel_spetsnaz = 200,	// factual 181 with prices atm
		/obj/item/storage/deferred/crate/excel_eva = 250,		// factual 237 with prices atm
		/obj/item/storage/deferred/crate/excel_heavy = 525,		// factual 509 with prices atm
		)
	//all IKEAs are better than manual building so multiply 2
	var/list/IKEA_list = list(
		/obj/item/machinery_crate/excelsior/shield = 125,			// factual 62
		/obj/item/machinery_crate/excelsior/autolathe = 40,			// factual 17
		/obj/item/machinery_crate/excelsior/boombox = 40,			// factual 16
		/obj/item/machinery_crate/excelsior/diesel_generator = 40, 	// factual 17
		/obj/item/machinery_crate/excelsior/turret = 600			// factual 271 oof-
	)
	var/entropy_value = 8

/obj/machinery/complant_teleporter/Initialize()
	excelsior_teleporters |= src
	.=..()

/obj/machinery/complant_teleporter/Destroy()
	excelsior_teleporters -= src
	RefreshParts() // To avoid energy overfills if a teleporter gets destroyed
	.=..()

/obj/machinery/complant_teleporter/RefreshParts()
	if(!LAZYLEN(component_parts))
		error("[src] \ref[src] had no parts on refresh")
		return //this has runtimed before
	var/man_rating = 0
	var/man_amount = 0
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		man_rating += M.rating
		entropy_value = initial(entropy_value)/M.rating
		man_amount++

	// +50% speed for each upgrade tier
	var/installed_parts_coefficient = 1 + (((man_rating / man_amount) - 1) / 2)

	energy_gain = initial(energy_gain) * installed_parts_coefficient
	active_power_usage = initial(active_power_usage) * installed_parts_coefficient

	var/obj/item/cell/C = locate() in component_parts
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
		//excelsior_energy += energy_gain moved to centor.dm
		SSnano.update_uis(src)
		set_power_use(ACTIVE_POWER_USE)
	else
		//excelsior_energy = excelsior_max_energy
		set_power_use(IDLE_POWER_USE)

 /*
  * The nano_ui_interact proc is used to open and update Nano UIs
  * If nano_ui_interact is not used then the UI will not update correctly
  * nano_ui_interact is currently defined for /atom/movable
  *
  * @param user /mob The mob who is interacting with this ui
  * @param ui_key string A string key to use for this ui. Allows for multiple unique uis on one obj/mob (defaut value "main")
  *
  * @return nothing
  */
/obj/machinery/complant_teleporter/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	if(user.stat || user.restrained() || stat & (BROKEN|NOPOWER))
		return

	var/list/data = nano_ui_data()

	time_until_scan = time2text((30 MINUTES - ((world.time - round_start_time) % (30 MINUTES))), "mm:ss")

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "excelsior_teleporter.tmpl", name, 390, 450)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/complant_teleporter/nano_ui_data()
	var/list/data = list()
	data["energy"] = round(excelsior_energy, 0.01)
	data["maxEnergy"] = round(excelsior_max_energy)
	data["menu"] = nanoui_menu
	data["excel_user"] = is_excelsior(current_user)
	data["time_until_scan"] = time_until_scan
	data["old_energy"] = round(old_energy, 0.01)
	data["conscripts"] = excelsior_conscripts
	data["reinforcements_ready"] = reinforcements_check()
	data += nanoui_data

	var/list/order_list_m = list()
	for(var/item in materials_list)
		order_list_m += list(
			list(
				"title" = material_display_name(item),
				"amount" = materials_list[item]["amount"],
				"price" = materials_list[item]["price"],
				"commands" = list("order" = item)
				)
			) // list in a list because Byond merges the first list...

	data["materials_list"] = order_list_m



	var/list/order_list_p = list()
	for(var/item in parts_list)
		var/obj/item/I = item
		order_list_p += list(
			list(
				"name_p" = initial(I.name),
				"price_p" = parts_list[item],
				"commands_p" = list("order_p" = item)
			)
		)

	data["list_of_parts"] = order_list_p



	var/list/order_list_c = list()
	for(var/item in circuits)
		var/obj/item/I = item
		order_list_c += list(
			list(
				"name_c" = initial(I.name),
				"price_c" = circuits[item],
				"commands_c" = list("order_c" = item)
			)
		)
	data["circuits"] = order_list_c



	var/list/order_list_e = list()
	for(var/item in excelsior_kits)
		var/obj/item/I = item
		order_list_e += list(
			list(
				"name_e" = initial(I.name),
				"price_e" = excelsior_kits[item],
				"commands_e" = list("order_e" = item)
			)
		)
	data["excelsior_kits"] = order_list_e



	var/list/order_list_i = list()
	for(var/obj/item/machinery_crate/I as anything in IKEA_list)
		order_list_i += list(list(
			"name_i" = initial(I.name),
			"price_i" = IKEA_list[I],
			"commands_i" = list("order_i" = I)
			)
		)

	data["list_of_IKEA"] = order_list_i

	return data


/obj/machinery/complant_teleporter/Topic(href, href_list)
	if(stat & (NOPOWER|BROKEN))
		return TOPIC_NOACTION // don't update UIs attached to this object

	if(processing_order)
		return TOPIC_NOACTION

	if(href_list["order"])
		var/ordered_item = href_list["order"]
		if (materials_list.Find(ordered_item))
			var/order_energy_cost = materials_list[ordered_item]["price"]
			var/order_path = material_stack_type(ordered_item)
			var/order_amount = materials_list[ordered_item]["amount"]
			send_order(order_path, order_energy_cost, order_amount, usr)



	if(href_list["order_p"])
		var/ordered_item = text2path(href_list["order_p"])
		if (parts_list.Find(ordered_item))
			var/order_energy_cost = parts_list[ordered_item]
			send_order(ordered_item, order_energy_cost, 1, usr)



	if(href_list["order_c"])
		var/ordered_item = text2path(href_list["order_c"])
		if (circuits.Find(ordered_item))
			var/order_energy_cost = circuits[ordered_item]
			send_order(ordered_item, order_energy_cost, 1, usr)




	if(href_list["order_e"])
		var/ordered_item = text2path(href_list["order_e"])
		if (excelsior_kits.Find(ordered_item))
			var/order_energy_cost = excelsior_kits[ordered_item]
			send_order(ordered_item, order_energy_cost, 1, usr)



	if(href_list["order_i"])
		var/ordered_item = text2path(href_list["order_i"])
		if (IKEA_list.Find(ordered_item))
			var/order_energy_cost = IKEA_list[ordered_item]
			send_order(ordered_item, order_energy_cost, 1, usr)

	if(href_list["open_menu"])
		nanoui_menu = 1

	if(href_list["close_menu"])
		nanoui_menu = 0

	if(href_list["request_reinforcements"])
		request_reinforcements(usr)

	add_fingerprint(usr)
	update_nano_data()
	return TOPIC_HANDLED // update UIs attached to this object


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

/obj/machinery/complant_teleporter/proc/send_order(order_path, order_cost, amount, mob/user)
	if(order_cost > excelsior_energy)
		to_chat(usr, SPAN_WARNING("Not enough energy."))
		return

	processing_order = TRUE
	excelsior_energy = max(excelsior_energy - order_cost, 0)
	flick("teleporting", src)
	spawn(17)
		complete_order(order_path, amount, user)

/obj/machinery/complant_teleporter/proc/complete_order(order_path, amount, mob/user)
	use_power(active_power_usage * 3)
	var/obj/item/item = new order_path(loc, amount)
	if(!user.put_in_hands(item))
		item.forceMove(get_turf(src))
	bluespace_entropy(entropy_value, get_turf(src))
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
	nano_ui_interact(user)

/obj/machinery/complant_teleporter/affect_grab(mob/user, mob/target)
	try_put_inside(target, user)
	return TRUE

/obj/machinery/complant_teleporter/MouseDrop_T(mob/living/L, mob/living/user)
	if(istype(L) && istype(user))
		try_put_inside(L, user)

/obj/machinery/complant_teleporter/proc/try_put_inside(mob/living/affecting, mob/living/user) //Based on crypods
	if(!ismob(affecting) || !Adjacent(affecting) || !Adjacent(user))
		return

	visible_message(SPAN_DANGER("[user] starts stuffing [affecting] into \the [src]."))
	add_fingerprint(user)

	if(!do_after(user, 20, src))
		return
	if(!user || !Adjacent(user))
		return
	if(!affecting || !Adjacent(affecting))
		return
	if(affecting.stat == DEAD)
		to_chat(user, SPAN_WARNING("[affecting] is dead, and can't be teleported"))
		return
	for(var/datum/antag_contract/excel/targeted/M in GLOB.excel_antag_contracts) // All targeted objectives can be completed by stuffing the target in the teleporter
		if(M.completed)
			continue
		if(affecting == M.target_mind.current)
			M.complete(user)
			teleport_out(affecting, user)
			excelsior_conscripts++
			return
	if(is_excelsior(affecting))
		teleport_out(affecting, user)
		excelsior_conscripts++
		return

	visible_message("\The [src] blinks, refusing [affecting].")
	playsound(src.loc, 'sound/machines/ping.ogg', 50, 1, -3)

/obj/machinery/complant_teleporter/proc/teleport_out(mob/living/affecting, mob/living/user)
	flick("teleporting", src)
	to_chat(affecting, SPAN_NOTICE("You have been teleported to haven, your crew respawn time is reduced by [(COLLECTIVISED_RESPAWN_BONUS)/600] minutes."))
	visible_message("\The [src] teleporter closes and [affecting] disapears.")
	affecting.set_respawn_bonus("TELEPORTED_TO_EXCEL", COLLECTIVISED_RESPAWN_BONUS)
	affecting << 'sound/effects/magic/blind.ogg'  //Play this sound to a player whenever their respawn time gets reduced
	qdel(affecting)

/obj/machinery/complant_teleporter/proc/request_reinforcements(mob/living/user)
	if(excelsior_energy < reinforcements_cost)
		to_chat(user, SPAN_WARNING("Not enough energy."))
		return
	if(world.time < (excelsior_last_draft + reinforcements_delay))
		to_chat(user, SPAN_WARNING("You can call only one conscript for [reinforcements_delay / 600] minutes."))
		return
	if(excelsior_conscripts <= 0)
		to_chat(user, SPAN_WARNING("They have nobody to send to you."))
		return
	processing_order = TRUE
	use_power(active_power_usage * 10)
	flick("teleporting", src)
	var/mob/observer/ghost/candidate = draft_ghost("Excelsior Conscript", ROLE_BANTYPE_EXCELSIOR, ROLE_EXCELSIOR_REV)
	if(!candidate)
		processing_order = FALSE
		to_chat(user, SPAN_WARNING("Reinforcements were postponed"))
		return

	processing_order = FALSE
	excelsior_last_draft = world.time
	excelsior_energy = excelsior_energy - reinforcements_cost
	excelsior_conscripts--

	var/mob/living/carbon/human/conscript = new /mob/living/carbon/human(loc)
	conscript.ckey = candidate.ckey
	make_antagonist(conscript.mind, ROLE_EXCELSIOR_REV)
	conscript.stats.setStat(STAT_TGH, 30)
	conscript.stats.setStat(STAT_VIG, 30)
	conscript.stats.setStat(STAT_ROB, 30)
	conscript.stats.setStat(STAT_MEC, 10)
	conscript.stats.setStat(STAT_BIO, 10)
	conscript.randomize_appearance()
	conscript.equip_to_appropriate_slot(new /obj/item/clothing/under/excelsior())
	conscript.equip_to_appropriate_slot(new /obj/item/clothing/shoes/workboots())
	conscript.equip_to_appropriate_slot(new /obj/item/device/radio/headset())
	conscript.equip_to_appropriate_slot(new /obj/item/storage/backpack/satchel())
	conscript.equip_to_appropriate_slot(new /obj/item/melee/baton/excelbaton())
	var/obj/item/card/id/card = new(conscript)
	conscript.set_id_info(card)
	card.assignment = "Excelsior Conscript"
	card.access = list(access_maint_tunnels)
	card.update_name()
	conscript.equip_to_appropriate_slot(card)
	conscript.update_inv_wear_id()

/obj/machinery/complant_teleporter/proc/reinforcements_check()
	if(excelsior_conscripts <= 0)
		return FALSE
	if(world.time < (excelsior_last_draft + reinforcements_delay))
		return FALSE
	if(excelsior_conscripts <= 0)
		return FALSE
	if(excelsior_energy < reinforcements_cost)
		return FALSE
	return TRUE
