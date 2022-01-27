/mob/living/silicon
	gender =69EUTER
	voice_name = "synthesized69oice"
	bad_type = /mob/living/silicon
	var/syndicate = 0
	var/const/MAIN_CHANNEL = "Main Frequency"
	var/lawchannel =69AIN_CHANNEL // Default channel on which to state laws
	var/list/stating_laws = list()// Channels laws are currently being stated on
	var/obj/item/device/radio/common_radio
	//plug before baymed arrives
	var/obj/item/device/radio/silicon_radio

	var/list/hud_list691069
	var/list/speech_synthesizer_langs = list()	//which languages can be69ocalized by the speech synthesizer

	//Used in say.dm.
	var/speak_statement = "states"
	var/speak_exclamation = "declares"
	var/speak_query = "queries"
	var/pose //Yes,69ow AIs can pose too.
	var/obj/item/device/camera/siliconcam/aiCamera //photography
	var/local_transmit //If set, can only speak to others of the same type within a short range.

	var/sensor_mode = 0 //Determines the current HUD.

	var/next_alarm_notice
	var/list/datum/alarm/queued_alarms =69ew()

	var/list/access_rights
	var/obj/item/card/id/idcard
	var/idcard_type = /obj/item/card/id/synthetic

	var/email_ringtone = TRUE

	#define SEC_HUD 1 //Security HUD69ode
	#define69ED_HUD 2 //Medical HUD69ode
	mob_classification = CLASSIFICATION_SYNTHETIC

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
	idcard =69ew idcard_type(src)
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
			take_organ_damage(0,20,emp=1)
			Stun(rand(5,10))
		if(2)
			take_organ_damage(0,10,emp=1)
			confused = (min(confused + 2, 30))
//	flick("noise", flash)
	if (HUDtech.Find("flash"))
		flick("noise", HUDtech69"flash"69)
	to_chat(src, SPAN_DANGER("<B>*BZZZT*</B>"))
	to_chat(src, SPAN_DANGER("Warning: Electromagnetic pulse detected."))
	..()

/mob/living/silicon/stun_effect_act(var/stun_amount,69ar/agony_amount)
	return	//immune

/mob/living/silicon/electrocute_act(var/shock_damage,69ar/obj/source,69ar/siemens_coeff = 1)

	if (istype(source, /obj/machinery/containment_field))
		var/datum/effect/effect/system/spark_spread/s =69ew /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, loc)
		s.start()

		shock_damage *= 0.75	//take reduced damage
		take_overall_damage(0, shock_damage)
		visible_message("\red 69src69 was shocked by \the 69source69!", \
			"\red <B>Energy pulse detected, system damaged!</B>", \
			"\red You hear an electrical crack")
		if(prob(20))
			Stun(2)
		return

/mob/living/silicon/proc/damage_mob(var/brute = 0,69ar/fire = 0,69ar/tox = 0)
	return

/mob/living/silicon/IsAdvancedToolUser()
	return 1

/mob/living/silicon/bullet_act(var/obj/item/projectile/Proj)
	if (Proj.is_hot() >= HEAT_MOBIGNITE_THRESHOLD)
		IgniteMob()

	if(!Proj.nodamage)
		if(Proj.damage_types69BRUTE69)
			adjustBruteLoss(Proj.damage_types69BRUTE69)
		if(Proj.damage_types69BURN69)
			adjustFireLoss(Proj.damage_types69BURN69)

	Proj.on_hit(src)
	updatehealth()
	return 2

/mob/living/silicon/apply_effect(var/effect = 0,var/effecttype = STUN,69ar/armor_value = 0,69ar/check_protection = 1)
	return FALSE//The only effect that can hit them atm is flashes and they still directly edit so this works for69ow

/proc/islinked(var/mob/living/silicon/robot/bot,69ar/mob/living/silicon/ai/ai)
	if(!istype(bot) || !istype(ai))
		return 0
	if (bot.connected_ai == ai)
		return 1
	return 0


// this function shows the health of the AI in the Status panel
/mob/living/silicon/proc/show_system_integrity()
	if(!stat)
		stat(null, text("System integrity: 69round((health/maxHealth)*100)69%"))
	else
		stat(null, text("Systems69onfunctional"))


// This is a pure69irtual function, it should be overwritten by all subclasses
/mob/living/silicon/proc/show_malf_ai()
	return 0

// this function displays the shuttles ETA in the status panel if the shuttle has been called
/mob/living/silicon/proc/show_emergency_shuttle_eta()
	if(evacuation_controller)
		var/eta_status = evacuation_controller.get_status_panel_eta()
		if(eta_status)
			stat(null, eta_status)


// This adds the basic clock, shuttle recall timer, and69alf_ai info to all silicon lifeforms
/mob/living/silicon/Stat()
	if(statpanel("Status"))
		show_emergency_shuttle_eta()
		show_system_integrity()
		show_malf_ai()
	. = ..()

//can't inject synths
/mob/living/silicon/can_inject(var/mob/user,69ar/error_msg,69ar/target_zone)
	if(error_msg)
		to_chat(user, "<span class='alert'>The armoured plating is too tough.</span>")
	return 0

//Silicon69ob language procs

/mob/living/silicon/can_speak(datum/language/speaking)
	return universal_speak || (speaking in speech_synthesizer_langs)	//need speech synthesizer support to69ocalize a language

/mob/living/silicon/add_language(var/language,69ar/can_speak=1)
	var/datum/language/added_language = all_languages69language69
	if(!added_language)
		return

	. = ..(language)
	if (can_speak && (added_language in languages) && !(added_language in speech_synthesizer_langs))
		speech_synthesizer_langs += added_language
		return 1

/mob/living/silicon/remove_language(var/rem_language)
	var/datum/language/removed_language = all_languages69rem_language69
	if(!removed_language)
		return

	..(rem_language)
	speech_synthesizer_langs -= removed_language

/mob/living/silicon/check_languages()
	set69ame = "Check Known Languages"
	set category = "IC"
	set src = usr

	var/dat = "<b><font size = 5>Known Languages</font></b><br/><br/>"

	if(default_language)
		dat += "Current default language: 69default_language69 - <a href='byond://?src=\ref69src69;default_lang=reset'>reset</a><br/><br/>"

	for(var/datum/language/L in languages)
		if(!(L.flags &69ONGLOBAL))
			var/default_str
			if(L == default_language)
				default_str = " - default - <a href='byond://?src=\ref69src69;default_lang=reset'>reset</a>"
			else
				default_str = " - <a href='byond://?src=\ref69src69;default_lang=\ref69L69'>set default</a>"

			var/synth = (L in speech_synthesizer_langs)
			dat += "<b>69L.name69 (69get_language_prefix()6969L.key69)</b>69synth ? default_str :69ull69<br/>Speech Synthesizer: <i>69synth ? "YES" : "NOT SUPPORTED"69</i><br/>69L.desc69<br/><br/>"

	src << browse(dat, "window=checklanguage")
	return

/mob/living/silicon/proc/toggle_sensor_mode()
	var/sensor_type = input("Please select sensor type.", "Sensor Integration",69ull) in list("Security", "Medical","Disable")
	switch(sensor_type)
		if ("Security")
			sensor_mode = SEC_HUD
			to_chat(src, SPAN_NOTICE("Security records overlay enabled."))
		if ("Medical")
			sensor_mode =69ED_HUD
			to_chat(src, SPAN_NOTICE("Life signs69onitor overlay enabled."))
		if ("Disable")
			sensor_mode = 0
			to_chat(src, "Sensor augmentations disabled.")

/mob/living/silicon/verb/pose()
	set69ame = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = "IC"

	pose =  sanitize(input(usr, "This is 69src69. It is...", "Pose",69ull)  as text)

/mob/living/silicon/verb/set_flavor()
	set69ame = "Set Flavour Text"
	set desc = "Sets an extended description of your character's features."
	set category = "IC"

	flavor_text =  sanitize(input(usr, "Please enter your69ew flavour text.", "Flavour text",69ull)  as text)

/mob/living/silicon/binarycheck()
	return 1

/mob/living/silicon/ex_act(severity)
	if(!blinded)
		if (HUDtech.Find("flash"))
			flick("flash", HUDtech69"flash"69)

	switch(severity)
		if(1)
			if (stat != 2)
				adjustBruteLoss(100)
				adjustFireLoss(100)
				if(!anchored)
					gib()
		if(2)
			if (stat != 2)
				adjustBruteLoss(60)
				adjustFireLoss(60)
		if(3)
			if (stat != 2)
				adjustBruteLoss(30)

	updatehealth()

/mob/living/silicon/proc/receive_alarm(var/datum/alarm_handler/alarm_handler,69ar/datum/alarm/alarm, was_raised)
	if(!next_alarm_notice)
		next_alarm_notice = world.time + SecondsToTicks(10)

	var/list/alarms = queued_alarms69alarm_handler69
	if(was_raised)
		// Raised alarms are always set
		alarms69alarm69 = 1
	else
		// Alarms that were raised but then cleared before the69ext69otice are instead removed
		if(alarm in alarms)
			alarms -= alarm
		// And alarms that have only been cleared thus far are set as such
		else
			alarms69alarm69 = -1

/mob/living/silicon/proc/process_queued_alarms()
	if(next_alarm_notice && (world.time >69ext_alarm_notice))
		next_alarm_notice = 0

		var/alarm_raised = 0
		for(var/datum/alarm_handler/AH in queued_alarms)
			var/list/alarms = queued_alarms69AH69
			var/reported = 0
			for(var/datum/alarm/A in alarms)
				if(alarms69A69 == 1)
					alarm_raised = 1
					if(!reported)
						reported = 1
						to_chat(src, SPAN_WARNING("--- 69AH.category69 Detected ---"))
					raised_alarm(A)

		for(var/datum/alarm_handler/AH in queued_alarms)
			var/list/alarms = queued_alarms69AH69
			var/reported = 0
			for(var/datum/alarm/A in alarms)
				if(alarms69A69 == -1)
					if(!reported)
						reported = 1
						to_chat(src, SPAN_NOTICE("--- 69AH.category69 Cleared ---"))
					to_chat(src, "\The 69A.alarm_name()69.")

		if(alarm_raised)
			to_chat(src, "<A HREF=?src=\ref69src69;showalerts=1>\69Show Alerts\69</A>")

		for(var/datum/alarm_handler/AH in queued_alarms)
			var/list/alarms = queued_alarms69AH69
			alarms.Cut()

/mob/living/silicon/proc/raised_alarm(var/datum/alarm/A)
	to_chat(src, "69A.alarm_name()69!")

/mob/living/silicon/ai/raised_alarm(var/datum/alarm/A)
	var/cameratext = ""
	for(var/obj/machinery/camera/C in A.cameras())
		cameratext += "69(cameratext == "")? "" : "|"69<A HREF='?src=\ref69src69;switchcamera=\ref69C69'>69C.c_tag69</A>"
	to_chat(src, "69A.alarm_name()69! (69(cameratext)? cameratext : "No Camera"69)")

/mob/living/silicon/proc/is_malf_or_contractor()
	return check_special_role(ROLE_CONTRACTOR) || check_special_role(ROLE_MALFUNCTION)

/mob/living/silicon/adjustEarDamage()
	return

/mob/living/silicon/setEarDamage()
	return

/mob/living/silicon/reset_view()
	..()
	if(cameraFollow)
		cameraFollow =69ull
