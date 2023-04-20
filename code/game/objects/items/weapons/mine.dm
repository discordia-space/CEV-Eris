/obj/item/mine
	name = "landmine"
	desc = "An anti-personnel mine. A danger to about everyone except those with a Pulsing tool."
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

	var/explosion_power = 250
	var/explosion_falloff = 100

	var/armed = FALSE
	var/deployed = FALSE
	var/excelsior = FALSE
	anchored = FALSE

/obj/item/mine/Initialize()
	. = ..()
	update_icon()

/obj/item/mine/excelsior
	name = "Excelsior mine"
	desc = "An anti-personnel mine. IFF technology grants safe passage to Excelsior agents, and a merciful brief end to others, unless they have a Pulse tool nearby."
	icon_state = "mine_excel"
	matter = list(MATERIAL_STEEL = 15, MATERIAL_PLASTIC = 10)
	excelsior = TRUE
	prob_explode = 100
	pulse_difficulty = FAILCHANCE_HARD

/obj/item/mine/old
	name = "old landmine"
	desc = "A rusted anti-personnel mine. A risky and unpredictable device, albeit with simple wiring."
	icon_state = "mine_old"
	prob_explode = 60
	pulse_difficulty = FAILCHANCE_EASY

/obj/item/mine/old/armed
	armed = TRUE
	deployed = TRUE
	rarity_value = 55
	spawn_frequency = 10
	spawn_tags = SPAWN_TRAP_ARMED

/obj/item/mine/improv
	name = "makeshift mine"
	desc = "An improvised explosive mounted in a bear trap. Dangerous to step on, but easy to defuse."
	icon_state = "mine_improv"
	matter = list(MATERIAL_STEEL = 25, MATERIAL_PLASMA = 5)
	prob_explode = 75
	pulse_difficulty = FAILCHANCE_ZERO
	explosion_power = 175
	explosion_falloff = 75

/obj/item/mine/improv/armed
	armed = TRUE
	deployed = TRUE
	rarity_value = 44
	spawn_frequency = 10
	spawn_tags = SPAWN_TRAP_ARMED

/obj/item/mine/ignite_act()
	explode()

/obj/item/mine/proc/explode()
	explosion(get_turf(src), explosion_power, explosion_falloff)
	fragment_explosion(get_turf(src), spread_radius, fragment_type, num_fragments, null, damage_step)
	if(src)
		qdel(src)

/obj/item/mine/update_icon()
	cut_overlays()

	if(armed)
		overlays += image(icon,"mine_light")

/obj/item/mine/attack_self(mob/user)
	if(locate(/obj/structure/multiz/ladder) in get_turf(user))
		to_chat(user, SPAN_NOTICE("You cannot place \the [src] here, there is a ladder."))
		return
	if(locate(/obj/structure/multiz/stairs) in get_turf(user))
		to_chat(user, SPAN_NOTICE("You cannot place \the [src] here, it needs a flat surface."))
		return
	if(!armed)
		user.visible_message(
			SPAN_DANGER("[user] starts to deploy \the [src]."),
			SPAN_DANGER("you begin deploying \the [src]!")
			)

		if (do_after(user, 25))
			user.visible_message(
				SPAN_DANGER("[user] has deployed \the [src]."),
				SPAN_DANGER("you have deployed \the [src]!")
				)

			deployed = TRUE
			user.drop_from_inventory(src)
			anchored = TRUE
			armed = TRUE
			update_icon()
			log_admin("[key_name(user)] has placed \a [src] at ([x],[y],[z]).")

	update_icon()

/obj/item/mine/attack_hand(mob/user)
	if(excelsior)
		for(var/datum/antagonist/A in user.mind.antagonist)
			if(A.id == ROLE_EXCELSIOR_REV && deployed)
				user.visible_message(
					SPAN_NOTICE("You summon up Excelsior's collective training and carefully deactivate the mine for transport.")
					)
				deployed = FALSE
				anchored = FALSE
				armed = FALSE
				update_icon()
				return
	if (deployed)
		if(pulse_difficulty == FAILCHANCE_ZERO)
			user.visible_message(
					SPAN_NOTICE("You carefully disarm the [src].")
					)
			deployed = FALSE
			anchored = FALSE
			armed = FALSE
			update_icon()
			return
		else
			user.visible_message(
					SPAN_DANGER("[user] extends its hand to reach \the [src]!"),
					SPAN_DANGER("You extend your arms to pick it up, knowing that it will likely blow up when you touch it!")
					)
			if (do_after(user, 5))
				if(prob(prob_explode))
					user.visible_message(
						SPAN_DANGER("[user] attempts to pick up \the [src] only to hear a beep as it explodes in \his hands!"),
						SPAN_DANGER("You attempt to pick up \the [src] only to hear a beep as it explodes in your hands!")
						)
					explode()
					return
				else
					user.visible_message(
						SPAN_DANGER("[user] picks up \the [src], which miraculously doesn't explode!"),
						SPAN_DANGER("You pick up \the [src], which miraculously doesn't explode!")
					)
					deployed = FALSE
					anchored = FALSE
					armed = FALSE
					update_icon()
					return
	. =..()

/obj/item/mine/attackby(obj/item/I, mob/user)
	if(QUALITY_PULSING in I.tool_qualities)

		if (deployed)
			user.visible_message(
			SPAN_DANGER("[user] starts to carefully disarm \the [src]."),
			SPAN_DANGER("You begin to carefully disarm \the [src].")
			)
		if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_PULSING, pulse_difficulty,  required_stat = STAT_COG)) //disarming a mine with a multitool should be for smarties
			user.visible_message(
				SPAN_DANGER("[user] has disarmed \the [src]."),
				SPAN_DANGER("You have disarmed \the [src]!")
				)
			deployed = FALSE
			anchored = FALSE
			armed = FALSE
			update_icon()
		return
	else
		if (deployed)   //now touching it with stuff that don't pulse will also be a bad idea
			user.visible_message(
				SPAN_DANGER("\The [src] is hit with [I] and it explodes!"),
				SPAN_DANGER("You hit \the [src] with [I] and it explodes!"))
			explode()
		return


/obj/item/mine/Crossed(mob/AM)
	if (armed)
		if(locate(/obj/structure/multiz/ladder) in get_turf(loc))
			visible_message(SPAN_DANGER("\The [src]'s triggering mechanism is disrupted by the ladder and does not go off."))
			return
		if(locate(/obj/structure/multiz/stairs) in get_turf(loc))
			visible_message(SPAN_DANGER("\The [src]'s triggering mechanism is disrupted by the slope and does not go off."))
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
/obj/item/mine/attackby(obj/item/I, mob/user)
	src.add_fingerprint(user)
	if(detonator && QUALITY_SCREW_DRIVING in I.tool_qualities)
		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_SCREW_DRIVING, FAILCHANCE_EASY, required_stat = STAT_COG))
			if(detonator)
				user.visible_message("[user] detaches \the [detonator] from [src].", \
					"You detach \the [detonator] from [src].")
				detonator.forceMove(get_turf(src))
				detonator = null

	if (istype(I,/obj/item/device/assembly_holder))
		if(detonator)
			to_chat(user, SPAN_WARNING("There is another device in the way."))
			return ..()

		user.visible_message("\The [user] begins attaching [I] to \the [src].", "You begin attaching [I] to \the [src]")
		if(do_after(user, 20, src))
			user.visible_message("<span class='notice'>The [user] attach [I] to \the [src].", "\blue  You attach [I] to \the [src].</span>")

			detonator = I
			user.unEquip(I,src)

	return ..()
*/
