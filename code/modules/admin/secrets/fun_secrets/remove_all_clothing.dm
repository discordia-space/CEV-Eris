/datum/admin_secret_item/fun_secret/remove_all_clothing
	name = "Remove ALL Clothing"

/datum/admin_secret_item/fun_secret/remove_all_clothing/execute(mob/user)
	. = ..()
	if(!.)
		return

	for(var/obj/item/clothing/O in world)
		qdel(O)
