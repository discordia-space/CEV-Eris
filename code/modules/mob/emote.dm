// All69obs should have custom emote, really..
//m_type == 1 -->69isual.
//m_type == 2 --> audible
/mob/proc/custom_emote(var/m_type=1,var/message =69ull)
	if(usr && stat || !use_me && usr == src)
		to_chat(src, "You are unable to emote.")
		return

	var/muzzled = istype(src.wear_mask, /obj/item/clothing/mask/muzzle) || istype(src.wear_mask, /obj/item/grenade)
	if(m_type == 2 &&69uzzled) return

	var/input
	if(!message)
		input = sanitize(input(src,"Choose an emote to display.") as text|null)
	else
		input =69essage
	if(input)
		message = "<B>69src69</B> 69input69"
	else
		return


	if (message)
		log_emote("69name69/69key69 : 69message69")

		send_emote(message,69_type)

/mob/proc/emote_dead(var/message)

	if(client.prefs.muted &69UTE_DEADCHAT)
		to_chat(src, SPAN_DANGER("You cannot send deadchat emotes (muted)."))
		return

	if(get_preference_value(/datum/client_preference/show_dsay) == GLOB.PREF_HIDE)
		to_chat(src, SPAN_DANGER("You have deadchat69uted."))
		return

	if(!src.client.holder)
		if(!config.dsay_allowed)
			to_chat(src, SPAN_DANGER("Deadchat is globally69uted."))
			return


	var/input
	if(!message)
		input = sanitize(input(src, "Choose an emote to display.") as text|null)
	else
		input =69essage

	if(input)
		log_emote("Ghost/69src.key69 : 69input69")
		say_dead_direct(input, src)

//This is a central proc that all emotes are run through. This handles sending the69essages to living69obs
/mob/proc/send_emote(var/message,69ar/type)
	var/list/messageturfs = list()//List of turfs we broadcast to.
	var/list/messagemobs = list()//List of living69obs69earby who can hear it, and distant ghosts who've chosen to hear it
	var/list/messagemobs_neardead = list()//List of69earby ghosts who can hear it. Those that qualify ONLY go in this list
	for (var/turf in69iew(world.view, get_turf(src)))
		messageturfs += turf

	for(var/mob/M in GLOB.player_list)
		if (!M.client || istype(M, /mob/new_player))
			continue
		if(get_turf(M) in69essageturfs)
			if (istype(M, /mob/observer))
				messagemobs_neardead +=69
				continue
			else if (istype(M, /mob/living) && !(type == 2 && (sdisabilities & DEAF || ear_deaf)))
				messagemobs +=69
		else if(src.client)
			if  (M.stat == DEAD && (M.get_preference_value(/datum/client_preference/ghost_ears) == GLOB.PREF_ALL_SPEECH))
				messagemobs +=69
				continue

	for (var/mob/N in69essagemobs)
		N.show_message(message, type)

	message = "<B>69message69</B>"

	for (var/mob/O in69essagemobs_neardead)
		O.show_message(message, type)