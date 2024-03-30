/obj/structure/sign/double/barsign
	icon = 'icons/obj/barsigns.dmi'
	icon_state = "empty"
	anchored = TRUE
	var/cult = 0

/obj/structure/sign/double/barsign/proc/get_valid_states(initial=1)
	. = icon_states(icon)
	. -= "on"
	. -= "narsiebistro"
	. -= "empty"
	if(initial)
		. -= "Off"

/obj/structure/sign/double/barsign/examine(mob/user, extra_description = "")
	switch(icon_state)
		if("Off")
			extra_description += "It appears to be switched off."
		if("narsiebistro")
			extra_description += "It shows a picture of a large black and red being. Spooky!"
		if("on", "empty")
			extra_description += "The lights are on, but there's no picture."
		else
			extra_description += "It says '[icon_state]'"
	..(user, extra_description)

/obj/structure/sign/double/barsign/New()
	..()
	icon_state = pick(get_valid_states())

/obj/structure/sign/double/barsign/attackby(obj/item/I, mob/user)
	if(cult)
		return ..()

	var/obj/item/card/id/card = I.GetIdCard()
	if(istype(card))
		if(access_bar in card.GetAccess())
			var/sign_type = input(user, "What would you like to change the barsign to?") as null|anything in get_valid_states(0)
			if(!sign_type)
				return
			icon_state = sign_type
			to_chat(user, SPAN_NOTICE("You change the barsign."))
		else
			to_chat(user, SPAN_WARNING("Access denied."))
		return

	return ..()
