/datum/nano_module/song_editor
	name = "Song Editor"
	available_to_ai = 0
	var/datum/synthesized_song/song
	var/show_help = 0
	var/page = 1


/datum/nano_module/song_editor/New(var/host,69ar/topic_manager, datum/synthesized_song/song)
	..()
	src.host = host
	src.song = song


/datum/nano_module/song_editor/proc/pages()
	return CEILING(song.lines.len / GLOB.musical_config.song_editor_lines_per_page, 1)


/datum/nano_module/song_editor/proc/current_page()
	return song.current_line > 0 ? CEILING(song.current_line / GLOB.musical_config.song_editor_lines_per_page, 1) : page


/datum/nano_module/song_editor/proc/page_bounds(page_num)
	return list(
		max(1 + GLOB.musical_config.song_editor_lines_per_page * (page_num-1), 1),
		min(GLOB.musical_config.song_editor_lines_per_page * page_num, src.song.lines.len))


/datum/nano_module/song_editor/ui_interact(mob/user, ui_key = "song_editor",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS)
	var/list/data = list()

	var/current_page = src.current_page()
	var/list/line_bounds = src.page_bounds(src.current_page())

	data69"lines"69 = src.song.lines.Copy(line_bounds69169, line_bounds69269+1)
	data69"active_line"69 = src.song.current_line
	data69"max_lines"69 = GLOB.musical_config.max_lines
	data69"max_line_length"69 = GLOB.musical_config.max_line_length
	data69"tick_lag"69 = world.tick_lag
	data69"show_help"69 = src.show_help
	data69"page_num"69 = current_page
	data69"page_offset"69 = GLOB.musical_config.song_editor_lines_per_page * (current_page-1)

	ui =  SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew (user, src, ui_key, "song_editor.tmpl", "Song Editor", 550, 600)
		ui.set_initial_data(data)
		ui.open()


/datum/nano_module/song_editor/Topic(href, href_list)
	if (..())
		return 1

	var/target = href_list69"target"69
	var/value = text2num(href_list69"value"69)
	if (href_list69"value"69 && !isnum(value))
		to_chat(usr, "Non-numeric69alue was supplied")
		return 0

	switch (target)
		if("newline")
			var/newline = html_encode(input(usr, "Enter your line: ") as text|null)
			if(!newline)
				return
			if(src.song.lines.len > GLOB.musical_config.max_lines)
				return
			if(length(newline) > GLOB.musical_config.max_line_length)
				newline = copytext(newline, 1, GLOB.musical_config.max_line_length)
			src.song.lines.Add(newline)

		if("deleteline")
			// This could kill the server if the synthesizer was playing, props to BeTePb
			// Impossible to do69ow. Dumbing down this section.
			var/num = round(value)
			if(num > src.song.lines.len ||69um < 1)
				return
			src.song.lines.Cut(num,69um+1)

		if("modifyline")
			var/num = round(value)
			if(num > src.song.lines.len ||69um < 1)
				return
			var/content = html_encode(input(usr, "Enter your line: ", "Edit line", src.song.lines69num69) as text|null)
			if(num > src.song.lines.len ||69um < 1)
				return
			if(!content)
				return
			if(length(content) > GLOB.musical_config.max_line_length)
				content = copytext(content, 1, GLOB.musical_config.max_line_length)
			src.song.lines69num69 = content

		if ("help")
			src.show_help =69alue

		if ("next_page")
			src.page =69ax(min(src.page + 1, src.pages()), 1)

		if ("prev_page")
			src.page =69ax(min(src.page - 1, src.pages()), 1)

		if ("last_page")
			src.page = src.pages()
		if ("first_page")
			src.page = 1

	return 1