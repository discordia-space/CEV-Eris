/obj/item/weapon/book/ritual
	name = "Rituals book"
	desc = "Contains rituals."
	icon = 'icons/obj/library.dmi'
	icon_state = "book"
	var/has_reference = FALSE

	var/expanded_group = null
	var/current_category = ""
	var/reference_mode = FALSE


/obj/item/weapon/book/ritual/attack_self(mob/living/carbon/human/H)
	playsound(src.loc, pick('sound/items/BOOK_Turn_Page_1.ogg',\
		'sound/items/BOOK_Turn_Page_2.ogg',\
		'sound/items/BOOK_Turn_Page_3.ogg',\
		'sound/items/BOOK_Turn_Page_4.ogg',\
		), rand(40,80), 1)
	interact(H)

/obj/item/weapon/book/ritual/ui_interact(mob/user, ui_key = "main",var/datum/nanoui/ui = null, var/force_open = 1)
	var/obj/item/weapon/implant/core_implant/cruciform/CI = user.get_cruciform()

	var/data = list()
	data["noimplant"] = FALSE
	data["refmode"] = reference_mode
	data["hasref"] = has_reference

	if(CI && istype(CI))
		var/list/rdata = list()
		var/list/cdata = list()

		for(var/RT in CI.rituals)
			var/datum/ritual/R = new RT

			if(!(R.category in cdata))
				cdata.Add(R.category)

			if(current_category != "" && current_category != R.category)
				continue

			if(R.phrase && R.distinct)
				var/list/L = list(
					"name" = capitalize(R.name),
					"phrase" = R.get_display_phrase(),
					"category" = R.category,
					"type" = "[RT]",
				)


				rdata.Add(list(L))

		data["rituals"] = rdata
		data["categories"] = cdata
	else
		data["noimplant"] = TRUE

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "ritual_book.tmpl", "Autolathe", 550, 655)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()


/obj/item/weapon/book/ritual/interact(mob/living/carbon/human/H)
	/*var/data = null
	for(var/RT in rituals)
		var/datum/ritual/R = new RT
		if(!R.phrase || R.phrase == "")
			continue
		data += ritual(R)
	H << browse(data, "window=[src.name]")*/
	ui_interact(H)


/obj/item/weapon/book/ritual/Topic(href, href_list)
	var/mob/living/carbon/human/H = usr
	if(H.stat)
		return

	var/obj/item/weapon/implant/core_implant/cruciform/CI = H.get_cruciform()

	for(var/RT in CI.rituals)
		var/rtype = replacetext("[RT]","/","")
		if(href_list[rtype])
			var/datum/ritual/R = new RT
			H.say(R.get_say_phrase())
			break
	return TRUE