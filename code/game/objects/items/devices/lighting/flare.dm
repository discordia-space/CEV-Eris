/obj/item/device/lighting/glowstick/flare
	name = "flare"
	desc = "A red standard-issue flare. There are instructions on the side reading 'pull cord, make light'."
	brightness_on = 4 // Pretty bright.
	light_power = 2
	color = null
	light_color = COLOR_LIGHTING_RED_BRIGHT
	icon_state = "flare"
	max_fuel = 1000
	melleDamages = list(
		ARMOR_BLUNT = list(
			DELEM(BRUTE, 3)
		)
	)
	var/list/onDamage = list(
		ARMOR_BLUNT = list(
			DELEM(BURN, 15)
		)
	)
	var/produce_heat = 1500
	turn_on_sound = 'sound/effects/Custom_flare.ogg'
	heat = 1873
	preloaded_reagents = list("sulfur" = 10, "potassium" = 5, "hydrazine" = 5)

/obj/item/device/lighting/glowstick/flare/Process()
	..()
	if(on)
		var/turf/pos = get_turf(src)
		if(pos)
			pos.hotspot_expose(produce_heat, 5)

/obj/item/device/lighting/glowstick/flare/burn_out()
	..()
	melleDamages = GLOB.melleDamagesCache[type]

/obj/item/device/lighting/glowstick/flare/attack_self(mob/user)
	if(turn_on(user))
		user.visible_message(
			SPAN_NOTICE("\The [user] activates \the [src]."),
			SPAN_NOTICE("You pull the cord on the flare, activating it!")
		)

/obj/item/device/lighting/glowstick/flare/turn_on(var/mob/user)
	. = ..()
	if(.)
		melleDamages = onDamage

/obj/item/device/lighting/glowstick/flare/update_icon()
	overlays.Cut()
	if(!fuel)
		icon_state = "[initial(icon_state)]-empty"
		set_light(0)
	else if(on)
		icon_state = "[initial(icon_state)]-on"
		set_light(brightness_on)
	else
		icon_state = initial(icon_state)
		set_light(0)
	update_wear_icon()

/obj/item/device/lighting/glowstick/flare/is_hot()
	if (on)
		return heat
