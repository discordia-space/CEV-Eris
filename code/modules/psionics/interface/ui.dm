/obj/screen/psi
	icon = 'icons/HUD/psi.dmi'
	var/mob/living/owner
	var/hidden = TRUE

/obj/screen/psi/Initialize(mapload)
	. = ..()
	owner = loc
	loc = null
	update_icon()

/obj/screen/psi/Destroy()
	if(owner && owner.client)
		owner.client.screen -= src
	. = ..()

/obj/screen/psi/update_icon()
	if(hidden)
		invisibility = INVISIBILITY_MAXIMUM
	else
		invisibility = 0
