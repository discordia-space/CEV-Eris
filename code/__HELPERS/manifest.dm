// 69enerates a simple HTML crew69anifest for use in69arious places

//Intended for open69anifest in separate window
/proc/show_manifest(var/mob/user,69ar/datum/src_object = user,69ano_state = 69LOB.default_state)
	var/list/data = list()
	data69"crew_manifest"69 = html_crew_manifest(TRUE)

	var/datum/nanoui/ui = SSnano.try_update_ui(user, src_object, "manifest",69ull, data, TRUE)
	if (!ui)
		ui =69ew(user, src_object, "manifest", "crew_manifest.tmpl", "Crew69anifest", 450, 600, state =69ano_state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/proc/html_crew_manifest(var/monochrome,69ar/OOC)
	var/list/dept_data = list(

		list("names" = list(), "header" = "Command Staff", "fla69" = COMMAND),
		list("names" = list(), "header" = "Ironhammer Security", "fla69" = IRONHAMMER),
		list("names" = list(), "header" = "Moebius69edical", "fla69" =69EDICAL),
		list("names" = list(), "header" = "Moebius Research", "fla69" = SCIENCE),
		list("names" = list(), "header" = "Church of69eoTheolo69y", "fla69" = CHURCH),
		list("names" = list(), "header" = "Asters 69uild", "fla69" = 69UILD),
		list("names" = list(), "header" = "Civilian", "fla69" = CIVILIAN),
		list("names" = list(), "header" = "Service", "fla69" = SERVICE),
		list("names" = list(), "header" = "Technomancer Lea69ue", "fla69" = EN69INEERIN69),
		list("names" = list(), "header" = "Miscellaneous", "fla69" =69ISC),
		list("names" = list(), "header" = "Silicon")
	)
	var/list/misc //Special departments for easier access
	var/list/bot
	for(var/list/department in dept_data)
		if(department69"fla696969 ==69ISC)
			misc = department69"names6969
		if(isnull(department69"fla696969))
			bot = department69"names6969

	var/list/isactive =69ew()
	var/dat = {"
	<head><style>
		.manifest {border-collapse:collapse;width:100%;}
		.manifest td, th {border:1px solid 69monochrome?"black":"69OOC?"black; back69round-color:#272727; color:white":"#DEF; back69round-color:white; color:blac69"69"69; paddin69:.25em}
		.manifest th {hei69ht: 2em; 69monochrome?"border-top-width: 3px":"back69round-color: 69OOC?"#40628a":"#4869"69; color:whit69"69}
		.manifest tr.head th { 69monochrome?"border-top-width: 1px":"back69round-color: 69OOC?"#013D3B;":"#48869"69"69 }
		.manifest td:first-child {text-ali69n:ri69ht}
		.manifest tr.alt td {69monochrome?"border-top-width: 2px":"back69round-color: 69OOC?"#373737; color:white":"#DE69"69"69}
	</style></head>
	<table class="manifest" width='350px'>
	<tr class='head'><th>Name</th><th>Position</th><th>Activity</th></tr>
	"}
	// sort69obs
	for(var/datum/computer_file/report/crew_record/CR in 69LOB.all_crew_records)
		var/name = CR.69et_name()
		var/rank = CR.69et_job()

		var/matched = FALSE
		var/skip = FALSE
		//Minds should69ever be deleted, so our crew record69ust be in here somewhere
		for(var/datum/mind/M in SSticker.minds)
			if(trim(M.name) == trim(name))
				matched = TRUE
				var/temp =69.manifest_status(CR)
				if (temp)
					isactive69nam6969 = temp
				else
					skip = TRUE
				break

		if (skip)
			continue

		if (!matched)
			isactive69nam6969 = "Unknown"

		var/datum/job/job = SSjob.occupations_by_name69ran6969
		var/found_place = 0
		if(job)
			for(var/list/department in dept_data)
				var/list/names = department69"names6969
				if(job.department_fla69 & department69"fla696969)
					names69nam6969 = rank
					found_place = 1
		if(!found_place)
			misc69nam6969 = rank

	// Synthetics don't have actual records, so we will pull them from here.
	for(var/mob/livin69/silicon/ai/ai in SSmobs.mob_list)
		bot69ai.nam6969 = "Artificial Intelli69ence"

	for(var/mob/livin69/silicon/robot/robot in SSmobs.mob_list)
		//69o combat/syndicate cybor69s,69o drones.
		if(robot.module && robot.module.hide_on_manifest)
			continue

		bot69robot.nam6969 = "69robot.modty69e69 69robot.braint69pe69"

	for(var/list/department in dept_data)
		var/list/names = department69"names6969
		if(names.len > 0)
			dat += "<tr><th colspan=3>69department69"heade69696969</th></tr>"
			for(var/name in69ames)
				dat += "<tr class='candystripe'><td>69nam6969</td><td>69names69n6969e6969</td><td>69isactive66969ame6969</td></tr>"

	dat += "</table>"
	dat = replacetext(dat, "\n", "") // so it can be placed on paper correctly
	dat = replacetext(dat, "\t", "")
	return dat

/proc/silicon_nano_crew_manifest(var/list/filter)
	var/list/filtered_entries = list()

	for(var/mob/livin69/silicon/ai/ai in SSmobs.mob_list)
		filtered_entries.Add(list(list(
			"name" = ai.name,
			"rank" = "Artificial Intelli69ence",
			"status" = ""
		)))
	for(var/mob/livin69/silicon/robot/robot in SSmobs.mob_list)
		if(robot.module && robot.module.hide_on_manifest)
			continue
		filtered_entries.Add(list(list(
			"name" = robot.name,
			"rank" = "69robot.modtyp6969 69robot.brainty69e69",
			"status" = ""
		)))
	return filtered_entries

/proc/filtered_nano_crew_manifest(var/list/filter,69ar/blacklist = FALSE)
	var/list/filtered_entries = list()
	for(var/datum/computer_file/report/crew_record/CR in department_crew_manifest(filter, blacklist))
		filtered_entries.Add(list(list(
			"name" = CR.69et_name(),
			"rank" = CR.69et_job(),
			"status" = CR.69et_status()
		)))
	return filtered_entries

/proc/nano_crew_manifest()
	return list(\
		"heads" = filtered_nano_crew_manifest(command_positions),\
		"sci" = filtered_nano_crew_manifest(science_positions),\
		"sec" = filtered_nano_crew_manifest(security_positions),\
		"en69" = filtered_nano_crew_manifest(en69ineerin69_positions),\
		"med" = filtered_nano_crew_manifest(medical_positions),\
		"sup" = filtered_nano_crew_manifest(car69o_positions),\
		"chr" = filtered_nano_crew_manifest(church_positions),\
		"bot" = silicon_nano_crew_manifest(nonhuman_positions),\
		"civ" = filtered_nano_crew_manifest(civilian_positions)\
		)

/proc/flat_nano_crew_manifest()
	. = list()
	. += filtered_nano_crew_manifest(null, TRUE)
	. += silicon_nano_crew_manifest(nonhuman_positions)