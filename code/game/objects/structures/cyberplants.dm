/obj/structure/cyberplant
	name = "Asters \"FluorescEnt\""
	desc = "One of those famous Aster's holoplants! Add to your Space a bit of the comfort from old Earth, by buying this blue buddy. A nuclear battery and a rugged case guarantee that your flower will survive journey to another galaxy, and variety of plant types won't let you to get bored along the way!"
	icon = 'icons/obj/cyberplants.dmi'
	icon_state = "holopot"
	light_color = "#3C94C5"
	var/autostripes = TRUE
	var/emaged = FALSE
	var/interference = FALSE
	var/icon/plant = null
	var/global/list/possible_plants = list(
		"plant-1",
		"plant-10",
		"plant-09",
		"plant-15",
		"plant-13",
		"plant-xmas",
	)

/obj/structure/cyberplant/New()
	..()
	plant = prepare_icon(plant)
	overlays += plant
	set_light(3)

/obj/structure/cyberplant/proc/prepare_icon(var/state)
	if(!state)
		state = pick(possible_plants)
	if(autostripes)
		var/plant_icon = icon(icon, state)
		return getHologramIcon(plant_icon, 0)
	else
		return image(icon, state)

/obj/structure/cyberplant/emag_act()
	if(emaged)
		return

	emaged = TRUE
	overlays -= plant
	plant = prepare_icon("emaged")
	overlays += plant

/obj/structure/cyberplant/Crossed(var/mob/living/L)
	if(!interference && istype(L))
		interference = TRUE
		spawn(0)
			overlays.Cut()
			set_light(0)
			sleep(3)
			overlays += plant
			set_light(3)
			sleep(3)
			overlays -= plant
			set_light(0)
			sleep(3)
			overlays += plant
			set_light(3)
			interference = FALSE
