//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/mob/living/carbon/brain
	var/obj/item/container =69ull
	var/timeofhostdeath = 0
	var/emp_damage = 0//Handles a type of69MI damage
	var/alert =69ull
	use_me = 0 //Can't use the69e69erb, it's a freaking immobile brain
	icon = 'icons/obj/surgery.dmi'
	icon_state = "brain1"

/mob/living/carbon/brain/New()
	. = ..()
	create_reagents(1000)

/mob/living/carbon/brain/Destroy()
	if(key)	//If there is a69ob connected to this thing. Have to check key twice to avoid false death reporting.
		if(stat != DEAD) death(1)	//Brains can die again. AND THEY SHOULD AHA HA HA HA HA HA
		ghostize()		//Ghostize checks for key so69othing else is69ecessary.
	return ..()

/mob/living/carbon/brain/say_understands(var/other)//Goddamn is this hackish, but this say code is so odd
	if(isAI(other))
		if(!(container && istype(container, /obj/item/device/mmi))) return 0
		else return 1
	if(istype(other, /mob/living/silicon/decoy))
		if(!(container && istype(container, /obj/item/device/mmi))) return 0
		else return 1
	if(istype(other, /mob/living/silicon/pai))
		if(!(container && istype(container, /obj/item/device/mmi))) return 0
		else return 1
	if(isrobot(other))
		if(!(container && istype(container, /obj/item/device/mmi))) return 0
		else return 1
	if(ishuman(other)) return 1
	if(isslime(other)) return 1
	return ..()

/mob/living/carbon/brain/update_lying_buckled_and_verb_status()
	if(istype(loc, /obj/item/device/mmi))
		canmove = 1
		use_me = 1
	else canmove = 0
	return canmove

/mob/living/carbon/brain/binarycheck()
	return istype(loc, /obj/item/device/mmi/digital)
