ADMIN_VERB_ADD(/client/proc/map_template_load, R_DEBUG, FALSE)
/client/proc/map_template_load()
	set category = "Debug"
	set name = "Map template - Place At Loc"

	var/datum/map_template/template


	var/map = input(usr, "Choose a Map Template to place at your CURRENT LOCATION","Place Map Template") as null|anything in SSmapping.map_templates
	if(!map)
		return
	template = SSmapping.map_templates[map]

	var/orientation = text2dir(input(usr, "Choose an orientation for this Map Template.", "Orientation") as null|anything in list("North", "South", "East", "West"))
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
			message_admins("<span class='adminnotice'>[key_name_admin(usr)] has placed a map template ([template.name]).</span>")
		else
			to_chat(usr, "Failed to place map")
	usr.client.images -= preview

ADMIN_VERB_ADD(/client/proc/map_template_load_on_new_z, R_DEBUG, FALSE)
/client/proc/map_template_load_on_new_z()
	set category = "Debug"
	set name = "Map template - New Z"

	var/datum/map_template/template

	var/map = input(usr, "Choose a Map Template to place on a new Z-level.","Place Map Template") as null|anything in SSmapping.map_templates
	if(!map)
		return
	template = SSmapping.map_templates[map]

	var/orientation = text2dir(input(usr, "Choose an orientation for this Map Template.", "Orientation") as null|anything in list("North", "South", "East", "West"))
	if(!orientation)
		return

	// Convert dir to degrees rotation
	orientation = dir2angle(orientation)

	if((!(orientation%180) && template.width > world.maxx || template.height > world.maxy) || (orientation%180 && template.width > world.maxy || template.height > world.maxx))
		if(alert(usr,"This template is larger than the existing z-levels. It will EXPAND ALL Z-LEVELS to match the size of the template. This may cause chaos. Are you sure you want to do this?","DANGER!!!","Cancel","Yes") == "Cancel")
			to_chat(usr,"Template placement aborted.")
			return

	if(alert(usr,"Confirm map load.", "Template Confirm","No","Yes") == "Yes")
		if(template.load_new_z(orientation=orientation))
			message_admins("<span class='adminnotice'>[key_name_admin(usr)] has placed a map template ([template.name]) on Z level [world.maxz].</span>")
		else
			to_chat(usr, "Failed to place map")


ADMIN_VERB_ADD(/client/proc/map_template_upload, R_DEBUG, FALSE)
/client/proc/map_template_upload()
	set category = "Debug"
	set name = "Map Template - Upload"

	var/map = input(usr, "Choose a Map Template to upload to template storage","Upload Map Template") as null|file
	if(!map)
		return
	if(copytext("[map]",-4) != ".dmm")
		to_chat(usr, "Bad map file: [map]")
		return

	var/datum/map_template/M = new(map, "[map]")
	if(M.preload_size(map))
		to_chat(usr, "Map template '[map]' ready to place ([M.width]x[M.height])")
		SSmapping.map_templates[M.name] = M
		message_admins("<span class='adminnotice'>[key_name_admin(usr)] has uploaded a map template ([map])</span>")
	else
		to_chat(usr, "Map template '[map]' failed to load properly")
