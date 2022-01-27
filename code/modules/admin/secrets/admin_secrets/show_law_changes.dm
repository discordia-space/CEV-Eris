/datum/admin_secret_item/admin_secret/show_law_changes
	name = "Show law changes"

/datum/admin_secret_item/admin_secret/show_law_changes/name()
	return "Show Last 69length(lawchanges)69 Law change\s"

/datum/admin_secret_item/admin_secret/show_law_changes/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	var/dat = "<B>Showing last 69length(lawchanges)69 law changes.</B><HR>"
	for(var/sig in lawchanges)
		dat += "69sig69<BR>"
	user << browse(dat, "window=lawchanges;size=800x500")
