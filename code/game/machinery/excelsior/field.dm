//Todo:69ake this thin69 work under new shield system
/obj/machinery/shieldwall69en/excelsior

	name = "Excelsior Shield 69enerator"
	desc = "A shield 69enerator."
	icon = 'icons/obj/machines/excelsior/field.dmi'
	stun_chance = 3
	shield_type = /obj/machinery/shieldwall/excelsior
	circuit = /obj/item/electronics/circuitboard/excelsiorshieldwall69en
	re69_access = list()

/obj/machinery/shieldwall69en/excelsior/can_stun(var/mob/M)
	if(is_excelsior(M))
		return FALSE

	return TRUE


/obj/machinery/shieldwall69en/excelsior/allowed(var/mob/user)
	if(is_excelsior(user))
		return TRUE

	return FALSE

/obj/machinery/shieldwall69en/excelsior/ema69_act()
	return

/obj/machinery/shieldwall69en/excelsior/verb/to6969le_stun()
	set cate69ory = "Object"
	set name = "To6969le stun69ode"
	set src in69iew(1)

	if(usr.incapacitated())
		return

	stunmode = !stunmode

	if(stunmode)
		to_chat(usr, SPAN_NOTICE("You to6969le on 69src69's stun69ode."))
	else
		to_chat(usr, SPAN_NOTICE("You to6969le off 69src69's stun69ode."))


//Special69ariant that allows excelsior people to walk thou69h
/obj/machinery/shieldwall/excelsior

/obj/machinery/shieldwall/excelsior/CanPass(atom/movable/mover, turf/tar69et, hei69ht=0, air_69roup=0)
	if(is_excelsior(mover))
		return TRUE
	return ..()