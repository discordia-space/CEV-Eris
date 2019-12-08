#define REAGENTS_PER_SHEET 20

/obj/machinery/reagentgrinder
	name = "All-In-One Grinder"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "juicer1"
	layer = BELOW_OBJ_LAYER
	density = 0
	anchored = 0
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 100
	circuit = /obj/item/weapon/circuitboard/reagentgrinder
	var/inuse = 0
	var/obj/item/weapon/reagent_containers/beaker = null
	var/limit = 10
	var/list/holdingitems = list()
	var/list/sheet_reagents = list(
		/obj/item/stack/material/iron = "iron",
		/obj/item/stack/material/uranium = MATERIAL_URANIUM,
		/obj/item/stack/material/plasma = "plasma",
		/obj/item/stack/material/gold = MATERIAL_GOLD,
		/obj/item/stack/material/silver = MATERIAL_SILVER,
		/obj/item/stack/material/mhydrogen = "hydrogen"
		)

/obj/item/weapon/circuitboard/reagentgrinder
	name = T_BOARD("reagent grinder")
	build_path = /obj/machinery/reagentgrinder
	origin_tech = list(TECH_BIO = 1)
	req_components = list(
		/obj/item/weapon/stock_parts/manipulator = 2
	)

/obj/machinery/reagentgrinder/Initialize()
	. = ..()
	beaker = new /obj/item/weapon/reagent_containers/glass/beaker/large(src)

/obj/machinery/reagentgrinder/update_icon()
	icon_state = "juicer"+num2text(!isnull(beaker))
	return

/obj/machinery/reagentgrinder/MouseDrop_T(atom/movable/I, mob/user, src_location, over_location, src_control, over_control, params)
	if(!Adjacent(user) || !I.Adjacent(user) || user.stat)
		return ..()
	if(istype(I, /obj/item/weapon/reagent_containers) && I.is_open_container() && !beaker)
		I.forceMove(src)
		src.beaker = I
		to_chat(user, SPAN_NOTICE("You add [I] to [src]."))
		SSnano.update_uis(src)
		update_icon()
		return

	if(holdingitems && holdingitems.len >= limit)
		to_chat(user, "The machine cannot hold anymore items.")
		return

	var/obj/item/O = I

	if(!istype(O))
		return

	if(istype(O,/obj/item/weapon/storage/bag/plants))
		var/obj/item/weapon/storage/bag/plants/bag = O
		var/failed = 1
		for(var/obj/item/G in O.contents)
			if(!G.reagents || !G.reagents.total_volume)
				continue
			failed = 0
			bag.remove_from_storage(G, src)
			holdingitems += G
			if(holdingitems && holdingitems.len >= limit)
				break

		if(failed)
			to_chat(user, "Nothing in the plant bag is usable.")
			return

		if(!O.contents.len)
			to_chat(user, "You empty \the [O] into \the [src].")
		else
			to_chat(user, "You fill \the [src] from \the [O].")

		SSnano.update_uis(src)
		return

	if(!sheet_reagents[O.type] && (!O.reagents || !O.reagents.total_volume))
		to_chat(user, "\The [O] is not suitable for blending.")
		return
	O.add_fingerprint(user)
	O.forceMove(src)
	holdingitems += O
	SSnano.update_uis(src)
	. = ..()

/obj/machinery/reagentgrinder/attackby(var/obj/item/O as obj, var/mob/user as mob)

	if (istype(O,/obj/item/weapon/reagent_containers/glass) || \
		istype(O,/obj/item/weapon/reagent_containers/food/drinks/drinkingglass) || \
		istype(O,/obj/item/weapon/reagent_containers/food/drinks/shaker))

		if (beaker)
			return 1
		else
			src.beaker =  O
			user.drop_item()
			O.loc = src
			update_icon()
			SSnano.update_uis(src)
			return 0

	//Useability tweak for borgs
	if (istype(O,/obj/item/weapon/gripper))
		ui_interact(user)
		return

	if(holdingitems && holdingitems.len >= limit)
		to_chat(user, "The machine cannot hold anymore items.")
		return 1

	if(!istype(O))
		return

	if(istype(O,/obj/item/weapon/storage/bag/plants))
		var/obj/item/weapon/storage/bag/plants/bag = O
		var/failed = 1
		for(var/obj/item/G in O.contents)
			if(!G.reagents || !G.reagents.total_volume)
				continue
			failed = 0
			bag.remove_from_storage(G, src)
			holdingitems += G
			if(holdingitems && holdingitems.len >= limit)
				break

		if(failed)
			to_chat(user, "Nothing in the plant bag is usable.")
			return 1

		if(!O.contents.len)
			to_chat(user, "You empty \the [O] into \the [src].")
		else
			to_chat(user, "You fill \the [src] from \the [O].")

		SSnano.update_uis(src)
		return 0

	if(!sheet_reagents[O.type] && (!O.reagents || !O.reagents.total_volume))
		to_chat(user, "\The [O] is not suitable for blending.")
		return 1

	user.remove_from_mob(O)
	O.loc = src
	holdingitems += O
	SSnano.update_uis(src)
	return 0

/obj/machinery/reagentgrinder/attack_ai(mob/user as mob)
	return 0

/obj/machinery/reagentgrinder/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	user.set_machine(src)
	ui_interact(user)

/obj/machinery/reagentgrinder/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	var/list/data = ui_data()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "grinder.tmpl", name, 400, 550)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/reagentgrinder/ui_data()
	var/list/data = list()
	data["on"] = inuse

	if(beaker)
		data["beaker"] = beaker.reagents.ui_data()
	data["contents"] = list()
	for (var/obj/item/O in holdingitems)
		data["contents"] += "\A [O.name]"
	return data

/obj/machinery/reagentgrinder/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["grind"])
		grind(usr)
	if(href_list["eject"])
		eject(usr)
	if(href_list["detach"])
		detach()
	playsound(loc, 'sound/machines/machine_switch.ogg', 100, 1)
	return 1

/obj/machinery/reagentgrinder/proc/detach(mob/user)
	if(user.stat)
		return
	if(!beaker)
		return
	beaker.loc = src.loc
	beaker = null
	update_icon()

/obj/machinery/reagentgrinder/proc/eject(mob/user)
	if(user.stat)
		return
	if(!holdingitems || holdingitems.len == 0)
		return

	for(var/obj/item/O in holdingitems)
		O.loc = src.loc
		holdingitems -= O
	holdingitems.Cut()

/obj/machinery/reagentgrinder/proc/grind()
	power_change()
	if(stat & (NOPOWER|BROKEN))
		return

	// Sanity check.
	if(!beaker || (beaker && beaker.reagents.total_volume >= beaker.reagents.maximum_volume))
		return

	playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
	inuse = 1

	// Reset the machine.
	spawn(60)
		inuse = 0
		SSnano.update_uis(src)

	// Process.
	for(var/obj/item/O in holdingitems)

		var/remaining_volume = beaker.reagents.maximum_volume - beaker.reagents.total_volume
		if(remaining_volume <= 0)
			break

		if(sheet_reagents[O.type])
			var/obj/item/stack/stack = O
			if(istype(stack))
				var/amount_to_take = max(0,min(stack.amount,round(remaining_volume/REAGENTS_PER_SHEET)))
				if(amount_to_take)
					stack.use(amount_to_take)
					if(QDELETED(stack))
						holdingitems -= stack
					beaker.reagents.add_reagent(sheet_reagents[stack.type], (amount_to_take*REAGENTS_PER_SHEET))
					if(stack.reagents)
						for(var/datum/reagent/R in stack.reagents.reagent_list)
							reagents.add_reagent(R.id, R.volume)
					continue

		if(O.reagents)
			O.reagents.trans_to(beaker, min(O.reagents.total_volume, remaining_volume))
			if(O.reagents.total_volume == 0)
				holdingitems -= O
				qdel(O)
			if (beaker.reagents.total_volume >= beaker.reagents.maximum_volume)
				break

/obj/item/weapon/storage/makeshift_grinder
	name = "makeshift grinder"
	desc = "Mortar and pestle to grind ingridients."
	icon = 'icons/obj/machines/chemistry.dmi'
	icon_state = "mortar"
	storage_slots = 3
	unacidable = 1
	var/amount_per_transfer_from_this = 10
	var/possible_transfer_amounts = list(5,10,30,60)
	reagent_flags = REFILLABLE | DRAINABLE

/obj/item/weapon/storage/makeshift_grinder/Initialize(mapload, ...)
	. = ..()
	create_reagents(60)

/obj/item/weapon/storage/makeshift_grinder/attack_self(mob/user)
	var/time_to_finish = 60 - (40 * user.stats.getMult(STAT_TGH, STAT_LEVEL_ADEPT))
	var/datum/repeating_sound/toolsound = new/datum/repeating_sound(8,time_to_finish,0.15, src, 'sound/effects/impacts/thud2.ogg', 50, 1)
	user.visible_message(SPAN_NOTICE("[user] grind contents of \the [src]."), SPAN_NOTICE("You starting to grind contents of \the [src]."))
	if(do_after(user,time_to_finish))
		grind()
		update_icon()
		refresh_all()
		if (toolsound)
			toolsound.stop()
			toolsound = null

/obj/item/weapon/storage/makeshift_grinder/proc/grind()
	// Sanity check.
	if (!reagents || (reagents.total_volume >= reagents.maximum_volume))
		return

	// Process.
	for (var/obj/item/O in src.contents)
		var/remaining_volume = reagents.maximum_volume - reagents.total_volume
		if(remaining_volume <= 0)
			break

		if(get_material_name_by_stack_type(O.type))
			var/obj/item/stack/stack = O
			if(istype(stack))
				var/amount_to_take = max(0,min(stack.amount,round(remaining_volume/REAGENTS_PER_SHEET)))
				if(amount_to_take)
					stack.use(amount_to_take)
					if(QDELETED(stack))
						src.contents.Remove(O)
					reagents.add_reagent(get_material_name_by_stack_type(stack.type), (amount_to_take*REAGENTS_PER_SHEET))
					if(stack.reagents)
						for(var/datum/reagent/R in stack.reagents.reagent_list)
							reagents.add_reagent(R.id, R.volume)
					continue

		if(O.reagents)
			O.reagents.trans_to(reagents, min(O.reagents.total_volume, remaining_volume))
			if(O.reagents.total_volume == 0)
				qdel(O)
				src.contents.Remove(O)
			if (reagents.total_volume >= reagents.maximum_volume)
				break

/obj/item/weapon/storage/makeshift_grinder/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/reagent_containers))
		var/obj/item/weapon/reagent_containers/container = I
		if(!container.standard_pour_into(user, src)) . = ..()
	else if (LAZYLEN(I.reagents)) . = ..()
	else to_chat(user, SPAN_NOTICE("\icon[I] \the [I] seems that it is not suitable for a \icon[src] [src]."))
	update_icon()

/obj/item/weapon/storage/makeshift_grinder/afterattack(atom/target, mob/user, flag)
	// Ensure we don't splash beakers and similar containers.
	if(user.a_intent == I_HURT)
		if(!istype(target))
			return FALSE

		if(!reagents.total_volume)
			to_chat(user, SPAN_NOTICE("[src] is empty."))
			return TRUE

		user.visible_message(
			SPAN_DANGER("[target] has been splashed with something by [user]!"),
			SPAN_NOTICE("You splash the solution onto [target].")
		)

		reagents.splash(target, reagents.total_volume)
		update_icon()
		return TRUE
	else
		if(!target.is_refillable())
			if(istype(target, /obj/item/weapon/reagent_containers))
				var/obj/item/weapon/reagent_containers/container = target
				container.is_closed_message(user)
				return TRUE
			// Otherwise don't care about splashing.
			else
				return ..()

		if(!reagents.total_volume)
			to_chat(user, SPAN_NOTICE("[src] is empty."))
			return TRUE

		if(!target.reagents.get_free_space())
			to_chat(user, SPAN_NOTICE("[target] is full."))
			return TRUE

		var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
		playsound(src,'sound/effects/Liquid_transfer_mono.ogg',50,1)
		to_chat(user, SPAN_NOTICE("You transfer [trans] units of the solution to [target]."))
	update_icon()

/obj/item/weapon/storage/makeshift_grinder/verb/set_APTFT() //set amount_per_transfer_from_this
	set name = "Set transfer amount"
	set category = "Object"
	set src in range(0)
	var/N = input("Amount per transfer from this:","[src]") as null|anything in possible_transfer_amounts
	if(N)
		amount_per_transfer_from_this = N

/obj/item/weapon/storage/makeshift_grinder/examine(mob/user)
	if(!..(user, 2))
		return
	if(contents.len)
		to_chat(user, SPAN_NOTICE("It has something inside."))
	if(reagents.total_volume)
		to_chat(user, SPAN_NOTICE("It's filled with [reagents.total_volume]/[reagents.maximum_volume] units of reagents."))


/obj/item/weapon/storage/makeshift_grinder/update_icon()
	. = ..()
	cut_overlays()
	if(reagents.total_volume)
		var/mutable_appearance/filling = mutable_appearance('icons/obj/reagentfillings.dmi', "[icon_state]100")
		filling.color = reagents.get_color()
		add_overlay(filling)
#undef REAGENTS_PER_SHEET
