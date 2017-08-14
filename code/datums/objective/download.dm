/datum/objective/download

/datum/objective/download/find_target()
	target_amount = rand(10, 20)
	update_explanation()

/datum/objective/download/check_completion()
	if(!ishuman(owner.current))
		return FALSE
	if(!owner.current || owner.current.stat == DEAD)
		return FALSE

	var/current_amount
	var/obj/item/weapon/rig/S
	if(ishuman(owner.current))
		var/mob/living/carbon/human/H = owner.current
		S = H.back

	if(!istype(S) || !S.installed_modules || !S.installed_modules.len)
		return FALSE

	var/obj/item/rig_module/datajack/stolen_data = locate() in S.installed_modules
	if(!istype(stolen_data))
		return FALSE

	for(var/datum/tech/current_data in stolen_data.stored_research)
		if(current_data.level > 1)
			current_amount += (current_data.level - 1)

	return (current_amount < target_amount) ? FALSE : TRUE

/datum/objective/download/update_explanation()
	explanation_text = "Download [target_amount] research levels."

/datum/objective/download/get_panel_entry()
	return "Download <a href='?src=\ref[src];set_target=1'>[target_amount]</a> research levels."

/datum/objective/download/Topic(href, href_list)
	if(..())
		return TRUE
	if(href_list["set_target"])
		var/new_target = input("Input target number:", "Research levels", target_amount) as num|null
		if(new_target < 1)
			return
		else
			target_amount = new_target
			update_explanation()
			owner.edit_memory()