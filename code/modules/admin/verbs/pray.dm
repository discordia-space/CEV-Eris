/mob/verb/pray(msg as text)
	set category = "IC"
	set name = "Pray"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_red("Speech is currently admin-disabled."))
		return

	msg = sanitize(msg)
	if(!msg)	return

	if(usr.client)
		if(usr.client.prefs.muted & MUTE_PRAY)
			to_chat(usr, span_red("You cannot pray (muted)."))
			return
		if(src.client.handle_spam_prevention(msg,MUTE_PRAY))
			return

	var/image/cross = image('icons/obj/storage.dmi',"bible")
	// List of people who will see the bibble icon
	var/receivers = list()
	receivers |= src
	receivers |= GLOB.admins

	msg = span_blue("[icon2html(cross, receivers)] <b><font color=purple>PRAY: </font> [ADMIN_FULLMONTY(src)]:</b> [msg]")

	for(var/client/C in GLOB.admins)
		if(R_ADMIN & C.holder.rights)
			if(C.get_preference_value(/datum/client_preference/staff/show_chat_prayers) == GLOB.PREF_SHOW)
				to_chat(C, msg)
	to_chat(usr, "Your prayers have been received by the gods.")

	log_prayer("[src.key]/([src.name]): [msg]")

	//log_admin("HELP: [key_name(src)]: [msg]")
