#define69EMOFILE "data/memo.sav"	//where the69emos are saved

ADMIN_VERB_ADD(/client/proc/admin_memo, R_ADMIN, FALSE)
//admin69emo system. show/delete/write.
// +SERVER needed to delete admin69emos of others
//switch69erb so we don't spam up the69erb lists with like, 369erbs for this feature.
/client/proc/admin_memo(task in list("write","show","delete"))
	set name = "Memo"
	set category = "Server"
	if(!config.admin_memo_system)	return
	if(!check_rights(0))	return
	switch(task)
		if("write")		admin_memo_write()
		if("show")		admin_memo_show()
		if("delete")	admin_memo_delete()

//write a69essage
/client/proc/admin_memo_write()
	var/savefile/F = new(MEMOFILE)
	if(F)
		var/memo = sanitize(input(src,"Type your69emo\n(Leaving it blank will delete your current69emo):","Write69emo",null) as null|message, extra = 0)
		switch(memo)
			if(null)
				return
			if("")
				F.dir.Remove(ckey)
				to_chat(src, "<b>Memo removed</b>")
				return
		if( findtext(memo,"<script",1,0) )
			return
		F69ckey69 << "69key69 on 69time2text(world.realtime,"(DDD) DD69MM hh:mm")69<br>69memo69"
		message_admins("69key69 set an admin69emo:<br>69memo69")

//show all69emos
/client/proc/admin_memo_show()
	if(config.admin_memo_system)
		var/savefile/F = new(MEMOFILE)
		if(F)
			for(var/ckey in F.dir)
				to_chat(src, "<center><span class='motd'><b>Admin69emo</b><i> by 69F69ckey6969</i></span></center>")

//delete your own or somebody else's69emo
/client/proc/admin_memo_delete()
	var/savefile/F = new(MEMOFILE)
	if(F)
		var/ckey
		if(check_rights(R_SERVER,0))	//high ranking admins can delete other admin's69emos
			ckey = input(src,"Whose69emo shall we remove?","Remove69emo",null) as null|anything in F.dir
		else
			ckey = src.ckey
		if(ckey)
			F.dir.Remove(ckey)
			to_chat(src, "<b>Removed69emo created by 69ckey69.</b>")

#undef69EMOFILE