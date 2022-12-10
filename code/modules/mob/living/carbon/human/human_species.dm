/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH

/mob/living/carbon/human/monkey
	icon_state = "monkey"

/mob/living/carbon/human/monkey/New(var/new_loc)
	..(new_loc, "Monkey")

/mob/living/carbon/human/dummy/mannequin/Initialize()
	. = ..()
	STOP_PROCESSING(SSmobs, src)
	GLOB.human_mob_list -= src
	delete_inventory()

/mob/living/carbon/human/dummy/mannequin/fully_replace_character_name(var/oldname, var/newname)
	..(newname = "[newname] (mannequin)")

/mob/living/carbon/human/skeleton
	icon_state = "skeleton"

/mob/living/carbon/human/skeleton/New(new_loc)
	..(new_loc, SPECIES_SKELETON)
	STOP_PROCESSING(SSmobs, src)
	death(FALSE)
	GLOB.human_mob_list -= src
