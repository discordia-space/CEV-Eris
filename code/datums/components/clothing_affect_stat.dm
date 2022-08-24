// possible skills
// STAT_MEC STAT_COG STAT_VIG STAT_BIO STAT_TGH STAT_ROB

/datum/component/clothing_stat_affecting
	var/list/affecting_stats = list()
	var/mob/living/carbon/human/current_user

/datum/component/clothing_stat_affecting/Initialize(list/value , usefull = 0)
	if(!(istype(parent, /obj/item/clothing)))
		return COMPONENT_INCOMPATIBLE
	affecting_stats = value
	var/atom/current_parent = parent
	var/description = "This item influences the following skills by the following amounts \n"
	for(var/affected in affecting_stats)
		message_admins("received stats - [affected] / [affecting_stats]")
		description += "[affected] by [affecting_stats[affected]] \n"
	current_parent.description_info += description
	RegisterSignal(current_parent, COMSIG_CLOTH_EQUIPPED, .proc/handle_stat_changes)

/datum/component/clothing_stat_affecting/proc/handle_stat_changes(mob/living/carbon/human/user)
	var/obj/item/current_parent = parent
	if(current_parent.is_worn())
		RegisterSignal(user, COMSIG_CLOTH_DROPPED, .proc/handle_stat_removal)
		current_user = user
		for(var/affected in affecting_stats)
			current_user.stats.addTempStat(affected, affecting_stats[affected], INFINITY, "[parent]")

/datum/component/clothing_stat_affecting/proc/handle_stat_removal()
	for(var/affected in affecting_stats)
		current_user.stats.removeTempStat(affected, "[parent]")
	UnregisterSignal(current_user, COMSIG_CLOTH_DROPPED)
	current_user = null

// Remove any references to avoid hard dels
/datum/component/clothing_stat_affecting/Destroy()
	if(current_user)
		for(var/affected in affecting_stats)
			current_user.stats.removeTempStat(affected, "[parent]")
		UnregisterSignal(current_user, COMSIG_CLOTH_DROPPED)
		current_user = null
	UnregisterSignal(parent, COMSIG_CLOTH_EQUIPPED)
	var/atom/current_parent = parent
	current_parent.description_info = initial(current_parent.description_info)
	..()
