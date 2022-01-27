/datum/computer_file/program/forceauthorization
	filename = "forceauthorization"
	filedesc = "Use of Force Authorization69anager"
	extended_desc = "Control console used to activate the69T1019 authorization chip."
	size = 4
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP
	program_icon_state = "security"
	program_menu_icon = "locked"
	requires_ntnet = 1
	available_on_ntnet = 1
	required_access = access_armory
	nanomodule_path = /datum/nano_module/forceauthorization/

/datum/nano_module/forceauthorization/
	name = "Use of Force Authorization69anager"

/datum/nano_module/forceauthorization/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	data69"is_silicon_usr"69 = issilicon(user)

	data69"guns"69 = list()
	var/atom/movable/AM =69ano_host()
	if(!istype(AM))
		return
	//var/list/zlevels = GetConnectedZlevels(AM.z)
	/*for(var/obj/item/gun/G in GLOB.registered_weapons)
		if(G.standby)
			continue
		var/turf/T = get_turf(G)
		if(!T || !(T.z in zlevels))
			continue

		var/list/modes = list()
		for(var/i = 1 to G.firemodes.len)
			if(G.authorized_modes69i69 == ALWAYS_AUTHORIZED)
				continue
			var/datum/firemode/firemode = G.firemodes69i69
			modes += list(list("index" = i, "mode_name" = firemode.name, "authorized" = G.authorized_modes69i69))

		data69"guns"69 += list(list("name" = "69G69", "ref" = "\ref69G69", "owner" = G.registered_owner, "modes" =69odes, "loc" = list("x" = T.x, "y" = T.y, "z" = T.z)))
	*/
	var/list/guns = data69"guns"69
	if(!guns.len)
		data69"message"69 = "No weapons registered"

	if(!data69"is_silicon_usr"69) // don't send data even though they won't be able to see it
		data69"cyborg_guns"69 = list()
		/*
		for(var/obj/item/gun/energy/gun/secure/mounted/G in GLOB.registered_cyborg_weapons)
			var/list/modes = list() // we don't get location, unlike inside of the last loop, because borg locations are reported elsewhere.
			for(var/i = 1 to G.firemodes.len)
				if(G.authorized_modes69i69 == ALWAYS_AUTHORIZED)
					continue
				var/datum/firemode/firemode = G.firemodes69i69
				modes += list(list("index" = i, "mode_name" = firemode.name, "authorized" = G.authorized_modes69i69))

			data69"cyborg_guns"69 += list(list("name" = "69G69", "ref" = "\ref69G69", "owner" = G.registered_owner, "modes" =69odes))
		*/
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "forceauthorization.tmpl",69ame, 700, 450, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/forceauthorization/Topic(href, href_list)
	if(..())
		return 1

	/*if(href_list69"gun"69 && ("authorize" in href_list) && href_list69"mode"69)
		var/obj/item/gun/G = locate(href_list69"gun"69) in GLOB.registered_weapons
		var/do_authorize = text2num(href_list69"authorize"69)
		var/mode = text2num(href_list69"mode"69)
		return isnum(do_authorize) && isnum(mode) && G && G.authorize(mode, do_authorize, usr.name)

	if(href_list69"cyborg_gun"69 && ("authorize" in href_list) && href_list69"mode"69)
		var/obj/item/gun/energy/gun/secure/mounted/M = locate(href_list69"cyborg_gun"69) in GLOB.registered_cyborg_weapons
		var/do_authorize = text2num(href_list69"authorize"69)
		var/mode = text2num(href_list69"mode"69)
		return isnum(do_authorize) && isnum(mode) &&69 &&69.authorize(mode, do_authorize, usr.name)

	return 0
	*/
