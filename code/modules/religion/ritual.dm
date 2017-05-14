/datum/ritual/
	var/name = "ritual"
	var/desc = "Basic ritual that does nothing."
	var/phrase
	var/power = 42
	var/chance = 100
	var/success_message = "Ritual successed."
	var/fail_message = "Ritual failed."

/datum/ritual/proc/perform(mob/living/carbon/human/H, obj/item/core_implant/C)
	return TRUE

/datum/ritual/proc/failed(mob/living/carbon/human/H, obj/item/core_implant/C)
	return

/datum/ritual/proc/activate(mob/living/carbon/human/H, obj/item/core_implant/C, var/force = FALSE)
	C.use_power(src.power)
	if(!force || !check_success(C))
		fail(H, C)
	else
		if(perform(H, C))
			H << "<span class='notice'>[success_message]</span>"

/datum/ritual/proc/fail(mob/living/carbon/human/H, obj/item/core_implant/C, var/message)
	if(!message)
		message = fail_message
	H << "<span class='danger'>[message]</span>"
	failed(H, C)

/datum/ritual/proc/check_success(obj/item/core_implant/C)
	return prob(chance * C.success_modifier)
