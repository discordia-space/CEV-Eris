/datum/vote_choice
	var/text = "Vladimir Putin"
	var/desc
	var/list/voters = list()	//assoc list of ckeys of69oters and the69oting power they contributed
	var/datum/poll/poll //The poll we're assigned to

/datum/vote_choice/New(var/datum/poll/_poll)
	poll = _poll

/datum/vote_choice/proc/on_win()
	return

/datum/vote_choice/proc/total_votes()
	var/total = 0
	for (var/voter in69oters)
		total +=69oters69voter69
	return total