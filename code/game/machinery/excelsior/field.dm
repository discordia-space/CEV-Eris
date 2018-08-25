//Todo: make this thing work under new shield system
/obj/machinery/shieldwallgen/excelsior

	name = "Excelsior Shield Generator"
	desc = "A shield generator."
	icon = 'icons/obj/machines/excelsior/field.dmi'
	stun_chance = 90
	circuit = /obj/item/weapon/circuitboard/excelsiorshieldwallgen

/obj/machinery/shieldwallgen/excelsior/can_stun(var/mob/M)
	if(locate(/obj/item/weapon/implant/revolution/excelsior) in M)
		return FALSE

	return TRUE

/obj/machinery/shieldwallgen/excelsior/emag_act()
	return

/obj/machinery/shieldwallgen/excelsior/verb/toggle_stun()
	set name = "Toggle stun mode"
	set src in range(1)

	stunmode = !stunmode

	if(stunmode)
		usr << SPAN_NOTICE("You toggle on [src]'s stun mode.")
	else
		usr << SPAN_NOTICE("You toggle off [src]'s stun mode.")

