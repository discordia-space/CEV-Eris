/obj/machinery/gym
	name = "Advanced Arcade Machine"
	desc = "Links with your brain to reduce lag to minimum. Now, success really does depend only on your skill!"
	icon = 'icons/obj/machines/gym.dmi'
	icon_state = "vigilance"

	var/stat_used = STAT_VIG //STAT_TGH, STAT_ROB or STAT_VIG
	var/mob/living/carbon/human/occupant
	var/unlocked = FALSE

	density = TRUE
	anchored = TRUE
	circuit = null //cannot be deconstructed

	use_power = IDLE_POWER_USE
	idle_power_usage = 60
	active_power_usage = 400

/obj/machinery/gym/robustness
	name = "Interim Resistive Exercise Device"
	desc = "This device uses a system of vacuum tubes and flywheel cables to simulate the process of free weight exercises that increase your strength. Are those barbells decorative...?"
	icon_state = "robustness"

	stat_used = STAT_ROB

/obj/machinery/gym/toughness
	name = "Total Resistance Punch Machine"
	desc = "Whatever the reason behind creating this thing is, experiencing the life of a punching bag really helps you become tougher."
	icon_state = "toughness"

	stat_used = STAT_TGH

/obj/machinery/gym/power_change()
	..()
	if(stat & BROKEN)
		update_icon()

/obj/machinery/gym/emag_act(remaining_charges, mob/user, emag_source)
	emagged = TRUE

/obj/machinery/gym/Destroy()
	if(occupant)
		occupant.ghostize(0)
		occupant.gib()
	return ..()

/obj/machinery/gym/relaymove(mob/occupant)
	if(occupant.incapacitated()) //Lost consciousness while lifting weights? Too bad, you HAVE to finish.
		return
	go_out(FALSE)
	return

/obj/machinery/gym/proc/go_out(var/finished_using)
	if(finished_using)

		spawn(1.5 SECONDS)
			state("Thank you for using club services! Please come back soon.")
			playsound(loc, "robot_talk_light", 100, 0, 0)
		
		if(occupant.rest_points > 0)
			to_chat(occupant, SPAN_NOTICE("You feel yourself become stronger..."))
			occupant.playsound_local(get_turf(occupant), 'sound/sanity/rest.ogg', 100)
			occupant.stats.changeStat(stat_used, rand(8, 10))

		else
			to_chat(occupant, SPAN_NOTICE("You did become stronger, you think... But not permanently. Perhaps you need to rest first?"))//probably should be changed
			occupant.stats.addTempStat(stat_used, 15, 10 MINUTES)

		occupant.stats.addPerk(PERK_COOLDOWN_EXERTION)
		unlocked = FALSE

	occupant.forceMove(loc)
	occupant.reset_view()
	occupant.unset_machine()
	occupant = null

	update_use_power(1)
	update_icon()

/obj/machinery/gym/attack_hand(mob/user)
	if(!ishuman(user))
		return

	if(stat & (NOPOWER|BROKEN))
		return

	if(user.stats.getPerk(PERK_COOLDOWN_REASON))
		to_chat(user, SPAN_WARNING("Your mind feels too dim to properly use this."))
		return

	if(user.stats.getPerk(PERK_COOLDOWN_EXERTION))
		to_chat(user, SPAN_WARNING("Your muscles hurt too much use this."))
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

/obj/machinery/gym/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/gym_ticket))
		var/obj/item/gym_ticket/G = I
		if(G.use())
			state("This machine is now unlocked for use.")
			unlocked = TRUE
			return

	..()

//Vigilance animation
/obj/machinery/gym/update_icon()

	cut_overlays()

	icon_state = "vigilance"

	if(stat & (NOPOWER|BROKEN))
		icon_state = "vigilance_off"

	if(occupant)
		var/image/occupant_image = image(occupant.icon, loc, occupant.icon_state, 4, NORTH)
		occupant_image.overlays = occupant.overlays

		overlays += occupant_image

		icon_state = "vigilance_active"

//Toughness animation
/obj/machinery/gym/toughness/update_icon()

	cut_overlays()

	icon_state = "toughness"

	if(stat & (NOPOWER|BROKEN))
		icon_state = "toughness_off"

	if(occupant)
		var/image/occupant_image = image(occupant.icon, loc, occupant.icon_state, 4, NORTH, 0, 8)
		occupant_image.overlays = occupant.overlays

		overlays += occupant_image
		overlays += "toughness_overlay"

//Robustness animation
/obj/machinery/gym/robustness/update_icon()

	cut_overlays()

	icon_state = "robustness"

	if(occupant)
		var/image/occupant_image = image(occupant.icon, loc, occupant.icon_state, 4, SOUTH, 0, 16)
		var/image/robustness_overlay = image(icon, "robustness_overlay")
		robustness_overlay.layer = 4.5
		occupant_image.overlays = occupant.overlays

		overlays += occupant_image
		overlays += robustness_overlay

		icon_state = "robustness_base"
