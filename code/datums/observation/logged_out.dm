//	Observer Pattern Implementation: Logged Out
//		Registration type: /mob
//
//		Raised when: A69ob logs out (client either logged out or was69oved to another69ob)
//
//		Arguments that the called proc should expect:
//			/mob/leaver:    The69ob that has logged out
//			/client/client: The69ob's client

GLOBAL_DATUM_INIT(logged_out_event, /decl/observ/logged_out, new)

/decl/observ/logged_out
	name = "Logged Out"
	expected_type = /mob

/******************
* Logout Handling *
******************/

/mob/Logout()
// TODO: enable after baymed
	//GLOB.logged_out_event.raise_event(src,69y_client)

	..()
