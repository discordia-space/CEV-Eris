/mob/living/var/traumatic_shock = 0
/mob/living/carbon/var/shock_stage = 0

// proc to find out in how much pain the mob is at the moment
/mob/living/carbon/proc/updateshock()
	if (species && (species.flags & NO_PAIN))
		src.traumatic_shock = 0
		return 0

	src.traumatic_shock = 			\
	1	* src.getOxyLoss() + 		\
	0.7	* src.getToxLoss() + 		\
	1.5	* src.getFireLoss() + 		\
	1.2	* src.getBruteLoss() + 		\
	1.7	* src.getCloneLoss() + 		\
	2	* src.halloss + 			\
	-1	* src.analgesic

	if(src.slurring)
		src.traumatic_shock -= 20

	if(src.traumatic_shock < 0)
		src.traumatic_shock = 0

	return src.traumatic_shock

// broken or ripped off organs will add quite a bit of pain
/mob/living/carbon/human/updateshock()
	..()
	for(var/obj/item/organ/external/organ in organs)
		if(organ && (organ.is_broken() || organ.open))
			traumatic_shock += 30

	return traumatic_shock


/mob/living/carbon/proc/handle_shock()
	updateshock()
