/datum/job/assistant
	title = "Assistant"
	flag = ASSISTANT
	department = DEPARTMENT_CIVILIAN
	department_flag = CIVILIAN
	faction = "CEV Eris"
	total_positions = -1
	spawn_positions = -1
	supervisors = "anyone who pays you"
	selection_color = "#dddddd"
	initial_balance	= 800
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

	description = "You are not part of the crew. Or at least, you don't hold an official rank. You will not be paid a wage.<br>\
Where did you come from, why are you here? These things are up to you.<br>\

Perhaps you're a stowaway, sneaked onboard with cargo and not discovered until your old world was already a speck on the star chart<br>\
Perhaps you are a passenger, who paid for transit. Where are you going, or what are you running from?<br>\
Perhaps you're a friend, relative, spouse or lover of an existing crewmember. How can you support them in their work?<br>\
Perhaps you're a young apprentice, taken onboard with promise of starting a new and exciting career.<br>\
Perhaps you're a former prisoner. Served your time and ready to join the crew.<br>\
Perhaps you were marooned on an asteroid and rescued by Eris.<br>\

Your story is yours to write. What matters is, you're here now, and you should find purpose.<br>\
As an assistant, you should strive to help out anyone you can. Or at least, anyone who offers you a paying job. Find a way to make money, stay out of trouble, and survive."

	loyalties = "Your loyalty is yours to decide"

/obj/landmark/join/start/assistant
	name = "Assistant"
	icon_state = "player-grey"
	join_tag = /datum/job/assistant
