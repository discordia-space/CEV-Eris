SUBSYSTEM_DEF(chat)
	name = "Chat"
	flags = SS_TICKER
	wait = 1
	priority = SS_PRIORITY_CHAT
	init_order = INIT_ORDER_CHAT

	var/list/payload = list()


/datum/controller/subsystem/chat/fire()
	for(var/i in payload)
		var/client/C = i
		C << output(payload[C], "browseroutput:output")
		payload -= C

		if(MC_TICK_CHECK)
			return


/datum/controller/subsystem/chat/proc/queue(target, message, handle_whitespace = TRUE)
	if(!target || !message)
		return

	if(!istext(message))
		CRASH("to_chat called with invalid input type") //Watch out for these. I did not specifically make sure that this doesn't happen.

	if(target == world)
		target = clients

	var/original_message = message
	//Some macros remain in the string even after parsing and fuck up the eventual output
	message = replacetext(message, "\improper", "")
	message = replacetext(message, "\proper", "")
	if(handle_whitespace)
		message = replacetext(message, "\n", "<br>")
		message = replacetext(message, "\t", "[FOURSPACES][FOURSPACES]")
	message += "<br>"


	var/static/regex/i = new(@/<IMG CLASS=icon SRC=(\[[^]]+])(?: ICONSTATE='([^']+)')?>/, "g")
	while(i.Find(message))
		message = copytext(message,1,i.index)+icon2html(locate(i.group[1]), target, icon_state=i.group[2])+copytext(message,i.next)

	message = \
		symbols_to_unicode(
			cyrillic_to_unicode(
				cp1251_to_utf8(
					strip_improper(
						color_macro_to_html(
							message
						)
					)
				)
			)
		)

	//url_encode it TWICE, this way any UTF-8 characters are able to be decoded by the Javascript.
	//Do the double-encoding here to save nanoseconds
	var/twiceEncoded = url_encode(url_encode(message))

	if(islist(target))
		for(var/I in target)
			var/client/C = CLIENT_FROM_VAR(I)

			if(!C)
				return

			//Send it to the old style output window.
			C << original_message

			if(!C || !C.chatOutput || C.chatOutput.broken) //A player who hasn't updated his skin file.
				continue

			if(!C.chatOutput.loaded) //Client still loading, put their messages in a queue
				if(length(C.chatOutput.messageQueue) > 25)
					continue
				C.chatOutput.messageQueue += message
				continue

			payload[C] += twiceEncoded

	else
		var/client/C = CLIENT_FROM_VAR(target)

		if(!C)
			return

		//Send it to the old style output window.
		C << original_message

		if(!C || !C.chatOutput || C.chatOutput.broken) //A player who hasn't updated his skin file.
			return

		if(!C.chatOutput.loaded) //Client still loading, put their messages in a queue
			if(length(C.chatOutput.messageQueue) > 25)
				return
			C.chatOutput.messageQueue += message
			return

		payload[C] += twiceEncoded
