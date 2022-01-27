/mob/proc/on_mob_jump(var/turf/T)
	if (istype(loc, /mob/living/exosuit))
		var/mob/living/exosuit/M = loc
		M.forceMove(T)
	else
		forceMove(T)

/mob/observer/ghost/on_mob_jump()
	stop_following()
	..()

ADMIN_VERB_ADD(/client/proc/Jump, R_ADMIN|R_DEBUG, FALSE)
/client/proc/Jump(var/area/A in return_sorted_areas())
	set name = "Jump to Area"
	set desc = "Area to jump to"
	set category = "Admin"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	var/new_location = safepick(get_area_turfs(A))

	if(new_location)
		usr.on_mob_jump(new_location)
		log_admin("69key_name(usr)69 jumped to 69A69")
		message_admins("69key_name_admin(usr)69 jumped to 69A69", 1)
	else
		alert("Admin jump failed due to69issing 69A69 area turfs.")

ADMIN_VERB_ADD(/client/proc/jumptoturf, R_ADMIN, FALSE)
//allows us to jump to a specific turf
/client/proc/jumptoturf(var/turf/T in turfs)
	set name = "Jump to Turf"
	set category = "Admin"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	log_admin("69key_name(usr)69 jumped to 69T.x69,69T.y69,69T.z69 in 69T.loc69")
	message_admins("69key_name_admin(usr)69 jumped to 69T.x69,69T.y69,69T.z69 in 69T.loc69", 1)

	//When inside a69ech,69ove the69ech instead of teleporting out of it
	usr.on_mob_jump(T)

ADMIN_VERB_ADD(/client/proc/jumptomob, R_ADMIN|R_DEBUG, FALSE)
//allows us to jump to a specific69ob
/client/proc/jumptomob(var/mob/M in SSmobs.mob_list)
	set category = "Admin"
	set name = "Jump to69ob"


	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return


	log_admin("69key_name(usr)69 jumped to 69key_name(M)69")
	message_admins("69key_name_admin(usr)69 jumped to 69key_name_admin(M)69", 1)
	if(src.mob)
		var/mob/A = src.mob
		var/turf/T = get_turf(M)
		if(T && isturf(T))
			A.on_mob_jump(T)
		else
			to_chat(A, "This69ob is not located in the game world.")

ADMIN_VERB_ADD(/client/proc/jumptocoord, R_ADMIN|R_DEBUG, FALSE)
//we ghost and jump to a coordinate
/client/proc/jumptocoord(tx as num, ty as num, tz as num)
	set category = "Admin"
	set name = "Jump to Coordinate"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if(src.mob)
		var/mob/A = src.mob
		A.on_mob_jump(locate(tx,ty,tz))
		message_admins("69key_name_admin(usr)69 jumped to coordinates 69tx69, 69ty69, 69tz69")

ADMIN_VERB_ADD(/client/proc/jumptokey, R_ADMIN, TRUE)
//allows us to jump to the location of a69ob with a certain ckey
/client/proc/jumptokey()
	set category = "Admin"
	set name = "Jump to Key"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	var/list/keys = list()
	for(var/mob/M in GLOB.player_list)
		keys +=69.client
	var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in sortKey(keys)
	if(!selection)
		to_chat(src, "No keys found.")
		return
	var/mob/M = selection:mob
	log_admin("69key_name(usr)69 jumped to 69key_name(M)69")
	message_admins("69key_name_admin(usr)69 jumped to 69key_name_admin(M)69", 1)
	usr.on_mob_jump(get_turf(M))

ADMIN_VERB_ADD(/client/proc/Getmob, R_ADMIN, FALSE)
//teleports a69ob to our location
/client/proc/Getmob(var/mob/M in SSmobs.mob_list)
	set category = "Admin"
	set name = "Get69ob"
	set desc = "Mob to teleport"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	log_admin("69key_name(usr)69 teleported 69key_name(M)69")
	message_admins("69key_name_admin(usr)69 teleported 69key_name_admin(M)69", 1)
	M.on_mob_jump(get_turf(usr))

ADMIN_VERB_ADD(/client/proc/Getkey, R_ADMIN, FALSE)
//teleports a69ob with a certain ckey to our location
/client/proc/Getkey()
	set category = "Admin"
	set name = "Get Key"
	set desc = "Key to teleport"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	var/list/keys = list()
	for(var/mob/M in GLOB.player_list)
		keys +=69.client
	var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in sortKey(keys)
	if(!selection)
		return
	var/mob/M = selection:mob

	if(!M)
		return
	log_admin("69key_name(usr)69 teleported 69key_name(M)69")
	message_admins("69key_name_admin(usr)69 teleported 69key_name(M)69", 1)
	if(M)
		M.on_mob_jump(get_turf(usr))