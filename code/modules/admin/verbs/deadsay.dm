//talk in deadchat using our ckey/fakekey
/client/proc/dsay(msg as text)
	set category = "Special Verbs"
	set name = "Dsay" //Gave this shit a shorter name so you only have to time out "dsay" rather than "dead say" to use it --NeoFite
	set hidden = 1
	if(!holder)
		to_chat(src, "Only administrators may use this command.")
		return
	if(!mob)
		return
	if(prefs.muted & MUTE_DEADCHAT)
		to_chat(src, span_warning("You cannot send DSAY messages (muted)."))
		return
	if(get_preference_value(/datum/client_preference/show_dsay) == GLOB.PREF_HIDE)
		to_chat(src, span_warning("You have deadchat muted."))
		return

	if(handle_spam_prevention(msg,MUTE_DEADCHAT))
		return

	msg = sanitize(msg)
	log_admin("DSAY: [key_name(src)] : [msg]")
	mob.log_talk(msg, LOG_DSAY)

	if(!msg)
		return

	var/rank_name = holder.rank
	var/admin_name = key

	var/name_and_rank = "[span_tooltip(rank_name, "STAFF")] ([admin_name])"

	deadchat_broadcast("[span_prefix("DEAD:")] [name_and_rank] says, <span class='message'>\"[emoji_parse(msg)]\"</span>")
	// say_dead_direct(span_name("[stafftype]([holder.fakekey ? holder.fakekey : key])</span> says, <span class='message linkify'>\"[msg]\""))
