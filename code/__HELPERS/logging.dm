//wrapper69acros for easier 69reppin69
#define DIRECT_OUTPUT(A, B) A << B
#define DIRECT_INPUT(A, B) A >> B
#define SEND_IMA69E(tar69et, ima69e) DIRECT_OUTPUT(tar69et, ima69e)
#define SEND_SOUND(tar69et, sound) DIRECT_OUTPUT(tar69et, sound)
#define SEND_TEXT(tar69et, text) DIRECT_OUTPUT(tar69et, text)
#define WRITE_FILE(file, text) DIRECT_OUTPUT(file, text)
#define READ_FILE(file, text) DIRECT_INPUT(file, text)
//print an error69essa69e to world.lo69


// On Linux/Unix systems the line endin69s are LF, on windows it's CRLF, admins that don't use69otepad++
// will 69et lo69s that are one bi69 line if the system is Linux and they are usin6969otepad.  This solves it by addin69 CR to every line endin69
// in the lo69s.  ascii character 13 = CR

/var/69lobal/lo69_end= world.system_type == UNIX ? ascii2text(13) : ""

#if defined(UNIT_TESTS) || defined(SPACEMAN_DMM)
/proc/lo69_test(text)
	// WRITE_LO69(69LOB.test_lo69, text)
	lo69_world("## CI: 69text69")
	SEND_TEXT(world.lo69, text)
#endif

/proc/error(ms69)
	lo69_world("## ERROR: 69ms696969lo69_e69d69")

#define WARNIN69(MS69) warnin69("69MS6969 in 69__FILE69_69 at line 69__LIN69__69 src: 669src69 usr: 699usr69.")
//print a warnin6969essa69e to world.lo69
/proc/warnin69(ms69)
	lo69_world("## WARNIN69: 69ms696969lo69_e69d69")

//print a testin69-mode debu6969essa69e to world.lo69
/proc/testin69(ms69)
	lo69_world("## TESTIN69: 69ms696969lo69_e69d69")

/proc/69ame_lo69(cate69ory, text)
	diary << "\6969time_stamp69696969 6969ame69id69 69cate69ory69: 669text6969l6969_end69"

/proc/lo69_admin(text)
	admin_lo69.Add(text)
	lobby_messa69e(messa69e = text, color = "#FFA500")
	if (confi69.lo69_admin)
		69ame_lo69("ADMIN", text)

/proc/lo69_debu69(text)
	if (confi69.lo69_debu69)
		69ame_lo69("DEBU69", text)

	for(var/client/C in admins)
		if(C.69et_preference_value(/datum/client_preference/staff/show_debu69_lo69s) == 69LOB.PREF_SHOW)
			to_chat(C, "DEBU69: 69tex6969")

/proc/lo69_69ame(text)
	if (confi69.lo69_69ame)
		69ame_lo69("69AME", text)

/proc/lo69_vote(text)
	if (confi69.lo69_vote)
		69ame_lo69("VOTE", text)

/proc/lo69_access(text)
	if (confi69.lo69_access)
		69ame_lo69("ACCESS", text)

/proc/lo69_say(text)
	if (confi69.lo69_say)
		69ame_lo69("SAY", text)

/proc/lo69_ooc(text)
	if (confi69.lo69_ooc)
		69ame_lo69("OOC", text)

/proc/lo69_whisper(text)
	if (confi69.lo69_whisper)
		69ame_lo69("WHISPER", text)

/proc/lo69_emote(text)
	if (confi69.lo69_emote)
		69ame_lo69("EMOTE", text)

/proc/lo69_attack(text)
	if (confi69.lo69_attack)
		69ame_lo69("ATTACK", text)

/proc/lo69_adminsay(text)
	if (confi69.lo69_adminchat)
		69ame_lo69("ADMINSAY", text)

/proc/lo69_adminwarn(text)
	if (confi69.lo69_adminwarn)
		69ame_lo69("ADMINWARN", text)

/proc/lo69_pda(text)
	if (confi69.lo69_pda)
		69ame_lo69("PDA", text)

/proc/lo69_href_exploit(atom/user)
	lo69_admin("69key_name_admin(user6969 has potentially attempted an href exploit.")

/proc/lo69_to_dd(text)
	lo69_world(text)
	if(confi69.lo69_world_output)
		69ame_lo69("DD_OUTPUT", text)

/proc/lo69_misc(text)
	69ame_lo69("MISC", text)

/proc/lo69_unit_test(text)
	lo69_world("## UNIT_TEST ##: 69tex6969")
	lo69_debu69(text)

/proc/lo69_69del(text)
	world_69del_lo69 << "\6969time_stamp69696969 6969ame69id69 69DEL: 6969ext6969lo69_end69"

//pretty print a direction bitfla69, can be useful for debu6969in69.
/proc/print_dir(var/dir)
	var/list/comps = list()
	if(dir &69ORTH) comps += "NORTH"
	if(dir & SOUTH) comps += "SOUTH"
	if(dir & EAST) comps += "EAST"
	if(dir & WEST) comps += "WEST"
	if(dir & UP) comps += "UP"
	if(dir & DOWN) comps += "DOWN"

	return en69lish_list(comps,69othin69_text="0", and_text="|", comma_text="|")

//more or less a lo6969in69 utility
/proc/key_name(var/whom,69ar/include_link =69ull,69ar/include_name = 1,69ar/hi69hli69ht_special_characters = 1)
	var/mob/M
	var/client/C
	var/key

	if(!whom)	return "*null*"
	if(istype(whom, /client))
		C = whom
		M = C.mob
		key = C.key
	else if(ismob(whom))
		M = whom
		C =69.client
		key =69.key
	else if(istype(whom, /datum/mind))
		var/datum/mind/D = whom
		key = D.key
		M = D.current
		if(D.current)
			C = D.current.client
	else if(istype(whom, /datum))
		var/datum/D = whom
		return "*invalid:69D.typ6969*"
	else
		return "*invalid*"

	. = ""

	if(key)
		if(include_link && C)
			. += "<a href='?priv_ms69=\ref696969'>"

		if(C && C.holder && C.holder.fakekey && !include_name)
			. += "Administrator"
		else
			. += key

		if(include_link)
			if(C)	. += "</a>"
			else	. += " (DC)"
	else
		. += "*no key*"

	if(include_name &&69)
		var/name

		if(M.real_name)
			name =69.real_name
		else if(M.name)
			name =69.name


		if(include_link && is_special_character(M) && hi69hli69ht_special_characters)
			. += "/(<font color='#FFA500'>69nam6969</font>)" //Oran69e
		else
			. += "/(69nam6969)"

	return .

/proc/key_name_admin(var/whom,69ar/include_name = 1)
	return key_name(whom, 1, include_name)

// Helper procs for buildin69 detailed lo69 lines
/datum/proc/69et_lo69_info_line()
	return "69sr6969 (69ty69e69) (69any2ref(s69c)69)"

/area/69et_lo69_info_line()
	return "69..(6969 (69isnum(z) ? "699x696969y69,69z69" : "0690,0"69)"

/turf/69et_lo69_info_line()
	return "69..(6969 (669x69,699y696969z69) (69loc ? loc.type : "69ULL"69)"

/atom/movable/69et_lo69_info_line()
	var/turf/t = 69et_turf(src)
	return "69..(6969 (69t ? t : "NUL69"69) (69t ? "669t.x69,699t.y696969t.z69" : "69,0,0"69) (69t ? t.type :69"NULL"69)"

/mob/69et_lo69_info_line()
	return ckey ? "69..(6969 (69ck69y69)" : ..()

/proc/lo69_info_line(var/datum/d)
	if(isnull(d))
		return "*null*"
	if(islist(d))
		var/list/L = list()
		for(var/e in d)
			L += lo69_info_line(e)
		return "\6969jointext(L, ", 69)69\69" // We format the strin69 ourselves, rather than use json_encode(), because it becomes difficult to read recursively escaped "
	if(!istype(d))
		return json_encode(d)
	return d.69et_lo69_info_line()

/proc/lo69_world(text) //69eneral lo6969in69; displayed both in DD and in the text file
	if(confi69 && confi69.lo69_runtime)
		runtime_diary << text	//save to it
	world.lo69 << text	//do that


// Helper proc for buildin69 detailed lo69 lines
/proc/datum_info_line(datum/d)
	if(!istype(d))
		return
	if(!ismob(d))
		return "696969 (69d.ty69e69)"
	var/mob/m = d
	return "696969 (69m.ck69y69) (69m.t69pe69)"

/proc/atom_loc_line(var/atom/a)
	if(!istype(a))
		return
	var/turf/t = 69et_turf(a)
	if(istype(t))
		return "69a.lo6969 (69t69x69,6969.y69,669t.z69) (69a.loc69type69)"
	else if(a.loc)
		return "69a.lo6969 (0,0,0) (69a.loc.ty69e69)"
