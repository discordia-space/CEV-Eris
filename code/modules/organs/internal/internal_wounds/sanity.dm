// Placeholder for disorders in sanity/psionics rework
/datum/component/internal_wound/sanity
	dupe_mode = COMPONENT_DUPE_UNIQUE
	name = "twitching tissue"
	treatments_chem = list(CE_MIND = 1)
	diagnosis_stat = STAT_COG
	diagnosis_difficulty = STAT_LEVEL_EXPERT
	can_progress = FALSE
	wound_nature = null
	severity = 1
	severity_max = 1
	psy_damage = 0.5
	can_hallucinate = TRUE

/datum/component/internal_wound/sanity/apply_damage()
	return
