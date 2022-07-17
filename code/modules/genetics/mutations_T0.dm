// Mostly disabilities and junk mutations
/datum/mutation/t0
	tier_num = 0
	tier_string = "Nero"
	NSA_load = 5

/datum/mutation/t0/blindness
	name = "Blindness"
	desc = "Decreased ability to see to a degree that causes problems not fixable by usual means, such as glasses."

/datum/mutation/t0/blindness/imprint(mob/living/carbon/user)
	if(..())
		user.sdisabilities |= BLIND

/datum/mutation/t0/blindness/cleanse(mob/living/carbon/user)
	if(..())
		user.sdisabilities -= BLIND

/datum/mutation/t0/deafness
	name = "Deafness"
	desc = "Prevents from hearing any sounds at all, regardless of amplification or method of production."

/datum/mutation/t0/deafness/imprint(mob/living/carbon/user)
	if(..())
		user.sdisabilities |= DEAF

/datum/mutation/t0/deafness/cleanse(mob/living/carbon/user)
	if(..())
		user.sdisabilities -= DEAF

/datum/mutation/t0/myopia
	name = "Myopia"
	desc = "Causes distant objects to appear blurry while close objects appear normal."

/datum/mutation/t0/myopia/imprint(mob/living/carbon/user)
	if(..())
		user.sdisabilities |= NEARSIGHTED

/datum/mutation/t0/myopia/cleanse(mob/living/carbon/user)
	if(..())
		user.sdisabilities -= NEARSIGHTED

/datum/mutation/t0/stat_debuff
	name = "Mnemonic degradation"
	desc = "Decreases ability to iteract with mechanisms."
	buff_type = STAT_MEC
	buff_power = -STAT_LEVEL_BASIC

/datum/mutation/t0/stat_debuff/imprint(mob/living/carbon/user)
	if(..())
		user.stats.addTempStat(buff_type, buff_power, INFINITY, "Mutation_[hex]_[name]")

/datum/mutation/t0/stat_debuff/cleanse(mob/living/carbon/user)
	if(..())
		user.stats.removeTempStat(buff_type, "Mutation_[hex]_[name]")

/datum/mutation/t0/stat_debuff/biology
	name = "Tremor"
	desc = "Involuntary twitching hand movements."
	buff_type = STAT_BIO

/datum/mutation/t0/stat_debuff/cognition
	name = "Dementia"
	desc = "Progressive impairments in memory and thinking."
	buff_type = STAT_COG

/datum/mutation/t0/stat_debuff/vigilance
	name = "Ataxia"
	desc = "Inability to judge distances or ranges of movement happens, most notably when shooting a gun."
	buff_type = STAT_VIG

/datum/mutation/t0/stat_debuff/robustness
	name = "Muscular dystrophy"
	desc = "Causes progressive weakness and loss of muscle mass."
	buff_type = STAT_ROB

/datum/mutation/t0/stat_debuff/toughness
	name = "Thin skin"
	desc = "Makes body more susceptible to damage."
	buff_type = STAT_TGH
