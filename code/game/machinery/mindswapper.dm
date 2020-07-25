
/obj/machinery/mindswapper
	name = "experimental mind swapper"
	desc = "The name isn't descriptive enough?"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "grinder"
	density = TRUE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	// req_access = list(access_kitchen,access_morgue)
	circuit = /obj/item/weapon/circuitboard/mindswapper

	var/operating = FALSE  // Is it on?
	var/swap_time = 200  // Time from starting until minds are swapped
	var/swap_range = 1

	use_power = 1
	idle_power_usage = 2
	active_power_usage = 500

/obj/machinery/mindswapper/update_icon()
	overlays.Cut()
	if(stat & (NOPOWER|BROKEN))
		return
	/*if (operating) // Overlay when the mindswapper is active
		src.overlays += image('icons/obj/kitchen.dmi', "gruse")*/

/obj/machinery/mindswapper/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	if(operating)
		to_chat(user, SPAN_DANGER("The mind swapping process has been launched, there is no going back now."))
		return
	else
		src.startswapping(user)

/obj/machinery/mindswapper/attackby(obj/item/I, mob/user)
	..()

/obj/machinery/mindswapper/examine()
	..()
	to_chat(usr, "The safety is [emagged ? SPAN_DANGER("disabled") : "enabled"].")

/obj/machinery/mindswapper/emag_act(var/remaining_charges, var/mob/user)
	emagged = !emagged
	to_chat(user, SPAN_DANGER("You [emagged ? "disable" : "enable"] the mind swapper safety."))
	if(emagged)
		swap_time = 50
	else
		swap_time = 200
	return 1

/obj/machinery/mindswapper/proc/startswapping(mob/user as mob)
	if(src.operating)
		return

	use_power(1000)
	visible_message(SPAN_DANGER("You hear an increasingly loud humming coming from the mind swapper."))
	src.operating = TRUE
	update_icon()

	user.attack_log += "\[[time_stamp()]\] Triggered the mind swapper</b>"
	msg_admin_attack("[user.name] ([user.ckey]) triggered the mind swapper (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	spawn(swap_time)

		src.operating = FALSE
		playsound(src.loc, 'sound/effects/splat.ogg', 50, 1)
		operating = FALSE

        // Get all candidates in range for the mind swapping
		var/list/swapBoddies = list()
		var/list/swapMinds = list()
		for(var/mob/living/carbon/C in range(swap_range,src))
			swapBoddies += C
			swapMinds += C.ghostize(0)
        
		// Shuffle the list containing the candidates' boddies
		swapBoddies = shuffle(swapBoddies)

		// Perform the mind swapping
		var/i = 1
		for(var/mob/observer/ghost in swapMinds)
			ghost.mind.transfer_to(swapBoddies[i])
			if(ghost.key)
				var/mob/living/L = swapBoddies[i]
				L.key = ghost.key	//have to transfer the key since the mind was not active
			qdel(ghost)
			i += 1

		// Knock out all candidates
		for(var/mob/living/carbon/C in swapBoddies)
			C.Stun(2)
			C.Weaken(10)

		visible_message(SPAN_DANGER("You hear a loud electrical crack before the mind swapper shuts down."))
		update_icon()
