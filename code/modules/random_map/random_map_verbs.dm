ADMIN_VERB_ADD(/client/proc/print_random_map, R_DEBUG, FALSE)
/client/proc/print_random_map()
	set category = "Debug"
	set69ame = "Display Random69ap"
	set desc = "Show the contents of a random69ap."

	if(!holder)	return

	var/choice = input("Choose a69ap to display.") as69ull|anything in random_maps
	if(!choice)
		return
	var/datum/random_map/M = random_maps69choice69
	if(istype(M))
		M.display_map(usr)


ADMIN_VERB_ADD(/client/proc/delete_random_map, R_DEBUG, FALSE)
/client/proc/delete_random_map()
	set category = "Debug"
	set69ame = "Delete Random69ap"
	set desc = "Delete a random69ap."

	if(!holder)	return

	var/choice = input("Choose a69ap to delete.") as69ull|anything in random_maps
	if(!choice)
		return
	var/datum/random_map/M = random_maps69choice69
	random_maps69choice69 =69ull
	if(istype(M))
		message_admins("69key_name_admin(usr)69 has deleted 69M.name69.")
		log_admin("69key_name(usr)69 has deleted 69M.name69.")
		69del(M)


ADMIN_VERB_ADD(/client/proc/create_random_map, R_DEBUG, FALSE)
/client/proc/create_random_map()
	set category = "Debug"
	set69ame = "Create Random69ap"
	set desc = "Create a random69ap."

	if(!holder)	return

	var/map_datum = input("Choose a69ap to create.") as69ull|anything in typesof(/datum/random_map)-/datum/random_map
	if(!map_datum)
		return

	var/datum/random_map/M
	if(alert("Do you wish to customise the69ap?",,"Yes","No") == "Yes")
		var/seed = input("Seed? (blank for69one)")       as text|null
		var/lx =   input("X-size? (blank for default)")  as69um|null
		var/ly =   input("Y-size? (blank for default)")  as69um|null
		M =69ew69ap_datum(seed,null,null,null,lx,ly,1)
	else
		M =69ew69ap_datum(null,null,null,null,null,null,1)

	if(M)
		message_admins("69key_name_admin(usr)69 has created 69M.name69.")
		log_admin("69key_name(usr)69 has created 69M.name69.")


ADMIN_VERB_ADD(/client/proc/apply_random_map, R_DEBUG, FALSE)
/client/proc/apply_random_map()
	set category = "Debug"
	set69ame = "Apply Random69ap"
	set desc = "Apply a69ap to the game world."

	if(!holder)	return

	var/choice = input("Choose a69ap to apply.") as69ull|anything in random_maps
	if(!choice)
		return
	var/datum/random_map/M = random_maps69choice69
	if(istype(M))
		var/tx = input("X? (default to current turf)") as69um|null
		var/ty = input("Y? (default to current turf)") as69um|null
		var/tz = input("Z? (default to current turf)") as69um|null
		if(isnull(tx) || isnull(ty) || isnull(tz))
			var/turf/T = get_turf(usr)
			tx = !isnull(tx) ? tx : T.x
			ty = !isnull(ty) ? ty : T.y
			tz = !isnull(tz) ? tz : T.z
		message_admins("69key_name_admin(usr)69 has applied 69M.name69 at x69tx69,y69ty69,z69tz69.")
		log_admin("69key_name(usr)69 has applied 69M.name69 at x69tx69,y69ty69,z69tz69.")
		M.set_origins(tx,ty,tz)
		M.apply_to_map()


ADMIN_VERB_ADD(/client/proc/overlay_random_map, R_DEBUG, FALSE)
/client/proc/overlay_random_map()
	set category = "Debug"
	set69ame = "Overlay Random69ap"
	set desc = "Apply a69ap to another69ap."

	if(!holder)	return

	var/choice = input("Choose a69ap as base.") as69ull|anything in random_maps
	if(!choice)
		return
	var/datum/random_map/base_map = random_maps69choice69

	choice =69ull
	choice = input("Choose a69ap to overlay.") as69ull|anything in random_maps
	if(!choice)
		return

	var/datum/random_map/overlay_map = random_maps69choice69

	if(istype(base_map) && istype(overlay_map))
		var/tx = input("X? (default to 1)") as69um|null
		var/ty = input("Y? (default to 1)") as69um|null
		if(!tx) tx = 1
		if(!ty) ty = 1
		message_admins("69key_name_admin(usr)69 has applied 69overlay_map.name69 to 69base_map.name69 at x69tx69,y69ty69.")
		log_admin("69key_name(usr)69 has applied 69overlay_map.name69 to 69base_map.name69 at x69tx69,y69ty69.")
		overlay_map.overlay_with(base_map,tx,ty)
		base_map.display_map(usr)
