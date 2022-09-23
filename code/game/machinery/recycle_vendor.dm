/obj/machinery/recycle_vendor
	name = "recycling vendor"
	desc = "Recycle today for a better tomorrow!"
	icon = 'icons/obj/vending.dmi'
	icon_state = "recycle"
	layer = BELOW_OBJ_LAYER
	anchored = TRUE
	density = TRUE
	use_power = IDLE_POWER_USE

	// Can't use subtypeof(), since we have lots of retarded materials
	var/list/materials_supported = list(
		MATERIAL_STEEL,
		MATERIAL_GLASS,
		MATERIAL_PLASTIC,
		MATERIAL_WOOD,
		MATERIAL_SILVER,
		MATERIAL_GOLD,
		MATERIAL_URANIUM,
		MATERIAL_CARDBOARD,
		MATERIAL_PLASMA,
		MATERIAL_PLATINUM,
		MATERIAL_PLASTEEL,
		MATERIAL_DIAMOND)
	var/list/materials_allowed = list()
	var/list/materials_stored = list()
	var/list/stored_item_materials = list()
	var/obj/item/stored_item_object = null
	var/stored_item_value = 0
	var/stored_item_fluff = ""
	var/sales_paused = FALSE
	var/vagabond_charity_budget = 2000
	var/datum/money_account/merchants_pocket
	var/datum/wires/recycle_vendor/wires
	var/wire_flags = 0


/obj/machinery/recycle_vendor/New(loc, ...)
	. = ..()
	materials_allowed = materials_supported.Copy()
	wires = new(src)
	update_icon()


/obj/machinery/recycle_vendor/Destroy()
	qdel(wires)
	eject_stored_materials()
	eject_stored_item()
	..()


/obj/machinery/recycle_vendor/update_icon()
	SSnano.update_uis(src)
	overlays.Cut()
	if(stat & BROKEN)
		icon_state = "recycle_broken"
		return

	icon_state = "recycle"

	if(stat & NOPOWER || !anchored)
		return

	overlays += sales_paused || !materials_allowed.len	? "recycle_screen_red"			: "recycle_screen_green"
	overlays += materials_stored.len					? "recycle_button_top_green"	: "recycle_button_top_red"
	overlays += vagabond_charity_budget > 500			? "recycle_button_bottom_green"	: "recycle_button_bottom_red"

	if(panel_open)
		overlays += "recycle_panel"


/obj/machinery/recycle_vendor/attackby(obj/item/I, mob/living/user)
	if(user.incapacitated() || user.stat || !user.Adjacent(user))
		// TODO: Standardized check for that kind of stuff -- KIROV
		return

	if(BITTEST(wire_flags, WIRE_SHOCK) && shock(user, 100))
		return

	if(user.a_intent != I_HURT)
		var/tool_type = I.get_tool_type(user, list(QUALITY_BOLT_TURNING, QUALITY_SCREW_DRIVING), src)
		switch(tool_type)
			if(QUALITY_BOLT_TURNING)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You [anchored? "un" : ""]secured \the [src]!"))
					anchored = !anchored
				return

			if(QUALITY_SCREW_DRIVING)
				var/used_sound = panel_open ? 'sound/machines/Custom_screwdriveropen.ogg' :  'sound/machines/Custom_screwdriverclose.ogg'
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC, instant_finish_tier = 30, forced_sound = used_sound))
					panel_open = !panel_open
					to_chat(user, SPAN_NOTICE("You [panel_open ? "open" : "close"] the maintenance panel."))
					update_icon()
				return

	if(stored_item_object || sales_paused || !user.unEquip(I))
		return

	I.forceMove(src)
	stored_item_object = I
	evaluate_stored_item()
	update_icon()


/obj/machinery/recycle_vendor/power_change()
	..()
	update_icon()


/obj/machinery/recycle_vendor/attack_hand(mob/user)
	if(user.incapacitated() || user.stat || !user.Adjacent(user))
		return

	if(BITTEST(wire_flags, WIRE_SHOCK) && shock(user, 100))
		return

	wires.Interact(user)
	nano_ui_interact(user)


/obj/machinery/recycle_vendor/AltClick(mob/user)
	if(user.incapacitated() || user.stat || !user.Adjacent(user))
		return

	eject_stored_item()


/obj/machinery/recycle_vendor/proc/eject_stored_item()
	if(stored_item_object)
		stored_item_object.forceMove(loc)
		stored_item_object = null
		flick("recycle_vend", src)
		update_icon()


/obj/machinery/recycle_vendor/proc/eject_stored_materials(material_type)
	if(material_type)
		var/material/M = get_material_by_name(material_type)
		new M.stack_type(loc, materials_stored[material_type])
		materials_stored -= material_type
	else
		for(var/i in materials_stored)
			var/material/M = get_material_by_name(i)
			new M.stack_type(loc, materials_stored[i])
		materials_stored.Cut()

	flick("recycle_vend", src)
	update_icon()


/obj/machinery/recycle_vendor/proc/evaluate_stored_item()
	stored_item_value = 0
	stored_item_fluff = "Material composition:"
	stored_item_materials = stored_item_object.get_matter()

	if(stored_item_object.contents.len)	// Storage items are too resource intensive to check (populate_contents() means we have to create new instances of every object within the initial object)
		stored_item_fluff += "<br>ERROR Storage Item Nesting Detected."
		return

	for(var/i in stored_item_materials)
		if(i in materials_supported)
			if(i in materials_allowed)
				var/material/M = get_material_by_name(i)
				var/obj/item/stack/material/S = new M.stack_type(null, stored_item_materials[i])
				stored_item_value += round(S.get_item_cost(), 2) / 2
				stored_item_fluff += "<br>[i] - [stored_item_materials[i]] units, worth [round(S.get_item_cost(), 2) / 2] credits."
			else
				stored_item_fluff += "<br>Payouts for [i] suspended by Aster Guild representative."
		else // Bay leftover materials
			stored_item_fluff += "<br>[i] recycling is not supported."

	stored_item_fluff += "<br>Payout total: [stored_item_value] credits."


/obj/machinery/recycle_vendor/proc/recycle_and_pay()
	// That account doesn't exist on initialize, hence
	// cannot be assigned to pre-mapped vendor in sane manner
	if(!merchants_pocket)
		merchants_pocket = department_accounts[DEPARTMENT_GUILD]

	if(!stored_item_value || stored_item_value > vagabond_charity_budget || stored_item_value > merchants_pocket.money)
		flick("recycle_screen_red", overlays[1])
		return

	vagabond_charity_budget -= stored_item_value
	var/datum/transaction/T = new(-stored_item_value, "", "Recycling payout for [stored_item_object.name]", src)
	T.apply_to(merchants_pocket)

	qdel(stored_item_object)
	stored_item_object = null

	for(var/i in stored_item_materials)
		if(i in materials_supported)
			if(i in materials_stored)
				materials_stored[i] += stored_item_materials[i]
			else
				materials_stored.Add(i)
				materials_stored[i] = stored_item_materials[i]

	playsound(loc, pick('sound/items/polaroid1.ogg', 'sound/items/polaroid2.ogg'), 50, 1)
	spawn_money(stored_item_value, loc)
	flick("recycle_vend", src)
	update_icon()

	if(stored_item_value < 50 && prob(5))
		speak("Ты бы еще консервных банок насобирал!")


/obj/machinery/recycle_vendor/Process()
	if(stat & (BROKEN|NOPOWER))
		return

	if(!BITTEST(wire_flags, WIRE_SPEAKER) && prob(1)) // Flag is set when value is not default
		speak(pick(
			"Bitch, don\'t you wanna start making some real fucking money?!",
			"Recycle. Everybody\'s doing it.",
			"Recycling is the only option.",
			"Recycling is a cool thing to do.",
			"Recycling Rocks.",
			"I pity the fool who doesn\'t recycle."))

	if(BITTEST(wire_flags, WIRE_THROW) && prob(2))
		throw_item()


/obj/machinery/recycle_vendor/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED

	if(href_list["recycle_item"])
		recycle_and_pay()

	if(href_list["eject_item"])
		eject_stored_item()

	if(href_list["eject_materials"])
		eject_stored_materials()

	if(href_list["set_budget"])
		var/new_budget = text2num(input("Number in credits: ", "Set new payout budget"))
		if(new_budget)
			vagabond_charity_budget = new_budget

	if(href_list["allow_sales"])
		sales_paused = FALSE

	if(href_list["disallow_sales"])
		sales_paused = TRUE

	if(href_list["allow_material"])
		materials_allowed |= href_list["allow_material"]

	if(href_list["disallow_material"])
		materials_allowed -= href_list["disallow_material"]

	if(href_list["eject_material"])
		eject_stored_materials(href_list["eject_material"])

	update_icon()
	return TOPIC_REFRESH


/obj/machinery/recycle_vendor/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	var/list/data = list()
	var/list/user_access = user.GetAccess()

	data["budget"]			= vagabond_charity_budget
	data["sales_paused"]	= sales_paused
	data["access_level"]	= (BITTEST(wire_flags, WIRE_ID_SCAN) ? 0 : (user_access.Find(access_merchant) ? 2 : (user_access.Find(access_cargo) ? 1 : 0)))
	data["item_name"]		= null

	if(stored_item_object)
		data["item_name"]	= stored_item_object.name
		data["item_fluff"]	= stored_item_fluff

	var/list/material_info = list()
	for(var/i in materials_supported)
		material_info.Add(list(list(
			"name" = i,
			"is_allowed" = (materials_allowed.Find(i)),
			"is_stored" = (materials_stored.Find(i)))))

	data["materials"] = material_info

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "recycle_vendor.tmpl", name, 440, 650)
		ui.set_initial_data(data)
		ui.open()
