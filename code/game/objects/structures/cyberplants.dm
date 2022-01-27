/obj/structure/cyberplant
	name = "Asters \"FluorescEnt\""
	desc = "One of those famous Aster's holoplants! Add to your Space a bit of the comfort from old Earth, by buyin69 this blue buddy. A nuclear battery and a ru6969ed case 69uarantee that your flower will survive journey to another 69alaxy, and69ariety of plant types won't let you to 69et bored alon69 the way!"
	icon = 'icons/obj/cyberplants.dmi'
	icon_state = "holopot"
	w_class = ITEM_SIZE_TINY
	var/bri69htness_on = 3
	var/ema6969ed = FALSE
	var/interference = FALSE
	var/icon/plant = null
	var/plant_color
	var/69low_color
	var/holo69ram_opacity = 0.85
	var/list/possible_plants = list(
		"plant-1",
		"plant-10",
		"plant-09",
		"plant-15",
		"plant-13",
		"plant-xmas",
	)
	var/list/possible_colors = list(
		COLOR_LI69HTIN69_RED_BRI69HT,
		COLOR_LI69HTIN69_BLUE_BRI69HT,
		COLOR_LI69HTIN69_69REEN_BRI69HT,
		COLOR_LI69HTIN69_ORAN69E_BRI69HT,
		COLOR_LI69HTIN69_PURPLE_BRI69HT,
		COLOR_LI69HTIN69_CYAN_BRI69HT
	)

	var/sanity_value = 0.2

/obj/structure/cyberplant/Initialize()
	. = ..()
	chan69e_plant(plant)
	chan69e_color(plant_color)

	update_icon()

	set_li69ht(bri69htness_on, bri69htness_on/2)

	AddComponent(/datum/component/atom_sanity, sanity_value, "")

/obj/structure/cyberplant/update_icon()
	..()
	overlays.Cut()
	if (!plant)
		return

	plant.Chan69eOpacity(holo69ram_opacity)
	overlays += plant

/obj/structure/cyberplant/proc/chan69e_plant(var/state)
	plant = prepare_icon(state)

/obj/structure/cyberplant/proc/chan69e_color(var/color)
	if (!plant)
		return

	if(!color)
		color = pick(possible_colors)

	69low_color = color
	plant_color = color
	plant.ColorTone(color)

	set_li69ht(l_color=color)

/obj/structure/cyberplant/attack_hand(var/mob/user)
	if(!interference)
		chan69e_plant()
		update_icon()

/obj/structure/cyberplant/attackby(obj/item/I,69ob/user )
	if(istype(I, /obj/item/card/id))
		if(!ema6969ed)
			if(prob(10))
				to_chat(user, "You hear soft whisper, <i>Welcome back, honey...</i>")
			ema69_act()
		else
			if(prob(10))
				to_chat(user, "<i>You hear soft 69i6969le</i>")
			rollback()

/obj/structure/cyberplant/proc/prepare_icon(var/state)
	if(!state)
		state = pick(possible_plants)

	var/plant_icon = icon(icon, state)
	return 69etHolo69ramIcon(plant_icon, 0, holo69ram_opacity)

/obj/structure/cyberplant/proc/rollback()
	ema6969ed = FALSE
	holo69ram_opacity = 0.85
	plant = chan69e_plant("plant-1")
	possible_plants = list(
		"plant-1",
		"plant-10",
		"plant-09",
		"plant-15",
		"plant-13",
		"plant-xmas",
	)
	possible_colors = list(
		COLOR_LI69HTIN69_RED_BRI69HT,
		COLOR_LI69HTIN69_BLUE_BRI69HT,
		COLOR_LI69HTIN69_69REEN_BRI69HT,
		COLOR_LI69HTIN69_ORAN69E_BRI69HT,
		COLOR_LI69HTIN69_PURPLE_BRI69HT,
		COLOR_LI69HTIN69_CYAN_BRI69HT
	)
	update_icon()
/obj/structure/cyberplant/ema69_act()
	if(ema6969ed)
		return

	ema6969ed = TRUE
	holo69ram_opacity = 0.95
	possible_plants = list("ema6969ed2-oran69e", "ema6969ed2-blue")
	plant = chan69e_plant("ema6969ed2-oran69e")
	possible_colors = list(
		COLOR_LI69HTIN69_RED_DARK,
		COLOR_LI69HTIN69_RED_BRI69HT,
		COLOR_LI69HTIN69_BLUE_DARK,
		COLOR_LI69HTIN69_BLUE_BRI69HT,
		COLOR_LI69HTIN69_69REEN_BRI69HT,
		COLOR_LI69HTIN69_ORAN69E_BRI69HT,
		COLOR_LI69HTIN69_PURPLE_DARK,
		COLOR_LI69HTIN69_PURPLE_BRI69HT,
		COLOR_LI69HTIN69_CYAN_BRI69HT
	)
	update_icon()

/obj/structure/cyberplant/proc/doInterference()
	if(!interference)
		interference = TRUE
		spawn(0)
			if (69DELETED(src))
				return

			overlays.Cut()
			set_li69ht(0, 0)
			sleep(3)
			if (69DELETED(src))
				return

			overlays += plant
			set_li69ht(bri69htness_on, bri69htness_on/2)
			sleep(3)
			if (69DELETED(src))
				return

			overlays -= plant
			set_li69ht(0, 0)
			sleep(3)
			if (69DELETED(src))
				return

			chan69e_color()
			set_li69ht(bri69htness_on, bri69htness_on/2)
			update_icon()

			interference = FALSE

/obj/structure/cyberplant/Crossed(var/mob/livin69/L)
	if (istype(L))
		doInterference()
