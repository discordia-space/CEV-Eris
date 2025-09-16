
/client/verb/adminhelp(msg as text)
	set category = "Admin"
	set name = "Adminhelp"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_red("Speech is currently admin-disabled."))
		return

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, span_danger("Error: Admin-PM: You cannot send adminhelps (Muted)."), confidential = TRUE)
		return

	adminhelped = 1 //Determines if they get the message to reply by clicking the name.

	if(src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	//clean the input msg
	if(!msg)
		return
	msg = sanitize(msg)
	if(!msg)
		return

	var/original_msg = msg


	if(!mob) //this doesn't happen
		return

	//show it to the person adminhelping too
	to_chat(src, "<font color='blue'>PM to-<b>Staff </b>: [msg]</font>", confidential = TRUE)

	// Mentors won't see coloring of names on people with special_roles (Antags, etc.)
	// var/mentor_msg = span_blue("<b><font color=red>Request for Help: </font>[get_options_bar(mob, 4, 1, 1, 0)]:</b> [msg]")

	// Send adminhelp message to Discord chat
	send2adminchat(key_name(src), original_msg)

	// Assuming it is an an admin help and not a mentor help
	SStickets.newHelpRequest(src, msg) // Ahelp

	// SSmentor_tickets.newHelpRequest(src, mentormsg) // Mhelp (for mentors if they ever get implemented)

	return

/proc/keywords_lookup(msg,external)

	//This is a list of words which are ignored by the parser when comparing message contents for names. MUST BE IN LOWER CASE!
	var/list/adminhelp_ignored_words = list("unknown","the","a","an","of","monkey","alien","as", "i")

	//explode the input msg into a list
	var/list/msglist = splittext(msg, " ")

	//generate keywords lookup
	var/list/surnames = list()
	var/list/forenames = list()
	var/list/ckeys = list()
	var/founds = ""
	for(var/mob/M in GLOB.mob_list)
		var/list/indexing = list(M.real_name, M.name)
		if(M.mind)
			indexing += M.mind.name

		for(var/string in indexing)
			var/list/L = splittext(string, " ")
			var/surname_found = 0
			//surnames
			for(var/i=L.len; i >= 1; i--)
				var/word = ckey(L[i])
				if(word)
					surnames[word] = M
					surname_found = i
					break
			//forenames
			for(var/i in 1 to surname_found-1)
				var/word = ckey(L[i])
				if(word)
					forenames[word] = M
			//ckeys
			ckeys[M.ckey] = M

	var/ai_found = 0
	msg = ""
	var/list/mobs_found = list()
	for(var/original_word in msglist)
		var/word = ckey(original_word)
		if(word)
			if(!(word in adminhelp_ignored_words))
				if(word == "ai")
					ai_found = 1
				else
					var/mob/found = ckeys[word]
					if(!found)
						found = surnames[word]
						if(!found)
							found = forenames[word]
					if(found)
						if(!(found in mobs_found))
							mobs_found += found
							if(!ai_found && isAI(found))
								ai_found = 1
							var/is_antag = 0
							if(is_special_character(found))
								is_antag = 1
							founds += "Name: [found.name]([found.real_name]) Key: [found.key] Ckey: [found.ckey] [is_antag ? "(Antag)" : null] "
							msg += "[original_word]<font size='1' color='[is_antag ? "red" : "black"]'>(<A HREF='byond://?_src_=holder;[HrefToken(forceGlobal = TRUE)];adminmoreinfo=[REF(found)]'>?</A>|<A HREF='byond://?_src_=holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservefollow=[REF(found)]'>F</A>)</font> "
							continue
		msg += "[original_word] "
	if(external)
		if(founds == "")
			return "Search Failed"
		else
			return founds

	return msg

/proc/get_mob_by_name(msg)
	//This is a list of words which are ignored by the parser when comparing message contents for names. MUST BE IN LOWER CASE!
	var/list/ignored_words = list("unknown","the","a","an","of","monkey","alien","as", "i")

	//explode the input msg into a list
	var/list/msglist = splittext(msg, " ")

	//who might fit the shoe
	var/list/potential_hits = list()

	for(var/i in GLOB.mob_list)
		var/mob/M = i
		var/list/nameWords = list()
		if(!M.mind)
			continue

		for(var/string in splittext(lowertext(M.real_name), " "))
			if(!(string in ignored_words))
				nameWords += string
		for(var/string in splittext(lowertext(M.name), " "))
			if(!(string in ignored_words))
				nameWords += string

		for(var/string in nameWords)
			if(string in msglist)
				potential_hits += M
				break

	return potential_hits

/**
 * Checks a given message to see if any of the words are something we want to treat specially, as detailed below.
 *
 * There are 3 cases where a word is something we want to act on
 * 1. Admin pings, like @adminckey. Pings the admin in question, text is not clickable
 * 2. Datum refs, like @0x2001169 or @mob_23. Clicking on the link opens up the VV for that datum
 * 3. Ticket refs, like #3. Displays the status and ahelper in the link, clicking on it brings up the ticket panel for it.
 * Returns a list being used as a tuple. Index ASAY_LINK_NEW_MESSAGE_INDEX contains the new message text (with clickable links and such)
 * while index ASAY_LINK_PINGED_ADMINS_INDEX contains a list of pinged admin clients, if there are any.
 *
 * Arguments:
 * * msg - the message being scanned
 */
/proc/check_asay_links(msg)
	var/list/msglist = splittext(msg, " ") //explode the input msg into a list
	var/list/pinged_admins = list() // if we ping any admins, store them here so we can ping them after
	var/modified = FALSE // did we find anything?

	var/i = 0
	for(var/word in msglist)
		i++
		if(!length(word))
			continue

		switch(word[1])
			if("@")
				var/stripped_word = ckey(copytext(word, 2))

				// first we check if it's a ckey of an admin
				var/client/client_check = GLOB.directory[stripped_word]
				if(client_check?.holder)
					msglist[i] = "<u>[word]</u>"
					pinged_admins[stripped_word] = client_check
					modified = TRUE
					continue

				// then if not, we check if it's a datum ref

				var/word_with_brackets = "\[[stripped_word]\]" // the actual memory address lookups need the bracket wraps
				var/datum/datum_check = locate(word_with_brackets)
				if(!istype(datum_check))
					continue
				msglist[i] = "<u><a href='byond://?_src_=vars;[HrefToken(forceGlobal = TRUE)];Vars=[word_with_brackets]'>[word]</A></u>"
				modified = TRUE

			if("#") // check if we're linking a ticket
				var/possible_ticket_id = text2num(copytext(word, 2))
				if(!possible_ticket_id)
					continue

				var/datum/ticket/ahelp_check = SStickets.allTickets[possible_ticket_id]
				if(!ahelp_check)
					continue

				var/state_word
				switch(ahelp_check.ticketState)
					if(TICKET_OPEN)
						state_word = "Open"
					if(TICKET_CLOSED)
						state_word = "Closed"
					if(TICKET_RESOLVED)
						state_word = "Resolved"
					if(TICKET_STALE)
						state_word = "Stale"

				msglist[i]= "<u><A href='byond://?_src_=holder;[HrefToken(forceGlobal = TRUE)];ahelp=[REF(ahelp_check)];ahelp_action=ticket'>[word] ([state_word] | [ahelp_check.client_ckey])</A></u>"
				modified = TRUE

	if(modified)
		var/list/return_list = list()
		return_list[ASAY_LINK_NEW_MESSAGE_INDEX] = jointext(msglist, " ") // without tuples, we must make do!
		return_list[ASAY_LINK_PINGED_ADMINS_INDEX] = pinged_admins
		return return_list

//
// HELPER PROCS
//

/proc/get_admin_counts(requiredflags = R_ADMIN)
	. = list("total" = list(), "noflags" = list(), "afk" = list(), "stealth" = list(), "present" = list())
	for(var/client/X in GLOB.admins)
		.["total"] += X
		if(requiredflags != NONE && !check_rights_for(X, requiredflags))
			.["noflags"] += X
		else if(X.is_afk())
			.["afk"] += X
		else if(X.holder.fakekey)
			.["stealth"] += X
		else
			.["present"] += X

/proc/send2tgs_adminless_only(source, msg, requiredflags = R_BAN)
	var/list/adm = get_admin_counts(requiredflags)
	var/list/activemins = adm["present"]
	. = activemins.len
	if(. <= 0)
		var/final = ""
		var/list/afkmins = adm["afk"]
		var/list/stealthmins = adm["stealth"]
		var/list/powerlessmins = adm["noflags"]
		var/list/allmins = adm["total"]
		if(!afkmins.len && !stealthmins.len && !powerlessmins.len)
			final = "[msg] - No admins online"
		else
			final = "[msg] - All admins stealthed\[[english_list(stealthmins)]\], AFK\[[english_list(afkmins)]\], or lacks +BAN\[[english_list(powerlessmins)]\]! Total: [allmins.len] "
		send2adminchat(source,final)
		send2otherserver(source,final)

/**
 * Sends a message to a set of cross-communications-enabled servers using world topic calls
 *
 * Arguments:
 * * source - Who sent this message
 * * msg - The message body
 * * type - The type of message, becomes the topic command under the hood
 * * target_servers - A collection of servers to send the message to, defined in config
 * * additional_data - An (optional) associated list of extra parameters and data to send with this world topic call
 */
/proc/send2otherserver(source, msg, type = "Ahelp", target_servers, list/additional_data = list())
	if(!CONFIG_GET(string/comms_key))
		debug_world_log("Server cross-comms message not sent for lack of configured key")
		return

	var/our_id = CONFIG_GET(string/cross_comms_name)
	additional_data["message_sender"] = source
	additional_data["message"] = msg
	additional_data["source"] = "([our_id])"
	additional_data += type

	var/list/servers = CONFIG_GET(keyed_list/cross_server)
	for(var/I in servers)
		if(I == our_id) //No sending to ourselves
			continue
		if(target_servers && !(I in target_servers))
			continue
		world.send_cross_comms(I, additional_data)

/// Sends a message to a given cross comms server by name (by name for security).
/world/proc/send_cross_comms(server_name, list/message, auth = TRUE)
	set waitfor = FALSE
	if (auth)
		var/comms_key = CONFIG_GET(string/comms_key)
		if(!comms_key)
			debug_world_log("Server cross-comms message not sent for lack of configured key")
			return
		message["key"] = comms_key
	var/list/servers = CONFIG_GET(keyed_list/cross_server)
	var/server_url = servers[server_name]
	if (!server_url)
		CRASH("Invalid cross comms config: [server_name]")
	world.Export("[server_url]?[list2params(message)]")
