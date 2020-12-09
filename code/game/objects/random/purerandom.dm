/obj/spawner/lowkeyrandom //Absolutly random things
	name = "random stuff"
	icon_state = "radnomstuff-green"
	tags_to_spawn = list()
	top_price = CHEAP_ITEM_PRICE
	low_price = 1
	restricted_tags = list(SPAWN_ORE, SPAWN_MATERIAL_RESOURCES, SPAWN_COOKED_FOOD, SPAWN_ORGAN_ORGANIC)
	include_paths = list(/obj/spawner/pack/rare, /obj/item/stash_spawner)

/obj/spawner/lowkeyrandom/Initialize(mapload, with_aditional_object)
	var/list/tags = SSspawn_data.lowkeyrandom_tags.Copy()
	var/new_tags_amt = max(round(tags.len*0.10),1)
	for(var/i in 1 to new_tags_amt)
		tags_to_spawn += pick_n_take(tags)
	. = ..()

/obj/spawner/lowkeyrandom/low_chance
	name = "low chance random stuff"
	icon_state = "radnomstuff-green-low"
	spawn_nothing_percentage = 60
