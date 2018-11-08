/mob/proc/get_all_hands()
	return list()

/mob/living/carbon/human/get_all_hands()
	return list(
		get_equipped_item(slot_l_hand),
		get_equipped_item(slot_r_hand)
	)