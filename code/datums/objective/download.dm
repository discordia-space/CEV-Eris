/datum/objective/download

/datum/objective/download/proc/gen_amount_goal()
	target_amount = rand(10, 20)
	explanation_text = "Download [target_amount] research levels."
	return target_amount

/datum/objective/download/check_completion()
	if(!ishuman(owner.current))
		return FALSE
	if(!owner.current || owner.current.stat == 2)
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

	return (current_amount < target_amount) ? 0 : 1
