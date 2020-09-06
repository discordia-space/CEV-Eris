/obj/item/weapon/mine
	name = "Excelsior Mine"
	desc = "An anti-personnel mine. IFF technology grants safe passage to Excelsior agents, and a mercifully brief end to others, unless they have a Pulse tool nearby"
	icon = 'icons/obj/machines/excelsior/objects.dmi'
	icon_state = "mine"
	w_class = ITEM_SIZE_BULKY
	matter = list(MATERIAL_STEEL = 30)
	matter_reagents = list("fuel" = 40)
	layer = ABOVE_OBJ_LAYER //should fix all layering problems? or am i crazy stupid and understood it wrong
	var/prob_explode = 100

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
	anchored = FALSE

/obj/item/weapon/mine/ignite_act()
	explode()

/obj/item/weapon/mine/proc/explode()
	var/turf/T = get_turf(src)
	explosion(T,explosion_d_size,explosion_h_size,explosion_l_size,explosion_f_size)
	fragment_explosion(T, spread_radius, fragment_type, num_fragments, null, damage_step)
	if(src)
		qdel(src)

/obj/item/weapon/mine/update_icon()
	overlays.Cut()

	if(armed)
		overlays.Add(image(icon,"mine_light"))

/obj/item/weapon/mine/attack_self(mob/user)
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

	update_icon()

/obj/item/weapon/mine/attack_hand(mob/user as mob)
	if (deployed)
		user.visible_message(
				SPAN_DANGER("[user] extends its hand to reach the [src]!"),
				SPAN_DANGER("you extend your arms to pick it up, knowing that it will likely blow up when you touch it!")
				)
		if (do_after(user, 5))
			user.visible_message(
				SPAN_DANGER("[user] attempts to pick up the [src] only to hear a beep as it explodes in your hands!"),
				SPAN_DANGER("you attempts to pick up the [src] only to hear a beep as it explodes in your hands!")
				)
			explode()
	.=..()

/obj/item/weapon/mine/attackby(obj/item/I, mob/user)
	if(QUALITY_PULSING in I.tool_qualities)
		
		if (deployed)
			user.visible_message(
			SPAN_DANGER("[user] starts to carefully disarm \the [src]."),
			SPAN_DANGER("You begin to carefully disarm \the [src].")
			)
		if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_PULSING, FAILCHANCE_HARD,  required_stat = STAT_COG)) //disarming a mine with a multitool should be for smarties
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
				SPAN_DANGER("the [src] is hit with [I] and it explodes!"),
				SPAN_DANGER("You hit the [src] with [I] and it explodes!"))
			explode()
		return


/obj/item/weapon/mine/Crossed(mob/AM)
	if (armed)
		if (isliving(AM))
			var/true_prob_explode = prob_explode - AM.skill_to_evade_traps()
			if(prob(true_prob_explode) && !is_excelsior(AM))
				explode()
				return
	.=..()

/*
/obj/item/weapon/mine/attackby(obj/item/I, mob/user)
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