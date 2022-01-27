
/obj/machinery/auto_cloner
	name = "mysterious pod"
	desc = "It's full of a69iscous li69uid, but appears dark and silent."
	icon = 'icons/obj/cryogenics.dmi'
	icon_state = "cellold0"
	var/spawn_type
	var/time_spent_spawning = 0
	var/time_per_spawn = 0
	var/last_process= 0
	density = TRUE
	var/previous_power_state = 0

	use_power = IDLE_POWER_USE
	active_power_usage = 2000
	idle_power_usage = 1000

/obj/machinery/auto_cloner/New()
	..()

	time_per_spawn = rand(1200,3600)

	//33% chance to spawn69asties
	if(prob(33))
		spawn_type = pick(\
		/mob/living/carbon/superior_animal/giant_spider/nurse,\
		/mob/living/simple_animal/hostile/alien,\
		/mob/living/simple_animal/hostile/bear,\
		/mob/living/simple_animal/hostile/creature\
		)
	else
		spawn_type = pick(\
		/mob/living/simple_animal/cat,\
		/mob/living/simple_animal/corgi,\
		/mob/living/simple_animal/corgi/puppy,\
		/mob/living/simple_animal/chicken,\
		/mob/living/simple_animal/cow,\
		/mob/living/simple_animal/parrot,\
		/mob/living/simple_animal/slime,\
		/mob/living/simple_animal/crab,\
		/mob/living/simple_animal/mouse,\
		/mob/living/simple_animal/hostile/retaliate/goat\
		)

//todo: how the hell is the asteroid permanently powered?
/obj/machinery/auto_cloner/Process()
	if(powered(power_channel))
		if(!previous_power_state)
			previous_power_state = 1
			icon_state = "cellold1"
			src.visible_message("\blue \icon69src69 69src69 suddenly comes to life!")

		//slowly grow a69ob
		if(prob(5))
			src.visible_message("\blue \icon69src69 69src69 69pick("gloops","glugs","whirrs","whooshes","hisses","purrs","hums","gushes")69.")

		//if we've finished growing...
		if(time_spent_spawning >= time_per_spawn)
			time_spent_spawning = 0
			use_power = IDLE_POWER_USE
			src.visible_message("\blue \icon69src69 69src69 pings!")
			icon_state = "cellold1"
			desc = "It's full of a bubbling69iscous li69uid, and is lit by a69ysterious glow."
			if(spawn_type)
				new spawn_type(src.loc)

		//if we're getting close to finished, kick into overdrive power usage
		if(time_spent_spawning / time_per_spawn > 0.75)
			use_power = ACTIVE_POWER_USE
			icon_state = "cellold2"
			desc = "It's full of a bubbling69iscous li69uid, and is lit by a69ysterious glow. A dark shape appears to be forming inside..."
		else
			use_power = IDLE_POWER_USE
			icon_state = "cellold1"
			desc = "It's full of a bubbling69iscous li69uid, and is lit by a69ysterious glow."

		time_spent_spawning = time_spent_spawning + world.time - last_process
	else
		if(previous_power_state)
			previous_power_state = 0
			icon_state = "cellold0"
			src.visible_message("\blue \icon69src69 69src69 suddenly shuts down.")

		//cloned69ob slowly breaks down
		time_spent_spawning =69ax(time_spent_spawning + last_process - world.time, 0)

	last_process = world.time
