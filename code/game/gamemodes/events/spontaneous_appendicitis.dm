/*
	Disabled for now, baymed is coming.

	Possible future todo: Add a random (not-viral) disease event for stuff like this with a bigger content pool
*/

/datum/event/spontaneous_appendicitis/start()
	for(var/mob/living/carbon/human/H in shuffle(GLOB.living_mob_list))
		if(H.client && H.stat != DEAD)
			var/obj/item/organ/internal/appendix/A = H.random_organ_by_process(OP_APPENDIX)
			if(!istype(A) || A.inflamed)
				continue
			A.inflamed = 1
			A.update_icon()
			break
