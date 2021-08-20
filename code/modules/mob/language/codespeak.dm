var/cop_code_expire
var/cop_code_last

/proc/get_cop_code()
	var/cop_code_1 = pick("10", "20", "0", "13")
	var/cop_code_2 = pick("1","4", "7", "8", "10", "13", "17", "21", "22", "24", "33", "40", "55", "64", "75", "88", "99")
	var/cop_code_3 = pick("Alpha", "Bravo", "Charlie", "Delta", "Echo", "Foxtrot", "Sierra", "Uniform")
	var/cop_code_new = "[cop_code_1]-[cop_code_2] [cop_code_3]"
	if(world.time < cop_code_expire)
		return cop_code_last
	else
		cop_code_expire = world.time + 3 // Just long enough for every hear_say, radio_hear and such to recieve the same code
		cop_code_last = cop_code_new
		return cop_code_new

/mob/living/carbon/human/
	var/codespeak_cooldown

/mob/living/carbon/human/proc/codesay(var/message, var/state_location, var/say_localy)
	var/prefix = get_prefix_key(/decl/prefix/radio_channel_selection)
	if(world.time < src.codespeak_cooldown)
		to_chat(src, "You can't do it so fast!")
	else if(state_location)
		var/area/area = get_area(src)
		var/location = initial(area.name) //No funny area renaming
		var/preposition = pick("in", "at")
		src.say("[prefix]s [message] [preposition] [location]@")
		codespeak_cooldown = world.time + 25
	else
		if(say_localy)
			src.say("[message]@")
			codespeak_cooldown = world.time + 25
		else
			src.say("[prefix]s [message]@")
			codespeak_cooldown = world.time + 25

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
	set name = "Dead oper"
	src.codesay("Operative down", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_wounded_oper()
	set category = "Codespeak"
	set name = "Wounded oper"
	src.codesay("Operative need medical help", TRUE, FALSE)

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
