#define LOYALTY_CIVILIAN "As a civilian, your only loyalty is to yourself and your livelihood.<br>\
		You just want to survive, make a living, and get through the day. You shouldn't try to be a hero, or throw your life away for a cause. Nor should you hold any loyalties. Civilians should be easily corruptible, willing to take bribes to do anything someone wants and stay quiet about it."


/datum/job/clubmanager
	title = "Club Manager"
	flag = CLUBMANAGER
	department = DEPARTMENT_CIVILIAN
	department_flag = SERVICE
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the First Officer"
	selection_color = "#dddddd"
	also_known_languages = list(LANGUAGE_CYRILLIC = 25, LANGUAGE_SERBIAN = 15, LANGUAGE_JIVE = 80)
	access = list(access_bar, access_kitchen)
	initial_balance = 3000
	wage = WAGE_NONE // Makes his own money
	stat_modifiers = list(
		STAT_ROB = 15,
		STAT_TGH = 15,
		STAT_VIG = 15,
	)
	outfit_type = /decl/hierarchy/outfit/job/service/bartender //Re-using this.
	description = "As the Club Manager, you run the club aboard CEV Eris. Provide the crewmembers with drinks, food, and entertainment.<br>\
	<br>\
	Technically you take orders from no one, but the Captain and the First Officer are the ones who hired you and you should strive to please them. Your Club Workers help you run the place and make money. Pay them well!"

	duties = "		Run the club, provide a safe haven for food, drinks, and entertainment.<br>\
		Make money, run deals through your place, provide entertainment, trade secrets.<br>\
		Keep the bar safe, clean, and free of fights."

	loyalties = LOYALTY_CIVILIAN

/obj/landmark/join/start/clubmanager
	name = "Club Manager"
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
	supervisors = "the Club Manager"
	selection_color = "#dddddd"
	also_known_languages = list(LANGUAGE_CYRILLIC = 10, LANGUAGE_JIVE = 60)
	access = list(access_bar, access_kitchen)
	initial_balance = 750
	wage = WAGE_NONE //They should get paid by the club owner, otherwise you know what to do.
	stat_modifiers = list(
		STAT_ROB = 10,
		STAT_TGH = 10,
		STAT_VIG = 5,
	)
	outfit_type = /decl/hierarchy/outfit/job/service/waiter
	description = "As a Club Worker, you work for the Club Manager. Your job is to fulfill your duties in running the Club and making sure all the customers are satisfied.<br>\
	<br>\
	You can cook, clean, server, tend the bar, entertain, or even be the bouncer. You have no limits to what you can do inside the Club granted your manager requests you do it.<br>\
	<br>\
	You are paid directly by the Club Manager, he gives you your allowance. The Club Manager only makes money if the Club is ran well, so work hard!"

	duties = "		Assist the Club Manager with running the club.<br>\
		Serve customers. Feed customers. Entertain customers.<br>\
		Protect the Club. Protect the Customers.<br>\
		Make enough money to stay alive aboard CEV Eris."

	loyalties = LOYALTY_CIVILIAN

/obj/landmark/join/start/clubworker
	name = "Club Worker"
	icon_state = "player-grey"
	join_tag = /datum/job/clubworker

/datum/job/bartender //Staying in until I can edit the map
	title = "Bartender"
	flag = CLUBMANAGER //Staying like this until it can be removed
	department = DEPARTMENT_CIVILIAN
	department_flag = SERVICE
	faction = "CEV Eris"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the First Officer"
	selection_color = "#dddddd"
	also_known_languages = list(LANGUAGE_CYRILLIC = 25, LANGUAGE_SERBIAN = 15)
	access = list(access_hydroponics, access_bar, access_kitchen)
	initial_balance	= 1600
	wage = WAGE_NONE	//Bartender is unpaid, they make money selling drinks
	stat_modifiers = list(
		STAT_ROB = 15,
		STAT_TGH = 15,
		STAT_VIG = 10,
	)
	also_known_languages = list(LANGUAGE_JIVE = 80)

	outfit_type = /decl/hierarchy/outfit/job/service/bartender

	description = "As a bartender, you're the social heart and soul of the ship. Your job is serving drinks, and you have a plethora of beverages to choose from. But that's only the beginning, unless you're particularly unimaginative. Your real work here is socialising. You cheer up the lonely, depressed and terrified. Or just the bored who are looking for a place to smoke and hang out. You can provide private space for those who wish to conduct certain kinds of business under the table, gather gossip from those who have information to share, make a profit from selling it onto those looking to know.<br>\
	<br>\
	The bar is your space, and you should endeavor to make it a safe, welcoming and interesting place for anyone who might visit. At least, anyone you decide is allowed in. In case of trouble, calling ironhammer should generally be your first move, but you have a shotgun stored in the backroom for emergencies.<br>\
	<br>\
	You are a free agent, a sole trader running a bar here.  That means you have to make your own money. Charge for your drinks, services and secrets, or you'll find yourself destitute. Allowing regular patrons to start up a tab may be a good idea.<br>\
	Theoretically you don't have a rank and aren't directly answerable to anyone in the crew. But it is still the captain's ship, and you'd best stay on his good side if you don't want a free trip out of an airlock.<br>\
	<br>\
	It is important to note that bartender is a roleplay oriented job. You don't have many duties on the ship and people may not come to visit you if you don't give a good reason. It's a role for players with creativity and charisma. If you don't have an idea of how and who you want to play, you may end up bored."

	duties = "		Mix and serve drinks for visitors to your bar<br>\
		Talk to crewmates, entertain them, keep people company and crew morale high<br>\
		Gather gossip and trade in secrets<br>\
		Keep the bar safe, break up fights, and get out your shotgun in dire emergencies"

	loyalties = LOYALTY_CIVILIAN


/obj/landmark/join/start/bartender
	name = "Bartender"
	icon_state = "player-grey"
	join_tag = /datum/job/bartender


/datum/job/chef //Staying in until I can edit the map
	title = "Chef"
	flag = CLUBWORKER //Staying like this until they can be removed.
	department = DEPARTMENT_CIVILIAN
	department_flag = SERVICE
	faction = "CEV Eris"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the First Officer"
	selection_color = "#dddddd"
	also_known_languages = list(LANGUAGE_CYRILLIC = 15, LANGUAGE_JIVE = 80)
	access = list(access_hydroponics, access_bar, access_kitchen)
	stat_modifiers = list(
		STAT_ROB = 10,
		STAT_TGH = 10,
	)
	outfit_type = /decl/hierarchy/outfit/job/service/chef

	loyalties = LOYALTY_CIVILIAN
	wage = WAGE_NONE	//Chef is unpaid, they make money selling food
	initial_balance	= 1600
	description = "	Everyone's favourite person when they're hungry, you are the chef, maker of food and slayer of hunger. Everyone needs to eat, and you make sure they can. Your job is fairly simple, cook food for the crew. Your primary source of raw materials is the garden downstairs, you and the gardener should work closely together. <br>\
	<br>\
	You are a sole trader trying to make a profit here, so giving away your food for free is not adviseable unless times are desperate<br>\
	<br>\
	Many of the crew will be too busy to come to the diner for food. You can capitalize on this by offering a delivery service - at extra cost of course. Hiring an assistant to act as a delivery boy would be a good move."

	duties = "		Cook food for the crew<br>\
		Make sure everyone is fed"

/obj/landmark/join/start/chef
	name = "Chef"
	icon_state = "player-grey"
	join_tag = /datum/job/chef





/datum/job/actor
	title = "Actor"
	flag = ACTOR
	department = DEPARTMENT_CIVILIAN
	department_flag = SERVICE
	faction = "CEV Eris"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the First Officer"
	selection_color = "#dddddd"
	also_known_languages = list(LANGUAGE_CYRILLIC = 15, LANGUAGE_SERBIAN = 5, LANGUAGE_JIVE = 80)
	access = list(access_maint_tunnels, access_theatre)

	outfit_type = /decl/hierarchy/outfit/job/service/actor/clown
	wage = WAGE_LABOUR_DUMB	//Barely a retaining fee. Actor can busk for credits to keep themselves fed
	stat_modifiers = list(
		STAT_TGH = 30, //basically a punching bag, he can't robust anyone or shoot guns anyway
	)

	loyalties = LOYALTY_CIVILIAN

/obj/landmark/join/start/actor
	name = "Actor"
	icon_state = "player-grey"
	join_tag = /datum/job/actor



