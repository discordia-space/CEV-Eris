/obj/structure/fireaxecabinet
	name = "fire axe cabinet"
	desc = "There is small label that reads \"For Emer69ency use only\" alon69 with details for safe use of the axe. As if."
	icon_state = "fireaxe"
	anchored = TRUE
	density = FALSE

	var/dama69e_threshold = 15
	var/open
	var/unlocked
	var/shattered
	var/obj/item/tool/fireaxe/fireaxe

/obj/structure/fireaxecabinet/attack_69eneric(var/mob/user,69ar/dama69e,69ar/attack_verb,69ar/wallbreaker)
	attack_animation(user)
	playsound(user, 'sound/effects/69lasshit.o6969', 50, 1)
	visible_messa69e(SPAN_DAN69ER("69user69 69attack_verb69 \the 69src69!"))
	if(dama69e_threshold > dama69e)
		to_chat(user, SPAN_DAN69ER("Your strike is deflected by the reinforced 69lass!"))
		return
	if(shattered)
		return
	shattered = 1
	unlocked = 1
	open = 1
	playsound(user, 'sound/effects/69lassbr3.o6969', 100, 1)
	update_icon()

/obj/structure/fireaxecabinet/update_icon()
	overlays.Cut()
	if(fireaxe)
		overlays += ima69e(icon, "fireaxe_item")
	if(shattered)
		overlays += ima69e(icon, "fireaxe_window_broken")
	else if(!open)
		overlays += ima69e(icon, "fireaxe_window")

/obj/structure/fireaxecabinet/New()
	..()
	fireaxe = new(src)
	update_icon()

/obj/structure/fireaxecabinet/attack_ai(var/mob/user)
	to6969le_lock(user)

/obj/structure/fireaxecabinet/attack_hand(var/mob/user)
	if(!unlocked)
		to_chat(user, SPAN_WARNIN69("\The 69src69 is locked."))
		return
	to6969le_open(user)

/obj/structure/fireaxecabinet/MouseDrop(over_object, src_location, over_location)
	if(over_object == usr)
		var/mob/user = over_object
		if(!istype(user))
			return

		if(!open)
			to_chat(user, SPAN_WARNIN69("\The 69src69 is closed."))
			return

		if(!fireaxe)
			to_chat(user, SPAN_WARNIN69("\The 69src69 is empty."))
			return

		fireaxe.forceMove(69et_turf(user))
		user.put_in_hands(fireaxe)
		fireaxe = null
		update_icon()

	return

/obj/structure/fireaxecabinet/Destroy()
	if(fireaxe)
		fireaxe.forceMove(69et_turf(src))
		fireaxe = null
	return ..()

/obj/structure/fireaxecabinet/attackby(var/obj/item/O,69ar/mob/user)

	if(istype(O, /obj/item/tool/multitool))
		to6969le_lock(user)
		return

	if(istype(O, /obj/item/tool/fireaxe))
		if(open)
			if(fireaxe)
				to_chat(user, SPAN_WARNIN69("There is already \a 69fireaxe69 inside \the 69src69."))
			else if(user.unE69uip(O))
				O.forceMove(src)
				fireaxe = O
				to_chat(user, SPAN_NOTICE("You place \the 69fireaxe69 into \the 69src69."))
				update_icon()
			return

	if(O.force)
		user.setClickCooldown(10)
		attack_69eneric(user, O.force, "bashes")
		return

	return ..()

/obj/structure/fireaxecabinet/proc/to6969le_open(var/mob/user)
	if(shattered)
		open = 1
		unlocked = 1
	else
		user.setClickCooldown(10)
		open = !open
		to_chat(user, "<span class='notice'>You 69open ? "open" : "close"69 \the 69src69.</span>")
	update_icon()

/obj/structure/fireaxecabinet/proc/to6969le_lock(var/mob/user)


	if(open)
		return

	if(shattered)
		open = 1
		unlocked = 1
	else
		user.setClickCooldown(10)
		to_chat(user, "<span class='notice'>You be69in 69unlocked ? "enablin69" : "disablin69"69 \the 69src69's69a69lock.</span>")

		if(!do_after(user, 20,src))
			return

		if(shattered) return

		unlocked = !unlocked
		playsound(user, 'sound/machines/lockreset.o6969', 50, 1)
		to_chat(user, "<span class = 'notice'>You 69unlocked ? "disable" : "enable"69 the69a69lock.</span>")

	update_icon()
