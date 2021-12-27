/datum/admin_secret_item/admin_secret/contractors_and_objectives
	name = "Show current contractors and objectives"

/datum/admin_secret_item/admin_secret/contractors_and_objectives/execute(var/mob/user)
	. = ..()
	if(.)
		user.client.holder.check_antagonists()
