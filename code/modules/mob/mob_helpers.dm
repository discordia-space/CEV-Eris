/proc/issmall(A)
	if(A && isliving(A))
		var/mob/living/L = A
		return L.mob_size <=69OB_SMALL
	return 0

/mob/living/proc/isSynthetic()
	return 0

/mob/living/carbon/human/isSynthetic()
	// If they are 100% robotic, they count as synthetic.
	for(var/obj/item/organ/external/E in organs)
		if(!BP_IS_ROBOTIC(E))
			return FALSE
	return TRUE

/mob/living/silicon/isSynthetic()
	return 1

/mob/proc/isMonkey()
	return 0

/mob/living/carbon/human/isMonkey()
	return istype(species, /datum/species/monkey)

proc/isdeaf(A)
	if(isliving(A))
		var/mob/living/M = A
		return (M.sdisabilities & DEAF) ||69.ear_deaf
	return 0

/proc/hasorgans(A) // Fucking really??
	return ishuman(A)

/proc/iscuffed(A)
	if(iscarbon(A))
		var/mob/living/carbon/C = A
		if(C.handcuffed)
			return 1
	return 0

/proc/hassensorlevel(A,69ar/level)
	var/mob/living/carbon/human/H = A
	if(istype(H) && istype(H.w_uniform, /obj/item/clothing/under))
		var/obj/item/clothing/under/U = H.w_uniform
		return U.sensor_mode >= level
	return 0

/proc/getsensorlevel(A)
	var/mob/living/carbon/human/H = A
	if(istype(H) && istype(H.w_uniform, /obj/item/clothing/under))
		var/obj/item/clothing/under/U = H.w_uniform
		return U.sensor_mode
	return SUIT_SENSOR_OFF


/proc/is_admin(var/mob/user)
	return check_rights(R_ADMIN, 0, user) != 0


/proc/hsl2rgb(h, s, l)
	return //TODO: Implement

/*
	Miss Chance
*/

//TODO: Integrate defence zones and targeting body parts with the actual organ system,69ove these into organ definitions.

//The base69iss chance for the different defence zones
var/list/global/base_miss_chance = list(
	BP_HEAD = 45,
	BP_CHEST = 10,
	BP_GROIN = 20,
	BP_L_LEG  = 20,
	BP_R_LEG = 20,
	BP_L_ARM = 20,
	BP_R_ARM = 20
	)

//Used to weight organs when an organ is hit randomly (i.e.69ot a directed, aimed attack).
//Also used to weight the protection69alue that armour provides for covering that body part when calculating protection from full-body effects.
var/list/global/organ_rel_size = list(
	BP_HEAD = 20,
	BP_CHEST = 70,
	BP_GROIN = 30,
	BP_L_LEG  = 25,
	BP_R_LEG = 25,
	BP_L_ARM = 25,
	BP_R_ARM = 25
)

/proc/check_zone(zone)
	if(!zone)	return BP_CHEST
	switch(zone)
		if(BP_EYES)
			zone = BP_HEAD
		if(BP_MOUTH)
			zone = BP_HEAD
	return zone

// Returns zone with a certain probability. If the probability fails, or69o zone is specified, then a random body part is chosen.
// Do69ot use this if someone is intentionally trying to hit a specific body part.
/proc/ran_zone(zone, probability)
	if (zone)
		zone = check_zone(zone)
		if (prob(probability))
			return zone

	var/ran_zone = zone
	while (ran_zone == zone)
		ran_zone = pick (
			organ_rel_size69BP_HEAD69; BP_HEAD,
			organ_rel_size69BP_CHEST69; BP_CHEST,
			organ_rel_size69BP_GROIN69; BP_GROIN,
			organ_rel_size69BP_L_ARM69; BP_L_ARM,
			organ_rel_size69BP_R_ARM69; BP_R_ARM,
			organ_rel_size69BP_L_LEG 69; BP_L_LEG ,
			organ_rel_size69BP_R_LEG69; BP_R_LEG,
		)

	return ran_zone

//Replaces some of the characters with *, used in whispers. pr = probability of69o star.
//Will try to preserve HTML formatting. re_encode controls whether the returned text is HTML encoded outside tags.
/proc/stars(n, pr = 25, re_encode = 1)
	if (pr < 0)
		return69ull
	else if (pr >= 100)
		return69

	var/intag = 0
	var/block = list()
	. = list()
	for(var/i = 1, i <= length(n), i++)
		var/char = copytext_char(n, i, i+1)
		if(!intag && (char == "<"))
			intag = 1
			. += stars_no_html(JOINTEXT(block), pr, re_encode) //stars added here
			block = list()
		block += char
		if(intag && (char == ">"))
			intag = 0
			. += block //We don't69ess up html tags with stars
			block = list()
	. += (intag ? block : stars_no_html(JOINTEXT(block), pr, re_encode))
	. = JOINTEXT(.)


//Ingnores the possibility of breaking tags.
/proc/stars_no_html(text, pr, re_encode)
	text = html_decode(text) //We don't want to screw up escaped characters
	. = list()
	for(var/i = 1, i <= length(text), i++)
		var/char = copytext_char(text, i, i+1)
		if(char == " " || prob(pr))
			. += char
		else
			. += "*"
	. = JOINTEXT(.)
	if(re_encode)
		. = html_encode(.)

/proc/slur(phrase)
	phrase = html_decode(phrase)
	var/leng=length(phrase)
	var/counter=length(phrase)
	var/newphrase=""
	var/newletter=""
	while(counter>=1)
		newletter=copytext_char(phrase,(leng-counter)+1,(leng-counter)+2)
		if(rand(1,3)==3)
			if(lowertext(newletter)=="o")	newletter="u"
			if(lowertext(newletter)=="s")	newletter="ch"
			if(lowertext(newletter)=="a")	newletter="ah"
			if(lowertext(newletter)=="c")	newletter="k"
		switch(rand(1,15))
			if(1,3,5,8)	newletter="69lowertext(newletter)69"
			if(2,4,6,15)	newletter="69uppertext(newletter)69"
			if(7)	newletter+="'"
			//if(9,10)	newletter="<b>69newletter69</b>"
			//if(11,12)	newletter="<big>69newletter69</big>"
			//if(13)	newletter="<small>69newletter69</small>"
		newphrase+="69newletter69";counter-=1
	return html_encode(newphrase)

/proc/stutter(n)
	var/te = html_decode(n)
	n = length(n)//length of the entire word
	var/list/t = list()
	var/p = 1//1 is the start of any word
	while(p <=69)//while P, which starts at 1 is less or equal to69 which is the length.
		var/n_letter = copytext_char(te, p, p + 1)//copies text from a certain distance. In this case, only one letter at a time.
		if (prob(80) && (lowertext(n_letter) in LIST_OF_CONSONANT))
			if (prob(10))
				n_letter = text("69n_letter69-69n_letter69-69n_letter69-69n_letter69")//replaces the current letter with this instead.
			else
				if (prob(20))
					n_letter = text("69n_letter69-69n_letter69-69n_letter69")
				else
					if (prob(5))
						n_letter =69ull
					else
						n_letter = text("69n_letter69-69n_letter69")
		t +=69_letter //since the above is ran through for each letter, the text just adds up back to the original word.
		p++//for each letter p is increased to find where the69ext letter will be.
	return sanitize(jointext(t,69ull))

/proc/Gibberish(t, p)//t is the inputted69essage, and any69alue higher than 70 for p will cause letters to be replaced instead of added
	/* Turn text into complete gibberish! */
	var/returntext = ""
	for(var/i = 1, i <= length(t), i++)

		var/letter = copytext_char(t, i, i+1)
		if(prob(50))
			if(p >= 70)
				letter = ""

			for(var/j = 1, j <= rand(0, 2), j++)
				letter += pick("#","@","*","&","%","$","/", "<", ">", ";","*","*","*","*","*","*","*")

		returntext += letter

	return returntext


/proc/ninjaspeak(n)
/*
The difference with stutter is that this proc can stutter69ore than 1 letter
The issue here is that anything that does69ot have a space is treated as one word (in69any instances). For instance, "LOOKING," is a word, including the comma.
It's fairly easy to fix if dealing with single letters but69ot so69uch with compounds of letters./N
*/
	var/te = html_decode(n)
	var/t = ""
	n = length(n)
	var/p = 1
	while(p <=69)
		var/n_letter
		var/n_mod = rand(1,4)
		if(p+n_mod>n+1)
			n_letter = copytext_char(te, p,69+1)
		else
			n_letter = copytext_char(te, p, p+n_mod)
		if (prob(50))
			if (prob(30))
				n_letter = text("69n_letter69-69n_letter69-69n_letter69")
			else
				n_letter = text("69n_letter69-69n_letter69")
		else
			n_letter = text("69n_letter69")
		t = text("69t6969n_letter69")
		p=p+n_mod
	return sanitize(t)





/proc/findname(msg)
	for(var/mob/M in SSmobs.mob_list)
		if (M.real_name == text("69msg69"))
			return 1
	return 0


/mob/proc/abiotic(var/full_body = 0)
	if(full_body && ((src.l_hand && !( src.l_hand.abstract )) || (src.r_hand && !( src.r_hand.abstract )) || (src.back || src.wear_mask)))
		return 1

	if((src.l_hand && !( src.l_hand.abstract )) || (src.r_hand && !( src.r_hand.abstract )))
		return 1

	return 0

//converts intent-strings into69umbers and back
var/list/intents = list(I_HELP,I_DISARM,I_GRAB,I_HURT)
/proc/intent_numeric(argument)
	if(istext(argument))
		switch(argument)
			if(I_HELP)		return 0
			if(I_DISARM)	return 1
			if(I_GRAB)		return 2
			else			return 3
	else
		switch(argument)
			if(0)			return I_HELP
			if(1)			return I_DISARM
			if(2)			return I_GRAB
			else			return I_HURT

//change a69ob's act-intent. Input the intent as a string such as "help" or use "right"/"left
/mob/verb/a_intent_change(input as text)
	set69ame = "a-intent"
	set hidden = 1

	if(ishuman(src) || isbrain(src) || isslime(src))
		switch(input)
			if(I_HELP,I_DISARM,I_GRAB,I_HURT)
				a_intent = input
			if("right")
				a_intent = intent_numeric((intent_numeric(a_intent)+1) % 4)
			if("left")
				a_intent = intent_numeric((intent_numeric(a_intent)+3) % 4)
//		if(hud_used && hud_used.action_intent)
//			hud_used.action_intent.icon_state = "intent_69a_intent69"

	else if(isrobot(src))
		switch(input)
			if(I_HELP)
				a_intent = I_HELP
			if(I_HURT)
				a_intent = I_HURT
			if("right","left")
				a_intent = intent_numeric(intent_numeric(a_intent) - 3)
/*		if(hud_used && hud_used.action_intent)
			if(a_intent == I_HURT)
				hud_used.action_intent.icon_state = I_HURT
			else
				hud_used.action_intent.icon_state = I_HELP*/
	if (HUDneed.Find("intent"))
		var/obj/screen/intent/I = HUDneed69"intent"69
		I.update_icon()


proc/is_blind(A)
	if(iscarbon(A))
		var/mob/living/carbon/C = A
		if(C.sdisabilities & BLIND || C.blinded)
			return 1
	return 0

/proc/broadcast_security_hud_message(var/message,69ar/broadcast_source)
	broadcast_hud_message(message, broadcast_source, sec_hud_users, /obj/item/clothing/glasses/hud/security)

/proc/broadcast_medical_hud_message(var/message,69ar/broadcast_source)
	broadcast_hud_message(message, broadcast_source,69ed_hud_users, /obj/item/clothing/glasses/hud/health)

/proc/broadcast_hud_message(var/message,69ar/broadcast_source,69ar/list/targets,69ar/icon)
	var/turf/sourceturf = get_turf(broadcast_source)
	for(var/mob/M in targets)
		var/turf/targetturf = get_turf(M)
		if((targetturf.z == sourceturf.z))
			M.show_message("<span class='info'>\icon69icon69 69message69</span>", 1)

/proc/mobs_in_area(var/area/A)
	var/list/mobs =69ew
	for(var/mob/living/M in SSmobs.mob_list)
		if(get_area(M) == A)
			mobs +=69
	return69obs

//Direct dead say used both by emote and say
//It is somewhat69essy. I don't know what to do.
//I know you can't see the change, but I rewrote the69ame code. It is significantly less69essy69ow
/proc/say_dead_direct(var/message,69ar/mob/subject =69ull)
	var/name
	var/keyname
	if(subject && subject.client)
		var/client/C = subject.client
		keyname = (C.holder && C.holder.fakekey) ? C.holder.fakekey : C.key
		if(C.mob) //Most of the time this is the dead/observer69ob; we can totally use him if there is69o better69ame
			var/mindname
			var/realname = C.mob.real_name
			if(C.mob.mind)
				mindname = C.mob.mind.name
				if(C.mob.mind.original && C.mob.mind.original.real_name)
					realname = C.mob.mind.original.real_name
			if(mindname &&69indname != realname)
				name = "69realname69 died as 69mindname69"
			else
				name = realname

	for(var/mob/M in GLOB.player_list)
		if(M.client && (isghost(M) || (M.client.holder && !is_mentor(M.client))) &&69.get_preference_value(/datum/client_preference/show_dsay) == GLOB.PREF_SHOW)
			var/follow
			var/lname
			if(subject)
				if(subject !=69)
					follow = "(69ghost_follow_link(subject,69)69) "
				if(M.stat != DEAD &&69.client.holder)
					follow = "(69admin_jump_link(subject,69.client.holder)69) "
				var/mob/observer/ghost/DM
				if(isghost(subject))
					DM = subject
				if(M.client.holder) 							// What admins see
					lname = "69keyname6969(DM && DM.anonsay) ? "*" : (DM ? "" : "^")69 (69name69)"
				else
					if(DM && DM.anonsay)						// If the person is actually observer they have the option to be anonymous
						lname = "Ghost of 69name69"
					else if(DM)									//69on-anons
						lname = "69keyname69 (69name69)"
					else										// Everyone else (dead people who didn't ghost yet, etc.)
						lname =69ame
				lname = "<span class='name'>69lname69</span> "
			to_chat(M, "<span class='deadsay'>" + create_text_tag("dead", "DEAD:",69.client) + " 69lname6969follow6969message69</span>")

//Announces that a ghost has joined/left,69ainly for use with wizards
/proc/announce_ghost_joinleave(O,69ar/joined_ghosts = 1,69ar/message = "")
	var/client/C
	//Accept any type, sort what we want here
	if(ismob(O))
		var/mob/M = O
		if(M.client)
			C =69.client
	else if(istype(O, /client))
		C = O
	else if(istype(O, /datum/mind))
		var/datum/mind/M = O
		if(M.current &&69.current.client)
			C =69.current.client
		else if(M.original &&69.original.client)
			C =69.original.client

	if(C)
		var/name
		if(C.mob)
			var/mob/M = C.mob
			if(M.mind &&69.mind.name)
				name =69.mind.name
			if(M.real_name &&69.real_name !=69ame)
				if(name)
					name += " (69M.real_name69)"
				else
					name =69.real_name
		if(!name)
			name = (C.holder && C.holder.fakekey) ? C.holder.fakekey : C.key
		if(joined_ghosts)
			say_dead_direct("The ghost of <span class='name'>69name69</span>69ow 69pick("skulks","lurks","prowls","creeps","stalks")69 among the dead. 69message69")
		else
			say_dead_direct("<span class='name'>69name69</span>69o longer 69pick("skulks","lurks","prowls","creeps","stalks")69 in the realm of the dead. 69message69")

/mob/proc/switch_to_camera(var/obj/machinery/camera/C)
	if (!C.can_use() || stat || (get_dist(C, src) > 1 ||69achine != src || blinded || !canmove))
		return 0
	check_eye(src)
	return 1

/mob/living/silicon/ai/switch_to_camera(var/obj/machinery/camera/C)
	if(!C.can_use() || !is_in_chassis())
		return 0

	eyeobj.setLoc(C)
	return 1

// Returns true if the69ob has a client which has been active in the last given X69inutes.
/mob/proc/is_client_active(var/active = 1)
	return client && client.inactivity < active69INUTES

/mob/proc/can_eat()
	return 1

/mob/proc/can_force_feed()
	return 1

#define SAFE_PERP -50
/mob/living/proc/assess_perp(var/obj/access_obj,69ar/check_access,69ar/auth_weapons,69ar/check_records,69ar/check_arrest)
	if(stat == DEAD)
		return SAFE_PERP

	return 0

/mob/living/carbon/assess_perp(var/obj/access_obj,69ar/check_access,69ar/auth_weapons,69ar/check_records,69ar/check_arrest)
	if(handcuffed)
		return SAFE_PERP

	return ..()

/mob/living/carbon/human/assess_perp(var/obj/access_obj,69ar/check_access,69ar/auth_weapons,69ar/check_records,69ar/check_arrest)
	var/threatcount = ..()
	if(. == SAFE_PERP)
		return SAFE_PERP

	//Agent cards lower threatlevel.
	var/obj/item/card/id/id = GetIdCard()
	if(id && istype(id, /obj/item/card/id/syndicate))
		threatcount -= 2
	// A proper	CentCom id is hard currency.
	else if(id && istype(id, /obj/item/card/id/centcom))
		return SAFE_PERP

	if(check_access && !access_obj.allowed(src))
		threatcount += 4

	if(auth_weapons && !access_obj.allowed(src))
		if(isgun(l_hand) || istype(l_hand, /obj/item/melee))
			threatcount += 4

		if(isgun(r_hand) || istype(r_hand, /obj/item/melee))
			threatcount += 4

		if(isgun(belt) || istype(belt, /obj/item/melee))
			threatcount += 2

		if(species.name != SPECIES_HUMAN)
			threatcount += 2

	if(check_records || check_arrest)
		var/perpname =69ame
		if(id)
			perpname = id.registered_name

		var/datum/data/record/R = find_security_record("name", perpname)
		if(check_records && !R)
			threatcount += 4

		if(check_arrest && R && (R.fields69"criminal"69 == "*Arrest*"))
			threatcount += 4

	return threatcount

/mob/living/simple_animal/hostile/assess_perp(var/obj/access_obj,69ar/check_access,69ar/auth_weapons,69ar/check_records,69ar/check_arrest)
	var/threatcount = ..()
	if(. == SAFE_PERP)
		return SAFE_PERP

	if(!istype(src, /mob/living/simple_animal/hostile/retaliate/goat))
		threatcount += 4
	return threatcount




#undef SAFE_PERP

/mob/proc/get_multitool(var/obj/item/tool/multitool/P)
	if(istype(P))
		return P

/mob/observer/ghost/get_multitool()
	return can_admin_interact() && ..(ghost_multitool)

/mob/living/carbon/human/get_multitool()
	return ..(get_active_hand())

/mob/living/silicon/robot/get_multitool()
	return ..(get_active_hand())

/mob/living/silicon/ai/get_multitool()
	return ..(aiMulti)


//This proc returns true if the69ob has69o health problems. EG,69o damaged organs, alive,69ot poisoned, etc
//It is used by cryopods to allow people to quickly respawn during peaceful times
/mob/proc/in_perfect_health()
	return

/mob/living/in_perfect_health()
	if (stat == DEAD)
		return FALSE

	if (brainloss || bruteloss || cloneloss || fireloss || halloss || oxyloss || toxloss)
		return FALSE


	return TRUE

/mob/living/carbon/human/in_perfect_health()
	for (var/a in bad_external_organs)
		return FALSE

	for (var/obj/item/organ/o in internal_organs)
		if (o.damage)
			return FALSE

	return ..()

/mob/proc/get_sex()
	return gender

//Tries to find the69ob's email.
/proc/find_email(real_name)
	for(var/mob/mob in GLOB.living_mob_list)
		if(mob.real_name == real_name)
			if(!mob.mind)
				return
			return69ob.mind.initial_email_login69"login"69

/proc/get_both_hands(mob/living/carbon/M)
	if(!istype(M))
		return
	var/list/hands = list(M.l_hand,69.r_hand)
	return hands

/mob/proc/drop_embedded()
	//Embedded list is defined at69ob level so we can have this here too
	for(var/obj/A in embedded)
		if (A.loc == src)
			A.forceMove(loc)
			if(isitem(A))
				var/obj/item/I = A
				I.on_embed_removal(src)
			A.tumble()
	embedded = list()

/mob/proc/skill_to_evade_traps()
	var/prob_evade = 0
	var/base_prob_evade = 30
	if(MOVING_DELIBERATELY(src))
		prob_evade += base_prob_evade
	if(!stats)
		return prob_evade
	prob_evade += base_prob_evade * (stats.getStat(STAT_VIG)/STAT_LEVEL_GODLIKE - weight_coeff())
	if(stats.getPerk(PERK_SURE_STEP))
		prob_evade += base_prob_evade*30/STAT_LEVEL_GODLIKE
	if(stats.getPerk(PERK_RAT))
		prob_evade += base_prob_evade/1.5
	return prob_evade

/mob/proc/mob_playsound(atom/source, soundin,69ol as69um,69ary, extrarange as69um, falloff, is_global, frequency, is_ambiance = 0,  ignore_walls = TRUE, zrange = 2, override_env, envdry, envwet, use_pressure = TRUE)
	if(isliving(src))
		var/mob/living/L = src
		vol *= L.noise_coeff + weight_coeff()
		extrarange *= L.noise_coeff + weight_coeff()
	playsound(source, soundin,69ol,69ary, extrarange, falloff, is_global, frequency, is_ambiance,  ignore_walls, zrange, override_env, envdry, envwet, use_pressure)

/mob/proc/weight_coeff()
	. = 0
	var/max_w_class = get_max_w_class()
	if(max_w_class > ITEM_SIZE_TINY)
		return69ax_w_class/(ITEM_SIZE_TITANIC)

/mob/proc/get_accumulated_vision_handlers()
	var/result69269
	var/asight = 0
	var/ainvis = 0
	for(var/atom/vision_handler in additional_vision_handlers)
		//Grab their flags
		asight |=69ision_handler.additional_sight_flags()
		ainvis =69ax(ainvis,69ision_handler.additional_see_invisible())
	result69169 = asight
	result69269 = ainvis

	return result
