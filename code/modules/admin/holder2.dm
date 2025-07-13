GLOBAL_LIST_EMPTY(admin_datums)

GLOBAL_VAR_INIT(href_token, GenerateToken())
GLOBAL_PROTECT(href_token)

/datum/admins
	var/target
	var/name = "nobody's admin datum (no rank)" //Makes for better runtimes
	var/rank			= "Temporary Admin"
	var/client/owner	= null
	var/rights = 0
	var/fakekey			= null

	var/deadmined

	var/datum/weakref/marked_datum_weak

	var/admincaster_screen = 0	//See newscaster.dm under machinery for a full description
	var/datum/feed_message/admincaster_feed_message = new /datum/feed_message   //These two will act as holders.
	var/datum/feed_channel/admincaster_feed_channel = new /datum/feed_channel
	var/admincaster_signature	//What you'll sign the newsfeeds as

	var/href_token

	var/given_profiling = FALSE

/datum/admins/proc/marked_datum()
	if(marked_datum_weak)
		return marked_datum_weak.resolve()

/datum/admins/New(initial_rank = "Temporary Admin", initial_rights = 0, ckey)
	if(IsAdminAdvancedProcCall())
		var/msg = " has tried to elevate permissions!"
		message_admins("[key_name_admin(usr)][msg]")
		log_admin("[key_name(usr)][msg]")
		if (!target) //only del if this is a true creation (and not just a New() proc call), other wise trialmins/coders could abuse this to deadmin other admins
			QDEL_IN(src, 0)
			CRASH("Admin proc call creation of admin datum")
		return
	if(!ckey)
		error("Admin datum created without a ckey argument.")
		qdel(src)
		return
	admincaster_signature = "[GLOB.company_name] Officer #[rand(0,9)][rand(0,9)][rand(0,9)]"
	href_token = GenerateToken()
	name = "[ckey]'s admin datum ([rank])"
	target = ckey
	rank = initial_rank
	rights = initial_rights
	try_give_devtools(owner)
	GLOB.admin_datums[ckey] = src

/datum/admins/Destroy()
	if(IsAdminAdvancedProcCall())
		var/msg = " has tried to elevate permissions! (destroy)"
		message_admins("[key_name_admin(usr)][msg]")
		log_admin("[key_name(usr)][msg]")
		return QDEL_HINT_LETMELIVE
	. = ..()

/datum/admins/proc/associate(client/client)
	if(IsAdminAdvancedProcCall())
		var/msg = " has tried to elevate permissions! (associate)"
		message_admins("[key_name_admin(usr)][msg]")
		log_admin("[key_name(usr)][msg]")
		return

	if(!istype(client))
		return

	owner = client
	owner.holder = src
	owner.add_admin_verbs()	//TODO
	GLOB.deadmins -= target
	GLOB.admins |= client
	try_give_devtools(client)
	try_give_profiling(client)

/datum/admins/proc/disassociate()
	if(IsAdminAdvancedProcCall())
		var/msg = " has tried to elevate permissions! (dissociate)"
		message_admins("[key_name_admin(usr)][msg]")
		log_admin("[key_name(usr)][msg]")
		return
	if(owner)
		GLOB.admins -= owner
		GLOB.deadmins += target
		owner.remove_admin_verbs()
		owner.deadmin_holder = owner.holder
		owner.holder = null

/datum/admins/proc/reassociate()
	if(IsAdminAdvancedProcCall())
		var/msg = " has tried to elevate permissions! (reassociate)"
		message_admins("[key_name_admin(usr)][msg]")
		log_admin("[key_name(usr)][msg]")
		return

	if(owner)
		GLOB.admins += owner
		GLOB.deadmins -= target

		owner.holder = src
		owner.deadmin_holder = null
		owner.add_admin_verbs()

/datum/admins/proc/try_give_devtools(client/client = usr)
	if(!check_rights(R_DEBUG, C = client))
		return
	winset(client, null, "browser-options=byondstorage,find,refresh,devtools")

/datum/admins/proc/try_give_profiling(client/client = usr)
	if (CONFIG_GET(flag/forbid_admin_profiling) || CONFIG_GET(flag/forbid_all_profiling))
		return

	if (given_profiling)
		return

	if (!check_rights(R_DEBUG))
		return

	given_profiling = TRUE
	world.SetConfig("APP/admin", owner?.ckey || target, "role=admin")


/// Get the permissions this admin is allowed to edit on other ranks
/datum/admins/proc/can_edit_rights_flags()
	var/combined_flags = NONE

	// for (var/datum/admin_rank/rank as anything in ranks)
	// 	combined_flags |= rank.can_edit_rights
	for (var/rankrights as anything in GLOB.admin_ranks)
		combined_flags |= rankrights

	return combined_flags

/*
checks if usr is an admin with at least ONE of the flags in rights_required. (Note, they don't need all the flags)
if rights_required == 0, then it simply checks if they are an admin.
if it doesn't return 1 and show_msg=1 it will prints a message explaining why the check has failed
generally it would be used like so:

/proc/admin_proc()
	if(!check_rights(R_ADMIN)) return
	to_chat(world, "Hi, I’m Saul Goodman. Did you know that you have rights?")

NOTE: It checks usr by default. Supply the "C" argument if you wish to check for a specific client/mob.
*/
/proc/check_rights(rights_required, show_msg=1, client/C = usr)
	if(ismob(C))
		var/mob/M = C
		C = M.client
	if(!C)
		return FALSE
	if(!(isclient(C))) // If we still didn't find a client, something is wrong.
		return FALSE
	if(!C.holder)
		if(show_msg)
			C << span_warning("Error: You are not an admin.")
		return FALSE

	if(rights_required)
		if(rights_required & C.holder.rights)
			return TRUE
		else
			if(show_msg)
				C << span_warning("Error: You do not have sufficient rights to do that. You require one of the following flags:[rights2text(rights_required," ")].")
			return FALSE
	else
		return TRUE

//probably a bit iffy - will hopefully figure out a better solution
/proc/check_if_greater_rights_than(client/other)
	if(usr && usr.client)
		if(usr.client.holder)
			if(!other || !other.holder)
				return 1
			if(usr.client.holder.rights != other.holder.rights)
				if( (usr.client.holder.rights & other.holder.rights) == other.holder.rights )
					return 1	//we have all the rights they have and more
		to_chat(usr, "<font color='red'>Error: Cannot proceed. They have more or equal rights to us.</font>")
	return 0


/proc/GenerateToken()
	. = ""
	for(var/I in 1 to 32)
		. += "[rand(10)]"

/proc/RawHrefToken(forceGlobal = FALSE)
	var/tok = GLOB.href_token
	if(!forceGlobal && usr)
		var/client/C = usr.client
		if(!C)
			CRASH("No client for HrefToken()!")
		var/datum/admins/holder = C.holder
		if(holder)
			tok = holder.href_token
	return tok

/proc/HrefToken(forceGlobal = FALSE)
	return "admin_token=[RawHrefToken(forceGlobal)]"

/proc/HrefTokenFormField(forceGlobal = FALSE)
	return "<input type='hidden' name='admin_token' value='[RawHrefToken(forceGlobal)]'>"
