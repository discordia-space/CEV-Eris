GLOBAL_LIST_EMPTY(simple_portals)

//Simple, stable, pre-mapped portal locations with any vis content wizardry. Able to be truned on and off at will.
//All portals require tags to be set.

/obj/effect/map_effect/simple_portal
	name = "simple_portal"
	var/portal_tag = "test" //For a portal to be made, 2 (and only 2) portals need to share the same ID value.
	var/active = FALSE
	var/start_active = TRUE //To be changed in map var editor
	var/obj/effect/map_effect/simple_portal/counterpart //For syncronization of turning the portals on and off.
	var/obj/effect/portal/perfect/our_portal //Portal that is later created/deleted

/obj/effect/map_effect/simple_portal/Initialize()
	GLOB.simple_portals += src
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/map_effect/simple_portal/LateInitialize()
	find_counterparts()
	if(start_active)
		try_activate()

/obj/effect/map_effect/simple_portal/Destroy()
	GLOB.simple_portals -= src
	return ..()

/obj/effect/map_effect/simple_portal/proc/find_counterparts()
	for(var/thing in GLOB.simple_portals)
		var/obj/effect/map_effect/simple_portal/M = thing
		if(M == src)
			continue
		if(M.counterpart)
			continue

		if(M.portal_tag == src.portal_tag)
			counterpart = M
			M.counterpart = src
			break
        //Not finding a counterpart is possible if we want to use these in maps instaced mid game, so it just needs to be accounted for.

/obj/effect/map_effect/simple_portal/proc/try_activate(recursive = TRUE) //If recursive is set false from the get-go the portals will be one way.
	if(!counterpart || active)
		return FALSE
	active = TRUE
	var/turf/T = get_turf(counterpart)
	our_portal = new /obj/effect/portal/perfect(get_turf(src))
	our_portal.set_target(T)
	if(recursive)
		counterpart.try_activate(FALSE)
	return TRUE

/obj/effect/map_effect/simple_portal/proc/try_deactivate(recursive = TRUE)
	if(!counterpart || !active)
		return FALSE
	active = FALSE
	qdel(our_portal)
	our_portal = null
	if(recursive)
		counterpart.try_deactivate(FALSE)
	return TRUE
