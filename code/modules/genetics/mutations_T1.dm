// Mildly useful mutations without side-effects aside of NSA load
/datum/mutation/t1
	name = "Unknown mutation"
	desc = "Unknown function"
	tier_num = 1
	tier_string = "Vespasian"
	NSA_load = 10

// Minor stat buffs, equivalent of what T1 stimulators provide
/datum/mutation/t1/stat_buff
	name = "MEC buff (Temporary Name)"
	desc = "Buffs MEC."
	var/stat_type = STAT_MEC
	var/buff_power = STAT_LEVEL_ADEPT

/datum/mutation/t1/stat_buff/imprint(mob/living/carbon/user)
	..(user)
	user.stats.addTempStat(stat_type, buff_power, INFINITY, "Mutation_[hex]_[name]")

/datum/mutation/t1/stat_buff/cleanse(mob/living/carbon/user)
	..(user)
	user.stats.removeTempStat(stat_type, "Mutation_[hex]_[name]")

/datum/mutation/t1/stat_buff/biology
	name = "Supressed neural oscillation"
	desc = "Stabilizes muscle motility and reduces tremor."
	stat_type = STAT_BIO

/datum/mutation/t1/stat_buff/cognition
	name = "Hypercalculia"
	desc = "Improves ability to perform mathematical calculations."
	stat_type = STAT_COG

/datum/mutation/t1/stat_buff/vigilance
	name = "Enchanced proprioceptors"
	desc = "Improves hand-eye coordination."
	stat_type = STAT_VIG

/datum/mutation/t1/stat_buff/robustness
	name = "Altered fibroblast growth factors"
	desc = "Increases peak muscle contraction force and pain tolerance."
	stat_type = STAT_ROB

/datum/mutation/t1/stat_buff/toughness
	name = "Controlled osteoderm formation"
	desc = "Causes growth of tiny bony patches thoughout the body."
	stat_type = STAT_TGH

// Implanted organs and transfused blood never rejected
/datum/mutation/t1/no_reject
	name = "Enforced histocompatibility"
	desc = "Prevents implant and blood rejection."
