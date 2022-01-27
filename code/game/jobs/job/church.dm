/datum/job/chaplain
	title = "NeoTheology Preacher"
	flag = CHAPLAIN
	head_position = 1
	department = DEPARTMENT_CHURCH
	department_flag = CHURCH | COMMAND
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the NeoTheology Church"
	selection_color = "#ecd37d"
	also_known_languages = list(LANGUAGE_LATIN = 100)
	security_clearance = CLEARANCE_CLERGY
	cruciform_access = list(
		access_morgue, access_chapel_office, access_crematorium, access_hydroponics, access_janitor, access_maint_tunnels
	)

	access = list(
		access_RC_announce, access_keycard_auth, access_heads, access_sec_doors, access_change_nt
	)

	wage = WAGE_PROFESSIONAL // The69oney of the soul is faith, and cold hard cash
	department_account_access = TRUE
	outfit_type = /decl/hierarchy/outfit/job/church/chaplain

	stat_modifiers = list(
		STAT_TGH = 10,
		STAT_ROB = 20,
		STAT_VIG = 15,
		STAT_COG = 20,
	)

	perks = list(/datum/perk/channeling)

	software_on_spawn = list(/datum/computer_file/program/records,
							 /datum/computer_file/program/reports)

	core_upgrades = list(
		CRUCIFORM_PRIEST,
		CRUCIFORM_REDLIGHT
	)

	description = "You are the head of a local branch of the Church of NeoTheology. You represent the church's interests aboard Eris, as well as the interests of the NT disciples among the crew, who can be identified by the Cruciform implant upon their breast. The church is a69ajor contributor to the funding of Eris'69ission, and demands respect<br>\
	<br>\
	Your duties aboard the ship69ay not seem so important to its69ission, but they have greater significance in the galaxy as a whole. As well as a69ore immediate significance to the69orale of the crew, especially the followers of NeoTheology.<br>\
	<br>\
	Sometimes the Church will deploy In69uisitors to remote outposts like this, to serve its interests. When one is on Eris, you will generally be their point of contact. In69uisitors outrank you and you should follow all of their instructions without 69uestion. In69uisitors work in secret, and so you should not discuss their presence with anyone unless they permit it.<br>\
	<br>\
	First and foremost, you are a69an of the Cloth, and as such you69ust tend to the spiritual needs of the crew. Those looking to convert to NT should come to you for the rites, and the cruciform.<br>\
	When the69ood is dour, when all hope is lost, it falls to you to be a spiritual leader. Preach to the flock, inspire faith and strength in their hearts. The rituals in your book can also offer69ore tangible assistance in labour and combat.<br>\
	Even when times are bright, do your best to keep it that way. Tour the ship, offering support to those in need. A prayer in the right ear, a helping hand, or a shoulder to cry on, can do wonders. And people are69ost69ulnerable to conversion when they are at their weakest.<br>\
	<br>\
	When the living are tended to, your next duty is to the dead. <br>\
	The church holds exclusive patents on cloning technology, utilising the Cruciform implanted in each of its disciples as a Cortical Stack, storing a backup of the host's69emories and personality - their soul, if you will. When one of the faithful suffers an untimely demise, it is your sacred duty to grow a new69essel and transplant their soul into it, restoring them to life. Immortality is the reward of the faithful.<br>\
	<br>\
	For those who are not part of the fold, the next best thing you can offer is a dignified funeral. The chapel area contains coffins and69achinery to commit the dead unto the69oid. Burial at space. Any player who is given a proper funeral will have their respawn time reduced, allowing them to rejoin the crew as a new character69ore 69uickly, after death."


	duties = "Represent the interests of NT disciples aboard Eris. Protect them from persecution and speak for them.<br>\
		Hold69ass, give sermons, preach to the faithful, and lead group ritual sessions.<br>\
		Recover and clone the faithful dead.<br>\
		Hold funerals for the dead heathens."

	setup_restricted = TRUE

/obj/landmark/join/start/chaplain
	name = "NeoTheology Preacher"
	icon_state = "player-black"
	join_tag = /datum/job/chaplain

/datum/job/acolyte
	title = "NeoTheology Acolyte"
	flag = ACOLYTE
	department = DEPARTMENT_CHURCH
	department_flag = CHURCH
	faction = "CEV Eris"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the NeoTheology Preacher"
	selection_color = "#ecd37d"
	also_known_languages = list(LANGUAGE_LATIN = 100)
	security_clearance = CLEARANCE_COMMON
	cruciform_access = list(access_morgue, access_crematorium, access_maint_tunnels, access_hydroponics)
	wage = WAGE_PROFESSIONAL // The69oney of the soul is faith, and cold hard cash
	outfit_type = /decl/hierarchy/outfit/job/church/acolyte

	stat_modifiers = list(
		STAT_VIG = 15,
		STAT_TGH = 15,
		STAT_ROB = 15,
		STAT_COG = 10,
	)

	core_upgrades = list(
		CRUCIFORM_ACOLYTE
	)

	description = "You serve the NeoTheology Preacher as a disciple of the Faith.<br>\
	<br>\
	The sacred duties of operating the bioreactor and69anaging biomass for the church's holy cloner falls to you.<br>\
	<br>\
	Though69ore69ay be re69uired of you, should your Preacher so chose."

	duties = "Operate the bioreactor to create power.<br>\
	Manage the distribution of biomatter.<br>\
	Serve the Preacher's will."

	setup_restricted = TRUE

/obj/landmark/join/start/acolyte
	name = "NeoTheology Acolyte"
	icon_state = "player-black"
	join_tag = /datum/job/acolyte

/datum/job/hydro
	title = "NeoTheology Agrolyte"
	flag = BOTANIST
	department = DEPARTMENT_CHURCH
	department_flag = CHURCH
	faction = "CEV Eris"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the NeoTheology Preacher"
	selection_color = "#ecd37d"
	//alt_titles = list("Hydroponicist")
	also_known_languages = list(LANGUAGE_LATIN = 100)
	security_clearance = CLEARANCE_COMMON
	cruciform_access = list(access_hydroponics, access_morgue, access_crematorium, access_maint_tunnels)
	wage = WAGE_PROFESSIONAL // The69oney of the soul is faith, and cold hard cash

	outfit_type = /decl/hierarchy/outfit/job/church/gardener
	stat_modifiers = list(
		STAT_BIO = 20,
		STAT_TGH = 10,
		STAT_ROB = 10,
		STAT_COG = 10,
	)

	core_upgrades = list(
		CRUCIFORM_AGROLYTE
	)

	perks = list(/datum/perk/greenthumb)

	description = "You are the holy cultivator of the church's plants, and assist in the production of biomatter. All duties of plant growth fall to you,69aking your role critical.<br>\
	<br>\
	Though the church is your primary concern, as you are a disciple of its faith,69any others aboard the ship rely upon your work as well. The crew re69uires food, and the club69anager seeks to provide. Though the69anager cannot69ake food without fresh produce grown from the church's holy garden.<br>\
	<br>\
	Thus, out of good will, the Church provides produce to the69anager, as well as the crew. And perhaps in time earn the favor of new converts."

	duties = "Grow plants for use as biomatter.<br>\
	Provide fresh produce.<br>\
	Serve the Faith."

	setup_restricted = TRUE

/obj/landmark/join/start/hydro
	name = "NeoTheology Agrolyte"
	icon_state = "player-black"
	join_tag = /datum/job/hydro

/datum/job/janitor
	title = "NeoTheology Custodian"
	flag = JANITOR
	department = DEPARTMENT_CHURCH
	department_flag = CHURCH
	faction = "CEV Eris"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the NeoTheology Preacher"
	selection_color = "#ecd37d"
	//alt_titles = list("Custodian","Sanitation Technician")
	also_known_languages = list(LANGUAGE_LATIN = 100)
	security_clearance = CLEARANCE_COMMON
	cruciform_access = list(access_janitor, access_maint_tunnels, access_morgue, access_crematorium)
	wage = WAGE_PROFESSIONAL // The69oney of the soul is faith, and cold hard cash
	outfit_type = /decl/hierarchy/outfit/job/church/janitor

	stat_modifiers = list(
		STAT_ROB = 15,
		STAT_TGH = 10,
		STAT_VIG = 15,
		STAT_COG = 10,
	)

	core_upgrades = list(
		CRUCIFORM_CUSTODIAN
	)

	perks = list(/datum/perk/neat)

	software_on_spawn = list(/datum/computer_file/program/camera_monitor)

	description = "You are the Custodian, the church's disciple charged with keeping the corridors of not only the church clean, but that of the entire ship.<br>\
	<br>\
	While69ost ships employ a simple janitor, you are69uch69ore than that. Cleanliness is next to godliness, and so, the halls69ust remain clean. Though the ship is also infested with giant roaches and spiders, which69ay find their ways out from the69aintenance tunnels and into the69ain corridors where they conse69uently die.<br>\
	<br>\
	Though dead roaches and dead spiders, like you, are69ore than what they seem. Their corpses are useful for biomatter, both for the bioreactor and for the church's holy cloner. Thus in your duty to keep the halls clean, you also provide precious biomatter for the Church."

	duties = "Keep the hallways clean of blood, dirt, and bug carcasses.<br>\
	Serve the faith."

	setup_restricted = TRUE

/obj/landmark/join/start/janitor
	name = "NeoTheology Custodian"
	icon_state = "player-black"
	join_tag = /datum/job/janitor
