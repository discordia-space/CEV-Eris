/obj/item/device/lighting/glowstick
	name = "green glowstick"
	desc = "A military-grade glowstick."
	color = "#49F37C"
	icon_state = "glowstick"
	action_button_name = null
	brightness_on = 2.5
	var/fuel = 0
	var/max_fuel = 2000

/obj/item/device/lighting/glowstick/New()
	pixel_x = rand(-12,12)
	pixel_y = rand(-12,12)
	fuel = rand(max_fuel*0.8, max_fuel)
	if(!light_color)
		light_color = color
	..()

/obj/item/device/lighting/glowstick/Process()
	if(--fuel <= 0)
		burn_out()

/obj/item/device/lighting/glowstick/proc/burn_out()
	STOP_PROCESSING(SSobj, src)
	on = FALSE
	update_icon()
	if(ismob(loc))
		var/mob/M = loc
		M.visible_message(
			"[src] slowly burn out.",
			"[src] slowly burn out in your hand."
		)
	else
		visible_message("[src] slowly burn out")

/obj/item/device/lighting/glowstick/update_icon()
	overlays.Cut()
	if(!fuel)
		icon_state = "[initial(icon_state)]-empty"
		item_state = "glowstick"
		set_light(0)
	else if(on)
		var/image/I = image(icon,"[initial(icon_state)]-on",color)
		I.blend_mode = BLEND_ADD
		overlays += I
		item_state = "[initial(icon_state)]-on"
		set_light(brightness_on)
	else
		icon_state = initial(icon_state)
	update_wear_icon()

/obj/item/device/lighting/glowstick/attack_self(mob/user)
	if(turn_on(user))
		user.visible_message(
			SPAN_NOTICE("[user] cracks and shakes the glowstick."),
			SPAN_NOTICE("You crack and shake the glowstick, turning it on!")
		)

/obj/item/device/lighting/glowstick/turn_on(mob/user)
	if(fuel <= 0)
		to_chat(user, SPAN_NOTICE("The [src] is spent."))
		return
	if(on)
		to_chat(user, SPAN_NOTICE("The [src] is already lit."))
		return

	. = ..()
	if(.)
		START_PROCESSING(SSobj, src)

/obj/item/device/lighting/glowstick/red
	name = "red glowstick"
	color = "#FC0F29"

/obj/item/device/lighting/glowstick/blue
	name = "blue glowstick"
	color = "#599DFF"

/obj/item/device/lighting/glowstick/orange
	name = "orange glowstick"
	color = "#FA7C0B"

/obj/item/device/lighting/glowstick/yellow
	name = "yellow glowstick"
	color = "#FEF923"

/obj/item/device/lighting/glowstick/random
	name = "glowstick"
	desc = "A party-grade glowstick."
	color = "#FF00FF"

/obj/item/device/lighting/glowstick/random/New()
	color = rgb(rand(50,255),rand(50,255),rand(50,255))
	..()

