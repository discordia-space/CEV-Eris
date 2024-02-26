/obj/machinery/braingym
	name = "Advanced Terminal"
	desc = "Read advanced lessons of various field of science, increase your knowledge."
	description_info = "Exercise machines can be used to increase your stats, either permanently, by using a rest point, or temporary."
	icon = 'icons/obj/machines/gym.dmi'
	icon_state = "cognition"

	var/stat_used = STAT_COG //STAT_TGH, STAT_ROB, STAT_VIG, STAT_COG, STAT_MEC, STAT_BIO
	var/mob/living/carbon/human/occupant
	var/unlocked = FALSE

	density = TRUE
	anchored = TRUE
	circuit = null //cannot be deconstructed

	use_power = IDLE_POWER_USE
	idle_power_usage = 60
	active_power_usage = 400

/obj/machinery/braingym/biology
	name = "Microbiology Data-Bank"
	desc = "A compilation of scintific data concerning several micro-organisms and their mutations."
	icon_state = "biology"

	stat_used = STAT_BIO

/obj/machinery/braingym/mechanical
	name = "Industrial Electro-Claw"
	desc = "A claw capable of generating its own electric arc, used in the ship building industry, operating one require good mechanical skills."
	icon_state = "mechanic"

	stat_used = STAT_MEC

/obj/machinery/braingym/power_change()
	..()
	if(stat & BROKEN || stat & NOPOWER)
		update_icon()

/obj/machinery/braingym/emag_act(remaining_charges, mob/user, emag_source)
	emagged = TRUE

/obj/machinery/braingym/Destroy()
	if(occupant)
		go_out(FALSE)
	return ..()

/obj/machinery/braingym/relaymove(mob/occupant)
	if(!occupant.incapacitated()) //Lost consciousness while thinking? Too bad, you HAVE to finish.
		go_out(FALSE)

/obj/machinery/braingym/proc/go_out(finished_using)
	if(finished_using)
		spawn(1.5 SECONDS)
			state("Thank you for using club services! Please come back soon.")
			playsound(loc, "robot_talk_light", 100, 0, 0)

		if(occupant.rest_points > 0)
			to_chat(occupant, SPAN_NOTICE("You feel yourself become smarter..."))
			occupant.playsound_local(get_turf(occupant), 'sound/sanity/rest.ogg', 100)
			occupant.stats.changeStat(stat_used, rand(15, 20))
			occupant.rest_points--

		else
			to_chat(occupant, SPAN_NOTICE("You did become smarter, you think... But not permanently. Perhaps you need to rest first?"))
			occupant.stats.addTempStat(stat_used, 15, 10 MINUTES)

		occupant.stats.addPerk(PERK_COOLDOWN_REASON)
		unlocked = FALSE

	occupant.forceMove(loc)
	occupant.reset_view()
	occupant.unset_machine()
	occupant = null

	update_use_power(1)
	update_icon()


/obj/machinery/braingym/attack_hand(mob/user)
	if(!ishuman(user))
		return

	if(stat & (NOPOWER|BROKEN))
		return

	if(user.stats.getPerk(PERK_COOLDOWN_REASON))
		to_chat(user, SPAN_WARNING("Your mind feels too dim to properly use this. You need to rest before you exercise again."))
		return

	if(!unlocked && !emagged)
		state(SPAN_WARNING("A payment ticket is required to use this machine."))
		return

	if(occupant)
		to_chat(user, SPAN_WARNING("The machine is already occupied!"))
		return

	user.forceMove(src)
	occupant = user
	update_use_power(2)
	user.set_machine(src)

	add_fingerprint(user)
	update_icon()
	sleep(15 SECONDS)

	if(occupant)//is user still using our machine?
		go_out(TRUE)
		update_icon()

/obj/machinery/braingym/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/gym_ticket))
		var/obj/item/gym_ticket/G = I
		if(G.use())
			state("This machine is now unlocked for use.")
			unlocked = TRUE
			return

	..()

/obj/machinery/braingym/update_icon() // Cognition animation
	cut_overlays()
	icon_state = (stat & (NOPOWER|BROKEN)) ? "cognition_off" : "cognition"
	if(occupant)
		var/image/occupant_image = image(occupant.icon, loc, occupant.icon_state, 4, NORTH, -3, -10)
		occupant_image.overlays = occupant.overlays
		overlays += occupant_image
		icon_state = "cognition_active"

/obj/machinery/braingym/biology/update_icon() // Biology animation
	cut_overlays()
	icon_state = (stat & (NOPOWER|BROKEN)) ? "biology_off" : "biology"
	if(occupant)
		var/image/occupant_image = image(occupant.icon, loc, occupant.icon_state, 4, NORTH, 0, -10)
		occupant_image.overlays = occupant.overlays
		overlays += occupant_image
		icon_state = "biology_active"

/obj/machinery/braingym/mechanical/update_icon() // Mechanic animation
	cut_overlays()
	icon_state = "mechanic"
	if(occupant)
		var/image/occupant_image = image(occupant.icon, loc, occupant.icon_state, 4, NORTH, 0, -10)
		occupant_image.overlays = occupant.overlays
		overlays += occupant_image
		icon_state = "mechanic_active"
