/obj/item/weapon/book/ritual
	name = "Rituals book"
	desc = "Contains rituals."
	icon = 'icons/obj/library.dmi'
	icon_state = "book"
	var/has_reference = FALSE

	var/expanded_group = null
	var/current_category = "Common"
	var/reference_mode = FALSE


/obj/item/weapon/book/ritual/attack_self(mob/living/carbon/human/H)
	playsound(src.loc, pick('sound/items/BOOK_Turn_Page_1.ogg',\
		'sound/items/BOOK_Turn_Page_2.ogg',\
		'sound/items/BOOK_Turn_Page_3.ogg',\
		'sound/items/BOOK_Turn_Page_4.ogg',\
		), rand(40,80), 1)
	interact(H)

/obj/item/weapon/book/ritual/ui_interact(mob/user, ui_key = "main",var/datum/nanoui/ui = null, var/force_open = NANOUI_FOCUS)
	var/obj/item/weapon/implant/core_implant/cruciform/CI = user.get_cruciform()

	var/data = list()
	data["noimplant"] = FALSE
	data["refmode"] = reference_mode
	data["hasref"] = has_reference

	if(CI && istype(CI))
		var/list/rdata = list()
		var/list/cdata = list()

		for(var/RT in CI.known_rituals)
			var/datum/ritual/R = GLOB.all_rituals[RT]


			if(!(R.category in cdata))
				cdata.Add(R.category)

			if(current_category != "" && current_category != R.category)
				continue

			if(R.phrase)
				if(istype(R,/datum/ritual/group))
					var/datum/ritual/group/GR = R

					var/list/L = list(
						"group" = TRUE,
						"name" = capitalize(R.name),
						"desc" = R.desc,
						"type" = "[R.name]",
					)

					var/list/P = list()
					for(var/i = 1; i <= GR.phrases.len; i++)
						P.Add(list(list("ind" = i, "phrase" = GR.phrases[i], "type" = "[RT]")))

					L["phrases"] = P
					rdata.Add(list(L))

				else
					var/list/L = list(
						"group" = FALSE,
						"name" = capitalize(R.name),
						"desc" = R.desc,
						"phrase" = R.get_display_phrase(),
						"type" = "[RT]",
					)


					rdata.Add(list(L))

		data["rituals"] = rdata
		data["categories"] = cdata

		data["firstcat"] = ""
		if(cdata.len >= 1)
			data["firstcat"] = cdata[1]

		data["currcat"] = current_category
		data["currexp"] = expanded_group

	else
		data["noimplant"] = TRUE



	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "ritual_book.tmpl", "Bible", 550, 655)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()


/obj/item/weapon/book/ritual/interact(mob/living/carbon/human/H)
	ui_interact(H)


/obj/item/weapon/book/ritual/Topic(href, href_list)
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr
	if(H.stat)
		return

	var/obj/item/weapon/implant/core_implant/cruciform/CI = H.get_cruciform()

	if(href_list["set_category"])
		current_category = href_list["set_category"]

	if(href_list["unfold"])
		expanded_group = href_list["unfold"]

	if(href_list["say"] || href_list["say_group"])
		var/incantation = ""
		for(var/RT in CI.known_rituals)

			if("[RT]" == href_list["say"])
				var/datum/ritual/R = GLOB.all_rituals[RT]
				incantation = R.get_say_phrase()
				break
			if("[RT]" == href_list["say_group"])
				var/ind = text2num(href_list["say_id"])
				var/datum/ritual/group/R = GLOB.all_rituals[RT]
				incantation = R.get_group_say_phrase(ind)
				break
		if (incantation != "")
			//Speaking a long phrase takes a little time
			if (do_after(H, length(incantation)*0.25))
				H.say(incantation)
	return TRUE
