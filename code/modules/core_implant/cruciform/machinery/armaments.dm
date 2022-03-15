/datum/armament
	var/name = "Virtue of coding"
	var/desc = "The gods made it quite clear this should not exist, Perhaps inform those above."
	var/cost = 100
	var/min_cost = 10 //aboslute minimum it should cost
	var/path = /obj/item/computer_hardware/hard_drive/portable/design/nt_bioprinter_public //path to spawn
	var/purchase_count = 0 //how many times its bought
	var/discount_increase = 25 //discount increase per purchase
	var/discount = 0 //total discount to apply to the cost
	var/max_discount = 25 //max amount of discounts
	var/rate_increase = 0 //rate increase per purchase
	var/max_rate_increase = 0 //max rate increase from buying this
	var/max_increase = 50 //incease of eotp max armement points per purchase

//modifiers in the future? maby some rituals to reduce cost for certain subtype
/datum/armament/proc/get_cost()
	return max(min_cost,cost - discount)

/datum/armament/proc/purchase(var/mob/living/carbon/H)
	if (!eotp)
		error("no eotp found to purchase from")
		return FALSE
	if (get_dist(eotp.loc,H.loc) > 3)
		log_and_message_admins("[key_name(H)] tryed to make a topic call out of range for the [eotp]")
		return FALSE

	if (!is_neotheology_disciple(H))
		to_chat(H, SPAN_DANGER("You do not understand how to use this."))
		return FALSE

	if (!eotp.armaments_points >= cost)
		to_chat(H, SPAN_DANGER("You lack required armament points."))
		return FALSE


	eotp.armaments_points -= get_cost()

	purchase_count++

	discount = max(max_discount,discount + discount_increase)

	if (eotp.armaments_rate + rate_increase > max_rate_increase)
		eotp.armaments_rate += rate_increase

	eotp.max_armaments_points += max_increase

	on_purchase(H)
	SSnano.update_uis(eotp)
	log_and_message_admins("[key_name(H)] has invoked [src.name]")
	return TRUE


//maby buying buffs,blessings, miracles,etc instead of just items
/datum/armament/proc/on_purchase(var/mob/living/carbon/H)
	return


/obj/machinery/power/eotp/ui_data(mob/user)
	var/list/data = list()
	var/list/listed_armaments = list()
	for(var/i=1 to armaments.len)
		var/datum/armament/A = armaments[i]
		listed_armaments.Add(list(list(
			"key" = i,
			"name" = strip_improper(A.name),
			"cost" = A.get_cost(),
			"desc" = A.desc)))
	data["armaments"] = listed_armaments
	return data


/obj/machinery/power/eotp/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	var/list/data = ui_data(user, ui_key)

	ui = SSnano.try_update_ui(user, eotp, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "eopt.tmpl", "Eye of the protector", 550, 655)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()

/obj/machinery/power/eotp/Topic(href, href_list)
	if (href_list["chosen"])
		var/i = text2num(href_list["chosen"])
		var/datum/armament/A = eotp.armaments[i]
		A.purchase(usr)

//////////////////////Item summonings
/datum/armament/item
	name = "item summoning"

/datum/armament/item/on_purchase(mob/living/carbon/H)
	if (path)
		var/obj/_item = new path(get_turf(eotp))
		eotp.visible_message(SPAN_NOTICE("The [_item.name] appers out of bluespace near the [eotp]!"))

/datum/armament/item/disk
	name = "disk"
	cost = 100
	discount_increase = 25
	min_cost = 25

/datum/armament/item/disk/crusader
	name = "Crusader disk"
	path = /obj/item/computer_hardware/hard_drive/portable/design/nt/crusader

/datum/armament/item/disk/advancedmelee
	name = "Advanced melee disk"
	path = /obj/item/computer_hardware/hard_drive/portable/design/nt/advancedmelee

/datum/armament/item/disk/cruciform_upgrade
	name = "Cruciform upgrade disk"
	path = /obj/item/computer_hardware/hard_drive/portable/design/nt/cruciform_upgrade

/datum/armament/item/disk/cells
	name = "Power Cells disk"
	path = /obj/item/computer_hardware/hard_drive/portable/design/nt/cells

/datum/armament/item/grenade
	name = "Grenade"
	desc = "Summoning of boom booms"
	path = /obj/item/grenade/explosive/nt
	cost = 50
	min_cost = 5
	discount_increase = 5

