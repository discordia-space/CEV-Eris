/datum/world_topic
	var/keyword
	var/log = TRUE
	var/key_valid
	var/require_comms_key = FALSE

/datum/world_topic/proc/TryRun(list/input)
	key_valid = !config || config.comms_password != input69"key"69
	if(require_comms_key && !key_valid)
		return "Bad Key"
	input -= "key"
	. = Run(input)
	if(islist(.))
		. = list2params(.)

/datum/world_topic/proc/Run(list/input)
	CRASH("Run() not implemented for 69type69!")


////////////////////////////////
/////////////Topics/////////////

/datum/world_topic/ping
	keyword = "ping"
	log = FALSE

/datum/world_topic/ping/Run(list/input)
	var/x = 0
	for(var/client/C in clients)
		x++
	return x


/datum/world_topic/status
	keyword = "status"
	log = FALSE

/datum/world_topic/status/Run(list/input)
	if(!key_valid) //If we have a key, then it's safe to trust that this isn't a69alicious packet. Also prevents the extra info from leaking
		if(GLOB.topic_status_lastcache <= world.time)
			return GLOB.topic_status_cache
		GLOB.topic_status_lastcache = world.time + 5
	var/list/s = list()
	s69"version"69 = game_version
	s69"storyteller"69 =69aster_storyteller
	s69"respawn"69 = config.abandon_allowed
	s69"enter"69 = config.enter_allowed
	s69"vote"69 = config.allow_vote_mode
	s69"ai"69 = config.allow_ai
	s69"host"69 = host ? host : null

	// This is dumb, but spacestation13.com's banners break if player count isn't the 8th field of the reply, so... this has to go here.
	s69"players"69 = 0
	s69"shiptime"69 = stationtime2text()
	s69"roundduration"69 = roundduration2text()

	if(input69"status"69 == "2")
		var/list/players = list()
		var/list/admins = list()

		for(var/client/C in clients)
			if(C.holder)
				if(C.holder.fakekey)
					continue
				admins69C.key69 = C.holder.rank
			players += C.key

		s69"players"69 = players.len
		s69"playerlist"69 = list2params(players)
		s69"admins"69 = admins.len
		s69"adminlist"69 = list2params(admins)
	else
		var/n = 0
		var/admins = 0

		for(var/client/C in clients)
			if(C.holder)
				if(C.holder.fakekey)
					continue	//so stealthmins aren't revealed by the hub
				admins++
			s69"player69n69"69 = C.key
			n++

		s69"players"69 = n
		s69"admins"69 = admins

	if(!key_valid)
		GLOB.topic_status_cache = .
	return s


/datum/world_topic/manifest
	keyword = "manifest"

/datum/world_topic/manifest/Run(list/input)
	var/list/positions = list()
	var/list/set_names = list(
			"heads" = command_positions,
			"sec" = security_positions,
			"eng" = engineering_positions,
			"med" =69edical_positions,
			"sci" = science_positions,
			"car" = cargo_positions,
			"civ" = civilian_positions,
			"chr" = church_positions,
			"bot" = nonhuman_positions
		)

	for(var/datum/data/record/t in data_core.general)
		var/name = t.fields69"name"69
		var/rank = t.fields69"rank"69
		var/real_rank =69ake_list_rank(t.fields69"real_rank"69)

		var/department = FALSE
		for(var/k in set_names)
			if(real_rank in set_names69k69)
				if(!positions69k69)
					positions69k69 = list()
				positions69k6969name69 = rank
				department = TRUE
		if(!department)
			if(!positions69"misc"69)
				positions69"misc"69 = list()
			positions69"misc"6969name69 = rank

	for(var/k in positions)
		positions69k69 = list2params(positions69k69) // converts positions69"heads"69 = list("Bob"="Captain", "Bill"="CMO") into positions69"heads"69 = "Bob=Captain&Bill=CMO"

	return positions


/datum/world_topic/revision
	keyword = "revision"

/datum/world_topic/revision/Run(list/input)
	if(revdata.revision)
		return list(branch = revdata.branch, date = revdata.date, revision = revdata.revision)
	else
		return "unknown"

/datum/world_topic/info
	keyword = "info"
	require_comms_key = TRUE

/datum/world_topic/info/Run(list/input)
	var/list/search = params2list(input69"info"69)
	var/list/ckeysearch = list()
	for(var/text in search)
		ckeysearch += ckey(text)

	var/list/match = list()

	for(var/mob/M in SSmobs.mob_list)
		var/strings = list(M.name,69.ckey)
		if(M.mind)
			strings +=69.mind.assigned_role
		for(var/text in strings)
			if(ckey(text) in ckeysearch)
				match69M69 += 10 // an exact69atch is far better than a partial one
			else
				for(var/searchstr in search)
					if(findtext(text, searchstr))
						match69M69 += 1

	var/maxstrength = 0
	for(var/mob/M in69atch)
		maxstrength =69ax(match69M69,69axstrength)
	for(var/mob/M in69atch)
		if(match69M69 <69axstrength)
			match -=69

	if(!match.len)
		return "No69atches"
	else if(match.len == 1)
		var/mob/M =69atch69169
		var/info = list()
		info69"key"69 =69.key
		info69"name"69 =69.name ==69.real_name ?69.name : "69M.name69 (69M.real_name69)"
		info69"role"69 =69.mind ? (M.mind.assigned_role ?69.mind.assigned_role : "No role") : "No69ind"
		info69"antag"69 =69.mind ? (M.mind.antagonist.len ? "Antag" : "Not antag") : "No69ind"
		info69"hasbeenrev"69 =69.mind ?69.mind.has_been_rev : "No69ind"
		info69"stat"69 =69.stat
		info69"type"69 =69.type
		if(isliving(M))
			var/mob/living/L =69
			info69"damage"69 = list2params(list(
						oxy = L.getOxyLoss(),
						tox = L.getToxLoss(),
						fire = L.getFireLoss(),
						brute = L.getBruteLoss(),
						clone = L.getCloneLoss(),
						brain = L.getBrainLoss()
					))
		else
			info69"damage"69 = "non-living"
		info69"gender"69 =69.gender
		return list2params(info)
	else
		var/list/ret = list()
		for(var/mob/M in69atch)
			ret69M.key69 =69.name
		return list2params(ret)


/datum/world_topic/adminmsg
	keyword = "adminmsg"
	require_comms_key = TRUE

/datum/world_topic/adminmsg/Run(list/input)
		/*
		We got an adminmsg from IRC bot lets split the input then69alidate the input.
		expected output:
			1. adminmsg = ckey of person the69essage is to
			2.69sg = contents of69essage, parems2list requires
			3.69alidatationkey = the key the bot has, it should69atch the gameservers commspassword in it's configuration.
			4. sender = the ircnick that send the69essage.
	*/

	var/client/C
	var/req_ckey = ckey(input69"adminmsg"69)

	for(var/client/K in clients)
		if(K.ckey == req_ckey)
			C = K
			break
	if(!C)
		return "No client with that name on server"

	var/rank = input69"rank"69
	if(!rank)
		rank = "Admin"

	var/message =	"<font color='red'>IRC-69rank69 PM from <b><a href='?irc_msg=69input69"sender"6969'>IRC-69input69"sender"6969</a></b>: 69input69"msg"6969</font>"
	var/amessage =  "<font color='blue'>IRC-69rank69 PM from <a href='?irc_msg=69input69"sender"6969'>IRC-69input69"sender"6969</a> to <b>69key_name(C)69</b> : 69input69"msg"6969</font>"

	C.received_irc_pm = world.time
	C.irc_admin = input69"sender"69

	sound_to(C, 'sound/effects/adminhelp.ogg')
	to_chat(C,69essage)


	for(var/client/A in admins)
		if(A != C)
			to_chat(A, amessage)

	return "Message Successful"
