/datum/codespeak_list
	var/list/codes = list()
	var/codetype

/datum/codespeak_list/proc/get_cop_code()
	if(codetype == "IH")
		var/cop_code_1 = pick("10", "20", "0", "13")
		var/cop_code_2 = pick("1","4", "7", "8", "10", "13", "17", "21", "22", "24", "33", "42", "54", "64", "75", "88", "99")
		var/cop_code_3 = pick("Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Sierra", "Uniform")
		return "[cop_code_1]-[cop_code_2] [cop_code_3]"
	else if(codetype == "SA")
		var/serb_code_1 = pick("Alil-Aga", "Boris", "Cvijan", "Dimitrije", "Grigorije", "Jelena", "Vasilij", "Leonid", "Nikolaj")
		var/serb_code_2 = pick("Srbije", "Rakija", "Cevapi", "Tito", "Artiljerija", "Budala", "Slava")
		return "[serb_code_1]! [serb_code_2]!"

// Add new ones here
var/global/datum/codespeak_list/cop_codes
var/global/datum/codespeak_list/serb_codes
proc/setup_codespeak()
	cop_codes = new()
	cop_codes.codetype = "IH"
	serb_codes = new()
	serb_codes.codetype = "SA"

// Takes meaning, returns code or generates new code
/datum/codespeak_list/proc/find_index(message)
	var/index = codes.Find(message)

	if(index)
		return index
	else
		index = get_cop_code()
		while(find_message(index))
			index = get_cop_code()
		codes[index] = message
		return index

// Takes code, returns meaning
/datum/codespeak_list/proc/find_message(index)
	var/message = codes[index]
	return message

// Takes code, returns meaning
/datum/codespeak_list/proc/find_message_radio(index)
	for(var/saved_index in codes)
		if(findtext(index, saved_index))
			return codes[saved_index]

/mob/living/carbon/human/
	var/codespeak_cooldown

/mob/living/carbon/human/proc/codesay(message, state_location, say_localy, faction = "IH")
	var/prefix = get_prefix_key(/decl/prefix/radio_channel_selection)
	if(world.time < src.codespeak_cooldown)
		to_chat(src, "You can't do it so fast!")
		return

	var/code_meaning
	var/code_index

	if(state_location)
		var/area/area = get_area(src)
		var/location = initial(area.name) //No funny area renaming
		var/preposition = pick("in", "at")
		code_meaning = "[message] [preposition] [location]"
	else
		code_meaning = message

	switch(faction)
		if("IH")
			code_index = cop_codes.find_index(code_meaning)
		if("SM")
			code_index = serb_codes.find_index(code_meaning)
		else
			return
	if(say_localy)
		say(code_index)
	else
		say("[prefix]s" + code_index)
	codespeak_cooldown = world.time + 25

// IRONHAMMER

/mob/living/carbon/human/proc/codespeak_help()
	set category = "Codespeak"
	set name = "HELP"
	src.codesay("Need help", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_backup()
	set category = "Codespeak"
	set name = "Backups"
	src.codesay("Need backups", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_clear()
	set category = "Codespeak"
	set name = "Area clear"
	src.codesay("No hostiles", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_romch()
	set category = "Codespeak"
	set name = "Roaches"
	src.codesay("Roaches", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_bigromch()
	set category = "Codespeak"
	set name = "Fuhrer roach"
	src.codesay("Fuhrer roach", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_murderhobo()
	set category = "Codespeak"
	set name = "Assailant"
	src.codesay("Armed assailant", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_serb()
	set category = "Codespeak"
	set name = "Serbs"
	src.codesay("Serbian mercs", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_commie()
	set category = "Codespeak"
	set name = "Excels"
	src.codesay("Excelsior infiltrators", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_carrion()
	set category = "Codespeak"
	set name = "Carrion"
	src.codesay("Carrion presence", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_mutant()
	set category = "Codespeak"
	set name = "Mutant"
	src.codesay("Unsanctioned organism", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_dead_crew()
	set category = "Codespeak"
	set name = "Dead guy"
	src.codesay("Crewmember flatlined", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_wounded_crew()
	set category = "Codespeak"
	set name = "Wounded guy"
	src.codesay("Crewmember wounded", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_dead_oper()
	set category = "Codespeak"
	set name = "Dead operative"
	src.codesay("Operative down", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_wounded_oper()
	set category = "Codespeak"
	set name = "Wounded operative"
	src.codesay("Operative needs medical help", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_ban()
	set category = "Codespeak"
	set name = "Burglary"
	src.codesay("Breaking and entering", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_criminal()
	set category = "Codespeak"
	set name = "Suspect"
	src.codesay("Located the suspect", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_status()
	set category = "Codespeak"
	set name = "Status?"
	src.codesay("What's the status?", FALSE, FALSE)

/mob/living/carbon/human/proc/codespeak_shutup()
	set category = "Codespeak"
	set name = "Shut up"
	src.codesay("Unnecessary use of radio", FALSE, FALSE)

/mob/living/carbon/human/proc/codespeak_understood()
	set category = "Codespeak"
	set name = "Ok"
	src.codesay("Affirmative", FALSE, FALSE)

/mob/living/carbon/human/proc/codespeak_yes()
	set category = "Codespeak"
	set name = "Yes"
	src.codesay("Positive", FALSE, FALSE)

/mob/living/carbon/human/proc/codespeak_no()
	set category = "Codespeak"
	set name = "No"
	src.codesay("Negative", FALSE, FALSE)

/mob/living/carbon/human/proc/codespeak_what()
	set category = "Codespeak"
	set name = "What?"
	src.codesay("Clarify?", FALSE, FALSE)

/mob/living/carbon/human/proc/codespeak_busted()
	set category = "Codespeak"
	set name = "Suspect in custody"
	src.codesay("Suspect in custody", FALSE, FALSE)

/mob/living/carbon/human/proc/codespeak_jailbreak()
	set category = "Codespeak"
	set name = "Suspect escaped"
	src.codesay("Suspect escaped", FALSE, FALSE)

/mob/living/carbon/human/proc/codespeak_understood_local()
	set category = "Codespeak"
	set name = "(local) Ok"
	src.codesay("Affirmative", FALSE, TRUE)

/mob/living/carbon/human/proc/codespeak_yes_local()
	set category = "Codespeak"
	set name = "(local) Yes"
	src.codesay("Positive", FALSE, TRUE)

/mob/living/carbon/human/proc/codespeak_no_local()
	set category = "Codespeak"
	set name = "(local) No"
	src.codesay("Negative", FALSE, TRUE)

/mob/living/carbon/human/proc/codespeak_engage_local()
	set category = "Codespeak"
	set name = "(local) Attack?"
	src.codesay("Engage?", FALSE, TRUE) //TODO: Replace with something that sounds good

/mob/living/carbon/human/proc/codespeak_hold_local()
	set category = "Codespeak"
	set name = "(local) Stay"
	src.codesay("Hold this position", FALSE, TRUE)

/mob/living/carbon/human/proc/codespeak_go_local()
	set category = "Codespeak"
	set name = "(local) Follow"
	src.codesay("Follow me", FALSE, TRUE)

/mob/living/carbon/human/proc/codespeak_stop_local()
	set category = "Codespeak"
	set name = "(local) Stop"
	src.codesay("Stop!", FALSE, TRUE)

/mob/living/carbon/human/proc/codespeak_run_local()
	set category = "Codespeak"
	set name = "(local) Run?"
	src.codesay("Proposing a tactical retreat", FALSE, TRUE)

/mob/living/carbon/human/proc/codespeak_idiot_local()
	set category = "Codespeak"
	set name = "(local) Friendly fire"
	src.codesay("Friendly fire", FALSE, TRUE)

/mob/living/carbon/human/proc/codespeak_warcrime_yes_local()
	set category = "Codespeak"
	set name = "(local) Use lethals"
	src.codesay("Use lethal ammunition, shoot to kill", FALSE, TRUE)

/mob/living/carbon/human/proc/codespeak_warcrime_no_local()
	set category = "Codespeak"
	set name = "(local) Use rubbers"
	src.codesay("Use non-lethal ammunition", FALSE, TRUE)

// Serbian exclusive

/mob/living/carbon/human/proc/sm_codespeak_help()
	set category = "SM Codespeak"
	set name = "HELP"
	src.codesay("Need help", TRUE, FALSE, "SM")

/mob/living/carbon/human/proc/sm_codespeak_backup()
	set category = "SM Codespeak"
	set name = "Backups"
	src.codesay("Need backups", TRUE, FALSE, "SM")

/mob/living/carbon/human/proc/sm_codespeak_clear()
	set category = "SM Codespeak"
	set name = "Area clear"
	src.codesay("No hostiles", TRUE, FALSE, "SM")

/mob/living/carbon/human/proc/sm_codespeak_dead_merc()
	set category = "SM Codespeak"
	set name = "Dead mercenary"
	src.codesay("Mercenary down", TRUE, FALSE, "SM")

/mob/living/carbon/human/proc/sm_codespeak_wounded_merc()
	set category = "SM Codespeak"
	set name = "Wounded mercenary"
	src.codesay("Mercenary needs medical help", TRUE, FALSE)

/mob/living/carbon/human/proc/sm_codespeak_target()
	set category = "SM Codespeak"
	set name = "Target"
	src.codesay("Located the target", TRUE, FALSE, "SM")

/mob/living/carbon/human/proc/sm_codespeak_status()
	set category = "SM Codespeak"
	set name = "Status?"
	src.codesay("What's the status?", FALSE, FALSE, "SM")

/mob/living/carbon/human/proc/sm_codespeak_shutup()
	set category = "SM Codespeak"
	set name = "Shut up"
	src.codesay("Unnecessary use of radio", FALSE, FALSE, "SM")

/mob/living/carbon/human/proc/sm_codespeak_understood()
	set category = "SM Codespeak"
	set name = "Ok"
	src.codesay("Affirmative", FALSE, FALSE, "SM")

/mob/living/carbon/human/proc/sm_codespeak_yes()
	set category = "SM Codespeak"
	set name = "Yes"
	src.codesay("Positive", FALSE, FALSE, "SM")

/mob/living/carbon/human/proc/sm_codespeak_no()
	set category = "SM Codespeak"
	set name = "No"
	src.codesay("Negative", FALSE, FALSE, "SM")

/mob/living/carbon/human/proc/sm_codespeak_what()
	set category = "SM Codespeak"
	set name = "What?"
	src.codesay("Clarify?", FALSE, FALSE, "SM")

/mob/living/carbon/human/proc/sm_codespeak_captured()
	set category = "SM Codespeak"
	set name = "Target in custody"
	src.codesay("Target in custody", FALSE, FALSE, "SM")

/mob/living/carbon/human/proc/sm_codespeak_escaped()
	set category = "SM Codespeak"
	set name = "Target escaped"
	src.codesay("Target escaped", FALSE, FALSE, "SM")

/mob/living/carbon/human/proc/sm_codespeak_understood_local()
	set category = "SM Codespeak"
	set name = "(local) Ok"
	src.codesay("Affirmative", FALSE, TRUE, "SM")

/mob/living/carbon/human/proc/sm_codespeak_yes_local()
	set category = "SM Codespeak"
	set name = "(local) Yes"
	src.codesay("Positive", FALSE, TRUE, "SM")

/mob/living/carbon/human/proc/sm_codespeak_no_local()
	set category = "SM Codespeak"
	set name = "(local) No"
	src.codesay("Negative", FALSE, TRUE, "SM")

/mob/living/carbon/human/proc/sm_codespeak_engage_local()
	set category = "SM Codespeak"
	set name = "(local) Attack?"
	src.codesay("Engage?", FALSE, TRUE, "SM") //TODO: Replace with something that sounds good

/mob/living/carbon/human/proc/sm_codespeak_hold_local()
	set category = "SM Codespeak"
	set name = "(local) Stay"
	src.codesay("Hold this position", FALSE, TRUE, "SM")

/mob/living/carbon/human/proc/sm_codespeak_go_local()
	set category = "SM Codespeak"
	set name = "(local) Follow"
	src.codesay("Follow me", FALSE, TRUE, "SM")

/mob/living/carbon/human/proc/sm_codespeak_stop_local()
	set category = "SM Codespeak"
	set name = "(local) Stop"
	src.codesay("Stop!", FALSE, TRUE, "SM")

/mob/living/carbon/human/proc/sm_codespeak_run_local()
	set category = "SM Codespeak"
	set name = "(local) Run?"
	src.codesay("Proposing a tactical retreat", FALSE, TRUE, "SM")

/mob/living/carbon/human/proc/sm_codespeak_idiot_local()
	set category = "SM Codespeak"
	set name = "(local) Friendly fire"
	src.codesay("Friendly fire", FALSE, TRUE, "SM")
