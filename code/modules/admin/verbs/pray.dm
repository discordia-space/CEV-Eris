/mob/verb/pray(msg as text)
	set category = "IC"
	set name = "Pray"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "\red Speech is currently admin-disabled.")
		return

	msg = sanitize(msg)
	if(!msg)	return

	if(usr.client)
		if(usr.client.prefs.muted & MUTE_PRAY)
			to_chat(usr, "\red You cannot pray (muted).")
			return
		if(src.client.handle_spam_prevention(msg,MUTE_PRAY))
			return

	var/image/cross = image('icons/obj/storage.dmi',"bible")
	msg = "\blue \icon[cross] <b><font color=purple>PRAY: </font>[key_name(src, 1)] (<A HREF='?_src_=holder;adminmoreinfo=\ref[src]'>?</A>) (<A HREF='?_src_=holder;adminplayeropts=\ref[src]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[src]'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=\ref[src]'>SM</A>) ([admin_jump_link(src, src)]) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=holder;adminspawncookie=\ref[src]'>SC</a>):</b> [msg]"

	for(var/client/C in admins)
		if(R_ADMIN & C.holder.rights)
			if(C.get_preference_value(/datum/client_preference/staff/show_chat_prayers) == GLOB.PREF_SHOW)
				to_chat(C, msg)
	to_chat(usr, "Your prayers have been received by the gods.")


	//log_admin("HELP: [key_name(src)]: [msg]")
