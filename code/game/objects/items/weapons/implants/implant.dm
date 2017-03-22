#define MALFUNCTION_TEMPORARY 1
#define MALFUNCTION_PERMANENT 2

/obj/item/weapon/implant
	name = "implant"
	icon = 'icons/obj/device.dmi'
	icon_state = "implant"
	w_class = 1
	var/implanted = null
	var/mob/imp_in = null
	var/obj/item/organ/external/part = null
	var/implant_color = "b"
	var/allow_reagents = 0
	var/malfunction = 0
	var/legal = TRUE

/obj/item/weapon/implant/proc/trigger(emote, source as mob)
	return

/obj/item/weapon/implant/proc/activate()
	return

/obj/item/weapon/implant/proc/install(var/mob/living/carbon/human/H, affected_organ)
	src.loc = H
	src.imp_in = H
	src.implanted = TRUE
	var/obj/item/organ/external/affected = H.get_organ(affected_organ)
	affected.implants += src
	src.part = affected
	BITSET(H.hud_updateflag, IMPLOYAL_HUD)

/obj/item/weapon/implant/proc/get_data()
	return "No information available"

/obj/item/weapon/implant/proc/hear(message, source as mob)
	return

/obj/item/weapon/implant/proc/meltdown()	//breaks it down, making implant unrecongizible
	imp_in << "<span class='warning'>You feel something melting inside [part ? "your [part.name]" : "you"]!</span>"
	if (part)
		part.take_damage(burn = 15, used_weapon = "Electronics meltdown")
	else
		var/mob/living/M = imp_in
		M.apply_damage(15,BURN)
	name = "melted implant"
	desc = "Charred circuit in melted plastic case. Wonder what that used to be..."
	icon_state = "implant_melted"
	malfunction = MALFUNCTION_PERMANENT

/obj/item/weapon/implant/Destroy()
	if(part)
		part.implants.Remove(src)
	..()
