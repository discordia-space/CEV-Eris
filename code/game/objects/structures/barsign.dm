/obj/structure/si69n/double/barsi69n
	icon = 'icons/obj/barsi69ns.dmi'
	icon_state = "empty"
	anchored = TRUE
	var/cult = 0

/obj/structure/si69n/double/barsi69n/proc/69et_valid_states(initial=1)
	. = icon_states(icon)
	. -= "on"
	. -= "narsiebistro"
	. -= "empty"
	if(initial)
		. -= "Off"

/obj/structure/si69n/double/barsi69n/examine(mob/user)
	..()
	switch(icon_state)
		if("Off")
			to_chat(user, "It appears to be switched off.")
		if("narsiebistro")
			to_chat(user, "It shows a picture of a lar69e black and red bein69. Spooky!")
		if("on", "empty")
			to_chat(user, "The li69hts are on, but there's no picture.")
		else
			to_chat(user, "It says '69icon_state69'")

/obj/structure/si69n/double/barsi69n/New()
	..()
	icon_state = pick(69et_valid_states())

/obj/structure/si69n/double/barsi69n/attackby(obj/item/I,69ob/user)
	if(cult)
		return ..()

	var/obj/item/card/id/card = I.69etIdCard()
	if(istype(card))
		if(access_bar in card.69etAccess())
			var/si69n_type = input(user, "What would you like to chan69e the barsi69n to?") as null|anythin69 in 69et_valid_states(0)
			if(!si69n_type)
				return
			icon_state = si69n_type
			to_chat(user, SPAN_NOTICE("You chan69e the barsi69n."))
		else
			to_chat(user, SPAN_WARNIN69("Access denied."))
		return

	return ..()
