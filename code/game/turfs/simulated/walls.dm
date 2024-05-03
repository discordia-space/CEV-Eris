/turf/wall
	name = "wall"
	desc = "A huge chunk of metal used to seperate rooms."
	description_info = "Can be deconstructed by welding"
	description_antag = "Deconstructing these will leave fingerprints. C4 or Thermite leave none"
	icon = 'icons/test_walls_best_walls.dmi'
	icon_state = "eris_wall"
	layer = CLOSED_TURF_LAYER
	opacity = TRUE
	density = TRUE
	blocks_air = TRUE
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall
	is_wall = TRUE // Leftover from times when low walls were not technically walls, could be replaced by a macro
	var/is_low_wall = FALSE // Similar to above, but new. Certainly should be a type check macro // TODO --KIROV
	var/is_reinforced = FALSE
	var/is_using_flat_icon = FALSE // Some very old walls aren't using 3/4 perspective and composite sprites
	var/health = 150
	var/maxHealth = 150
	var/hardness = 60
	var/ricochet_id = 0
	var/any_wall_connections[10] // List of booleans. 8 total directions, 10 is maximum value, 7 and 3 aren't used
	var/full_wall_connections[10] // Used for adding extra overlays in cases when low and full walls meet

	var/window_type // Low wall stuff, defined here so we can override as few procs as possible
	var/window_health
	var/window_maxHealth
	var/window_heat_resistance
	var/window_damage_resistance
	var/window_prespawned_material

/turf/wall/Initialize(mapload, ...)
	. = ..() // Calls /turf/Initialize()
	if(mapload) // We defer icon updates to late initialize at roundstart
		return INITIALIZE_HINT_LATELOAD
	update_connections()
	if(window_prespawned_material)
		create_window(window_prespawned_material)
	else
		update_icon()

/turf/wall/LateInitialize()
	update_connections()
	if(window_prespawned_material)
		create_window(window_prespawned_material)
	else
		update_icon()

/turf/wall/Destroy()
	remove_neighbour_connections()
	ChangeTurf(/turf/floor/plating)
	. = ..()

// This is only called in an event of IC wall deconstruction
// Admin deleting the object will not call this, hence producing no girder or shards
/turf/wall/proc/dismantle_wall(mob/user)
	for(var/obj/O in contents) //Eject contents!
		if(istype(O,/obj/item/contraband/poster))
			var/obj/item/contraband/poster/P = O
			P.roll_and_drop(src)
		else
			O.loc = src
	playsound(src, 'sound/items/Welder.ogg', 100, 1)
	drop_materials(src, user)
	var/obj/structure/girder/girder = new(src)
	girder.is_low = is_low_wall
	girder.is_reinforced = is_reinforced
	girder.update_icon()
	qdel(src)

/turf/wall/get_matter()
	return list(MATERIAL_STEEL = 5)

/turf/wall/levelupdate()
	for(var/obj/O in src)
		O.hide(TRUE) // Walls always hide the stuff below them
		SEND_SIGNAL_OLD(O, COMSIG_TURF_LEVELUPDATE, TRUE)

// Extracts angle's tan if ischance = TRUE.
// In other case it just makes bullets and lazorz go where they're supposed to.
/turf/wall/proc/projectile_reflection(obj/item/projectile/Proj, ischance = FALSE)
	if(Proj.starting)
		var/ricochet_temp_id = rand(1,1000)
		if(!ischance)
			Proj.ricochet_id = ricochet_temp_id
		var/turf/curloc = get_turf(src)

		var/check_x0 = 32 * curloc.x
		var/check_y0 = 32 * curloc.y
		var/check_x1 = 32 * Proj.starting.x
		var/check_y1 = 32 * Proj.starting.y
		var/check_x2 = 32 * Proj.original.x
		var/check_y2 = 32 * Proj.original.y
		var/corner_x0 = check_x0
		var/corner_y0 = check_y0
		if(check_y0 - check_y1 > 0)
			corner_y0 = corner_y0 - 16
		else
			corner_y0 = corner_y0 + 16
		if(check_x0 - check_x1 > 0)
			corner_x0 = corner_x0 - 16
		else
			corner_x0 = corner_x0 + 16

		// Checks if original is lower or upper than line connecting proj's starting and wall
		// In specific coordinate system that has wall as (0,0) and 'starting' as (r, 0), where r > 0.
		// So, this checks whether 'original's' y-coordinate is positive or negative in new c.s.
		// In order to understand, in which direction bullet will ricochet.
		// Actually new_y isn't y-coordinate, but it has the same sign.
		var/new_y = (check_y2 - corner_y0) * (check_x1 - corner_x0) - (check_x2 - corner_x0) * (check_y1 - corner_y0)
		// Here comes the thing which differs two situations:
		// First - bullet comes from north-west or south-east, with negative func value. Second - NE or SW.
		var/new_func = (corner_x0 - check_x1) * (corner_y0 - check_y1)

		// Added these wall things because my original code works well with one-tiled walls, but ignores adjacent turfs which in my current opinion was pretty wrong.
		var/wallnorth = 0
		var/wallsouth = 0
		var/walleast = 0
		var/wallwest = 0
		for (var/turf/wall/W in range(2, curloc))
			var/turf/tempwall = get_turf(W)
			if (tempwall.x == curloc.x)
				if (tempwall.y == (curloc.y - 1))
					wallnorth = 1
					if (!ischance)
						W.ricochet_id = ricochet_temp_id
				else if (tempwall.y == (curloc.y + 1))
					wallsouth = 1
					if (!ischance)
						W.ricochet_id = ricochet_temp_id
			if (tempwall.y == curloc.y)
				if (tempwall.x == (curloc.x + 1))
					walleast = 1
					if (!ischance)
						W.ricochet_id = ricochet_temp_id
				else if (tempwall.x == (curloc.x - 1))
					wallwest = 1
					if (!ischance)
						W.ricochet_id = ricochet_temp_id

		if((wallnorth || wallsouth) && ((Proj.starting.y - curloc.y)*(wallsouth - wallnorth) >= 0))
			if(!ischance)
				Proj.redirect(round(check_x1 / 32), round((2 * check_y0 - check_y1)/32), curloc, src)
				return
			else
				return abs((check_y0 - check_y1) / (check_x0 - check_x1))

		if((walleast || wallwest) && ((Proj.starting.x - curloc.x)*(walleast-wallwest) >= 0))
			if(!ischance)
				Proj.redirect(round((2 * check_x0 - check_x1) / 32), round(check_y1 / 32), curloc, src)
				return
			else
				return abs((check_x0 - check_x1) / (check_y0 - check_y1))

		if((new_y * new_func) > 0)
			if(!ischance)
				Proj.redirect(round((2 * check_x0 - check_x1) / 32), round(check_y1 / 32), curloc, src)
			else
				return abs((check_x0 - check_x1) / (check_y0 - check_y1))
		else
			if(!ischance)
				Proj.redirect(round(check_x1 / 32), round((2 * check_y0 - check_y1)/32), curloc, src)
			else
				return abs((check_y0 - check_y1) / (check_x0 - check_x1))
		return


/turf/wall/bullet_act(obj/item/projectile/Proj)
	if(ricochet_id != 0)
		if(ricochet_id == Proj.ricochet_id)
			ricochet_id = 0
			new /obj/effect/sparks(get_turf(Proj))
			return PROJECTILE_CONTINUE
		ricochet_id = 0
	var/proj_health = Proj.get_structure_damage()

	Proj.on_hit(src)

	if(Proj.can_ricochet && proj_health != 0 && (x != Proj.starting.x) && (y != Proj.starting.y))
		var/ricochetchance = 1
		if(proj_health <= 60)
			ricochetchance = 2 + round((60 - proj_health) / 5)
			ricochetchance = min(ricochetchance * ricochetchance, 100)
		// here it is multiplied by 1/2 temporally, changes will be required when new wall system gets implemented
		ricochetchance = round(ricochetchance * projectile_reflection(Proj, TRUE) / 2)

		ricochetchance *= Proj.ricochet_ability
		ricochetchance = min(max(ricochetchance, 0), 100)
		if(prob(ricochetchance))
			// projectile loses up to 50% of its health when it ricochets, depending on situation
			var/healthdiff = round(proj_health / 2 + proj_health * ricochetchance / 200) // projectile loses up to 50% of its health when it ricochets, depending on situation
			Proj.damage_types[BRUTE] = round(Proj.damage_types[BRUTE] / 2 + Proj.damage_types[BRUTE] * ricochetchance / 200)
			Proj.damage_types[BURN] = round(Proj.damage_types[BURN] / 2 + Proj.damage_types[BURN] * ricochetchance / 200)
			Proj.def_zone = ran_zone()
			projectile_reflection(Proj)		// Reflect before health, runtimes occur in some cases if health happens first.
			visible_message("<span class='danger'>\The [Proj] ricochets off the surface of wall!</span>")
			take_damage(min(proj_health - healthdiff, 100))
			new /obj/effect/sparks(get_turf(Proj))
			return PROJECTILE_CONTINUE // complete projectile permutation

	//cut some projectile health here and not in projectile.dm, because we need not to all things what are using get_str_dam() becomes thin and weak.
	//in general, bullets have 35-95 health, and they are plased in ~30 bullets magazines, so 50*30 = 150, but plasteel walls have only 400 hp =|
	//but you may also increase materials thickness or etc.
	proj_health = round(Proj.get_structure_damage() / 3)//Yo may replace 3 to 5-6 to make walls fucking stronk as a Poland

	//cap the amount of health, so that things like emitters can't destroy walls in one hit.
	var/health_taken = 0
	if(Proj.nocap_structures)
		health_taken = proj_health * 4
	else
		health_taken = min(proj_health, 100)

	create_bullethole(Proj)//Potentially infinite bullet holes but most walls don't last long enough for this to be a problem.

/* TODO: Let's not chip off material for now, this could be a separate proc --KIROV
	if(Proj.damage_types[BRUTE] && prob(health / maxHealth * 33))
		var/obj/item/trash/material/metal/slug = new(get_turf(Proj))
		slug.matter.Cut()
		slug.matter[reinf_material ? reinf_material.name : material.name] = 0.1
		slug.throw_at(get_turf(Proj), 0, 1)
*/
	take_damage(health_taken)


/turf/wall/hitby(atom/movable/AM, speed = THROWFORCE_SPEED_DIVISOR)
	if(density)
		AM.throwing = FALSE
	if(ismob(AM))
		return
	var/tforce = AM:throwforce * (speed/THROWFORCE_SPEED_DIVISOR)
	if(tforce < 15)
		return
	take_damage(tforce)


/turf/wall/ChangeTurf(new_turf_type, force_lighting_update)
	for(var/obj/effect/overlay/wallrot/WR in src)
		qdel(WR)
	for(var/obj/effect/plant/plant in range(src, 1))
		if(plant.wall_mount == src) //shrooms drop to the floor
			qdel(plant)
		plant.update_neighbors()
	clear_bulletholes()
	..() // Call /turf/proc/ChangeTurf()


/turf/wall/examine(mob/user, extra_description = "")
	if(health == maxHealth)
		extra_description += SPAN_NOTICE("It looks fully intact.")
	else
		var/hratio = health / maxHealth
		if(hratio <= 0.3)
			extra_description += SPAN_WARNING("It looks heavily damaged.")
		else if(hratio <= 0.6)
			extra_description += SPAN_WARNING("It looks moderately damaged.")
		else
			extra_description += SPAN_DANGER("It looks lightly damaged.")

	if(locate(/obj/effect/overlay/wallrot) in src)
		extra_description += SPAN_WARNING("\nThere is fungus growing on [src].")


/turf/wall/melt()
	ChangeTurf(/turf/floor/plating)
	var/turf/floor/F = src
	if(!F)
		return
	F.burn_tile()
	F.icon_state = "wall_thermite"
	visible_message(SPAN_DANGER("\The [src] spontaneously combusts!")) //!!OH SHIT!!

/turf/wall/take_damage(damage)
	if(damage < 1)
		return
	if(locate(/obj/effect/overlay/wallrot) in src)
		damage *= 10
	. = min(health, damage)
	health -= damage
	if(health <= 0)
		dismantle_wall()
	else
		update_icon()


/turf/wall/explosion_act(target_power, explosion_handler/handler)
	var/absorbed = take_damage(target_power)
	// All health has been blocked
	if(absorbed == target_power)
		return target_power
	return absorbed + ..(target_power - absorbed)

/turf/wall/adjacent_fire_act(turf/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	var/melting_point = (hardness > 100) ? 6000 : 1800
	if(adj_temp > melting_point)
		take_damage(log(RAND_DECIMAL(0.9, 1.1) * (adj_temp - melting_point)))

/turf/wall/proc/thermitemelt(mob/user) // TODO: Refactor this --KIROV
	var/obj/effect/overlay/O = new/obj/effect/overlay(src)
	O.name = "Thermite"
	O.desc = "Looks hot."
	O.icon = 'icons/effects/fire.dmi'
	O.icon_state = "2"
	O.anchored = TRUE
	O.density = TRUE
	O.layer = 5

	thermite = FALSE
	take_damage(maxHealth / ((hardness > 100) ? 2 : 1)) // thermite overkills steel immediately but not plasteel

	if(istype(src, /turf/floor))
		var/turf/floor/F = src
		F.burn_tile()
		F.icon_state = "wall_thermite"
		to_chat(user, SPAN_WARNING("The thermite starts melting the wall away."))
	else
		to_chat(user, SPAN_WARNING("The thermite starts melting through the wall."))


	spawn(10 SECONDS)
		if(O)
			qdel(O)

/turf/wall/proc/create_window()
	CRASH("Proc 'create_window()' is called on a wrong wall type! src: [src], usr: [usr]" )
