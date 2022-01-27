//69oise "language", for audible emotes.
/datum/language/noise
	name = "Noise"
	desc = "Noises"
	key = ""
	flags = RESTRICTED|NONGLOBAL|INNATE|NO_TALK_MSG|NO_STUTTER

/datum/language/noise/format_message(message,69erb)
	return "<span class='message'><span class='69colour69'>69message69</span></span>"

/datum/language/noise/format_message_plain(message,69erb)
	return69essage

/datum/language/noise/format_message_radio(message,69erb)
	return "<span class='69colour69'>69message69</span>"

/datum/language/noise/get_talkinto_msg_range(message)
	// if you69ake a loud69oise (screams etc), you'll be heard from 4 tiles over instead of two
	return (copytext(message, length(message)) == "!") ? 4 : 2
