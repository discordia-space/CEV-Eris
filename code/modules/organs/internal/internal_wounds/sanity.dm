// Placeholder for disorders in sanity/psionics rework
/datum/component/internal_wound/organic/sanity
	name = "twitching tissue"
	treatments_chem = list(CE_MIND = 2)
	diagnosis_stat = STAT_COG
	diagnosis_difficulty = STAT_LEVEL_EXPERT
	can_progress = FALSE
	severity = 1
	severity_max = 1
	can_damage_organ = FALSE
	psy_damage = 0.2
	can_hallucinate = TRUE

/datum/component/internal_wound/robotic/sanity
	dupe_mode = COMPONENT_DUPE_UNIQUE
	name = "anomalous voltage accumulation"
	treatments_chem = list(CE_MIND = 2)
	diagnosis_stat = STAT_COG
	diagnosis_difficulty = STAT_LEVEL_EXPERT
	can_progress = FALSE
	wound_nature = MODIFICATION_SILICON
	severity = 1
	severity_max = 1
	can_damage_organ = FALSE
	psy_damage = 0.2
	can_hallucinate = TRUE
