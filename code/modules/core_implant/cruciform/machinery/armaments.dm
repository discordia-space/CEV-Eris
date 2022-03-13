/datum/armament
	var/name = "Virtue of coding"
	var/desc = "The gods made it quite clear this should not exist, Perhaps inform those above."
	var/cost = 100
	var/min_cost = 10
	var/path = /obj/item/computer_hardware/hard_drive/portable/design/nt_bioprinter_public
	var/purchase_count = 0
	var/discount_increase = 25
	var/discount = 0
	var/max_discount = 25
	var/rate_increase = 0
	var/max_rate_increase = 0
	var/max_increase = 50

//modifiers in the future? maby some rituals to reduce cost for certain subtype
/datum/armament/proc/get_cost()
	return (cost - discount) > min_cost ? cost - discount : min_cost

/datum/armament/proc/purchase(var/mob/living/carbon/H)
	if (!eotp)
		error("no eotp found to purchase from")
		return FALSE

	if (!is_neotheology_disciple(H))
		to_chat(H, SPAN_DANGER("You do not understand how to use this."))
		return FALSE

	if (!eotp.armaments_points >= cost)
		to_chat(H, SPAN_DANGER("You lack required armament points."))
		return FALSE


	eotp.armaments_points -= get_cost()

	purchase_count++

	discount += discount_increase
	if (max_discount > discount)
		discount = max_discount

	if (eotp.armaments_rate > max_rate_increase)
		eotp.armaments_rate += rate_increase


	on_purchase(H)

	log_and_message_admins("[key_name(H)] has invoked [src.name]")
	return TRUE


//maby buying buffs,blessings, miracles,etc instead of just items
/datum/armament/proc/on_purchase(var/mob/living/carbon/H)
	return



/datum/armament/ui_data(mob/user)
	var/list/data = list()
	var/list/listed_armaments = list()
	for(var/i=1 to eotp.armaments.len)
		var/datum/armament/A = eotp.armaments[i]
		listed_armaments.Add(list(list(
			"key" = i,
			"name" = strip_improper(A.name),
			"cost" = A.cost,
			"desc" = A.desc)))
	data["armements"] = listed_armaments
	return data


/datum/armament/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	var/list/data = ui_data(user, ui_key)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "eopt.tmpl", "Eye of the protector", 550, 655)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()

/datum/armament/Topic(href, href_list)
	if (href_list["Buy"])
		var/i = text2num(href_list["vend"])
		var/datum/armament/A = eotp.armaments[i]
		A.purchase(usr)

//////////////////////Item summonings
/datum/armament/item
	name = "item summoning"

/datum/armament/item/on_purchase(mob/living/carbon/H)
	if (path)
		var/obj/_item = new path(get_turf(eotp))
		eotp.visible_message(SPAN_NOTICE("The [_item.name] appers out of bluespace near the [eotp]!"))




