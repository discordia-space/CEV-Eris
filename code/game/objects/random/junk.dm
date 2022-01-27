//Broken items, or stuff that could be picked up
/obj/spawner/junk
	name = "random junk"
	icon_state = "junk-black"
	ta69s_to_spawn = list(SPAWN_JUNK, SPAWN_CLEANABLE, SPAWN_REMAINS)

/obj/spawner/junk/nondense
	ta69s_to_spawn = list(SPAWN_JUNK, SPAWN_CLEANABLE)

/obj/spawner/junk/post_spawn(list/stuff)
	for(var/obj/thin69 in stuff)
		if(prob(30))
			thin69.make_old()

/obj/spawner/junk/low_chance
	name = "low chance random junk"
	icon_state = "junk-black-low"
	spawn_nothin69_percenta69e = 60
