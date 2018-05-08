/obj/item/organ/external/robotic
	name = "robotic"
	force_icon = 'icons/mob/human_races/robotic.dmi'
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	dislocated = -1
	cannot_break = 1
	robotic = ORGAN_ROBOT
	brute_mod = 0.8
	burn_mod = 0.8
	var/list/forced_children = null

/obj/item/organ/external/robotic/get_cache_key()
	return "Robotic[model]"

/obj/item/organ/external/robotic/update_icon()
	var/gender = "m"
	var/body = ""
	if(owner)
		gender = owner.gender == FEMALE ? "f" : "m"
		body = owner.body_build.index
	icon_state = "[organ_tag]_[gender][body]"
	mob_icon = icon(force_icon, icon_state)
	return mob_icon

/obj/item/organ/external/robotic/set_description(var/datum/organ_description/desc)
	src.name = "[name] [desc.name]"
	src.organ_tag = desc.organ_tag
	src.amputation_point = desc.amputation_point
	src.joint = desc.joint


/obj/item/organ/external/robotic/Destroy()
	deactivate(1)
	. = ..()

/obj/item/organ/external/robotic/removed()
	deactivate(1)
	..()

/obj/item/organ/external/robotic/update_germs()
	germ_level = 0
	return

/obj/item/organ/external/robotic/setBleeding()
	return FALSE

/obj/item/organ/external/robotic/proc/can_activate()
	return 1

/obj/item/organ/external/robotic/proc/activate()
	return 1

/obj/item/organ/external/robotic/proc/deactivate(var/emergency = 1)
	return 1

/obj/item/organ/external/robotic/limb
	max_damage = 50
	min_broken_damage = 30
	w_class = ITEM_SIZE_NORMAL

/obj/item/organ/external/robotic/tiny
	min_broken_damage = 15
	w_class = ITEM_SIZE_SMALL

