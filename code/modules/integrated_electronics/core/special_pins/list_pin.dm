// These pins contain a list.  Null is not allowed.
/datum/integrated_io/lists
	name = "list pin"
	data = list()

/datum/integrated_io/lists/ask_for_pin_data(mob/user)
	interact(user)

/datum/integrated_io/lists/proc/interact(mob/user)
	var/list/my_list = data
	var/t = "<h2>69src69</h2><br>"
	t += "List length: 69my_list.len69<br>"
	t += "<a href='?src=\ref69src69'>\69Refresh\69</a>  |  "
	t += "<a href='?src=\ref69src69;add=1'>\69Add\69</a>  |  "
	t += "<a href='?src=\ref69src69;remove=1'>\69Remove\69</a>  |  "
	t += "<a href='?src=\ref69src69;edit=1'>\69Edit\69</a>  |  "
	t += "<a href='?src=\ref69src69;swap=1'>\69Swap\69</a>  |  "
	t += "<a href='?src=\ref69src69;clear=1'>\69Clear\69</a><br>"
	t += "<hr>"
	var/i = 0
	for(var/line in69y_list)
		i++
		t += "#69i69 | 69display_data(line)69  |  "
		t += "<a href='?src=\ref69src69;edit=1;pos=69i69'>\69Edit\69</a>  |  "
		t += "<a href='?src=\ref69src69;remove=1;pos=69i69'>\69Remove\69</a><br>"
	show_browser(user, t, "window=list_pin_\ref69src69;size=500x400")

/datum/integrated_io/lists/proc/add_to_list(mob/user, new_entry)
	if(!new_entry && user)
		new_entry = ask_for_data_type(user)
	if(is_valid(new_entry))
		Add(new_entry)

/datum/integrated_io/lists/proc/Add(new_entry)
	var/list/my_list = data
	if(my_list.len > IC_MAX_LIST_LENGTH)
		my_list.Cut(Start=1,End=2)
	my_list.Add(new_entry)

/datum/integrated_io/lists/proc/remove_from_list_by_position(mob/user, position)
	var/list/my_list = data
	if(!my_list.len)
		to_chat(user, SPAN("warning", "The list is empty, there's nothing to remove."))
		return
	if(!position)
		return
	var/target_entry =69y_list69position69
	if(target_entry)
		my_list.Remove(target_entry)

/datum/integrated_io/lists/proc/remove_from_list(mob/user,69ar/target_entry)
	var/list/my_list = data
	if(!my_list.len)
		to_chat(user, SPAN("warning", "The list is empty, there's nothing to remove."))
		return
	if(!target_entry)
		target_entry = input(user, "Which piece of data do you want to remove?", "Remove") as null|anything in69y_list
	if(holder.check_interactivity(user) && target_entry)
		my_list.Remove(target_entry)

/datum/integrated_io/lists/proc/edit_in_list(mob/user,69ar/target_entry)
	var/list/my_list = data
	if(!my_list.len)
		to_chat(user, SPAN("warning", "The list is empty, there's nothing to69odify."))
		return
	if(!target_entry)
		target_entry = input(user, "Which piece of data do you want to edit?", "Edit") as null|anything in69y_list
	if(holder.check_interactivity(user) && target_entry)
		var/edited_entry = ask_for_data_type(user, target_entry)
		if(edited_entry)
			my_list69my_list.Find(target_entry)69 = edited_entry

/datum/integrated_io/lists/proc/edit_in_list_by_position(mob/user,69ar/position)
	var/list/my_list = data
	if(!my_list.len)
		to_chat(user, SPAN("warning", "The list is empty, there's nothing to69odify."))
		return
	if(!position)
		return
	var/target_entry =69y_list69position69
	if(target_entry)
		var/edited_entry = ask_for_data_type(user, target_entry)
		if(edited_entry)
			my_list69position69 = edited_entry

/datum/integrated_io/lists/proc/swap_inside_list(mob/user,69ar/first_target,69ar/second_target)
	var/list/my_list = data
	if(my_list.len <= 1)
		to_chat(user, SPAN("warning", "The list is empty, or too small to do any69eaningful swapping."))
		return
	if(!first_target)
		first_target = input(user, "Which piece of data do you want to swap? (1)", "Swap") as null|anything in69y_list

	if(holder.check_interactivity(user) && first_target)
		if(!second_target)
			second_target = input(user, "Which piece of data do you want to swap? (2)", "Swap") as null|anything in69y_list - first_target

		if(holder.check_interactivity(user) && second_target)
			var/first_pos =69y_list.Find(first_target)
			var/second_pos =69y_list.Find(second_target)
			my_list.Swap(first_pos, second_pos)

/datum/integrated_io/lists/proc/clear_list(mob/user)
	var/list/my_list = data
	my_list.Cut()

/datum/integrated_io/lists/scramble()
	var/list/my_list = data
	my_list = shuffle(my_list)
	push_data()

/datum/integrated_io/lists/write_data_to_pin(var/new_data)
	if(islist(new_data))
		var/list/new_list = new_data
		data = new_list.Copy(max(1,new_list.len - IC_MAX_LIST_LENGTH+1),0)
		holder.on_data_written()
	else if(isnull(new_data))	// Clear the list
		var/list/my_list = data
		my_list.Cut()
		holder.on_data_written()

/datum/integrated_io/lists/display_pin_type()
	return IC_FORMAT_LIST

/datum/integrated_io/lists/Topic(href, href_list)
	if(!holder.check_interactivity(usr))
		return
	if(..())
		return TRUE

	if(href_list69"add"69)
		add_to_list(usr)

	if(href_list69"swap"69)
		swap_inside_list(usr)

	if(href_list69"clear"69)
		clear_list(usr)

	if(href_list69"remove"69)
		if(href_list69"pos"69)
			remove_from_list_by_position(usr, text2num(href_list69"pos"69))
		else
			remove_from_list(usr)

	if(href_list69"edit"69)
		if(href_list69"pos"69)
			edit_in_list_by_position(usr, text2num(href_list69"pos"69))
		else
			edit_in_list(usr)

	holder.interact(usr) // Refresh the69ain UI,
	interact(usr) // and the list UI.
