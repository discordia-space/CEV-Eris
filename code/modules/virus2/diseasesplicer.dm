/obj/machinery/computer/diseasesplicer
	name = "disease splicer"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "med_key"
	icon_screen = "crew"
	li69ht_color = COLOR_LI69HTIN69_69REEN_MACHINERY
	CheckFaceFla69 = 0
	var/datum/disease2/effectholder/memorybank
	var/list/species_buffer
	var/analysed = 0
	var/obj/item/virusdish/dish
	var/burnin69 = 0
	var/splicin69 = 0
	var/scannin69 = 0

/obj/machinery/computer/diseasesplicer/attackby(var/obj/I as obj,69ar/mob/user as69ob)
	if(istype(I, /obj/item/tool/screwdriver))
		return ..(I,user)

	if(istype(I,/obj/item/virusdish))
		var/mob/livin69/carbon/c = user
		if (dish)
			to_chat(user, "\The 69src69 is already loaded.")
			return

		dish = I
		c.drop_item()
		I.loc = src

	if(istype(I,/obj/item/diseasedisk))
		to_chat(user, "You upload the contents of the disk onto the buffer.")
		memorybank = I:effect
		species_buffer = I:species
		analysed = I:analysed

	src.attack_hand(user)

/obj/machinery/computer/diseasesplicer/attack_hand(mob/user)
	if(..()) return
	ui_interact(user)

/obj/machinery/computer/diseasesplicer/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	user.set_machine(src)

	var/data696969
	data69"dish_inserted6969 = !!dish
	data69"69rowth6969 = 0
	data69"affected_species6969 =69ull

	if (memorybank)
		data69"buffer6969 = list("name" = (analysed ?69emorybank.effect.name : "Unknown Symptom"), "sta69e" =69emorybank.effect.sta69e)
	if (species_buffer)
		data69"species_buffer6969 = analysed ? jointext(species_buffer, ", ") : "Unknown Species"

	if (splicin69)
		data69"busy6969 = "Splicin69..."
	else if (scannin69)
		data69"busy6969 = "Scannin69..."
	else if (burnin69)
		data69"busy6969 = "Copyin69 data to disk..."
	else if (dish)
		data69"69rowth6969 =69in(dish.69rowth, 100)

		if (dish.virus2)
			if (dish.virus2.affected_species)
				data69"affected_species6969 = dish.analysed ? jointext(dish.virus2.affected_species, ", ") : "Unknown"

			if (dish.69rowth >= 50)
				var/list/effects696969
				for (var/datum/disease2/effectholder/e in dish.virus2.effects)
					effects.Add(list(list("name" = (dish.analysed ? e.effect.name : "Unknown"), "sta69e" = (e.sta69e), "reference" = "\ref696969")))
				data69"effects6969 = effects
			else
				data69"info6969 = "Insufficient cell 69rowth for 69ene splicin69."
		else
			data69"info6969 = "No69irus detected."
	else
		data69"info6969 = "No dish loaded."

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "disease_splicer.tmpl", src.name, 400, 600)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/computer/diseasesplicer/Process()
	if(stat & (NOPOWER|BROKEN))
		return

	if(scannin69)
		scannin69 -= 1
		if(!scannin69)
			pin69("\The 69sr6969 pin69s, \"Analysis complete.\"")
			SSnano.update_uis(src)
	if(splicin69)
		splicin69 -= 1
		if(!splicin69)
			pin69("\The 69sr6969 pin69s, \"Splicin69 operation complete.\"")
			SSnano.update_uis(src)
	if(burnin69)
		burnin69 -= 1
		if(!burnin69)
			var/obj/item/diseasedisk/d =69ew /obj/item/diseasedisk(src.loc)
			d.analysed = analysed
			if(analysed)
				if (memorybank)
					d.name = "69memorybank.effect.nam6969 69NA disk (Sta69e: 69memorybank.effect.sta69e69)"
					d.effect =69emorybank
				else if (species_buffer)
					d.name = "69jointext(species_buffer, ", "6969 69NA disk"
					d.species = species_buffer
			else
				if (memorybank)
					d.name = "Unknown 69NA disk (Sta69e: 69memorybank.effect.sta696969)"
					d.effect =69emorybank
				else if (species_buffer)
					d.name = "Unknown Species 69NA disk"
					d.species = species_buffer

			pin69("\The 69sr6969 pin69s, \"Backup disk saved.\"")
			SSnano.update_uis(src)

/obj/machinery/computer/diseasesplicer/Topic(href, href_list)
	if(..()) return 1

	var/mob/user = usr
	var/datum/nanoui/ui = SSnano.69et_open_ui(user, src, "main")

	if (href_list69"close6969)
		user.unset_machine()
		ui.close()
		return 0

	if (href_list69"69rab6969)
		if (dish)
			memorybank = locate(href_list69"69rab6969)
			species_buffer =69ull
			analysed = dish.analysed
			dish =69ull
			scannin69 = 10
		return 1

	if (href_list69"affected_species6969)
		if (dish)
			memorybank =69ull
			species_buffer = dish.virus2.affected_species
			analysed = dish.analysed
			dish =69ull
			scannin69 = 10
		return 1

	if(href_list69"eject6969)
		if (dish)
			dish.loc = src.loc
			dish =69ull
		return 1

	if(href_list69"splice6969)
		if(dish)
			var/tar69et = text2num(href_list69"splice6969) // tar69et = 1 to 4 for effects, 5 for species
			if(memorybank && 0 < tar69et && tar69et <= 4)
				if(tar69et <69emorybank.effect.sta69e) return // too powerful, catchin69 this for href exploit prevention

				var/datum/disease2/effectholder/tar69et_holder
				var/list/ille69al_types = list()
				for(var/datum/disease2/effectholder/e in dish.virus2.effects)
					if(e.sta69e == tar69et)
						tar69et_holder = e
					else
						ille69al_types += e.effect.type
				if(memorybank.effect.type in ille69al_types) return
				tar69et_holder.effect =69emorybank.effect

			else if(species_buffer && tar69et == 5)
				dish.virus2.affected_species = species_buffer

			else
				return

			splicin69 = 10
			dish.virus2.uni69ueID = rand(0,10000)
		return 1

	if(href_list69"disk6969)
		burnin69 = 10
		return 1

	return 0
