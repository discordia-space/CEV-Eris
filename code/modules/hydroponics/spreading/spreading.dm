#define DEFAULT_SEED "glowshroom"
#define VINE_GROWTH_STAGES 5



/obj/effect/dead_plant
	anchored = TRUE
	opacity = 0
	density = FALSE
	color = DEAD_PLANT_COLOUR

/obj/effect/dead_plant/attack_hand()
	qdel(src)

/obj/effect/dead_plant/attackby()
	..()
	for(var/obj/effect/plant/neighbor in range(1))
		neighbor.update_neighbors()
	qdel(src)

/obj/effect/plant
	name = "plant"
	anchored = TRUE
	opacity = 0
	density = FALSE
	icon = 'icons/obj/hydroponics_growing.dmi'
	icon_state = "bush4-1"
	layer = 3
	pass_flags = PASSTABLE
	mouse_opacity = 1
	reagent_flags = DRAINABLE

	var/health = 5
	var/max_health = 60
	var/growth_threshold = 0
	var/growth_type = 0
	var/max_growth = 0
	var/list/neighbors = list()
	var/obj/effect/plant/parent
	var/datum/seed/seed
	var/sampled = 0
	var/atom/wall_mount = null
	var/spread_chance = 40
	var/spread_distance = 3
	var/evolve_chance = 2
	var/mature_time		//minimum maturation time
	var/last_tick = 0
	var/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/plant
	var/spray_cooldown = FALSE
	var/chem_regen_cooldown = FALSE
	var/near_external = FALSE

/obj/effect/plant/Destroy()
	if(plant_controller)
		plant_controller.remove_plant(src)
	for(var/obj/effect/plant/neighbor in range(1,src))
		plant_controller.add_plant(neighbor)
	if(seed.type == /datum/seed/mushroom/maintshroom)
		GLOB.all_maintshrooms -= src
	. = ..()


/obj/effect/plant/single
	spread_chance = 0

/obj/effect/plant/New(var/newloc, var/datum/seed/newseed, var/obj/effect/plant/newparent)
	..()

	if(!newparent)
		parent = src
	else
		parent = newparent

	if(!plant_controller)
		sleep(250) // ugly hack, should mean roundstart plants are fine.
	if(!plant_controller)
		to_chat(world, SPAN_DANGER("Plant controller does not exist and [src] requires it. Aborting."))
		qdel(src)
		return

	if(!istype(newseed))
		newseed = plant_controller.seeds[DEFAULT_SEED]
	seed = newseed
	if(!seed)
		qdel(src)
		return

	name = seed.display_name
	max_health = round(seed.get_trait(TRAIT_ENDURANCE)/2)
	if(seed.get_trait(TRAIT_SPREAD)>=2)
		layer = LOW_OBJ_LAYER
		max_growth = VINE_GROWTH_STAGES
		growth_threshold = max_health/VINE_GROWTH_STAGES
		icon = 'icons/obj/hydroponics_vines.dmi'
		growth_type = 2 // Vines by default.
		if(seed.type == /datum/seed/mushroom/maintshroom)
			growth_type = 0 // this is maintshroom
			density = FALSE
			GLOB.all_maintshrooms += src
		else if(seed.get_trait(TRAIT_CARNIVOROUS) == 2)
			growth_type = 1 // WOOOORMS.
		else if(!(seed.seed_noun in list("seeds","pits")))
			if(seed.seed_noun == "nodes")
				growth_type = 3 // Biomass
			else
				growth_type = 4 // Mold

		if (growth_type != 4 && !(seed.get_trait(TRAIT_WALL_HUGGER)))
			//Random rotation for vines
			//Disabled for mold because it looks bad
			//0 is in here several times to weight it a bit more towards normal
			var/rot = pick(list(0,0,0, 90, 180, -90))
			var/matrix/M = matrix()
			M.Turn(rot)
			transform = M
	else
		max_growth = seed.growth_stages
		growth_threshold = max_health/seed.growth_stages

	if(max_growth > 2 && prob(50))
		max_growth-- //Ensure some variation in final sprite, makes the carpet of crap look less wonky.

	mature_time = world.time + seed.get_trait(TRAIT_MATURATION) + 15 //prevent vines from maturing until at least a few seconds after they've been created.
	spread_chance = seed.get_trait(TRAIT_POTENCY)
	spread_distance = ((growth_type>0) ? round(spread_chance) : round(spread_chance*0.5))
	update_icon()

	if(seed.get_trait(TRAIT_CHEMS) > 0)
		src.create_reagents(5*(seed.chems.len))
		for (var/reagent in seed.chems)
			src.reagents.add_reagent(reagent, 5)

	spawn(2) // Plants will sometimes be spawned in the turf adjacent to the one they need to end up in, for the sake of correct dir/etc being set.
		if(seed.get_trait(TRAIT_WALL_HUGGER))
			set_dir(calc_dir())
		update_icon()
		plant_controller.add_plant(src)

		// Some plants eat through plating.
		if(islist(seed.chems) && !isnull(seed.chems["pacid"]))
			var/turf/T = get_turf(src)
			//Lets make acid plants not cause random breaches

			//Check for external tiles around it
			for (var/turf/U in range(T, 2))
				if (turf_is_external(U))
					near_external = TRUE
					break

			//If we're not near to any external tiles, then we can melt stuff
			if (!near_external)
				T.explosion_act(prob(80) ? 50 : 100, null)

/obj/effect/plant/update_icon()
	//TODO: should really be caching this.
	refresh_icon()

	var/icon_colour = seed.get_trait(TRAIT_PLANT_COLOUR)
	if(icon_colour)
		color = icon_colour
	// Apply colour and light from seed datum.
	if(seed.get_trait(TRAIT_BIOLUM))
		var/clr
		if(seed.get_trait(TRAIT_BIOLUM_COLOUR))
			clr = seed.get_trait(TRAIT_BIOLUM_COLOUR)
		set_light(1+round(seed.get_trait(TRAIT_POTENCY)/20), l_color = clr)
		return
	else
		set_light(0)

/obj/effect/plant/proc/refresh_icon()
	if (growth_threshold == 0)
		error("growth_threshold is somehow 0, probably never got redefined. Qdeling to prevent repeat logs")
		qdel(src)
		return
	var/growth = max(1,min(max_growth,round(health/growth_threshold)))
	var/at_fringe = dist3D(src,parent)
	if(spread_distance > 5)
		if(at_fringe >= (spread_distance-3))
			max_growth--
		if(at_fringe >= (spread_distance-2))
			max_growth--
	max_growth = max(1,max_growth)
	if(growth_type > 0)
		switch(growth_type)
			if(1)
				icon_state = "worms"
			if(2)
				icon_state = "vines-[growth]"
			if(3)
				icon_state = "mass-[growth]"
			if(4)
				icon_state = "mold-[growth]"
	else
		icon_state = "[seed.get_trait(TRAIT_PLANT_ICON)]-[growth]"

	if(growth>2 && growth == max_growth)
		layer = (seed && seed.force_layer) ? seed.force_layer : 5
		if(seed.type != /datum/seed/mushroom/maintshroom)
			set_opacity(TRUE)
		if(islist(seed.chems) && !isnull(seed.chems["woodpulp"]))
			density = TRUE
	else
		layer = (seed && seed.force_layer) ? seed.force_layer : 5
		density = FALSE


var/list/global/cutoff_plant_icons = list()
//Used for wall hugger plants. Retrieves or creates an icon used for plants growing on the north side of a wall
//This allows them to be cutoff and appear to draw under the wall

/obj/effect/plant/proc/get_cutoff_plant_icon(var/icon_base)
	if (!icon_base)
		return icon //This is not unlikely

	//We retrieve things from this global list first, used as a cache to prevent repeating this expensive icon work
	if (cutoff_plant_icons[icon_base])
		return cutoff_plant_icons[icon_base]

	//Ok it doesnt exist yet, lets make it

	//First we need an empty icon to hold the finished result
	var/icon/I = new()

	//We will loop through each of the five iconstates of a plant
	for (var/i = 1; i <= 5; i++)
		//For each state, we create an icon containing only that state
		var/icon/J = new(icon, "[icon_base]-[i]")

		//We blend the blank icon with it with an offset that will chop 12 pixels off the bottom
		J.Blend(new /icon('icons/obj/hydroponics_vines.dmi', "blank"),ICON_MULTIPLY, y=WALL_HUG_OFFSET-31)

		//Finally we'll insert this new icon into the container we made
		I.Insert(J, "[icon_base]-[i]")

	//We're done, it's made, now store it
	cutoff_plant_icons[icon_base] = I

	//And return it so we can use it immediately
	return I


//Used for plants that grow on walls
/obj/effect/plant/proc/calc_dir()
	set background = 1
	pixel_x = 0
	pixel_y = 0
	var/turf/T = get_turf(src)
	if(!istype(T)) return

	var/direction = UP

	for(var/wallDir in cardinal)
		var/turf/newTurf = get_step(T,wallDir)
		if(newTurf.is_wall)
			direction |= wallDir

	for(var/obj/effect/plant/shroom in T.contents)
		if(shroom == src)
			continue
		if(!shroom.wall_mount) //special
			direction &= ~UP
		else
			direction &= ~shroom.dir

	var/list/dirList = list()

	for(var/i=1,i<=UP,i <<= 1)
		if(direction & i)
			dirList += i

	if(dirList.len)
		var/newDir = pick(dirList)
		if(newDir == UP)
			newDir = 1
		else
			wall_mount = get_step(loc, newDir)
			var/matrix/M = matrix()
			// should make the plant flush against the wall it's meant to be growing from.

			//M.Translate(0,offset)

			switch(newDir)
				if(WEST)
					M.Turn(90)
				if(NORTH)
					M.Turn(180)
					offset_to(wall_mount, WALL_HUG_OFFSET*0.5) //Due to perspective, there's more space to the north
					//So plants that hug a north wall will be offset 50% more
				if(EAST)
					M.Turn(270)
			src.transform = M

			if (newDir == SOUTH)
				//Lets cutoff part of the plant
				icon = get_cutoff_plant_icon(seed.get_trait(TRAIT_PLANT_ICON))


			offset_to(wall_mount, WALL_HUG_OFFSET)

		return newDir

	wall_mount = null
	return 1



/obj/effect/plant/proc/check_health(var/iconupdate = TRUE)
	if(health <= 0)
		die_off()
	else
		update_icon()

/obj/effect/plant/proc/is_mature()
	return (health >= (max_health*0.8) && world.time > mature_time)


/obj/effect/plant/examine()
	. = ..()
	if(seed.get_trait(TRAIT_CHEMS))
		if(!reagents.total_volume)
			to_chat(usr, SPAN_NOTICE("It looks totally dried."))
		else if (!reagents.get_free_space())
			to_chat(usr, SPAN_NOTICE("It looks juicy."))
		else
			to_chat(usr, SPAN_NOTICE("It looks a bit dry."))
