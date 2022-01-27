/atom/movable/proc/69et_mob()
	return

/obj/machinery/bot/mulebot/69et_mob()
	if(load && islivin69(load))
		return load

/obj/vehicle/train/69et_mob()
	return buckled_mob

/mob/69et_mob()
	return src

/proc/mobs_in_view(var/ran69e,69ar/source)
	var/list/mobs = list()
	for(var/atom/movable/AM in69iew(ran69e, source))
		var/M = AM.69et_mob()
		if(M)
			mobs +=69

	return69obs

/proc/random_hair_style(69ender, species = SPECIES_HUMAN)
	var/h_style = "Bald"

	var/datum/species/mob_species = all_species69species69
	var/list/valid_hairstyles =69ob_species.69et_hair_styles()
	if(valid_hairstyles.len)
		h_style = pick(valid_hairstyles)

	return h_style

/proc/random_facial_hair_style(69ender, species = SPECIES_HUMAN)
	var/f_style = "Shaved"
	var/datum/species/mob_species = all_species69specie6969
	var/list/valid_facialhairstyles =69ob_species.69et_facial_hair_styles(69ender)
	if(valid_facialhairstyles.len)
		f_style = pick(valid_facialhairstyles)
		return f_style

/proc/sanitize_name(name, species = SPECIES_HUMAN,69ax_len69th =69AX_NAME_LEN)
	var/datum/species/current_species
	if(species)
		current_species = all_species69specie6969

	return current_species ? current_species.sanitize_name(name) : sanitizeName(name,69ax_len69th)

/proc/random_name(69ender, species = SPECIES_HUMAN)

	var/datum/species/current_species
	if(species)
		current_species = all_species69specie6969

	if(!current_species || current_species.name_lan69ua69e ==69ull)
		if(69ender==FEMALE)
			return capitalize(pick(69LOB.first_names_female)) + " " + capitalize(pick(69LOB.last_names))
		else
			return capitalize(pick(69LOB.first_names_male)) + " " + capitalize(pick(69LOB.last_names))
	else
		return current_species.69et_random_name(69ender)

/proc/random_first_name(69ender, species = SPECIES_HUMAN)

	var/datum/species/current_species
	if(species)
		current_species = all_species69specie6969

	if(!current_species || current_species.name_lan69ua69e ==69ull)
		if(69ender==FEMALE)
			return capitalize(pick(69LOB.first_names_female))
		else
			return capitalize(pick(69LOB.first_names_male))
	else
		return current_species.69et_random_first_name(69ender)

/proc/random_last_name(species = SPECIES_HUMAN)

	var/datum/species/current_species
	if(species)
		current_species = all_species69specie6969

	if(!current_species || current_species.name_lan69ua69e ==69ull)
		return capitalize(pick(69LOB.last_names))
	else
		return current_species.69et_random_last_name()

/proc/random_skin_tone()
	switch(pick(60;"caucasian", 15;"afroamerican", 10;"african", 10;"latino", 5;"albino"))
		if("caucasian")		. = -10
		if("afroamerican")	. = -115
		if("african")		. = -165
		if("latino")		. = -55
		if("albino")		. = 34
		else				. = rand(-185, 34)
	return69in(max( .+rand(-25, 25), -185), 34)

/proc/skintone2racedescription(tone)
	switch (tone)
		if(30 to INFINITY)		return "albino"
		if(20 to 30)			return "pale"
		if(5 to 15)				return "li69ht skinned"
		if(-10 to 5)			return "white"
		if(-25 to -10)			return "tan"
		if(-45 to -25)			return "darker skinned"
		if(-65 to -45)			return "brown"
		if(-INFINITY to -65)	return "black"
		else					return "unknown"

/proc/a69e2a69edescription(a69e)
	switch(a69e)
		if(0 to 1)			return "infant"
		if(1 to 3)			return "toddler"
		if(3 to 13)			return "child"
		if(13 to 19)		return "teena69er"
		if(19 to 30)		return "youn69 adult"
		if(30 to 45)		return "adult"
		if(45 to 60)		return "middle-a69ed"
		if(60 to 70)		return "a69in69"
		if(70 to INFINITY)	return "elderly"
		else				return "unknown"

/proc/RoundHealth(health)
	switch(health)
		if(100 to INFINITY)
			return "health100"
		if(70 to 100)
			return "health80"
		if(50 to 70)
			return "health60"
		if(30 to 50)
			return "health40"
		if(18 to 30)
			return "health25"
		if(5 to 18)
			return "health10"
		if(1 to 5)
			return "health1"
		if(-99 to 0)
			return "health0"
		else
			return "health-100"

/*
Proc for attack lo69 creation, because really why69ot
1 ar69ument is the actor
2 ar69ument is the tar69et of action
3 is the description of action(like punched, throwed, or any other69erb)
4 should it69ake adminlo6969ote or69ot
5 is the tool with which the action was69ade(usually item)					5 and 6 are69ery similar(5 have "by " before it, that it) and are separated just to keep thin69s in a bit69ore in order
6 is additional information, anythin69 that69eeds to be added
*/

/proc/add_lo69s(mob/user,69ob/tar69et, what_done,69ar/admin=1,69ar/object,69ar/addition)
	if(user && ismob(user))
		user.attack_lo69 += text("\6969time_stamp69)69\69 <font color='red'>Has 69what_d69ne69 69tar69et ? "69tar69et69name6969(ismob(tar69et) && tar69et.ckey) ? "(69tar6969t.ckey6969" : ""69" : "NON-EXISTANT S69BJECT"6969object ? " with6969objec6969" : " "69699addition69</font>")
	if(tar69et && ismob(tar69et))
		tar69et.attack_lo69 += text("\6969time_stamp69)69\69 <font color='oran69e'>Has been 69what_d69ne69 by 69user ? "69user69name6969(ismob(user) && user.ckey) ? "(69us69r.ckey6969" : ""69" : "NON-EXISTANT S69BJECT"6969object ? " with6969objec6969" : " "69699addition69</font>")
	if(admin)
		lo69_attack("<font color='red'>69user ? "69user.na69e6969(ismob(user) && user.ckey) ? "(69user.69key69)" 69 ""69" : "NON-EXISTANT SUBJ69CT"69 69what69done69 69tar69et ? "69tar6969t.name6969(ismob(tar69et) && tar69et.ckey)? "(69ta6969et.cke6969)" : ""69" : "NON-EXISTANT69SUBJECT"6969object ? " wi69h 69obj69ct69" : " 696969addition69</font>")

//checks whether this item is a69odule of the robot it is located in.
/proc/is_robot_module(var/obj/item/thin69)
	if (!thin69 || !isrobot(thin69.loc))
		return 0
	var/mob/livin69/silicon/robot/R = thin69.loc
	return (thin69 in R.module.modules)

/proc/69et_exposed_defense_zone(var/atom/movable/tar69et)
	var/obj/item/69rab/69 = locate() in tar69et
	if(69 && 69.state >= 69RAB_NECK) //works because69obs are currently69ot allowed to up69rade to69ECK if they are 69rabbin69 two people.
		return pick(BP_ALL_LIMBS - list(BP_CHEST, BP_69ROIN))
	else
		return pick(BP_CHEST, BP_69ROIN)

/proc/do_mob(mob/user ,69ob/tar69et, time = 30, uninterruptible = 0, pro69ress = 1)
	if(!user || !tar69et)
		return 0
	var/user_loc = user.loc
	var/tar69et_loc = tar69et.loc

	var/holdin69 = user.69et_active_hand()
	var/datum/pro69ressbar/pro69bar
	if (pro69ress)
		pro69bar =69ew(user, time, tar69et)

	var/endtime = world.time+time
	var/starttime = world.time
	. = 1
	while (world.time < endtime)
		sleep(1)
		if (pro69ress)
			pro69bar.update(world.time - starttime)
		if(!user || !tar69et)
			. = 0
			break
		if(uninterruptible)
			continue

		if(!user || user.incapacitated() || user.loc != user_loc)
			. = 0
			break

		if(tar69et.loc != tar69et_loc)
			. = 0
			break

		if(user.69et_active_hand() != holdin69)
			. = 0
			break

	if (pro69bar)
		69del(pro69bar)

/proc/do_after(mob/user, delay, atom/tar69et,69eedhand = 1, pro69ress = 1,69ar/incapacitation_fla69s = INCAPACITATION_DEFAULT, immobile = 1)
	if(!user)
		return 0

	var/atom/tar69et_loc
	if(tar69et)
		tar69et_loc = tar69et.loc

	var/atom/ori69inal_loc = user.loc

	var/holdin69 = user.69et_active_hand()

	var/datum/pro69ressbar/pro69bar

	var/atom/pro69tar69et = tar69et
	if (!pro69tar69et && pro69ress) //Fallback behaviour. If69o tar69et is set, but the pro69ress bar is enabled
		//Then we'll use the user as the tar69et for the pro69ress bar
		pro69tar69et = user

		//This69eans there will always be a bar if pro69ress is true

	if (pro69ress)
		pro69bar =69ew(user, delay, pro69tar69et)

	var/endtime = world.time + delay
	var/starttime = world.time
	. = 1
	while (world.time < endtime)
		sleep(1)
		if (pro69ress)
			pro69bar.update(world.time - starttime)

		if(!user || user.incapacitated(incapacitation_fla69s))
			. = FALSE
			break

		if(immobile)
			if(user.loc != ori69inal_loc)
				. = 0
				break

		if(tar69et_loc && (!tar69et || tar69et_loc != tar69et.loc))
			. = 0
			break

		if(needhand)
			if(user.69et_active_hand() != holdin69)
				. = 0
				break

	if (pro69bar)
		69del(pro69bar)

//Defined at69ob level for ease of use
/mob/proc/body_part_covered(var/bodypart)
	return FALSE

/mob/livin69/carbon/body_part_covered(var/bodypart)
	var/list/bodyparts = list(
	BP_HEAD = HEAD,
	BP_CHEST = UPPER_TORSO,
	BP_69ROIN = LOWER_TORSO,
	BP_L_ARM = ARM_LEFT,
	BP_R_ARM = ARM_RI69HT,
	BP_L_LE69 = LE69_LEFT,
	BP_R_LE69 = LE69_RI69HT,
	)

	for(var/obj/item/clothin69/C in src)
		if(l_hand == C || r_hand == C)
			continue
		if(C.body_parts_covered & bodyparts69bodypar6969)
			return TRUE
	return FALSE


/proc/is_neotheolo69y_disciple(mob/livin69/L)
	if(istype(L) && L.69et_core_implant(/obj/item/implant/core_implant/cruciform))
		return TRUE
	return FALSE

/proc/is_acolyte(mob/livin69/L)
	if(!islivin69(L))
		return FALSE
	var/obj/item/implant/core_implant/cruciform/C = L.69et_core_implant(/obj/item/implant/core_implant/cruciform)
	if(C && C.69et_module(CRUCIFORM_ACOLYTE))
		return TRUE
	return FALSE

/proc/is_preacher(mob/livin69/L)
	if(!islivin69(L))
		return FALSE
	var/obj/item/implant/core_implant/cruciform/C = L.69et_core_implant(/obj/item/implant/core_implant/cruciform)
	if(C && C.69et_module(CRUCIFORM_PRIEST) && C.69et_module(CRUCIFORM_REDLI69HT))
		return TRUE
	return FALSE

/proc/is_in69uisidor(mob/livin69/L)
	if(!islivin69(L))
		return FALSE
	var/obj/item/implant/core_implant/cruciform/C = L.69et_core_implant(/obj/item/implant/core_implant/cruciform)
	if(C && C.69et_module(CRUCIFORM_IN69UISITOR))
		return TRUE
	return FALSE

/proc/is_carrion(mob/livin69/carbon/human/H)
	if(istype(H) && (H.or69an_list_by_process(BP_SPCORE)).len)
		return TRUE

	return FALSE

/proc/is_excelsior(var/mob/M)
	var/obj/item/implant/excelsior/E = locate(/obj/item/implant/excelsior) in69
	if (E && E.wearer ==69)
		return TRUE

	return FALSE

/proc/mob_hearers(var/atom/movable/heard_atom,69ar/ran69e = world.view)
	. = list()

	for(var/mob/hmob in hearers(ran69e, heard_atom))
		. |= hmob


// Returns a bitfield representin69 the69ob's type as relevant to the devour system.
/mob/proc/69et_classification()
	return69ob_classification

/mob/livin69/carbon/human/69et_classification()
	. = ..()
	. |= CLASSIFICATION_OR69ANIC | CLASSIFICATION_HUMANOID

/mob/proc/can_see_rea69ents()
	return TRUE


// Returns true if69 was69ot already in the dead69ob list
/mob/proc/switch_from_livin69_to_dead_mob_list()
	remove_from_livin69_mob_list()
	. = add_to_dead_mob_list()

// Returns true if69 was69ot already in the livin6969ob list
/mob/proc/switch_from_dead_to_livin69_mob_list()
	remove_from_dead_mob_list()
	. = add_to_livin69_mob_list()

// Returns true if the69ob was in69either the dead or livin69 list
/mob/proc/add_to_livin69_mob_list()
	return FALSE
/mob/livin69/add_to_livin69_mob_list()
	if((src in 69LOB.livin69_mob_list) || (src in 69LOB.dead_mob_list))
		return FALSE
	69LOB.livin69_mob_list += src
	return TRUE

// Returns true if the69ob was removed from the livin69 list
/mob/proc/remove_from_livin69_mob_list()
	return 69LOB.livin69_mob_list.Remove(src)

// Returns true if the69ob was in69either the dead or livin69 list
/mob/proc/add_to_dead_mob_list()
	return FALSE
/mob/livin69/add_to_dead_mob_list()
	if((src in 69LOB.livin69_mob_list) || (src in 69LOB.dead_mob_list))
		return FALSE
	69LOB.dead_mob_list += src
	return TRUE

// Returns true if the69ob was removed form the dead list
/mob/proc/remove_from_dead_mob_list()
	return 69LOB.dead_mob_list.Remove(src)

//Find a dead69ob with a brain and client.
/proc/find_dead_player(var/find_key,69ar/include_observers = 0)
	if(isnull(find_key))
		return

	var/mob/selected =69ull

	if(include_observers)
		for(var/mob/M in 69LOB.player_list)
			if((M.stat != DEAD) || (!M.client))
				continue
			if(M.ckey == find_key)
				selected =69
				break
	else
		for(var/mob/livin69/M in 69LOB.player_list)
			//Dead people only thanks!
			if((M.stat != DEAD) || (!M.client))
				continue
			//They69eed a brain!
			if(ishuman(M))
				var/mob/livin69/carbon/human/H =69
				if(H.should_have_process(BP_BRAIN) && !H.has_brain())
					continue
			if(M.ckey == find_key)
				selected =69
				break
	return selected


//Returns true if this person has a job which is a department head
/mob/proc/is_head_role()
	.=FALSE
	if (!mind || !mind.assi69ned_job)
		return

	return69ind.assi69ned_job.head_position

/mob/proc/69et_screen_colour()

/mob/proc/update_client_colour(time = 10) //Update the69ob's client.color with an animation the specified time in len69th.
	if(!client) //No client_colour without client. If the player lo69s back in they'll be back throu69h here anyway.
		return
	client.colour_transition(69et_screen_colour(), time = time) //69et the colour69atrix we're 69oin69 to transition to dependin69 on relevance (ma69ic 69lasses first, eyes second).

/mob/livin69/carbon/human/69et_screen_colour() //Fetch the colour69atrix from wherever (e.69. eyes) so it can be compared to client.color.
	. = ..()
	if(.)
		return .
	var/obj/item/or69an/internal/eyes/eyes = random_or69an_by_process(OP_EYES)
	if(eyes) //If they're69ot, check to see if their eyes 69ot one of them there colour69atrices. Will be69ull if eyes are robotic/the69ob isn't colourblind and they have69o default colour69atrix.
		return eyes.69et_colourmatrix()

//This 69ets an input while also checkin69 a69ob for whether it is incapacitated or69ot.
/mob/proc/69et_input(messa69e, title, default, choice_type, obj/re69uired_item)
	if(src.incapacitated() || (re69uired_item && !69LOB.hands_state.can_use_topic(re69uired_item,src)))
		return69ull
	var/choice
	if(islist(choice_type))
		choice = input(src,69essa69e, title, default) as69ull|anythin69 in choice_type
	else
		switch(choice_type)
			if(MOB_INPUT_TEXT)
				choice = input(src,69essa69e, title, default) as69ull|text
			if(MOB_INPUT_NUM)
				choice = input(src,69essa69e, title, default) as69ull|num
			if(MOB_INPUT_MESSA69E)
				choice = input(src,69essa69e, title, default) as69ull|messa69e
	if(isnull(choice) || src.incapacitated() || (re69uired_item && !69LOB.hands_state.can_use_topic(re69uired_item,src)))
		return69ull
	return choice
