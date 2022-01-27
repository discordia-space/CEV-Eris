// Holographic Items!

// Holographic tables are in code/modules/tables/presets.dm
// Holographic racks are in code/modules/tables/rack.dm

/turf/simulated/floor/holofloor
	thermal_conductivity = 0

/turf/simulated/floor/holofloor/attackby(obj/item/W as obj,69ob/user as69ob)
	return
	// HOLOFLOOR DOES NOT GIVE A FUCK

/turf/simulated/floor/holofloor/set_flooring()
	return

/turf/simulated/floor/holofloor/carpet
	name = "carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "carpet"
	initial_flooring = /decl/flooring/carpet

/turf/simulated/floor/holofloor/tiled
	name = "floor"
	icon = 'icons/turf/flooring/tiles_steel.dmi'
	icon_state = "tiles"
	initial_flooring = /decl/flooring/tiling/steel

/turf/simulated/floor/holofloor/tiled/dark
	name = "floor"
	icon = 'icons/turf/flooring/tiles_dark.dmi'
	icon_state = "tiles"
	initial_flooring = /decl/flooring/tiling/dark

/turf/simulated/floor/holofloor/wood
	name = "wooden floor"
	icon = 'icons/turf/flooring/wood.dmi'
	icon_state = "wood"
	initial_flooring = /decl/flooring/wood

/turf/simulated/floor/holofloor/grass
	name = "lush grass"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass0"
	initial_flooring = /decl/flooring/grass

/turf/simulated/floor/holofloor/snow
	name = "snow"
	icon = 'icons/turf/floors.dmi'
	icon_state = "snow"

/turf/simulated/floor/holofloor/space
	icon = 'icons/turf/space.dmi'
	name = "\proper space"
	icon_state = "0"

/turf/simulated/floor/holofloor/reinforced
	icon = 'icons/turf/flooring/tiles.dmi'
	initial_flooring = /decl/flooring/reinforced
	name = "reinforced holofloor"
	icon_state = "reinforced"

/turf/simulated/floor/holofloor/space/New()
	icon_state = "69((x + y) ^ ~(x * y) + z) % 2569"

/turf/simulated/floor/holofloor/beach
	desc = "Uncomfortably gritty for a hologram."
	icon = 'icons/misc/beach.dmi'
	initial_flooring = null

/turf/simulated/floor/holofloor/beach/sand
	name = "sand"
	icon_state = "desert"

/turf/simulated/floor/holofloor/beach/coastline
	name = "coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"

/turf/simulated/floor/holofloor/beach/water
	name = "water"
	icon_state = "seashallow"

/turf/simulated/floor/holofloor/desert
	name = "desert sand"
	desc = "Uncomfortably gritty for a hologram."
	icon_state = "asteroid"
	icon = 'icons/turf/flooring/asteroid.dmi'
	initial_flooring = null

/turf/simulated/floor/holofloor/desert/New()
	..()
	if(prob(10))
		overlays += "asteroid69rand(0,9)69"

/obj/structure/holostool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "stool_padded_preview"
	anchored = TRUE

/obj/item/clothing/gloves/boxing/hologlove
	name = "boxing gloves"
	desc = "Because you really needed another excuse to punch your crewmates."
	icon_state = "boxing"
	item_state = "boxing"

/obj/structure/window/reinforced/holowindow/Destroy()
	. = ..()

/obj/structure/window/reinforced/holowindow/attackby(obj/item/W as obj,69ob/user as69ob)
	if(!istype(W) || W.flags & NOBLUDGEON)
		return

	if(istype(W, /obj/item/tool/screwdriver))
		to_chat(user, (SPAN_NOTICE("It's a holowindow, you can't unfasten it!")))
	else if(istype(W, /obj/item/tool/crowbar) && reinf && state <= 1)
		to_chat(user, (SPAN_NOTICE("It's a holowindow, you can't pry it!")))
	else if(istype(W, /obj/item/tool/wrench) && !anchored && (!state || !reinf))
		to_chat(user, (SPAN_NOTICE("It's a holowindow, you can't dismantle it!")))
	else
		if(W.damtype == BRUTE || W.damtype == BURN)
			hit(W.force)
			if(health <= 7)
				anchored = FALSE
				update_nearby_icons()
				step(src, get_dir(user, src))
		else
			playsound(loc, 'sound/effects/Glasshit.ogg', 75, 1)
		..()
	return

/obj/structure/window/reinforced/holowindow/shatter(var/display_message = 1)
	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message("69src69 fades away as it shatters!")
	qdel(src)
	return

/obj/structure/window/reinforced/holowindow/disappearing/Destroy()
	. = ..()

/obj/machinery/door/window/holowindoor/Destroy()
	. = ..()

/obj/machinery/door/window/holowindoor/attackby(obj/item/I as obj,69ob/user as69ob)

	if (src.operating == 1)
		return

	if(src.density && istype(I, /obj/item) && !istype(I, /obj/item/card))
		var/aforce = I.force
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
		visible_message("\red <B>69src69 was hit by 69I69.</B>")
		if(I.damtype == BRUTE || I.damtype == BURN)
			take_damage(aforce)
		return

	src.add_fingerprint(user)
	if (!src.requiresID())
		user = null

	if (src.allowed(user))
		if (src.density)
			open()
		else
			close()

	else if (src.density)
		flick(text("6969deny", src.base_state), src)

	return

/obj/machinery/door/window/holowindoor/shatter(var/display_message = 1)
	src.density = FALSE
	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message("69src69 fades away as it shatters!")
	qdel(src)

/obj/structure/bed/chair/holochair/Destroy()
	. = ..()

/obj/structure/bed/chair/holochair/attackby(obj/item/W as obj,69ob/user as69ob)
	if(istype(W, /obj/item/tool/wrench))
		to_chat(user, (SPAN_NOTICE("It's a holochair, you can't dismantle it!")))
	return

/obj/item/holo
	damtype = HALLOSS
	no_attack_log = 1
	bad_type = /obj/item/holo

/obj/item/holo/esword
	desc = "May the force be within you. Sorta."
	icon_state = "sword0"
	force = 3
	throw_speed = 1
	throw_range = 5
	throwforce = 0
	w_class = ITEM_SIZE_SMALL
	flags = NOBLOODY
	var/active = 0
	var/item_color

/obj/item/holo/esword/green
	item_color = "green"

/obj/item/holo/esword/red
	item_color = "red"

/obj/item/holo/esword/handle_shield(mob/user,69ar/damage, atom/damage_source = null,69ob/attacker = null,69ar/def_zone = null,69ar/attack_text = "the attack")
	if(active && default_parry_check(user, attacker, damage_source) && prob(50))
		user.visible_message(SPAN_DANGER("\The 69user69 parries 69attack_text69 with \the 69src69!"))

		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)
		return 1
	return 0

/obj/item/holo/esword/Initialize(mapload)
	. = ..()
	if(!item_color)
		item_color = pick("red","blue","green","purple")

/obj/item/holo/esword/attack_self(mob/living/user as69ob)
	active = !active
	if (active)
		force = 30
		icon_state = "sword69item_color69"
		w_class = ITEM_SIZE_BULKY
		playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("69src69 is now active."))
	else
		force = 3
		icon_state = "sword0"
		w_class = ITEM_SIZE_SMALL
		playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("69src69 can now be concealed."))

	update_wear_icon()

	add_fingerprint(user)

//BASKETBALL OBJECTS

/obj/item/beach_ball/holoball
	icon = 'icons/obj/basketball.dmi'
	icon_state = "basketball"
	name = "basketball"
	item_state = "basketball"
	desc = "Here's your chance, do your dance at the Space Jam."
	w_class = ITEM_SIZE_BULKY //Stops people from hiding it in their bags/pockets

/obj/structure/holohoop
	name = "basketball hoop"
	desc = "Boom, Shakalaka!"
	icon = 'icons/obj/basketball.dmi'
	icon_state = "hoop"
	anchored = TRUE
	density = TRUE
	throwpass = 1

/obj/structure/holohoop/affect_grab(var/mob/living/user,69ar/mob/living/target,69ar/state)
	if(state == GRAB_PASSIVE)
		to_chat(user, SPAN_WARNING("You need a better grip to do that!"))
		return FALSE
	target.forceMove(src.loc)
	target.Weaken(5)
	visible_message(SPAN_WARNING("69user69 dunks 69target69 into the 69src69!"))
	return TRUE

/obj/structure/holohoop/attackby(obj/item/W as obj,69ob/user as69ob)
	if (istype(W, /obj/item) && get_dist(src,user)<2)
		user.drop_item(src.loc)
		visible_message(SPAN_NOTICE("69user69 dunks 69W69 into the 69src69!"), 3)
		return

/obj/structure/holohoop/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (istype(mover,/obj/item) &&69over.throwing)
		var/obj/item/I =69over
		if(istype(I, /obj/item/projectile))
			return
		if(prob(50))
			I.forceMove(src.loc)
			visible_message(SPAN_NOTICE("Swish! \the 69I69 lands in \the 69src69."))
		else
			visible_message(SPAN_WARNING("\The 69I69 bounces off of \the 69src69's rim!"))
		return 0
	else
		return ..(mover, target, height, air_group)


/obj/machinery/readybutton
	name = "Ready Declaration Device"
	desc = "This device is used to declare ready. If all devices in an area are ready, the event will begin!"
	icon = 'icons/obj/monitors.dmi'
	icon_state = "auth_off"
	var/ready = 0
	var/area/currentarea = null
	var/eventstarted = 0

	anchored = TRUE
	use_power = IDLE_POWER_USE
	idle_power_usage = 2
	active_power_usage = 6
	power_channel = STATIC_ENVIRON

/obj/machinery/readybutton/attack_ai(mob/user as69ob)
	to_chat(user, "The ship AI is not to interact with these devices!")
	return

/obj/machinery/readybutton/New()
	..()


/obj/machinery/readybutton/attackby(obj/item/W as obj,69ob/user as69ob)
	to_chat(user, "The device is a solid button, there's nothing you can do with it!")

/obj/machinery/readybutton/attack_hand(mob/user as69ob)

	if(user.stat || stat & (NOPOWER|BROKEN))
		to_chat(user, "This device is not powered.")
		return

	if(!user.IsAdvancedToolUser())
		return 0

	currentarea = get_area(src.loc)
	if(!currentarea)
		qdel(src)

	if(eventstarted)
		to_chat(usr, "The event has already begun!")
		return

	ready = !ready

	update_icon()

	var/numbuttons = 0
	var/numready = 0
	for(var/obj/machinery/readybutton/button in currentarea)
		numbuttons++
		if (button.ready)
			numready++

	if(numbuttons == numready)
		begin_event()

/obj/machinery/readybutton/update_icon()
	if(ready)
		icon_state = "auth_on"
	else
		icon_state = "auth_off"

/obj/machinery/readybutton/proc/begin_event()

	eventstarted = 1

	for(var/obj/structure/window/reinforced/holowindow/disappearing/W in currentarea)
		qdel(W)

	for(var/mob/M in currentarea)
		to_chat(M, "FIGHT!")

//Holocarp

/mob/living/simple_animal/hostile/carp/holodeck
	icon = 'icons/mob/AI.dmi'
	icon_state = "holo4"
	icon_dead = "holo4"
	alpha = 127
	icon_gib = null
	meat_amount = 0
	meat_type = null

/mob/living/simple_animal/hostile/carp/holodeck/New()
	..()
	set_light(2) //hologram lighting

/mob/living/simple_animal/hostile/carp/holodeck/proc/set_safety(var/safe)
	if (safe)
		faction = "neutral"
		melee_damage_lower = 0
		melee_damage_upper = 0
		environment_smash = 0
		destroy_surroundings = 0
	else
		faction = "carp"
		melee_damage_lower = initial(melee_damage_lower)
		melee_damage_upper = initial(melee_damage_upper)
		environment_smash = initial(environment_smash)
		destroy_surroundings = initial(destroy_surroundings)

/mob/living/simple_animal/hostile/carp/holodeck/gib()
	derez() //holograms can't gib

/mob/living/simple_animal/hostile/carp/holodeck/death()
	..()
	derez()

/mob/living/simple_animal/hostile/carp/holodeck/proc/derez()
	visible_message(SPAN_NOTICE("\The 69src69 fades away!"))
	qdel(src)
