/obj/machinery/power/os_turret
	name = "One Star Gauss turret"
	desc = "A One Star made turret with a mounted QJZ-295 gauss machinegun." //A turret of the One Star variety.
	icon = 'icons/obj/machines/one_star/machines.dmi'
	icon_state = "os_gauss"
	circuit = /obj/item/electronics/circuitboard/os_turret
	idle_power_usage = 30
	active_power_usage = 2500
	density = TRUE
	anchored = TRUE

	// Targeting
	var/should_target_players = TRUE			// TRUE targets players, FALSE targets superior animals (roaches, golems, and spiders)
	var/range = 8								// Starts firing just out of player sight
	var/returning_fire = FALSE					// Will attempt to fire at the nearest target when attacked and no one is in range

	// Shooting
	var/obj/item/projectile/projectile = /obj/item/projectile/bullet/gauss
	var/shot_sound = 'sound/weapons/guns/fire/energy_shotgun.ogg'
	var/number_of_shots = 5
	var/time_between_shots = 0.5 SECONDS
	var/list/shot_timer_ids = list()
	var/cooldown_time = null

	// Internal
	var/emp_cooldown = 8 SECONDS
	var/emp_timer_id
	var/on_cooldown = FALSE
	var/cooldown_timer_id

/obj/machinery/power/os_turret/laser
	name = "One Star laser turret"
	icon_state = "os_laser"
	desc = "A One Star made turret with a mounted QJZ-958 laser machinegun." //A turret of the One Star variety.
	circuit = /obj/item/electronics/circuitboard/os_turret/laser
	range = 10
	projectile = /obj/item/projectile/beam/pulsed_laser
	shot_sound = 'sound/weapons/Laser.ogg'
	number_of_shots = 3
	time_between_shots = 0.3 SECONDS
	cooldown_time = 2 SECONDS
	health = 360
	maxHealth = 360

/obj/machinery/power/os_turret/Initialize()
	. = ..()
	update_icon()

	if(!cooldown_time)
		cooldown_time = time_between_shots * number_of_shots

/obj/machinery/power/os_turret/Process()
	if(stat)
		if(prob(2))
			do_sparks(1, TRUE, src)
		return

	if(health <= 0)
		stat |= BROKEN
		return

	if(!on_cooldown)
		use_power = IDLE_POWER_USE
	else
		use_power = ACTIVE_POWER_USE
		return

	update_icon()

	var/list/potential_targets = list()
	var/mob/nearest_valid_target
	var/nearest_valid_target_distance

	if(should_target_players)
		potential_targets = (GLOB.player_list & SSmobs.mob_living_by_zlevel[z])
	else
		potential_targets = (GLOB.superior_animal_list & SSmobs.mob_living_by_zlevel[z])

	for(var/mob in potential_targets)
		var/distance_to_target = get_dist(src, mob)

		if(!returning_fire && !(distance_to_target <= range))
			continue

		var/mob/living/L = mob

		if(!L)
			continue
		if(L.stat == DEAD)
			continue

		if(should_target_players)
			if(L.faction == "onestar")	// For future content or admin use
				continue

		if(L.invisibility >= INVISIBILITY_LEVEL_ONE) // Cannot see him. see_invisible is a mob-var
			continue
		if(!check_trajectory(L, src))	//check if we have true line of sight
			continue

		if(!nearest_valid_target)
			nearest_valid_target = L
			nearest_valid_target_distance = distance_to_target
		else
			if(distance_to_target < nearest_valid_target_distance)
				nearest_valid_target = L
				nearest_valid_target_distance = distance_to_target

	if(nearest_valid_target)
		try_shoot(nearest_valid_target)

/obj/machinery/power/os_turret/Destroy()
	if(cooldown_timer_id)
		deltimer(cooldown_timer_id)
	if(emp_timer_id)
		deltimer(emp_timer_id)
	if(shot_timer_ids.len)
		for(var/id in shot_timer_ids)
			deltimer(id)
	..()

/obj/machinery/power/os_turret/examine(mob/user)
	..()
	if(should_target_players)
		to_chat(user, SPAN_NOTICE("It is set to target humans, androids, and cyborgs."))
	else
		to_chat(user, SPAN_NOTICE("It is set to target golems and large bugs."))

/obj/machinery/power/os_turret/update_icon()
	underlays.Cut()
	underlays += image(icon, "osframe")

/obj/machinery/power/os_turret/emp_act()
	..()
	stat |= EMPED
	emp_timer_id = addtimer(CALLBACK(src, PROC_REF(emp_off)), emp_cooldown, TIMER_STOPPABLE)

/obj/machinery/power/os_turret/bullet_act(obj/item/projectile/proj)
	var/damage = proj.get_structure_damage()

	if(!damage)
		if(istype(proj, /obj/item/projectile/ion))
			proj.on_hit(loc)
		return

	..()

	take_damage(damage*proj.structure_damage_factor)

	if(!returning_fire && !stat)
		returning_fire = TRUE
		var/turf/proj_start_turf = proj.starting
		for(var/obj in proj_start_turf.contents)
			if(istype(obj, /obj/machinery/power/os_turret))
				return		// Don't shoot other turrets
		try_shoot(proj_start_turf)

/obj/machinery/power/os_turret/attackby(obj/item/I, mob/user)
	var/mec_or_cog = max(user.stats.getStat(STAT_MEC), user.stats.getStat(STAT_COG))

	if(mec_or_cog < STAT_LEVEL_EXPERT)
		to_chat(user, SPAN_WARNING("You lack the knowledge or skill to perform work on \the [src]."))
	else
		if(default_deconstruction(I, user))
			return
		if(default_part_replacement(I, user))
			return

	// If the turret is friendly, you can unanchor it. If not, you bash it.
	if(should_target_players)
		if(!(I.flags & NOBLUDGEON) && I.force && !(stat & BROKEN))
			// If the turret was attacked with the intention of harming it:
			user.do_attack_animation(src)
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

			if(take_damage(I.force * I.structure_damage_factor))
				playsound(src, 'sound/weapons/smash.ogg', 70, 1)
			else
				playsound(src, 'sound/weapons/Genhit.ogg', 25, 1)
			return
	else
		var/list/usable_qualities = list(QUALITY_BOLT_TURNING)

		var/tool_type = I.get_tool_type(user, usable_qualities, src)
		switch(tool_type)
			if(QUALITY_BOLT_TURNING)
				if(istype(get_turf(src), /turf/space) && !anchored)
					to_chat(user, SPAN_NOTICE("You can't anchor something to empty space. Idiot."))
					return
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You [anchored ? "un" : ""]anchor the brace with [I]."))
					anchored = !anchored
					if(anchored)
						connect_to_network()
					else
						disconnect_from_network()
			if(ABORT_CHECK)
				return

/obj/machinery/power/os_turret/RefreshParts()
	var/obj/item/electronics/circuitboard/os_turret/C = circuit
	should_target_players = !C.target_superior_mobs

/obj/machinery/power/os_turret/on_deconstruction()
	var/obj/item/electronics/circuitboard/os_turret/C = circuit
	C.target_superior_mobs = TRUE

/obj/machinery/power/os_turret/take_damage(amount)
	health = max(health - amount, 0)
	if(!health)
		stat |= BROKEN
	else if(prob(50))
		do_sparks(1, 0, loc)
	return amount

/obj/machinery/power/os_turret/proc/try_shoot(target)
	if(on_cooldown && !returning_fire)
		return

	// Delete previously queued shots to prevent overlap
	if(shot_timer_ids.len)
		for(var/id in shot_timer_ids)
			deltimer(id)
		shot_timer_ids = list()

	var/def_zone

	if(istype(target, /mob/living/carbon/human))
		def_zone = pick(
			organ_rel_size[BP_CHEST]; BP_CHEST,
			organ_rel_size[BP_GROIN]; BP_GROIN,
			organ_rel_size[BP_L_ARM]; BP_L_ARM,
			organ_rel_size[BP_R_ARM]; BP_R_ARM,
			organ_rel_size[BP_L_LEG]; BP_L_LEG,
			organ_rel_size[BP_R_LEG]; BP_R_LEG,
		)

	if(number_of_shots)
		var/to_shoot = number_of_shots - 1
		var/timer = time_between_shots
		shoot(target, def_zone)
		for(var/i in 1 to to_shoot)
			shot_timer_ids += addtimer(CALLBACK(src, PROC_REF(shoot), target, def_zone), timer, TIMER_STOPPABLE)
			timer += time_between_shots

	if(cooldown_time && !returning_fire)
		on_cooldown = TRUE
		cooldown_timer_id = addtimer(CALLBACK(src, PROC_REF(cooldown)), cooldown_time, TIMER_STOPPABLE)

	if(returning_fire)
		returning_fire = FALSE

/obj/machinery/power/os_turret/proc/shoot(atom/target, def_zone)
	if(QDELETED(target))
		return
	set_dir(get_dir(src, target))
	var/obj/item/projectile/P = new projectile(loc)
	P.launch(target, def_zone)
	playsound(src, shot_sound, 60, 1)

/obj/machinery/power/os_turret/proc/cooldown()
	on_cooldown = FALSE
	cooldown_timer_id = null

/obj/machinery/power/os_turret/proc/emp_off()
	stat &= ~EMPED
	emp_timer_id = null

/obj/item/electronics/circuitboard/os_turret
	name = T_BOARD("One Star gauss turret")
	description_info = "When re-constructed, this turret will target roaches, spiders, and golems."
	build_path = /obj/machinery/power/os_turret
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 5)
	spawn_blacklisted = TRUE
	req_components = list(
		/obj/item/stock_parts/capacitor/one_star = 2,
		/obj/item/stock_parts/matter_bin/one_star = 2,
		/obj/item/stock_parts/micro_laser/one_star = 2,
		/obj/item/stock_parts/scanning_module/one_star = 1,
		/obj/item/cell/large = 1
	)
	var/target_superior_mobs = FALSE

/obj/item/electronics/circuitboard/os_turret/examine(user, distance)
	. = ..()
	if(target_superior_mobs)
		to_chat(user, SPAN_NOTICE("When constructed, this turret will target roaches, spiders, and golems."))

/obj/item/electronics/circuitboard/os_turret/laser
	name = T_BOARD("One Star laser turret")
	build_path = /obj/machinery/power/os_turret/laser
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 5)
	spawn_blacklisted = TRUE
	req_components = list(
		/obj/item/stock_parts/capacitor/one_star = 2,
		/obj/item/stock_parts/matter_bin/one_star = 2,
		/obj/item/stock_parts/micro_laser/one_star = 2,
		/obj/item/stock_parts/scanning_module/one_star = 1,
		/obj/item/cell/large = 1
	)

/obj/item/projectile/bullet/gauss
	name = "ferrous slug"
	damage_types = list(BRUTE = 15)
	armor_divisor = 3
	penetrating = 2
	recoil = 30
	step_delay = 0.4
	sharp = TRUE	// Until all bullets are turned sharp by default
	wounding_mult = WOUNDING_EXTREME

/obj/item/projectile/beam/pulsed_laser
	name = "pulsed beam"
	icon_state = "beam_blue"
	damage_types = list(BURN = 20)
	armor_divisor = 2
	stutter = 3
	recoil = 10
	wounding_mult = WOUNDING_WIDE

	muzzle_type = /obj/effect/projectile/laser_blue/muzzle
	tracer_type = /obj/effect/projectile/laser_blue/tracer
	impact_type = /obj/effect/projectile/laser_blue/impact
