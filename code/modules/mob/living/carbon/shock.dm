#define SOFTCRIT_TRAUMATIC_SHOCK	50
#define HARDCRIT_TRAUMATIC_SHOCK	100
#define SHOCK_STAGE_BUFFER			50

/mob/living/var/traumatic_shock = 0
/mob/living/carbon/var/shock_stage = 0

// proc to find out in how much pain the mob is at the moment
/mob/living/carbon/proc/updateshock()
	if(species && (species.flags & NO_PAIN))
		traumatic_shock = 0
		return 0

	traumatic_shock = get_constant_pain() + get_dynamic_pain() - get_painkiller()

	if(slurring)
		traumatic_shock -= 10

	if(traumatic_shock < 0)
		traumatic_shock = 0

	return traumatic_shock

/mob/living/carbon/var/last_tick_pain

/mob/living/carbon/proc/get_constant_pain()
	var/hard_crit_threshold = HARDCRIT_TRAUMATIC_SHOCK + min(stats.getStat(STAT_TGH), 100)
	if(stats.getPerk(PERK_BALLS_OF_PLASTEEL))
		hard_crit_threshold += 20

	. = 						\
	1	* getOxyLoss() + 		\
	0.5	* getToxLoss() + 		\
	1	* getFireLoss() + 		\
	1	* getBruteLoss() + 		\
	1.5	* getCloneLoss()


	//Constant Pain above 80% of the crit treshold gets converted to dynamic pain (hallos)
	//Damage from the last tick gets saved as last_tick_pain and compared to current pain, if the current pain is larger hallos gets applied again
	if(. > 0.8 * hard_crit_threshold)
		if(. > last_tick_pain)
			adjustHalLoss((. - last_tick_pain) * 0.75)	// 0.75 * 1.33 modifier from hallos to dynamic pain convesion is roughly 1
		last_tick_pain = .
		. = 0.8 * hard_crit_threshold
		return

	last_tick_pain = .

/mob/living/carbon/proc/get_dynamic_pain()
	. = 1.33 * halloss

/mob/living/carbon/proc/get_painkiller()
	. = analgesic

// broken or ripped off organs will add quite a bit of pain
/mob/living/carbon/human/updateshock()
	..()
	for(var/obj/item/organ/external/organ in organs)
		if(organ && (organ.is_broken() || organ.open))
			traumatic_shock += 30

	return traumatic_shock

/mob/living/carbon/proc/handle_shock()
	updateshock()

/mob/living/carbon/human/handle_shock()
	..()
	if(status_flags & GODMODE)	//godmode
		return 0
	if(species && species.flags & NO_PAIN)
		return
	if(status_flags & HARDCRIT)	//already in hardcrit
		return

	//Get crit treshold
	var/soft_crit_threshold = SOFTCRIT_TRAUMATIC_SHOCK + min(stats.getStat(STAT_TGH), 100)
	var/hard_crit_threshold = HARDCRIT_TRAUMATIC_SHOCK + min(stats.getStat(STAT_TGH), 100)
	if(stats.getPerk(PERK_BALLS_OF_PLASTEEL))
		soft_crit_threshold += 20
		hard_crit_threshold += 20

	//Get shock speed
	var/shock_stage_speed = 1
	if(traumatic_shock > hard_crit_threshold + SHOCK_STAGE_BUFFER)
		shock_stage_speed = 3

	else if(traumatic_shock > soft_crit_threshold + SHOCK_STAGE_BUFFER)
		shock_stage_speed = 2

	//Handle shock
	if(shock_stage <= traumatic_shock)	//Shock stage slowly climbs to traumatic shock
		shock_stage = min(shock_stage + shock_stage_speed, traumatic_shock)

		if(shock_stage < traumatic_shock * 0.4)	//If the difference is too big shock stage jumps to half of traumatic shock
			shock_stage = min(traumatic_shock / 0.4, 160)

	else
		shock_stage = min(shock_stage, 160)
		shock_stage = max(shock_stage - shock_stage_speed, 0)
		return

	if(shock_resist || soft_crit_threshold > traumatic_shock)
		shock_stage = min(shock_stage, 58)

	sanity.onShock(shock_stage)

	if(shock_stage == 12)
		to_chat(src, SPAN_DANGER("[pick("It hurts so much", "You really need some painkillers", "Dear god, the pain")]!"))

	if(shock_stage >= 30)
		if(shock_stage == 30) emote("me",1,"is having trouble keeping their eyes open.")
		stuttering = max(stuttering, 5)

	if(shock_stage == 42)
		to_chat(src, SPAN_DANGER("[pick("The pain is excruciating", "Please, just end the pain", "Your whole body is going numb")]!"))

	if (shock_stage >= 60)
		if(shock_stage == 60) emote("me",1,"'s body becomes limp.")
		if (prob(2))
			to_chat(src, SPAN_DANGER("[pick("The pain is excruciating", "Please, just end the pain", "Your whole body is going numb")]!"))
			Weaken(10)

	if(shock_stage >= 80)
		if (prob(5))
			to_chat(src, SPAN_DANGER("[pick("The pain is excruciating", "Please, just end the pain", "Your whole body is going numb")]!"))
			Weaken(10)

	if(shock_stage >= hard_crit_threshold)
		enter_hard_crit()

/mob/living/carbon/human/proc/enter_hard_crit()
	var/knockout_time = rand(3 MINUTES, 4 MINUTES)
	message_admins(knockout_time)
	to_chat(src, SPAN_DANGER("[pick("You are knocked out", "You can't feel anything anymore", "You just can't keep going anymore")]!"))
	Weaken(knockout_time)
	Paralyse(knockout_time)
	status_flags |= HARDCRIT

	addtimer(CALLBACK(src, .proc/exit_hard_crit), knockout_time)

/mob/living/carbon/human/proc/exit_hard_crit()
	if(status_flags & HARDCRIT)
		setHalLoss(0)
		SetWeakened(0)
		SetParalysis(0)
		shock_stage = 0
		status_flags &= ~HARDCRIT

#undef SOFTCRIT_TRAUMATIC_SHOCK
#undef HARDCRIT_TRAUMATIC_SHOCK
#undef SHOCK_STAGE_BUFFER