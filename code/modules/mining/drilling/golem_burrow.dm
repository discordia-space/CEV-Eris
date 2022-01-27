/obj/structure/golem_burrow
	name = "golem burrow"
	icon = 'icons/obj/burrows.dmi'
	icon_state = "maint_hole"
	desc = "A pile of rocks that regularly pulses as if it was alive."
	density = TRUE
	anchored = TRUE

	var/max_health = 50
	var/health = 50
	var/datum/golem_controller/controller 

/obj/structure/golem_burrow/New(loc, parent)
	..()
	controller = parent  // Link burrow with golem controller

/obj/structure/golem_burrow/Destroy()
	visible_message(SPAN_DANGER("\The 69src69 crumbles!"))
	if(controller)
		controller.burrows -= src
		controller =69ull
	..()

/obj/structure/golem_burrow/attack_generic(mob/user, damage)
	user.do_attack_animation(src)
	visible_message(SPAN_DANGER("\The 69user69 smashes \the 69src69!"))
	take_damage(damage)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN * 1.5)

/obj/structure/golem_burrow/attackby(obj/item/I,69ob/user)
	if (user.a_intent == I_HURT && user.Adjacent(src))
		if(!(I.flags &69OBLUDGEON))
			user.do_attack_animation(src)
			var/damage = I.force * I.structure_damage_factor
			var/volume = 69in(damage * 3.5, 15)
			if (I.hitsound)
				playsound(src, I.hitsound,69olume, 1, -1)
			visible_message(SPAN_DANGER("69src69 has been hit by 69user69 with 69I69."))
			take_damage(damage)
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN * 1.5)
	return TRUE

/obj/structure/golem_burrow/bullet_act(obj/item/projectile/Proj)
	..()
        // Bullet69ot really efficient against a pile of rock
	take_damage(Proj.get_structure_damage() * 0.25)

/obj/structure/golem_burrow/proc/take_damage(value)
	health =69in(max(health -69alue, 0),69ax_health)
	if(health == 0)
		qdel(src)

/obj/structure/golem_burrow/proc/stop()
	qdel(src)  // Delete burrow
