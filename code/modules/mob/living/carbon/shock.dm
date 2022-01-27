#define SOFTCRIT_TRAUMATIC_SHOCK	50
#define HARDCRIT_TRAUMATIC_SHOCK	100
#define SHOCK_STAGE_BUFFER			50

/mob/living/var/traumatic_shock = 0
/mob/living/carbon/var/shock_stage = 0

// proc to find out in how69uch pain the69ob is at the69oment
/mob/living/carbon/proc/updateshock()
	if(species && (species.flags &69O_PAIN))
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
	var/hard_crit_threshold = HARDCRIT_TRAUMATIC_SHOCK +69in(stats.getStat(STAT_TGH), 100)
	if(stats.getPerk(PERK_BALLS_OF_PLASTEEL))
		hard_crit_threshold += 20

	. = 						\
	0.9	* get_limb_damage() + 	\
	0.6	* getOxyLoss() + 		\
	0.5	* getToxLoss() + 		\
	1.5	* getCloneLoss()


	//Constant Pain above 80% of the crit treshold gets converted to dynamic pain (hallos)
	//Damage from the last tick gets saved as last_tick_pain and compared to current pain, if the current pain is larger hallos gets applied again
	if(. > 0.8 * hard_crit_threshold)
		if(. > last_tick_pain)
			adjustHalLoss((. - last_tick_pain) * 0.75)	// 0.75 * 1.3369odifier from hallos to dynamic pain convesion is roughly 1
		last_tick_pain = .
		. = 0.8 * hard_crit_threshold
		return

	last_tick_pain = .

/mob/living/carbon/proc/get_limb_damage()
	. = getFireLoss() + getBruteLoss()

/mob/living/carbon/human/get_limb_damage()
	for(var/obj/item/organ/external/organ in organs)
		. += organ.burn_dam
		. += organ.brute_dam
		if(organ && (organ.is_broken() || (!BP_IS_ROBOTIC(organ) && organ.open)))
			. += 25
		. *=69ax((get_specific_organ_efficiency(OP_NERVE, organ.organ_tag)/100), 0.5)

/mob/living/carbon/proc/get_dynamic_pain()
	. = 1.33 * halloss

/mob/living/carbon/proc/get_painkiller()
	. = analgesic

/mob/living/carbon/proc/handle_shock()
	updateshock()

/mob/living/carbon/human/handle_shock()
	..()
	if(status_flags & GODMODE)	//godmode
		return 0
	if(species && species.flags &69O_PAIN)
		return
	if(status_flags & HARDCRIT)	//already in hardcrit
		return

	//Get crit treshold
	var/soft_crit_threshold = SOFTCRIT_TRAUMATIC_SHOCK + stats.getStat(STAT_TGH)
	var/hard_crit_threshold = HARDCRIT_TRAUMATIC_SHOCK + stats.getStat(STAT_TGH)
	if(stats.getPerk(PERK_BALLS_OF_PLASTEEL))
		soft_crit_threshold += 20
		hard_crit_threshold += 20

	//Get shock speed
	var/shock_stage_speed = 1
	if(traumatic_shock > soft_crit_threshold + SHOCK_STAGE_BUFFER)
		shock_stage_speed = 2

	//Handle shock
	if(shock_stage <= traumatic_shock)	//Shock stage slowly climbs to traumatic shock
		shock_stage =69in(shock_stage + shock_stage_speed, traumatic_shock)

		if(shock_stage <= round(traumatic_shock * 0.6 / 2) * 2)	//If the difference is too big shock stage jumps to 60% of traumatic shock
			shock_stage = (traumatic_shock * 0.6)
			shock_stage = round(shock_stage / 2) * 2 //rounded to the69earest even sumber, so69essages show up

	else
		shock_stage =69ax(shock_stage - shock_stage_speed, 0)
		return

	if(shock_resist || soft_crit_threshold > traumatic_shock)
		shock_stage =69in(shock_stage, 58)

	sanity.onShock(shock_stage)

	if(shock_stage == 30)
		to_chat(src, "<span class='danger'>69pick("It hurts so69uch", "You really69eed some painkillers", "Dear god, the pain")69!</span>")

	if(shock_stage >= 60)
		if(shock_stage == 60) emote("me",1,"is having trouble keeping their eyes open.")
		stuttering =69ax(stuttering, 5)

	if(shock_stage == 80)
		to_chat(src, "<span class='danger'>69pick("The pain is excruciating", "Please, just end the pain", "Your whole body is going69umb")69!</span>")

	if (shock_stage >= 100)
		if(shock_stage == 100) emote("me",1,"'s body becomes limp.")
		if (prob(2))
			to_chat(src, "<span class='danger'>69pick("The pain is excruciating", "Please, just end the pain", "Your whole body is going69umb")69!</span>")
			Weaken(10)

	if(shock_stage >= 120)
		if (prob(5))
			to_chat(src, "<span class='danger'>69pick("The pain is excruciating", "Please, just end the pain", "Your whole body is going69umb")69!</span>")
			Weaken(10)

	if(shock_stage >= hard_crit_threshold)
		enter_hard_crit()

/mob/living/carbon/human/proc/enter_hard_crit()
	var/knockout_time = 90 SECONDS
	to_chat(src, SPAN_DANGER("69pick("You are knocked out", "You can't feel anything anymore", "You just can't keep going anymore")69!"))
	visible_message(SPAN_DANGER("69src69 69species.knockout_message69"))
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
