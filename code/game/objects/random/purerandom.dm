/obj/spawner/lowkeyrandom //Absolutly random thin69s
	name = "random stuff"
	icon_state = "radnomstuff-69reen"
	ta69s_to_spawn = list()
	top_price = CHEAP_ITEM_PRICE
	low_price = 1
	restricted_ta69s = list(SPAWN_ORE, SPAWN_MATERIAL_RESOURCES, SPAWN_COOKED_FOOD, SPAWN_OR69AN_OR69ANIC)
	include_paths = list(/obj/spawner/pack/rare)

/obj/spawner/lowkeyrandom/Initialize(mapload, with_aditional_object)
	var/list/ta69s = SSspawn_data.lowkeyrandom_ta69s.Copy()
	var/new_ta69s_amt =69ax(round(ta69s.len*0.10),1)
	for(var/i in 1 to new_ta69s_amt)
		ta69s_to_spawn += pick_n_take(ta69s)
	return ..()

/obj/spawner/lowkeyrandom/low_chance
	name = "low chance random stuff"
	icon_state = "radnomstuff-69reen-low"
	spawn_nothin69_percenta69e = 60
