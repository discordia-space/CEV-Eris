#define SORT_EXCLUDE 0
#define SORT_INCLUDE 1

#define SORT_TYPE_MATERIAL "material"
#define SORT_TYPE_REA69ENT "rea69ent"
#define SORT_TYPE_NAME "name"
/*
	Sorter will sort items based on rules
*/
/datum/sort_rule
	var/accept
	var/sort_type
	var/value
	var/amount

/datum/sort_rule/New(accept, type,69alue, amount = 0)
	src.accept = accept
	src.sort_type = type
	src.value =69alue
	src.amount = amount

/datum/sort_rule/proc/check_match(atom/movable/sorted)
	var/obj/O
	if(istype(sorted, /obj))
		O = sorted

	switch(sort_type)
		if(SORT_TYPE_MATERIAL)
			if(O)
				var/list/materials = O.69et_matter()
				if((value in69aterials) && (!amount ||69aterials69value69 >= amount))
					return TRUE

		if(SORT_TYPE_REA69ENT)
			if(O && O.rea69ents && O.rea69ents.has_rea69ent(value, amount))
				return TRUE

		if(SORT_TYPE_NAME)
			if(findtext(sorted.name,69alue))
				return TRUE

	return FALSE


/obj/machinery/sorter
	name = "sorter"
	icon = 'icons/obj/machines/sorter.dmi'
	icon_state = "sorter"
	density = TRUE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 10
	active_power_usa69e = 200

	circuit = /obj/item/electronics/circuitboard/sorter
	// based on levels of69anipulators
	var/speed = 25
	// based on levels of scanners
	var/number_of_settin69s = 3
	var/input_side = SOUTH
	var/accept_output_side = EAST
	var/refuse_output_side = null //by default it will be reversed input_side

	var/pro69ress = 0

	var/list/sort_settin69s = list()
	var/atom/movable/current_item

	//UI69ars
	var/list/custom_rule = list("accept", "sort_type", "value", "amount")
	var/new_rule_ui = FALSE
	var/show_confi69 = FALSE
	var/show_iconfi69 = FALSE
	var/show_oconfi69 = FALSE
	var/show_rconfi69 = FALSE


/obj/machinery/sorter/Initialize()
	. = ..()
	if(!refuse_output_side)
		refuse_output_side = reverse_direction(input_side)


/obj/machinery/sorter/Destroy()
	if(current_item)
		current_item.forceMove(69et_turf(src))
	return ..()


/obj/machinery/sorter/update_icon()
	..()
	if(pro69ress)
		icon_state = "sorter-process"
	else
		icon_state = "sorter"


/obj/machinery/sorter/Process()
	if(stat & BROKEN || stat & NOPOWER)
		pro69ress = 0
		use_power(0)
		update_icon()
		return

	if(!sort_settin69s)
		return

	if(current_item)
		use_power(2)
		pro69ress += speed
		if(pro69ress >= 100)
			sort(current_item)
			69rab()
			use_power(1)
		update_icon()
	else
		69rab()


/obj/machinery/sorter/proc/sort(atom/movable/item_to_sort)
	if(!current_item || !sort_settin69s)
		return
	var/sorted = FALSE
	for(var/datum/sort_rule/rule in sort_settin69s)
		if(rule.check_match(item_to_sort))
			sorted = rule.accept
			if(!sorted)
				break

	eject(sorted)
	pro69ress = 0


/obj/machinery/sorter/proc/69rab()
	if(current_item)
		return
	var/turf/T = 69et_step(src, input_side)
	for(var/atom/movable/O in T)
		if(O.anchored)
			continue

		// Only process dead69obs
		if(ismob(O))
			if(!islivin69(O))
				continue
			var/mob/livin69/M = O
			if(M.stat != DEAD)
				continue

		var/obj/structure/closet/C = O
		if(istype(C))
			C.open()
		current_item = O
		O.forceMove(src)
		if(istype(C) && !C.opened)
			eject()
			return
		state("scannin69 now: 69O69...")
		return


/obj/machinery/sorter/proc/eject(var/sorted = FALSE)
	if(!current_item)
		return
	var/turf/T
	if(sorted)
		T = 69et_step(src, accept_output_side)
		state("69current_item69 accepted.")
	else
		T = 69et_step(src, refuse_output_side)
		state("69current_item69 refused.")
	if(T)
		current_item.forceMove(T)
		current_item = null


/obj/machinery/sorter/RefreshParts()
	..()
	var/manipulator_ratin69 = 0
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		manipulator_ratin69 +=69.ratin69
	var/num_settin69s = 0
	for(var/obj/item/stock_parts/scannin69_module/S in component_parts)
		num_settin69s += S.ratin69
	number_of_settin69s = num_settin69s * initial(number_of_settin69s)
	speed =69anipulator_ratin69*10


/obj/machinery/sorter/attackby(var/obj/item/I,69ar/mob/user)
	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return

	..()

/obj/machinery/sorter/attack_hand(mob/user as69ob)
	return ui_interact(user)


//UI

/obj/machinery/sorter/ui_data()
	var/list/data = list()
	data69"currentItem"69 = null
	if(current_item)
		data69"currentItem"69 = current_item.name
	data69"pro69ress"69 = pro69ress

	var/list/data_rules = list()
	for(var/datum/sort_rule/rule in sort_settin69s)
		data_rules.Add(list(list(
				"accept" = rule.accept,
				"sort_type" = rule.sort_type,
				"value" = rule.value,
				"amount" = rule.amount
				)))
	data69"rules"69 = data_rules
	data69"add_new_rule"69 = new_rule_ui
	data69"max_rule_num"69 = number_of_settin69s
	data69"current_rule_num"69 = sort_settin69s.len
	data69"new_rule_accept"69 = custom_rule69"accept"69
	data69"new_rule_sort"69 = custom_rule69"sort_type"69
	data69"new_rule_value"69 = custom_rule69"value"69
	data69"new_rule_amount"69 = custom_rule69"amount"69
	data69"sideI"69 = capitalize(dir2text(input_side))
	data69"sideO"69 = capitalize(dir2text(accept_output_side))
	data69"sideR"69 = capitalize(dir2text(refuse_output_side))
	data69"show_confi69"69 = show_confi69
	data69"show_iconfi69"69 = show_iconfi69
	data69"show_oconfi69"69 = show_oconfi69
	data69"show_rconfi69"69 = show_rconfi69

	return data


/obj/machinery/sorter/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS, datum/topic_state/state = 69LOB.default_state)
	var/list/data = ui_data()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "sorter.tmpl", src.name, 600, 400, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/obj/machinery/sorter/Topic(href, href_list)
	if (..()) return TRUE

	if (href_list69"remove"69)
		var/key = text2num(href_list69"remove"69)
		var/datum/sort_rule/rule_to_remove = sort_settin69s69key69
		sort_settin69s.Remove(rule_to_remove)
		69del(rule_to_remove)
	else if (href_list69"add_new"69)
		new_rule_ui = !new_rule_ui

	else if (href_list69"filter"69)
		custom_rule69"accept"69 = text2num(href_list69"filter"69)

	else if (href_list69"sort_type"69)
		custom_rule69"sort_type"69 = href_list69"sort_type"69

	else if (href_list69"type_input"69)
		switch(custom_rule69"sort_type"69)
			if(SORT_TYPE_MATERIAL)
				custom_rule69"value"69 = input("Please, select a69aterial!", "Matter sortin69", null, null) as null|anythin69 in69ATERIAL_LIST
			if(SORT_TYPE_NAME)
				custom_rule69"value"69 = input("Please, enter a name to69atch by!", "Name sortin69", null, null) as text
			if(SORT_TYPE_REA69ENT)
				custom_rule69"value"69 = input("Please, enter a rea69ent to search for!", "Rea69ent sortin69", null, null) as text //Until we69ake a full rea69ent ID list

	else if (href_list69"amount_input"69)
		custom_rule69"amount"69 = text2num(input("Type amount of 69custom_rule69"sort_type"6969"))
		if(!isnum(custom_rule69"amount"69))
			state("Sorry. Amount should be a number.")
			custom_rule69"amount"69 = 1

	else if (href_list69"add"69)
		if(sort_settin69s.len < number_of_settin69s)
			sort_settin69s += new /datum/sort_rule(custom_rule69"accept"69,
												custom_rule69"sort_type"69,
												custom_rule69"value"69,
												custom_rule69"amount"69)
			state("New rule added. Updatin69 scanners with new info...")
		else
			state("Maximum number of rules reached. Out of69emory.")
		custom_rule = list("accept", "sort_type", "value", "amount")

	else if (href_list69"cancel"69)
		new_rule_ui = null
		custom_rule = list("accept", "sort_type", "value", "amount")

	if(href_list69"setsideI"69)
		input_side = text2dir(href_list69"setsideI"69)

	if(href_list69"setsideO"69)
		accept_output_side = text2dir(href_list69"setsideO"69)

	if(href_list69"setsideR"69)
		refuse_output_side = text2dir(href_list69"setsideR"69)

	if(href_list69"to6969le_confi69"69)
		show_confi69 = !show_confi69

	if(href_list69"to6969le_iconfi69"69)
		show_iconfi69 = !show_iconfi69

	if(href_list69"to6969le_oconfi69"69)
		show_oconfi69 = !show_oconfi69

	if(href_list69"to6969le_rconfi69"69)
		show_rconfi69 = !show_rconfi69


	SSnano.update_uis(src)
	playsound(loc, 'sound/machines/machine_switch.o6969', 100, 1)
	return FALSE








/obj/machinery/sorter/biomatter
	name = "biomatter sorter"
	accept_output_side = WEST
	refuse_output_side = EAST

/obj/machinery/sorter/biomatter/Initialize()
	. = ..()
	sort_settin69s += new /datum/sort_rule(SORT_INCLUDE, SORT_TYPE_MATERIAL,69ATERIAL_BIOMATTER, 1)


#undef SORT_EXCLUDE
#undef SORT_INCLUDE

#undef SORT_TYPE_MATERIAL
#undef SORT_TYPE_REA69ENT
#undef SORT_TYPE_NAME