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
		cop_code_expire = world.time + 3
		cop_code_last = cop_code_new
		return cop_code_new

/mob/living/carbon/human/proc/codesay(var/message, var/state_location, var/say_localy)
	var/prefix = get_prefix_key(/decl/prefix/radio_channel_selection)
	if(state_location)
		var/area/location = get_area(src)
		var/preposition = pick("in", "at")
		src.say("[prefix]s [message] [preposition] [location.name]¿")
	else
		if(say_localy)
			src.say("[message]¿")
		else
			src.say("[prefix]s [message]¿")

/mob/living/carbon/human/proc/codespeak_help()
	set category = "Codespeak"
	set name = "MAYDAY"
	src.codesay("Need backups", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_clear()
	set category = "Codespeak"
	set name = "Area clear"
	src.codesay("No hostiles", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_romch()
	set category = "Codespeak"
	set name = "Found roaches"
	src.codesay("Roaches", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_bigromch()
	set category = "Codespeak"
	set name = "Found fuhrer"
	src.codesay("Fuhrer roach", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_serb()
	set category = "Codespeak"
	set name = "Found serbs"
	src.codesay("Serbian mercs", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_commie()
	set category = "Codespeak"
	set name = "Found excels"
	src.codesay("Excelsior infiltrators", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_carrion()
	set category = "Codespeak"
	set name = "Found carrion"
	src.codesay("Carrion presence", TRUE, FALSE)

/mob/living/carbon/human/proc/codespeak_understood()
	set category = "Codespeak"
	set name = "Ok"
	src.codesay("Roger that", FALSE, FALSE)

/mob/living/carbon/human/proc/codespeak_yes()
	set category = "Codespeak"
	set name = "Yes"
	src.codesay("Positive", FALSE, FALSE)

/mob/living/carbon/human/proc/codespeak_no()
	set category = "Codespeak"
	set name = "No"
	src.codesay("Negative", FALSE, FALSE)

/mob/living/carbon/human/proc/codespeak_understood_local()
	set category = "Codespeak"
	set name = "local Ok"
	src.codesay("Roger that", FALSE, TRUE)

/mob/living/carbon/human/proc/codespeak_yes_local()
	set category = "Codespeak"
	set name = "local Yes"
	src.codesay("Positive", FALSE, TRUE)

/mob/living/carbon/human/proc/codespeak_no_local()
	set category = "Codespeak"
	set name = "local No"
	src.codesay("Negative", FALSE, TRUE)