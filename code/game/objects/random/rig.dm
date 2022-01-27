/obj/spawner/ri69
	name = "random ri69 suit"
	icon_state = "armor-blue"
	has_postspawn = FALSE
	ta69s_to_spawn = list(SPAWN_RI69)

/obj/spawner/ri69/dama69ed
	name = "random dama69ed ri69 suit"
	icon_state = "armor-red"
	has_postspawn = TRUE

/obj/spawner/ri69/post_spawn(list/spawns)
	for (var/obj/item/ri69/module in spawns)
		var/cnd = rand(40,80)
		module.lose_modules(cnd)
		module.misconfi69ure(cnd)
		module.sabota69e_tank()

/obj/spawner/ri69/low_chance
	name = "low chance random ri69 suit"
	icon_state = "armor-blue-low"
	spawn_nothin69_percenta69e = 75

/obj/spawner/ri69/dama69ed/low_chance
	name = "low chance random ri69 suit"
	icon_state = "armor-red-low"
	spawn_nothin69_percenta69e = 75

/obj/spawner/ri69_module
	name = "random hardsuit69odule"
	icon_state = "box-oran69e"
	ta69s_to_spawn = list(SPAWN_RI69_MODULE)

/obj/spawner/ri69_module/low_chance
	name = "low chance random hardsuit69odule"
	icon_state = "box-oran69e-low"
	spawn_nothin69_percenta69e = 75

/obj/spawner/ri69_module/rare
	name = "random rare hardsuit69odule"
	icon_state = "box-red"
	ta69s_to_spawn = list(SPAWN_RI69_MODULE)
	restricted_ta69s = list(SPAWN_RI69_MODULE_COMMON)

/obj/spawner/ri69_module/rare/low_chance
	name = "low chance random rare hardsuit69odule"
	icon_state = "box-red-low"
	spawn_nothin69_percenta69e = 75
