var/datum/controller/vote/vote = new()

/datum/controller/vote
	var/list/votes = list()
	var/list/voters = list()	//List of clients with opened vote window
	var/datum/poll/active_vote = null
	var/vote_start_time = 0

/datum/controller/vote/New()
	if(vote != src)
		if(istype(vote))
			del(vote)
		vote = src

	init_votes()

/datum/controller/vote/proc/init_votes()
	for(var/T in typesof(/datum/poll)-/datum/poll)
		var/datum/poll/P = new T
		votes[T] = P

/datum/controller/vote/proc/update_voters()
	for(var/client/C in voters)
		interface_client(C)

/datum/controller/vote/proc/interface_client(var/client/C)
	C << browse(interface(C),"window=vote;can_close=0;can_resize=0;can_minimize=0")


/datum/controller/vote/Process()	//called by master_controller
	if(active_vote)
		active_vote.Process()

		if(get_vote_time() >= active_vote.time)
			active_vote.check_winners()
			stop_vote()

		update_voters()

/datum/controller/vote/proc/autostoryteller()
	start_vote(/datum/poll/storyteller)

/datum/controller/vote/proc/start_vote(var/newvote)
	if(active_vote)
		return FALSE

	var/datum/poll/poll = null

	if(ispath(newvote) && newvote in votes)
		poll = votes[newvote]

	if(!poll || !poll.can_start())
		return FALSE

	if(!poll.start())
		return

	vote_start_time = world.time

	for(var/client/C in voters)
		C << browse(interface(C),"window=vote")

	var/text = "[poll.name] vote started by [poll.initiator]."
	log_vote(text)
	world << {"<font color='purple'><b>[text]</b>\nType <b>vote</b> or click <a href='?src=\ref[src]'>here</a> to place your votes. <br>You have [poll.time] seconds to vote.</font>"}
	world << sound('sound/ambience/alarm4.ogg', repeat = 0, wait = 0, volume = 50, channel = 3)

	return TRUE

/datum/controller/vote/proc/stop_vote()
	if(!active_vote)
		return FALSE

	active_vote.reset()
	vote_start_time = 0
	voters.Cut()
	active_vote = null
	return TRUE

/datum/controller/vote/proc/get_vote_time()	//How many seconds vote lasts
	return round((world.time - vote_start_time)/10)

/datum/controller/vote/proc/interface(var/client/C)
	if(!C)
		return
	var/data = "<html><head><title>Voting Panel</title></head><body>"

	var/admin = FALSE
	if(C.mob)
		admin = check_rights(user = C.mob, show_msg=FALSE)

	voters |= C

	if(active_vote)
		data += "<h2>Vote: '[active_vote.question]'</h2>"
		data += "Time Left: [active_vote.time - get_vote_time()] s<br>"
		data += "Started by: <b>[active_vote.initiator]</b><hr>"

		if(active_vote.multiple_votes)
			data += "You can vote multiple choices.<br>"
		else
			data += "You can vote one choice.<br>"

		if(active_vote.can_revote)
			if(active_vote.can_unvote)
				data += "You can either change vote or remove it."
			else
				data += "You can change your vote."
		else
			data += "You can't change your vote."

		data += "<hr>"
		data += "<table width = '100%'><tr><td align = 'center'><b>Choices</b></td><td align = 'center'><b>Votes</b></td>"

		for(var/datum/vote_choice/choice in active_vote.choices)
			var/c_votes = (active_vote.see_votes || admin) ? choice.voters.len : "*"
			data += "<tr><td>"
			if(C.key in choice.voters)
				data += "<b><a href='?src=\ref[src];vote=\ref[choice]'>[choice.text]</a></b>"
			else
				data += "<a href='?src=\ref[src];vote=\ref[choice]'>[choice.text]</a>"
			if(choice.desc)
				data += "<br>\t<i>[choice.desc]</i>"
			data += "</td><td align = 'center'>[c_votes]</td></tr>"

		data += "</table><hr>"
		if(admin)
			data += "(<a href='?src=\ref[src];cancel=1'>Cancel Vote</a>) "
	else
		var/any_votes = FALSE
		data += "<h2>Start a vote:</h2><hr><ul>"

		for(var/P in votes)
			var/datum/poll/poll = votes[P]
			data += "<li>"
			any_votes = TRUE

			if(poll.can_start() && (!poll.only_admin || admin))
				data += "<a href='?src=\ref[src];start_vote=\ref[poll]'>[poll.name]</a>"
			else
				data += "<s>[poll.name]</s>"

			if(admin)
				data += "\t(<a href='?src=\ref[src];toggle_admin=\ref[poll]'>[poll.only_admin?"Only admin":"Allowed"]</a>)"
			data += "</li>"

		if(!any_votes)
			data += "<li><i>There is no available votes here now.</i></li>"

		data += "</ul><hr>"
	data += "<a href='?src=\ref[src];close=1' style='position:absolute;right:50px'>Close</a></body></html>"
	return data


/datum/controller/vote/Topic(href,href_list[],hsrc)
	if(href_list["vote"])
		if(active_vote)
			var/datum/vote_choice/choice = locate(href_list["vote"]) in active_vote.choices
			if(istype(choice) && usr && usr.client)
				active_vote.vote(choice, usr.client)

	if(href_list["toggle_admin"])
		var/datum/poll/poll = locate(href_list["toggle_admin"])
		if(istype(poll) && check_rights(R_ADMIN))
			poll.only_admin = !poll.only_admin

	if(href_list["start_vote"])
		var/datum/poll/poll = locate(href_list["start_vote"])
		if(istype(poll) && (!poll.only_admin || check_rights(R_ADMIN)))
			start_vote(poll.type)

	if(href_list["cancel"])
		if(active_vote && check_rights())
			stop_vote()

	if(href_list["debug"])
		usr.client.debug_variables(src)

	if(href_list["close"])
		if(usr && usr.client)
			voters.Remove(usr.client)
			usr.client << browse(null,"window=vote")
			return

	usr.vote()



/datum/poll
	var/name = "Voting"
	var/question = "Voting, voting, candidates are faggots!"
	var/time = 60	//in seconds
	var/list/choice_types = list(/datum/vote_choice)	//Choices will be initialized from this list

	var/only_admin = TRUE	//Is only admins can initiate this?

	var/multiple_votes = FALSE
	var/can_revote = TRUE	//Can voters change their mind?
	var/can_unvote = FALSE

	var/see_votes = TRUE	//Can voters see choices votes count?

	var/list/choices = list()
	var/initiator = null	//Initiator's key

/datum/poll/proc/init_choices()
	for(var/ch in choice_types)
		choices.Add(new ch)

/datum/poll/proc/start()
	init_choices()
	if(!choices.len)
		return FALSE


	if(usr && usr.client)
		initiator = usr.client.key
	else
		initiator = "server"

	on_start()
	vote.active_vote = src
	return TRUE

/datum/poll/proc/can_start()
	return TRUE

/datum/poll/proc/on_start()
	return

/datum/poll/proc/on_end()
	return

/datum/poll/proc/reset()
	on_end()
	choices.Cut()
	initiator = null
	if(vote.active_vote == src)
		vote.active_vote = null



/datum/poll/Process()
	return


/datum/poll/proc/vote(var/datum/vote_choice/choice, var/client/CL)
	var/key = CL.key
	if(key in choice.voters)
		if(can_revote && can_unvote)
			choice.voters.Remove(key)
	else
		if(multiple_votes)
			choice.voters.Add(key)
		else
			var/vtd = FALSE
			for(var/datum/vote_choice/C in choices)
				vtd = TRUE
				if(can_revote)
					C.voters.Remove(key)

			if(can_revote || !vtd)
				choice.voters.Add(key)

/datum/poll/proc/check_winners()

	var/list/choice_votes = list()
	var/list/all_voters = list()

	for(var/datum/vote_choice/V in choices)
		all_voters |= V.voters
		choice_votes[V] = V.voters.len

	var/max_votes = 1

	for(var/datum/vote_choice/V in choice_votes)
		max_votes = max(max_votes, choice_votes[V])

	var/list/winners = list()
	for(var/datum/vote_choice/V in choice_votes)
		if(V.voters.len == max_votes)
			winners.Add(V)

	var/non_voters = clients.len - all_voters.len
	var/text = "<b>Votes:</b><br>"
	var/datum/vote_choice/winner = null
	if(winners.len)
		winner = pick(winners)

	for(var/datum/vote_choice/ch in choice_votes)
		if(ch == winner)
			text += "<b>"
		text += "\t[ch.text] - [ch.voters.len] vote[(ch.voters.len>1)?"s":""].<br>"
		if(ch == winner)
			text += "</b>"

	if(!winner)
		text += "\t<b>Did not vote - [non_voters]</b><br>"
	else
		text += "\tDid not vote - [non_voters]<br>"
		winner.on_win()


	log_vote(text)
	world << "<font color='purple'>[text]</font>"



/datum/vote_choice
	var/text = "Vladimir Putin"
	var/desc = null
	var/list/voters = list()	//list of ckeys of voters

/datum/vote_choice/proc/on_win()
	return



/mob/verb/vote()
	set category = "OOC"
	set name = "Vote"

	if(vote)
		vote.interface_client(client)


///////////////////////////////////////////////
///////////////////VOTES//////////////////////
//////////////////////////////////////////////

/datum/poll/restart
	name = "Restart"
	question = "Restart Round"
	time = 60
	choice_types = list(/datum/vote_choice/restart, /datum/vote_choice/countinue_round)

	only_admin = TRUE

	multiple_votes = FALSE
	can_revote = TRUE
	can_unvote = FALSE

	see_votes = TRUE

/datum/vote_choice/restart
	text = "Restart Round"

/datum/vote_choice/restart/on_win()
	world << "<b>World restarting due to vote...<b>"
	sleep(50)
	log_game("Rebooting due to restart vote")
	world.Reboot()

/datum/vote_choice/countinue_round
	text = "Continue Round"



/datum/poll/storyteller
	name = "Storyteller"
	question = "Choose storyteller"
	time = 60
	choice_types = list()

	only_admin = TRUE

	multiple_votes = FALSE
	can_revote = TRUE
	can_unvote = TRUE

	see_votes = TRUE

/datum/poll/storyteller/init_choices()
	for(var/ch in storyteller_cache)
		var/datum/vote_choice/storyteller/CS = new
		var/datum/storyteller/S = storyteller_cache[ch]
		CS.text = S.name
		CS.desc = S.description
		CS.new_storyteller = ch
		choices.Add(CS)

/datum/poll/storyteller/Process()
	if(ticker.current_state != GAME_STATE_PREGAME)
		vote.stop_vote()
		world << "<b>Voting aborted due to game start.</b>"
	return

/datum/poll/storyteller/can_start()
	return ticker && ticker.current_state == GAME_STATE_PREGAME

/datum/poll/storyteller/on_start()
	round_progressing = FALSE
	world << "<b>Game start has been delayed.</b>"

/datum/poll/storyteller/on_end()
	ticker.story_vote_ended = TRUE
	round_progressing = TRUE
	world << "<b>The game will start soon.</b>"

/datum/vote_choice/storyteller
	text = "You shouldn't see this."
	var/new_storyteller = STORYTELLER_BASE

/datum/vote_choice/storyteller/on_win()
	master_storyteller = new_storyteller
	world.save_storyteller(master_storyteller)



/datum/poll/custom
	name = "Custom"
	question = "Why is there no text here?"
	time = 60
	choice_types = list()

	only_admin = TRUE

	multiple_votes = TRUE
	can_revote = TRUE
	can_unvote = FALSE

	see_votes = TRUE

/datum/poll/custom/init_choices()
	multiple_votes = FALSE
	can_revote = TRUE
	can_unvote = FALSE
	see_votes = TRUE

	question = input("What's your vote question?","Custom vote","Custom vote question")

	var/choice_text = ""
	var/ch_num = 1
	do
		choice_text = input("Vote choice [ch_num]. Type nothing to stop.","Custom vote","")
		ch_num += 1
		if(choice_text != "")
			var/datum/vote_choice/custom/C = new
			C.text = choice_text
			choices.Add(C)
	while(choice_text != "" && ch_num < 10)

	if(alert("Should the voters be able to vote multiple options?","Custom vote","Yes","No") == "Yes")
		multiple_votes = TRUE

	if(alert("Should the voters be able to change their choice?","Custom vote","Yes","No") == "No")
		can_revote = FALSE

	if(alert("Should the voters be able to remove their votes?","Custom vote","Yes","No") == "Yes")
		can_unvote = TRUE

	if(alert("Should the voters see another voters votes?","Custom vote","Yes","No") == "No")
		see_votes = FALSE

	if(alert("Are you sure you want to continue?","Custom vote","Yes","No") == "No")
		choices.Cut()

/datum/vote_choice/custom
	text = "Vote choice"



