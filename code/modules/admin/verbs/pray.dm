/mob/verb/pray(msg as text)
	set category = "IC"
	set name = "Pray"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "\red Speech is currently admin-disabled.")
		return

	msg = sanitize(msg)
	if(!msg)	return

	if(usr.client)
		if(usr.client.prefs.muted &69UTE_PRAY)
			to_chat(usr, "\red You cannot pray (muted).")
			return
		if(src.client.handle_spam_prevention(msg,MUTE_PRAY))
			return

	var/image/cross = image('icons/obj/storage.dmi',"bible")
	msg = "\blue \icon69cross69 <b><font color=purple>PRAY: </font>69key_name(src, 1)69 (<A HREF='?_src_=holder;adminmoreinfo=\ref69src69'>?</A>) (<A HREF='?_src_=holder;adminplayeropts=\ref69src69'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref69src69'>VV</A>) (<A HREF='?_src_=holder;subtlemessage=\ref69src69'>SM</A>) (69admin_jump_link(src, src)69) (<A HREF='?_src_=holder;secretsadmin=check_antagonist'>CA</A>) (<A HREF='?_src_=holder;adminspawncookie=\ref69src69'>SC</a>):</b> 69msg69"

	for(var/client/C in admins)
		if(R_ADMIN & C.holder.rights)
			if(C.get_preference_value(/datum/client_preference/staff/show_chat_prayers) == GLOB.PREF_SHOW)
				to_chat(C,69sg)
	to_chat(usr, "Your prayers have been received by the gods.")


	//log_admin("HELP: 69key_name(src)69: 69msg69")
