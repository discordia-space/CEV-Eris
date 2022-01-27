SUBSYSTEM_DEF(vote)
	name = "Vote"
	wait = 1 SECONDS
	flags = SS_KEEP_TIMING | SS_NO_INIT
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	var/list/votes = list()
	var/list/voters = list()	//List of clients with opened69ote window
	var/datum/poll/active_vote
	var/vote_start_time = 0

/datum/controller/subsystem/vote/PreInit()
	for(var/T in subtypesof(/datum/poll))
		var/datum/poll/P = new T
		votes69T69 = P

/datum/controller/subsystem/vote/proc/update_voters()
	for(var/client/C in69oters)
		interface_client(C)

/datum/controller/subsystem/vote/proc/interface_client(client/C)
	var/datum/browser/panel = new(C.mob, "Vote","Vote", 500, 650)
	panel.set_content(interface(C))
	panel.open()

/datum/controller/subsystem/vote/fire()
	if(active_vote)
		active_vote.Process()

		if(active_vote)//Need to check again because the active69ote can be nulled during its process. For example if an admin forces start
			if(get_vote_time() >= active_vote.time)
				active_vote.check_winners()
				stop_vote()

			update_voters()

/datum/controller/subsystem/vote/proc/autostoryteller()
	start_vote(/datum/poll/storyteller)

/datum/controller/subsystem/vote/proc/start_vote(newvote)
	if(active_vote)
		return FALSE

	var/datum/poll/poll

	if(ispath(newvote) && (newvote in69otes))
		poll =69otes69newvote69

	//can_start check is done before calling this so that admins can skip it
	if(!poll)
		return FALSE

	if(!poll.start())
		return

	vote_start_time = world.time

	var/text = "69poll.name6969ote started by 69poll.initiator69."
	log_vote(text)
	to_chat(world, {"<font color='purple'><b>69text69</b>\nType <b>vote</b> or click <a href='?src=\ref69src69'>here</a> to place your69otes. <br>You have 69poll.time69 seconds to69ote.</font>"})
	sound_to(world, sound('sound/ambience/alarm4.ogg', repeat = 0, wait = 0,69olume = 50, channel = GLOB.vote_sound_channel))

	return TRUE

/datum/controller/subsystem/vote/proc/stop_vote()
	if(!active_vote)
		return FALSE

	active_vote.reset()
	vote_start_time = 0
	voters.Cut()
	active_vote = null
	return TRUE

/datum/controller/subsystem/vote/proc/get_vote_time()	//How69any seconds69ote lasts
	return round((world.time -69ote_start_time)/10)

/datum/controller/subsystem/vote/proc/interface(client/C)
	if(!C)
		return
	var/data = "<html><head><title>Voting Panel</title></head><body>"

	var/admin = check_rights(R_ADMIN, FALSE, C)

	voters |= C

	if(active_vote)
		data += "<h2>Vote: '69active_vote.question69'</h2>"
		data += "Time Left: 69active_vote.time - get_vote_time()69 s<br>"
		data += "Started by: <b>69active_vote.initiator69</b><hr>"

		if(active_vote.multiple_votes)
			data += "You can69ote69ultiple choices.<br>"
		else
			data += "You can69ote one choice.<br>"

		if(active_vote.can_revote)
			if(active_vote.can_unvote)
				data += "You can either change69ote or remove it."
			else
				data += "You can change your69ote."
		else
			data += "You can't change your69ote."

		if (active_vote.description)
			data += "<br>69active_vote.description69<br>"

		data += "<hr>"
		data += "<table width = '100%'><tr><td align = 'center'><b>Choices</b></td><td align = 'center'><b>Votes</b></td>"

		for(var/datum/vote_choice/choice in active_vote.choices)
			var/c_votes = (active_vote.see_votes || admin) ? choice.total_votes() : "*"
			data += "<tr><td>"
			if(C.key in choice.voters)
				data += "<b><a href='?src=\ref69src69;vote=\ref69choice69'>69choice.text69</a></b>"
			else
				data += "<a href='?src=\ref69src69;vote=\ref69choice69'>69choice.text69</a>"
			if(choice.desc)
				data += "<br>\t<i>69choice.desc69</i>"
			data += "</td><td align = 'center'>69c_votes69</td></tr>"

		data += "</table><hr>"
		if(admin)
			data += "(<a href='?src=\ref69src69;cancel=1'>Cancel69ote</a>) "
	else
		var/any_votes = FALSE
		data += "<h2>Start a69ote:</h2><hr><ul>"

		for(var/P in69otes)
			var/datum/poll/poll =69otes69P69
			data += "<li>"
			any_votes = TRUE

			if(poll.can_start() && (!poll.only_admin || admin))
				data += "<a href='?src=\ref69src69;start_vote=\ref69poll69'>69poll.name69</a>"
			else
				data += "<s>69poll.name69</s>"
				if (admin)
					data += " <a href='?src=\ref69src69;start_vote=\ref69poll69'>force</a> "

			if(admin)
				data += "\t(<a href='?src=\ref69src69;toggle_admin=\ref69poll69'>69poll.only_admin?"Only admin":"Allowed"69</a>)"
			data += "</li>"

		if(!any_votes)
			data += "<li><i>There is no available69otes here now.</i></li>"

		data += "</ul><hr>"
	data += "<a href='?src=\ref69src69;close=1' style='position:absolute;right:50px'>Close</a></body></html>"
	return data


/datum/controller/subsystem/vote/Topic(href,href_list6969,hsrc)
	if(href_list69"vote"69)
		if(active_vote)
			var/datum/vote_choice/choice = locate(href_list69"vote"69) in active_vote.choices
			if(istype(choice) && usr && usr.client)
				active_vote.vote(choice, usr.client)

	if(href_list69"toggle_admin"69)
		var/datum/poll/poll = locate(href_list69"toggle_admin"69)
		if(istype(poll) && check_rights(R_ADMIN))
			poll.only_admin = !poll.only_admin

	if(href_list69"start_vote"69)
		var/datum/poll/poll = locate(href_list69"start_vote"69)
		if(istype(poll) && (check_rights(R_ADMIN) || (!poll.only_admin && poll.can_start())))
			start_vote(poll.type)

	if(href_list69"cancel"69)
		if(active_vote && check_rights())
			stop_vote()

	if(href_list69"debug"69)
		usr.client.debug_variables(src)

	if(href_list69"close"69)
		if(usr && usr.client)
			voters.Remove(usr.client)
			usr.client << browse(null,"window=Vote")
			return

	usr.vote()

/mob/verb/vote()
	set category = "OOC"
	set name = "Vote"

	SSvote.interface_client(client)
