/obj/structure/displaycase
	name = "display case"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "glassbox1"
	desc = "A display case for prized possessions. It taunts you to kick it."
	density = TRUE
	anchored = TRUE
	unacidable = 1//Dissolving the case would also delete the gun.
	explosion_coverage = 0.8
	health = 60
	maxHealth = 60
	var/occupied = 1
	var/destroyed = 0

/obj/structure/displaycase/explosion_act(target_power, explosion_handler/handler)
	var/absorbed = take_damage(target_power)
	return absorbed

/obj/structure/displaycase/bullet_act(var/obj/item/projectile/Proj)
	take_damage(Proj.get_structure_damage())
	..()
	return

/obj/structure/displaycase/take_damage(damage)
	. = health - damage < 0 ? damage - (damage - health) : damage
	. *= explosion_coverage
	health -= damage
	if (health <= 0)
		if (!(destroyed ))
			src.density = FALSE
			src.destroyed = TRUE
			new /obj/item/material/shard( src.loc )
			playsound(src, "shatter", 70, 1)
			update_icon()
	else
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
	return

/obj/structure/displaycase/update_icon()
	if(src.destroyed)
		src.icon_state = "glassboxb[src.occupied]"
	else
		src.icon_state = "glassbox[src.occupied]"
	return


/obj/structure/displaycase/attackby(obj/item/W as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	take_damage(W.force)
	..()
	return

/obj/structure/displaycase/attack_hand(mob/user as mob)
	if (src.destroyed && src.occupied)
		new /obj/item/gun/energy/captain( src.loc )
		to_chat(user, SPAN_NOTICE("You deactivate the hover field built into the case."))
		src.occupied = 0
		src.add_fingerprint(user)
		update_icon()
		return
	else
		to_chat(usr, text(SPAN_WARNING("You kick the display case.")))
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				to_chat(O, SPAN_WARNING("[usr] kicks the display case."))
		take_damage(2)
		return
