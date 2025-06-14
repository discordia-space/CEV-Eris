//DEFINITIONS FOR ASSET DATUMS START HERE.

/datum/asset/simple/tgui
	keep_local_name = TRUE
	assets = list(
		"tgui.bundle.js" = file("tgui/public/tgui.bundle.js"),
		"tgui.bundle.css" = file("tgui/public/tgui.bundle.css"),
	)

/datum/asset/simple/tgui_panel
	keep_local_name = TRUE
	assets = list(
		"tgui-panel.bundle.js" = file("tgui/public/tgui-panel.bundle.js"),
		"tgui-panel.bundle.css" = file("tgui/public/tgui-panel.bundle.css"),
	)

/datum/asset/simple/namespaced/tgfont
	assets = list(
		"tgfont.eot" = file("tgui/packages/tgfont/static/tgfont.eot"),
		"tgfont.woff2" = file("tgui/packages/tgfont/static/tgfont.woff2"),
	)
	parents = list(
		"tgfont.css" = file("tgui/packages/tgfont/static/tgfont.css"),
	)

// /datum/asset/simple/headers
// 	assets = list(
// 		"alarm_green.gif" = 'icons/program_icons/alarm_green.gif',
// 		"alarm_red.gif" = 'icons/program_icons/alarm_red.gif',
// 		"batt_5.gif" = 'icons/program_icons/batt_5.gif',
// 		"batt_20.gif" = 'icons/program_icons/batt_20.gif',
// 		"batt_40.gif" = 'icons/program_icons/batt_40.gif',
// 		"batt_60.gif" = 'icons/program_icons/batt_60.gif',
// 		"batt_80.gif" = 'icons/program_icons/batt_80.gif',
// 		"batt_100.gif" = 'icons/program_icons/batt_100.gif',
// 		"charging.gif" = 'icons/program_icons/charging.gif',
// 		"downloader_finished.gif" = 'icons/program_icons/downloader_finished.gif',
// 		"downloader_running.gif" = 'icons/program_icons/downloader_running.gif',
// 		"ntnrc_idle.gif" = 'icons/program_icons/ntnrc_idle.gif',
// 		"ntnrc_new.gif" = 'icons/program_icons/ntnrc_new.gif',
// 		"power_norm.gif" = 'icons/program_icons/power_norm.gif',
// 		"power_warn.gif" = 'icons/program_icons/power_warn.gif',
// 		"sig_high.gif" = 'icons/program_icons/sig_high.gif',
// 		"sig_low.gif" = 'icons/program_icons/sig_low.gif',
// 		"sig_lan.gif" = 'icons/program_icons/sig_lan.gif',
// 		"sig_none.gif" = 'icons/program_icons/sig_none.gif',
// 		"smmon_0.gif" = 'icons/program_icons/smmon_0.gif',
// 		"smmon_1.gif" = 'icons/program_icons/smmon_1.gif',
// 		"smmon_2.gif" = 'icons/program_icons/smmon_2.gif',
// 		"smmon_3.gif" = 'icons/program_icons/smmon_3.gif',
// 		"smmon_4.gif" = 'icons/program_icons/smmon_4.gif',
// 		"smmon_5.gif" = 'icons/program_icons/smmon_5.gif',
// 		"smmon_6.gif" = 'icons/program_icons/smmon_6.gif',
// 		"borg_mon.gif" = 'icons/program_icons/borg_mon.gif',
// 		"robotact.gif" = 'icons/program_icons/robotact.gif'
// 	)

// /datum/asset/simple/radar_assets
// 	assets = list(
// 		"ntosradarbackground.png" = 'icons/ui_icons/tgui/ntosradar_background.png',
// 		"ntosradarpointer.png" = 'icons/ui_icons/tgui/ntosradar_pointer.png',
// 		"ntosradarpointerS.png" = 'icons/ui_icons/tgui/ntosradar_pointer_S.png'
// 	)

// /datum/asset/simple/circuit_assets
// 	assets = list(
// 		"grid_background.png" = 'icons/ui_icons/tgui/grid_background.png'
// 	)

// /datum/asset/spritesheet/simple/pda
// 	name = "pda"
// 	assets = list(
// 		"atmos" = 'icons/pda_icons/pda_atmos.png',
// 		"back" = 'icons/pda_icons/pda_back.png',
// 		"bell" = 'icons/pda_icons/pda_bell.png',
// 		"blank" = 'icons/pda_icons/pda_blank.png',
// 		"boom" = 'icons/pda_icons/pda_boom.png',
// 		"bucket" = 'icons/pda_icons/pda_bucket.png',
// 		"medbot" = 'icons/pda_icons/pda_medbot.png',
// 		"floorbot" = 'icons/pda_icons/pda_floorbot.png',
// 		"cleanbot" = 'icons/pda_icons/pda_cleanbot.png',
// 		"crate" = 'icons/pda_icons/pda_crate.png',
// 		"cuffs" = 'icons/pda_icons/pda_cuffs.png',
// 		"eject" = 'icons/pda_icons/pda_eject.png',
// 		"flashlight" = 'icons/pda_icons/pda_flashlight.png',
// 		"honk" = 'icons/pda_icons/pda_honk.png',
// 		"mail" = 'icons/pda_icons/pda_mail.png',
// 		"medical" = 'icons/pda_icons/pda_medical.png',
// 		"menu" = 'icons/pda_icons/pda_menu.png',
// 		"mule" = 'icons/pda_icons/pda_mule.png',
// 		"notes" = 'icons/pda_icons/pda_notes.png',
// 		"power" = 'icons/pda_icons/pda_power.png',
// 		"rdoor" = 'icons/pda_icons/pda_rdoor.png',
// 		"reagent" = 'icons/pda_icons/pda_reagent.png',
// 		"refresh" = 'icons/pda_icons/pda_refresh.png',
// 		"scanner" = 'icons/pda_icons/pda_scanner.png',
// 		"signaler" = 'icons/pda_icons/pda_signaler.png',
// 		"skills" = 'icons/pda_icons/pda_skills.png',
// 		"status" = 'icons/pda_icons/pda_status.png',
// 		"dronephone" = 'icons/pda_icons/pda_dronephone.png',
// 		"emoji" = 'icons/pda_icons/pda_emoji.png',
// 		"droneblacklist" = 'icons/pda_icons/pda_droneblacklist.png',
// 	)

// /datum/asset/spritesheet/simple/paper
// 	name = "paper"
// 	assets = list(
// 		"stamp-clown" = 'icons/stamp_icons/large_stamp-clown.png',
// 		"stamp-deny" = 'icons/stamp_icons/large_stamp-deny.png',
// 		"stamp-ok" = 'icons/stamp_icons/large_stamp-ok.png',
// 		"stamp-hop" = 'icons/stamp_icons/large_stamp-hop.png',
// 		"stamp-cmo" = 'icons/stamp_icons/large_stamp-cmo.png',
// 		"stamp-ce" = 'icons/stamp_icons/large_stamp-ce.png',
// 		"stamp-hos" = 'icons/stamp_icons/large_stamp-hos.png',
// 		"stamp-rd" = 'icons/stamp_icons/large_stamp-rd.png',
// 		"stamp-cap" = 'icons/stamp_icons/large_stamp-cap.png',
// 		"stamp-qm" = 'icons/stamp_icons/large_stamp-qm.png',
// 		"stamp-law" = 'icons/stamp_icons/large_stamp-law.png',
// 		"stamp-chap" = 'icons/stamp_icons/large_stamp-chap.png',
// 		"stamp-mime" = 'icons/stamp_icons/large_stamp-mime.png',
// 		"stamp-centcom" = 'icons/stamp_icons/large_stamp-centcom.png',
// 		"stamp-syndicate" = 'icons/stamp_icons/large_stamp-syndicate.png'
// 	)


/datum/asset/simple/irv
	assets = list(
		"jquery-ui.custom-core-widgit-mouse-sortable.min.js" = 'html/jquery/jquery-ui.custom-core-widgit-mouse-sortable.min.js',
	)

/datum/asset/group/irv
	children = list(
		/datum/asset/simple/jquery,
		/datum/asset/simple/irv
	)

/datum/asset/simple/jquery
	legacy = TRUE
	assets = list(
		"jquery.min.js" = 'html/jquery/jquery.min.js',
	)

/datum/asset/simple/namespaced/fontawesome
	assets = list(
		"fa-regular-400.eot"  = 'html/font-awesome/webfonts/fa-regular-400.eot',
		"fa-regular-400.woff" = 'html/font-awesome/webfonts/fa-regular-400.woff',
		"fa-solid-900.eot"    = 'html/font-awesome/webfonts/fa-solid-900.eot',
		"fa-solid-900.woff"   = 'html/font-awesome/webfonts/fa-solid-900.woff',
		"v4shim.css"          = 'html/font-awesome/css/v4-shims.min.css'
	)
	parents = list("font-awesome.css" = 'html/font-awesome/css/all.min.css')

// /datum/asset/simple/namespaced/tgfont
// 	assets = list(
// 		"tgfont.eot" = file("tgui/packages/tgfont/dist/tgfont.eot"),
// 		"tgfont.woff2" = file("tgui/packages/tgfont/dist/tgfont.woff2"),
// 	)
// 	parents = list(
// 		"tgfont.css" = file("tgui/packages/tgfont/dist/tgfont.css"),
// 	)

/datum/asset/simple/goonchat
	legacy = TRUE
	assets = list(
		"json2.min.js"             = 'code/modules/goonchat/browserassets/js/json2.min.js',
		"browserOutput.js"         = 'code/modules/goonchat/browserassets/js/browserOutput.js',
		"browserOutput.css"	       = 'code/modules/goonchat/browserassets/css/browserOutput.css',
		"browserOutput_white.css"  = 'code/modules/goonchat/browserassets/css/browserOutput_white.css',
		"browserOutput_override.css"  = 'code/modules/goonchat/browserassets/css/browserOutput_override.css',
	)

/datum/asset/group/goonchat
	children = list(
		/datum/asset/simple/jquery,
		/datum/asset/simple/goonchat,
		/datum/asset/simple/namespaced/fontawesome)


/datum/asset/simple/namespaced/common
	assets = list("padlock.png" = 'icons/ui_icons/common/padlock.png')
	parents = list("common.css" = 'html/browser/common.css')


/* === ERIS STUFF === */
/datum/asset/simple/design_icons/register()
	for(var/D in SSresearch.all_designs)
		var/datum/design/design = D

		var/filename = sanitizeFileName("[design.build_path].png")

		var/atom/item = design.build_path
		var/icon_file = initial(item.icon)
		var/icon_state = initial(item.icon_state)

		// eugh
		if(!icon_file)
			icon_file = ""

		#ifdef UNIT_TESTS
		if(!(icon_state in icon_states(icon_file)))
			// stack_trace("design [D] with icon '[icon_file]' missing state '[icon_state]'")
			continue
		#endif
		var/icon/I = icon(icon_file, icon_state, SOUTH)

		assets[filename] = I
	..()

	for(var/D in SSresearch.all_designs)
		var/datum/design/design = D
		design.nano_ui_data["icon"] = SSassets.transport.get_asset_url(sanitizeFileName("[design.build_path].png"))

/datum/asset/simple/materials/register()
	for(var/type in subtypesof(/obj/item/stack/material) - typesof(/obj/item/stack/material/cyborg))
		var/filename = sanitizeFileName("[type].png")

		var/atom/item = initial(type)
		var/icon_file = initial(item.icon)
		var/icon_state = initial(item.icon_state)
		var/icon/I = icon(icon_file, icon_state, SOUTH)

		assets[filename] = I
	..()

/datum/asset/simple/craft/register()
	var/list/craftStep = list()
	for(var/name in SScraft.categories)
		for(var/datum/craft_recipe/CR in SScraft.categories[name])
			if(CR.result)
				var/filename = sanitizeFileName("[CR.result].png")

				var/atom/item = initial(CR.result)
				var/icon_file = initial(item.icon)
				var/icon_state = initial(item.icon_state)

				// eugh
				if(!icon_file)
					icon_file = ""

				#ifdef UNIT_TESTS
				if(!(icon_state in icon_states(icon_file)))
					// stack_trace("crafting result [CR] with icon '[icon_file]' missing state '[icon_state]'")
					continue
				#endif
				var/icon/I = icon(icon_file, icon_state, SOUTH)

				assets[filename] = I

			for(var/datum/craft_step/CS in CR.steps)
				if(CS.reqed_type)
					var/filename = sanitizeFileName("[CS.reqed_type].png")

					var/atom/item = initial(CS.reqed_type)
					var/icon_file = initial(item.icon)
					var/icon_state = initial(item.icon_state)
					#ifdef UNIT_TESTS
					if(!(icon_state in icon_states(icon_file)))
						// stack_trace("crafting step [CS] with icon '[icon_file]' missing state '[icon_state]'")
						continue
					#endif
					var/icon/I = icon(icon_file, icon_state, SOUTH)

					assets[filename] = I
					craftStep |= CS
	..()

	// this is fucked but crafting has a circular dept unfortunantly. could unfuck with tgui port
	for(var/datum/craft_step/CS as anything in craftStep)
		if(!CS.reqed_material && !CS.reqed_type)
			continue
		CS.iconfile = SSassets.transport.get_asset_url(CS.reqed_material ? sanitizeFileName("[material_stack_type(CS.reqed_material)].png") : null, assets[sanitizeFileName("[CS.reqed_type].png")])
		CS.make_desc() // redo it

/datum/asset/simple/tool_upgrades/register()
	for(var/type in subtypesof(/obj/item/tool_upgrade))
		var/filename = sanitizeFileName("[type].png")

		var/obj/item/item = initial(type)
		// no.
		if(initial(item.bad_type) == type)
			continue

		var/icon_file = initial(item.icon)
		var/icon_state = initial(item.icon_state)

		#ifdef UNIT_TESTS
		if(!(icon_state in icon_states(icon_file)))
			// stack_trace("tool upgrade [type] with icon '[icon_file]' missing state '[icon_state]'")
			continue
		#endif

		var/icon/I = icon(icon_file, icon_state, SOUTH)
		assets[filename] = I
	..()

/datum/asset/simple/perks/register()
	for(var/type in subtypesof(/datum/perk))
		var/filename = sanitizeFileName("[type].png")

		var/datum/perk/item = initial(type)
		var/icon_file = initial(item.icon)
		var/icon_state = initial(item.icon_state)
		#ifdef UNIT_TESTS
		if(!(icon_state in icon_states(icon_file)))
			//stack_trace("perks [type] with icon '[icon_file]' missing state '[icon_state]'")
			continue
		#endif
		var/icon/I = icon(icon_file, icon_state, SOUTH)

		assets[filename] = I
	..()

/datum/asset/simple/directories/nanoui
	dirs = list(
		"nano/js/",
		"nano/css/",
		"nano/templates/",
		"nano/images/",
		"nano/images/status_icons/",
		"nano/images/modular_computers/",
		"nano/images/eris/",
	)

/datum/asset/simple/directories/images_news
	dirs = list("news_articles/images/")

/datum/asset/simple/directories
	keep_local_name = TRUE
	var/list/dirs = list()

/datum/asset/simple/directories/register()
	// Crawl the directories to find files.
	for(var/path in dirs)
		var/list/filenames = flist(path)
		for(var/filename in filenames)
			if(copytext(filename, length(filename)) != "/") // Ignore directories.
				var/realpath = "[path][filename]"
				if(fexists(realpath))
					assets[filename] = file(realpath)
	..()

/datum/asset/simple/images_map
	keep_local_name = TRUE

/datum/asset/simple/images_map/register()
	var/list/mapnames = list()
	for(var/z in SSmapping.main_ship_z_levels)
		mapnames += map_image_file_name(z)

	var/list/filenames = flist(MAP_IMAGE_PATH)
	for(var/filename in filenames)
		if(copytext(filename, length(filename)) != "/") // Ignore directories.
			var/file_path = MAP_IMAGE_PATH + filename
			if((filename in mapnames) && fexists(file_path))
				assets[filename] = fcopy_rsc(file_path)
	..()
