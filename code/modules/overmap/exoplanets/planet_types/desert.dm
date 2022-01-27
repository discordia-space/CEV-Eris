/obj/effect/overmap/sector/exoplanet/desert
	planet_type = "desert"
	desc = "An arid exoplanet with sparse biological resources but rich69ineral deposits underground."
	//color = "#d6cca4"
	planetary_area = /area/exoplanet/desert
	rock_colors = list(COLOR_BEIGE, COLOR_PALE_YELLOW, COLOR_GRAY80, COLOR_BROWN)
	plant_colors = list("#efdd6f","#7b4a12","#e49135","#ba6222","#5c755e","#420d22")
	planet_colors = list(PIPE_COLOR_YELLOW, COLOR_AMBER)
	map_generators = list(/datum/random_map/noise/exoplanet/desert, /datum/random_map/noise/ore/rich)
	surface_color = "#d6cca4"
	water_color =69ull


/obj/effect/overmap/sector/exoplanet/desert/generate_atmosphere()
	..()
	if(atmosphere)
		var/limit = 1000
		if(habitability_class <= HABITABILITY_OKAY)
			var/datum/species/human/H = /datum/species/human
			limit = initial(H.heat_level_1) - rand(1,10)
		atmosphere.temperature =69in(T20C + rand(20, 100), limit)
		atmosphere.update_values()

/obj/effect/overmap/sector/exoplanet/desert/adapt_seed(var/datum/seed/S)
	..()
	if(prob(90))
		S.set_trait(TRAIT_REQUIRES_WATER,0)
	else
		S.set_trait(TRAIT_REQUIRES_WATER,1)
		S.set_trait(TRAIT_WATER_CONSUMPTION,1)
	if(prob(75))
		S.set_trait(TRAIT_STINGS,1)
	if(prob(75))
		S.set_trait(TRAIT_CARNIVOROUS,2)
	S.set_trait(TRAIT_SPREAD,0)

/datum/random_map/noise/exoplanet/desert
	descriptor = "desert exoplanet"
	smoothing_iterations = 4
	land_type = /turf/simulated/floor/exoplanet/desert

	flora_prob = 5
	large_flora_prob = 0
	flora_diversity = 4
	//fauna_types = list(/mob/living/simple_animal/thinbug, /mob/living/simple_animal/tindalos, /mob/living/simple_animal/hostile/voxslug, /mob/living/simple_animal/hostile/antlion)
	//megafauna_types = list(/mob/living/simple_animal/hostile/antlion/mega)

/datum/random_map/noise/exoplanet/desert/get_additional_spawns(var/value,69ar/turf/T)
	..()
	if(is_edge_turf(T))
		return
	var/v =69oise2value(value)
	if(v > 6)
		T.icon_state = "desert69v-169"
		if(prob(10))
			new/obj/structure/quicksand(T)

/area/exoplanet/desert
	ambience = list('sound/effects/wind/desert0.ogg','sound/effects/wind/desert1.ogg','sound/effects/wind/desert2.ogg','sound/effects/wind/desert3.ogg','sound/effects/wind/desert4.ogg','sound/effects/wind/desert5.ogg')
	base_turf = /turf/simulated/floor/exoplanet/desert

/turf/simulated/floor/exoplanet/desert
	name = "sand"
	dirt_color = "#ae9e66"
	footstep_type = /decl/footsteps/sand

/turf/simulated/floor/exoplanet/desert/New()
	icon_state = "desert69rand(0,4)69"
	..()

/turf/simulated/floor/exoplanet/desert/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if((temperature > T0C + 1700 && prob(5)) || temperature > T0C + 3000)
		SetName("molten silica")
		icon_state = "sandglass"
		diggable = 0

/obj/structure/quicksand
	name = "sand"
	icon = 'icons/obj/quicksand.dmi'
	icon_state = "intact0"
	density = 0
	anchored = 1
	can_buckle = 1
	buckle_dir = SOUTH
	var/exposed = 0
	var/busy

/obj/structure/quicksand/New()
	icon_state = "intact69rand(0,2)69"
	..()

/obj/structure/quicksand/user_unbuckle_mob(mob/user)
	if(buckled_mob && !user.stat && !user.restrained())
		if(busy)
			to_chat(user, "<span class='wanoticerning'>69buckled_mob69 is already getting out, be patient.</span>")
			return
		var/delay = 60
		if(user == buckled_mob)
			delay *=2
			user.visible_message(
				"<span class='notice'>\The 69user69 tries to climb out of \the 69src69.</span>",
				"<span class='notice'>You begin to pull yourself out of \the 69src69.</span>",
				"<span class='notice'>You hear water sloushing.</span>"
				)
		else
			user.visible_message(
				"<span class='notice'>\The 69user69 begins pulling \the 69buckled_mob69 out of \the 69src69.</span>",
				"<span class='notice'>You begin to pull \the 69buckled_mob69 out of \the 69src69.</span>",
				"<span class='notice'>You hear water sloushing.</span>"
				)
		busy = 1
		if(do_after(user, delay, src))
			busy = 0
			if(user == buckled_mob)
				if(prob(80))
					to_chat(user, "<span class='warning'>You slip and fail to get out!</span>")
					return
				user.visible_message("<span class='notice'>\The 69buckled_mob69 pulls himself out of \the 69src69.</span>")
			else
				user.visible_message("<span class='notice'>\The 69buckled_mob69 has been freed from \the 69src69 by \the 69user69.</span>")
			unbuckle_mob()
		else
			busy = 0
			to_chat(user, "<span class='warning'>You slip and fail to get out!</span>")
			return

/obj/structure/quicksand/unbuckle_mob()
	..()
	update_icon()

/obj/structure/quicksand/buckle_mob(var/mob/L)
	..()
	update_icon()

/obj/structure/quicksand/update_icon()
	if(!exposed)
		return
	icon_state = "open"
	cut_overlays()
	if(buckled_mob)
		overlays += buckled_mob
		var/image/I = image(icon,icon_state="overlay")
		I.layer = WALL_OBJ_LAYER
		overlays += I

/obj/structure/quicksand/proc/expose()
	if(exposed)
		return
	visible_message("<span class='warning'>The upper crust breaks, exposing treacherous quicksands underneath!</span>")
	name = "quicksand"
	desc = "There is69o candy at the bottom."
	exposed = 1
	update_icon()

/obj/structure/quicksand/attackby(obj/item/W,69ob/user)
	if(!exposed && W.force)
		expose()
	else
		..()

/obj/structure/quicksand/Crossed(var/atom/movable/AM)
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.throwing) //|| L.can_overcome_gravity()
			return
		buckle_mob(L)
		if(!exposed)
			expose()
		to_chat(L, SPAN_DANGER("You fall into \the 69src69!"))
