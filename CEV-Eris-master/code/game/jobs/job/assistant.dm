/datum/job/assistant
	title = ASSISTANT_TITLE
	flag = ASSISTANT
	department = DEPARTMENT_CIVILIAN
	department_flag = CIVILIAN
	faction = "CEV Eris"
	total_positions = -1
	spawn_positions = -1
	supervisors = "anyone who pays you"
	selection_color = "#dddddd"
	initial_balance	= 0 // This is now defined in code\modules\economy\cash.dm under spacecash/bundle/Vagabond as they carry cash on them.
	wage = WAGE_NONE //Get a job ya lazy bum
	//alt_titles = list("Technomancer Assistant","Moebius Medical Intern","Moebius Research Assistant")
	also_known_languages = list(LANGUAGE_CYRILLIC = 15, LANGUAGE_SERBIAN = 5)

	access = list(access_maint_tunnels)
	outfit_type = /decl/hierarchy/outfit/job/assistant

	stat_modifiers = list(
		STAT_ROB = 8,
		STAT_TGH = 8,
		STAT_BIO = 8,
		STAT_MEC = 8,
		STAT_VIG = 8,
		STAT_COG = 8
	)

	perks = list(/datum/perk/vagabond)

	description = "You are a vagabond, journeying through the vast expanses of space upon the CEV Eris. You will not be paid a wage.<br>\
Though this does not mean you have no home, as the Eris is your home. Whatever planet you may have came from a now distant memory.<br>\

You remember boarding the Eris sometime in your past, when it had a different purpose and a different captain.<br>\
Over time you've become accustomed to the dangers of this ship.<br>\
The ID you wear likely not even your own. At least as far as you can remember.<br>\
But this chunk of plastic still can be a rare oddity, that can change your character.<br>\
As an vagabond, you should strive to help out anyone you can. Or at least, anyone who offers you a paying job. Find a way to make money, stay out of trouble, and survive."

	loyalties = "Your loyalty is yours to decide"

/obj/landmark/join/start/assistant
	name = ASSISTANT_TITLE
	icon_state = "player-grey"
	join_tag = /datum/job/assistant

/datum/job/assistant/New()
	..()
	for(var/alt in subtypesof(/datum/job_flavor/assistant))
		random_flavors += new alt
