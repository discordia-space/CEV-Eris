/turf/wall/dummy
	name = "wall"
	icon = 'icons/turf/walls.dmi'
	icon_state = "riveted"
	opacity = TRUE
	density = TRUE
	is_using_flat_icon = TRUE
	is_simulated = FALSE

/turf/wall/dummy/fakeglass
	name = "window"
	icon_state = "fakewindows"
	opacity = 0

/turf/wall/dummy/other
	icon_state = "eris_reinf_wall"
	is_using_flat_icon = FALSE


/turf/floor/dummy
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "Floor3"
	is_simulated = FALSE

/turf/floor/dummy/airless
	oxygen = 0
	nitrogen = 0

/turf/floor/dummy/shuttle_ceiling
	icon_state = "reinforced"

/turf/mask
	name = "mask"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rockvault"
	dynamic_lighting = TRUE
	is_simulated = FALSE

/turf/beach
	name = "Beach"
	icon = 'icons/misc/beach.dmi'
	is_simulated = FALSE

/turf/beach/sand
	name = "Sand"
	icon_state = "sand"

/turf/beach/coastline
	name = "Coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"

/turf/beach/water
	name = "Water"
	icon_state = "water"
	light_color = "#00BFFF"
	light_power = 2
	light_range = 2

/turf/beach/water/New()
	..()
	overlays += image("icon"='icons/misc/beach.dmi',"icon_state"="water2","layer"=MOB_LAYER+0.1)

// 25.02.25 - CFW - Porting Soj unsimulated turfs
// Minerals

/turf/unsimulated
	name = "command"
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

/turf/unsimulated/mineral
	name = "impassable rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock-dark"
	blocks_air = 1
	density = 1
	opacity = 1
	layer = BELOW_MOB_LAYER

/turf/unsimulated/mineral/cold
	name = "impassable rock"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rock-cold"
	blocks_air = 1
	density = 1
	opacity = 1
	layer = BELOW_MOB_LAYER

/turf/unsimulated/mineral/transition
	name = "path elsewhere"
	desc = "Looks like this leads to a whole new area."
	icon_state = "floor_transition"

// 25.05.25 - CFW - Deactivated for now. TODO: Port all the dependencies
/*
/turf/unsimulated/mineral/attackby(obj/item/I, mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(!istype(user.loc, /turf))
		return
	var/list/usable_qualities = list(QUALITY_EXCAVATION)
	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	var/mining_eyes = 0
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(MINING in H.mutations)
			mining_eyes = 20
	if(tool_type==QUALITY_EXCAVATION)
		to_chat(user, SPAN_NOTICE("You try to break out a rock geode or two."))
		if(I.use_tool(user, src, WORKTIME_DELAYED-mining_eyes, tool_type, FAILCHANCE_ZERO, required_stat = STAT_ROB))
			new /obj/random/material_ore_small(get_turf(src))
			if(prob(50+mining_eyes))
				new /obj/random/material_ore_small(get_turf(src))
			if(prob(25+mining_eyes))
				new /obj/random/material_ore_small(get_turf(src))
			if(prob(5+mining_eyes))
				new /obj/random/material_ore_small(get_turf(src))
			to_chat(user, SPAN_NOTICE("You break out some rock geode(s)."))
			return
		return
*/

// Vegetation
/turf/unsimulated/wall/jungle
	name = "dense forestry"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "wall2"
	desc = "A thick, impassable mass of plants and shrubbery."
	blocks_air = 1
	density = 1
	opacity = 1

/turf/unsimulated/wall/jungle/variant
	name = "dense forestry"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "wall1"
	desc = "A thick, impassable mass of plants and shrubbery."
	blocks_air = 1
	density = 1
	opacity = 1

// Beach
/turf/unsimulated/beach
	name = "Beach"
	icon = 'icons/turf/flooring/beach.dmi'

/turf/unsimulated/beach/sand
	name = "Sand"
	icon_state = "sand"

/turf/unsimulated/beach/coastline
	name = "Coastline"
	icon = 'icons/turf/flooring/beach2.dmi'
	icon_state = "sandwater"

/turf/unsimulated/beach/water
	name = "Water"
	icon_state = "water"
	light_color = "#00BFFF"
	light_power = 2
	light_range = 2

/turf/unsimulated/beach/water/New()
	..()
	add_overlay(image("icon"='icons/turf/flooring/beach.dmi',"icon_state"="water2","layer"=MOB_LAYER+0.1))

// Floors

/turf/unsimulated/floor
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "Floor3"

/turf/unsimulated/mask
	name = "mask"
	icon = 'icons/turf/walls.dmi'
	icon_state = "rockvault"
	dynamic_lighting = TRUE

/turf/unsimulated/floor/shuttle_ceiling
	icon_state = "reinforced"
