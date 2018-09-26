var/list/global_ritual_cooldowns = list() // internal lists. Use ritual's cooldown_category
/mob/living/carbon/human/var/list/personal_ritual_cooldowns = list()


/datum/ritual/
	var/name = "ritual"
	var/desc = "Basic ritual that does nothing."
	var/phrase = ""
	var/power = 0
	var/chance = 100
	var/success_message = "Ritual successed."
	var/fail_message = "Ritual failed."
	var/implant_type = /obj/item/weapon/implant/core_implant
	var/category = "???"

	var/cooldown = FALSE
	var/cooldown_time = 0
	var/cooldown_category = ""
	var/effect_time = 0

//code of ritual, returns true on success, can be interrupted with fail(H, C, targets) and return FALSE
/datum/ritual/proc/perform(mob/living/carbon/human/H, obj/item/weapon/implant/core_implant/C, targets)
	return TRUE

//ritual will be proceed only if this returns true
/datum/ritual/proc/pre_check(mob/living/carbon/human/H, obj/item/weapon/implant/core_implant/C, targets)
	if(cooldown && is_on_cooldown(H))
		fail("Litanies of this type can't be spoken too often.", H, C)
		return FALSE
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


//COOLDOWN STUFF
//sets global cooldown for ritual's cooldown category
/datum/ritual/proc/set_global_cooldown()
	if(src.cooldown)
		global_ritual_cooldowns[src.cooldown_category] = TRUE
		addtimer(CALLBACK(src, .proc/reset_cooldown), src.cooldown_time)

//sets personal cooldown for user of ritual's cooldown category
/datum/ritual/proc/set_personal_cooldown(mob/living/carbon/human/user)
	if(src.cooldown)
		user.personal_ritual_cooldowns[src.cooldown_category] = TRUE
		addtimer(CALLBACK(src, .proc/reset_cooldown, user), src.cooldown_time)

//resets personal cooldown for user if he's not nil or resets global cooldown, internal proc
/datum/ritual/proc/reset_cooldown(mob/living/carbon/human/user)
	if(user)
		user.personal_ritual_cooldowns[src.cooldown_category] = FALSE
	else
		global_ritual_cooldowns[src.cooldown_category] = FALSE

//check's if ritual at personal or global cooldown
/datum/ritual/proc/is_on_cooldown(mob/living/carbon/human/user)
	if(global_ritual_cooldowns[src.cooldown_category])
		return TRUE
	if(user.personal_ritual_cooldowns[src.cooldown_category])
		return TRUE
	return FALSE

//HELPERS



//Getting mobs
/datum/ritual/proc/get_grabbed_mob(var/mob/living/carbon/human/user)
	var/obj/item/weapon/grab/G = locate(/obj/item/weapon/grab) in user

	if (G && G.affecting && istype(G.affecting, /mob/living))
		return G.affecting
	return null

/datum/ritual/proc/get_front_mob(var/mob/living/carbon/human/user)
	var/turf/T = get_step(user,user.dir)
	return (locate(/mob/living) in T)

/datum/ritual/proc/get_victim(var/mob/living/carbon/human/user)
	var/mob/living/L = get_grabbed_mob(user)
	if (!L)
		L = get_front_mob(user)
	return L


//Getting implants (from mobs usually)
/datum/ritual/proc/get_coreimplant(var/ctype = /obj/item/weapon/implant/core_implant, var/mob/living/H)
	var/obj/item/weapon/implant/core_implant/CI = locate(ctype) in H
	return CI

/datum/ritual/proc/get_implant_from_victim(var/mob/living/carbon/human/user, var/ctype = /obj/item/weapon/implant/core_implant)
	var/mob/living/L = get_victim(user)
	return get_coreimplant(ctype, L)


//Getting other objects
/datum/ritual/proc/get_front(var/mob/living/carbon/human/user)
	var/turf/T = get_step(user,user.dir)
	return T.contents