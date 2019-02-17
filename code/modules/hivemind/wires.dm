//Wireweeds is an actually wires that covered with metal shell.
//They are grow and spread under rogue AI control and with help of unknown, dangerous nano-tech
//When they reach any machine, they annihilate them and rebuild into something horrible. This is 'hands' of our rogue AI

/obj/effect/plant/hivemind
	layer = 2
	health = 80
	max_health = 80 //we are a little bit durable
	var/list/killer_reagents = list("pacid", "sacid", "hclacid", "thermite")
	//internals
	var/obj/structure/hivemind_machine/node/master_node
	var/list/wires_connections = list("0", "0", "0", "0")


/obj/effect/plant/hivemind/New()
	..()
	icon = 'icons/obj/hivemind.dmi'
	spawn(2)
		update_neighbors()


/obj/effect/plant/hivemind/Destroy()
	if(master_node)
		master_node.my_wireweeds.Remove(src)
	return ..()


/obj/effect/plant/hivemind/after_spread(var/obj/effect/plant/child, var/turf/target_turf)
	if(master_node)
		master_node.add_wireweed(child)
	spawn(1)
		child.dir = get_dir(loc, target_turf) //actually this means nothing for wires, but need for animation
		flick("spread_anim", child)
		child.forceMove(target_turf)
		update_icon()


/obj/effect/plant/hivemind/proc/try_to_annihilate()
	if(hive_mind_ai && master_node)
		for(var/obj/machinery/machine_on_my_tile in loc)
			var/can_annihilate = TRUE

			//whitelist check
			if(is_type_in_list(machine_on_my_tile, hive_mind_ai.restricted_machineries))
				can_annihilate = FALSE

			//annihilation is slow process, so it's take some time
			//there we use our failure chance. Then it lower, then faster hivemind learn how to properly annihilate it
			if(can_annihilate && prob(hive_mind_ai.failure_chance))
				can_annihilate = FALSE
				shake_the(machine_on_my_tile)
				return

			 //only one machine per turf
			if(can_annihilate && !locate(/obj/structure/hivemind_machine) in loc)
				annihilate(machine_on_my_tile)
			//other will be... merged
			else if(can_annihilate)
				qdel(machine_on_my_tile)

		//modular computers handling
		var/obj/item/modular_computer/console/mod_comp = locate() in loc
		if(mod_comp)
			annihilate(mod_comp)

		//dead bodies handling
		for(var/mob/living/dead_body in loc)
			if(dead_body.stat == DEAD)
				annihilate(dead_body)


/obj/effect/plant/hivemind/update_neighbors()
	..()
	update_connections()
	update_icon()
	update_openspace()


/obj/effect/plant/hivemind/spread()
	if(hive_mind_ai && master_node)
		..()


/obj/effect/plant/hivemind/life()
	if(hive_mind_ai && master_node)
		try_to_annihilate()
		chem_handler()
	else
		//slow vanishing after node death
		health -= 10
		alpha = 255 * health/max_health
		check_health()


/obj/effect/plant/hivemind/is_mature()
	return TRUE


/obj/effect/plant/hivemind/refresh_icon()
	overlays.Cut()
	var/image/I
	for(var/i = 1 to 4)
		I = image(src.icon, "wires[wires_connections[i]]", dir = 1<<(i-1))
		overlays += I
	for(var/d in cardinal)
		var/turf/T = get_step(loc, d)
		if((locate(/obj/structure/window) in T) || istype(T, /turf/simulated/wall))
			var/image/wall_hug_overlay = image(icon = src.icon, icon_state = "wall_hug", dir = d)
			if (T.x < x)
				wall_hug_overlay.pixel_x -= 32
			else if (T.x > x)
				wall_hug_overlay.pixel_x += 32
			if (T.y < y)
				wall_hug_overlay.pixel_y -= 32
			else if (T.y > y)
				wall_hug_overlay.pixel_y += 32
			wall_hug_overlay.layer = ABOVE_WINDOW_LAYER
			overlays += wall_hug_overlay


/obj/effect/plant/hivemind/proc/update_connections(propagate = 0)
	var/list/dirs = list()
	for(var/obj/effect/plant/hivemind/W in range(1, src) - src)
		if(propagate)
			W.update_connections()
			W.update_icon()
		dirs += get_dir(src, W)

	wires_connections = dirs_to_corner_states(dirs)


//special check
//machinery is allowed, door interaction also here
/obj/effect/plant/hivemind/is_can_pass_special(var/turf/target)
	//density turf check
	if(target.density)
		return FALSE
	//custom door interaction
	if(locate(/obj/machinery/door) in target)
		var/obj/machinery/door/airlock/Door = locate() in target
		if(Door)
			//if our door isn't broken, we will try to break open. We can do only one action per call
			if(!(Door.stat & BROKEN))
				shake_the(Door)
				//first, we open our panel to give our wireweeds access to exposed airlock's electronics
				if(!Door.p_open)
					if(prob(20))
						Door.p_open = TRUE
					return FALSE
				//but if airlock is welded, we just shake it like we rummage inside
				if(Door.welded)
					return FALSE
				//if panel opened, we begin to destruct it from inside of airlock
				if(Door.p_open)
					//bolts are down? Our wireweeds infest electronics, so this isn't a problem cause it part of us
					if(Door.locked)
						if(prob(50))
							Door.unlock()
						return FALSE
					//and then, if airlock is closed, we begin destroy it electronics
					if(Door.density)
						Door.take_damage(rand(15, 50))
						return FALSE
		return FALSE
	//structure density check
	if(locate(/obj/structure) in target)
		for(var/obj/structure/S in target)
			if(S.density)
				return FALSE
	return TRUE


//What a pity that we haven't some kind proc as special library to use it somewhere
/obj/effect/plant/hivemind/proc/shake_the(var/atom/thing)
	var/init_px = thing.pixel_x
	var/shake_dir = pick(-1, 1)
	animate(thing, transform=turn(matrix(), 8*shake_dir), pixel_x=init_px + 2*shake_dir, time=1)
	animate(transform=null, pixel_x=init_px, time=6, easing=ELASTIC_EASING)


//annihilation process
/obj/effect/plant/hivemind/proc/annihilate(var/atom/subject)
	if(istype(subject, /obj/machinery) || istype(subject, /obj/item/modular_computer/console))
		if(prob(hive_mind_ai.failure_chance))
			//critical failure! This machine would be a dummy, which means - without any ability
			//let's make an infested sprite
			var/obj/structure/hivemind_machine/new_machine = new (loc)
			var/icon/infected_icon = new('icons/obj/hivemind_machines.dmi', icon_state = "wires-[rand(1, 3)]")
			var/icon/new_icon = new(subject.icon, icon_state = subject.icon_state, dir = subject.dir)
			new_icon.Blend(infected_icon, ICON_OVERLAY)
			new_machine.icon = new_icon
			var/prefix = pick("strange", "interesting", "marvelous", "unusual")
			new_machine.name = "[prefix] [subject.name]"
		else
			//of course, here we have a very little chance to spawn him, our mini-boss
			if(prob(1))
				new /mob/living/simple_animal/hostile/hivemind/mechiver(loc)
				qdel(subject)
				return
			else
				var/picked_machine
				var/list/possible_machines = subtypesof(/obj/structure/hivemind_machine)
				if(hive_mind_ai.hives.len < 10)
					if(hive_mind_ai.evo_points < (hive_mind_ai.hives.len * 100)) //one hive per 100 EP
						possible_machines -= /obj/structure/hivemind_machine/node
					else
						//we make new nodes asap, cause it has higher priority to survive, so we force it here
						picked_machine = /obj/structure/hivemind_machine/node

				//here we compare hivemind's EP with machine's required value
				for(var/machine_path in possible_machines)
					if(hive_mind_ai.evo_points <= hive_mind_ai.EP_price_list[machine_path])
						possible_machines.Remove(machine_path)

				if(!picked_machine)
					picked_machine = pick(possible_machines)
				var/obj/structure/hivemind_machine/new_machine = new picked_machine(loc)
				new_machine.update_icon()

	if(istype(subject, /mob/living) && !istype(subject, /mob/living/simple_animal/hostile/hivemind))
		//human bodies
		if(istype(subject, /mob/living/carbon/human))
			var/mob/living/L = subject
			for(var/obj/item/W in L)
				L.drop_from_inventory(W)
			var/M = pick(/mob/living/simple_animal/hostile/hivemind/himan, /mob/living/simple_animal/hostile/hivemind/phaser)
			new M(loc)
		//robot corpses
		else if(istype(subject, /mob/living/silicon))
			new /mob/living/simple_animal/hostile/hivemind/hiborg(loc)
		//other dead bodies
		else
			var/mob/living/simple_animal/hostile/hivemind/resurrected/transformed_mob =  new(loc)
			transformed_mob.absorb_the(subject)

	qdel(subject)


//////////////////////////////////////////////////////////////////
/////////////////////////>RESPONSE CODE<//////////////////////////
//////////////////////////////////////////////////////////////////


//in fact, this is some kind of reinforced wires, so we can't take samples from it and inject something too
//but we still can slice it with something sharp
/obj/effect/plant/hivemind/attackby(var/obj/item/weapon/W, var/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)

	var/weapon_type
	if (W.has_quality(QUALITY_CUTTING))
		weapon_type = QUALITY_CUTTING
	else if (W.has_quality(QUALITY_WELDING))
		weapon_type = QUALITY_WELDING

	if(weapon_type)
		if(W.use_tool(user, src, WORKTIME_FAST*0.30, weapon_type, FAILCHANCE_VERY_EASY, required_stat = STAT_ROB))
			user.visible_message(SPAN_DANGER("[user] cuts down [src]."), SPAN_DANGER("You cut down [src]."))
			die_off()
			return
		return
	else
		if(W.sharp && W.force >= 10)
			health -= rand(W.force/2, W.force) //hm, maybe make damage based on player's robust stat?
			user.visible_message(SPAN_DANGER("[user] slices [src]."), SPAN_DANGER("You slice [src]."))
		else
			user.visible_message(SPAN_DANGER("[user] trying to slice [src] with [W], but it's seems useless."),
								SPAN_DANGER("You trying to slice [src]. But it's useless!"))
	check_health()


//fire is effective, but there need some time to melt the covering
/obj/effect/plant/hivemind/fire_act()
	health -= rand(1, 4)
	check_health()


//emp is effective too
//it causes electricity failure, so our wireweeds just blowing up inside, what makes them fragile
/obj/effect/plant/hivemind/emp_act(severity)
	if(severity)
		die_off()


//Some acid and there's no problem
/obj/effect/plant/hivemind/proc/chem_handler()
	for(var/obj/effect/effect/smoke/chem/smoke in loc)
		for(var/lethal in killer_reagents)
			if(smoke.reagents.has_reagent(lethal))
				die_off()
				return