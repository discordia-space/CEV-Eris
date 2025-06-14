/datum/objective/plunder
	target_amount = 15000 // Cumulated value of loot to plunder
	unique = TRUE

/datum/objective/plunder/New(datum/antagonist/new_owner, datum/mind/_target)
	..()
	if(owner_faction)
		target_amount *= LAZYLEN(owner_faction.members)
		update_explanation()

/datum/objective/plunder/check_completion()
	if(failed)
		return FALSE
	if(owner && (!owner.current || owner.current.stat == DEAD))
		return FALSE

	return (get_loot_value() < target_amount) ? FALSE : TRUE

/datum/objective/plunder/proc/get_loot_value()
	var/list/contents = list()

	// Get inventory of the faction
	if(owner_faction)
		contents.Add(owner_faction.get_inventory())

	var/cumulated_amount = 0

	// Check cumulated loot value
	for(var/atom/movable/A in contents)
		if(isitem(A))
			var/obj/item/I = A
			if(I.item_flags & PIRATE_BASE)  // Item spawned in pirate base are worthless for pirates
				continue
		cumulated_amount += SStrade.get_price(A, TRUE)

	return cumulated_amount

/datum/objective/plunder/update_explanation()
	explanation_text = "Plunder loot with a cumulated value of [target_amount] credits. Loot must be stored on the raid shuttle in a loot crate to be considered toward your objective."

/datum/objective/plunder/get_panel_entry()
	return "Plunder loot with a cumulated value of <a href='?src=\ref[src];set_target=1'>[target_amount]</a> credits. \
	        Value of loot: <a href='?src=\ref[src];set_target=1'>[get_loot_value()]</a> credits."

/datum/objective/plunder/get_info()
	return "Value of loot: [get_loot_value()] credits."

/datum/objective/plunder/Topic(href, href_list)
	if(..())
		return TRUE
	if(href_list["set_target"])
		var/new_target = input("Input target number:", "Value of loot to plunder", target_amount) as num|null
		if(new_target < 1)
			return
		else
			target_amount = new_target
			update_explanation()
			antag.antagonist_panel()
