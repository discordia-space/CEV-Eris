/obj/item/book/ritual
	name = "Rituals book"
	desc = "Contains rituals."
	icon = 'icons/obj/library.dmi'
	icon_state = "book"
	var/has_reference = FALSE

	var/expanded_group = null
	var/current_category = "Common"
	var/reference_mode = FALSE


/obj/item/book/ritual/attack_self(mob/living/carbon/human/H)
	playsound(src.loc, pick('sound/items/BOOK_Turn_Page_1.ogg',\
		'sound/items/BOOK_Turn_Page_2.ogg',\
		'sound/items/BOOK_Turn_Page_3.ogg',\
		'sound/items/BOOK_Turn_Page_4.ogg',\
		), rand(40,80), 1)
	interact(H)

/obj/item/book/ritual/ui_data(mob/user)
	var/obj/item/implant/core_implant/cruciform/CI
	if(isliving(user))
		var/mob/living/L = user
		CI = L.get_core_implant(/obj/item/implant/core_implant/cruciform)

	var/list/data = list(
		"refmode" = reference_mode,
		"hasref" = has_reference
	)

	if(!CI)
		data69"noimplant"69 = TRUE
		return data

	var/list/ritual_data = list()
	var/list/category_data = list()

	for(var/RT in CI.known_rituals)
		var/datum/ritual/R = GLOB.all_rituals69RT69

		if(!(R.category in category_data))
			category_data.Add(R.category)

		if(current_category != "" && current_category != R.category)
			continue

		if(R.phrase)
			var/list/L = list(
				"name" = capitalize(R.name),
				"desc" = R.desc,
				"type" = "69RT69"
			)

			if(istype(R, /datum/ritual/group))
				L69"group"69 = TRUE

				var/datum/ritual/group/GR = R
				var/list/P = list()
				for(var/i = 1; i <= GR.phrases.len; i++)
					P.Add(list(list("ind" = i, "phrase" = GR.phrases69i69, "type" = "69RT69")))

				L69"phrases"69 = P

			else
				L69"group"69 = FALSE
				L69"phrase"69 = R.get_display_phrase()

			ritual_data.Add(list(L))

	data69"rituals"69 = ritual_data
	data69"categories"69 = category_data

	data69"firstcat"69 = ""
	if(category_data.len)
		data69"firstcat"69 = category_data69169

	data69"currcat"69 = current_category
	data69"currexp"69 = expanded_group

	return data


/obj/item/book/ritual/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	var/list/data = ui_data(user, ui_key)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "ritual_book.tmpl", "Bible", 550, 655)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()


/obj/item/book/ritual/interact(mob/living/carbon/human/H)
	ui_interact(H)


/obj/item/book/ritual/Topic(href, href_list)
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr
	if(H.stat)
		return

	var/obj/item/implant/core_implant/cruciform/CI = H.get_core_implant(/obj/item/implant/core_implant/cruciform)

	if(href_list69"set_category"69)
		current_category = href_list69"set_category"69

	if(href_list69"unfold"69)
		expanded_group = href_list69"unfold"69

	if(href_list69"say"69 || href_list69"say_group"69)
		var/incantation = ""
		if(!CI)
			return

		for(var/RT in CI.known_rituals)

			if("69RT69" == href_list69"say"69)
				var/datum/ritual/R = GLOB.all_rituals69RT69
				incantation = R.get_say_phrase()
				break
			if("69RT69" == href_list69"say_group"69)
				var/ind = text2num(href_list69"say_id"69)
				var/datum/ritual/group/R = GLOB.all_rituals69RT69
				incantation = R.get_group_say_phrase(ind)
				break
		if (incantation != "")
			//Speaking a long phrase takes a little time
			if (do_after(H, length(incantation)*0.25))
				H.say(incantation)
	return TRUE
