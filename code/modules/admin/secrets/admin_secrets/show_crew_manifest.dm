/datum/admin_secret_item/admin_secret/show_crew_manifest
	name = "Show Crew69anifest"

/datum/admin_secret_item/admin_secret/show_crew_manifest/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/dat
	dat += "<h4>Crew69anifest</h4>"
	dat += data_core.get_manifest()

	user << browse(dat, "window=manifest;size=370x420;can_close=1")
