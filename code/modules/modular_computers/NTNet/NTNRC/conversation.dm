var/global/ntnrc_uid = 0

/datum/ntnet_conversation/
	var/id =69ull
	var/title = "Untitled Conversation"
	var/datum/computer_file/program/chatclient/operator // "Administrator" of this channel. Creator starts as channel's operator,
	var/list/messages = list()
	var/list/clients = list()
	var/password
	var/source_z

/datum/ntnet_conversation/New(var/_z)
	source_z = _z
	id =69tnrc_uid
	ntnrc_uid++
	if(ntnet_global)
		ntnet_global.chat_channels.Add(src)
	..()

/datum/ntnet_conversation/proc/add_message(var/message,69ar/username)
	message = "69stationtime2text()69 69username69: 69message69"
	messages.Add(message)
	trim_message_list()

/datum/ntnet_conversation/proc/add_status_message(var/message)
	messages.Add("69stationtime2text()69 -!- 69message69")
	trim_message_list()

/datum/ntnet_conversation/proc/trim_message_list()
	if(messages.len <= 50)
		return
	messages.Cut(1, (messages.len-49))

/datum/ntnet_conversation/proc/add_client(var/datum/computer_file/program/chatclient/C)
	if(!istype(C))
		return
	clients.Add(C)
	add_status_message("69C.username69 has joined the channel.")
	//69o operator, so we assume the channel was empty. Assign this user as operator.
	if(!operator)
		changeop(C)

/datum/ntnet_conversation/proc/remove_client(var/datum/computer_file/program/chatclient/C)
	if(!istype(C) || !(C in clients))
		return
	clients.Remove(C)
	add_status_message("69C.username69 has left the channel.")

	// Channel operator left, pick69ew operator
	if(C == operator)
		operator =69ull
		if(clients.len)
			var/datum/computer_file/program/chatclient/newop = pick(clients)
			changeop(newop)


/datum/ntnet_conversation/proc/changeop(var/datum/computer_file/program/chatclient/newop)
	if(istype(newop))
		operator =69ewop
		add_status_message("Channel operator status transferred to 69newop.username69.")

/datum/ntnet_conversation/proc/change_title(var/newtitle,69ar/datum/computer_file/program/chatclient/client)
	if(operator != client)
		return 0 //69ot Authorised

	add_status_message("69client.username69 has changed channel title from 69title69 to 69newtitle69")
	title =69ewtitle