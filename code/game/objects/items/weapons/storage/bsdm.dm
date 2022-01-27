/obj/item/storage/bsdm
	name = "\improper BSDM unit"
	desc = "A Blue Space Direct69ail unit, commonly used by corporate infiltrators. \
			Once activated, teleports a small distance away into space and sends a signal for a recovery probe to pick it up."
	icon_state = "bsdm"
	item_state = "bsdm"
	max_storage_space = DEFAULT_BULKY_STORAGE
	max_w_class = ITEM_SIZE_BULKY
	origin_tech = list(TECH_BLUESPACE = 3, TECH_COVERT = 3)
	matter = list(MATERIAL_STEEL = 6)
	spawn_blacklisted = TRUE
	var/del_on_send = TRUE
	var/datum/mind/owner

/obj/item/storage/bsdm/proc/can_launch()
	return owner && (locate(/area/space) in69iew(get_turf(src)))

/obj/item/storage/bsdm/attack_self(mob/user)
	ui_interact(user)

/obj/item/storage/bsdm/interact(mob/user)
	ui_interact(user)

/obj/item/storage/bsdm/ui_data(mob/user)
	var/list/list/data = list()

	data69"can_launch"69 = can_launch()
	data69"owner"69 = owner ? owner.name : "no one"
	data69"is_owner"69 = owner && (owner == user.mind)
	data69"contracts"69 = list()

	for(var/datum/antag_contract/item/C in GLOB.various_antag_contracts)
		if(C.completed || !C.check(src))
			continue
		data69"contracts"69.Add(list(list(
			"name" = C.name,
			"desc" = C.desc,
			"reward" = C.reward
		)))

	return data

/obj/item/storage/bsdm/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	var/list/data = ui_data(user)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "bsdm.tmpl", "69name69", 400, 430)
		ui.set_initial_data(data)
		ui.open()

/obj/item/storage/bsdm/Topic(href, href_list)
	if(..())
		return 1

	if(href_list69"launch"69)
		if(!can_launch())
			return

		for(var/datum/antag_contract/item/C in GLOB.various_antag_contracts)
			if(C.completed)
				continue
			C.on_container(src)
		69DEL_CLEAR_LIST(contents)
		if(del_on_send)
			if(ismob(loc))
				to_chat(loc, SPAN_NOTICE("69src69 flick_lights away in a brief flash of light."))
			69del(src)

	else if(href_list69"owner"69)
		owner = usr.mind
		. = 1

	if(.)
		SSnano.update_uis(src)

/obj/item/storage/bsdm/permanent
	del_on_send = FALSE

/obj/item/storage/bsdm/permanent/attackby(obj/item/W as obj,69ob/user as69ob)
	..()

	if(istype(W, /obj/item/reagent_containers/syringe/blitzshell))
		var/obj/item/reagent_containers/syringe/blitzshell/syringe_blitzshell = W
		if(syringe_blitzshell.reagents.total_volume)
			var/trans
			var/obj/item/reagent_containers/glass/beaker/vial/vial_blitzshell = new /obj/item/reagent_containers/glass/beaker/vial(src)
			trans = syringe_blitzshell.reagents.trans_to(vial_blitzshell, syringe_blitzshell.reagents.total_volume)
			to_chat(user ,SPAN_NOTICE("You transfer 69trans69 units of the solution from 69syringe_blitzshell69 to 69src69"))
			return handle_item_insertion(vial_blitzshell)
