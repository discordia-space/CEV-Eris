//Due to how large this one is it gets its own file
/datum/job/chaplain
	title = "Cyberchristian Preacher"
	flag = CHAPLAIN
	department = "Civilian"
	department_flag = CHURCH
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the NeoTheology Church and God"
	selection_color = "#ecd37d"
	also_known_languages = list(LANGUAGE_CYRILLIC = 15)
	access = list(access_morgue, access_chapel_office, access_crematorium, access_maint_tunnels)

	outfit_type = /decl/hierarchy/outfit/job/chaplain	

	stat_modifers = list(
		STAT_TGH = 10,
	)

	software_on_spawn = list(/datum/computer_file/program/records,
							 /datum/computer_file/program/reports)

/obj/landmark/join/start/chaplain
	name = "Cyberchristian Preacher"
	icon_state = "player-black"
	join_tag = /datum/job/chaplain
