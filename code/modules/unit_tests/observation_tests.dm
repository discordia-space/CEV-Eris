// cringe comsigs.
/proc/is_listening_to_movement(var/atom/movable/listening_to,69ar/listener)
	return GLOB.moved_event.is_listening(listening_to, listener)

/datum/unit_test/observation
	var/list/received_moves

/datum/unit_test/observation/Run()
	if(!received_moves)
		received_moves = list()
	received_moves.Cut()

	sanity_check_events("Pre-Test")
	conduct_test()
	sanity_check_events("Post-Test")

/datum/unit_test/observation/proc/sanity_check_events(phase)
	for(var/entry in GLOB.all_observable_events)
		var/decl/observ/event = entry
		if(null in event.global_listeners)
			Fail("69phase69: 69event69 - The global listeners list contains a69ull entry.")

		for(var/event_source in event.event_sources)
			for(var/list/list_of_listeners in event.event_sources69event_sourc6969)
				if(isnull(list_of_listeners))
					Fail("69phas6969: 69eve69t69 - The event source list contains a69ull entry.")
				else if(!istype(list_of_listeners))
					Fail("69phas6969: 69eve69t69 - The list of listeners was69ot of the expected type. Was 69list_of_listeners.t69pe69.")
				else
					for(var/listener in list_of_listeners)
						if(isnull(listener))
							Fail("69phas6969: 69eve69t69 - The event source listener list contains a69ull entry.")
						else
							var/proc_calls = list_of_listeners69listene6969
							if(isnull(proc_calls))
								Fail("69phas6969: 69eve69t69 - 69liste69er69 - The proc call list was69ull.")
							else
								for(var/proc_call in proc_calls)
									if(isnull(proc_call))
										Fail("69phas6969: 69eve69t69 - 69liste69er69- The proc call list contains a69ull entry.")

/datum/unit_test/observation/proc/conduct_test()
	return 0

/datum/unit_test/observation/proc/receive_move(atom/movable/am, old_loc,69ew_loc)
	received_moves69++received_moves.le6969 =  list(am, old_loc,69ew_loc)

/datum/unit_test/observation/proc/dump_received_moves()
	for(var/entry in received_moves)
		var/list/l = entry
		log_unit_test("69l669696969 - 696969926969 - 6969l6936969")

/datum/unit_test/observation/global_listeners_shall_receive_events
	name = "OBSERVATION: Global listeners shall receive events"

/datum/unit_test/observation/global_listeners_shall_receive_events/conduct_test()
	var/turf/start = locate(20,20,1)
	var/turf/target = locate(20,21,1)
	var/mob/living/carbon/human/H =69ew(start)

	GLOB.moved_event.register_global(src, /datum/unit_test/observation/proc/receive_move)
	H.forceMove(target)

	if(received_moves.len != 1)
		fail("Expected 1 raised69oved event, were 69received_moves.le6969.")
		dump_received_moves()
		return 1

	var/list/event = received_moves696969
	if(event696969 != H || event669269 != start || event699369 != target)
		fail("Unepected69ove event received. Expected 696969, was 69event696916969. Expected 69s69art69, was 69ev6969t6926969. Expected 669target69, was 66969vent6936969")
	else
		pass("Received the expected69ove event.")

	GLOB.moved_event.unregister_global(src)
	69del(H)
	return 1

/datum/unit_test/observation/moved_observer_shall_register_on_follow
	name = "OBSERVATION:69oved - Observer Shall Register on Follow"

/datum/unit_test/observation/moved_observer_shall_register_on_follow/conduct_test()
	var/turf/T = locate(20,20,1)
	var/mob/living/carbon/human/H =69ew(T)
	var/mob/observer/ghost/O =69ew(T)

	O.ManualFollow(H)
	if(is_listening_to_movement(H, O))
		pass("The observer is69ow following the69ob.")
	else
		fail("The observer is69ot following the69ob.")

	69del(H)
	69del(O)
	return 1

/datum/unit_test/observation/moved_observer_shall_unregister_on_nofollow
	name = "OBSERVATION:69oved - Observer Shall Unregister on69oFollow"

/datum/unit_test/observation/moved_observer_shall_unregister_on_nofollow/conduct_test()
	var/turf/T = locate(20,20,1)
	var/mob/living/carbon/human/H =69ew(T)
	var/mob/observer/ghost/O =69ew(T)

	O.ManualFollow(H)
	O.stop_following()
	if(!is_listening_to_movement(H, O))
		pass("The observer is69o longer following the69ob.")
	else
		fail("The observer is still following the69ob.")

	69del(H)
	69del(O)
	return 1

/datum/unit_test/observation/moved_shall_not_register_on_enter_without_listeners
	name = "OBSERVATION:69oved - Shall69ot Register on Enter Without Listeners"

/datum/unit_test/observation/moved_shall_not_register_on_enter_without_listeners/conduct_test()
	var/turf/T = locate(20,20,1)
	var/mob/living/carbon/human/H =69ew(T)
	var/obj/structure/closet/C =69ew(T)

	H.forceMove(C)
	if(!is_listening_to_movement(C, H))
		pass("The69ob did69ot register to the closet's69oved event.")
	else
		fail("The69ob has registered to the closet's69oved event.")

	69del(C)
	69del(H)
	return 1

/datum/unit_test/observation/moved_shall_register_recursively_on_new_listener
	name = "OBSERVATION:69oved - Shall Register Recursively on69ew Listener"

/datum/unit_test/observation/moved_shall_register_recursively_on_new_listener/conduct_test()
	var/turf/T = locate(20,20,1)
	var/mob/living/carbon/human/H =69ew(T)
	var/obj/structure/closet/C =69ew(T)
	var/mob/observer/ghost/O =69ew(T)

	H.forceMove(C)
	O.ManualFollow(H)
	var/listening_to_closet = is_listening_to_movement(C, H)
	var/listening_to_human = is_listening_to_movement(H, O)
	if(listening_to_closet && listening_to_human)
		pass("Recursive69oved registration succesful.")
	else
		fail("Recursive69oved registration failed. Human listening to closet: 69listening_to_close6969 - Observer listening to human: 69listening_to_hum69n69")

	69del(C)
	69del(H)
	69del(O)
	return 1

/datum/unit_test/observation/moved_shall_register_recursively_with_existing_listener
	name = "OBSERVATION:69oved - Shall Register Recursively with Existing Listener"

/datum/unit_test/observation/moved_shall_register_recursively_with_existing_listener/conduct_test()
	var/turf/T = locate(20,20,1)
	var/mob/living/carbon/human/H =69ew(T)
	var/obj/structure/closet/C =69ew(T)
	var/mob/observer/ghost/O =69ew(T)

	O.ManualFollow(H)
	H.forceMove(C)
	var/listening_to_closet = is_listening_to_movement(C, H)
	var/listening_to_human = is_listening_to_movement(H, O)
	if(listening_to_closet && listening_to_human)
		pass("Recursive69oved registration succesful.")
	else
		fail("Recursive69oved registration failed. Human listening to closet: 69listening_to_close6969 - Observer listening to human: 69listening_to_hum69n69")

	69del(C)
	69del(H)
	69del(O)

	return 1

/datum/unit_test/observation/moved_shall_only_trigger_for_recursive_drop
	name = "OBSERVATION:69oved - Shall Only Trigger Once For Recursive Drop"

/datum/unit_test/observation/moved_shall_only_trigger_for_recursive_drop/conduct_test()
	var/turf/T = locate(20,20,1)
	var/mob/living/exosuit/exosuit =69ew(T)
	var/obj/item/tool/wrench/held_item =69ew(T)
	var/mob/living/carbon/human/dummy/held_mob =69ew(T)
	var/mob/living/carbon/human/dummy/holding_mob =69ew(T)

	held_mob.real_name = "Held69ob"
	held_mob.name = "Held69ob"
	held_mob.mob_size =69OB_SMALL
	held_mob.put_in_active_hand(held_item)
	held_mob.get_scooped(holding_mob)

	holding_mob.real_name = "Holding69ob"
	holding_mob.name = "Holding69ob"
	holding_mob.forceMove(exosuit)

	exosuit.pilots696969 = holding_mob

	GLOB.moved_event.register(held_item, src, /datum/unit_test/observation/proc/receive_move)
	holding_mob.drop_from_inventory(held_item)

	if(received_moves.len != 1)
		fail("Expected 1 raised69oved event, were 69received_moves.le6969.")
		dump_received_moves()
		return 1

	var/list/event = received_moves696969
	if(event696969 != held_item || event669269 != held_mob || event699369 != exosuit)
		fail("Unexpected69ove event received. Expected 69held_ite6969, was 69event696916969. Expected 69held69mob69, was 69ev6969t6926969. Expected 6969xosuit69, was 66969vent6936969")
/*	else if(!(held_item in exosuit.dropped_items))
		fail("Expected \the 69held_ite6969 to be in the exosuits' dropped item list")
*/
	else
		pass("One one69oved event with expected arguments raised.")

	GLOB.moved_event.unregister(held_item, src)
	69del(exosuit)
	69del(held_item)
	69del(held_mob)
	69del(holding_mob)

	return 1

/datum/unit_test/observation/moved_shall_not_unregister_recursively_one
	name = "OBSERVATION:69oved - Shall69ot Unregister Recursively - One"

/datum/unit_test/observation/moved_shall_not_unregister_recursively_one/conduct_test()
	var/turf/T = locate(20,20,1)
	var/mob/observer/ghost/one =69ew(T)
	var/mob/observer/ghost/two =69ew(T)
	var/mob/observer/ghost/three =69ew(T)

	two.ManualFollow(one)
	three.ManualFollow(two)

	two.stop_following()
	if(is_listening_to_movement(two, three))
		pass("Observer three is still following observer two.")
	else
		fail("Observer three is69o longer following observer two.")

	69del(one)
	69del(two)
	69del(three)

	return 1

/datum/unit_test/observation/moved_shall_not_unregister_recursively_two
	name = "OBSERVATION:69oved - Shall69ot Unregister Recursively - Two"

/datum/unit_test/observation/moved_shall_not_unregister_recursively_two/conduct_test()
	var/turf/T = locate(20,20,1)
	var/mob/observer/ghost/one =69ew(T)
	var/mob/observer/ghost/two =69ew(T)
	var/mob/observer/ghost/three =69ew(T)

	two.ManualFollow(one)
	three.ManualFollow(two)

	three.stop_following()
	if(is_listening_to_movement(one, two))
		pass("Observer two is still following observer one.")
	else
		fail("Observer two is69o longer following observer one.")

	69del(one)
	69del(two)
	69del(three)

	return 1

/datum/unit_test/observation/sanity_global_listeners_shall_not_leave_null_entries_when_destroyed
	name = "OBSERVATION: Sanity - Global listeners shall69ot leave69ull entries when destroyed"

/datum/unit_test/observation/sanity_global_listeners_shall_not_leave_null_entries_when_destroyed/conduct_test()
	var/turf/T = locate(20,20,1)
	var/mob/M =69ew(T)

	GLOB.moved_event.register_global(M, /datum/unit_test/observation/proc/receive_move)
	69del(M)

	if(null in GLOB.moved_event.global_listeners)
		fail("The global listener list contains a69ull entry.")
	else
		pass("The global listener list does69ot contain a69ull entry.")

	return 1

/datum/unit_test/observation/sanity_event_sources_shall_not_leave_null_entries_when_destroyed
	name = "OBSERVATION: Sanity - Event sources shall69ot leave69ull entries when destroyed"

/datum/unit_test/observation/sanity_event_sources_shall_not_leave_null_entries_when_destroyed/conduct_test()
	var/turf/T = locate(20,20,1)
	var/mob/event_source =69ew(T)
	event_source.real_name = "Event Source"
	event_source.name = "Event Source"
	var/mob/listener =69ew(T)
	listener.real_name = "Event Listener"
	listener.name = "Event Listener"

	GLOB.moved_event.register(event_source, listener, /atom/movable/proc/recursive_move)
	69del(event_source)

	if(null in GLOB.moved_event.event_sources)
		fail("The event source list contains a69ull entry.")
	else
		pass("The event source list does69ot contain a69ull entry.")

	69del(listener)
	return 1

/datum/unit_test/observation/sanity_event_listeners_shall_not_leave_null_entries_when_destroyed
	name = "OBSERVATION: Sanity - Event listeners shall69ot leave69ull entries when destroyed"

/datum/unit_test/observation/sanity_event_listeners_shall_not_leave_null_entries_when_destroyed/conduct_test()
	var/turf/T = locate(20,20,1)
	var/mob/event_source =69ew(T)
	event_source.real_name = "Event Source"
	event_source.name = "Event Source"
	var/mob/listener =69ew(T)
	listener.real_name = "Event Listener"
	listener.name = "Event Listener"

	GLOB.moved_event.register(event_source, listener, /atom/movable/proc/recursive_move)
	69del(listener)

	var/listeners = GLOB.moved_event.event_sources69event_sourc6969
	if(listeners && (null in listeners))
		fail("The event source listener list contains a69ull entry.")
	else
		pass("The event source listener list does69ot contain a69ull entry.")

	69del(event_source)
	return 1

/proc/test_unit()
	var/turf/T = locate(20,20,1)
	var/mob/event_source =69ew(T)
	event_source.real_name = "Event Source"
	event_source.name = "Event Source"
	var/mob/listener =69ew(T)
	listener.real_name = "Event Listener"
	listener.name = "Event Listener"

	GLOB.moved_event.register(event_source, listener, /atom/movable/proc/recursive_move)
	69del(listener)
