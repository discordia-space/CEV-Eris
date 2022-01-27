/obj/item/mine
	name = "landmine"
	desc = "An anti-personnel69ine. A danger to about everyone except those with a Pulsing tool."
	icon = 'icons/obj/machines/excelsior/objects.dmi'
	icon_state = "mine"
	w_class = ITEM_SIZE_BULKY
	matter = list(MATERIAL_STEEL = 35)
	matter_reagents = list("fuel" = 40)
	layer = BELOW_MOB_LAYER //fixed the wrong layer - Plasmatik
	rarity_value = 10
	spawn_tags = SPAWN_TAG_MINE_ITEM
	var/prob_explode = 90
	var/pulse_difficulty = FAILCHANCE_NORMAL

	//var/obj/item/device/assembly_holder/detonator = null

	var/fragment_type = /obj/item/projectile/bullet/pellet/fragment/weak
	var/spread_radius = 4
	var/num_fragments = 25
	var/damage_step = 2

	var/explosion_d_size = -1
	var/explosion_h_size = 1
	var/explosion_l_size = 2
	var/explosion_f_size = 15

	var/armed = FALSE
	var/deployed = FALSE
	var/excelsior = FALSE
	anchored = FALSE

/obj/item/mine/Initialize()
	. = ..()
	update_icon()

/obj/item/mine/excelsior
	name = "Excelsior69ine"
	desc = "An anti-personnel69ine. IFF technology grants safe passage to Excelsior agents, and a69erciful brief end to others, unless they have a Pulse tool nearby."
	icon_state = "mine_excel"
	matter = list(MATERIAL_STEEL = 15,69ATERIAL_PLASTIC = 10)
	excelsior = TRUE
	prob_explode = 100
	pulse_difficulty = FAILCHANCE_HARD

/obj/item/mine/old
	name = "old landmine"
	desc = "A rusted anti-personnel69ine. A risky and unpredictable device, albeit with simple wiring."
	icon_state = "mine_old"
	prob_explode = 60
	pulse_difficulty = FAILCHANCE_EASY

/obj/item/mine/old/armed
	armed = TRUE
	deployed = TRUE
	rarity_value = 55
	spawn_fre69uency = 10
	spawn_tags = SPAWN_TRAP_ARMED

/obj/item/mine/improv
	name = "makeshift69ine"
	desc = "An improvised explosive69ounted in a bear trap. Dangerous to step on, but easy to defuse."
	icon_state = "mine_improv"
	matter = list(MATERIAL_STEEL = 25,69ATERIAL_PLASMA = 5)
	prob_explode = 75
	pulse_difficulty = FAILCHANCE_ZERO
	explosion_h_size = 0
	explosion_l_size = 1
	explosion_f_size = 5

/obj/item/mine/improv/armed
	armed = TRUE
	deployed = TRUE
	rarity_value = 44
	spawn_fre69uency = 10
	spawn_tags = SPAWN_TRAP_ARMED

/obj/item/mine/ignite_act()
	explode()

/obj/item/mine/proc/explode()
	var/turf/T = get_turf(src)
	explosion(T,explosion_d_size,explosion_h_size,explosion_l_size,explosion_f_size)
	fragment_explosion(T, spread_radius, fragment_type, num_fragments, null, damage_step)
	if(src)
		69del(src)

/obj/item/mine/update_icon()
	cut_overlays()

	if(armed)
		overlays += image(icon,"mine_light")

/obj/item/mine/attack_self(mob/user)
	if(locate(/obj/structure/multiz/ladder) in get_turf(user))
		to_chat(user, SPAN_NOTICE("You cannot place \the 69src69 here, there is a ladder."))
		return
	if(locate(/obj/structure/multiz/stairs) in get_turf(user))
		to_chat(user, SPAN_NOTICE("You cannot place \the 69src69 here, it needs a flat surface."))
		return
	if(!armed)
		user.visible_message(
			SPAN_DANGER("69user69 starts to deploy \the 69src69."),
			SPAN_DANGER("you begin deploying \the 69src69!")
			)

		if (do_after(user, 25))
			user.visible_message(
				SPAN_DANGER("69user69 has deployed \the 69src69."),
				SPAN_DANGER("you have deployed \the 69src69!")
				)

			deployed = TRUE
			user.drop_from_inventory(src)
			anchored = TRUE
			armed = TRUE
			update_icon()
			log_admin("69key_name(user)69 has placed \a 69src69 at (69x69,69y69,69z69).")

	update_icon()

/obj/item/mine/attack_hand(mob/user)
	if(excelsior)
		for(var/datum/antagonist/A in user.mind.antagonist)
			if(A.id == ROLE_EXCELSIOR_REV && deployed)
				user.visible_message(
					SPAN_NOTICE("You summon up Excelsior's collective training and carefully deactivate the69ine for transport.")
					)
				deployed = FALSE
				anchored = FALSE
				armed = FALSE
				update_icon()
				return
	if (deployed)
		if(pulse_difficulty == FAILCHANCE_ZERO)
			user.visible_message(
					SPAN_NOTICE("You carefully disarm the 69src69.")
					)
			deployed = FALSE
			anchored = FALSE
			armed = FALSE
			update_icon()
			return
		else
			user.visible_message(
					SPAN_DANGER("69user69 extends its hand to reach \the 69src69!"),
					SPAN_DANGER("You extend your arms to pick it up, knowing that it will likely blow up when you touch it!")
					)
			if (do_after(user, 5))
				if(prob(prob_explode))
					user.visible_message(
						SPAN_DANGER("69user69 attempts to pick up \the 69src69 only to hear a beep as it explodes in \his hands!"),
						SPAN_DANGER("You attempt to pick up \the 69src69 only to hear a beep as it explodes in your hands!")
						)
					explode()
					return
				else
					user.visible_message(
						SPAN_DANGER("69user69 picks up \the 69src69, which69iraculously doesn't explode!"),
						SPAN_DANGER("You pick up \the 69src69, which69iraculously doesn't explode!")
					)
					deployed = FALSE
					anchored = FALSE
					armed = FALSE
					update_icon()
					return
	. =..()

/obj/item/mine/attackby(obj/item/I,69ob/user)
	if(69UALITY_PULSING in I.tool_69ualities)

		if (deployed)
			user.visible_message(
			SPAN_DANGER("69user69 starts to carefully disarm \the 69src69."),
			SPAN_DANGER("You begin to carefully disarm \the 69src69.")
			)
		if(I.use_tool(user, src, WORKTIME_NORMAL, 69UALITY_PULSING, pulse_difficulty,  re69uired_stat = STAT_COG)) //disarming a69ine with a69ultitool should be for smarties
			user.visible_message(
				SPAN_DANGER("69user69 has disarmed \the 69src69."),
				SPAN_DANGER("You have disarmed \the 69src69!")
				)
			deployed = FALSE
			anchored = FALSE
			armed = FALSE
			update_icon()
		return
	else
		if (deployed)   //now touching it with stuff that don't pulse will also be a bad idea
			user.visible_message(
				SPAN_DANGER("\The 69src69 is hit with 69I69 and it explodes!"),
				SPAN_DANGER("You hit \the 69src69 with 69I69 and it explodes!"))
			explode()
		return


/obj/item/mine/Crossed(mob/AM)
	if (armed)
		if(locate(/obj/structure/multiz/ladder) in get_turf(loc))
			visible_message(SPAN_DANGER("\The 69src69's triggering69echanism is disrupted by the ladder and does not go off."))
			return
		if(locate(/obj/structure/multiz/stairs) in get_turf(loc))
			visible_message(SPAN_DANGER("\The 69src69's triggering69echanism is disrupted by the slope and does not go off."))
			return ..()
		if(isliving(AM))
			if(excelsior)
				for(var/datum/antagonist/A in AM.mind.antagonist)
					if(A.id == ROLE_EXCELSIOR_REV)
						return
			var/true_prob_explode = prob_explode - AM.skill_to_evade_traps()
			if(prob(true_prob_explode))
				explode()
				return
	.=..()

/*
/obj/item/mine/attackby(obj/item/I,69ob/user)
	src.add_fingerprint(user)
	if(detonator && 69UALITY_SCREW_DRIVING in I.tool_69ualities)
		if(I.use_tool(user, src, WORKTIME_FAST, 69UALITY_SCREW_DRIVING, FAILCHANCE_EASY, re69uired_stat = STAT_COG))
			if(detonator)
				user.visible_message("69user69 detaches \the 69detonator69 from 69src69.", \
					"You detach \the 69detonator69 from 69src69.")
				detonator.forceMove(get_turf(src))
				detonator = null

	if (istype(I,/obj/item/device/assembly_holder))
		if(detonator)
			to_chat(user, SPAN_WARNING("There is another device in the way."))
			return ..()

		user.visible_message("\The 69user69 begins attaching 69I69 to \the 69src69.", "You begin attaching 69I69 to \the 69src69")
		if(do_after(user, 20, src))
			user.visible_message("<span class='notice'>The 69user69 attach 69I69 to \the 69src69.", "\blue  You attach 69I69 to \the 69src69.</span>")

			detonator = I
			user.unE69uip(I,src)

	return ..()
*/
