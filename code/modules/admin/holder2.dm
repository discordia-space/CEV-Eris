var/list/admin_datums = list()

/datum/admins
	var/rank			= "Temporary Admin"
	var/client/owner	= null
	var/rights = 0
	var/fakekey			= null
	var/name = "nobody's admin datum (no rank)" //Makes for better runtimes
	var/target
	var/datum/marked_datum

	var/admincaster_screen = 0	//See newscaster.dm under machinery for a full description
	var/datum/feed_message/admincaster_feed_message = new /datum/feed_message   //These two will act as holders.
	var/datum/feed_channel/admincaster_feed_channel = new /datum/feed_channel
	var/admincaster_signature	//What you'll sign the newsfeeds as
	var/datum/filter_editor/filteriffic

/datum/admins/proc/marked_datum()
	if(marked_datum)
		return marked_datum

/datum/admins/New(initial_rank = "Temporary Admin", initial_rights = 0, ckey)
	if(!ckey)
		QDEL_IN(src, 0)
		CRASH("Admin datum created without a ckey")
	target = ckey
	name = "[ckey]'s admin datum ([initial_rank])"
	rank = initial_rank
	admincaster_signature = "[company_name] Officer #[rand(0,9)][rand(0,9)][rand(0,9)]"
	rights = initial_rights
	if(rights & R_DEBUG) //grant profile access
		world.SetConfig("APP/admin", ckey, "role=admin")
	admin_datums[target] = src

/datum/admins/proc/associate(client/C)
	if(istype(C))
		if(C.ckey != target)
			var/msg = " has attempted to associate with [target]'s admin datum"
			message_admins("[key_name_admin(C)][msg]")
			log_admin("[key_name(C)][msg]")
			return
		// if (deadmined)
		// 	activate()
		owner = C
		owner.holder = src
		owner.add_admin_verbs() //TODO <--- todo what? the proc clearly exists and works since its the backbone to our entire admin system
		// remove_verb(owner, /client/proc/readmin)
		owner.init_verbs() //re-initialize the verb list
		admins |= C

/datum/admins/proc/disassociate()
	if(owner)
		admins -= owner
		owner.remove_admin_verbs()
		owner.init_verbs()
		owner.deadmin_holder = owner.holder
		owner.holder = null

/datum/admins/proc/reassociate()
	if(owner)
		admins += owner
		owner.holder = src
		owner.deadmin_holder = null
		owner.add_admin_verbs()

/datum/admins/proc/check_if_greater_rights_than_holder(datum/admins/other)
	if(!other)
		return TRUE //they have no rights
	if(rights == R_MAXPERMISSION)
		return TRUE //we have all the rights
	if(src == other)
		return TRUE //you always have more rights than yourself
	if(rights != other.rights)
		if( (rights & other.rights) == other.rights )
			return TRUE //we have all the rights they have and more
	return FALSE

/datum/admins/vv_edit_var(var_name, var_value)
	return FALSE //nice try trialmin

/*
checks if usr is an admin with at least ONE of the flags in rights_required. (Note, they don't need all the flags)
if rights_required == 0, then it simply checks if they are an admin.
if it doesn't return 1 and show_msg=1 it will prints a message explaining why the check has failed
generally it would be used like so:

/proc/admin_proc()
	if(!check_rights(R_ADMIN))
		return
	to_chat(world, "you have enough rights!", confidential = TRUE)

NOTE: it checks usr! not src! So if you're checking somebody's rank in a proc which they did not call
you will have to do something like if(client.rights & R_ADMIN) yourself.
*/
/proc/check_rights(rights_required, show_msg=1)
	if(usr?.client)
		if (check_rights_for(usr.client, rights_required))
			return TRUE
		else
			if(show_msg)
				to_chat(usr, "<font color='red'>Error: You do not have sufficient rights to do that. You require one of the following flags:[rights2text(rights_required," ")].</font>", confidential = TRUE)
	return FALSE

/datum/admins/proc/check_for_rights(rights_required)
	if(rights_required && !(rights_required & rights))
		return FALSE
	return TRUE

//probably a bit iffy - will hopefully figure out a better solution
/proc/check_if_greater_rights_than(client/other)
	if(usr?.client)
		if(usr.client.holder)
			if(!other || !other.holder)
				return TRUE
			return usr.client.holder.check_if_greater_rights_than_holder(other.holder)
	return FALSE

/client/proc/deadmin()
	if(holder)
		holder.disassociate()
		//qdel(holder)
	return 1

/proc/HrefToken(forceGlobal = FALSE)
	return "admin_token=CODEMEPLS" // [RawHrefToken(forceGlobal)]
