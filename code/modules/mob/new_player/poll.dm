/datum/poll_option
	var/id
	var/text

/mob/new_player/proc/handle_player_polling()
	if(SSdbcore.Connect())
		var/datum/db_query/select_query = SSdbcore.NewQuery(
			"SELECT id, question FROM [format_table_name("polls")] WHERE Now() BETWEEN start AND end"
		)
		if(!select_query.Execute())
			log_world("Failed to retrieve active player polls. Error message: [select_query.ErrorMsg()].")
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
			poll_id = select_query.item[1]
			poll_question = select_query.item[2]
			output += "<tr bgcolor='[ (i % 2 == 1) ? color1 : color2 ]'><td><a href=\"byond://?src=\ref[src];poll_id=[poll_id]\"><b>[poll_question]</b></a></td></tr>"
			i++

		output += "</table>"

		src << browse(HTML_SKELETON(output),"window=playerpolllist;size=500x300")


/mob/new_player/proc/poll_player(poll_id = -1)
	if(poll_id == -1)
		return

	if(SSdbcore.Connect())
		var/datum/db_query/select_query = SSdbcore.NewQuery(
			"SELECT start, end, question, type, FROM [format_table_name("polls")] WHERE id = :poll_id",
			list("poll_id" = poll_id)
		)
		if(!select_query.Execute())
			log_world("Failed to get poll with id [poll_id]. Error message: [select_query.ErrorMsg()].")
			return

		var/start_time = ""
		var/end_time = ""
		var/question = ""
		var/type = ""

		if(select_query.NextRow())
			start_time = select_query.item[1]
			end_time = select_query.item[2]
			question = select_query.item[3]
			type = select_query.item[4]
		else
			to_chat(usr, span_danger("Poll question details not found."))
			return

		switch(type)
			//Polls that have enumerated options
			if("OPTION")
				var/datum/db_query/voted_query = SSdbcore.NewQuery(
					"SELECT option_id FROM [format_table_name("poll_votes")] WHERE poll_id = :poll_id AND ckey = :ckey",
					list("ckey" = client.ckey, "poll_id" = poll_id)
				)
				if(!voted_query.Execute())
					log_world("Failed to retrieve votes from poll [poll_id] for player [client.ckey]. Error message: [voted_query.ErrorMsg()].")
					return

				var/voted = FALSE
				var/voted_option_id = 0
				while(voted_query.NextRow())
					voted_option_id = text2num(voted_query.item[1])
					voted = TRUE
					break

				var/list/datum/poll_option/options = list()

				var/datum/db_query/options_query = SSdbcore.NewQuery(
					"SELECT id, text FROM [format_table_name("poll_options")] WHERE poll_id = :poll_id",
					list("poll_id" = poll_id))
				if(!options_query.Execute())
					log_world("Failed to get poll options for poll with id [poll_id]. Error message: [options_query.ErrorMsg()].")
					return
				while(options_query.NextRow())
					var/datum/poll_option/option = new()
					option.id = text2num(options_query.item[1])
					option.text = options_query.item[2]
					options.Add(option)

				var/output = "<div align='center'><B>Player poll</B>"
				output +="<hr>"
				output += "<b>Question: [question]</b><br>"
				output += "<font size='2'>Poll runs from <b>[start_time]</b> until <b>[end_time]</b></font><p>"

				if(!voted)	//Only make this a form if we have not voted yet
					output += "<form name='cardcomp' action='?src=\ref[src]' method='get'>"
					output += "<input type='hidden' name='src' value='\ref[src]'>"
					output += "<input type='hidden' name='poll_id' value='[poll_id]'>"
					output += "<input type='hidden' name='type' value='OPTION'>"

				output += "<table><tr><td>"
				for(var/datum/poll_option/option in options)
					if(option.id && option.text)
						if(voted)
							if(voted_option_id == option.id)
								output += "<b>[option.text]</b><br>"
							else
								output += "[option.text]<br>"
						else
							output += "<input type='radio' name='vote_option_id' value='[option.id]'> [option.text]<br>"
				output += "</td></tr></table>"

				if(!voted)	//Only make this a form if we have not voted yet
					output += "<p><input type='submit' value='Vote'>"
					output += "</form>"

				output += "</div>"

				src << browse(HTML_SKELETON(output),"window=playerpoll;size=500x250")

			//Polls with a text input
			if("TEXT")
				var/datum/db_query/voted_query = SSdbcore.NewQuery(
					"SELECT text FROM [format_table_name("poll_text_replies")] WHERE poll_id = :poll_id AND ckey = :ckey",
					list("poll_id" = poll_id, "ckey" = client.ckey)
				)
				if(!voted_query.Execute())
					log_world("Failed to get votes from text poll [poll_id] for user [client.ckey]. Error message: [voted_query.ErrorMsg()].")
					return

				var/voted = FALSE
				var/vote_text = ""
				while(voted_query.NextRow())
					vote_text = voted_query.item[1]
					voted = TRUE
					break

				var/output = "<div align='center'><B>Player poll</B>"
				output +="<hr>"
				output += "<b>Question: [question]</b><br>"
				output += "<font size='2'>Feedback gathering runs from <b>[start_time]</b> until <b>[end_time]</b></font><p>"

				if(!voted)	//Only make this a form if we have not voted yet
					output += "<form name='cardcomp' action='?src=\ref[src]' method='get'>"
					output += "<input type='hidden' name='src' value='\ref[src]'>"
					output += "<input type='hidden' name='vote_on_poll' value='[poll_id]'>"
					output += "<input type='hidden' name='vote_type' value='TEXT'>"

					output += "<font size='2'>Please provide feedback below. You can use any letters of the English alphabet, numbers and the symbols: . , ! ? : ; -</font><br>"
					output += "<textarea name='reply_text' cols='50' rows='14'></textarea>"

					output += "<p><input type='submit' value='Submit'>"
					output += "</form>"

					output += "<form name='cardcomp' action='?src=\ref[src]' method='get'>"
					output += "<input type='hidden' name='src' value='\ref[src]'>"
					output += "<input type='hidden' name='vote_on_poll' value='[poll_id]'>"
					output += "<input type='hidden' name='vote_type' value='TEXT'>"
					output += "<input type='hidden' name='reply_text' value='ABSTAIN'>"
					output += "<input type='submit' value='Abstain'>"
					output += "</form>"
				else
					output += "[vote_text]"

				src << browse(HTML_SKELETON(output),"window=playerpoll;size=500x500")


/mob/new_player/proc/vote_on_poll(poll_id = -1, option_id = -1)
	if(poll_id == -1 || option_id == -1)
		return

	if(!isnum(poll_id) || !isnum(option_id))
		return

	if(SSdbcore.Connect())
		var/datum/db_query/select_query = SSdbcore.NewQuery(
			"SELECT start, end, question, type, FROM [format_table_name("polls")] WHERE id = :poll_id AND Now() BETWEEN start AND end",
			list("poll_id" = poll_id)
		)
		if(!select_query.Execute())
			log_world("Failed to get poll [poll_id]. Error message: [select_query.ErrorMsg()].")
			return

		if(select_query.NextRow())
			if(select_query.item[4] != "OPTION")
				to_chat(usr, span_danger("Invalid poll type."))
				return
		else
			to_chat(usr, span_danger("Poll not found."))
			return

		var/datum/db_query/select_query2 = SSdbcore.NewQuery(
			"SELECT id FROM [format_table_name("poll_options")] WHERE id = :option_id AND poll_id = :poll_id",
			list("option_id" = option_id, "poll_id" = poll_id)
		)
		if(!select_query2.Execute())
			log_world("Failed to get poll options for poll [poll_id]. Error message: [select_query2.ErrorMsg()].")
			return

		if(!select_query2.NextRow())
			to_chat(usr, span_warning("Invalid poll options."))
			return

		var/datum/db_query/voted_query = SSdbcore.NewQuery(
			"SELECT id FROM [format_table_name("poll_votes")] WHERE poll_id = :poll_id AND ckey = :ckey",
			list("poll_id" = poll_id, "ckey" = client.ckey)
		)
		if(!voted_query.Execute())
			log_world("Failed to get votes for poll [poll_id]. Error message: [voted_query.ErrorMsg()].")
			return

		if(voted_query.NextRow())
			to_chat(usr, span_warning("You already voted in this poll."))
			return

		var/datum/db_query/insert_query = SSdbcore.NewQuery(
			"INSERT INTO [format_table_name("poll_votes")] (time, option_id, poll_id, ckey) VALUES (Now(), :option_id, :poll_id, :ckey)",
			list("option_id" = option_id, "poll_id" = poll_id, "ckey" = client.ckey)
		)
		if(!insert_query.Execute())
			log_world("Failed to insert vote from [client.ckey] for poll [poll_id]. Error message: [insert_query.ErrorMsg()].")
			return

		to_chat(usr, span_notice("Vote successful."))
		usr << browse(null,"window=playerpoll")


/mob/new_player/proc/log_text_poll_reply(poll_id = -1, reply_text = "")
	if(poll_id == -1 || reply_text == "")
		return

	if(!isnum(poll_id) || !istext(reply_text))
		return
	if(SSdbcore.Connect())
		var/datum/db_query/select_query = SSdbcore.NewQuery("SELECT start, end, question, type FROM [format_table_name("polls")] WHERE id = [poll_id] AND Now() BETWEEN start AND end")
		if(!select_query.Execute())
			log_world("Failed to get poll  [poll_id]. Error message: [select_query.ErrorMsg()].")
			return

		if(select_query.NextRow() && select_query.item[4] != "TEXT")
			to_chat(usr, span_warning("Invalid poll type."))
			return

		var/datum/db_query/voted_query = SSdbcore.NewQuery("SELECT id FROM [format_table_name("poll_text_replies")] WHERE poll_id = [poll_id] AND ckey = [client.ckey]")
		if(!voted_query.Execute())
			log_world("Failed to get text replies for poll [poll_id] from user [client.ckey]. Error message: [voted_query.ErrorMsg()].")
			return

		if(voted_query.NextRow())
			to_chat(usr, span_warning("You already sent your feedback for this poll."))
			return

		reply_text = replacetext(reply_text, "%BR%", "")
		reply_text = replacetext(reply_text, "\n", "%BR%")
		var/text_pass = reject_bad_text(reply_text,8000)
		reply_text = replacetext(reply_text, "%BR%", "<BR>")

		if(!text_pass)
			to_chat(usr, span_warning("The text you entered was blank, contained illegal characters or was too long. Please correct the text and submit again."))
			return

		var/datum/db_query/insert_query = SSdbcore.NewQuery("INSERT INTO [format_table_name("poll_text_replies")] (time, poll_id, ckey, text) VALUES (Now(), [poll_id], [client.ckey], '[reply_text]')")
		if(!insert_query.Execute())
			log_world("Failed to insert text vote reply for [poll_id] from user [client.ckey]. Error message: [insert_query.ErrorMsg()].")
			return

		to_chat(usr, span_notice("Vote successful."))
		usr << browse(null,"window=playerpoll")
