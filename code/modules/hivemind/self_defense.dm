//Self-Defense Protocols
//Can be used at hivemind machines in attempt to save the machine


/datum/hivemind_sdp
	var/name = "Self-Defense Protocol"
	var/obj/machinery/hivemind_machine/master
	var/cooldown = 1 SECONDS
	var/silent = FALSE
	//internal
	var/current_cooldown = 0
	var/hp_percent = 0


/datum/hivemind_sdp/proc/set_master(obj/machinery/hivemind_machine/new_master)
	src.master = new_master
	hp_percent = master.maxHealth/100


/datum/hivemind_sdp/proc/turn_off()
	if(master)
		master.SDP = null
		master = null
	qdel(src)


/datum/hivemind_sdp/proc/set_cooldown()
	current_cooldown = world.time + cooldown


/datum/hivemind_sdp/proc/is_on_cooldown()
	if(world.time >= current_cooldown)
		return FALSE
	return TRUE


/datum/hivemind_sdp/proc/check_conditions()
	return


/datum/hivemind_sdp/proc/execute()
	if(!silent)
		master.state("says: \"Execution of [name] protocol initiated...\"")
	return



//SHOCKWAVE
//Emmits an energy wave, that short stuns the enemies and damage them
/datum/hivemind_sdp/shockwave
	name = "Shockwave v0.3"
	cooldown = 20 SECONDS
	silent = TRUE
	var/attack_range = 3


/datum/hivemind_sdp/shockwave/check_conditions()
	if(is_on_cooldown())
		return
	if(master.health <= (hp_percent * 60))
		for(var/mob/living/T in mobs_in_view(attack_range, master))
			if(T.stat == CONSCIOUS && T.faction != HIVE_FACTION)
				execute()
				break


/datum/hivemind_sdp/shockwave/execute()
	. = ..()
	master.visible_message("[master] emmits an energy wave!")
	playsound(master, 'sound/effects/EMPulse.ogg', 90, 1)
	var/list/targets = mobs_in_view(attack_range, master)
	for(var/mob/living/victim in targets)
		if(victim.stat == CONSCIOUS && victim.faction != HIVE_FACTION)
			victim.Weaken(5)
			step_away(victim, master)
			victim.damage_through_armor(10, BURN, BP_HEAD, ARMOR_ENERGY)

	set_cooldown()



//CHAMPION CALL
//One-shot protocol. Spawns a few hivemind mobs as champions to protect the master
/datum/hivemind_sdp/champion
	name = "CHAM-v3.14-ON"


/datum/hivemind_sdp/champion/check_conditions()
	if(master.health <= (hp_percent * 40))
		execute()
		turn_off()


/datum/hivemind_sdp/champion/execute()
	. = ..()
	var/list/places_to_spawn = list()
	for(var/turf/T in orange(1, master))
		if(!T.density)
			for(var/obj/O in T)
				if(!O.CanPass(master, T))
					continue
		places_to_spawn.Add(T)
	if(!places_to_spawn.len)
		places_to_spawn.Add(get_turf(master))

	var/mob/living/simple_animal/hostile/hivemind/champion
	var/list/champ_names = list()
	var/champion_path
	var/amount = 1

	var/squad = pick("defiler", "twins", "zeus", "swarm", GLOB.hive_data_bool["allow_tyrant_spawn"] ? "tyrant" : "defiler")
	switch(squad)
		if("defiler")
			champion_path = /mob/living/simple_animal/hostile/hivemind/mechiver
			champ_names += "Defiler"
		if("twins")
			champ_names = list("Twin Alpha", "Twin Beta", "Twin Gamma")
			amount = 3
			champion_path = /mob/living/simple_animal/hostile/hivemind/himan
		if("zeus")
			champ_names = list("Zeus", "Thor")
			champion_path = /mob/living/simple_animal/hostile/hivemind/hiborg
			amount = 2
		if("swarm")
			champ_names = list("Swarmer Slicer", "Swarmer Destroyer", "Swarmer Annihilater", "Swarmer Stinger", "Swarmer Cutter", "Swarmer Dicer")
			amount = 6
			champion_path = /mob/living/simple_animal/hostile/hivemind/stinger
		if("tyrant")
			champion_path = /mob/living/simple_animal/hostile/megafauna/hivemind_tyrant
		//Death of the tyrant = death of the hive. Players wont have to chase a bunch of nodes all over the ship around.
		//Although this would be a problem if the players go after a undefended node, said node spawns the tyrant, tyrant dies, entire hive dies.
		//Would be better if we could apply the death effect of the tyrant to the spawned champions.
		//So for now, It has a chance of showing up
	for(var/i = 1 to amount)
		var/turf/spawn_loc = pick(places_to_spawn)
		champion = new champion_path(spawn_loc)
		champion.adjustMaxHealth(150)
		champion.health += 150
		champion.malfunction_chance = 0
		champion.name = "Champion "
		if(i > champ_names.len)
			champion.name = champion.name + " " + champ_names[champ_names.len]
		else
			champion.name = champion.name + " " + champ_names[i]
		if(places_to_spawn.len > 1)
			places_to_spawn -= spawn_loc
	playsound(master, 'sound/effects/teleport.ogg', 80, 1)
	champion.say(pick("You shall be destroyed!", "Fear me!", "Face me!", "You have lived for far too long!", "Die vermin!", "Fight me insect!", "There is no escape!"))


//EMERGENCY JUMP
//Teleports master to new location
//Also disconnect wireweeds if this is node
//Single usage
/datum/hivemind_sdp/emergency_jump
	name = "wOrm-hOle"


/datum/hivemind_sdp/emergency_jump/check_conditions()
	if(GLOB.hive_data_bool["teleport_core_when_damaged"] && master.health <= (hp_percent * 30))
		execute()
		turn_off()


/datum/hivemind_sdp/emergency_jump/execute()
	. = ..()
	var/area/A = random_ship_area(filter_maintenance = TRUE, filter_critical = TRUE)
	if(A)
		var/turf/new_place = A.random_space()
		if(new_place)
			//We abandon our wires, so we lose everything
			//Let's pay our price
			if(istype(master, /obj/machinery/hivemind_machine/node))
				var/obj/machinery/hivemind_machine/node/node = master
				for(var/obj/effect/plant/hivemind/wireweed in node.my_wireweeds)
					node.remove_wireweed(wireweed)
			master.visible_message("[master] vanished in the air!")
			playsound(master, 'sound/effects/cascade.ogg', 70, 1)
			master.forceMove(new_place)
			bluespace_entropy(2, new_place, TRUE)
			master.visible_message("[master] appeared from an air!")
			playsound(master, 'sound/effects/cascade.ogg', 50, 1)
			message_admins("Hivemind node [master] emergency run at \the [jumplink(new_place)]")
