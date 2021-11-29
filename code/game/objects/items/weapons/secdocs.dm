/obj/item/oddity/secdocs
	name = "science data"
	desc = "A folder containing some papers with important scientific data."
	icon = 'icons/obj/oddities.dmi'
	icon_state = "folder"
	price_tag = 5000

	oddity_stats = list(
		STAT_MEC = 8,
		STAT_COG = 8,
		STAT_BIO = 8,
	)

	var/static/inv_spawn_count = 3

/proc/get_title()
	var/list/verb_ion = list("exploration", "development", "refinement", "investigation", "analysis", "improvement", "emulation", "simulation", "construction", "evaluation", "deployment", "synthesis", "visualization")
	var/list/prefixes = list("","[pick(verb_ion)]: ")
	var/list/suffixes = list("using [pick(verb_ion)]","with [pick(verb_ion)]")
	var/list/subjects = list("proprioception", "implants", "null space", "AI", "neural networks", "drones", "cyborgs", "human thought", "materiel", "materials", "microgravity", "artificial gravity", "MMIs", "brain death", "system shock", "SSD", "memory transcription", "closed intranets", "internal networks", "the old Alliance", "Alliance nanomachines", "One Star", "the Ironhammer SAU overfund", "SAU equipment specifications", "public administration", "outside-context problems", "the timeline", "timelines", "parallel worlds", "continuity breaches", "access points to Discordia", "the Door Phenomenon", "bluespace fault tolerance", "bluespace translocation", "firewalls", "ICE", "symmetric encryption", "NTNet", "low-light ecosystems", "algorithms", "systems", "ionospheric anomalies", "mass hallucinations", "human experimentation", "extinct civilizations")
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

/obj/item/oddity/secdocs/Initialize()
	icon_state = "folder-[pick("omega","psi","theta")]"
	name = get_title()
	. = ..()
	var/mob/living/carbon/human/owner = loc
	if(istype(owner))
		to_chat(owner, SPAN_NOTICE("You have valuable scientific data on your person. Do not let it fall into the wrong hands."))

/hook/roundstart/proc/place_docs()
	var/list/obj/landmark/storyevent/midgame_stash_spawn/L = list()
	for(var/obj/landmark/storyevent/midgame_stash_spawn/S in GLOB.landmarks_list)
		L.Add(S)

	L = shuffle(L)

	if(L.len < 3)
		warning("Failed to place secret documents: not enough landmarks.")
		return FALSE

	for(var/i in 1 to 3)
		new /obj/item/oddity/secdocs(L[i].get_loc())

	return TRUE
