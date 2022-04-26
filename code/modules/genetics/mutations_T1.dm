/datum/mutation/t1
	tier_num = 1
	tier_string = "Vespasian"
	NSA_load = 10

// Minor stat buffs, equivalent of what T1 stimulators provide
/datum/mutation/t1/stat_buff
	name = "Mnemonic stimulation"
	desc = "Improves abstract thinking and ability to iteract with mechanisms."
	buff_type = STAT_MEC
	buff_power = STAT_LEVEL_ADEPT

/datum/mutation/t1/stat_buff/imprint(mob/living/carbon/user)
	if(..())
		user.stats.addTempStat(buff_type, buff_power, INFINITY, "Mutation_[hex]_[name]")

/datum/mutation/t1/stat_buff/cleanse(mob/living/carbon/user)
	if(..())
		user.stats.removeTempStat(buff_type, "Mutation_[hex]_[name]")

/datum/mutation/t1/stat_buff/biology
	name = "Supressed neural oscillation"
	desc = "Stabilizes muscle motility and reduces tremor."
	buff_type = STAT_BIO

/datum/mutation/t1/stat_buff/cognition
	name = "Hypercalculia"
	desc = "Improves ability to perform mathematical calculations."
	buff_type = STAT_COG

/datum/mutation/t1/stat_buff/vigilance
	name = "Enchanced proprioceptors"
	desc = "Improves hand-eye coordination when handling a weapon."
	buff_type = STAT_VIG

/datum/mutation/t1/stat_buff/robustness
	name = "Altered fibroblast growth factors"
	desc = "Increases peak muscle contraction force and pain tolerance."
	buff_type = STAT_ROB

/datum/mutation/t1/stat_buff/toughness
	name = "Controlled osteoderm formation"
	desc = "Causes growth of tiny bony patches thoughout the body."
	buff_type = STAT_TGH

/datum/mutation/t1/no_reject
	name = "Enforced histocompatibility"
	desc = "Prevents implant and blood rejection."
