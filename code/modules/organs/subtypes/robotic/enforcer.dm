/obj/item/organ/external/robotic/enforcer
	default_icon = 'icons/mob/human_races/cyberlimbs/enforcer.dmi'
	brute_mod = 0.7
	burn_mod = 0.7

/obj/item/organ/external/robotic/enforcer/set_description()
	..()
	w_class ++ // I't large than normal organ

/obj/item/organ/external/robotic/enforcer/limb
	forced_children = list(
		BP_L_ARM = list(BP_L_HAND = /obj/item/organ/external/robotic/enforcer/hand),
		BP_R_ARM = list(BP_R_HAND = /obj/item/organ/external/robotic/enforcer/hand),
		BP_L_LEG = list(BP_L_FOOT = /obj/item/organ/external/robotic/enforcer),
		BP_R_LEG = list(BP_R_FOOT = /obj/item/organ/external/robotic/enforcer)
		)

/obj/item/organ/external/robotic/enforcer/hand
	var/datum/unarmed_attack/enforcer/active_atack = new

	activate()
		verbs += /obj/item/organ/external/robotic/enforcer/hand/proc/toggle
		owner << "<span class='notice'>Power system controller successfuly activated inside your [name].</span>"

	deactivate(emergency = 1)
		owner << "<span class = 'warning'>Your [name] power module has been emergency disabled!</span>"
		if(emergency)
			verbs -= /obj/item/organ/external/robotic/enforcer/hand/proc/toggle
			qdel(active_atack)

	proc/toggle()
		set name = "Toggle force mode"
		set category = "Prosthesis"
		set popup_menu = 0
		if(usr != owner || owner.stat || owner.restrained()) return
		if(in_use)
			owner << "<span class = 'warning'>Power system still toggling. Wait please.</span>"
		in_use = 1
		if(!attack)
			attack = active_atack
			owner.visible_message("<span class = 'warning'>[owner] activate \his [name]'s power system!</span>",\
				"<span class = 'notice'>Your [name]'s power system has been successfully activated.</span>",\
				"<span class = 'warning'>You hear loudly metal sound and hissing of steam jets.</span>")
		else
			attack = null
			owner.visible_message("<span class = 'notice'>[owner] disabled \his [name]'s power system.</span>",\
				"<span class = 'notice'>Your [name]'s power system has been successfully disabled.</span>",\
				"<span class = 'warning'>You hear loudly metal sound.</span>")
		sleep(60)
		in_use = 0

/datum/unarmed_attack/enforcer
	attack_verb = list("smash")
	attack_noun = list("fist")
	damage = 5
	attack_sound = "punch"
	shredding = 1
	is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)
		if(user.restrained()) return 0
		return 1


/obj/item/clothing/shoes/magboots/mounted
	var/atom/holder = null
	New(newloc)
		holder = newloc
		..()
	dropped()
		..()
		if(holder)
			forceMove(holder)

/obj/item/organ/external/robotic/enforcer/limb/leg
	var/obj/item/clothing/shoes/magboots/mounted/magboots = null
	var/obj/item/organ/external/robotic/enforcer/limb/slave = null

	can_activate()
		var/obj/item/organ/external/robotic/enforcer/limb/leg/other = null
		if(body_part == BP_L_LEG)
			other = owner.organs_by_name[BP_R_LEG]
		else
			other = owner.organs_by_name[BP_L_LEG]
		if(other && istype(other, type))
			other.slave = src
			return 0
		return 1

	activate()
		verbs += /obj/item/organ/external/robotic/enforcer/limb/leg/proc/toggle_magboots
		magboots = new(src)
		magboots.canremove = 0
		owner << "<span class='notice'>Magboots controller successfuly activated inside your [name].</span>"

	deactivate(emergency = 1)
		if(magboots)
			if(!(magboots in src))
				if(owner)
					owner << "<span class = 'warning'>Magboots module has been emergency disabled!</span>"
					owner.u_equip(magboots)
				magboots.forceMove(src)
			if(emergency)
				verbs -= /obj/item/organ/external/robotic/enforcer/limb/leg/proc/toggle_magboots
				qdel(magboots)
		if(slave && !deleted(slave) && slave.owner == owner)
			slave.activate()
			slave = null

	proc/toggle_magboots()
		set name = "Toggle Magboots"
		set category = "Prosthesis"
		set popup_menu = 0
		if(!owner || !magboots) //MB would be rewrited after forced toggle addition.
			usr << "<span class='warning'>You can't unload magboots when controller disabled.</span>"
			return
		if(owner.stat) return
		if(magboots in src)
			if(owner.equip_to_slot_if_possible(magboots, slot_shoes))
				usr << "<span class = 'notice'>The mag-pulse traction system has been activated.</span>"
		else
			owner.drop_from_inventory(magboots, src)
			usr << "<span class = 'notice'>The mag-pulse traction system has been disabled.</span>"
		return

