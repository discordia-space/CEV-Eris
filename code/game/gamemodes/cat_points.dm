/*	cat_points
	Everything cat_points related is here.
	Part of cat_points purchase is handled in client_procs.dm	*/

/proc/sql_report_cat_points(mob/spender, mob/receiver)
	var/sqlspendername = sanitizeSQL(spender.name)
	var/sqlspenderkey = sanitizeSQL(spender.ckey)
	var/sqlreceivername = sanitizeSQL(receiver.name)
	var/sqlreceiverkey = sanitizeSQL(receiver.ckey)
	var/sqlspenderip = spender.client.address


	if(!dbcon.IsConnected())
		log_game("SQL ERROR during cat_points logging. Failed to connect.")
	else
		var/sqltime = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")
		var/DBQuery/query = dbcon.NewQuery("INSERT INTO cat_points (spendername, spenderkey, receivername, receiverkey, spenderip, time) VALUES ('[sqlspendername]', '[sqlspenderkey]', '[sqlreceivername]', '[sqlreceiverkey]', '[sqlspenderip]', '[sqltime]')")
		if(!query.Execute())
			var/err = query.ErrorMsg()
			log_game("SQL ERROR during cat_points logging. Error : \[[err]\]\n")


		query = dbcon.NewQuery("SELECT * FROM cat_pointstotals WHERE byondkey='[sqlreceiverkey]'")
		query.Execute()

		var/cat_points
		var/id
		while(query.NextRow())
			id = query.item[1]
			cat_points = text2num(query.item[3])
		if(cat_points == null)
			cat_points = 1
			query = dbcon.NewQuery("INSERT INTO cat_pointstotals (byondkey, cat_points) VALUES ('[sqlreceiverkey]', [cat_points])")
			if(!query.Execute())
				var/err = query.ErrorMsg()
				log_game("SQL ERROR during cat_pointstotal logging (adding new key). Error : \[[err]\]\n")
		else
			cat_points++
			query = dbcon.NewQuery("UPDATE cat_pointstotals SET cat_points=[cat_points] WHERE id=[id]")
			if(!query.Execute())
				var/err = query.ErrorMsg()
				log_game("SQL ERROR during cat_pointstotal logging (updating existing entry). Error : \[[err]\]\n")

GLOBAL_LIST_EMPTY(cat_points_spenders)

// Returns TRUE if mob can give cat_points at all; if not, tells them why
/mob/proc/can_give_cat_points()
	if(!client)
		to_chat(src, SPAN_WARNING("You can't award cat_points without being connected."))
		return FALSE
	if(config.disable_cat_points)
		to_chat(src, SPAN_WARNING("cat_points is disabled."))
		return FALSE
	if(!SSticker || !GLOB.player_list.len || (SSticker.current_state == GAME_STATE_PREGAME))
		to_chat(src, SPAN_WARNING("You can't award cat_points until the game has started."))
		return FALSE
	if(client.cat_points_spent || (ckey in GLOB.cat_points_spenders))
		to_chat(src, SPAN_WARNING("You've already spent your cat_points for the round."))
		return FALSE
	return TRUE

// Returns TRUE if mob can give cat_points to M; if not, tells them why
/mob/proc/can_give_cat_points_to_mob(mob/M)
	if(!can_give_cat_points())
		return FALSE
	if(!istype(M))
		to_chat(src, SPAN_WARNING("That's not a mob."))
		return FALSE
	if(!M.client)
		to_chat(src, SPAN_WARNING("That mob has no client connected at the moment."))
		return FALSE
	//if(M.ckey == ckey) //Evan uncoment
	//	to_chat(src, SPAN_WARNING("You can't spend cat_points on yourself!"))
	//	return FALSE
	//if(client.address == M.client.address)
	//	message_admins(SPAN_WARNING("Illegal cat_points spending attempt detected from [key] to [M.key]. Using the same IP!"))
	//	log_game("Illegal cat_points spending attempt detected from [key] to [M.key]. Using the same IP!")
	//	to_chat(src, SPAN_WARNING("You can't spend cat_points on someone connected from the same IP."))
	//	return FALSE
	if(!M.get_preference_value(/datum/client_preference/cat_points) == GLOB.PREF_YES)
		to_chat(src, SPAN_WARNING("That player has turned off incoming cat_points."))
		return FALSE
	return TRUE


/mob/verb/spend_cat_points_list()
	set name = "Award cat_points"
	set desc = "Let the gods know whether someone's been nice. Can only be used once per round."
	set category = "Special Verbs"

	if(!can_give_cat_points())
		return

	var/list/cat_points_list = list()
	for(var/mob/M in GLOB.player_list)
		if(!(M.client && M.mind))
			continue
		//if(M == src) // //Evan uncoment it
		//	continue
		if(!isobserver(src) && player_is_antag(M.mind) && !player_is_ship_antag(M.mind))
			continue // Don't include special roles for non-observers, because players use it to meta
		cat_points_list += M

	if(!cat_points_list.len)
		to_chat(usr, SPAN_WARNING("There's no-one to spend your cat_points on."))
		return

	var/pickedmob = input("Who would you like to award cat_points to?", "Award cat_points", "Cancel") as null|mob in cat_points_list

	if(isnull(pickedmob))
		return

	spend_cat_points(pickedmob)

/mob/verb/spend_cat_points(mob/M)
	set name = "Award cat_points to Player"
	set desc = "Let the gods know whether someone's been nice. Can only be used once per round."
	set category = "Special Verbs"

	if(!M)
		to_chat(usr, "Please right click a mob to award cat_points directly, or use the 'Award cat_points' verb to select a player from the player listing.")
		return
	if(config.disable_cat_points) // this is here because someone thought it was a good idea to add an alert box before checking if they can even give a mob cat_points
		to_chat(usr, SPAN_WARNING("cat_points is disabled."))
		return
	if(alert("Give [M.name] good cat_points?", "cat_points", "Yes", "No") != "Yes")
		return
	if(!can_give_cat_points_to_mob(M))
		return // Check again, just in case things changed while the alert box was up

	M.client.cat_points++
	to_chat(usr, "Good cat_points spent on [M.name].")
	client.cat_points_spent = TRUE
	GLOB.cat_points_spenders += ckey

	var/cat_points_diary = file("data/log/cat_points.log")
	cat_points_diary << "[M.name] ([M.key]): [M.client.cat_points] - [time2text(world.timeofday, "hh:mm:ss")] given by [key]"

	sql_report_cat_points(src, M)

/client/verb/check_cat_points()
	set name = "Check cat_points"
	set desc = "Reports how much cat_points you have accrued."
	set category = "Special Verbs"

	if(config.disable_cat_points)
		to_chat(src, SPAN_WARNING("cat_points is disabled."))
		return

	var/currentcat_points = verify_cat_points()
	if(!isnull(currentcat_points))
		to_chat(usr, {"<br>You have <b>[currentcat_points]</b> available."})

/client/proc/verify_cat_points()
	var/currentcat_points = 0
	var/sanitzedkey = sanitizeSQL(src.ckey)
	if(!dbcon.IsConnected())
		to_chat(usr, SPAN_WARNING("Unable to connect to cat_points database. Please try again later.<br>"))
		return
	else
		var/DBQuery/query = dbcon.NewQuery("SELECT cat_points, cat_pointsspent FROM cat_pointstotals WHERE byondkey='[sanitzedkey]'")
		query.Execute()

		var/totalcat_points
		var/cat_pointsspent
		while(query.NextRow())
			totalcat_points = query.item[1]
			cat_pointsspent = query.item[2]
		currentcat_points = (text2num(totalcat_points) - text2num(cat_pointsspent))

	return currentcat_points
