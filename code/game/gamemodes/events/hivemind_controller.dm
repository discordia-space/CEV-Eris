GLOBAL_LIST_INIT(hive_data_bool, list(
	"maximum_existing_mobs"			= FALSE, // Exact number set separately
	"spread_trough_burrows"			= TRUE,
	"spread_on_lower_z_level"		= TRUE, // Spread via wires "falling down" from higher z-level
	"teleport_core_when_damaged"	= TRUE,
	"allow_tyrant_spawn"			= TRUE,
	"tyrant_death_kills_hive"		= TRUE))

GLOBAL_LIST_INIT(hive_data_float, list(
	"maximum_controlled_areas"		= 0, // Stop expansion when controlling certain number of areas, 0 to disable
	"maximum_existing_mobs"			= 50, // Should be true in "hive_data_bool" to take effect, 0 means no hive mob spawn (except champions)
	"core_oddity_drop_chance"		= 50)) // prob() of hive node leaving hive-themed oddity on death

GLOBAL_LIST_INIT(hive_names, list("Von Neumann", "Lazarus", "Abattoir", "Auto-Surgeon", "NanoTrasen",
				"NanoNurse", "Vivisector", "Ex Costa", "Apostasy", "Gnosis", "Balaam", "Ophite",
				"Sarif", "VersaLife", "Slylandro", "SHODAN", "Pandora", "Fisto"))

GLOBAL_LIST_INIT(hive_surnames, list("Mk I", "Mk II", "Mk III", "Mk IV", "Mk V",
			"v0.9", "v1.0", "v1.1", "v2.0", "2418-B", "Open Beta",
			"Pre-Release", "Commercial Release", "Closed Alpha", "Hivebuilt"))

GLOBAL_LIST_EMPTY(hivemind_areas)
GLOBAL_LIST_EMPTY(hivemind_mobs)

GLOBAL_VAR_INIT(hivemind_panel, new /datum/hivemind_panel)


/datum/hivemind_panel
	var/_name // Remember what (sur)name user picked
	var/_surname


/datum/hivemind_panel/New()
	_name = pick(GLOB.hive_names)
	_surname = pick(GLOB.hive_surnames)


/datum/hivemind_panel/proc/mob_list_interact()
	var/data = "<table><tr><td>"
	for(var/i in GLOB.hivemind_mobs)
		data += "<br>[i] - [GLOB.hivemind_mobs[i]]."
	data += "</td></tr></table>"
	usr << browse(data, "window=hive_mob;size=600x600")


/datum/hivemind_panel/proc/area_list_interact()
	var/data = "<table><tr><td>"
	for(var/i in GLOB.hivemind_areas)
		data += "<br>[i] - [GLOB.hivemind_areas[i]] wireweed."
	data += "</td></tr></table>"
	usr << browse(data, "window=hive_area;size=600x600")


/datum/hivemind_panel/proc/main_interact()
	var/data = "<center><font size='3'><b>HIVEMIND PANEL v0.2</b></font></center>"
	data += "<table><tr><td><a href='?src=\ref[src];refresh=1'>\[REFRESH\]</a>"

	if(hive_mind_ai)
		data += "<br>Hivemind [hive_mind_ai.name] [hive_mind_ai.surname] is active."
		data += "<br>Evolution points: [hive_mind_ai.evo_points]"
		data += "<br>Evolution level: [hive_mind_ai.evo_level]"
		data += "<br>Nodes count: [hive_mind_ai.hives.len]"
		data += "<br>Areas count: [GLOB.hivemind_areas.len] \
		<a href='?src=\ref[src];area_list_interact=1'>\[DETAILS\]</a>"
		data += "<br>Mobs count: [GLOB.hivemind_mobs.len] \
		<a href='?src=\ref[src];mob_list_interact=1'>\[DETAILS\]</a>"
	else
		data += "<br>Hivemind is not active. Yet."
		data += "<br>Name: [_name] <a href='?src=\ref[src];set_name=1'>\[SET\]</a>"
		data += "<br>Surname: [_surname] <a href='?src=\ref[src];set_surname=1'>\[SET\]</a>"
	data += "<br><a href='?src=\ref[src];spawn_hive=1'>\[SPAWN\]</a>"
	data += "<br><a href='?src=\ref[src];kill_hive=1'>\[PURGE\]</a>"
	data += "<br><a href='?src=\ref[src];really_kill_hive=1'>\[HARDCORE PURGE\]</a>"

	if(GLOB.hive_data_bool["maximum_existing_mobs"])
		data += "<br>Controlled mob limit: [GLOB.hive_data_float["maximum_existing_mobs"]] \
		<a href='?src=\ref[src];toggle_mob_limit=1'>\[DISABLE\]</a>	\
		<a href='?src=\ref[src];set_mob_limit=1'>\[SET\]</a>"
	else
		data += "<br>Mob limit disabled.<a href='?src=\ref[src];toggle_mob_limit=1'>\[ENABLE\]</a>"

	if(GLOB.hive_data_float["maximum_controlled_areas"])
		data += "<br>Controlled area limit: [GLOB.hive_data_float["maximum_controlled_areas"]]"
	else
		data += "<br>Area limit disabled."
	data += "<a href='?src=\ref[src];set_area_limit=1'>\[SET\]</a>"

	data += "<br>Core oddity drop chance: [GLOB.hive_data_float["core_oddity_drop_chance"]] \
	<a href='?src=\ref[src];rig_gacha=1'>\[SET\]</a>"

	data += "<br>Spread trough burrows: [GLOB.hive_data_bool["spread_trough_burrows"] ? "Enabled" : "Disabled"] \
	<a href='?src=\ref[src];toggle_burrow=1'>\[TOGGLE\]</a>"

	data += "<br>Spread on z level below: [GLOB.hive_data_bool["spread_on_lower_z_level"] ? "Enabled" : "Disabled"] \
	<a href='?src=\ref[src];toggle_gravity_spread=1'>\[TOGGLE\]</a>"

	data += "<br>Teleport core when damaged: [GLOB.hive_data_bool["teleport_core_when_damaged"] ? "Enabled" : "Disabled"] \
	<a href='?src=\ref[src];toggle_core_teleportation=1'>\[TOGGLE\]</a>"

	data += "<br>Allow tyrant spawn: [GLOB.hive_data_bool["allow_tyrant_spawn"] ? "Enabled" : "Disabled"] \
	<a href='?src=\ref[src];toggle_tyrant_spawn=1'>\[TOGGLE\]</a>"

	data += "<br>Tyrant death kills hive: [GLOB.hive_data_bool["tyrant_death_kills_hive"] ? "Enabled" : "Disabled"] \
	<a href='?src=\ref[src];toggle_tyrant_gameover=1'>\[TOGGLE\]</a>"

	data += "</td></tr></table>"
	usr << browse(data, "window=hive_main;size=600x600")


/datum/hivemind_panel/Topic(href,href_list)
	if(!check_rights(R_FUN))
		return

	if(href_list["mob_list_interact"])
		mob_list_interact()

	if(href_list["area_list_interact"])
		area_list_interact()

	if(href_list["toggle_mob_limit"])
		GLOB.hive_data_bool["maximum_existing_mobs"] = !GLOB.hive_data_bool["maximum_existing_mobs"]

	if(href_list["set_mob_limit"])
		var/cap = input(usr, "When number of hivemind mobs exceed that number, new mobs won't be created", "Hivemind mob limit") as null|num
		GLOB.hive_data_float["maximum_existing_mobs"] = CLAMP(cap ? cap : 0, 0, 500)

	if(href_list["set_area_limit"])
		var/cap = input(usr, "Hivemind will halt expansion when spread over set number of areas, 0 to disable", "Hivemind area limit") as null|num
		GLOB.hive_data_float["maximum_controlled_areas"] = CLAMP(cap ? cap : 0, 0, 100)

	if(href_list["rig_gacha"])
		var/percent = input(usr, "Percentage probability of hive node dropping oddity on destruction", "Rigging gacha") as null|num
		GLOB.hive_data_float["core_oddity_drop_chance"] = CLAMP(percent ? percent : 0, 0, 100)

	if(href_list["set_name"])
		var/name = input(usr, "Choose wisely", "Hivemind name") as null|anything in GLOB.hive_names
		if(name)
			_name = name

	if(href_list["set_surname"])
		var/surname = input(usr, "Choose wisely", "Hivemind surname") as null|anything in GLOB.hive_surnames
		if(surname)
			_surname = surname

	if(href_list["spawn_hive"])
		var/turf/wrong_place_to_be_in
		var/choice = alert(usr, "Spawn where?", "Commencing adminbuse", "Current location", "Coordinates", "Cancel")
		switch(choice)
			if("Current location")
				wrong_place_to_be_in = get_turf(usr)
			if("Coordinates")
				wrong_place_to_be_in = locate(
					input(usr, "Enter X coordinate", "Commencing adminbuse") as null|num,
					input(usr, "Enter Y coordinate", "Commencing adminbuse") as null|num,
					input(usr, "Enter Z coordinate", "Commencing adminbuse") as null|num)
		if(wrong_place_to_be_in)
			message_admins("Hivemind spawned at \the [jumplink(wrong_place_to_be_in)] by [usr.ckey]")
			new /obj/machinery/hivemind_machine/node(wrong_place_to_be_in, _name, _surname)

	if(href_list["kill_hive"])
		if(hive_mind_ai)
			hive_mind_ai.die()
			message_admins("Hivemind purge initiated by [usr.ckey], hive mobs and structures will die out shortly.")

	if(href_list["really_kill_hive"])
		message_admins("Hivemind deleted by [usr.ckey].")
		for(var/obj/machinery/hivemind_machine/i in world)
			i.destruct()
		for(var/obj/effect/plant/hivemind/i in world)
			i.Destroy()
		for(var/mob/living/simple_animal/hostile/hivemind/i in world)
			i.death()
		GLOB.hivemind_mobs	= list()
		GLOB.hivemind_areas	= list()

	if(href_list["toggle_burrow"])
		GLOB.hive_data_bool["spread_trough_burrows"] = !GLOB.hive_data_bool["spread_trough_burrows"]

	if(href_list["toggle_gravity_spread"])
		GLOB.hive_data_bool["spread_on_lower_z_level"] = !GLOB.hive_data_bool["spread_on_lower_z_level"]

	if(href_list["toggle_core_teleportation"])
		GLOB.hive_data_bool["teleport_core_when_damaged"] = !GLOB.hive_data_bool["teleport_core_when_damaged"]

	if(href_list["toggle_tyrant_spawn"])
		GLOB.hive_data_bool["allow_tyrant_spawn"] = !GLOB.hive_data_bool["allow_tyrant_spawn"]

	if(href_list["toggle_tyrant_gameover"])
		GLOB.hive_data_bool["tyrant_death_kills_hive"] = !GLOB.hive_data_bool["tyrant_death_kills_hive"] 

	main_interact()
