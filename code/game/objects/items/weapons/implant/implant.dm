#define MALFUNCTION_NONE 0
#define MALFUNCTION_TEMPORARY 1
#define MALFUNCTION_PERMANENT 2

/obj/item/weapon/implant
	name = "implant"
	icon = 'icons/obj/device.dmi'
	icon_state = "implant"
	w_class = 1
	var/implanted = FALSE
	var/mob/wearer = null
	var/obj/item/organ/external/part = null
	var/implant_color = "b"
	var/allow_reagents = FALSE
	var/malfunction = MALFUNCTION_NONE
	var/is_legal = TRUE
	var/list/allowed_organs = list()
	var/position_flag = 0

/obj/item/weapon/implant/proc/trigger(emote, mob/living/source)
/obj/item/weapon/implant/proc/activate()
/obj/item/weapon/implant/proc/deactivate()
/obj/item/weapon/implant/proc/malfunction(var/severity)

/obj/item/weapon/implant/proc/is_external()
	return istype(src, /obj/item/weapon/implant/external)

//return TRUE for implanter icon update.
/obj/item/weapon/implant/proc/install(var/mob/living/carbon/human/target, var/organ, var/mob/user)
	var/obj/item/organ/external/affected = target.organs_by_name[organ]
	if(!affected)
		if(allowed_organs.len)
			organ = pick(allowed_organs)
		else
			organ = BP_CHEST
	affected = target.organs_by_name[organ]

	if(!affected)
		user << "<span class='warning'>[target] miss that body part!.</span>"
		return

	if(allowed_organs && allowed_organs.len && !(organ in allowed_organs))
		user << "<span class='warning'>[src] cannot be implanted in this limb.</span>"
		return

	forceMove(target)
	wearer = target
	implanted = TRUE
	if(affected)
		affected.implants += src
		part = affected
	if(ishuman(wearer))
		var/mob/living/carbon/human/H = wearer
		H.update_implants()
	on_install(target, affected)
	return TRUE

/obj/item/weapon/implant/proc/on_install(var/mob/living/target, var/obj/item/organ/external/E)

/obj/item/weapon/implant/proc/uninstall()
	forceMove(get_turf(wearer))
	part.implants.Remove(src)
	part = null
	implanted = FALSE
	if(ishuman(wearer))
		var/mob/living/carbon/human/H = wearer
		H.update_implants()
	wearer = null

/obj/item/weapon/implant/proc/get_data()
	return "No information available"

/obj/item/weapon/implant/proc/hear(message, mob/source)

/obj/item/weapon/implant/proc/meltdown()	//breaks it down, making implant unrecongizible
	wearer << "<span class='warning'>You feel something melting inside [part ? "your [part.name]" : "you"]!</span>"
	if (part)
		part.take_damage(burn = 15, used_weapon = "Electronics meltdown")
	else
		var/mob/living/M = wearer
		M.apply_damage(15,BURN)
	name = "melted implant"
	desc = "Charred circuit in melted plastic case. Wonder what that used to be..."
	icon_state = "implant_melted"
	malfunction = MALFUNCTION_PERMANENT

/obj/item/weapon/implant/proc/get_mob_overlay(var/gender, var/body_build)
	return null

/obj/item/weapon/implant/Destroy()
	if(part)
		part.implants.Remove(src)
	return ..()

/obj/item/weapon/implant/explosive/emp_act(severity)
	malfunction(severity)
