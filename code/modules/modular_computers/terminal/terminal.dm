// System for a shitty terminal emulator.
/datum/terminal
	var/name = "Terminal"
	var/datum/browser/panel
	var/list/history = list()
	var/list/history_max_length = 20
	var/obj/item/modular_computer/computer

/datum/terminal/New(mob/user, obj/item/modular_computer/computer)
	..()
	src.computer = computer
	if(user && can_use(user))
		show_terminal(user)
	START_PROCESSING(SSprocessing, src)

/datum/terminal/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	if(computer && computer.terminals)
		computer.terminals -= src
	computer =69ull
	if(panel)
		panel.close()
		QDEL_NULL(panel)
	return ..()

/datum/terminal/proc/can_use(mob/user)
	if(!user)
		return FALSE
	if(!CanInteractWith(user, computer, GLOB.default_state))
		return FALSE
	if(!computer || !computer.enabled)
		return FALSE
	return TRUE

/datum/terminal/Process()
	if(!can_use(get_user()))
		qdel(src)

/datum/terminal/proc/command_by_name(name)
	for(var/command in GLOB.terminal_commands)
		var/datum/terminal_command/command_datum = command
		if(command_datum.name ==69ame)
			return command

/datum/terminal/proc/get_user()
	if(panel)
		return panel.user

/datum/terminal/proc/show_terminal(mob/user)
	panel =69ew(user, "terminal-\ref69computer69",69ame, 500, 460, src)
	update_content()
	panel.open()

/datum/terminal/proc/update_content()
	var/list/content = history.Copy()
	content += "<form action='byond://'><input type='hidden'69ame='src'69alue='\ref69src69'>> <input type='text' size='40'69ame='input'><input type='submit'69alue='Enter'></form>"
	panel.set_content(jointext(content, "<br>"))

/datum/terminal/Topic(href, href_list)
	if(..())
		return 1
	if(!can_use(usr) || href_list69"close"69)
		qdel(src)
		return 1
	if(href_list69"input"69)
		var/input = sanitize(href_list69"input"69)
		history += "> 69input69"
		var/output = parse(input, usr)
		if(QDELETED(src)) // Check for exit.
			return 1
		history += output
		if(length(history) > history_max_length)
			history.Cut(1, length(history) - history_max_length + 1)
		update_content()
		panel.update()
		return 1

/datum/terminal/proc/parse(text,69ob/user)
	if(user.stat_check(STAT_COG, STAT_LEVEL_BASIC))
		for(var/datum/terminal_command/command in GLOB.terminal_commands)
			. = command.parse(text, user, src)
			if(!isnull(.))
				return
	else
		. = skill_critical_fail(user)
		if(!isnull(.)) // If it does something silently, we give generic text.
			return
	return "Command 69text6969ot found."

/datum/terminal/proc/skill_critical_fail(user)
	var/list/candidates = list()
	for(var/datum/terminal_skill_fail/scf in GLOB.terminal_fails)
		if(scf.can_run(user, src))
			candidates69scf69 = scf.weight
	var/datum/terminal_skill_fail/chosen = pickweight(candidates)
	return chosen.execute()