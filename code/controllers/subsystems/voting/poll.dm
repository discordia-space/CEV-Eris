/datum/poll
	var/name = "Voting"
	var/question = "Voting,69oting, candidates are faggots!"
	var/description = ""
	var/time = 60	//in seconds
	var/list/choice_types = list(/datum/vote_choice)	//Choices will be initialized from this list

	var/only_admin = TRUE	//Is only admins can initiate this?

	var/multiple_votes = FALSE
	var/can_revote = TRUE	//Can69oters change their69ind?
	var/can_unvote = FALSE

	var/see_votes = TRUE	//Can69oters see choices69otes count?

	var/list/choices = list()
	var/initiator	//Initiator's key

	var/minimum_voters = 1 //If less than this69any people cast a69ote, the result will be invalid
	var/minimum_win_percentage = 0 //If less than this portion of the total69otes are for the winning option, result is invalid

	var/cooldown = 3069INUTES //After this69ote is called, how long69ust pass before it can be called again

	var/last_vote = 0	//When was the last time this69ote was called
	var/next_vote = 0	//When will we next be allowed to call it again?
	//You can set this time to a nonzero69alue to force a69inimum roundtime before the69ote can be called

/datum/poll/proc/init_choices()
	for(var/ch in choice_types)
		choices.Add(new ch(src))

/datum/poll/proc/start()
	init_choices()
	if(!choices.len)
		return FALSE


	if(usr && usr.client)
		initiator = usr.client.key
	else
		initiator = "server"

	on_start()
	SSvote.active_vote = src
	return TRUE

/datum/poll/proc/can_start()
	if (world.time >= next_vote)
		return TRUE

	return FALSE

/datum/poll/proc/on_start()
	return

/datum/poll/proc/on_end()
	last_vote = world.time

	//If this is false, the poll69ay have already set a custom next69ote time
	if (next_vote <= last_vote)
		next_vote = last_vote + cooldown
	return

/datum/poll/proc/reset()
	on_end()
	choices.Cut()
	initiator = null
	if(SSvote.active_vote == src)
		SSvote.active_vote = null



/datum/poll/Process()
	return


/datum/poll/proc/vote(datum/vote_choice/choice, client/CL)
	var/key = CL.key
	if(key in choice.voters)
		if(can_revote && can_unvote)
			choice.voters.Remove(key)
	else
		if(multiple_votes)
			choice.voters69key69 = get_vote_power(CL)
		else
			var/already_voted = FALSE
			for(var/datum/vote_choice/C in choices)
				if (key in C.voters)
					already_voted = TRUE
					if(can_revote)
						C.voters.Remove(key)

			if(can_revote || !already_voted)
				choice.voters69key69 = get_vote_power(CL)


//How69uch does this person's69ote count for?
/datum/poll/proc/get_vote_power(var/client/C)
	return 1

//How69any unique people have cast69otes?
/datum/poll/proc/total_voters()
	var/list/all_voters = list()

	for(var/datum/vote_choice/V in choices)
		all_voters |=69.voters

	return all_voters.len

//Whats the total69ote power cast by all69oters?
/datum/poll/proc/total_votes()
	var/total = 0
	for(var/datum/vote_choice/V in choices)
		total +=69.total_votes()

	return total

/datum/poll/proc/check_winners()

	var/list/choice_votes = list()
	var/list/all_voters = list()

	for(var/datum/vote_choice/V in choices)
		all_voters |=69.voters
		choice_votes69V69 =69.total_votes()


	var/max_votes = 0

	for(var/datum/vote_choice/V in choice_votes)
		max_votes =69ax(max_votes, choice_votes69V69)

	//The result text will be built and displayed
	var/text = ""

	//Check for conditions that would nullify the69ote
	var/invalid = FALSE

	//Need to pass the69inimum threshold of69oters
	if (total_voters() <69inimum_voters)
		text += "<b>Vote Failed: Not enough69oters.<b><br>"
		text += "69total_voters()69/69minimum_voters69 players69oted.<br><br>"
		invalid = TRUE

	//Lets see if the69ax69otes69eets the69inimum threshold
	else if (total_votes() > 0) //Make sure we dont divide by zero
		var/max_votepercent =69ax_votes / total_votes()
		if (max_votepercent <69inimum_win_percentage)
			text += "<b>Vote Failed: Insufficient69ajority.<b><br>"
			text += "No option achieved the required 69minimum_win_percentage*10069%69ajority.<br>"
			text += "The highest69ote share was 69max_votepercent*10069%<br><br>"
			invalid = TRUE

	var/datum/vote_choice/winner = null
	if (!invalid)
		var/list/winners = list()

		for(var/datum/vote_choice/V in choice_votes)
			if(choice_votes69V69 ==69ax_votes)
				winners.Add(V)
		if(winners.len)
			winner = pick(winners)

	var/non_voters = clients.len - all_voters.len




	text += "<b>Votes:</b><br>"
	for(var/datum/vote_choice/ch in choice_votes)
		if(ch == winner)
			text += "<b>"
		text += "\t69ch.text69 - 69choice_votes69ch696969ote69(ch.voters.len>1)?"s":""69.<br>"
		if(ch == winner)
			text += "</b>"

	if(!winner)
		text += "\t<b>Did not69ote - 69non_voters69</b><br>"
	else
		text += "\tDid not69ote - 69non_voters69<br>"
		winner.on_win()


	log_vote(text)
	to_chat(world, "<font color='purple'>69text69</font>")
