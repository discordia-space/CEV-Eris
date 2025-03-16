/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH

/mob/living/carbon/human/monkey
	icon_state = "monkey"

/mob/living/carbon/human/monkey/Initialize(var/new_loc)
	..(new_loc, "Monkey")

/mob/living/carbon/human/dummy/mannequin/Initialize()
	. = ..()
	GLOB.human_mob_list -= src
	GLOB.living_mob_list -= src
	GLOB.player_list -= src
	qdel(sanity) //Sanity datum onLife() proc is its own set of timers independant from /mob/proc/Life(), this removes references that might try to ping it
	sanity = null
	delete_inventory()

/mob/living/carbon/human/dummy/mannequin/fully_replace_character_name(var/oldname, var/newname)
	..(newname = "[newname] (mannequin)")

/mob/living/carbon/human/dummy/mannequin/Life()		//Disables mannequin from doing more than processing this one Life(), stops organ processing
	return

/mob/living/carbon/human/skeleton
	icon_state = "skeleton"

/mob/living/carbon/human/skeleton/Initialize(new_loc)
	. = ..(new_loc, SPECIES_SKELETON)
	death(FALSE)
	GLOB.human_mob_list -= src
