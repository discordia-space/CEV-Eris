/obj/machinery/door/blast/shutters/glass
	name = "showcase"
	icon = 'icons/obj/doors/showcase.dmi'
	icon_state = "closed"
	health = 200
	maxhealth = 200
	layer = 4.2
	var/broken = FALSE
	var/have_glass = TRUE

/obj/machinery/door/blast/shutters/glass/New()
	opacity = 0
	..()

/obj/machinery/door/blast/shutters/glass/is_block_dir(target_dir, border_only, atom/target)
	return ..(target_dir, FALSE, target)

/obj/machinery/door/blast/shutters/glass/attackby(obj/item/I, mob/user, params)
	if(density)
		if(istype(I, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WT = I
			if(broken && have_glass)
				if(WT.remove_fuel(0,user))
					user << "<span class='notice'>You begin slicing [src]'s debris...</span>"
					playsound(loc, 'sound/items/Welder.ogg', 40, 1)
					if(do_after(user, 40))
						have_glass = FALSE
						icon_state = "closed-empty"
						playsound(loc, 'sound/items/Welder2.ogg', 50, 1)
						return
			else
				if(user.a_intent == "help")
					if(health < maxhealth)
						if(WT.remove_fuel(0,user))
							user << "<span class='notice'>You begin repairing [src]...</span>"
							playsound(loc, 'sound/items/Welder.ogg', 40, 1)
							if(do_after(user, 40))
								health = maxhealth
								playsound(loc, 'sound/items/Welder2.ogg', 50, 1)
								update_icon()
					return
		else if(istype(I,/obj/item/stack/material/glass/reinforced))
			if(!have_glass)
				var/obj/item/stack/material/glass/reinforced/G = I
				if(G.get_amount() >= 2)
					playsound(loc, 'sound/items/Deconstruct.ogg', 50, 1)
					user << "<span class='notice'>You start to put the glass into [src]...</span>"
					if(do_after(user, 10))
						if (G.get_amount() >= 2 && density)
							G.use(2)
							health = maxhealth
							broken = FALSE
							have_glass = TRUE
							icon_state = "closed"
							update_icon()
							return

		if(I.damtype == BRUTE || I.damtype == BURN)
			hit(I.force)
			user.visible_message("<span class='danger'>[user] has hit the [name] with [I]!</span>",
								 "<span class='danger'>[user] has hit the [name] with [I]!</span>")

	else
		user << "<span class='warning'>It must be closed!</span>"

/obj/machinery/door/blast/shutters/glass/attack_hand(mob/user)
	return

/obj/machinery/door/blast/shutters/glass/hitby(AM as mob|obj)
	..()
	visible_message("<span class='danger'>[src] was hit by [AM].</span>")
	var/throw_force = 0
	if(ismob(AM))
		throw_force = 10

	else if(isobj(AM))
		var/obj/item/I = AM
		throw_force = I.throwforce

	hit(throw_force)

/obj/machinery/door/blast/shutters/glass/ex_act(severity, target)
	..()
	if(broken)
		qdel(src)
		return
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			hit(200, 0)
			return
		if(3.0)
			hit(rand(50, 100), 0)
			return

/obj/machinery/door/blast/shutters/glass/bullet_act(var/obj/item/projectile/Proj)
	if((Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		hit(Proj.damage)
	..()

/obj/machinery/door/blast/shutters/glass/proc/hit(var/damage, var/sound_effect = 1)
	if(broken)
		return

	health = max(0, health - damage)
	update_icon()
	if(sound_effect)
		playsound(loc, 'sound/effects/Glasshit.ogg', 75, 1)
	if(health <= 0)
		broken = TRUE
		if(density)
			icon_state += "-broken"
		playsound(loc, 'sound/effects/Glassbr3.ogg', 75, 1)
		new /obj/item/weapon/material/shard(src.loc)
		update_icon()

/obj/machinery/door/blast/shutters/glass/Destroy()
	playsound(loc, 'sound/effects/Glassbr3.ogg', 75, 1)
	new /obj/item/weapon/material/shard(src.loc)
	..()

/obj/machinery/door/blast/shutters/glass/update_icon()
	overlays.Cut()
	if(icon_state == "closed" && !broken)
		var/ratio = health / maxhealth
		ratio = Ceiling(ratio * 4) * 25
		overlays += "damage[ratio]"

/obj/machinery/door/blast/shutters/glass/open()
	if(operating)
		return
	operating = TRUE

	if(!have_glass)
		flick("opening-empty", src)

	else if(broken)
		flick("opening-broken", src)

	else
		var/ratio = health / maxhealth
		ratio = Ceiling(ratio * 4) * 25
		overlays.Cut()
		flick("opening[ratio]", src)

	icon_state = "open"
	update_icon()
	density = 0
	operating = FALSE


/obj/machinery/door/blast/shutters/glass/close()
	if(operating)
		return

	operating = TRUE
	overlays.Cut()
	if(!have_glass)
		flick("closing-empty", src)
		icon_state = "closed-empty"

	else if(broken)
		flick("closing-broken", src)
		icon_state = "closed-broken"

	else
		var/ratio = health / maxhealth
		ratio = Ceiling(ratio * 4) * 25
		flick("closing[ratio]", src)
		icon_state = "closed"

	update_icon()
	density = 1
	crush()
	operating = FALSE
