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


/datum/controller/subsystem/chat/proc/queue(target, message, handle_whitespace = TRUE, trailing_newline = TRUE)
	if(!target || !message)
		return

	if(!istext(message))
		CRASH("to_chat called with invalid input type")
		return

	if(target == world)
		target = clients

	//Some macros remain in the string even after parsing and fuck up the eventual output
	var/original_message = message
	message = replacetext(message, "\improper", "")
	message = replacetext(message, "\proper", "")
	if(handle_whitespace)
		message = replacetext(message, "\n", "<br>")
		message = replacetext(message, "\t", "[GLOB.TAB][GLOB.TAB]")
	if (trailing_newline)
		message += "<br>"

	//Replace expanded \icon macro with icon2html
	//regex/Replace with a proc won't work here because icon2html takes target as an argument and there is no way to pass it to the replacement proc
	//not even hacks with reassigning usr work
	var/regex/i = new(@/<IMG CLASS=icon SRC=(\[[^]]+])(?: ICONSTATE='([^']+)')?>/, "g")
	while(i.Find(message))
		message = copytext(message,1,i.index)+icon2html(locate(i.group[1]), target, icon_state=i.group[2])+copytext(message,i.next)

	message = \
		symbols_to_unicode(
			strip_improper(
				color_macro_to_html(
					message
				)
			)
		)

	//url_encode it TWICE, this way any UTF-8 characters are able to be decoded by the Javascript.
	//Do the double-encoding here to save nanoseconds
	var/twiceEncoded = url_encode(url_encode(message))

	if(islist(target))
		for(var/I in target)
			var/client/C = CLIENT_FROM_VAR(I) //Grab us a client if possible

			if(!C)
				return

			//Send it to the old style output window.
			SEND_TEXT(C, original_message)

			if(!C?.chatOutput || C.chatOutput.broken) //A player who hasn't updated his skin file.
				continue

			if(!C.chatOutput.loaded) //Client still loading, put their messages in a queue
				C.chatOutput.messageQueue += message
				continue

			payload[C] += twiceEncoded

	else
		var/client/C = CLIENT_FROM_VAR(target) //Grab us a client if possible

		if(!C)
			return

		//Send it to the old style output window.
		SEND_TEXT(C, original_message)

		if(!C?.chatOutput || C.chatOutput.broken) //A player who hasn't updated his skin file.
			return

		if(!C.chatOutput.loaded) //Client still loading, put their messages in a queue
			C.chatOutput.messageQueue += message
			return

		payload[C] += twiceEncoded
