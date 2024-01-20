/obj/structure/cyberplant
	name = "Asters \"FluorescEnt\""
	desc = "One of those famous Aster's holoplants! Add to your Space a bit of the comfort from old Earth, by buying this blue buddy. A nuclear battery and a rugged case guarantee that your flower will survive journey to another galaxy, and variety of plant types won't let you to get bored along the way!"
	icon = 'icons/obj/cyberplants.dmi'
	icon_state = "holopot"
	volumeClass = ITEM_SIZE_TINY
	var/brightness_on = 4
	var/emagged = FALSE
	var/interference = FALSE
	var/icon/plant = null
	var/custom_color
	var/plant_color
	var/glow_color
	var/hologram_opacity = 0.85
	var/list/possible_plants = list(
		"plant-1",
		"plant-10",
		"plant-09",
		"plant-15",
		"plant-13",
		"plant-xmas",
	)
	var/list/possible_colors = list(
		COLOR_LIGHTING_RED_BRIGHT,
		COLOR_LIGHTING_BLUE_BRIGHT,
		COLOR_LIGHTING_GREEN_BRIGHT,
		COLOR_LIGHTING_ORANGE_BRIGHT,
		COLOR_LIGHTING_PURPLE_BRIGHT,
		COLOR_LIGHTING_CYAN_BRIGHT
	)

	var/sanity_value = 0.2

/obj/structure/cyberplant/Initialize()
	. = ..()
	change_plant(plant)
	change_color(plant_color)

	update_icon()

	set_light(brightness_on, brightness_on/2)

	AddComponent(/datum/component/atom_sanity, sanity_value, "")

/obj/structure/cyberplant/update_icon()
	..()
	overlays.Cut()
	if (!plant)
		return

//	plant.ChangeOpacity(hologram_opacity)
	overlays += plant

/obj/structure/cyberplant/proc/change_plant(var/state)
	plant = prepare_icon(state)

/obj/structure/cyberplant/proc/change_color(var/color)
	if (!plant)
		return

	if(!color)
		color = custom_color ? custom_color : pick(possible_colors)

	glow_color = color
	plant_color = color
	plant.ColorTone(color)

	set_light(l_color = color)

/obj/structure/cyberplant/attackby(obj/item/I, mob/user )
	if(istype(I, /obj/item/card/id))
		if(!emagged)
			if(prob(10))
				to_chat(user, "You hear soft whisper, <i>Welcome back, honey...</i>")
			emag_act()
		else
			if(prob(10))
				to_chat(user, "<i>You hear soft giggle</i>")
			rollback()

/obj/structure/cyberplant/attack_hand(mob/user)
	var/color_of_choice = input("Choose a color.", "\"FluorescEnt\" configuration", custom_color) as color|null
	custom_color = color_of_choice
	if(!interference)
		change_plant()
		change_color()
		update_icon()

/obj/structure/cyberplant/proc/prepare_icon(var/state)
	if(!state)
		state = pick(possible_plants)

	var/plant_icon = icon(icon, state)
	return getHologramIcon(plant_icon, 0, hologram_opacity)

/obj/structure/cyberplant/proc/rollback()
	emagged = FALSE
	hologram_opacity = 0.85
	plant = change_plant("plant-1")
	possible_plants = list(
		"plant-1",
		"plant-10",
		"plant-09",
		"plant-15",
		"plant-13",
		"plant-xmas",
	)
	possible_colors = list(
		COLOR_LIGHTING_RED_BRIGHT,
		COLOR_LIGHTING_BLUE_BRIGHT,
		COLOR_LIGHTING_GREEN_BRIGHT,
		COLOR_LIGHTING_ORANGE_BRIGHT,
		COLOR_LIGHTING_PURPLE_BRIGHT,
		COLOR_LIGHTING_CYAN_BRIGHT
	)
	update_icon()

/obj/structure/cyberplant/emag_act()
	if(emagged)
		return

	emagged = TRUE
	hologram_opacity = 0.95
	possible_plants = list("emagged2-orange", "emagged2-blue")
	plant = change_plant("emagged2-orange")
	possible_colors = list(
		COLOR_LIGHTING_RED_DARK,
		COLOR_LIGHTING_RED_BRIGHT,
		COLOR_LIGHTING_BLUE_DARK,
		COLOR_LIGHTING_BLUE_BRIGHT,
		COLOR_LIGHTING_GREEN_BRIGHT,
		COLOR_LIGHTING_ORANGE_BRIGHT,
		COLOR_LIGHTING_PURPLE_DARK,
		COLOR_LIGHTING_PURPLE_BRIGHT,
		COLOR_LIGHTING_CYAN_BRIGHT
	)
	update_icon()

/obj/structure/cyberplant/proc/doInterference()
	if(!interference)
		interference = TRUE
		spawn(0)
			if(QDELETED(src))
				return

			overlays.Cut()
			set_light(0, 0)
			sleep(3)
			if(QDELETED(src))
				return

			overlays += plant
			set_light(brightness_on, brightness_on/2)
			sleep(3)
			if(QDELETED(src))
				return

			overlays -= plant
			set_light(0, 0)
			sleep(3)
			if(QDELETED(src))
				return

			change_color()
			set_light(brightness_on, brightness_on/2)
			update_icon()

			interference = FALSE

/obj/structure/cyberplant/Crossed(mob/living/L)
	if(istype(L))
		doInterference()
