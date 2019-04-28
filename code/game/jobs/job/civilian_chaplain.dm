//Due to how large this one is it gets its own file
/datum/job/chaplain
	title = "Neotheology Preacher"
	flag = CHAPLAIN
	department = DEPARTMENT_CHURCH
	department_flag = CHURCH
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the NeoTheology Church"
	selection_color = "#ecd37d"
	also_known_languages = list(LANGUAGE_CYRILLIC = 25, LANGUAGE_SERBIAN = 25)
	access = list(access_morgue, access_chapel_office, access_crematorium, access_maint_tunnels)
	wage = WAGE_PROFESSIONAL //The church has deep pockets
	department_account_access = TRUE
	outfit_type = /decl/hierarchy/outfit/job/chaplain

	stat_modifiers = list(
		STAT_TGH = 10,
		STAT_BIO = 15,
		STAT_VIG = 15,
		STAT_COG = 10,
	)

	software_on_spawn = list(/datum/computer_file/program/records,
							 /datum/computer_file/program/reports)

	description = "You are the head of a local branch of the Church of Neotheology. You represent the church's interests aboard Eris, as well as the interests of the NT disciples among the crew, who can be identified by the Cruciform implant upon their breast. The church is a major contributor to the funding of Eris' mission, and demands respect<br>\
	<br>\
	Your duties aboard the ship may not seem so important to its mission, but they have greater significance in the galaxy as a whole. As well as a more immediate significance to the morale of the crew, especially the followers of Neotheology.<br>\
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
		Recover and clone the faithful dead<br>\
		Hold funerals for the heathen dead"

/obj/landmark/join/start/chaplain
	name = "Neotheology Preacher"
	icon_state = "player-black"
	join_tag = /datum/job/chaplain
