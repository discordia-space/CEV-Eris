/obj/spawner/lowkeyrandom //Absolutly random things
	name = "random stuff"
	icon_state = "radnomstuff-green"
	tags_to_spawn = list(SPAWN_ITEM)
	top_price = 800
	low_price = 1
	restricted_tags = list(SPAWN_ORE, SPAWN_MATERIAL_RESOURCES, SPAWN_COOKED_FOOD)
	include_paths = list(/obj/spawner/pack/rare)

/obj/spawner/lowkeyrandom/low_chance
	name = "low chance random stuff"
	icon_state = "radnomstuff-green-low"
	spawn_nothing_percentage = 60

/obj/spawner/lowkeyrandom/valid_candidates()
	var/list/candidates = ..()
	var/list/old_tags = lsd.take_tags(candidates)
	old_tags -= list(SPAWN_ITEM,SPAWN_OBJ)
	var/new_tags_amt = max(round(old_tags.len*0.15),1)
	tags_to_spawn = list()
	for(var/i in 1 to new_tags_amt)
		tags_to_spawn += pick_n_take(old_tags)
	.=..()
