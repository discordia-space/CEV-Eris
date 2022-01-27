ADMIN_VERB_ADD(/client/proc/cmd_admin_say, R_ADMIN, TRUE)
//admin-only ooc chat
/client/proc/cmd_admin_say(msg as text)
	set category = "Special69erbs"
	set name = "Asay" //Gave this shit a shorter name so you only have to time out "asay" rather than "admin say" to use it --NeoFite
	set hidden = 1
	if(!check_rights(R_ADMIN))	return

	msg = sanitize(msg)
	if(!msg)	return

	log_admin("ADMIN: 69key_name(src)69 : 69msg69")

	msg = emoji_parse(msg)

	if(check_rights(R_ADMIN,0))
		for(var/client/C in admins)
			if(R_ADMIN & C.holder.rights)
				to_chat(C, "<span class='admin_channel'>" + create_text_tag("admin", "ADMIN:", C) + " <span class='name'>69key_name(usr, 1)69</span>(69admin_jump_link(mob, src)69): <span class='message linkify'>69msg69</span></span>")


ADMIN_VERB_ADD(/client/proc/cmd_mod_say, R_ADMIN|R_MOD|R_MENTOR, TRUE)
/client/proc/cmd_mod_say(msg as text)
	set category = "Special69erbs"
	set name = "Msay"
	set hidden = 1

	if(!check_rights(R_ADMIN|R_MOD|R_MENTOR))	return

	msg = sanitize(msg)
	log_admin("MOD: 69key_name(src)69 : 69msg69")

	if (!msg)
		return

	var/sender_name = key_name(usr, 1)
	if(check_rights(R_ADMIN, 0))
		sender_name = "<span class='admin'>69sender_name69</span>"
	for(var/client/C in admins)
		to_chat(C, "<span class='mod_channel'>" + create_text_tag("mod", "MOD:", C) + " <span class='name'>69sender_name69</span>(69admin_jump_link(mob, C.holder)69): <span class='message linkify'>69msg69</span></span>")


