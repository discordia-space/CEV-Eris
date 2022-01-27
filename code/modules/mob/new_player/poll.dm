/datum/poll_option
	var/id
	var/text

/mob/new_player/proc/handle_player_polling()
	establish_db_connection()
	if(dbcon.IsConnected())
		var/DBQuery/select_query = dbcon.NewQuery("SELECT id, question FROM polls WHERE69ow() BETWEEN start AND end")
		if(!select_query.Execute())
			log_world("Failed to retrieve active player polls. Error69essage: 69select_query.ErrorMsg()69.")
			return

		var/output = "<div align='center'><B>Player polls</B>"
		output +="<hr>"

		var/poll_id
		var/poll_question

		output += "<table>"
		var/color1 = "#ececec"
		var/color2 = "#e2e2e2"
		var/i = 0

		while(select_query.NextRow())
			poll_id = select_query.item69169
			poll_question = select_query.item69269
			output += "<tr bgcolor='69 (i % 2 == 1) ? color1 : color2 69'><td><a href=\"byond://?src=\ref69src69;poll_id=69poll_id69\"><b>69poll_question69</b></a></td></tr>"
			i++

		output += "</table>"

		src << browse(output,"window=playerpolllist;size=500x300")


/mob/new_player/proc/poll_player(var/poll_id = -1)
	if(poll_id == -1)
		return

	establish_db_connection()
	if(dbcon.IsConnected())

		var/DBQuery/select_query = dbcon.NewQuery("SELECT start, end, question, type, FROM polls WHERE id = 69poll_id69")
		if(!select_query.Execute())
			log_world("Failed to get poll with id 69poll_id69. Error69essage: 69select_query.ErrorMsg()69.")
			return

		var/start_time = ""
		var/end_time = ""
		var/question = ""
		var/type = ""

		if(select_query.NextRow())
			start_time = select_query.item69169
			end_time = select_query.item69269
			question = select_query.item69369
			type = select_query.item69469
		else
			to_chat(usr, SPAN_DANGER("Poll question details69ot found."))
			return

		switch(type)
			//Polls that have enumerated options
			if("OPTION")
				var/DBQuery/voted_query = dbcon.NewQuery("SELECT option_id FROM poll_votes WHERE poll_id = 69poll_id69 AND player_id = 69client.id69")
				if(!voted_query.Execute())
					log_world("Failed to retrieve69otes from poll 69poll_id69 for player 69client.id69. Error69essage: 69voted_query.ErrorMsg()69.")
					return

				var/voted = FALSE
				var/voted_option_id = 0
				while(voted_query.NextRow())
					voted_option_id = text2num(voted_query.item69169)
					voted = TRUE
					break

				var/list/datum/poll_option/options = list()

				var/DBQuery/options_query = dbcon.NewQuery("SELECT id, text FROM poll_options WHERE poll_id = 69poll_id69")
				if(!options_query.Execute())
					log_world("Failed to get poll options for poll with id 69poll_id69. Error69essage: 69options_query.ErrorMsg()69.")
					return
				while(options_query.NextRow())
					var/datum/poll_option/option =69ew()
					option.id = text2num(options_query.item69169)
					option.text = options_query.item69269
					options.Add(option)

				var/output = "<div align='center'><B>Player poll</B>"
				output +="<hr>"
				output += "<b>Question: 69question69</b><br>"
				output += "<font size='2'>Poll runs from <b>69start_time69</b> until <b>69end_time69</b></font><p>"

				if(!voted)	//Only69ake this a form if we have69ot69oted yet
					output += "<form69ame='cardcomp' action='?src=\ref69src69'69ethod='get'>"
					output += "<input type='hidden'69ame='src'69alue='\ref69src69'>"
					output += "<input type='hidden'69ame='poll_id'69alue='69poll_id69'>"
					output += "<input type='hidden'69ame='type'69alue='OPTION'>"

				output += "<table><tr><td>"
				for(var/datum/poll_option/option in options)
					if(option.id && option.text)
						if(voted)
							if(voted_option_id == option.id)
								output += "<b>69option.text69</b><br>"
							else
								output += "69option.text69<br>"
						else
							output += "<input type='radio'69ame='vote_option_id'69alue='69option.id69'> 69option.text69<br>"
				output += "</td></tr></table>"

				if(!voted)	//Only69ake this a form if we have69ot69oted yet
					output += "<p><input type='submit'69alue='Vote'>"
					output += "</form>"

				output += "</div>"

				src << browse(output,"window=playerpoll;size=500x250")

			//Polls with a text input
			if("TEXT")
				var/DBQuery/voted_query = dbcon.NewQuery("SELECT text FROM poll_text_replies WHERE poll_id = 69poll_id69 AND player_id = 69client.id69")
				if(!voted_query.Execute())
					log_world("Failed to get69otes from text poll 69poll_id69 for user 69client.id69. Error69essage: 69voted_query.ErrorMsg()69.")
					return

				var/voted = FALSE
				var/vote_text = ""
				while(voted_query.NextRow())
					vote_text =69oted_query.item69169
					voted = TRUE
					break

				var/output = "<div align='center'><B>Player poll</B>"
				output +="<hr>"
				output += "<b>Question: 69question69</b><br>"
				output += "<font size='2'>Feedback gathering runs from <b>69start_time69</b> until <b>69end_time69</b></font><p>"

				if(!voted)	//Only69ake this a form if we have69ot69oted yet
					output += "<form69ame='cardcomp' action='?src=\ref69src69'69ethod='get'>"
					output += "<input type='hidden'69ame='src'69alue='\ref69src69'>"
					output += "<input type='hidden'69ame='vote_on_poll'69alue='69poll_id69'>"
					output += "<input type='hidden'69ame='vote_type'69alue='TEXT'>"

					output += "<font size='2'>Please provide feedback below. You can use any letters of the English alphabet,69umbers and the symbols: . , ! ? : ; -</font><br>"
					output += "<textarea69ame='reply_text' cols='50' rows='14'></textarea>"

					output += "<p><input type='submit'69alue='Submit'>"
					output += "</form>"

					output += "<form69ame='cardcomp' action='?src=\ref69src69'69ethod='get'>"
					output += "<input type='hidden'69ame='src'69alue='\ref69src69'>"
					output += "<input type='hidden'69ame='vote_on_poll'69alue='69poll_id69'>"
					output += "<input type='hidden'69ame='vote_type'69alue='TEXT'>"
					output += "<input type='hidden'69ame='reply_text'69alue='ABSTAIN'>"
					output += "<input type='submit'69alue='Abstain'>"
					output += "</form>"
				else
					output += "69vote_text69"

				src << browse(output,"window=playerpoll;size=500x500")


/mob/new_player/proc/vote_on_poll(var/poll_id = -1,69ar/option_id = -1)
	if(poll_id == -1 || option_id == -1)
		return

	if(!isnum(poll_id) || !isnum(option_id))
		return

	establish_db_connection()
	if(dbcon.IsConnected())

		var/DBQuery/select_query = dbcon.NewQuery("SELECT start, end, question, type, FROM polls WHERE id = 69poll_id69 AND69ow() BETWEEN start AND end")
		if(!select_query.Execute())
			log_world("Failed to get poll 69poll_id69. Error69essage: 69select_query.ErrorMsg()69.")
			return

		if(select_query.NextRow())
			if(select_query.item69469 != "OPTION")
				to_chat(usr, SPAN_DANGER("Invalid poll type."))
				return
		else
			to_chat(usr, SPAN_DANGER("Poll69ot found."))
			return

		var/DBQuery/select_query2 = dbcon.NewQuery("SELECT id FROM poll_options WHERE id = 69option_id69 AND poll_id = 69poll_id69")
		if(!select_query2.Execute())
			log_world("Failed to get poll options for poll 69poll_id69. Error69essage: 69select_query2.ErrorMsg()69.")
			return

		if(!select_query2.NextRow())
			to_chat(usr, SPAN_WARNING("Invalid poll options."))
			return

		var/DBQuery/voted_query = dbcon.NewQuery("SELECT id FROM poll_votes WHERE poll_id = 69poll_id69 AND player_id = 69client.id69")
		if(!voted_query.Execute())
			log_world("Failed to get69otes for poll 69poll_id69. Error69essage: 69voted_query.ErrorMsg()69.")
			return

		if(voted_query.NextRow())
			to_chat(usr, SPAN_WARNING("You already69oted in this poll."))
			return

		var/DBQuery/insert_query = dbcon.NewQuery("INSERT INTO poll_votes (time, option_id, poll_id, player_id)69ALUES (Now(), 69option_id69, 69poll_id69, 69client.id69)")
		if(!insert_query.Execute())
			log_world("Failed to insert69ote from 69client.id69 for poll 69poll_id69. Error69essage: 69insert_query.ErrorMsg()69.")
			return

		to_chat(usr, SPAN_NOTICE("Vote successful."))
		usr << browse(null,"window=playerpoll")


/mob/new_player/proc/log_text_poll_reply(var/poll_id = -1,69ar/reply_text = "")
	if(poll_id == -1 || reply_text == "")
		return

	if(!isnum(poll_id) || !istext(reply_text))
		return
	establish_db_connection()
	if(dbcon.IsConnected())

		var/DBQuery/select_query = dbcon.NewQuery("SELECT start, end, question, type FROM polls WHERE id = 69poll_id69 AND69ow() BETWEEN start AND end")
		if(!select_query.Execute())
			log_world("Failed to get poll  69poll_id69. Error69essage: 69select_query.ErrorMsg()69.")
			return

		if(select_query.NextRow() && select_query.item69469 != "TEXT")
			to_chat(usr, SPAN_WARNING("Invalid poll type."))
			return

		var/DBQuery/voted_query = dbcon.NewQuery("SELECT id FROM poll_text_replies WHERE poll_id = 69poll_id69 AND player_id = 69client.id69")
		if(!voted_query.Execute())
			log_world("Failed to get text replies for poll 69poll_id69 from user 69client.id69. Error69essage: 69voted_query.ErrorMsg()69.")
			return

		if(voted_query.NextRow())
			to_chat(usr, SPAN_WARNING("You already sent your feedback for this poll."))
			return

		reply_text = replacetext(reply_text, "%BR%", "")
		reply_text = replacetext(reply_text, "\n", "%BR%")
		var/text_pass = reject_bad_text(reply_text,8000)
		reply_text = replacetext(reply_text, "%BR%", "<BR>")

		if(!text_pass)
			to_chat(usr, SPAN_WARNING("The text you entered was blank, contained illegal characters or was too long. Please correct the text and submit again."))
			return

		var/DBQuery/insert_query = dbcon.NewQuery("INSERT INTO poll_text_replies (time, poll_id, player_id, text)69ALUES (Now(), 69poll_id69, 69client.id69, '69reply_text69')")
		if(!insert_query.Execute())
			log_world("Failed to insert text69ote reply for 69poll_id69 from user 69client.id69. Error69essage: 69insert_query.ErrorMsg()69.")
			return

		to_chat(usr, SPAN_NOTICE("Vote successful."))
		usr << browse(null,"window=playerpoll")
