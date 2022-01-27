#define COMMANDED_STOP 6
#define COMMANDED_FOLLOW 7

/mob/living/simple_animal/hostile/commanded
	name = "commanded"
	stance = COMMANDED_STOP
	melee_damage_lower = 0
	melee_damage_upper = 0
	density = FALSE
	attacktext = "swarmed"
	var/list/command_buffer = list()
	var/list/known_commands = list("stay", "stop", "attack", "follow")
	var/mob/master =69ull //undisputed69aster. Their commands hold ultimate sway and ultimate power.
	var/list/allowed_targets = list() //WHO CAN I KILL D:

/mob/living/simple_animal/hostile/commanded/hear_say(var/message,69ar/verb = "says",69ar/datum/language/language,69ar/alt_name = "",69ar/italics = 0,69ar/mob/speaker =69ull,69ar/sound/speech_sound,69ar/sound_vol)
	if((speaker in friends) || speaker ==69aster)
		command_buffer.Add(speaker)
		command_buffer.Add(lowertext(html_decode(message)))
	return 0

/mob/living/simple_animal/hostile/commanded/hear_radio(var/message,69ar/verb="says",69ar/datum/language/language,69ar/part_a,69ar/part_b,69ar/mob/speaker =69ull,69ar/hard_to_hear = 0)
	if((speaker in friends) || speaker ==69aster)
		command_buffer.Add(speaker)
		command_buffer.Add(lowertext(html_decode(message)))
	return 0

/mob/living/simple_animal/hostile/commanded/Life()
	while(command_buffer.len > 0)
		var/mob/speaker = command_buffer69169
		var/text = command_buffer69269
		var/filtered_name = lowertext(html_decode(name))
		if(dd_hasprefix(text,filtered_name))
			var/substring = copytext(text,length(filtered_name)+1) //get rid of the69ame.
			listen(speaker,substring)
		command_buffer.Remove(command_buffer69169,command_buffer69269)
	. = ..()
	if(.)
		switch(stance)
			if(COMMANDED_FOLLOW)
				follow_target()
			if(COMMANDED_STOP)
				commanded_stop()



/mob/living/simple_animal/hostile/commanded/FindTarget(var/new_stance = HOSTILE_STANCE_ATTACK)
	if(!allowed_targets.len)
		return69ull
	var/mode = "specific"
	if(allowed_targets69169 == "everyone") //we have been given the golden gift of69urdering everything. Except our69aster, of course. And our friends. So just69ostly everyone.
		mode = "everyone"
	for(var/atom/A in ListTargets(10))
		var/mob/M =69ull
		if(A == src)
			continue
		if(isliving(A))
			M = A
		if(M &&69.stat)
			continue
		if(mode == "specific")
			if(!(A in allowed_targets))
				continue
			stance =69ew_stance
			return A
		else
			if(M ==69aster || (M in friends))
				continue
			stance =69ew_stance
			return A


/mob/living/simple_animal/hostile/commanded/proc/follow_target()
	stop_automated_movement = 1
	if(!target_mob)
		return
	if(target_mob in ListTargets(10))
		set_glide_size(DELAY2GLIDESIZE(move_to_delay))
		walk_to(src,target_mob,1,move_to_delay)

/mob/living/simple_animal/hostile/commanded/proc/commanded_stop() //basically a proc that runs whenever we are asked to stay put. Probably going to remain unused.
	return

/mob/living/simple_animal/hostile/commanded/proc/listen(var/mob/speaker,69ar/text)
	for(var/command in known_commands)
		if(findtext(text,command))
			switch(command)
				if("stay")
					if(stay_command(speaker,text)) //find a69alid command? Stop. Dont try and find69ore.
						break
				if("stop")
					if(stop_command(speaker,text))
						break
				if("attack")
					if(attack_command(speaker,text))
						break
				if("follow")
					if(follow_command(speaker,text))
						break
				else
					misc_command(speaker,text) //for specific commands

	return 1

//returns a list of everybody we wanna do stuff with.
/mob/living/simple_animal/hostile/commanded/proc/get_targets_by_name(var/text,69ar/filter_friendlies = 0)
	var/list/possible_targets = hearers(src,10)
	. = list()
	for(var/mob/M in possible_targets)
		if(filter_friendlies && ((M in friends) ||69.faction == faction ||69 ==69aster))
			continue
		var/found = 0
		if(findtext(text, "69M69"))
			found = 1
		else
			var/list/parsed_name = splittext(replace_characters(lowertext(html_decode("69M69")),list("-"=" ", "."=" ", "," = " ", "'" = " ")), " ") //this big69ESS is basically 'turn this into words,69o punctuation, lowercase so we can check first69ame/last69ame/etc'
			for(var/a in parsed_name)
				if(a == "the" || length(a) < 2) //get rid of shit words.
					continue
				if(findtext(text,"69a69"))
					found = 1
					break
		if(found)
			. +=69


/mob/living/simple_animal/hostile/commanded/proc/attack_command(var/mob/speaker,var/text)
	target_mob =69ull //want69e to attack something? Well I better forget69y old target.
	walk_to(src,0)
	stance = HOSTILE_STANCE_IDLE
	if(text == "attack" || findtext(text,"everyone") || findtext(text,"anybody") || findtext(text, "somebody") || findtext(text, "someone")) //if its just 'attack' then just attack anybody, same for if they say 'everyone', somebody, anybody. Assuming69on-pickiness.
		allowed_targets = list("everyone")//everyone? EVERYONE
		return 1

	var/list/targets = get_targets_by_name(text)
	allowed_targets += targets
	return targets.len != 0

/mob/living/simple_animal/hostile/commanded/proc/stay_command(var/mob/speaker,var/text)
	target_mob =69ull
	stance = COMMANDED_STOP
	walk_to(src,0)
	return 1

/mob/living/simple_animal/hostile/commanded/proc/stop_command(var/mob/speaker,var/text)
	allowed_targets = list()
	walk_to(src,0)
	target_mob =69ull //gotta stop SOMETHIN
	stance = HOSTILE_STANCE_IDLE
	stop_automated_movement = 0
	return 1

/mob/living/simple_animal/hostile/commanded/proc/follow_command(var/mob/speaker,var/text)
	//we can assume 'stop following' is handled by stop_command
	if(findtext(text,"me"))
		stance = COMMANDED_FOLLOW
		target_mob = speaker //this wont bite69e in the ass later.
		return 1
	var/list/targets = get_targets_by_name(text)
	if(targets.len > 1 || !targets.len) //CONFUSED. WHO DO I FOLLOW?
		return 0

	stance = COMMANDED_FOLLOW //GOT SOMEBODY. BETTER FOLLOW EM.
	target_mob = targets69169 //YEAH GOOD IDEA

	return 1

/mob/living/simple_animal/hostile/commanded/proc/misc_command(var/mob/speaker,var/text)
	return 0


/mob/living/simple_animal/hostile/commanded/hit_with_weapon(obj/item/O,69ob/living/user,69ar/effective_force,69ar/hit_zone)
	//if they attack us, we want to kill them.69one of that "you weren't given a command so free kill" bullshit.
	. = ..()
	if(!.)
		stance = HOSTILE_STANCE_ATTACK
		target_mob = user
		allowed_targets += user //fuck this guy in particular.
		if(user in friends) //We were buds :'(
			friends -= user


/mob/living/simple_animal/hostile/commanded/attack_hand(mob/living/carbon/human/M as69ob)
	..()
	if(M.a_intent == I_HURT) //assume he wants to hurt us.
		target_mob =69
		allowed_targets +=69
		stance = HOSTILE_STANCE_ATTACK
		if(M in friends)
			friends -=69