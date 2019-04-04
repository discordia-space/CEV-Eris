/obj/structure/cyberplant
	name = "Asters \"FluorescEnt\""
	desc = "One of those famous Aster's holoplants! Add to your Space a bit of the comfort from old Earth, by buying this blue buddy. A nuclear battery and a rugged case guarantee that your flower will survive journey to another galaxy, and variety of plant types won't let you to get bored along the way!"
	icon = 'icons/obj/cyberplants.dmi'
	icon_state = "holopot"
	w_class = ITEM_SIZE_TINY
	var/brightness_on = 4
	var/emaged = FALSE
	var/interference = FALSE
	var/icon/plant = null
	var/plant_color
	var/glow_color
	var/hologram_opacity = 0.85
	var/global/list/possible_plants = list(
		"plant-1",
		"plant-10",
		"plant-09",
		"plant-15",
		"plant-13",
		"plant-xmas",
	)
	var/global/list/possible_colors = list(
		COLOR_LIGHTING_RED_BRIGHT,
		COLOR_LIGHTING_BLUE_BRIGHT,
		COLOR_LIGHTING_GREEN_BRIGHT,
		COLOR_LIGHTING_ORANGE_BRIGHT,
		COLOR_LIGHTING_PURPLE_BRIGHT,
		COLOR_LIGHTING_CYAN_BRIGHT
	)

/obj/structure/cyberplant/Initialize()
	..()
	change_plant(plant)
	change_color(plant_color)

	update_icon()

	set_light(brightness_on, brightness_on/2)

/obj/structure/cyberplant/update_icon()
	..()
	overlays.Cut()
	if (!plant)
		return

	plant.ChangeOpacity(hologram_opacity)
	overlays += plant

/obj/structure/cyberplant/proc/change_plant(var/state)
	plant = prepare_icon(state)

/obj/structure/cyberplant/proc/change_color(var/color)
	if (!plant)
		return

	if(!color)
		color = pick(possible_colors)

	glow_color = color
	plant_color = color
	plant.ColorTone(color)

	set_light(l_color=color)

/obj/structure/cyberplant/attack_hand(var/mob/user)
	if(!interference)
		if (prob(1))
			change_plant("emaged")
		else
			change_plant()
		update_icon()

/obj/structure/cyberplant/proc/prepare_icon(var/state)
	if(!state)
		state = pick(possible_plants)

	var/plant_icon = icon(icon, state)
	return getHologramIcon(plant_icon, 0, hologram_opacity)

/obj/structure/cyberplant/emag_act()
	if(emaged)
		return

	emaged = TRUE
	plant = change_plant("emaged")

	update_icon()

/obj/structure/cyberplant/proc/doInterference()
	if(!interference)
		interference = TRUE
		spawn(0)
			if (QDELETED(src))
				return

			overlays.Cut()
			set_light(0, 0)
			sleep(3)
			if (QDELETED(src))
				return

			overlays += plant
			set_light(brightness_on, brightness_on/2)
			sleep(3)
			if (QDELETED(src))
				return

			overlays -= plant
			set_light(0, 0)
			sleep(3)
			if (QDELETED(src))
				return

			change_color()
			set_light(brightness_on, brightness_on/2)
			update_icon()

			interference = FALSE

/obj/structure/cyberplant/Crossed(var/mob/living/L)
	if (istype(L))
		doInterference()