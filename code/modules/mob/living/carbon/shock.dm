/mob/living/var/traumatic_shock = 0
/mob/living/carbon/var/shock_stage = 0

// proc to find out in how much pain the mob is at the moment
/mob/living/carbon/proc/updateshock()
	if (species && (species.flags & NO_PAIN))
		src.traumatic_shock = 0
		return 0

	src.traumatic_shock = 			\
	1	* src.getOxyLoss() + 		\
	0.5	* src.getToxLoss() + 		\
	1	* src.getPainFromDam() +	\
	1.7	* src.getCloneLoss() + 		\
	2	* src.halloss + 			\
	-1	* src.analgesic

	if(src.slurring)
		src.traumatic_shock -= 20

	if(src.traumatic_shock < 0)
		src.traumatic_shock = 0

	return src.traumatic_shock

/mob/living/carbon/proc/getPainFromDam()
	return src.getFireLoss() + src.getBruteLoss()

// broken or ripped off organs will add quite a bit of pain
/mob/living/carbon/human/updateshock()
	..()
	for(var/obj/item/organ/external/organ in organs)
		if(organ && (organ.is_broken() || (!BP_IS_ROBOTIC(organ) && organ.open)))
			traumatic_shock += 30

	return traumatic_shock

/mob/living/carbon/human/getPainFromDam()
	var/value = 0
	for(var/obj/item/organ/external/organ in organs)
		value += organ.burn_dam
		value += organ.brute_dam
		value *= max((get_specific_organ_efficiency(OP_NERVE, organ.organ_tag)/100), 0.5)
	return value

/mob/living/carbon/proc/handle_shock()
	updateshock()
