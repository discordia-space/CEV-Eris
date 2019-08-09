ADMIN_VERB_ADD(/client/proc/dsay, R_ADMIN|R_DEBUG|R_MOD, TRUE)
//talk in deadchat using our ckey/fakekey
/client/proc/dsay(msg as text)
	set category = "Special Verbs"
	set name = "Dsay" //Gave this shit a shorter name so you only have to time out "dsay" rather than "dead say" to use it --NeoFite
	set hidden = 1
	if(!src.holder)
		to_chat(src, "Only administrators may use this command.")
		return
	if(!src.mob)
		return
	if(prefs.muted & MUTE_DEADCHAT)
		to_chat(src, SPAN_WARNING("You cannot send DSAY messages (muted)."))
		return
	if(src.get_preference_value(/datum/client_preference/show_dsay) == GLOB.PREF_HIDE)
		to_chat(src, SPAN_WARNING("You have deadchat muted."))
		return

	if (src.handle_spam_prevention(msg,MUTE_DEADCHAT))
		return

	var/stafftype = uppertext(holder.rank)

	msg = sanitize(msg)
	log_admin("DSAY: [key_name(src)] : [msg]")

	if (!msg)
		return

	say_dead_direct("<span class='name'>[stafftype]([src.holder.fakekey ? src.holder.fakekey : src.key])</span> says, <span class='message'>\"[msg]\"</span>")


