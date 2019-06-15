#define SORT_EXCLUDE 0
#define SORT_INCLUDE 1

#define SORT_TYPE_MATERIAL "material"
#define SORT_TYPE_REAGENT "reagent"
/*
	Sorter will sort items based on rules
*/
/datum/sort_rule
	var/accept
	var/sort_type
	var/value
	var/amount

/datum/sort_rule/New(var/accept, var/type, var/value, var/amount)
	src.accept = accept
	src.sort_type = type
	src.value = value
	src.amount = amount



/obj/machinery/sorter
	name = "sorter"
	icon = 'icons/obj/machines/sorter.dmi'
	icon_state = "sorter"
	density = TRUE
	anchored = TRUE
	use_power = 1
	idle_power_usage = 10
	active_power_usage = 200

	circuit = /obj/item/weapon/circuitboard/sorter
	// based on levels of manipulators
	var/speed = 8
	// based on levels of scanners
	var/number_of_settings = 2
	var/accept_output_side = EAST
	var/refuse_output_side = null		//by default it will be reversed sorter's dir

	var/progress = 0

	var/list/sort_settings = list()
	var/obj/item/current_item

	//UI vars
	var/list/custom_rule = list("accept", "sort_type", "value", "amount")
	var/new_rule_ui = FALSE


/obj/machinery/sorter/Destroy()
	if(current_item)
		current_item.forceMove(get_turf(src))
	return ..()


/obj/machinery/sorter/update_icon()
	..()
	if(progress)
		icon_state = "sorter-process"
	else
		icon_state = "sorter"


/obj/machinery/sorter/Process()
	if(stat & BROKEN || stat & NOPOWER)
		progress = 0
		use_power(0)
		update_icon()
		return

	if(!sort_settings)
		return

	if(current_item)
		use_power(2)
		progress += speed
		if(progress >= 100)
			sort(current_item)
			progress = 0
			use_power(1)
		update_icon()
	else
		grab()


/obj/machinery/sorter/proc/sort(var/obj/item_to_sort)
	if(!current_item || !sort_settings)
		return
	var/sorted = FALSE
	for(var/datum/sort_rule/rule in sort_settings)
		switch(rule.sort_type)
			if(SORT_TYPE_MATERIAL)
				if(rule.value in item_to_sort.matter)
					if(rule.amount && (item_to_sort.matter[rule.value] >= rule.amount))
						sorted = rule.accept
						if(!sorted)
							break

			if(SORT_TYPE_REAGENT)
				if(item_to_sort.reagents && item_to_sort.reagents.has_reagent(rule.value, rule.amount))
					sorted = rule.accept
					if(!sorted)
						break

	eject(sorted)
	return


/obj/machinery/sorter/proc/grab()
	if(current_item)
		return
	var/turf/T = get_step(src, dir)
	var/obj/item/O = locate(/obj/item) in T
	if(istype(O) && !O.anchored)
		current_item = O
		O.forceMove(src)
		state("scanning now: [O]...")


/obj/machinery/sorter/proc/eject(var/sorted = FALSE)
	if(!current_item)
		return
	var/output_dir
	if(refuse_output_side)
		output_dir = refuse_output_side
	else
		output_dir = reverse_direction(dir)
	var/turf/T
	if(sorted)
		T = get_step(src, accept_output_side)
		state("[current_item] accepted.")
	else
		T = get_step(src, output_dir)
		state("[current_item] refused.")
	if(T)
		current_item.forceMove(T)
		current_item = null


/obj/machinery/sorter/RefreshParts()
	..()
	var/manipulator_rating = 0
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		manipulator_rating += M.rating
	var/num_settings = 0
	for(var/obj/item/weapon/stock_parts/scanning_module/S in component_parts)
		num_settings += S.rating
	number_of_settings = num_settings * 2
	speed = manipulator_rating*4


/obj/machinery/sorter/attackby(var/obj/item/I, var/mob/user)
	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return

	..()

/obj/machinery/sorter/attack_hand(mob/user as mob)
	return ui_interact(user)


//UI

/obj/machinery/sorter/ui_data()
	var/list/data = list()
	data["currentItem"] = null
	if(current_item)
		data["currentItem"] = current_item.name
	data["progress"] = progress

	var/list/data_rules = list()
	for(var/datum/sort_rule/rule in sort_settings)
		data_rules.Add(list(list(
				"accept" = rule.accept,
				"sort_type" = rule.sort_type,
				"value" = rule.value,
				"amount" = rule.amount
				)))
	data["rules"] = data_rules
	data["add_new_rule"] = new_rule_ui
	data["max_rule_num"] = number_of_settings
	data["current_rule_num"] = sort_settings.len
	data["new_rule_accept"] = custom_rule["accept"]
	data["new_rule_sort"] = custom_rule["sort_type"]
	data["new_rule_value"] = custom_rule["value"]
	data["new_rule_amount"] = custom_rule["amount"]

	return data


/obj/machinery/sorter/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS, datum/topic_state/state = GLOB.default_state)
	var/list/data = ui_data()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "sorter.tmpl", src.name, 600, 400, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/obj/machinery/sorter/Topic(href, href_list)
	if (..()) return TRUE

	if (href_list["remove"])
		var/key = text2num(href_list["remove"])
		var/datum/sort_rule/rule_to_remove = sort_settings[key]
		sort_settings.Remove(rule_to_remove)
		qdel(rule_to_remove)
	else if (href_list["add_new"])
		new_rule_ui = TRUE

	else if (href_list["filter"])
		custom_rule["accept"] = text2num(href_list["filter"])

	else if (href_list["sort_type"])
		custom_rule["sort_type"] = href_list["sort_type"]

	else if (href_list["type_input"])
		custom_rule["value"] = lowertext(input("Type name of [custom_rule["sort_type"]]"))

	else if (href_list["amount_input"])
		custom_rule["amount"] = text2num(input("Type amount of [custom_rule["sort_type"]]"))
		if(!isnum(custom_rule["amount"]))
			state("Sorry. Amount should be a number.")
			custom_rule["amount"] = 1

	else if (href_list["add"])
		if(sort_settings.len < number_of_settings)
			sort_settings += new /datum/sort_rule(custom_rule["accept"],
												custom_rule["sort_type"],
												custom_rule["value"],
												custom_rule["amount"])
			state("New rule added. Updating scanners with new info...")
		else
			state("Maximum number of rules reached. Out of Memory.")
		custom_rule = list("accept", "sort_type", "value", "amount")

	else if (href_list["cancel"])
		new_rule_ui = null
		custom_rule = list("accept", "sort_type", "value", "amount")


	SSnano.update_uis(src)
	playsound(loc, 'sound/machines/machine_switch.ogg', 100, 1)
	return FALSE








/obj/machinery/sorter/biomatter
	name = "biomatter sorter"

/obj/machinery/sorter/biomatter/Initialize()
	. = ..()
	sort_settings += new /datum/sort_rule(SORT_INCLUDE, SORT_TYPE_MATERIAL, MATERIAL_BIOMATTER, 1)


#undef SORT_EXCLUDE
#undef SORT_INCLUDE

#undef SORT_TYPE_MATERIAL
#undef SORT_TYPE_REAGENT