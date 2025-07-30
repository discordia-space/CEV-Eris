/// Shows a header name on top when you investigate an appearance/image
/image/vv_get_header()
	. = list()
	var/icon_name = "<b>[icon || "null"]</b><br/>"
	. += replacetext(icon_name, "icons/obj", "") // shortens the name. We know the path already.
	if(icon)
		. += icon_state ? "\"[icon_state]\"" : "(icon_state = null)"

/// Makes nice short vv names for images
/image/debug_variable_value(name, level, datum/owner, sanitize, display_flags)
	var/display_name = "[type]"
	if("[src]" != "[type]") // If we have a name var, let's use it.
		display_name = "[src] [type]"

	var/display_value
	var/list/icon_file_name = splittext("[icon]", "/")
	if(length(icon_file_name))
		display_value = icon_file_name[length(icon_file_name)]
	else
		display_value = "null"

	if(icon_state)
		display_value = "[display_value]:[icon_state]"

	var/display_ref = get_vv_link_ref()
	return "<a href='byond://?_src_=vars;[HrefToken()];Vars=[display_ref]'>[display_name] (<span class='value'>[display_value]</span>) [display_ref]</a>"

/// Returns the ref string to use when displaying this image in the vv menu of something else
/image/proc/get_vv_link_ref()
	return REF(src)

// It is endlessly annoying to display /appearance directly for stupid byond reasons, so we copy everything we care about into a holder datum
// That we can override procs on and store other vars on and such.
/mutable_appearance/appearance_mirror
	// So people can see where it came from
	var/appearance_ref

// arg is actually an appearance, typed as mutable_appearance as closest mirror
/mutable_appearance/appearance_mirror/New(mutable_appearance/appearance_father)
	. = ..() // /mutable_appearance/New() copies over all the appearance vars MAs care about by default
	appearance_ref = REF(appearance_father)

// This means if the appearance loses refs before a click it's gone, but that's consistent to other datums so it's fine
// Need to ref the APPEARANCE because we just free on our own, which sorta fucks this operation up you know?
/mutable_appearance/appearance_mirror/get_vv_link_ref()
	return appearance_ref

/mutable_appearance/appearance_mirror/can_vv_get(var_name)
	var/static/datum/beloved = new()
	if(beloved.vars.Find(var_name)) // If datums have it, get out
		return FALSE
	// If it is one of the two args on /image, yeet (I am sorry)
	if(var_name == NAMEOF(src, realized_overlays))
		return FALSE
	if(var_name == NAMEOF(src, realized_underlays))
		return FALSE
	// Could make an argument for this but I think they will just confuse people, so yeeet
	if(var_name == NAMEOF(src, vis_contents))
		return FALSE
	return ..()

/mutable_appearance/appearance_mirror/vv_get_var(var_name)
	// No editing for you
	var/value = vars[var_name]
	return "<li style='backgroundColor:white'>(READ ONLY) [var_name] = [_debug_variable_value(var_name, value, 0, src, sanitize = TRUE, display_flags = NONE)]</li>"

/mutable_appearance/appearance_mirror/vv_get_dropdown()
	SHOULD_CALL_PARENT(FALSE)

	. = list()
	VV_DROPDOWN_OPTION("", "---")
	VV_DROPDOWN_OPTION(VV_HK_CALLPROC, "Call Proc")
	VV_DROPDOWN_OPTION(VV_HK_MARK, "Mark Object")
	VV_DROPDOWN_OPTION(VV_HK_TAG, "Tag Datum")
	VV_DROPDOWN_OPTION(VV_HK_DELETE, "Delete")
	VV_DROPDOWN_OPTION(VV_HK_EXPOSE, "Show VV To Player")

/proc/get_vv_appearance(mutable_appearance/appearance) // actually appearance yadeeyada
	return new /mutable_appearance/appearance_mirror(appearance)

// Debug procs

/atom
	/// List of overlay "keys" (info about the appearance) -> mutable versions of static appearances
	/// Drawn from the overlays list
	var/list/realized_overlays
	/// List of underlay "keys" (info about the appearance) -> mutable versions of static appearances
	/// Drawn from the underlays list
	var/list/realized_underlays

/image
	/// List of overlay "keys" (info about the appearance) -> mutable versions of static appearances
	/// Drawn from the overlays list
	var/list/realized_overlays
	/// List of underlay "keys" (info about the appearance) -> mutable versions of static appearances
	/// Drawn from the underlays list
	var/list/realized_underlays

/// Takes the atoms's existing overlays and underlays, and makes them mutable so they can be properly vv'd in the realized_overlays/underlays list
/atom/proc/realize_overlays()
	realized_overlays = realize_appearance_queue(overlays)
	realized_underlays = realize_appearance_queue(underlays)

/// Takes the image's existing overlays, and makes them mutable so they can be properly vv'd in the realized_overlays list
/image/proc/realize_overlays()
	realized_overlays = realize_appearance_queue(overlays)
	realized_underlays = realize_appearance_queue(underlays)

/// Takes a list of appearnces, makes them mutable so they can be properly vv'd and inspected
/proc/realize_appearance_queue(list/appearances)
	var/list/real_appearances = list()
	var/list/queue = appearances.Copy()
	var/queue_index = 0
	while(queue_index < length(queue))
		queue_index++
		// If it's not a command, we assert that it's an appearance
		var/mutable_appearance/appearance = queue[queue_index]
		if(!appearance) // Who fucking adds nulls to their sublists god you people are the worst
			continue

		var/mutable_appearance/new_appearance = new /mutable_appearance()
		new_appearance.appearance = appearance
		var/key = "[appearance.icon]-[appearance.icon_state]-[appearance.plane]-[appearance.layer]-[appearance.dir]-[appearance.color]"
		var/tmp_key = key
		var/appearance_indx = 1
		while(real_appearances[tmp_key])
			tmp_key = "[key]-[appearance_indx]"
			appearance_indx++

		real_appearances[tmp_key] = new_appearance
		var/add_index = queue_index
		// Now check its children
		for(var/mutable_appearance/child_appearance as anything in appearance.overlays)
			add_index++
			queue.Insert(add_index, child_appearance)
		for(var/mutable_appearance/child_appearance as anything in appearance.underlays)
			add_index++
			queue.Insert(add_index, child_appearance)
	return real_appearances

/// Takes two appearances as args, prints out, logs, and returns a text representation of their differences
/// Including suboverlays
/proc/diff_appearances(mutable_appearance/first, mutable_appearance/second, iter = 0)
	var/list/diffs = list()
	var/list/firstdeet = first.vars
	var/list/seconddeet = second.vars
	var/diff_found = FALSE
	for(var/name in first.vars)
		var/firstv = firstdeet[name]
		var/secondv = seconddeet[name]
		if(firstv ~= secondv)
			continue
		if((islist(firstv) || islist(secondv)) && length(firstv) == 0 && length(secondv) == 0)
			continue
		if(name == "vars") // Go away
			continue
		if(name == "_listen_lookup") // This is just gonna happen with marked datums, don't care
			continue
		if(name == "overlays")
			first.realize_overlays()
			second.realize_overlays()
			var/overlays_differ = FALSE
			for(var/i in 1 to length(first.realized_overlays))
				if(diff_appearances(first.realized_overlays[i], second.realized_overlays[i], iter + 1))
					overlays_differ = TRUE

			if(!overlays_differ)
				continue

		diff_found = TRUE
		diffs += "Diffs detected at [name]: First ([firstv]), Second ([secondv])"

	var/text = "Depth of: [iter]\n\t[diffs.Join("\n\t")]"
	message_admins(text)
	log_world(text)
	return diff_found
