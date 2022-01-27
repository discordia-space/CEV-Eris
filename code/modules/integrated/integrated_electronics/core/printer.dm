GLOBAL_LIST_EMPTY(circuit_fabricator_recipe_list)

/hook/startup/proc/populate_circuit_fabricator_recipe_list()
	for(var/path in typesof(/obj/item/integrated_circuit))
		var/obj/item/integrated_circuit/IC = path

		if(!(initial(IC.spawn_flags) & (IC_SPAWN_DEFAULT | IC_SPAWN_RESEARCH)))
			continue

		var/category = initial(IC.category_text)
		if(!GLOB.circuit_fabricator_recipe_list69category69)
			GLOB.circuit_fabricator_recipe_list69category69 = list()
		var/list/category_list = GLOB.circuit_fabricator_recipe_list69category69
		category_list += IC // Populating the fabricator categories


	GLOB.circuit_fabricator_recipe_list69"Assemblies"69 = list(
		/obj/item/device/electronic_assembly,
		/obj/item/device/electronic_assembly/medium,
		/obj/item/device/electronic_assembly/large,
		/obj/item/device/electronic_assembly/drone,
		/obj/item/implant/integrated_circuit
		)

	GLOB.circuit_fabricator_recipe_list69"Tools"69 = list(
		/obj/item/device/electronics/integrated/wirer,
		/obj/item/device/electronics/integrated/debugger
		)



/obj/item/device/electronics/integrated/integrated_circuit_printer
	name = "integrated circuit printer"
	desc = "A portable(ish)69achine69ade to print tiny69odular circuitry out of69etal."
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "circuit_printer"
	w_class = ITEM_SIZE_BULKY
	var/metal = 0
	var/max_metal = 100
	var/metal_per_sheet = 10 // One sheet equals this69uch69etal.
	var/debug = FALSE // If true,69etal is infinite.

	matter = list(MATERIAL_STEEL = 5,69ATERIAL_GLASS = 3,69ATERIAL_SILVER = 3)

	var/upgraded = FALSE		// When hit with an upgrade disk, will turn true, allowing it to print the higher tier circuits.
	var/current_category = null
	var/obj/item/device/electronic_assembly/assembly_to_clone = null

/obj/item/device/electronics/integrated/integrated_circuit_printer/upgraded
	upgraded = TRUE

/obj/item/device/electronics/integrated/integrated_circuit_printer/debug
	name = "fractal integrated circuit printer"
	desc = "A portable(ish)69achine that69akes69odular circuitry seemingly out of thin air."
	upgraded = TRUE
	debug = TRUE
	spawn_blacklisted = TRUE

/obj/item/device/electronics/integrated/integrated_circuit_printer/attack_robot(mob/user as69ob)
	if(Adjacent(user))
		return interact(user)
	else
		return ..()

/obj/item/device/electronics/integrated/integrated_circuit_printer/attackby(var/obj/item/O,69ar/mob/user)
	if(istype(O,/obj/item/stack/material))
		var/obj/item/stack/material/stack = O
		if(stack.material.name ==69ATERIAL_STEEL)
			if(debug)
				to_chat(user, span("warning", "\The 69src69 does not need any69aterial."))
				return
			var/num =69in((max_metal -69etal) /69etal_per_sheet, stack.amount)
			if(num < 1)
				to_chat(user, span("warning", "\The 69src69 is too full to add69ore69etal."))
				return
			if(stack.use(max(1, round(num)))) // We don't want to create stacks that aren't whole numbers
				to_chat(user, span("notice", "You add 69num69 sheet\s to \the 69src69."))
				metal += num *69etal_per_sheet
				interact(user)
				return TRUE

	if(istype(O,/obj/item/integrated_circuit))
		to_chat(user, span("notice", "You insert the circuit into \the 69src69."))
		user.unEquip(O)
		metal =69in(metal + O.w_class,69ax_metal)
		qdel(O)
		interact(user)
		return TRUE

	if(istype(O,/obj/item/disk/integrated_circuit/upgrade/advanced))
		if(upgraded)
			to_chat(user, span("warning", "\The 69src69 already has this upgrade."))
			return TRUE
		to_chat(user, span("notice", "You install \the 69O69 into  \the 69src69."))
		upgraded = TRUE
		interact(user)
		return TRUE

	return ..()

/obj/item/device/electronics/integrated/integrated_circuit_printer/attack_self(var/mob/user)
	interact(user)

/obj/item/device/electronics/integrated/integrated_circuit_printer/interact(mob/user)
	var/window_height = 600
	var/window_width = 500

	if(isnull(current_category))
		current_category = GLOB.circuit_fabricator_recipe_list69169

	var/HTML = "<center><h2>Integrated Circuit Printer</h2></center><br>"
	if(!debug)
		HTML += "Metal: 69metal/metal_per_sheet69/69max_metal/metal_per_sheet69 sheets.<br>"
	else
		HTML += "Metal: INFINITY.<br>"
	HTML += "Circuits available: 69upgraded ? "Advanced":"Regular"69.<br>"

	HTML += "Crossed out circuits69ean that the printer is not sufficentally upgraded to create that circuit.<br>"
	HTML += "<hr>"
	HTML += "Categories:"
	for(var/category in GLOB.circuit_fabricator_recipe_list)
		if(category != current_category)
			HTML += " <a href='?src=\ref69src69;category=69category69'>\6969category69\69</a> "
		else // Bold the button if it's already selected.
			HTML += " <b>\6969category69\69</b> "
	HTML += "<hr>"
	HTML += "<center><h4>69current_category69</h4></center>"

	var/list/current_list = GLOB.circuit_fabricator_recipe_list69current_category69
	for(var/path in current_list)
		var/obj/O = path
		var/can_build = TRUE
		if(ispath(path, /obj/item/integrated_circuit))
			var/obj/item/integrated_circuit/IC = path
			if((initial(IC.spawn_flags) & IC_SPAWN_RESEARCH) && (!(initial(IC.spawn_flags) & IC_SPAWN_DEFAULT)) && !upgraded)
				can_build = FALSE
		if(can_build)
			HTML += "<A href='?src=\ref69src69;build=69path69'>\6969initial(O.name)69\69</A>: 69initial(O.desc)69<br>"
		else
			HTML += "<s>\6969initial(O.name)69\69</s>: 69initial(O.desc)69<br>"

	user << browse(jointext(HTML, null), "window=integrated_printer;size=69window_width69x69window_height69;border=1;can_resize=1;can_close=1;can_minimize=1")


/obj/item/device/electronics/integrated/integrated_circuit_printer/Topic(href, href_list)
	if(..())
		return 1

	add_fingerprint(usr)

	if(href_list69"category"69)
		current_category = href_list69"category"69

	if(href_list69"build"69)
		var/build_type = text2path(href_list69"build"69)
		if(!build_type || !ispath(build_type))
			return 1

		var/cost = 1

		if(isnull(current_category))
			current_category = GLOB.circuit_fabricator_recipe_list69169
		if(ispath(build_type, /obj/item/device/electronic_assembly))
			var/obj/item/device/electronic_assembly/E = build_type
			cost = round( (initial(E.max_complexity) + initial(E.max_components) ) / 4)
		else
			var/obj/item/I = build_type
			cost = initial(I.w_class)
		if(!(build_type in GLOB.circuit_fabricator_recipe_list69current_category69))
			return

		if(!debug)
			if(!Adjacent(usr))
				to_chat(usr, "<span class='notice'>You are too far away from \the 69src69.</span>")
			if(metal - cost < 0)
				to_chat(usr, "<span class='warning'>You need 69cost6969etal to build that!.</span>")
				return 1
			metal -= cost
		var/obj/item/built = new build_type(get_turf(loc))
		usr.put_in_hands(built)
		to_chat(usr, "<span class='notice'>69capitalize(built.name)69 printed.</span>")
		playsound(src, 'sound/items/Deconstruct.ogg', 50, TRUE)

	interact(usr)


// FUKKEN UPGRADE DISKS
/obj/item/disk/integrated_circuit/upgrade
	name = "integrated circuit printer upgrade disk"
	desc = "Install this into your integrated circuit printer to enhance it."
	icon = 'icons/obj/electronic_assemblies.dmi'
	icon_state = "upgrade_disk"
	item_state = "card-id"
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 4)

/obj/item/disk/integrated_circuit/upgrade/advanced
	name = "integrated circuit printer upgrade disk - advanced designs"
	desc = "Install this into your integrated circuit printer to enhance it.  This one adds new, advanced designs to the printer."

