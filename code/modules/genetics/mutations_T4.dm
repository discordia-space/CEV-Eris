/datum/mutation/t4
	tier_num = 4
	tier_string = "Aurelien"
	NSA_load = 0

/datum/mutation/t4/remoteobserve
	name = "Remote observation"
	desc = "Allows you to look through the eyes of other people."
	NSA_load = 20

/datum/mutation/t4/remoteobserve/imprint(mob/living/carbon/user)
	if(..())
		user.verbs += /mob/living/carbon/human/proc/remoteobserve

/datum/mutation/t4/remoteobserve/cleanse(mob/living/carbon/user)
	if(..())
		user.verbs -= /mob/living/carbon/human/proc/remoteobserve


/datum/mutation/t4/godblood
	name = "God Blood"
	desc = "Suppresses cruciform, allowing to have any implant or organ, as well as mutations."

/datum/mutation/t4/xray
	name = "X Ray Vision"
	desc = "Allows to see trough walls."
	NSA_load = 15

/datum/mutation/t4/phazing
	name = "Phazing"
	desc = "Allows to phaze trough solid objects, albeit slowly."
	NSA_load = 20

/datum/mutation/t4/phazing/imprint(mob/living/carbon/user)
	if(..())
		user.verbs += /mob/living/carbon/human/proc/phaze_trough

/datum/mutation/t4/phazing/cleanse(mob/living/carbon/user)
	if(..())
		user.verbs -= /mob/living/carbon/human/proc/phaze_trough

/datum/mutation/t4/morph
	name = "Morph body"
	desc = "Provides ability to completely reshape one\'s body."
	NSA_load = 10

/datum/mutation/t4/morph/imprint(mob/living/carbon/user)
	if(..())
		user.verbs += /mob/living/carbon/human/proc/morph

/datum/mutation/t4/morph/cleanse(mob/living/carbon/user)
	if(..())
		user.verbs -= /mob/living/carbon/human/proc/morph
