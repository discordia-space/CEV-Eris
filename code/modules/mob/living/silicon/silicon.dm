/mob/living/silicon
	gender = NEUTER
	voice_name = "synthesized voice"
	bad_type = /mob/living/silicon
	tts_seed = "Robot_1"
	var/syndicate = 0
	var/const/MAIN_CHANNEL = "Main Frequency"
	/// Default channel on which to state laws
	var/lawchannel = MAIN_CHANNEL
	/// Channels laws are currently being stated on
	var/list/stating_laws = list()
	var/obj/item/device/radio/common_radio
	//plug before baymed arrives
	var/obj/item/device/radio/silicon_radio

	var/list/hud_list[10]
	/// which languages can be vocalized by the speech synthesizer
	var/list/speech_synthesizer_langs = list()

	var/last_lawchange_announce = 0
	//Used in say.dm.
	var/speak_statement = "states"
	var/speak_exclamation = "declares"
	var/speak_query = "queries"
	var/pose //Yes, now AIs can pose too.
	var/obj/item/device/camera/siliconcam/aiCamera //photography
	/// If set, can only speak to others of the same type within a short range.
	var/local_transmit

	var/sensor_mode = 0 //Determines the current HUD.

	var/next_alarm_notice
	var/list/datum/alarm/queued_alarms = new()

	var/list/access_rights
	var/obj/item/card/id/idcard
	var/idcard_type = /obj/item/card/id/synthetic

	var/email_ringtone = TRUE

	#define SEC_HUD 1 //Security HUD mode
	#define MED_HUD 2 //Medical HUD mode
	mob_classification = CLASSIFICATION_SYNTHETIC

	injury_type = INJURY_TYPE_UNLIVING // Has no soft vitals, but also contains delicate electronics

/mob/living/silicon/Initialize()
	GLOB.silicon_mob_list |= src
	. = ..()
	add_language(LANGUAGE_COMMON)
	init_id()
	init_subsystems()

/mob/living/silicon/Destroy()
	GLOB.silicon_mob_list -= src
	for(var/datum/alarm_handler/AH in SSalarm.all_handlers)
		AH.unregister_alarm(src)
	. = ..()

/mob/living/silicon/lay_down()
	resting = FALSE
	update_lying_buckled_and_verb_status()

/mob/living/silicon/proc/init_id()
	if(idcard)
		return
	idcard = new idcard_type(src)
	set_id_info(idcard)

/mob/living/silicon/SetName(pickedName as text)
	real_name = pickedName
	name = real_name
	create_or_rename_email(pickedName, "root.rt")

/mob/living/silicon/proc/show_laws()
	return

/mob/living/silicon/drop_item()
	if(isrobot(src))
		var/mob/living/silicon/robot/R = src
		R.update_robot_modules_display()
	return

/mob/living/silicon/emp_act(severity)
	switch(severity)
		if(1)
			take_organ_damage(0,20,emp=TRUE)
			Stun(rand(5,10))
		if(2)
			take_organ_damage(0,10,emp=TRUE)
			confused = (min(confused + 2, 30))
//	flick("noise", flash)
	flash(0, FALSE , FALSE , FALSE)
	to_chat(src, span_danger("<B>*BZZZT*</B>"))
	to_chat(src, span_danger("Warning: Electromagnetic pulse detected."))
	..()

/mob/living/silicon/stun_effect_act(stun_amount, agony_amount)
	return	//immune

/mob/living/silicon/electrocute_act(shock_damage, obj/source, siemens_coeff = 1)

	if (istype(source, /obj/machinery/containment_field))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, loc)
		s.start()

		shock_damage *= 0.75	//take reduced damage
		take_overall_damage(0, shock_damage)
		visible_message(span_red("[src] was shocked by \the [source]!"), \
			span_red("<B>Energy pulse detected, system damaged!</B>"), \
			span_red("You hear an electrical crack"))
		if(prob(20))
			Stun(2)
		return

/mob/living/silicon/proc/damage_mob(brute = 0, fire = 0, tox = 0)
	return

/mob/living/silicon/IsAdvancedToolUser()
	return 1

/mob/living/silicon/bullet_act(obj/item/projectile/Proj)
	if (Proj.is_hot() >= HEAT_MOBIGNITE_THRESHOLD)
		IgniteMob()

	if(!Proj.nodamage)
		if(Proj.damage_types[BRUTE])
			adjustBruteLoss(Proj.damage_types[BRUTE])
		if(Proj.damage_types[BURN])
			adjustFireLoss(Proj.damage_types[BURN])

	Proj.on_hit(src)
	updatehealth()
	return 2

/mob/living/silicon/apply_effect(effect = 0,effecttype = STUN, armor_value = 0, check_protection = 1)
	return FALSE//The only effect that can hit them atm is flashes and they still directly edit so this works for now

/proc/islinked(mob/living/silicon/robot/bot, mob/living/silicon/ai/ai)
	if(!istype(bot) || !istype(ai))
		return FALSE
	if(bot.connected_ai == ai)
		return TRUE
	return FALSE

/mob/living/silicon/get_status_tab_items()
	. = ..()
	if(!stat)
		. += list(list("System integrity: [round((health/maxHealth)*100)]%"))
	else
		. += list(list("Systems nonfunctional"))

//can't inject synths
/mob/living/silicon/can_inject(mob/user, error_msg, target_zone)
	if(error_msg)
		to_chat(user, span_alert("The armoured plating is too tough."))
	return 0

//Silicon mob language procs

/mob/living/silicon/can_speak(datum/language/speaking)
	return universal_speak || (speaking in speech_synthesizer_langs)	//need speech synthesizer support to vocalize a language

/mob/living/silicon/add_language(language, can_speak=1)
	var/datum/language/added_language = GLOB.all_languages[language]
	if(!added_language)
		return

	. = ..(language)
	if (can_speak && (added_language in languages) && !(added_language in speech_synthesizer_langs))
		speech_synthesizer_langs += added_language
		return 1

/mob/living/silicon/remove_language(rem_language)
	var/datum/language/removed_language = GLOB.all_languages[rem_language]
	if(!removed_language)
		return

	..(rem_language)
	speech_synthesizer_langs -= removed_language

/mob/living/silicon/proc/toggle_sensor_mode()
	var/sensor_type = input("Please select sensor type.", "Sensor Integration", null) in list("Security", "Medical","Disable")
	switch(sensor_type)
		if ("Security")
			sensor_mode = SEC_HUD
			to_chat(src, span_notice("Security records overlay enabled."))
		if ("Medical")
			sensor_mode = MED_HUD
			to_chat(src, span_notice("Life signs monitor overlay enabled."))
		if ("Disable")
			sensor_mode = 0
			to_chat(src, "Sensor augmentations disabled.")

/mob/living/silicon/verb/pose()
	set name = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = "IC"

	pose =  sanitize(input(usr, "This is [src]. It is...", "Pose", null)  as text)

/mob/living/silicon/verb/set_flavor()
	set name = "Set Flavour Text"
	set desc = "Sets an extended description of your character's features."
	set category = "IC"

	flavor_text =  sanitize(input(usr, "Please enter your new flavour text.", "Flavour text", null)  as text)

/mob/living/silicon/binarycheck()
	return 1

/mob/living/silicon/explosion_act(target_power, explosion_handler/handler)
	adjustBruteLoss(target_power/2)
	adjustFireLoss(target_power/2)
	updatehealth()
	return 0

/mob/living/silicon/proc/receive_alarm(datum/alarm_handler/alarm_handler, datum/alarm/alarm, was_raised)
	if(!next_alarm_notice)
		next_alarm_notice = world.time + SecondsToTicks(10)

	var/list/alarms = queued_alarms[alarm_handler]
	if(was_raised)
		// Raised alarms are always set
		alarms[alarm] = 1
	else
		// Alarms that were raised but then cleared before the next notice are instead removed
		if(alarm in alarms)
			alarms -= alarm
		// And alarms that have only been cleared thus far are set as such
		else
			alarms[alarm] = -1

/mob/living/silicon/proc/process_queued_alarms()
	if(next_alarm_notice && (world.time > next_alarm_notice))
		next_alarm_notice = 0

		var/alarm_raised = 0
		for(var/datum/alarm_handler/AH in queued_alarms)
			var/list/alarms = queued_alarms[AH]
			var/reported = 0
			for(var/datum/alarm/A in alarms)
				if(alarms[A] == 1)
					alarm_raised = 1
					if(!reported)
						reported = 1
						to_chat(src, span_warning("--- [AH.category] Detected ---"))
					raised_alarm(A)

		for(var/datum/alarm_handler/AH in queued_alarms)
			var/list/alarms = queued_alarms[AH]
			var/reported = 0
			for(var/datum/alarm/A in alarms)
				if(alarms[A] == -1)
					if(!reported)
						reported = 1
						to_chat(src, span_notice("--- [AH.category] Cleared ---"))
					to_chat(src, "\The [A.alarm_name()].")

		if(alarm_raised)
			to_chat(src, "<A href='byond://?src=\ref[src];showalerts=1'>\[Show Alerts\]</A>")

		for(var/datum/alarm_handler/AH in queued_alarms)
			var/list/alarms = queued_alarms[AH]
			alarms.Cut()

/mob/living/silicon/proc/raised_alarm(datum/alarm/A)
	to_chat(src, "[A.alarm_name()]!")

/mob/living/silicon/ai/raised_alarm(datum/alarm/A)
	var/cameratext = ""
	for(var/obj/machinery/camera/C in A.cameras())
		cameratext += "[(cameratext == "")? "" : "|"]<A href='byond://?src=\ref[src];switchcamera=\ref[C]'>[C.c_tag]</A>"
	to_chat(src, "[A.alarm_name()]! ([(cameratext)? cameratext : "No Camera"])")

/mob/living/silicon/proc/is_malf_or_contractor()
	return check_special_role(ROLE_CONTRACTOR) || check_special_role(ROLE_MALFUNCTION)

/mob/living/silicon/adjustEarDamage()
	return

/mob/living/silicon/setEarDamage()
	return

/mob/living/silicon/reset_view()
	..()
	if(cameraFollow)
		cameraFollow = null
