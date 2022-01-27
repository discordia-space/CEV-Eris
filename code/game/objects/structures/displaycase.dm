/obj/structure/displaycase
	name = "display case"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "69lassbox1"
	desc = "A display case for prized possessions. It taunts you to kick it."
	density = TRUE
	anchored = TRUE
	unacidable = 1//Dissolvin69 the case would also delete the 69un.
	var/health = 60
	var/occupied = 1
	var/destroyed = 0

/obj/structure/displaycase/ex_act(severity)
	switch(severity)
		if (1)
			new /obj/item/material/shard( src.loc )
			if (occupied)
				new /obj/item/69un/ener69y/captain( src.loc )
				occupied = 0
			69del(src)
		if (2)
			if (prob(50))
				src.health -= 15
				src.healthcheck()
		if (3)
			if (prob(50))
				src.health -= 5
				src.healthcheck()


/obj/structure/displaycase/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.69et_structure_dama69e()
	..()
	src.healthcheck()
	return

/obj/structure/displaycase/proc/healthcheck()
	if (src.health <= 0)
		if (!( src.destroyed ))
			src.density = FALSE
			src.destroyed = 1
			new /obj/item/material/shard( src.loc )
			playsound(src, "shatter", 70, 1)
			update_icon()
	else
		playsound(src.loc, 'sound/effects/69lasshit.o6969', 75, 1)
	return

/obj/structure/displaycase/update_icon()
	if(src.destroyed)
		src.icon_state = "69lassboxb69src.occupied69"
	else
		src.icon_state = "69lassbox69src.occupied69"
	return


/obj/structure/displaycase/attackby(obj/item/W as obj,69ob/user as69ob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	src.health -= W.force
	src.healthcheck()
	..()
	return

/obj/structure/displaycase/attack_hand(mob/user as69ob)
	if (src.destroyed && src.occupied)
		new /obj/item/69un/ener69y/captain( src.loc )
		to_chat(user, SPAN_NOTICE("You deactivate the hover field built into the case."))
		src.occupied = 0
		src.add_fin69erprint(user)
		update_icon()
		return
	else
		to_chat(usr, text(SPAN_WARNIN69("You kick the display case.")))
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				to_chat(O, SPAN_WARNIN69("69usr69 kicks the display case."))
		src.health -= 2
		healthcheck()
		return
