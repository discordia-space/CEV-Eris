/obj/machinery/autolathe_disk_cloner
	name = "Autolathe disk cloner"
	desc = "Machine used for copying recipes from unprotected autolathe disks."
	icon_state = "disk_cloner"
	circuit = /obj/item/weapon/circuitboard/autolathe_disk_cloner
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 500

	var/hacked = FALSE
	var/copying_delay = 0
	var/hack_fail_chance = 0

	var/obj/item/weapon/disk/autolathe_disk/original = null
	var/obj/item/weapon/disk/autolathe_disk/copy = null

	var/copying = FALSE


/obj/machinery/autolathe_disk_cloner/New()
	..()
	update_icon()

/obj/machinery/autolathe_disk_cloner/RefreshParts()
	..()
	var/laser_rating = 0
	var/scanner_rating = 0
	for(var/obj/item/weapon/stock_parts/scanning_module/SM in component_parts)
		scanner_rating += SM.rating
	for(var/obj/item/weapon/stock_parts/micro_laser/ML in component_parts)
		laser_rating += ML.rating

	if(scanner_rating+laser_rating >= 9)
		copying_delay = 10
	else if(scanner_rating+laser_rating >= 6)
		copying_delay = 20
	else
		copying_delay = 40

	hack_fail_chance = ((scanner_rating+laser_rating) >= 9) ? 20 : 40

	if(laser_rating >= 4 && scanner_rating >= 2)
		hacked = TRUE

/obj/machinery/autolathe_disk_cloner/attackby(var/obj/item/I, var/mob/user)
	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return

	if(panel_open)
		return

	if(istype(I,/obj/item/weapon/disk/autolathe_disk))
		if(!original)
			original = put_disk(I,user)
			user << SPAN_NOTICE("You put \the [I] into the first slot of [src].")
		else if(!copy)
			copy = put_disk(I,user)
			user << SPAN_NOTICE("You put \the [I] into the second slot of [src].")
		else
			user << SPAN_NOTICE("[src]'s slots is full.")

	user.set_machine(src)
	ui_interact(user)
	update_icon()


/obj/machinery/autolathe_disk_cloner/dismantle()
	if(original)
		original.forceMove(src.loc)
		original = null
	if(copy)
		copy.forceMove(src.loc)
		copy = null
	..()
	return TRUE

/obj/machinery/autolathe_disk_cloner/Process()
	update_icon()

/obj/machinery/autolathe_disk_cloner/proc/put_disk(var/obj/item/weapon/disk/autolathe_disk/AD, var/mob/user)
	ASSERT(istype(AD))

	user.unEquip(AD,src)
	return AD


/obj/machinery/autolathe_disk_cloner/attack_hand(mob/user as mob)
	if(..())
		return TRUE

	user.set_machine(src)
	ui_interact(user)
	update_icon()

/obj/machinery/autolathe_disk_cloner/ui_interact(mob/user, ui_key = "main",var/datum/nanoui/ui = null, var/force_open = 1)
	var/list/data = list()

	data["disk1"] = null
	data["disk2"] = null
	data["copying"] = copying
	data["hacked"] = hacked

	if(original)
		data["disk1"] = original.category
		data["disk1license"] = original.license

		var/list/R = list()

		for(var/r in original.recipes)
			var/datum/autolathe/recipe/recipe = autolathe_recipes[r]
			R.Add(recipe.name)

		data["disk1recipes"] = R

		data["copyingtotal"] = original.recipes.len

	if(copy)
		data["disk2"] = copy.category

		var/list/R = list()

		for(var/r in copy.recipes)
			var/datum/autolathe/recipe/recipe = autolathe_recipes[r]
			R.Add(recipe.name)

		data["disk2recipes"] = R

		data["copyingnow"] = copy.recipes.len

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "autolathe_disk_cloner.tmpl", "Autolathe disk cloner", 480, 555)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()

/obj/machinery/autolathe_disk_cloner/Topic(href, href_list)
	add_fingerprint(usr)

	usr.set_machine(src)

	if(href_list["start"])
		if(copying)
			copying = FALSE
		else
			copy()
		return

	if(href_list["eject"])
		var/mob/living/H = null
		var/obj/item/weapon/disk/autolathe_disk/D = null
		if(ishuman(usr))
			H = usr
			D = H.get_active_hand()

		if(href_list["eject"] == "f")
			if(original)
				original.forceMove(src.loc)
				if(H)
					H.put_in_active_hand(original)
				original = null
			else
				if(istype(D))
					H.drop_item()
					D.forceMove(src)
					original = D
		else
			if(copy)
				copy.forceMove(src.loc)
				if(H)
					H.put_in_active_hand(copy)
				copy = null
			else
				if(istype(D))
					H.drop_item()
					D.forceMove(src)
					copy = D

	nanomanager.update_uis(src)
	update_icon()


/obj/machinery/autolathe_disk_cloner/proc/copy()
	copying = TRUE
	nanomanager.update_uis(src)
	update_icon()
	if(original && copy && !copy.recipes.len && (hacked || original.license < 0))
		if(!hacked)
			copy.category = "[original.category] \[copy\]"
			copy.name = "[original.name] copy"
		else
			copy.category = original.category
			copy.name = original.name

		for(var/r in original.recipes)
			if(!(original && copy) || !copying)
				break

			if(original.license < 0)
				copy.recipes.Add(r)
			else
				if(hacked)
					if(prob(hack_fail_chance))
						copy.recipes.Add(/datum/autolathe/recipe/corrupted)
					else
						copy.recipes.Add(r)
				else
					break

			nanomanager.update_uis(src)
			update_icon()
			sleep(copying_delay)

	copying = FALSE
	nanomanager.update_uis(src)
	update_icon()


/obj/machinery/autolathe_disk_cloner/update_icon()
	overlays.Cut()

	if(panel_open)
		overlays.Add(image(icon, icon_state = "disk_cloner_panel"))

	if(!stat)
		overlays.Add(image(icon, icon_state = "disk_cloner_screen"))
		overlays.Add(image(icon, icon_state = "disk_cloner_keyboard"))

		if(original)
			overlays.Add(image(icon, icon_state = "disk_cloner_screen_disk1"))

			if(original.recipes.len)
				overlays.Add(image(icon, icon_state = "disk_cloner_screen_list1"))

		if(copy)
			overlays.Add(image(icon, icon_state = "disk_cloner_screen_disk2"))

			if(copy.recipes.len)
				overlays.Add(image(icon, icon_state = "disk_cloner_screen_list2"))

		if(copying)
			overlays.Add(image(icon, icon_state = "disk_cloner_cloning"))

