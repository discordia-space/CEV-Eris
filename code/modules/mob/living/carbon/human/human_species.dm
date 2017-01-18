/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH

/mob/living/carbon/human/monkey
	icon_state = "monkey"

/mob/living/carbon/human/monkey/New(var/new_loc)
	..(new_loc, "Monkey")
