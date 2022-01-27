ADMIN_VERB_ADD(/client/proc/aooc, R_ADMIN, FALSE)
/client/proc/aooc(msg as text)
	set category = "OOC"
	set name = "AOOC"
	set desc = "Antagonist OOC"

	if(!check_rights(R_ADMIN))	return

	msg = sanitize(msg)
	if(!msg)	return

	var/display_name = src.key
	if(holder && holder.fakekey)
		display_name = holder.fakekey

	for(var/mob/M in SSmobs.mob_list)
		if((M.mind &&69.mind.antagonist.len &&69.client) || check_rights(R_ADMIN, 0,69))
			to_chat(M, "<font color='#960018'><span class='ooc'>" + create_text_tag("aooc", "Antag-OOC:",69.client) + " <EM>69display_name69:</EM> <span class='message linkify'>69msg69</span></span></font>")

	log_ooc("(ANTAG) 69key69 : 69msg69")