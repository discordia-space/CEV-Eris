/datum/admin_secret_item/admin_secret/show_signalers
	name = "Show Last Signalers"

/datum/admin_secret_item/admin_secret/show_signalers/name()
	return "Show Last 69length(lastsignalers)69 Signaler\s"

/datum/admin_secret_item/admin_secret/show_signalers/execute(var/mob/user)
	. = ..()
	if(!.)
		return

	var/dat = "<B>Showing last 69length(lastsignalers)69 signalers.</B><HR>"
	for(var/sig in lastsignalers)
		dat += "69sig69<BR>"
	user << browse(dat, "window=lastsignalers;size=800x500")
