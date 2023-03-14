// Placeholder for disorders in sanity/psionics rework
/datum/component/internal_wound/organic/sanity
	treatments_chem = list(CE_MIND = 2)
	diagnosis_stat = STAT_COG
	diagnosis_difficulty = STAT_LEVEL_EXPERT
	characteristic_flag = IWOUND_HALLUCINATE
	severity = 1
	severity_max = 1
	psy_damage = IWOUND_MEDIUM_DAMAGE

/datum/component/internal_wound/organic/sanity/twitch
	name = "twitching tissue"

/datum/component/internal_wound/robotic/sanity
	treatments_chem = list(CE_MIND = 2)
	diagnosis_stat = STAT_COG
	diagnosis_difficulty = STAT_LEVEL_EXPERT
	wound_nature = MODIFICATION_SILICON
	characteristic_flag = IWOUND_HALLUCINATE
	severity = 1
	severity_max = 1
	psy_damage = IWOUND_MEDIUM_DAMAGE

/datum/component/internal_wound/robotic/sanity/volt
	name = "anomalous voltage accumulation"
