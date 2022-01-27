/obj/machinery/biogenerator
	name = "Biogenerator"
	desc = ""
	icon = 'icons/obj/biogenerator.dmi'
	icon_state = "biogen-stand"
	density = TRUE
	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 40
	var/processing = 0
	var/obj/item/reagent_containers/glass/beaker = null
	var/points = 0
	var/menustat = "menu"
	var/build_eff = 1
	var/eat_eff = 1


	var/list/recipes = list(
		"Food",
			list(name="Milk, 30u", cost=60, reagent="milk"),
			list(name="Slab of69eat", cost=50, path=/obj/item/reagent_containers/food/snacks/meat),
			list(name="Box of eggs", cost=200, path=/obj/item/storage/fancy/egg_box),
		"Nutrient",
			list(name="EZ-Nutrient, 30u", cost=30, reagent="eznutrient"),
			list(name="Left4Zed, 30u", cost=60, reagent="left4zed"),
			list(name="Robust Harvest, 30u", cost=75, reagent="robustharvest"),
		"Leather",
			list(name="Wallet", cost=100, path=/obj/item/storage/wallet),
			list(name="Botanical gloves", cost=250, path=/obj/item/clothing/gloves/botanic_leather),
			list(name="Utility belt", cost=300, path=/obj/item/storage/belt/utility),
			list(name="Leather Satchel", cost=400, path=/obj/item/storage/backpack/satchel),
			list(name="Leather jacket", cost=400, /obj/item/clothing/suit/storage/leather_jacket),
			list(name="Cash Bag", cost=400, path=/obj/item/storage/bag/money),
			list(name="Medical belt", cost=300, path=/obj/item/storage/belt/medical),
			list(name="Tactical belt", cost=300, path=/obj/item/storage/belt/tactical),
			list(name="EMT belt", cost=300, path=/obj/item/storage/belt/medical/emt),
			list(name="Champion belt", cost=500, path=/obj/item/storage/belt/champion),
		"Medicine",
			list(name="Medical splints", cost=100, path=/obj/item/stack/medical/splint),
			list(name="Roll of gauze", cost=100, path=/obj/item/stack/medical/bruise_pack),
			list(name="Ointment", cost=100, path=/obj/item/stack/medical/ointment),
			list(name="Advanced trauma kit", cost=200, path=/obj/item/stack/medical/advanced/bruise_pack),
			list(name="Advanced burn kit", cost=200, path=/obj/item/stack/medical/advanced/ointment),
	)


/obj/machinery/biogenerator/New()
	..()
	create_reagents(1000)
	beaker = new /obj/item/reagent_containers/glass/beaker/large(src)


/obj/machinery/biogenerator/on_reagent_change()			//When the reagents change, change the icon as well.
	update_icon()

/obj/machinery/biogenerator/update_icon()
	if(!beaker)
		icon_state = "biogen-empty"
	else if(!processing)
		icon_state = "biogen-stand"
	else
		icon_state = "biogen-work"
	return

/obj/machinery/biogenerator/attackby(var/obj/item/I,69ar/mob/user)

	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return
	if(istype(I, /obj/item/reagent_containers/glass))
		if(beaker)
			to_chat(user, SPAN_NOTICE("The 69src69 is already loaded."))
		else
			user.remove_from_mob(I)
			I.loc = src
			beaker = I
			updateUsrDialog()
	else if(processing)
		to_chat(user, SPAN_NOTICE("\The 69src69 is currently processing."))
	else if(istype(I, /obj/item/storage/bag/produce))
		var/i = 0
		for(var/obj/item/reagent_containers/food/snacks/grown/G in contents)
			i++
		if(i >= 10)
			to_chat(user, SPAN_NOTICE("\The 69src69 is already full! Activate it."))
		else
			for(var/obj/item/reagent_containers/food/snacks/grown/G in I.contents)
				G.loc = src
				i++
				if(i >= 10)
					to_chat(user, SPAN_NOTICE("You fill \the 69src69 to its capacity."))
					break
			if(i < 10)
				to_chat(user, SPAN_NOTICE("You empty \the 69I69 into \the 69src69."))


	else if(!istype(I, /obj/item/reagent_containers/food/snacks/grown))
		to_chat(user, SPAN_NOTICE("You cannot put this in \the 69src69."))
	else
		var/i = 0
		for(var/obj/item/reagent_containers/food/snacks/grown/G in contents)
			i++
		if(i >= 10)
			to_chat(user, SPAN_NOTICE("\The 69src69 is full! Activate it."))
		else
			user.remove_from_mob(I)
			I.loc = src
			to_chat(user, SPAN_NOTICE("You put \the 69I69 in \the 69src69"))
	update_icon()
	return

/obj/machinery/biogenerator/ui_interact(var/mob/user,69ar/ui_key = "main",69ar/datum/nanoui/ui = null,69ar/force_open = NANOUI_FOCUS,69ar/datum/topic_state/state =GLOB.outside_state)
	user.set_machine(src)
	var/list/data = list()
	data69"points"69 = points
	if(menustat == "menu")
		data69"beaker"69 = beaker
		if(beaker)

			var/list/tmp_recipes = list()
			for(var/smth in recipes)
				if(istext(smth))
					tmp_recipes += list(list(
						"is_category" = 1,
						"name" = smth,
					))
				else
					var/list/L = smth
					tmp_recipes += list(list(
						"is_category" = 0,
						"name" = L69"name"69,
						"cost" = round(L69"cost"69/build_eff),
						"allow_multiple" = L69"allow_multiple"69,
					))

			data69"recipes"69 = tmp_recipes

	data69"processing"69 = processing
	data69"menustat"69 =69enustat
	if(menustat == "menu")
		data69"beaker"69 = beaker

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "biogenerator.tmpl", "Biogenerator", 550, 655)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()

/obj/machinery/biogenerator/attack_hand(mob/user as69ob)
	if(..())
		return TRUE

	user.set_machine(src)
	ui_interact(user)

/obj/machinery/biogenerator/proc/activate()
	if (usr.stat)
		return
	if (stat) //NOPOWER etc
		return
	if(processing)
		to_chat(usr, SPAN_NOTICE("The biogenerator is in the process of working."))
		return
	var/S = 0
	for(var/obj/item/reagent_containers/food/snacks/grown/I in contents)
		S += 5
		if(I.reagents.get_reagent_amount("nutriment") < 0.1)
			points += 1
		else points += I.reagents.get_reagent_amount("nutriment") * 8 * eat_eff
		69del(I)
	if(S)
		processing = 1
		update_icon()
		updateUsrDialog()
		playsound(src.loc, 'sound/machines/blender.ogg', 50, 1)
		use_power(S * 30)
		sleep((S + 15) / eat_eff)
		processing = 0
		update_icon()
	else
		menustat = "void"
	return

/obj/machinery/biogenerator/proc/create_product(var/item,69ar/amount)
	var/list/recipe = null
	if(processing)
		return

	for(var/list/R in recipes)
		if(R69"name"69 == item)
			recipe = R
			break
	if(!recipe)
		return

	if(!("allow_multiple" in recipe))
		amount = 1
	else
		amount =69ax(amount, 1)

	var/cost = recipe69"cost"69 * amount / build_eff

	if(cost > points)
		menustat = "nopoints"
		return 0

	processing = 1
	update_icon()
	updateUsrDialog() //maybe we can remove it
	points -= cost
	sleep(cost*0.5)

	var/creating = recipe69"path"69
	var/reagent = recipe69"reagent"69
	if(reagent) //For reagents like69ilk
		beaker.reagents.add_reagent(reagent, 30)
	else
		for(var/i in 1 to amount)
			new creating(loc)
	processing = 0
	menustat = "complete"
	update_icon()
	return 1

/obj/machinery/biogenerator/Topic(href, href_list)
	if(stat & BROKEN) return
	if(usr.stat || usr.restrained()) return
	if(!in_range(src, usr)) return
	usr.set_machine(src)

	switch(href_list69"action"69)
		if("activate")
			activate()
		if("detach")
			if(beaker)
				beaker.loc = src.loc
				beaker = null
				update_icon()
		if("create")
			create_product(href_list69"item"69, text2num(href_list69"amount"69))
		if("menu")
			menustat = "menu"
	updateUsrDialog()

/obj/machinery/biogenerator/RefreshParts()
	..()
	var/man_rating = 0
	var/bin_rating = 0

	for(var/obj/item/stock_parts/P in component_parts)
		if(istype(P, /obj/item/stock_parts/matter_bin))
			bin_rating += P.rating
		if(istype(P, /obj/item/stock_parts/manipulator))
			man_rating += P.rating

	build_eff =69an_rating
	eat_eff = bin_rating
