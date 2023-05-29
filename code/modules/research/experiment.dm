// Contains everything related to earning research points
#define AUTOPSY_WEAPON_PAMT rand(1,5) * 20 // 50-100 points for random weapon

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

	var/list/saved_tech_levels = list() // list("materials" = list(1, 4, ...), ...)
	var/list/saved_autopsy_weapons = list()
	var/list/saved_symptoms = list()
	var/list/saved_slimecores = list()

	// Special point amount for autopsy weapons
	var/static/list/special_weapons = list(
		"large organic needle" = 10000,
		"Hulk Foot" = 10000,
		"Explosive blast" = 5000,
		"Electronics meltdown" = 4000,
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
/datum/experiment_data/proc/ConvertReqString2List(list/source_list)
	var/list/temp_list = params2list(source_list)
	for(var/O in temp_list)
		temp_list[O] = text2num(temp_list[O])
	return temp_list
*/
// TODO: unify this with do_research_object?
/datum/experiment_data/proc/get_object_research_value(obj/item/I, ignoreRepeat = FALSE)
	var/list/temp_tech = I.origin_tech
	var/item_tech_points = 0
	var/has_new_tech = FALSE
	var/is_board = istype(I, /obj/item/electronics/circuitboard)

	for(var/T in temp_tech)
		if(tech_points[T])
			if(ignoreRepeat)
				item_tech_points += temp_tech[T] * tech_points[T]
			else
				if(saved_tech_levels[T] && (temp_tech[T] in saved_tech_levels[T])) // You only get a fraction of points if you researched items with this level already
					if(!is_board) // Boards are cheap to make so we don't give any points for repeats
						item_tech_points += temp_tech[T] * tech_points[T] * 0.1
				else
					item_tech_points += temp_tech[T] * tech_points[T]
					has_new_tech = TRUE

	if(!ignoreRepeat && !has_new_tech) // We are deconstucting the same items, cut the reward really hard
		item_tech_points = min(item_tech_points, 400)

	return round(item_tech_points)

/datum/experiment_data/proc/do_research_object(obj/item/I)
	var/list/temp_tech = I.origin_tech

	for(var/T in temp_tech)
		if(!saved_tech_levels[T])
			saved_tech_levels[T] = list()

		if(!(temp_tech[T] in saved_tech_levels[T]))
			saved_tech_levels[T] += temp_tech[T]



// Returns amount of research points received
/datum/experiment_data/proc/read_science_tool(obj/item/device/science_tool/I)
	var/points = 0

	for(var/weapon in I.scanned_autopsy_weapons)
		if(!(weapon in saved_autopsy_weapons))
			saved_autopsy_weapons += weapon

			if(special_weapons[weapon])
				points += special_weapons[weapon]
			else
				points += AUTOPSY_WEAPON_PAMT


	for(var/symptom in I.scanned_symptoms)
		if(saved_symptoms[symptom])
			continue

		var/level = I.scanned_symptoms[symptom]
		if(level_to_points[level])
			points += level_to_points[level]

		saved_symptoms[symptom] = level

	for(var/core in I.scanned_slimecores)
		if(core in saved_slimecores)
			continue

		var/reward = 1000
		if(core in core_points)
			reward = core_points[core]
		points += reward
		saved_slimecores += core

	I.clear_data()
	return round(points)

/datum/experiment_data/proc/merge_with(datum/experiment_data/O)
	for(var/tech in O.saved_tech_levels)
		if(!saved_tech_levels[tech])
			saved_tech_levels[tech] = list()

		saved_tech_levels[tech] |= O.saved_tech_levels[tech]

	for(var/weapon in O.saved_autopsy_weapons)
		saved_autopsy_weapons |= weapon

	for(var/symptom in O.saved_symptoms)
		saved_symptoms[symptom] = O.saved_symptoms[symptom]

	for(var/core in O.saved_slimecores)
		saved_slimecores |= core

	saved_best_explosion = max(saved_best_explosion, O.saved_best_explosion)


// Grants research points when explosion happens nearby
/obj/item/device/radio/beacon/explosion_watcher
	name = "Kinetic Energy Scanner"
	desc = "Scans the level of kinetic energy from explosions"

	channels = list("Science" = 1)

/obj/item/device/radio/beacon/explosion_watcher/explosion_act(target_power, explosion_handler/handler)
	return 0


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

			var/added_power = max(0, power - saved_power_level)
			var/already_earned_power = min(saved_power_level, power)

			calculated_research_points = added_power * 1000 + already_earned_power * 200

			if(power > saved_power_level)
				RD.files.experiments.saved_best_explosion = power

			RD.files.adjust_research_points(calculated_research_points)

	if(calculated_research_points > 0)
		autosay("Detected explosion with power level [power], received [calculated_research_points] research points", name ,"Science")
	else
		autosay("Detected explosion with power level [power], R&D console is missing or broken", name ,"Science")

// Universal tool to get research points from autopsy reports, virus info reports, archeology reports, slime cores
/obj/item/device/science_tool
	name = "science tool"
	icon_state = "science"
	item_state = "sciencetool"
	desc = "A hand-held device capable of extracting usefull data from various sources, such as paper reports and slime cores."
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = ITEM_SIZE_SMALL
	throw_speed = 5
	throw_range = 10
	matter = list(MATERIAL_STEEL = 5)
	origin_tech = list(TECH_ENGINEERING = 1, TECH_BIO = 1)
	spawn_tags = SPAWN_TAG_DEVICE_SCIENCE
	spawn_frequency = 5
	rarity_value = 8

	var/datum/experiment_data/experiments
	var/list/scanned_autopsy_weapons = list()
	var/list/scanned_symptoms = list()
	var/list/scanned_slimecores = list()
	var/datablocks = 0

/obj/item/device/science_tool/Initialize()
	. = ..()
	experiments = new

/obj/item/device/science_tool/attack(mob/living/M, mob/living/user)
	return

/obj/item/device/science_tool/afterattack(obj/O, mob/living/user)
	var/scanneddata = 0

	if(istype(O,/obj/item/paper/autopsy_report))
		var/obj/item/paper/autopsy_report/report = O
		for(var/datum/autopsy_data/W in report.autopsy_data)
			if(!(W.weapon in scanned_autopsy_weapons))
				scanneddata += 1
				scanned_autopsy_weapons += W.weapon

	if(istype(O, /obj/item/slime_extract))
		if(!(O.type in scanned_slimecores))
			scanned_slimecores += O.type
			scanneddata += 1

	if(scanneddata > 0)
		datablocks += scanneddata
		to_chat(user, SPAN_NOTICE("[src] received [scanneddata] data block[scanneddata>1?"s":""] from scanning [O]"))
	else if(istype(O, /obj/item))
		var/science_value = experiments.get_object_research_value(O)
		if(science_value > 0)
			to_chat(user, SPAN_NOTICE("Estimated research value of [O.name] is [science_value]"))
		else
			to_chat(user, SPAN_NOTICE("[O] has no research value"))

/obj/item/device/science_tool/proc/clear_data()
	scanned_autopsy_weapons = list()
	scanned_symptoms = list()
	scanned_slimecores = list()
	datablocks = 0

/obj/item/computer_hardware/hard_drive/portable/research_points/proc/get_title()
	var/list/verb_ion = list("exploration", "development", "refinement", "investigation", "analysis", "improvement", "emulation", "simulation", "construction", "evaluation", "deployment", "synthesis", "visualization")
	var/list/prefixes = list("","[pick(verb_ion)]: ")
	var/list/suffixes = list("using [pick(verb_ion)]","with [pick(verb_ion)]")
	var/list/subjects = list("proprioception", "implants", "null space", "AI", "neural networks", "drones", "cyborgs", "human thought", "materiel", "materials", "microgravity", "artificial gravity", "MMIs", "brain death", "system shock", "SSD", "memory transcription", "closed intranets", "internal networks", "bluespace fault tolerance", "bluespace translocation", "firewalls", "ICE", "symmetric encryption", "NTNet", "low-light ecosystems", "algorithms", "systems", "ionospheric anomalies", "mass hallucinations", "human experimentation")
	var/list/impact = list("impact of", "effect of", "influence of")
	var/list/verb_ing = list("harnessing", "enabling", "exploring", "controlling", "developing", "refining", "investigating", "improving", "analyzing", "constructing", "simulating", "evaluating", "emulating", "deploying", "synthesizing", "visualizing", "studying")
	var/list/buzzword_nouns = list("wetware", "technology", "nanotechnology", "communication", "algorithms", "theory", "methodologies", "information", "models", "archetypes", "configurations", "modalities", "symmetries", "epistemologies", "gradients", "plots", "matrices", "manifolds", "methods")
	var/list/buzzword_adjs = list("n-dimensional", "anomalistic", "parallel", "noisy", "discrete", "exhaustive", "randomized", "pipelined", "critical", "heuristic", "bluespace", "high-throughput", "peer-to-peer", "game-theoretic", "knowledge-based", "relational", "compact", "ubiquitous", "linear-time", "fuzzy", "embedded", "constant-time", "client-server", "efficient", "reliable", "replicated", "low-energy", "omniscient", "wireless", "modular", "autonomous", "introspective", "distributed", "flexible", "extensible", "amphibious", "metamorphic", "ambimorphic", "permutable", "adaptive", "self-learning", "trainable", "smart", "classical", "atomic", "event-driven", "read-write", "encrypted", "highly-available", "secure", "interposable", "cacheable", "perfect", "electronic", "pervasive", "large-scale", "multimodal", "authenticated", "interactive", "heterogeneous", "homogeneous", "collaborative", "concurrent", "probabilistic", "mobile", "semantic", "real-time", "cooperative", "decentralized", "scalable", "certifiable", "robust", "signed", "virtual", "lossless", "psychoacoustic", "empathic", "optimal", "stable", "unstable", "symbiotic", "stochastic", "Monte Carlo", "pseudorandom")
	var/buzzword_adj_multi = "[pick(buzzword_adjs)], [pick(buzzword_adjs)]"
	var/list/fields = list("cyanocommunication", "cyanotranslocation", "population control", "psychoanalysis", "networking", "operating systems", "programming languages", "theory", "algorithms", "chaos theory", "artificial intelligence", "machine learning", "robotics", "electrical engineering", "cyborg engineering", "drone fabrication", "cryptography", "cryptanalysis", "cyberinformatics", "steganography", "software engineering", "information control", "memetics")
	var/list/compare = list("comparing", "contrasting", "the relationship between", pick(verb_ing))
	var/list/status = list("ethical", "unethical", "harmful", "desirable", "detrimental", "practical", "effective", "beneficial", "crucial", "instrumental")
	var/list/titles = list("[pick(prefixes)][pick(verb_ion)] of [pick(subjects)]",
							"on the [pick(verb_ion)] of [pick(subjects)]",
							"a [pick(verb_ion)] of [pick(subjects)] [pick(suffixes)]",
							"[pick(subjects)] [pick("","no longer ")]considered [pick(status)] in [pick("","[pick(buzzword_adjs)] ")][pick(fields)]",
							"deconstructing [pick(subjects)] [pick(suffixes)]",
							"decoupling [pick(subjects)] from [pick(subjects)] in [pick(subjects)]",
							"[pick(prefixes)]a methodology for the [pick(verb_ion)] of [pick(subjects)]",
							"a case [pick("for", "against")] [pick(subjects)]",
							"[pick(verb_ing)] [pick(subjects)] using [pick(buzzword_adjs)] [pick(buzzword_nouns)]",
							"[pick(verb_ing)] [pick(subjects)] and [pick(subjects)] [pick(suffixes)]",
							"[pick(prefixes)][buzzword_adj_multi] [pick(buzzword_nouns)]",
							"[pick(compare)] [pick(subjects)] and [pick(subjects)] [pick(suffixes)]",
							"the [pick(impact)] [pick(buzzword_adjs)] [pick(buzzword_nouns)] on [pick("","[pick(buzzword_adjs)] ")][pick(fields)]",
							"[buzzword_adj_multi] [pick(buzzword_nouns)] for [pick(subjects)]")
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
	var/datum/computer_file/binary/research_points/F = new(size = rand(min_points / 1000, max_points / 1000))
	store_file(F)

/obj/item/computer_hardware/hard_drive/portable/research_points/rare
	min_points = 10000
	max_points = 20000
	rarity_value = 60
