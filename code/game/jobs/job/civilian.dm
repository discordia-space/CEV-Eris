#define LOYALTY_CIVILIAN "As a civilian, your only loyalty is to yourself and your livelihood.<br>\
		You just want to survive, make a living, and get through the day. You shouldn't try to be a hero, or throw your life away for a cause. Nor should you hold any loyalties. Civilians should be easily corruptible, willing to take bribes to do anything someone wants and stay quiet about it."


/datum/job/clubmanager
	title = "Mafia Don"
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
	wage = WAGE_NONE // Makes his own money
	department_account_access = TRUE
	stat_modifiers = list(
		STAT_ROB = 15,
		STAT_TGH = 15,
		STAT_VIG = 15,
	)
	outfit_type = /decl/hierarchy/outfit/job/service/bartender //Re-using this.
	description = "As the Mafia Don, you run the club aboard CEV Eris. Provide the crewmembers with drinks, food, and entertainment.<br>\
	<br>\
	Technically you take orders from no one, but the Captain and the First Officer are the ones who hired you and you should strive to please them. Your Mafia Consiglieres help you run the place and make money. Pay them well!"

	duties = "		Run the club, provide a safe haven for food, drinks, and entertainment.<br>\
		Make money, run deals through your place, provide entertainment, trade secrets.<br>\
		Keep the bar safe, clean, and free of fights."

	loyalties = LOYALTY_CIVILIAN

/obj/landmark/join/start/clubmanager
	name = "Mafia Don"
	icon_state = "player-grey"
	join_tag = /datum/job/clubmanager

/datum/job/clubworker
	title = "Mafia Consigliere"
	flag = CLUBWORKER
	department = DEPARTMENT_CIVILIAN
	department_flag = SERVICE
	faction = "CEV Eris"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Mafia Don"
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
	description = "As a Mafia Consigliere, you work for the Mafia Don. Your job is to fulfill your duties in running the Mafia and making sure all the customers are satisfied.<br>\
	<br>\
	You can cook, clean, server, tend the bar, entertain, or even be the bouncer. You have no limits to what you can do inside the Mafia granted your manager requests you do it.<br>\
	<br>\
	You are paid directly by the Mafia Don, he gives you your allowance. The Mafia Don only makes money if the Mafia is ran well, so work hard!"

	duties = "		Assist the Mafia Don with running the club.<br>\
		Serve customers. Feed customers. Entertain customers.<br>\
		Protect the Mafia. Protect the Customers.<br>\
		Make enough money to stay alive aboard CEV Eris."

	loyalties = LOYALTY_CIVILIAN

/obj/landmark/join/start/clubworker
	name = "Mafia Consigliere"
	icon_state = "player-grey"
	join_tag = /datum/job/clubworker

