//Food
/datum/job/bartender
	title = "Bartender"
	flag = BARTENDER
	department = "Civilian"
	department_flag = SERVICE
	faction = "CEV Eris"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the First Officer"
	selection_color = "#dddddd"
	also_known_languages = list(LANGUAGE_CYRILLIC = 25)
	access = list(access_hydroponics, access_bar, access_kitchen)

	stat_modifers = list(
		STAT_ROB = 10,
	)

	outfit_type = /decl/hierarchy/outfit/job/service/bartender

/obj/landmark/join/start/bartender
	name = "Bartender"
	icon_state = "player-grey"
	join_tag = /datum/job/bartender


/datum/job/chef
	title = "Chef"
	flag = CHEF
	department = "Civilian"
	department_flag = SERVICE
	faction = "CEV Eris"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the First Officer"
	selection_color = "#dddddd"
	also_known_languages = list(LANGUAGE_CYRILLIC = 15)
	access = list(access_hydroponics, access_bar, access_kitchen)

	outfit_type = /decl/hierarchy/outfit/job/service/chef

/obj/landmark/join/start/chef
	name = "Chef"
	icon_state = "player-grey"
	join_tag = /datum/job/chef



/datum/job/hydro
	title = "Gardener"
	flag = BOTANIST
	department = "Civilian"
	department_flag = SERVICE
	faction = "CEV Eris"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the First Officer"
	selection_color = "#dddddd"
	//alt_titles = list("Hydroponicist")
	also_known_languages = list(LANGUAGE_CYRILLIC = 15)
	access = list(access_hydroponics, access_bar, access_kitchen)

	outfit_type = /decl/hierarchy/outfit/job/service/gardener

	stat_modifers = list(
		STAT_BIO = 10,
		STAT_TGH = 10,
		STAT_ROB = 20,
	)


/obj/landmark/join/start/hydro
	name = "Gardener"
	icon_state = "player-grey"
	join_tag = /datum/job/hydro


/datum/job/actor
	title = "Actor"
	flag = ACTOR
	department = "Civilian"
	department_flag = SERVICE
	faction = "CEV Eris"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the First Officer"
	selection_color = "#dddddd"
	also_known_languages = list(LANGUAGE_CYRILLIC = 15)
	access = list(access_maint_tunnels, access_theatre)

	outfit_type = /decl/hierarchy/outfit/job/service/actor/clown

	stat_modifers = list(
		STAT_TGH = 10,
		STAT_ROB = 20,
	)

	
	/*TODO: DEL THIS
	backpacks = list(
		/obj/item/weapon/storage/backpack/clown,\
		/obj/item/weapon/storage/backpack/satchel_norm,\
		/obj/item/weapon/storage/backpack/satchel
		)
	*/

/obj/landmark/join/start/actor
	name = "Actor"
	icon_state = "player-grey"
	join_tag = /datum/job/actor


/datum/job/janitor
	title = "Janitor"
	flag = JANITOR
	department = "Civilian"
	department_flag = SERVICE
	faction = "CEV Eris"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the First Officer"
	selection_color = "#dddddd"
	//alt_titles = list("Custodian","Sanitation Technician")
	also_known_languages = list(LANGUAGE_CYRILLIC = 15)
	access = list(access_janitor, access_maint_tunnels)

	outfit_type = /decl/hierarchy/outfit/job/service/janitor

	stat_modifers = list(
		STAT_ROB = 10,
	)

	software_on_spawn = list(
							 /datum/computer_file/program/camera_monitor)

/obj/landmark/join/start/janitor
	name = "Janitor"
	icon_state = "player-grey"
	join_tag = /datum/job/janitor
