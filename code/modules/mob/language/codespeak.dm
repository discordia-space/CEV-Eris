var/cop_code_expire
var/cop_code_last
var/cop_code_meaning

/proc/get_cop_code()
	var/cop_code_1 = pick("10", "20", "0", "13")
	var/cop_code_2 = pick("1","4", "7", "8", "10", "13", "17", "21", "22", "24", "33", "40", "55", "64", "75", "88", "99")
	var/cop_code_3 = pick("Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Sierra", "Uniform")
	var/cop_code_new = "69cop_code_169-69cop_code_269 69cop_code_369"
	if(world.time < cop_code_expire)
		return cop_code_last
	else
		cop_code_expire = world.time + 3 // Just long enough for every hear_say, radio_hear and such to recieve the same code
		cop_code_last = cop_code_new
		return cop_code_new

/mob/living/carbon/human/
	var/codespeak_cooldown

/mob/living/carbon/human/proc/codesay(message, state_location, say_localy)
	var/prefix = get_prefix_key(/decl/prefix/radio_channel_selection)
	if(world.time < src.codespeak_cooldown)
		to_chat(src, "You can't do it so fast!")
	else if(state_location)
		var/area/area = get_area(src)
		var/location = initial(area.name) //No funny area renaming
		var/preposition = pick("in", "at")
		cop_code_meaning = "69message69 69preposition69 69location69"
		say("69prefix69s" + get_cop_code())
		codespeak_cooldown = world.time + 25
	else
		if(say_localy)
			cop_code_meaning =69essage
			say(get_cop_code())
			codespeak_cooldown = world.time + 25
		else
			cop_code_meaning =69essage
			say("69prefix69s" + get_cop_code())
			codespeak_cooldown = world.time + 25

/mob/living/carbon/human/proc/codespeak_help()
	set category = "Codespeak"
	set69ame = "HELP"
	src.codesay("Need help", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_backup()
	set category = "Codespeak"
	set69ame = "Backups"
	src.codesay("Need backups", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_clear()
	set category = "Codespeak"
	set69ame = "Area clear"
	src.codesay("No hostiles", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_romch()
	set category = "Codespeak"
	set69ame = "Roaches"
	src.codesay("Roaches", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_bigromch()
	set category = "Codespeak"
	set69ame = "Fuhrer roach"
	src.codesay("Fuhrer roach", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_murderhobo()
	set category = "Codespeak"
	set69ame = "Assailant"
	src.codesay("Armed assailant", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_serb()
	set category = "Codespeak"
	set69ame = "Serbs"
	src.codesay("Serbian69ercs", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_commie()
	set category = "Codespeak"
	set69ame = "Excels"
	src.codesay("Excelsior infiltrators", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_carrion()
	set category = "Codespeak"
	set69ame = "Carrion"
	src.codesay("Carrion presence", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_mutant()
	set category = "Codespeak"
	set69ame = "Mutant"
	src.codesay("Unsanctioned organism", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_dead_crew()
	set category = "Codespeak"
	set69ame = "Dead guy"
	src.codesay("Crewmember flatlined", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_wounded_crew()
	set category = "Codespeak"
	set69ame = "Wounded guy"
	src.codesay("Crewmember wounded", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_dead_oper()
	set category = "Codespeak"
	set69ame = "Dead operative"
	src.codesay("Operative down", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_wounded_oper()
	set category = "Codespeak"
	set69ame = "Wounded operative"
	src.codesay("Operative69eeds69edical help", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_ban()
	set category = "Codespeak"
	set69ame = "Burglary"
	src.codesay("Breaking and entering", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_criminal()
	set category = "Codespeak"
	set69ame = "Suspect"
	src.codesay("Located the suspect", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_status()
	set category = "Codespeak"
	set69ame = "Status?"
	src.codesay("What's the status?", FALSE, FALSE)

/mob/living/carbon/human/proc/codespeak_shutup()
	set category = "Codespeak"
	set69ame = "Shut up"
	src.codesay("Unnecessary use of radio", FALSE, FALSE)

/mob/living/carbon/human/proc/codespeak_understood()
	set category = "Codespeak"
	set69ame = "Ok"
	src.codesay("Affirmative", FALSE, FALSE)

/mob/living/carbon/human/proc/codespeak_yes()
	set category = "Codespeak"
	set69ame = "Yes"
	src.codesay("Positive", FALSE, FALSE)

/mob/living/carbon/human/proc/codespeak_no()
	set category = "Codespeak"
	set69ame = "No"
	src.codesay("Negative", FALSE, FALSE)

/mob/living/carbon/human/proc/codespeak_what()
	set category = "Codespeak"
	set69ame = "What?"
	src.codesay("Clarify?", FALSE, FALSE)

/mob/living/carbon/human/proc/codespeak_busted()
	set category = "Codespeak"
	set69ame = "Suspect in custody"
	src.codesay("Suspect in custody", FALSE, FALSE) 

/mob/living/carbon/human/proc/codespeak_jailbreak()
	set category = "Codespeak"
	set69ame = "Suspect escaped"
	src.codesay("Suspect escaped", FALSE, FALSE) 

/mob/living/carbon/human/proc/codespeak_understood_local()
	set category = "Codespeak"
	set69ame = "(local) Ok"
	src.codesay("Affirmative", FALSE, TRUE)

/mob/living/carbon/human/proc/codespeak_yes_local()
	set category = "Codespeak"
	set69ame = "(local) Yes"
	src.codesay("Positive", FALSE, TRUE)

/mob/living/carbon/human/proc/codespeak_no_local()
	set category = "Codespeak"
	set69ame = "(local)69o"
	src.codesay("Negative", FALSE, TRUE)

/mob/living/carbon/human/proc/codespeak_engage_local()
	set category = "Codespeak"
	set69ame = "(local) Attack?"
	src.codesay("Engage?", FALSE, TRUE) //TODO: Replace with something that sounds good

/mob/living/carbon/human/proc/codespeak_hold_local()
	set category = "Codespeak"
	set69ame = "(local) Stay"
	src.codesay("Hold this position", FALSE, TRUE)

/mob/living/carbon/human/proc/codespeak_go_local()
	set category = "Codespeak"
	set69ame = "(local) Follow"
	src.codesay("Follow69e", FALSE, TRUE)

/mob/living/carbon/human/proc/codespeak_stop_local()
	set category = "Codespeak"
	set69ame = "(local) Stop"
	src.codesay("Stop!", FALSE, TRUE)

/mob/living/carbon/human/proc/codespeak_run_local()
	set category = "Codespeak"
	set69ame = "(local) Run?"
	src.codesay("Proposing a tactical retreat", FALSE, TRUE)

/mob/living/carbon/human/proc/codespeak_idiot_local()
	set category = "Codespeak"
	set69ame = "(local) Friendly fire"
	src.codesay("Friendly fire", FALSE, TRUE)

/mob/living/carbon/human/proc/codespeak_warcrime_yes_local()
	set category = "Codespeak"
	set69ame = "(local) Use lethals"
	src.codesay("Use lethal ammunition, shoot to kill", FALSE, TRUE)

/mob/living/carbon/human/proc/codespeak_warcrime_no_local()
	set category = "Codespeak"
	set69ame = "(local) Use rubbers"
	src.codesay("Use69on-lethal ammunition", FALSE, TRUE)
