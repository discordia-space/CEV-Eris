/client/proc/fix_next_move()
	set category = "Debug"
	set name = "Unfreeze Everyone"
	var/largest_move_time = 0
	var/largest_click_time = 0
	var/mob/largest_move_mob = null
	var/mob/largest_click_mob = null
	for(var/mob/M in world)
		if(!M.client)
			continue
		if(M.next_move >= largest_move_time)
			largest_move_mob =69
			if(M.next_move > world.time)
				largest_move_time =69.next_move - world.time
			else
				largest_move_time = 1
		if(M.next_click >= largest_click_time)
			largest_click_mob =69
			if(M.next_click > world.time)
				largest_click_time =69.next_click - world.time
			else
				largest_click_time = 0
		log_admin("DEBUG: 69key_name(M)69  next_move = 69M.next_move69  next_click = 69M.next_click69  world.time = 69world.time69")
		M.next_move = 1
		M.next_click = 0
	message_admins("69key_name_admin(largest_move_mob)69 had the largest69ove delay with 69largest_move_time69 frames / 69largest_move_time/1069 seconds!", 1)
	message_admins("69key_name_admin(largest_click_mob)69 had the largest click delay with 69largest_click_time69 frames / 69largest_click_time/1069 seconds!", 1)
	message_admins("world.time = 69world.time69", 1)

	return

/client/proc/radio_report()
	set category = "Debug"
	set name = "Radio report"

	var/output = "<b>Radio Report</b><hr>"
	for (var/fq in SSradio.frequencies)
		output += "<b>Freq: 69fq69</b><br>"
		var/datum/radio_frequency/fqs = SSradio.frequencies69fq69
		if (!fqs)
			output += "&nbsp;&nbsp;<b>ERROR</b><br>"
			continue
		for (var/filter in fqs.devices)
			var/list/f = fqs.devices69filter69
			if (!f)
				output += "&nbsp;&nbsp;69filter69: ERROR<br>"
				continue
			output += "&nbsp;&nbsp;69filter69: 69f.len69<br>"
			for (var/device in f)
				if (isobj(device))
					output += "&nbsp;&nbsp;&nbsp;&nbsp;69device69 (69device:x69,69device:y69,69device:z69 in area 69get_area(device:loc)69)<br>"
				else
					output += "&nbsp;&nbsp;&nbsp;&nbsp;69device69<br>"

	usr << browse(output,"window=radioreport")


ADMIN_VERB_ADD(/client/proc/reload_admins, R_SERVER, FALSE)
/client/proc/reload_admins()
	set name = "Reload Admins"
	set category = "Debug"

	if(!check_rights(R_SERVER))	return

	message_admins("69usr6969anually reloaded admins")
	load_admins()


ADMIN_VERB_ADD(/client/proc/reload_mentors, R_SERVER, FALSE)
/client/proc/reload_mentors()
	set name = "Reload69entors"
	set category = "Debug"

	if(!check_rights(R_SERVER)) return

	message_admins("69usr6969anually reloaded69entors")
	world.load_mentors()

/*
//todo:
ADMIN_VERB_ADD(/client/proc/jump_to_dead_group, R_DEBUG, FALSE)
/client/proc/jump_to_dead_group()
	set name = "Jump to dead group"
	set category = "Debug"
	if(!holder)
		to_chat(src, "Only administrators69ay use this command.")
		return

	var/datum/air_group/dead_groups = list()
	for(var/datum/air_group/group in SSair.air_groups)
		if (!group.group_processing)
			dead_groups += group
	var/datum/air_group/dest_group = pick(dead_groups)
	usr.loc = pick(dest_group.members)

	return
*/

/*
ADMIN_VERB_ADD(/client/proc/kill_airgroup, R_DEBUG, FALSE)
/client/proc/kill_airgroup()
	set name = "Kill Local Airgroup"
	set desc = "Use this to allow69anual69anupliation of atmospherics."
	set category = "Debug"
	if(!holder)
		to_chat(src, "Only administrators69ay use this command.")
		return

	var/turf/T = get_turf(usr)
	if(istype(T, /turf/simulated))
		var/datum/air_group/AG = T:parent
		AG.next_check = 30
		AG.group_processing = 0
	else
		to_chat(usr, "Local airgroup is unsimulated!")

*/

/client/proc/print_jobban_old()
	set name = "Print Jobban Log"
	set desc = "This spams all the active jobban entries for the current round to standard output."
	set category = "Debug"

	to_chat(usr, "<b>Jobbans active in this round.</b>")
	for(var/t in jobban_keylist)
		to_chat(usr, "69t69")

/client/proc/print_jobban_old_filter()
	set name = "Search Jobban Log"
	set desc = "This searches all the active jobban entries for the current round and outputs the results to standard output."
	set category = "Debug"

	var/filter = input("Contains what?","Filter") as text|null
	if(!filter)
		return

	to_chat(usr, "<b>Jobbans active in this round.</b>")
	for(var/t in jobban_keylist)
		if(findtext(t, filter))
			to_chat(usr, "69t69")
