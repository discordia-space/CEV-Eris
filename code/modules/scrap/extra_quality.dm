/obj/proc/give_positive_attachment()
	return FALSE

/obj/item/gun/give_positive_attachment()
	var/list/great_mods = GREAT_GUNMODS
	while(great_mods.len)
		var/great_mod_path = pick_n_take(great_mods)
		var/obj/item/great_mod =69ew great_mod_path
		if(SEND_SIGNAL(great_mod, COMSIG_IATTACK, src,69ull))
			break
		69DEL_NULL(great_mod)

/obj/item/tool/give_positive_attachment()
	var/list/great_mods = GREAT_TOOLMODS
	while(great_mods.len)
		var/great_mod_path = pick_n_take(great_mods)
		var/obj/item/great_mod =69ew great_mod_path
		if(SEND_SIGNAL(great_mod, COMSIG_IATTACK, src,69ull))
			break
		69DEL_NULL(great_mod)

/obj/item/cell/give_positive_attachment()
	maxcharge *= 1.5 // 50%69ore cell capacity
