var/list/communists = list()

/obj/item/weapon/implant/core_implant/complant
	name = "complant"
	icon_state = ""
	desc = ""
	allowed_organs = list(BP_HEAD)
	implant_type = /obj/item/weapon/implant/core_implant/complant
	external = FALSE

/obj/item/weapon/implant/core_implant/complant/hard_eject()
	if(!ishuman(wearer))
		return
	var/mob/living/carbon/human/H = wearer
	if(H.stat == DEAD)
		return
	if(part)
		part.droplimb(FALSE, DROPLIMB_BLUNT) //Explode head

/obj/item/weapon/implant/core_implant/complant/activate()
	if(!wearer || active)
		return
	..()
	communists |= wearer

/obj/item/weapon/implant/core_implant/complant/deactivate()
	if(!active || !wearer)
		return
	communists.Remove(wearer)
	..()

/obj/item/weapon/implant/core_implant/complant/process()
	..()
	if(wearer && wearer.stat == DEAD)
		deactivate()


////////////////////////////////

/mob/proc/get_complant()
	var/obj/item/weapon/implant/core_implant/C = locate(/obj/item/weapon/implant/core_implant/complant, src)
	return C
