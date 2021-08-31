//making this separate from /obj/landmark until that mess can be dealt with
/obj/effect/shuttle_landmark
	name = "Nav Point"
	icon = 'icons/misc/landmarks.dmi'
	icon_state = "shuttle-blue"
	alpha = 120
	anchored = TRUE
	unacidable = 1
	simulated = FALSE
	invisibility = 101

	var/landmark_tag
	//ID of the controller on the shuttle
	var/datum/computer/file/embedded_program/docking/docking_controller

	//ID of controller used for this landmark for docks with multiple ones.
	var/list/special_dock_targets

	var/dock_target

	//when the shuttle leaves this landmark, it will leave behind the base area
	//also used to determine if the shuttle can arrive here without obstruction
	var/area/base_area
	//Will also leave this type of turf behind if set.
	var/turf/base_turf
	var/shuttle_restricted
	//If set, will set base area and turf type to same as where it was spawned at
	var/autoset

/obj/effect/shuttle_landmark/New()
	..()
	GLOB.shuttle_landmarks_list += src
	tag = copytext(landmark_tag, 1) //since tags cannot be set at compile time
	if(autoset)
		base_area = get_area(src)
		var/turf/T = get_turf(src)
		if(T)
			base_turf = T.type
	else
		base_area = locate(base_area || world.area)
	name = name + " ([x],[y])"

/obj/effect/shuttle_landmark/Initialize()
	. = ..()
	spawn(10)
		if(docking_controller)
			var/docking_tag = docking_controller
			docking_controller = locate(docking_tag)
			if(!istype(docking_controller))
				admin_notice("Could not find docking controller for shuttle waypoint '[name]', docking tag was '[docking_tag]'.")
		SSshuttle.register_landmark(tag, src)

/obj/effect/shuttle_landmark/proc/is_valid(var/datum/shuttle/shuttle)
	if(shuttle.current_location == src)
		return FALSE
	for(var/area/A in shuttle.shuttle_area)
		var/list/translation = get_turf_translation(get_turf(shuttle.current_location), get_turf(src), A.contents)
		if(check_collision(translation))
			return FALSE
	return TRUE

/obj/effect/shuttle_landmark/Destroy()
	GLOB.shuttle_landmarks_list -= src
	return ..()

/obj/effect/shuttle_landmark/proc/check_collision(var/list/turf_translation)
	for(var/source in turf_translation)
		var/turf/target = turf_translation[source]
		if(!target)
			return TRUE //collides with edge of map
		if(target.loc != base_area)
			return TRUE //collides with another area
		if(target.density)
			return TRUE //dense turf
	return FALSE

//Self-naming/numbering ones.
/obj/effect/shuttle_landmark/automatic
	name = "Navpoint"
	landmark_tag = "navpoint"
	autoset = 1

/obj/effect/shuttle_landmark/automatic/Initialize()
	tag = landmark_tag+"-[x]-[y]"
	. = ..()
	base_area = get_area(src)
	if(!config.use_overmap)
		return
	add_to_sector(map_sectors["[z]"])

/obj/effect/shuttle_landmark/automatic/proc/add_to_sector(var/obj/effect/overmap/O, var/tag_only)
	if(!istype(O))
		return
	if(shuttle_restricted)
		if(!O.restricted_waypoints[shuttle_restricted])
			O.restricted_waypoints[shuttle_restricted] = list()
		O.restricted_waypoints[shuttle_restricted] += tag_only ? tag : src
	else
		O.generic_waypoints += tag_only ? tag : src

//Subtype that calls explosion on init to clear space for shuttles
/obj/effect/shuttle_landmark/automatic/clearing
	var/radius = 25

/obj/effect/shuttle_landmark/automatic/clearing/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/shuttle_landmark/automatic/clearing/LateInitialize()
	..()
	for(var/turf/T in range(radius, src))
		if(T.density)
			T.ChangeTurf(get_base_turf_by_area(T))
	for(var/obj/effect/mineral/M in range(radius, src))
		qdel(M)

/obj/item/device/spaceflare
	name = "bluespace flare"
	desc = "Burst transmitter used to broadcast all needed information for shuttle navigation systems. Has a flare attached for marking the spot where you probably shouldn't be standing."
	icon_state = "bluflare"
	light_color = COLOR_LIGHTING_BLUE_MACHINERY
	var/active

/obj/item/device/spaceflare/attack_self(var/mob/user)
	if(!active)
		visible_message("<span class='notice'>[user] pulls the cord, activating the [src].</span>")
		activate()

/obj/item/device/spaceflare/proc/activate()
	if(active)
		return
	active = 1
	var/turf/T = get_turf(src)
	var/obj/effect/shuttle_landmark/automatic/mark = new(T)
	mark.name = "Beacon signal ([T.x],[T.y])"
	if(ismob(loc))
		var/mob/M = loc
		M.drop_from_inventory(src,T)
	anchored = TRUE
	T.hotspot_expose(1500, 5)
	update_icon()

/obj/item/device/spaceflare/on_update_icon()
	if(active)
		SetIconState("bluflare_on")
		set_light(l_range = 6, l_power = 3)


/proc/check_collision(area/target_area, list/target_turfs)
	for(var/target_turf in target_turfs)
		var/turf/target = target_turf
		if(!target)
			return TRUE //collides with edge of map
		if(target.loc != target_area)
			return TRUE //collides with another area
		if(target.density)
			return TRUE //dense turf
	return FALSE


//Called when the landmark is added to an overmap sector.
/obj/effect/shuttle_landmark/proc/sector_set(var/obj/effect/overmap/O, shuttle_name)
	shuttle_restricted = shuttle_name
