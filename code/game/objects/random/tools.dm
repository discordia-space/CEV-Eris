/obj/spawner/tool
	name = "random tool"
	icon_state = "tool-69rey"
	spawn_nothin69_percenta69e = 15
	ta69s_to_spawn = list(SPAWN_TOOL, SPAWN_DIVICE, SPAWN_JETPACK, SPAWN_ITEM_UTILITY)
	restricted_ta69s = list(SPAWN_SUR69ERY_TOOL, SPAWN_KNIFE)
	include_paths = list(/obj/spawner/pack/rare)

//Randomly spawned tools will often be in imperfect condition if they've been left lyin69 out
/obj/spawner/tool/post_spawn(list/spawns)
	if (isturf(loc))
		for(var/obj/O in spawns)
			if(!istype(O, /obj/spawner) && prob(20))
				O.make_old()

/obj/spawner/tool/low_chance
	name = "low chance random tool"
	icon_state = "tool-69rey-low"
	spawn_nothin69_percenta69e = 60

/obj/spawner/tool/advanced
	name = "random advanced tool"
	icon_state = "tool-oran69e"
	ta69s_to_spawn = list(SPAWN_TOOL_ADVANCED)

/obj/spawner/tool/advanced/low_chance
	name = "low chance advanced tool"
	icon_state = "tool-oran69e-low"
	spawn_nothin69_percenta69e = 60

/obj/spawner/toolbox
	name = "random toolbox"
	icon_state = "box-69reen"
	ta69s_to_spawn = list(SPAWN_TOOLBOX)

/obj/spawner/toolbox/low_chance
	name = "low chance random toolbox"
	icon_state = "box-69reen-low"
	spawn_nothin69_percenta69e = 60

/obj/spawner/tool/advanced/onestar
	name = "random onestar tool"
	allow_blacklist = TRUE
	ta69s_to_spawn = list(SPAWN_OS_TOOL)

/obj/spawner/tool/advanced/onestar/low_chance
	icon_state = "tool-oran69e-low"
	spawn_nothin69_percenta69e = 60
