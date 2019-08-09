/mob/proc/on_mob_jump(var/turf/T)
	if (istype(loc, /obj/mecha))
		var/obj/mecha/M = loc
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

	if(config.allow_admin_jump)
		var/new_location = safepick(get_area_turfs(A))

		if(new_location)
			usr.on_mob_jump(new_location)
			log_admin("[key_name(usr)] jumped to [A]")
			message_admins("[key_name_admin(usr)] jumped to [A]", 1)
		else
			alert("Admin jump failed due to missing [A] area turfs.")

	else
		alert("Admin jumping disabled")

ADMIN_VERB_ADD(/client/proc/jumptoturf, R_ADMIN, FALSE)
//allows us to jump to a specific turf
/client/proc/jumptoturf(var/turf/T in turfs)
	set name = "Jump to Turf"
	set category = "Admin"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return
	if(config.allow_admin_jump)
		log_admin("[key_name(usr)] jumped to [T.x],[T.y],[T.z] in [T.loc]")
		message_admins("[key_name_admin(usr)] jumped to [T.x],[T.y],[T.z] in [T.loc]", 1)

		//When inside a mech, move the mech instead of teleporting out of it
		usr.on_mob_jump(T)

	else
		alert("Admin jumping disabled")
	return

ADMIN_VERB_ADD(/client/proc/jumptomob, R_ADMIN|R_DEBUG, FALSE)
//allows us to jump to a specific mob
/client/proc/jumptomob(var/mob/M in SSmobs.mob_list)
	set category = "Admin"
	set name = "Jump to Mob"


	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if(config.allow_admin_jump)
		log_admin("[key_name(usr)] jumped to [key_name(M)]")
		message_admins("[key_name_admin(usr)] jumped to [key_name_admin(M)]", 1)
		if(src.mob)
			var/mob/A = src.mob
			var/turf/T = get_turf(M)
			if(T && isturf(T))

				A.on_mob_jump(T)
			else
				to_chat(A, "This mob is not located in the game world.")
	else
		alert("Admin jumping disabled")

ADMIN_VERB_ADD(/client/proc/jumptocoord, R_ADMIN|R_DEBUG, FALSE)
//we ghost and jump to a coordinate
/client/proc/jumptocoord(tx as num, ty as num, tz as num)
	set category = "Admin"
	set name = "Jump to Coordinate"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if (config.allow_admin_jump)
		if(src.mob)
			var/mob/A = src.mob
			A.on_mob_jump(locate(tx,ty,tz))

		message_admins("[key_name_admin(usr)] jumped to coordinates [tx], [ty], [tz]")

	else
		alert("Admin jumping disabled")

ADMIN_VERB_ADD(/client/proc/jumptokey, R_ADMIN, TRUE)
//allows us to jump to the location of a mob with a certain ckey
/client/proc/jumptokey()
	set category = "Admin"
	set name = "Jump to Key"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if(config.allow_admin_jump)
		var/list/keys = list()
		for(var/mob/M in GLOB.player_list)
			keys += M.client
		var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in sortKey(keys)
		if(!selection)
			to_chat(src, "No keys found.")
			return
		var/mob/M = selection:mob
		log_admin("[key_name(usr)] jumped to [key_name(M)]")
		message_admins("[key_name_admin(usr)] jumped to [key_name_admin(M)]", 1)
		usr.on_mob_jump(get_turf(M))

	else
		alert("Admin jumping disabled")

ADMIN_VERB_ADD(/client/proc/Getmob, R_ADMIN, FALSE)
//teleports a mob to our location
/client/proc/Getmob(var/mob/M in SSmobs.mob_list)
	set category = "Admin"
	set name = "Get Mob"
	set desc = "Mob to teleport"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return
	if(config.allow_admin_jump)
		log_admin("[key_name(usr)] teleported [key_name(M)]")
		message_admins("[key_name_admin(usr)] teleported [key_name_admin(M)]", 1)
		M.on_mob_jump(get_turf(usr))

	else
		alert("Admin jumping disabled")

ADMIN_VERB_ADD(/client/proc/Getkey, R_ADMIN, FALSE)
//teleports a mob with a certain ckey to our location
/client/proc/Getkey()
	set category = "Admin"
	set name = "Get Key"
	set desc = "Key to teleport"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG))
		return

	if(config.allow_admin_jump)
		var/list/keys = list()
		for(var/mob/M in GLOB.player_list)
			keys += M.client
		var/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in sortKey(keys)
		if(!selection)
			return
		var/mob/M = selection:mob

		if(!M)
			return
		log_admin("[key_name(usr)] teleported [key_name(M)]")
		message_admins("[key_name_admin(usr)] teleported [key_name(M)]", 1)
		if(M)
			M.on_mob_jump(get_turf(usr))

	else
		alert("Admin jumping disabled")