// Contains everything related to earning research points
#define AUTOPSY_WEAPON_PAMT rand(1,5) * 20 // 50-100 points for random weapon
#define ARTIFACT_PAMT rand(5,10) * 1000 // 5000-10000 points for random artifact

GLOBAL_LIST_EMPTY(explosion_watcher_list)

/datum/experiment_data
	var/saved_best_explosion = 0

	var/static/list/tech_points = list(
		TECH_MATERIAL = 200,
		TECH_ENGINEERING = 250,
		TECH_PLASMA = 500,
		TECH_POWER = 300,
		TECH_BLUESPACE = 1000,
		TECH_BIO = 300,
		TECH_COMBAT = 500,
		TECH_MAGNET = 350,
		TECH_DATA = 400,
		TECH_COVERT = 5000,
	)

	// So we don't give points for researching69on-artifact item
	var/static/list/artifact_types = list(
		/obj/machinery/auto_cloner,
		/obj/machinery/power/supermatter,
		/obj/machinery/giga_drill,
//		/obj/mecha/working/hoverpod,
		/obj/machinery/replicator,
		/obj/machinery/artifact
	)

	var/list/saved_tech_levels = list() // list("materials" = list(1, 4, ...), ...)
	var/list/saved_autopsy_weapons = list()
	var/list/saved_artifacts = list()
	var/list/saved_symptoms = list()
	var/list/saved_slimecores = list()

	// Special point amount for autopsy weapons
	var/static/list/special_weapons = list(
		"large organic69eedle" = 10000,
		"Hulk Foot" = 10000,
		"Explosive blast" = 5000,
		"Electronics69eltdown" = 4000,
		"Low Pressure" = 3000,
		"Facepalm" = 2000,
	)
	// Points for each symptom level, from 1 to 5
	var/static/list/level_to_points = list(200,500,1000,2500,10000)
	// Points for special slime cores
	var/static/list/core_points = list(
		/obj/item/slime_extract/grey = 100,
		/obj/item/slime_extract/gold = 2000,
		/obj/item/slime_extract/adamantine = 3000,
		/obj/item/slime_extract/bluespace = 5000,
		/obj/item/slime_extract/rainbow = 10000
	)

/*
/datum/experiment_data/proc/ConvertRe69String2List(list/source_list)
	var/list/temp_list = params2list(source_list)
	for(var/O in temp_list)
		temp_list69O69 = text2num(temp_list69O69)
	return temp_list
*/
// TODO: unify this with do_research_object?
/datum/experiment_data/proc/get_object_research_value(obj/item/I, ignoreRepeat = FALSE)
	var/list/temp_tech = I.origin_tech
	var/item_tech_points = 0
	var/has_new_tech = FALSE
	var/is_board = istype(I, /obj/item/electronics/circuitboard)

	for(var/T in temp_tech)
		if(tech_points69T69)
			if(ignoreRepeat)
				item_tech_points += temp_tech69T69 * tech_points69T69
			else
				if(saved_tech_levels69T69 && (temp_tech69T69 in saved_tech_levels69T69)) // You only get a fraction of points if you researched items with this level already
					if(!is_board) // Boards are cheap to69ake so we don't give any points for repeats
						item_tech_points += temp_tech69T69 * tech_points69T69 * 0.1
				else
					item_tech_points += temp_tech69T69 * tech_points69T69
					has_new_tech = TRUE

	if(!ignoreRepeat && !has_new_tech) // We are deconstucting the same items, cut the reward really hard
		item_tech_points =69in(item_tech_points, 400)

	return round(item_tech_points)

/datum/experiment_data/proc/do_research_object(obj/item/I)
	var/list/temp_tech = I.origin_tech

	for(var/T in temp_tech)
		if(!saved_tech_levels69T69)
			saved_tech_levels69T69 = list()

		if(!(temp_tech69T69 in saved_tech_levels69T69))
			saved_tech_levels69T69 += temp_tech69T69



// Returns amount of research points received
/datum/experiment_data/proc/read_science_tool(obj/item/device/science_tool/I)
	var/points = 0

	for(var/weapon in I.scanned_autopsy_weapons)
		if(!(weapon in saved_autopsy_weapons))
			saved_autopsy_weapons += weapon

			if(special_weapons69weapon69)
				points += special_weapons69weapon69
			else
				points += AUTOPSY_WEAPON_PAMT

	for(var/list/artifact in I.scanned_artifacts)
		if(!(artifact69"type"69 in artifact_types)) // useless
			continue

		var/already_scanned = FALSE
		for(var/list/our_artifact in saved_artifacts)
			if(our_artifact69"type"69 == artifact69"type"69 && our_artifact69"first_effect"69 == artifact69"first_effect"69 && our_artifact69"second_effect"69 == artifact69"second_effect"69)
				already_scanned = TRUE
				break

		if(!already_scanned)
			points += ARTIFACT_PAMT
			saved_artifacts += list(artifact)

	for(var/symptom in I.scanned_symptoms)
		if(saved_symptoms69symptom69)
			continue

		var/level = I.scanned_symptoms69symptom69
		if(level_to_points69level69)
			points += level_to_points69level69

		saved_symptoms69symptom69 = level

	for(var/core in I.scanned_slimecores)
		if(core in saved_slimecores)
			continue

		var/reward = 1000
		if(core in core_points)
			reward = core_points69core69
		points += reward
		saved_slimecores += core

	I.clear_data()
	return round(points)

/datum/experiment_data/proc/merge_with(datum/experiment_data/O)
	for(var/tech in O.saved_tech_levels)
		if(!saved_tech_levels69tech69)
			saved_tech_levels69tech69 = list()

		saved_tech_levels69tech69 |= O.saved_tech_levels69tech69

	for(var/weapon in O.saved_autopsy_weapons)
		saved_autopsy_weapons |= weapon

	for(var/list/artifact in O.saved_artifacts)
		var/has_artifact = FALSE
		for(var/list/our_artifact in saved_artifacts)
			if(our_artifact69"type"69 == artifact69"type"69 && our_artifact69"first_effect"69 == artifact69"first_effect"69 && our_artifact69"second_effect"69 == artifact69"second_effect"69)
				has_artifact = TRUE
				break
		if(!has_artifact)
			saved_artifacts += list(artifact)

	for(var/symptom in O.saved_symptoms)
		saved_symptoms69symptom69 = O.saved_symptoms69symptom69

	for(var/core in O.saved_slimecores)
		saved_slimecores |= core

	saved_best_explosion =69ax(saved_best_explosion, O.saved_best_explosion)


// Grants research points when explosion happens69earby
/obj/item/device/radio/beacon/explosion_watcher
	name = "Kinetic Energy Scanner"
	desc = "Scans the level of kinetic energy from explosions"

	channels = list("Science" = 1)

/obj/item/device/radio/beacon/explosion_watcher/ex_act(severity)
	return

/obj/item/device/radio/beacon/explosion_watcher/Initialize()
	. = ..()
	GLOB.explosion_watcher_list += src

/obj/item/device/radio/beacon/explosion_watcher/Destroy()
	GLOB.explosion_watcher_list -= src
	return ..()

/obj/item/device/radio/beacon/explosion_watcher/proc/react_explosion(turf/epicenter, power)
	power = round(power)
	var/calculated_research_points = -1
	for(var/obj/machinery/computer/rdconsole/RD in GLOB.computer_list)
		if(RD.id == 1) // only core gets the science
			var/saved_power_level = RD.files.experiments.saved_best_explosion

			var/added_power =69ax(0, power - saved_power_level)
			var/already_earned_power =69in(saved_power_level, power)

			calculated_research_points = added_power * 1000 + already_earned_power * 200

			if(power > saved_power_level)
				RD.files.experiments.saved_best_explosion = power

			RD.files.adjust_research_points(calculated_research_points)

	if(calculated_research_points > 0)
		autosay("Detected explosion with power level 69power69, received 69calculated_research_points69 research points",69ame ,"Science")
	else
		autosay("Detected explosion with power level 69power69, R&D console is69issing or broken",69ame ,"Science")

// Universal tool to get research points from autopsy reports,69irus info reports, archeology reports, slime cores
/obj/item/device/science_tool
	name = "science tool"
	icon_state = "science"
	item_state = "sciencetool"
	desc = "A hand-held device capable of extracting usefull data from69arious sources, such as paper reports and slime cores."
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = ITEM_SIZE_SMALL
	throw_speed = 5
	throw_range = 10
	matter = list(MATERIAL_STEEL = 5)
	origin_tech = list(TECH_ENGINEERING = 1, TECH_BIO = 1)
	spawn_tags = SPAWN_TAG_DIVICE_SCIENCE
	spawn_fre69uency = 5
	rarity_value = 8

	var/datum/experiment_data/experiments
	var/list/scanned_autopsy_weapons = list()
	var/list/scanned_artifacts = list()
	var/list/scanned_symptoms = list()
	var/list/scanned_slimecores = list()
	var/datablocks = 0

/obj/item/device/science_tool/Initialize()
	. = ..()
	experiments =69ew

/obj/item/device/science_tool/attack(mob/living/M,69ob/living/user)
	return

/obj/item/device/science_tool/afterattack(obj/O,69ob/living/user)
	var/scanneddata = 0

	if(istype(O,/obj/item/paper/autopsy_report))
		var/obj/item/paper/autopsy_report/report = O
		for(var/datum/autopsy_data/W in report.autopsy_data)
			if(!(W.weapon in scanned_autopsy_weapons))
				scanneddata += 1
				scanned_autopsy_weapons += W.weapon

	if(istype(O, /obj/item/paper/artifact_info))
		var/obj/item/paper/artifact_info/report = O
		if(report.artifact_type)
			for(var/list/artifact in scanned_artifacts)
				if(artifact69"type"69 == report.artifact_type && artifact69"first_effect"69 == report.artifact_first_effect && artifact69"second_effect"69 == report.artifact_second_effect)
					to_chat(user, SPAN_NOTICE("69src69 already has data about this artifact report"))
					return

			scanned_artifacts += list(list(
				"type" = report.artifact_type,
				"first_effect" = report.artifact_first_effect,
				"second_effect" = report.artifact_second_effect,
			))
			scanneddata += 1

	if(istype(O, /obj/item/paper/virus_report))
		var/obj/item/paper/virus_report/report = O
		for(var/symptom in report.symptoms)
			if(!scanned_symptoms69symptom69)
				scanneddata += 1
				scanned_symptoms69symptom69 = report.symptoms69symptom69
	if(istype(O, /obj/item/slime_extract))
		if(!(O.type in scanned_slimecores))
			scanned_slimecores += O.type
			scanneddata += 1

	if(scanneddata > 0)
		datablocks += scanneddata
		to_chat(user, SPAN_NOTICE("69src69 received 69scanneddata69 data block69scanneddata>1?"s":""69 from scanning 69O69"))
	else if(istype(O, /obj/item))
		var/science_value = experiments.get_object_research_value(O)
		if(science_value > 0)
			to_chat(user, SPAN_NOTICE("Estimated research69alue of 69O.name69 is 69science_value69"))
		else
			to_chat(user, SPAN_NOTICE("69O69 has69o research69alue"))

/obj/item/device/science_tool/proc/clear_data()
	scanned_autopsy_weapons = list()
	scanned_artifacts = list()
	scanned_symptoms = list()
	scanned_slimecores = list()
	datablocks = 0

/obj/item/computer_hardware/hard_drive/portable/research_points/proc/get_title()
	var/list/verb_ion = list("exploration", "development", "refinement", "investigation", "analysis", "improvement", "emulation", "simulation", "construction", "evaluation", "deployment", "synthesis", "visualization")
	var/list/prefixes = list("","69pick(verb_ion)69: ")
	var/list/suffixes = list("using 69pick(verb_ion)69","with 69pick(verb_ion)69")
	var/list/subjects = list("proprioception", "implants", "null space", "AI", "neural69etworks", "drones", "cyborgs", "human thought", "materiel", "materials", "microgravity", "artificial gravity", "MMIs", "brain death", "system shock", "SSD", "memory transcription", "closed intranets", "internal69etworks", "bluespace fault tolerance", "bluespace translocation", "firewalls", "ICE", "symmetric encryption", "NTNet", "low-light ecosystems", "algorithms", "systems", "ionospheric anomalies", "mass hallucinations", "human experimentation")
	var/list/impact = list("impact of", "effect of", "influence of")
	var/list/verb_ing = list("harnessing", "enabling", "exploring", "controlling", "developing", "refining", "investigating", "improving", "analyzing", "constructing", "simulating", "evaluating", "emulating", "deploying", "synthesizing", "visualizing", "studying")
	var/list/buzzword_nouns = list("wetware", "technology", "nanotechnology", "communication", "algorithms", "theory", "methodologies", "information", "models", "archetypes", "configurations", "modalities", "symmetries", "epistemologies", "gradients", "plots", "matrices", "manifolds", "methods")
	var/list/buzzword_adjs = list("n-dimensional", "anomalistic", "parallel", "noisy", "discrete", "exhaustive", "randomized", "pipelined", "critical", "heuristic", "bluespace", "high-throughput", "peer-to-peer", "game-theoretic", "knowledge-based", "relational", "compact", "ubi69uitous", "linear-time", "fuzzy", "embedded", "constant-time", "client-server", "efficient", "reliable", "replicated", "low-energy", "omniscient", "wireless", "modular", "autonomous", "introspective", "distributed", "flexible", "extensible", "amphibious", "metamorphic", "ambimorphic", "permutable", "adaptive", "self-learning", "trainable", "smart", "classical", "atomic", "event-driven", "read-write", "encrypted", "highly-available", "secure", "interposable", "cacheable", "perfect", "electronic", "pervasive", "large-scale", "multimodal", "authenticated", "interactive", "heterogeneous", "homogeneous", "collaborative", "concurrent", "probabilistic", "mobile", "semantic", "real-time", "cooperative", "decentralized", "scalable", "certifiable", "robust", "signed", "virtual", "lossless", "psychoacoustic", "empathic", "optimal", "stable", "unstable", "symbiotic", "stochastic", "Monte Carlo", "pseudorandom")
	var/buzzword_adj_multi = "69pick(buzzword_adjs)69, 69pick(buzzword_adjs)69"
	var/list/fields = list("cyanocommunication", "cyanotranslocation", "population control", "psychoanalysis", "networking", "operating systems", "programming languages", "theory", "algorithms", "chaos theory", "artificial intelligence", "machine learning", "robotics", "electrical engineering", "cyborg engineering", "drone fabrication", "cryptography", "cryptanalysis", "cyberinformatics", "steganography", "software engineering", "information control", "memetics")
	var/list/compare = list("comparing", "contrasting", "the relationship between", pick(verb_ing))
	var/list/status = list("ethical", "unethical", "harmful", "desirable", "detrimental", "practical", "effective", "beneficial", "crucial", "instrumental")
	var/list/titles = list("69pick(prefixes)6969pick(verb_ion)69 of 69pick(subjects)69",
							"on the 69pick(verb_ion)69 of 69pick(subjects)69",
							"a 69pick(verb_ion)69 of 69pick(subjects)69 69pick(suffixes)69",
							"69pick(subjects)69 69pick("","no longer ")69considered 69pick(status)69 in 69pick("","69pick(buzzword_adjs)69 ")6969pick(fields)69",
							"deconstructing 69pick(subjects)69 69pick(suffixes)69",
							"decoupling 69pick(subjects)69 from 69pick(subjects)69 in 69pick(subjects)69",
							"69pick(prefixes)69a69ethodology for the 69pick(verb_ion)69 of 69pick(subjects)69",
							"a case 69pick("for", "against")69 69pick(subjects)69",
							"69pick(verb_ing)69 69pick(subjects)69 using 69pick(buzzword_adjs)69 69pick(buzzword_nouns)69",
							"69pick(verb_ing)69 69pick(subjects)69 and 69pick(subjects)69 69pick(suffixes)69",
							"69pick(prefixes)6969buzzword_adj_multi69 69pick(buzzword_nouns)69",
							"69pick(compare)69 69pick(subjects)69 and 69pick(subjects)69 69pick(suffixes)69",
							"the 69pick(impact)69 69pick(buzzword_adjs)69 69pick(buzzword_nouns)69 on 69pick("","69pick(buzzword_adjs)69 ")6969pick(fields)69",
							"69buzzword_adj_multi69 69pick(buzzword_nouns)69 for 69pick(subjects)69")
	return capitalize(pick(titles))
/obj/item/computer_hardware/hard_drive/portable/research_points
	desc = "A removable disk used to store large amounts of research data."
	icon_state = "onestar"
	spawn_tags = SPAWN_TAG_RESEARCH_POINTS
	rarity_value = 12
	var/min_points = 2000
	var/max_points = 10000

/obj/item/computer_hardware/hard_drive/portable/research_points/Initialize()
	disk_name = get_title()
	. = ..()

/obj/item/computer_hardware/hard_drive/portable/research_points/install_default_files()
	..()
	var/datum/computer_file/binary/research_points/F =69ew(size = rand(min_points / 1000,69ax_points / 1000))
	store_file(F)

/obj/item/computer_hardware/hard_drive/portable/research_points/rare
	min_points = 10000
	max_points = 20000
	rarity_value = 60
