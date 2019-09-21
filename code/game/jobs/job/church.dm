/datum/job/chaplain
	title = "NeoTheology Preacher"
	flag = CHAPLAIN
	department = DEPARTMENT_CHURCH
	department_flag = CHURCH
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the NeoTheology Church"
	selection_color = "#ecd37d"
	also_known_languages = list(LANGUAGE_CYRILLIC = 25, LANGUAGE_SERBIAN = 25)
	cruciform_access = list(access_morgue, access_chapel_office, access_crematorium, access_hydroponics, access_janitor, access_maint_tunnels)
	wage = WAGE_PROFESSIONAL //The church has deep pockets
	department_account_access = TRUE
	outfit_type = /decl/hierarchy/outfit/job/church/chaplain

	stat_modifiers = list(
		STAT_TGH = 10,
		STAT_BIO = 15,
		STAT_VIG = 15,
		STAT_COG = 10,
	)

	software_on_spawn = list(/datum/computer_file/program/records,
							 /datum/computer_file/program/reports)

	core_upgrades = list(
		CRUCIFORM_PRIEST,
		CRUCIFORM_REDLIGHT
	)

	description = "You are the head of a local branch of the Church of NeoTheology. You represent the church's interests aboard Eris, as well as the interests of the NT disciples among the crew, who can be identified by the Cruciform implant upon their breast. The church is a major contributor to the funding of Eris' mission, and demands respect<br>\
	<br>\
	Your duties aboard the ship may not seem so important to its mission, but they have greater significance in the galaxy as a whole. As well as a more immediate significance to the morale of the crew, especially the followers of NeoTheology.<br>\
	<br>\
	Sometimes the Church will deploy Inquisitors to remote outposts like this, to serve its interests. When one is on Eris, you will generally be their point of contact. Inquisitors outrank you and you should follow all of their instructions without question. Inquisitors work in secret, and so you should not discuss their presence with anyone unless they permit it.<br>\
	<br>\
	First and foremost, you are a Man of the Cloth, and as such you must tend to the spiritual needs of the crew. Those looking to convert to NT should come to you for the rites, and the cruciform.<br>\
	When the mood is dour, when all hope is lost, it falls to you to be a spiritual leader. Preach to the flock, inspire faith and strength in their hearts. The rituals in your book can also offer more tangible assistance in labour and combat.<br>\
	Even when times are bright, do your best to keep it that way. Tour the ship, offering support to those in need. A prayer in the right ear, a helping hand, or a shoulder to cry on, can do wonders. And people are most vulnerable to conversion when they are at their weakest.<br>\
	<br>\
	When the living are tended to, your next duty is to the dead. <br>\
	The church holds exclusive patents on cloning technology, utilising the Cruciform implanted in each of its disciples as a Cortical Stack, storing a backup of the host's memories and personality - their soul, if you will. When one of the faithful suffers an untimely demise, it is your sacred duty to grow a new vessel and transplant their soul into it, restoring them to life. Immortality is the reward of the faithful.<br>\
	<br>\
	For those who are not part of the fold, the next best thing you can offer is a dignified funeral. The chapel area contains coffins and machinery to commit the dead unto the void. Burial at space. Any player who is given a proper funeral will have their respawn time reduced, allowing them to rejoin the crew as a new character more quickly, after death."


	duties = "Represent the interests of NT disciples aboard Eris. Protect them from persecution and speak for them.<br>\
		Hold mass, give sermons, preach to the faithful, and lead group ritual sessions.<br>\
		Recover and clone the faithful dead.<br>\
		Hold funerals for the dead heathens."

	setup_restricted = TRUE

/obj/landmark/join/start/chaplain
	name = "NeoTheology Preacher"
	icon_state = "player-black"
	join_tag = /datum/job/chaplain

/datum/job/acolyte
	title = "Neotheology Acolyte"
	flag = ACOLYTE
	department = DEPARTMENT_CHURCH
	department_flag = CHURCH
	faction = "CEV Eris"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Neotheology Preacher"
	selection_color = "#ecd37d"
	also_known_languages = list(LANGUAGE_CYRILLIC = 10)
	cruciform_access = list(access_morgue, access_crematorium, access_maint_tunnels, access_hydroponics)
	wage = WAGE_PROFESSIONAL
	outfit_type = /decl/hierarchy/outfit/job/church/acolyte

	stat_modifiers = list(
	STAT_MEC = 25,
	STAT_BIO = 10,
	STAT_VIG = 10,
	STAT_TGH = 5,
	)

	core_upgrades = list(
		CRUCIFORM_PRIEST
	)

	description = "WIP"

	duties = "WIP"

	setup_restricted = TRUE

/obj/landmark/join/start/acolyte
	name = "NeoTheology Acolyte"
	icon_state = "player-black"
	join_tag = /datum/job/acolyte


/datum/job/hydro
	title = "Gardener"
	flag = BOTANIST
	department = DEPARTMENT_CHURCH
	department_flag = CHURCH
	faction = "CEV Eris"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Neotheology Preacher"
	selection_color = "#ecd37d"
	//alt_titles = list("Hydroponicist")
	also_known_languages = list(LANGUAGE_CYRILLIC = 15, LANGUAGE_JIVE = 80)
	cruciform_access = list(access_hydroponics, access_morgue, access_crematorium, access_maint_tunnels,)
	wage = WAGE_PROFESSIONAL

	outfit_type = /decl/hierarchy/outfit/job/church/gardener
	stat_modifiers = list(
		STAT_BIO = 15,
		STAT_TGH = 15,
		STAT_ROB = 10,
	)

	description = "WIP"/*"The green-fingered gnome working in the glorious viridian basement of Eris. You are the gardener, tender of plants.<br>\
	All plantlife aboard the station is your responsibility to deal with, both the nice and the nasty ones. You have gardens spread across two floors to work with, conveniently located below the diner area. Visitors and guests are not uncommon, but your main contact will be with the Chef, your closest colleague.<br>\
	<br>\
	Your first and primary responsibility aboard eris, is as a farmer. The gardens contain all of the seeds, tools and fertilisers you need to grow crops and feed the station. Ensure a good variety of raw vegetables, and plenty of core grains like rice and wheat.<br>\
	<br>\
	Your second duty is as a rancher, if you have the talents. The lower garden contains a few rooms that are suitable for use as a sort of stable or paddock, in general the whole area is quite pleasant for animal life to roam around in, and comes with a few chickens plus a cow to start you off. More animals can be imported through the guild, allowing you to create a little oasis of life in a dark and gritty universe.<br>\
	<br>\
	Your third responsibility is much less savory. Eris is an old ship, ancient, rusty, and teeming with life. The maintenance corridors are infested with an invasive fungal species, affectionately termed Fungo d'Artigliero, by some botanist before your time. These mushrooms grow through burrows around the ship and wreak havoc, spraying chemicals around. Dealing with them - as well as any other invasive flora -  primarily falls to you, although this is a task that you may wish to hire some assistants to help out with.<br>\
	<br>\
	The shovels and hatchets in your garden provide the basic tools you'll need for these tasks, but you should always be on the lookout for more advanced equipment. A chainsaw or flamethrower would both be exceptionally useful tools for aggresive plant management"
*/
	duties = "WIP"/*"Grow food for the chef to feed the station<br>\
		Raise animals for eggs, meat and recreation<br>\
		Manage invasive flora around the ship, and cut out mushroom infestations"*/

	setup_restricted = TRUE

/obj/landmark/join/start/hydro
	name = "Gardener"
	icon_state = "player-black"
	join_tag = /datum/job/hydro


/datum/job/janitor
	title = "Janitor"
	flag = JANITOR
	department = DEPARTMENT_CHURCH
	department_flag = CHURCH
	faction = "CEV Eris"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Neotheology Preacher"
	selection_color = "#ecd37d"
	//alt_titles = list("Custodian","Sanitation Technician")
	also_known_languages = list(LANGUAGE_CYRILLIC = 15, LANGUAGE_JIVE = 80)
	cruciform_access = list(access_janitor, access_maint_tunnels, access_morgue, access_crematorium)
	wage = WAGE_PROFESSIONAL
	outfit_type = /decl/hierarchy/outfit/job/church/janitor

	stat_modifiers = list(
		STAT_ROB = 10,
		STAT_BIO = 10,
	)

	software_on_spawn = list(/datum/computer_file/program/camera_monitor)

	description = "WIP"/*"The lowly janitor. Probably the worst paid and least respected role on the ship. Everyone overlooks you, until they need you. And need you they shall. When someone stumbles down the hallway bleeding from every orifice, you get to clean it up.<br>\
	<br>\
	Armed with your trusty janicart full of cleaning supplies, you trundle around the ship mopping up blood, and spraying away oil. Cleaning is obviously your first and foremost duty. Wherever there's dirt, rubble, bloodstains, trash and chemical spills, you should be there to clean it up. Monster corpses are also a bit of a problem to dispose of. The roaches should be taken up to chemistry, where they can be processed for chemical purposes. Others should generally be shoved down a disposal chute, let the guild sort it out from there.<br>\
	<br>\
	To note though, you should be careful when cleaning up a scene of violence - especially a murder. The Ironhammer investigative team will probably want to take samples of evidence before you destroy it all<br>\
	<br>\
	In addition to cleaning, you should also handle minor maintenance. Replacing lights, correcting broken vendors, replacing floor tiles, duct taping cracked walls and windows, etc. You're far from being one of the Technomancers, but you can handle small problems if they're busy<br>\
	<br>\
	Lastly, your custodial closet contains quite a few traps, large and small. Deploying these carefully around maintenance - and especially ontop of burrows, may help remove a few roaches from the ship. Treasure those traps, as producing more is not so easy."
*/
	duties = "WIP"/*"		Clean blood, dirt, rubble and messes. Pickup trash and dispose of monster corpses<br>\
		Conduct minor repairs and maintenance when technomancers aren't available<br>\
		Deploy traps on burrows to keep nasty creatures at bay"*/

	setup_restricted = TRUE

/obj/landmark/join/start/janitor
	name = "Janitor"
	icon_state = "player-black"
	join_tag = /datum/job/janitor