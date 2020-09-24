//Has processes for all internal organs, called from /mob/living/carbon/human/Life()

/mob/living/carbon/human/proc/porcess_internal_ograns() //Calls all of the internal organ processes
	eye_process()

/mob/living/carbon/human/proc/get_organ_quality(bodypart_define)
	var/obj/item/organ/internal/I = internal_organs_by_name[bodypart_define] //Change this to not a dumb list
	return I?.quality

/mob/living/carbon/human/proc/eye_process()
	var/eye_quality = get_organ_quality(BP_EYES)

	if(eye_quality < 66)	//Turn these random numbers to reflect on organ bruised/broken defines
		eye_blurry = 20
	if(is_broken())
		eye_blind = 20
	update_client_colour()

