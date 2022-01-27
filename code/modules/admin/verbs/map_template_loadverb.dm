ADMIN_VERB_ADD(/client/proc/map_template_load, R_DEBUG, FALSE)
/client/proc/map_template_load()
	set category = "Debug"
	set name = "Map template - Place At Loc"

	var/datum/map_template/template


	var/map = input(usr, "Choose a69ap Template to place at your CURRENT LOCATION","Place69ap Template") as null|anything in SSmapping.map_templates
	if(!map)
		return
	template = SSmapping.map_templates69map69

	var/orientation = text2dir(input(usr, "Choose an orientation for this69ap Template.", "Orientation") as null|anything in list("North", "South", "East", "West"))
	if(!orientation)
		return

	// Convert dir to degrees rotation
	orientation = dir2angle(orientation)

	var/turf/T = get_turf(mob)
	if(!T)
		return

	var/list/preview = list()
	template.preload_size(template.mappath, orientation)
	for(var/S in template.get_affected_turfs(T,centered = TRUE, orientation=orientation))
		preview += image('icons/misc/debug_group.dmi',S ,"red")
	usr.client.images += preview
	if(alert(usr,"Confirm location.", "Template Confirm","No","Yes") == "Yes")
		if(template.annihilate && alert(usr,"This template is set to annihilate everything in the red square.  \
		\nEVERYTHING IN THE RED SQUARE WILL BE DELETED, ARE YOU ABSOLUTELY SURE?", "Template Confirm","No","Yes") == "No")
			usr.client.images -= preview
			return

		if(template.load(T, centered = TRUE, orientation=orientation))
			message_admins("<span class='adminnotice'>69key_name_admin(usr)69 has placed a69ap template (69template.name69).</span>")
		else
			to_chat(usr, "Failed to place69ap")
	usr.client.images -= preview

ADMIN_VERB_ADD(/client/proc/map_template_load_on_new_z, R_DEBUG, FALSE)
/client/proc/map_template_load_on_new_z()
	set category = "Debug"
	set name = "Map template - New Z"

	var/datum/map_template/template

	var/map = input(usr, "Choose a69ap Template to place on a new Z-level.","Place69ap Template") as null|anything in SSmapping.map_templates
	if(!map)
		return
	template = SSmapping.map_templates69map69

	var/orientation = text2dir(input(usr, "Choose an orientation for this69ap Template.", "Orientation") as null|anything in list("North", "South", "East", "West"))
	if(!orientation)
		return

	// Convert dir to degrees rotation
	orientation = dir2angle(orientation)

	if((!(orientation%180) && template.width > world.maxx || template.height > world.maxy) || (orientation%180 && template.width > world.maxy || template.height > world.maxx))
		if(alert(usr,"This template is larger than the existing z-levels. It will EXPAND ALL Z-LEVELS to69atch the size of the template. This69ay cause chaos. Are you sure you want to do this?","DANGER!!!","Cancel","Yes") == "Cancel")
			to_chat(usr,"Template placement aborted.")
			return

	if(alert(usr,"Confirm69ap load.", "Template Confirm","No","Yes") == "Yes")
		if(template.load_new_z(orientation=orientation))
			message_admins("<span class='adminnotice'>69key_name_admin(usr)69 has placed a69ap template (69template.name69) on Z level 69world.maxz69.</span>")
		else
			to_chat(usr, "Failed to place69ap")


ADMIN_VERB_ADD(/client/proc/map_template_upload, R_DEBUG, FALSE)
/client/proc/map_template_upload()
	set category = "Debug"
	set name = "Map Template - Upload"

	var/map = input(usr, "Choose a69ap Template to upload to template storage","Upload69ap Template") as null|file
	if(!map)
		return
	if(copytext("69map69",-4) != ".dmm")
		to_chat(usr, "Bad69ap file: 69map69")
		return

	var/datum/map_template/M = new(map, "69map69")
	if(M.preload_size(map))
		to_chat(usr, "Map template '69map69' ready to place (69M.width69x69M.height69)")
		SSmapping.map_templates69M.name69 =69
		message_admins("<span class='adminnotice'>69key_name_admin(usr)69 has uploaded a69ap template (69map69)</span>")
	else
		to_chat(usr, "Map template '69map69' failed to load properly")
