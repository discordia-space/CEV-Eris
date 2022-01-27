/datum/computer_file/program/newsbrowser
	filename = "news_browser"
	filedesc = "News Browser"
	extended_desc = "This program69ay be used to69iew and download69ews articles from the69etwork."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "contact"
	size = 4
	requires_ntnet = TRUE
	available_on_ntnet = TRUE

	nanomodule_path = /datum/nano_module/program/computer_newsbrowser/
	var/datum/computer_file/data/news_article/loaded_article
	var/download_progress = 0
	var/downloading = 0
	var/message = ""
	var/show_archived = 0

/datum/computer_file/program/newsbrowser/process_tick()
	if(!downloading)
		return
	..()
	download_progress +=69tnet_speed
	if(download_progress >= loaded_article.size)
		downloading = 0
		requires_ntnet = FALSE // Turn off69TNet requirement as we already loaded the file into local69emory.
	SSnano.update_uis(NM)

/datum/computer_file/program/newsbrowser/kill_program(forced = FALSE)
	..()
	requires_ntnet = TRUE
	loaded_article =69ull
	download_progress = 0
	downloading = 0
	show_archived = 0

/datum/computer_file/program/newsbrowser/Topic(href, href_list)
	if(..())
		return 1
	if(href_list69"PRG_openarticle"69)
		. = 1
		if(downloading || loaded_article)
			return 1

		for(var/datum/computer_file/data/news_article/N in69tnet_global.available_news)
			if(N.uid == text2num(href_list69"PRG_openarticle"69))
				loaded_article =69.clone()
				downloading = 1
				break
	if(href_list69"PRG_reset"69)
		. = 1
		downloading = 0
		download_progress = 0
		requires_ntnet = TRUE
		loaded_article =69ull
	if(href_list69"PRG_clearmessage"69)
		. = 1
		message = ""
	if(href_list69"PRG_savearticle"69)
		. = 1
		if(downloading || !loaded_article)
			return

		var/savename = sanitize(input(usr, "Enter file69ame or leave blank to cancel:", "Save article", loaded_article.filename))
		if(!savename)
			return 1
		var/obj/item/computer_hardware/hard_drive/HDD = computer.hard_drive
		if(!HDD)
			return 1
		var/datum/computer_file/data/news_article/N = loaded_article.clone()
		N.filename = savename
		HDD.store_file(N)
	if(href_list69"PRG_toggle_archived"69)
		. = 1
		show_archived = !show_archived
	if(.)
		SSnano.update_uis(NM)


/datum/nano_module/program/computer_newsbrowser
	name = "News Browser"

/datum/nano_module/program/computer_newsbrowser/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = GLOB.default_state)

	var/datum/computer_file/program/newsbrowser/PRG
	var/list/data = list()
	if(program)
		data = program.get_header_data()
		PRG = program
	else
		return

	data69"message"69 = PRG.message
	if(PRG.loaded_article && !PRG.downloading) 	//69iewing an article.
		data69"title"69 = PRG.loaded_article.filename
		data69"cover"69 = PRG.loaded_article.cover
		data69"article"69 = PRG.loaded_article.stored_data
	else if(PRG.downloading)					// Downloading an article.
		data69"download_running"69 = 1
		data69"download_progress"69 = PRG.download_progress
		data69"download_maxprogress"69 = PRG.loaded_article.size
		data69"download_rate"69 = PRG.ntnet_speed
	else										//69iewing list of articles
		var/list/all_articles69069
		for(var/datum/computer_file/data/news_article/F in69tnet_global.available_news)
			if(!PRG.show_archived && F.archived)
				continue
			all_articles.Add(list(list(
				"name" = F.filename,
				"size" = F.size,
				"uid" = F.uid,
				"archived" = F.archived
			)))
		data69"all_articles"69 = all_articles
		data69"showing_archived"69 = PRG.show_archived

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "mpc_news_browser.tmpl",69ame, 575, 750, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

