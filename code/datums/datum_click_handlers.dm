/datum/click_handler
//	var/mob_type
	var/species
	var/handler_name
	var/one_use_flag = 1//drop client.CH after succes ability use
	var/client/owner
	var/icon/mouse_icon

/datum/click_handler/New(client/_owner)
	owner = _owner
	if (mouse_icon)
		owner.mouse_pointer_icon = mouse_icon

//datum/click_handler/Prepare(/client/_owner)

/datum/click_handler/Destroy()
	..()
	if (owner)
		owner.CH = null
		owner.mouse_pointer_icon=initial(owner.mouse_pointer_icon)
	return ..()
//	owner = null

//Return false from these procs to discard the click afterwards
/datum/click_handler/proc/Click(var/atom/target, location, control, params)
	if (!isHUDobj(target))
		if (mob_check(owner.mob) && use_ability(owner.mob, target))
			//Ability successful
			if (one_use_flag)
				//If we're single use, delete ourselves anyways
				qdel(src)
		else
			//Ability fail, delete ourselves
			to_chat(owner.mob, "For some reason you can't use [handler_name] ability")
			qdel(src)

		return FALSE //As long as we're not clicking a hud object, we drop the click
	return TRUE

/datum/click_handler/proc/MouseDown(object,location,control,params)
	return TRUE

/datum/click_handler/proc/MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
	return TRUE

/datum/click_handler/proc/MouseUp(object,location,control,params)
	return TRUE


/datum/click_handler/proc/mob_check(mob/living/carbon/human/user) //Check can mob use a ability
	return

/datum/click_handler/proc/use_ability(mob/living/carbon/human/user,atom/target)
	return

//Tests whether the target thing is valid, and returns it if so.
//If its not valid, null will be returned
//In the case of click catchers, we resolve and return the turf under it
/datum/click_handler/proc/resolve_world_target(var/a)

	if (istype(a, /obj/screen/click_catcher))
		var/obj/screen/click_catcher/CC = a
		return CC.resolve(owner.mob)

	if (istype(a, /turf))
		return a

	else if (istype(a, /atom))
		var/atom/A = a
		if (istype(A.loc, /turf))
			return A
	return null

/****************************
	Full auto gunfire
*****************************/
/datum/click_handler/fullauto
	var/atom/target = null
	var/firing = FALSE
	var/obj/item/weapon/gun/reciever //The thing we send firing signals to.
	//Todo: Make this work with callbacks

/datum/click_handler/fullauto/Click()
	return TRUE //Doesn't work with normal clicks

/datum/click_handler/fullauto/proc/start_firing()
	firing = TRUE
	while (firing && target)
		do_fire()
		sleep(0.5) //Keep spamming events every frame as long as the button is held
	stop_firing()

//Next loop will notice these vars and stop shooting
/datum/click_handler/fullauto/proc/stop_firing()
	firing = FALSE
	target = null
	if(reciever)
		reciever.cursor_check()

/datum/click_handler/fullauto/proc/do_fire()
	reciever.afterattack(target, owner.mob, FALSE)

/datum/click_handler/fullauto/MouseDown(object,location,control,params)
	object = resolve_world_target(object)
	if (object)
		target = object
		owner.mob.face_atom(target)
		spawn()
			start_firing()
		return FALSE
	return TRUE

/datum/click_handler/fullauto/MouseDrag(over_object,src_location,over_location,src_control,over_control,params)
	src_location = resolve_world_target(src_location)
	if (src_location && firing)
		target = src_location //This var contains the thing the user is hovering over, oddly
		owner.mob.face_atom(target)
		return FALSE
	return TRUE

/datum/click_handler/fullauto/MouseUp(object,location,control,params)
	stop_firing()
	return TRUE

/datum/click_handler/fullauto/Destroy()
	stop_firing()//Without this it keeps firing in an infinite loop when deleted
	.=..()









/datum/click_handler/human/mob_check(mob/living/carbon/human/user)
	if(ishuman(user))
		if(user.species.name == src.species)
			return 1
	return 0

/datum/click_handler/human/use_ability(mob/living/carbon/human/user,atom/target)
	return

//Changeling CH

/datum/click_handler/changeling
	mouse_icon = icon ('icons/changeling_mouse_icons.dmi')

/datum/click_handler/changeling/mob_check(mob/living/carbon/human/user)
	if(ishuman(user) && user.mind && user.mind.changeling)
		return 1
	return 0

/datum/click_handler/changeling/use_ability(mob/living/carbon/human/user,atom/target) //Check can mob use a ability
	if (user.stat == DEAD)
		to_chat(user, "No! You dead!")
		user.kill_CH()
		return 0
	if (istype(user.loc, /obj/mecha))
		to_chat(user, "Cannot use [handler_name] in mecha!")
		user.kill_CH()
		return 0

/datum/click_handler/changeling/changeling_lsdsting
	handler_name = "Hallucination Sting"

/datum/click_handler/changeling/changeling_lsdsting/use_ability(mob/living/carbon/human/user,atom/target)
	..()
	return user.changeling_lsdsting(target)

/datum/click_handler/changeling/changeling_silence_sting
	handler_name = "Silence Sting"

/datum/click_handler/changeling/changeling_silence_sting/use_ability(mob/living/carbon/human/user,atom/target)
	..()
	return user.changeling_silence_sting(target)

/datum/click_handler/changeling/changeling_blind_sting
	handler_name = "Blind Sting"

/datum/click_handler/changeling/changeling_blind_sting/use_ability(mob/living/carbon/human/user,atom/target)
	..()
	return user.changeling_blind_sting(target)

/datum/click_handler/changeling/changeling_deaf_sting
	handler_name = "Deaf Sting"

/datum/click_handler/changeling/changeling_deaf_sting/use_ability(mob/living/carbon/human/user,atom/target)
	..()
	return user.changeling_deaf_sting(target)

/datum/click_handler/changeling/changeling_paralysis_sting
	handler_name = "Paralysis Sting"

/datum/click_handler/changeling/changeling_paralysis_sting/use_ability(mob/living/carbon/human/user,atom/target)
	..()
	return user.changeling_paralysis_sting(target)

/datum/click_handler/changeling/changeling_transformation_sting
	handler_name = "Transformation Sting"
	var/datum/dna/chosen_dna

/datum/click_handler/changeling/changeling_transformation_sting/New(client/_owner, var/datum/dna/sended_dna)
	..()
	chosen_dna = sended_dna

/datum/click_handler/changeling/changeling_transformation_sting/use_ability(mob/living/carbon/human/user,atom/target)
	..()
	return user.changeling_transformation_sting(target, chosen_dna)

/datum/click_handler/changeling/changeling_unfat_sting
	handler_name = "Unfat Sting"

/datum/click_handler/changeling/changeling_unfat_sting/use_ability(mob/living/carbon/human/user,atom/target)
	..()
	return user.changeling_unfat_sting(target)

/datum/click_handler/changeling/changeling_DEATHsting
	handler_name = "Death Sting"

/datum/click_handler/changeling/changeling_DEATHsting/use_ability(mob/living/carbon/human/user,atom/target)
	..()
	return user.changeling_DEATHsting(target)

/datum/click_handler/changeling/changeling_extract_dna_sting
	handler_name = "Extract DNA Sting"

/datum/click_handler/changeling/changeling_extract_dna_sting/use_ability(mob/living/carbon/human/user,atom/target)
	..()
	return user.changeling_extract_dna_sting(target)