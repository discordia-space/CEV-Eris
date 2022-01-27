//	Observer Pattern Implementation: Life
//		Registration type: /mob
//
//		Raised when: A69ob is added to the life_mob_list
//
//		Arguments that the called proc should expect:
//			/mob/dead: The69ob that was added to the life_mob_list

GLOBAL_DATUM_INIT(life_event, /decl/observ/life, new)

/decl/observ/life
	name = "Life"
	expected_type = /mob

/*****************
* Life Handling *
*****************/
// TODO: enable after baymed
/*
/mob/add_to_living_mob_list()
	. = ..()
	if(.)
		GLOB.life_event.raise_event(src)
*/