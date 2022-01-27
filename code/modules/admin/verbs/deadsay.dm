ADMIN_VERB_ADD(/client/proc/dsay, R_ADMIN|R_DEBUG|R_MOD, TRUE)
//talk in deadchat using our ckey/fakekey
/client/proc/dsay(msg as text)
	set category = "Special69erbs"
	set name = "Dsay" //Gave this shit a shorter name so you only have to time out "dsay" rather than "dead say" to use it --NeoFite
	set hidden = 1
	if(!src.holder)
		to_chat(src, "Only administrators69ay use this command.")
		return
	if(!src.mob)
		return
	if(prefs.muted &69UTE_DEADCHAT)
		to_chat(src, SPAN_WARNING("You cannot send DSAY69essages (muted)."))
		return
	if(src.get_preference_value(/datum/client_preference/show_dsay) == GLOB.PREF_HIDE)
		to_chat(src, SPAN_WARNING("You have deadchat69uted."))
		return

	if (src.handle_spam_prevention(msg,MUTE_DEADCHAT))
		return

	var/stafftype = uppertext(holder.rank)

	msg = sanitize(msg)
	log_admin("DSAY: 69key_name(src)69 : 69msg69")

	if (!msg)
		return

	say_dead_direct("<span class='name'>69stafftype69(69src.holder.fakekey ? src.holder.fakekey : src.key69)</span> says, <span class='message linkify'>\"69msg69\"</span>")


