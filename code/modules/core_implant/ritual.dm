/datum/ritual/
	var/name = "ritual"
	var/desc = "Basic ritual that does nothing."
	var/phrase = ""
	var/power = 0
	var/chance = 100
	var/success_message = "Ritual successed."
	var/fail_message = "Ritual failed."
	var/implant_type = /obj/item/weapon/implant/core_implant

//code of ritual, returns true on success, can be interrupted with fail(H, C, targets) and return FALSE
/datum/ritual/proc/perform(mob/living/carbon/human/H, obj/item/weapon/implant/core_implant/C, targets)
	return TRUE

//ritual will be proceed only if this returns true
/datum/ritual/proc/pre_check(obj/living/carbon/human/H, obj/item/weapon/implant/core_implant/C, targets)
	return TRUE

//code of ritual fail, called by fail(H,C,targets)		'on_chance' will be true, if ritual failed on chance check
/datum/ritual/proc/failed(mob/living/carbon/human/H, obj/item/weapon/implant/core_implant/C, targets, on_chance = FALSE)
	return

/datum/ritual/proc/activate(mob/living/carbon/human/H, obj/item/weapon/implant/core_implant/C, var/list/targets, var/force = FALSE)
	if(!pre_check(H,C,targets))
		return
	if(!force && !check_success(C))
		H << SPAN_DANGER("[fail_message]")
		failed(H, C, targets, TRUE)
	else
		if(perform(H, C, targets))
			C.use_power(src.power)
			H << SPAN_NOTICE("[success_message]")

/datum/ritual/proc/fail(var/message, mob/living/carbon/human/H, obj/item/weapon/implant/core_implant/C, targets)
	if(!message)
		message = fail_message
	H << SPAN_DANGER("[message]")
	failed(H, C, targets)

/datum/ritual/proc/check_success(obj/item/weapon/implant/core_implant/C)
	return prob(chance * C.success_modifier)

/datum/ritual/proc/is_allowed(obj/item/weapon/implant/core_implant/C)
	return TRUE

//returns phrase to say, may require to specify target
/datum/ritual/proc/get_say_phrase()
	return phrase

//returns phrase to display in bible
/datum/ritual/proc/get_display_phrase()
	return phrase

//returns true, if text is phrase of this ritual
/datum/ritual/proc/compare(var/text)
	return phrase && phrase != "" && text == phrase

//returns list of targets, specified in text
/datum/ritual/proc/get_targets(var/text)
	return list()


//HELPERS

/datum/ritual/proc/get_coreimplant(var/ctype, var/mob/living/carbon/human/H)
	var/obj/item/weapon/implant/core_implant/CI = locate(ctype) in H
	return CI


/datum/ritual/proc/get_grabbed(var/mob/living/carbon/human/user)
	var/obj/item/weapon/grab/G = locate(/obj/item/weapon/grab) in user
	var/obj/item/weapon/implant/core_implant/CI

	if(G)
		CI = locate(implant_type) in G.affecting

	return CI

/datum/ritual/proc/get_front(var/mob/living/carbon/human/user)
	var/turf/T = get_step(user,user.dir)
	return T.contents