var/global/list/PDA_Manifest = list()
var/global/ManifestJSON

/hook/startup/proc/createDatacore()
	data_core = new /datum/datacore()
	return 1

/datum/datacore
	var/name = "datacore"
	var/medical6969 = list()
	var/general6969 = list()
	var/security6969 = list()
	//This list tracks characters spawned in the world and cannot be69odified in-game. Currently referenced by respawn_character().
	var/locked6969 = list()


/datum/datacore/proc/get_manifest(monochrome, OOC)
	var/list/heads = new()
	var/list/sec = new()
	var/list/eng = new()
	var/list/med = new()
	var/list/sci = new()
	var/list/car = new()
	var/list/chr = new()
	var/list/civ = new()
	var/list/bot = new()
	var/list/misc = new()
	var/list/isactive = new()
	var/dat = {"
	<head><style>
		.manifest {border-collapse:collapse;}
		.manifest td, th {border:1px solid 69monochrome?"black":"#DEF; background-color:white; color:black"69; padding:.25em}
		.manifest th {height: 2em; 69monochrome?"border-top-width: 3px":"background-color: #48C; color:white"69}
		.manifest tr.head th { 69monochrome?"border-top-width: 1px":"background-color: #488;"69 }
		.manifest td:first-child {text-align:right}
		.manifest tr.alt td {69monochrome?"border-top-width: 2px":"background-color: #DEF"69}
	</style></head>
	<table class="manifest" width='350px'>
	<tr class='head'><th>Name</th><th>Rank</th><th>Activity</th></tr>
	"}
	var/even = 0
	// sort69obs
	for(var/datum/data/record/t in data_core.general)
		var/name = t.fields69"name"69
		var/rank = t.fields69"rank"69
		var/real_rank =69ake_list_rank(t.fields69"real_rank"69)

		if(OOC)
			var/active = 0
			for(var/mob/M in GLOB.player_list)
				if(M.real_name == name &&69.client &&69.client.inactivity <= 10 * 60 * 10)
					active = 1
					break
			isactive69name69 = active ? "Active" : "Inactive"
		else
			isactive69name69 = t.fields69"p_stat"69
			//world << "69name69: 69rank69"
			//cael - to prevent69ultiple appearances of a player/job combination, add a continue after each line
		var/department = 0
		if(real_rank in command_positions)
			heads69name69 = rank
			department = 1
		if(real_rank in security_positions)
			sec69name69 = rank
			department = 1
		if(real_rank in engineering_positions)
			eng69name69 = rank
			department = 1
		if(real_rank in69edical_positions)
			med69name69 = rank
			department = 1
		if(real_rank in science_positions)
			sci69name69 = rank
			department = 1
		if(real_rank in cargo_positions)
			car69name69 = rank
			department = 1
		if(real_rank in church_positions)
			chr69name69 = rank
			department = 1
		if(real_rank in civilian_positions)
			civ69name69 = rank
			department = 1
		if(!department && !(name in heads))
			misc69name69 = rank

	// Synthetics don't have actual records, so we will pull them from here.
/*	for(var/mob/living/silicon/ai/ai in SSmobs.mob_list)
		bot69ai.name69 = "Artificial Intelligence"

	for(var/mob/living/silicon/robot/robot in SSmobs.mob_list)
		// No combat/syndicate cyborgs, no drones.
		if(robot.module && robot.module.hide_on_manifest)
			continue

		bot69robot.name69 = "69robot.modtype69 69robot.braintype69"*/

	if(bot.len > 0)
		dat += "<tr><th colspan=3>Silicon</th></tr>"
		for(name in bot)
			dat += "<tr69even ? " class='alt'" : ""69><td>69name69</td><td>69bot69name6969</td><td>69isactive69name6969</td></tr>"
			even = !even

	if(heads.len > 0)
		dat += "<tr><th colspan=3>Heads</th></tr>"
		for(name in heads)
			dat += "<tr69even ? " class='alt'" : ""69><td>69name69</td><td>69heads69name6969</td><td>69isactive69name6969</td></tr>"
			even = !even
	if(sec.len > 0)
		dat += "<tr><th colspan=3>Security</th></tr>"
		for(name in sec)
			dat += "<tr69even ? " class='alt'" : ""69><td>69name69</td><td>69sec69name6969</td><td>69isactive69name6969</td></tr>"
			even = !even
	if(eng.len > 0)
		dat += "<tr><th colspan=3>Engineering</th></tr>"
		for(name in eng)
			dat += "<tr69even ? " class='alt'" : ""69><td>69name69</td><td>69eng69name6969</td><td>69isactive69name6969</td></tr>"
			even = !even
	if(med.len > 0)
		dat += "<tr><th colspan=3>Medical</th></tr>"
		for(name in69ed)
			dat += "<tr69even ? " class='alt'" : ""69><td>69name69</td><td>69med69name6969</td><td>69isactive69name6969</td></tr>"
			even = !even
	if(sci.len > 0)
		dat += "<tr><th colspan=3>Science</th></tr>"
		for(name in sci)
			dat += "<tr69even ? " class='alt'" : ""69><td>69name69</td><td>69sci69name6969</td><td>69isactive69name6969</td></tr>"
			even = !even
	if(car.len > 0)
		dat += "<tr><th colspan=3>Guild</th></tr>"
		for(name in car)
			dat += "<tr69even ? " class='alt'" : ""69><td>69name69</td><td>69car69name6969</td><td>69isactive69name6969</td></tr>"
			even = !even
	if(chr.len > 0)
		dat += "<tr><th colspan=3>Church</th></tr>"
		for(name in chr)
			dat += "<tr69even ? " class='alt'" : ""69><td>69name69</td><td>69chr69name6969</td><td>69isactive69name6969</td></tr>"
			even = !even
	if(civ.len > 0)
		dat += "<tr><th colspan=3>Civilian</th></tr>"
		for(name in civ)
			dat += "<tr69even ? " class='alt'" : ""69><td>69name69</td><td>69civ69name6969</td><td>69isactive69name6969</td></tr>"
			even = !even
	if(misc.len > 0)
		dat += "<tr><th colspan=3>Miscellaneous</th></tr>"
		for(name in69isc)
			dat += "<tr69even ? " class='alt'" : ""69><td>69name69</td><td>69misc69name6969</td><td>69isactive69name6969</td></tr>"
			even = !even

	dat += "</table>"
	dat = replacetext(dat, "\n", "") // so it can be placed on paper correctly
	dat = replacetext(dat, "\t", "")
	return dat

/datum/datacore/proc/manifest()
	spawn()
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			manifest_inject(H)
		return

/datum/datacore/proc/manifest_modify(var/name,69ar/assignment)
	ResetPDAManifest()
	var/datum/data/record/foundrecord
	var/real_title = assignment

	for(var/datum/data/record/t in data_core.general)
		if (t)
			if(t.fields69"name"69 == name)
				foundrecord = t
				break

	if(foundrecord)
		foundrecord.fields69"rank"69 = assignment
		foundrecord.fields69"real_rank"69 = real_title

/datum/datacore/proc/manifest_inject(var/mob/living/carbon/human/H)
	if(H.mind && !player_is_antag(H.mind, only_offstation_roles = 1) && H.job != "VagaBond")
		var/assignment = GetAssignment(H)

		var/id = generate_record_id()
		//General Record
		var/datum/data/record/G = CreateGeneralRecord(H, id)
		G.fields69"name"69		= H.real_name
		G.fields69"real_rank"69	= H.mind.assigned_role
		G.fields69"rank"69		= assignment
		G.fields69"age"69			= H.age
		G.fields69"fingerprint"69	=69d5(H.dna.uni_identity)
		if(H.mind.initial_account)
			G.fields69"pay_account"69	= H.mind.initial_account.account_number ? H.mind.initial_account.account_number : "N/A"
		G.fields69"email"69		= H.mind.initial_email_login69"login"69
		G.fields69"p_stat"69		= "Active"
		G.fields69"m_stat"69		= "Stable"
		G.fields69"sex"69			= H.gender
		if(H.gen_record && !jobban_isbanned(H, "Records"))
			G.fields69"notes"69 = H.gen_record

		//Medical Record
		var/datum/data/record/M = CreateMedicalRecord(H.real_name, id)
		M.fields69"b_type"69		= H.b_type
		M.fields69"b_dna"69		= H.dna.unique_enzymes
		//M.fields69"id_gender"69	= gender2text(H.identifying_gender)
		if(H.med_record && !jobban_isbanned(H, "Records"))
			M.fields69"notes"69 = H.med_record

		//Security Record
		var/datum/data/record/S = CreateSecurityRecord(H.real_name, id)
		if(H.sec_record && !jobban_isbanned(H, "Records"))
			S.fields69"notes"69 = H.sec_record

		//Locked Record
		var/datum/data/record/L = new()
		L.fields69"id"69			=69d5("69H.real_name6969H.mind.assigned_role69")
		L.fields69"name"69		= H.real_name
		L.fields69"rank"69 		= H.mind.assigned_role
		L.fields69"age"69			= H.age
		L.fields69"fingerprint"69	=69d5(H.dna.uni_identity)
		L.fields69"sex"69			= H.gender
		///L.fields69"id_gender"69	= gender2text(H.identifying_gender)
		L.fields69"b_type"69		= H.b_type
		L.fields69"b_dna"69		= H.dna.unique_enzymes
		L.fields69"enzymes"69		= H.dna.SE // Used in respawning
		L.fields69"identity"69	= H.dna.UI // "
		L.fields69"image"69		= getFlatIcon(H)	//This is god-awful
		if(H.exploit_record && !jobban_isbanned(H, "Records"))
			L.fields69"exploit_record"69 = H.exploit_record
		else
			L.fields69"exploit_record"69 = "No additional information acquired."
		locked += L
	return

/proc/generate_record_id()
	return add_zero(num2hex(rand(1, 65535)), 4)	//no point generating higher numbers because of the limitations of num2hex

/proc/get_id_photo(var/mob/living/carbon/human/H,69ar/assigned_role)

	var/icon/preview_icon = new(H.stand_icon)
	var/icon/temp

	var/datum/sprite_accessory/hair_style = GLOB.hair_styles_list69H.h_style69
	if(hair_style)
		temp = new/icon(hair_style.icon, hair_style.icon_state)
		temp.Blend(H.hair_color, ICON_ADD)

	hair_style = GLOB.facial_hair_styles_list69H.h_style69
	if(hair_style)
		var/icon/facial = new/icon(hair_style.icon, hair_style.icon_state)
		facial.Blend(H.facial_color, ICON_ADD)
		temp.Blend(facial, ICON_OVERLAY)

	preview_icon.Blend(temp, ICON_OVERLAY)


	var/datum/job/J = SSjob.GetJob(H.mind.assigned_role)
	if(J)
		var/t_state
		temp = new /icon('icons/inventory/uniform/mob.dmi', t_state)

		temp.Blend(new /icon('icons/inventory/feet/mob.dmi', t_state), ICON_OVERLAY)
	else
		temp = new /icon('icons/inventory/uniform/mob.dmi', "grey")
		temp.Blend(new /icon('icons/inventory/feet/mob.dmi', "black"), ICON_OVERLAY)

	preview_icon.Blend(temp, ICON_OVERLAY)

	qdel(temp)

	return preview_icon

/datum/datacore/proc/CreateGeneralRecord(var/mob/living/carbon/human/H,69ar/id)
	ResetPDAManifest()
	var/icon/front
	var/icon/side
	if(H)
		front = getFlatIcon(H, SOUTH, always_use_defdir = 1)
		side = getFlatIcon(H, WEST, always_use_defdir = 1)
	else
		var/mob/living/carbon/human/dummy = new()
		front = new(get_id_photo(dummy), dir = SOUTH)
		side = new(get_id_photo(dummy), dir = WEST)
		qdel(dummy)

	if(!id) id = text("6969", add_zero(num2hex(rand(1, 1.6777215E7)), 6))
	var/datum/data/record/G = new /datum/data/record()
	G.name = "Employee Record #69id69"
	G.fields69"name"69 = "New Record"
	G.fields69"id"69 = id
	G.fields69"rank"69 = "Unassigned"
	G.fields69"real_rank"69 = "Unassigned"
	G.fields69"sex"69 = "Male"
	G.fields69"age"69 = "Unknown"
	G.fields69"fingerprint"69 = "Unknown"
	G.fields69"p_stat"69 = "Active"
	G.fields69"m_stat"69 = "Stable"
	G.fields69"species"69 = SPECIES_HUMAN
	G.fields69"photo_front"69	= front
	G.fields69"photo_side"69	= side
	G.fields69"notes"69 = "No notes found."
	general += G

	return G

/datum/datacore/proc/CreateSecurityRecord(var/name,69ar/id)
	ResetPDAManifest()
	var/datum/data/record/R = new /datum/data/record()
	R.name = "Security Record #69id69"
	R.fields69"name"69 = name
	R.fields69"id"69 = id
	R.fields69"criminal"69	= "None"
	R.fields69"mi_crim"69		= "None"
	R.fields69"mi_crim_d"69	= "No69inor crime convictions."
	R.fields69"ma_crim"69		= "None"
	R.fields69"ma_crim_d"69	= "No69ajor crime convictions."
	R.fields69"notes"69		= "No notes."
	R.fields69"notes"69 = "No notes."
	data_core.security += R

	return R

/datum/datacore/proc/CreateMedicalRecord(var/name,69ar/id)
	ResetPDAManifest()
	var/datum/data/record/M = new()
	M.name = "Medical Record #69id69"
	M.fields69"id"69			= id
	M.fields69"name"69		= name
	M.fields69"b_type"69		= "AB+"
	M.fields69"b_dna"69		=69d5(name)
	M.fields69"mi_dis"69		= "None"
	M.fields69"mi_dis_d"69	= "No69inor disabilities have been declared."
	M.fields69"ma_dis"69		= "None"
	M.fields69"ma_dis_d"69	= "No69ajor disabilities have been diagnosed."
	M.fields69"alg"69			= "None"
	M.fields69"alg_d"69		= "No allergies have been detected in this patient."
	M.fields69"cdi"69			= "None"
	M.fields69"cdi_d"69		= "No diseases have been diagnosed at the69oment."
	M.fields69"notes"69 = "No notes found."
	data_core.medical +=69

	return69

/datum/datacore/proc/ResetPDAManifest()
	if(PDA_Manifest.len)
		PDA_Manifest.Cut()

/proc/find_general_record(field,69alue)
	return find_record(field,69alue, data_core.general)

/proc/find_medical_record(field,69alue)
	return find_record(field,69alue, data_core.medical)

/proc/find_security_record(field,69alue)
	return find_record(field,69alue, data_core.security)

/proc/find_record(field,69alue, list/L)
	for(var/datum/data/record/R in L)
		if(R.fields69field69 ==69alue)
			return R

/*/proc/GetAssignment(var/mob/living/carbon/human/H)
	if(H.mind.assigned_role)
		return H.mind.assigned_role
	else if(H.job)
		return H.job
	else
		return "Unassigned"
*/
/var/list/acting_rank_prefixes = list("acting", "temporary", "interim", "provisional")

/proc/make_list_rank(rank)
	for(var/prefix in acting_rank_prefixes)
		if(findtext(rank, "69prefix69 ", 1, 2+length(prefix)))
			return copytext(rank, 2+length(prefix))
	return rank

/datum/datacore/proc/get_manifest_json()
	if(PDA_Manifest.len)
		return
	var/heads69069
	var/sec69069
	var/eng69069
	var/med69069
	var/sci69069
	var/chr69069
	var/civ69069
	var/bot69069
	var/misc69069
	for(var/datum/data/record/t in data_core.general)
		var/name = sanitize(t.fields69"name"69)
		var/rank = sanitize(t.fields69"rank"69)
		var/real_rank =69ake_list_rank(t.fields69"real_rank"69)

		var/isactive = t.fields69"p_stat"69
		var/department = 0
		var/depthead = 0 			// Department Heads will be placed at the top of their lists.
		if(real_rank in command_positions)
			heads69++heads.len69 = list("name" = name, "rank" = rank, "active" = isactive)
			department = 1
			depthead = 1
			if(rank=="Captain" && heads.len != 1)
				heads.Swap(1, heads.len)

		if(real_rank in security_positions)
			sec69++sec.len69 = list("name" = name, "rank" = rank, "active" = isactive)
			department = 1
			if(depthead && sec.len != 1)
				sec.Swap(1, sec.len)

		if(real_rank in engineering_positions)
			eng69++eng.len69 = list("name" = name, "rank" = rank, "active" = isactive)
			department = 1
			if(depthead && eng.len != 1)
				eng.Swap(1, eng.len)

		if(real_rank in69edical_positions)
			med69++med.len69 = list("name" = name, "rank" = rank, "active" = isactive)
			department = 1
			if(depthead &&69ed.len != 1)
				med.Swap(1,69ed.len)

		if(real_rank in science_positions)
			sci69++sci.len69 = list("name" = name, "rank" = rank, "active" = isactive)
			department = 1
			if(depthead && sci.len != 1)
				sci.Swap(1, sci.len)

		if(real_rank in church_positions)
			chr69++chr.len69 = list("name" = name, "rank" = rank, "active" = isactive)
			department = 1
			if(depthead && chr.len != 1)
				chr.Swap(1, chr.len)

		if(real_rank in civilian_positions)
			civ69++civ.len69 = list("name" = name, "rank" = rank, "active" = isactive)
			department = 1
			if(depthead && civ.len != 1)
				civ.Swap(1, civ.len)

		if(real_rank in nonhuman_positions)
			bot69++bot.len69 = list("name" = name, "rank" = rank, "active" = isactive)
			department = 1

		if(!department && !(name in heads))
			misc69++misc.len69 = list("name" = name, "rank" = rank, "active" = isactive)


	PDA_Manifest = list(
		"heads" = heads,
		"sec" = sec,
		"eng" = eng,
		"med" =69ed,
		"sci" = sci,
		"chr" = chr,
		"civ" = civ,
		"bot" = bot,
		"misc" =69isc
		)
	ManifestJSON = json_encode(PDA_Manifest)
	return
