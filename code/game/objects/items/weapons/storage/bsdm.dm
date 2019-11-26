/obj/item/weapon/storage/bsdm
	name = "\improper BSDM unit"
	desc = "A Blue Space Direct Mail unit."
	icon_state = "bsdm"
	item_state = "bsdm"
	max_storage_space = DEFAULT_BULKY_STORAGE
	max_w_class = ITEM_SIZE_BULKY
	var/datum/mind/owner

/obj/item/weapon/storage/bsdm/attack_self(mob/user)
	ui_interact(user)

/obj/item/weapon/storage/bsdm/interact(mob/user)
	ui_interact(user)

/obj/item/weapon/storage/bsdm/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	var/data[0]

	data["can_launch"] = !!(locate(/area/space) in view(get_turf(src)))
	data["owner"] = owner.name
	data["is_owner"] = owner == user.mind
	data["contracts"] = list()

	for(var/datum/antag_contract/item/C in GLOB.all_antag_contracts)
		if(C.completed || !C.check(src))
			continue
		data["contracts"].Add(list(list(
			"name" = C.name,
			"desc" = C.desc,
			"reward" = C.reward
		)))

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "bsdm.tmpl", "[name]", 400, 430)
		ui.set_initial_data(data)
		ui.open()

/obj/item/weapon/storage/bsdm/Topic(href, href_list)
	if(..())
		return 1

	if (href_list["launch"])
		if(!(locate(/area/space) in view(get_turf(src))))
			return
		for(var/datum/antag_contract/item/C in GLOB.all_antag_contracts)
			if(C.completed)
				continue
			C.on_container(src)
		qdel(src)

	else if (href_list["owner"])
		owner = usr.mind
		. = 1

	if(.)
		SSnano.update_uis(src)
