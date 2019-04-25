#define LOYALTY_CIVILIAN "As a civilian, your only loyalty is to yourself and your livelihood.<br>\
		You just want to survive, make a living, and get through the day. You shouldn't try to be a hero, or throw your life away for a cause. Nor should you hold any loyalties. Civilians should be easily corruptible, willing to take bribes to do anything someone wants and stay quiet about it."

/datum/job/bartender
	title = "Bartender"
	flag = BARTENDER
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
		STAT_VIG = 5,
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


/datum/job/chef
	title = "Chef"
	flag = CHEF
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



/datum/job/hydro
	title = "Gardener"
	flag = BOTANIST
	department = DEPARTMENT_CIVILIAN
	department_flag = SERVICE
	faction = "CEV Eris"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the First Officer"
	selection_color = "#dddddd"
	//alt_titles = list("Hydroponicist")
	also_known_languages = list(LANGUAGE_CYRILLIC = 15, LANGUAGE_JIVE = 80)
	access = list(access_hydroponics, access_bar, access_kitchen)

	outfit_type = /decl/hierarchy/outfit/job/service/gardener
	stat_modifiers = list(
		STAT_BIO = 10,
		STAT_TGH = 15,
		STAT_ROB = 10,
	)

	description = "The green-fingered gnome working in the glorious viridian basement of Eris. You are the gardener, tender of plants.<br>\
	All plantlife aboard the station is your responsibility to deal with, both the nice and the nasty ones. You have gardens spread across two floors to work with, conveniently located below the diner area. Visitors and guests are not uncommon, but your main contact will be with the Chef, your closest colleague.<br>\
	<br>\
	Your first and primary responsibility aboard eris, is as a farmer. The gardens contain all of the seeds, tools and fertilisers you need to grow crops and feed the station. Ensure a good variety of raw vegetables, and plenty of core grains like rice and wheat.<br>\
	<br>\
	Your second duty is as a rancher, if you have the talents. The lower garden contains a few rooms that are suitable for use as a sort of stable or paddock, in general the whole area is quite pleasant for animal life to roam around in, and comes with a few chickens plus a cow to start you off. More animals can be imported through the guild, allowing you to create a little oasis of life in a dark and gritty universe.<br>\
	<br>\
	Your third responsibility is much less savory. Eris is an old ship, ancient, rusty, and teeming with life. The maintenance corridors are infested with an invasive fungal species, affectionately termed Fungo d'Artigliero, by some botanist before your time. These mushrooms grow through burrows around the ship and wreak havoc, spraying chemicals around. Dealing with them - as well as any other invasive flora -  primarily falls to you, although this is a task that you may wish to hire some assistants to help out with.<br>\
	<br>\
	The shovels and hatchets in your garden provide the basic tools you'll need for these tasks, but you should always be on the lookout for more advanced equipment. A chainsaw or flamethrower would both be exceptionally useful tools for aggresive plant management"

	duties = "Grow food for the chef to feed the station<br>\
		Raise animals for eggs, meat and recreation<br>\
		Manage invasive flora around the ship, and cut out mushroom infestations"

	loyalties = LOYALTY_CIVILIAN

/obj/landmark/join/start/hydro
	name = "Gardener"
	icon_state = "player-grey"
	join_tag = /datum/job/hydro


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
		STAT_TGH = 10,
		STAT_ROB = 15,
		STAT_VIG = 10,
	)

	loyalties = LOYALTY_CIVILIAN

/obj/landmark/join/start/actor
	name = "Actor"
	icon_state = "player-grey"
	join_tag = /datum/job/actor


/datum/job/janitor
	title = "Janitor"
	flag = JANITOR
	department = DEPARTMENT_CIVILIAN
	department_flag = SERVICE
	faction = "CEV Eris"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the First Officer"
	selection_color = "#dddddd"
	//alt_titles = list("Custodian","Sanitation Technician")
	also_known_languages = list(LANGUAGE_CYRILLIC = 15, LANGUAGE_JIVE = 80)
	access = list(access_janitor, access_maint_tunnels)
	wage = WAGE_LABOUR_DUMB //Todo future: Give janitor bonus based on cleaning actually done
	outfit_type = /decl/hierarchy/outfit/job/service/janitor

	stat_modifiers = list(
		STAT_ROB = 10,
		STAT_BIO = 10,
	)

	software_on_spawn = list(/datum/computer_file/program/camera_monitor)

	description = "The lowly janitor. Probably the worst paid and least respected role on the ship. Everyone overlooks you, until they need you. And need you they shall. When someone stumbles down the hallway bleeding from every orifice, you get to clean it up.<br>\
	<br>\
	Armed with your trusty janicart full of cleaning supplies, you trundle around the ship mopping up blood, and spraying away oil. Cleaning is obviously your first and foremost duty. Wherever there's dirt, rubble, bloodstains, trash and chemical spills, you should be there to clean it up. Monster corpses are also a bit of a problem to dispose of. The roaches should be taken up to chemistry, where they can be processed for chemical purposes. Others should generally be shoved down a disposal chute, let the guild sort it out from there.<br>\
	<br>\
	To note though, you should be careful when cleaning up a scene of violence - especially a murder. The Ironhammer investigative team will probably want to take samples of evidence before you destroy it all<br>\
	<br>\
	In addition to cleaning, you should also handle minor maintenance. Replacing lights, correcting broken vendors, replacing floor tiles, duct taping cracked walls and windows, etc. You're far from being one of the Technomancers, but you can handle small problems if they're busy<br>\
	<br>\
	Lastly, your custodial closet contains quite a few traps, large and small. Deploying these carefully around maintenance - and especially ontop of burrows, may help remove a few roaches from the ship. Treasure those traps, as producing more is not so easy."

	duties = "		Clean blood, dirt, rubble and messes. Pickup trash and dispose of monster corpses<br>\
		Conduct minor repairs and maintenance when technomancers aren't available<br>\
		Deploy traps on burrows to keep nasty creatures at bay"

	loyalties = LOYALTY_CIVILIAN


/obj/landmark/join/start/janitor
	name = "Janitor"
	icon_state = "player-grey"
	join_tag = /datum/job/janitor
