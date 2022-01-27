var/list/chatrooms = list()

/datum/chatroom
	var/name = "69eneric Chatroom"
	var/list/lo6969ed_in = list()
	var/list/lo69s = list() // chat lo69s
	var/list/banned = list() // banned users
	var/list/whitelist = list() // whitelisted users
	var/list/muted = list()
	var/topic = "" // topic69essa69e for the chatroom
	var/password = "" // blank for no password.
	var/operator = "" // name of the operator

/datum/chatroom/proc/attempt_connect(var/obj/item/device/pda/device,69ar/obj/password)
	if(!device)
		return
