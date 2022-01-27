#define LOYALTY_CIVILIAN "As a civilian, your only loyalty is to yourself and your livelihood.<br>\
		You just want to survive,69ake a living, and get through the day. You shouldn't try to be a hero, or throw your life away for a cause. Nor should you hold any loyalties. Civilians should be easily corruptible, willing to take bribes to do anything someone wants and stay 69uiet about it."


/datum/job/clubmanager
	title = "Club69anager"
	flag = CLUBMANAGER
	department = DEPARTMENT_CIVILIAN
	department_flag = SERVICE
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the First Officer"
	selection_color = "#dddddd"
	also_known_languages = list(LANGUAGE_CYRILLIC = 25, LANGUAGE_SERBIAN = 15, LANGUAGE_JIVE = 80)
	access = list(access_bar, access_kitchen, access_maint_tunnels, access_change_club)
	initial_balance = 3000
	perks = list(PERK_CLUB)
	wage = WAGE_NONE //69akes his own69oney
	department_account_access = TRUE
	stat_modifiers = list(
		STAT_ROB = 15,
		STAT_TGH = 15,
		STAT_VIG = 15,
	)
	outfit_type = /decl/hierarchy/outfit/job/service/bartender //Re-using this.
	description = "As the Club69anager, you run the club aboard CEV Eris. Provide the crewmembers with drinks, food, and entertainment.<br>\
	<br>\
	Technically you take orders from no one, but the Captain and the First Officer are the ones who hired you and you should strive to please them. Your Club Workers help you run the place and69ake69oney. Pay them well!"

	duties = "		Run the club, provide a safe haven for food, drinks, and entertainment.<br>\
		Make69oney, run deals through your place, provide entertainment, trade secrets.<br>\
		Keep the bar safe, clean, and free of fights."

	loyalties = LOYALTY_CIVILIAN

/obj/landmark/join/start/clubmanager
	name = "Club69anager"
	icon_state = "player-grey"
	join_tag = /datum/job/clubmanager

/datum/job/clubworker
	title = "Club Worker"
	flag = CLUBWORKER
	department = DEPARTMENT_CIVILIAN
	department_flag = SERVICE
	faction = "CEV Eris"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Club69anager"
	selection_color = "#dddddd"
	also_known_languages = list(LANGUAGE_CYRILLIC = 10, LANGUAGE_JIVE = 60)
	access = list(access_bar, access_kitchen, access_maint_tunnels)
	initial_balance = 750
	perks = list(PERK_CLUB)
	wage = WAGE_NONE //They should get paid by the club owner, otherwise you know what to do.
	department_account_access = TRUE
	stat_modifiers = list(
		STAT_ROB = 10,
		STAT_TGH = 10,
		STAT_VIG = 5,
	)
	outfit_type = /decl/hierarchy/outfit/job/service/waiter
	description = "As a Club Worker, you work for the Club69anager. Your job is to fulfill your duties in running the Club and69aking sure all the customers are satisfied.<br>\
	<br>\
	You can cook, clean, server, tend the bar, entertain, or even be the bouncer. You have no limits to what you can do inside the Club granted your69anager re69uests you do it.<br>\
	<br>\
	You are paid directly by the Club69anager, he gives you your allowance. The Club69anager only69akes69oney if the Club is ran well, so work hard!"

	duties = "		Assist the Club69anager with running the club.<br>\
		Serve customers. Feed customers. Entertain customers.<br>\
		Protect the Club. Protect the Customers.<br>\
		Make enough69oney to stay alive aboard CEV Eris."

	loyalties = LOYALTY_CIVILIAN

/obj/landmark/join/start/clubworker
	name = "Club Worker"
	icon_state = "player-grey"
	join_tag = /datum/job/clubworker

