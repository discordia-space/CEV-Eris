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
