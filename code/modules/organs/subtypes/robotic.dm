/obj/item/organ/external/robotic
	name = "robotic"
	force_icon = 'icons/mob/human_races/robotic.dmi'
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	dislocated = -1
	cannot_break = 1
	status = ORGAN_ROBOT
	robotic = ORGAN_ROBOT
	brute_mod = 0.8
	burn_mod = 0.8
	var/list/forced_children = null
	var/attack = 0 			//Attack mode

/obj/item/organ/external/robotic/set_description(var/datum/organ_description/desc)
	src.name = "[name] [desc.name]"
	src.limb_name = desc.organ_tag
	src.amputation_point = desc.amputation_point
	src.joint = desc.joint

/obj/item/organ/external/robotic/install()
	if(..()) return 1
	if(islist(forced_children) && forced_children[organ_tag])
		var/list/spawn_part = forced_children[organ_tag]
		var/child_type
		for(var/name in spawn_part)
			child_type = spawn_part[name]
			new child_type(owner, owner.species.has_limbs[name])
	if(can_activate())
		activate()

/*/obj/item/organ/external/robotic/sync_colour_to_owner()
	for(var/obj/item/organ/I in internal_organs)
		I.sync_colour_to_owner()*/

	if(gender)
		gender = (owner.gender == MALE)? "_m": "_f"

/*/obj/item/organ/external/robotic/get_icon()
	icon_state = "[organ_tag][gender][owner.body_build]"

	mob_icon = new /icon(icon_name, icon_state)
	return mob_icon
*/
/*
/obj/item/organ/external/robotic/apply_colors()
	return

/obj/item/organ/external/robotic/get_icon_key()
	. = "robotic[model]"
*/

/obj/item/organ/external/robotic/Destroy()
	deactivate(1)
	..()

/obj/item/organ/external/robotic/removed()
	deactivate(1)
	..()

/obj/item/organ/external/robotic/update_germs()
	germ_level = 0
	return

/obj/item/organ/external/robotic/proc/can_activate()
	return 1

/obj/item/organ/external/robotic/proc/activate()
	return 1

/obj/item/organ/external/robotic/proc/deactivate(var/emergency = 1)
	return 1

/obj/item/organ/external/robotic/limb
	max_damage = 50
	min_broken_damage = 30
	w_class = 3

/obj/item/organ/external/robotic/tiny
	min_broken_damage = 15
	w_class = 2

