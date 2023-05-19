GLOBAL_LIST_EMPTY(all_portal_masters)

/*

Portal map effects allow a mapper to join two distant places together, while looking somewhat seamlessly connected.
This can allow for very strange PoIs that twist and turn in what appear to be physically impossible ways.

Portals do have some specific requirements when mapping them in;
	- There must by one, and only one `/obj/effect/map_effect/portal/master` for each side of a portal.
	- Both sides need to have matching `portal_id`s in order to link to each other.
	- Each side must face opposite directions, e.g. if side A faces SOUTH, side B must face NORTH.
	- Clarification on the above - you will be moved in the direction that the portal faces.
	  If Side A faces south, you will be moved south. Dirs are 1/2/4/8, 1: NORTH, 2: SOUTH, 4: EAST, 8: WEST.
	  To further explain: If your cave entrance is on the NORTH side of the map on ENTRY side, and SOUTH side on EXIT side:
	  You will need to set the ENTRY side's dir to 2, IE SOUTH, as that's the direction you will moving coming FROM the EXIT side.
	  IE: Directions should be set based on the direction of travel.
	- Each side must have the same orientation, e.g. horizontal on both sides, or vertical on both sides.
	- Portals can be made to be longer than 1x1 with `/obj/effect/map_effect/portal/line`s,
	  but both sides must have the same length.
	- If portal lines are added, they must form a straight line and be next to a portal master or another portal line.
	- If portal lines are used, both portal masters should be in the same relative position among the lines.
	  E.g. both being on the left most side on a horizontal row.

Portals also have some limitations to be aware of when mapping. Some of these are not an issue if you're trying to make an 'obvious' portal;
	- The objects seen through portals are purely visual, which has many implications,
	  such as simple_mob AIs being blind to mobs on the other side of portals.
	- Objects on the other side of a portal can be interacted with if the interaction has no range limitation,
	  or the distance between the two portal sides happens to be less than the interaction max range. Examine will probably work,
	  while picking up an item that appears to be next to you will fail.
	- Sounds currently are not carried across portals.
	- Mismatched lighting between each portal end can make the portal look obvious.
	- Portals look weird when observing as a ghost, or otherwise when able to see through walls. Meson vision will also spoil the illusion.
	- Walls that change icons based on neightboring walls can give away that a portal is nearby if both sides don't have a similar transition.
	- Projectiles that pass through portals will generally work as intended, however aiming and firing upon someone on the other side of a portal
	  will likely be weird due to the click targeting the real position of the thing clicked instead of the apparent position.
	  Thrown objects suffer a similar fate.
	- The tiles that are visually shown across a portal are determined based on visibility at the time of portal initialization,
	  and currently don't update, meaning that opacity changes are not reflected, e.g. a wall is deconstructed, or an airlock is opened.
	- There is currently a small but somewhat noticable pause in mob movement when moving across a portal,
	  as a result of the mob's glide animation being inturrupted by a teleport.
	- Gas is not transferred through portals, and ZAS is oblivious to them.

A lot of those limitations can potentially be solved with some more work. Otherwise, portals work best in static environments like Points of Interest,
when portals are shortly lived, or when portals are made to be obvious with special effects.
*/

/obj/effect/map_effect/portal
	name = "portal subtype"
	invisibility = 0
	opacity = TRUE
	layer = FLY_LAYER
	appearance_flags = PIXEL_SCALE|KEEP_TOGETHER // Removed TILE_BOUND so things not visible on the other side stay hidden from the viewer.

	var/obj/effect/map_effect/portal/counterpart = null // The portal line or master that this is connected to, on the 'other side'.

	// Information used to apply `pixel_[x|y]` offsets so that the visuals line up.
	// Set automatically by `calculate_dimensions()`.
	var/total_height = 0 // Measured in tiles.
	var/total_width = 0

	var/portal_distance_x = 0 // How far the portal is from the left edge, in tiles.
	var/portal_distance_y = 0 // How far the portal is from the top edge.

/obj/effect/map_effect/portal/Destroy()
	vis_contents = null
	if(counterpart)
		counterpart.counterpart = null // Disconnect our counterpart from us
		counterpart = null // Now disconnect us from them.
	return ..()

// Called when something touches the portal, and usually teleports them to the other side.
/obj/effect/map_effect/portal/Crossed(atom/movable/AM)
	..()
	if(!AM)
		return
	if(!counterpart)
		return

	go_through_portal(AM)


/obj/effect/map_effect/portal/proc/go_through_portal(atom/movable/AM)
	// TODO: Find a way to fake the glide or something.
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.pulling)
			var/atom/movable/pulled = L.pulling
			L.stop_pulling()
			// For some reason, trying to put the pulled object behind the person makes the drag stop and it doesn't even move to the other side.
		//	pulled.forceMove(get_turf(counterpart))
			pulled.forceMove(counterpart.get_focused_turf())
			L.forceMove(counterpart.get_focused_turf())
			L.start_pulling(pulled)
		else
			L.forceMove(counterpart.get_focused_turf())
	else
		AM.forceMove(counterpart.get_focused_turf())

// 'Focused turf' is the turf directly in front of a portal,
// and it is used both as the destination when crossing, as well as the PoV for visuals.
/obj/effect/map_effect/portal/proc/get_focused_turf()
	return get_step(get_turf(src), dir)

// Determines the size of the block of turfs inside `vis_contents`, and where the portal is in relation to that.
/obj/effect/map_effect/portal/proc/calculate_dimensions()
	var/highest_x = 0
	var/lowest_x = 0

	var/highest_y = 0
	var/lowest_y = 0

	// First pass is for finding the top right corner.
	for(var/thing in vis_contents)
		var/turf/T = thing
		if(T.x > highest_x)
			highest_x = T.x
		if(T.y > highest_y)
			highest_y = T.y

	lowest_x = highest_x
	lowest_y = highest_y

	// Second one is for the bottom left corner.
	for(var/thing in vis_contents)
		var/turf/T = thing
		if(T.x < lowest_x)
			lowest_x = T.x
		if(T.y < lowest_y)
			lowest_y = T.y

	// Now calculate the dimensions.
	total_width = (highest_x - lowest_x) + 1
	total_height = (highest_y - lowest_y) + 1

	// Find how far the portal is from the edges.
	var/turf/focused_T = counterpart.get_focused_turf()
	portal_distance_x = lowest_x - focused_T.x
	portal_distance_y = lowest_y - focused_T.y


// Portal masters manage everything else involving portals.
// This is the base type. Use `/side_a` or `/side_b` with matching IDs for actual portals.
/obj/effect/map_effect/portal/master
	name = "portal master"
	var/portal_id = "test" // For a portal to be made, both the A and B sides need to share the same ID value.
	var/list/portal_lines = list()

/obj/effect/map_effect/portal/master/Initialize()
	GLOB.all_portal_masters += src
	find_lines()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/map_effect/portal/master/LateInitialize()
	find_counterparts()
	make_visuals()
	apply_offset()

/obj/effect/map_effect/portal/master/Destroy()
	GLOB.all_portal_masters -= src
	for(var/thing in portal_lines)
		qdel(thing)
	return ..()

/obj/effect/map_effect/portal/master/proc/find_lines()
	var/list/dirs_to_search = list(turn(dir, 90), turn(dir, -90))

	for(var/dir_to_search in dirs_to_search)
		var/turf/current_T = get_turf(src)
		while(current_T)
			current_T = get_step(current_T, dir_to_search)
			var/obj/effect/map_effect/portal/line/line = locate() in current_T
			if(line)
				portal_lines += line
				line.my_master = src
			else
				break

// Connects both sides of a portal together.
/obj/effect/map_effect/portal/master/proc/find_counterparts()
	for(var/thing in GLOB.all_portal_masters)
		var/obj/effect/map_effect/portal/master/M = thing
		if(M == src)
			continue
		if(M.counterpart)
			continue

		if(M.portal_id == src.portal_id)
			counterpart = M
			M.counterpart = src
			if(portal_lines.len)
				for(var/i = 1 to portal_lines.len)
					var/obj/effect/map_effect/portal/line/our_line = portal_lines[i]
					var/obj/effect/map_effect/portal/line/their_line = M.portal_lines[i]
					our_line.counterpart = their_line
					their_line.counterpart = our_line
			break

	if(!counterpart)
		CRASH("Portal master [type] ([x],[y],[z]) could not find another portal master with a matching portal_id ([portal_id]).")

/obj/effect/map_effect/portal/master/proc/make_visuals()
	var/list/observed_turfs = list()
	for(var/thing in portal_lines + src)
		var/obj/effect/map_effect/portal/P = thing
		P.name = null
		P.icon_state = null

		if(!P.counterpart)
			return

		var/turf/T = P.counterpart.get_focused_turf()
		P.vis_contents += T

		var/list/things = dview(world.view, T)
		for(var/turf/turf in things)
			if(get_dir(turf, T) & P.dir)
				if(turf in observed_turfs) // Avoid showing the same turf twice or more for improved performance.
					continue

				P.vis_contents += turf
				observed_turfs += turf

		P.calculate_dimensions()

// Shifts the portal's pixels in order to line up properly, as BYOND offsets the sprite when it holds multiple turfs inside `vis_contents`.
// This undos the shift that BYOND did.
/obj/effect/map_effect/portal/master/proc/apply_offset()
	for(var/thing in portal_lines + src)
		var/obj/effect/map_effect/portal/P = thing

		P.pixel_x = WORLD_ICON_SIZE * P.portal_distance_x
		P.pixel_y = WORLD_ICON_SIZE * P.portal_distance_y

// Allows portals to transfer emotes.
// Only portal masters do this to avoid flooding the other side with duplicate messages.
/obj/effect/map_effect/portal/master/see_emote(mob/M, text)
	if(!counterpart)
		return
	var/turf/T = counterpart.get_focused_turf()
	var/list/in_range = get_mobs_and_objs_in_view_fast(T, world.view, 0)
	var/list/mobs_to_relay = in_range["mobs"]

	for(var/thing in mobs_to_relay)
		var/mob/mob = thing
		var/rendered = "<span class='message'>[text]</span>"
		mob.show_message(rendered)

	..()

// Allows portals to transfer visible messages.
/obj/effect/map_effect/portal/master/show_message(msg, type, alt, alt_type)
	if(!counterpart)
		return
	var/rendered = "<span class='message'>[msg]</span>"
	var/turf/T = counterpart.get_focused_turf()
	var/list/in_range = get_mobs_and_objs_in_view_fast(T, world.view, 0)
	var/list/mobs_to_relay = in_range["mobs"]

	for(var/thing in mobs_to_relay)
		var/mob/mob = thing
		mob.show_message(rendered)

	..()

// Allows portals to transfer speech.
/obj/effect/map_effect/portal/master/hear_talk(mob/M, var/msg, verb)
	if(!counterpart)
		return
	var/turf/T = counterpart.get_focused_turf()
	var/list/in_range = get_mobs_and_objs_in_view_fast(T, world.view, 0)
	var/list/mobs_to_relay = in_range["mobs"]

	for(var/thing in mobs_to_relay)
		var/mob/mob = thing
		var/name_used = "Someone"
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			name_used = H.GetVoice()
		else
			name_used = M.name
		var/rendered = null
		rendered = "<span class='game say'><span class='name'>[name_used]</span> [msg]</span>"
		mob.show_message(rendered, 2)

	..()


/obj/effect/map_effect/portal/master/side_a
	name = "portal master A"
	icon_state = "portal_side_a"
//	color = "#00FF00"

/obj/effect/map_effect/portal/master/side_b
	name = "portal master B"
	icon_state = "portal_side_b"
//	color = "#FF0000"



// Portal lines extend out from the sides of portal masters,
// They let portals be longer than 1x1.
// Both sides MUST be the same length, meaning if side A is 1x3, side B must also be 1x3.
/obj/effect/map_effect/portal/line
	name = "portal line"
	var/obj/effect/map_effect/portal/master/my_master = null

/obj/effect/map_effect/portal/line/Destroy()
	if(my_master)
		my_master.portal_lines -= src
		my_master = null
	return ..()

/obj/effect/map_effect/portal/line/side_a
	name = "portal line A"
	icon_state = "portal_line_side_a"

/obj/effect/map_effect/portal/line/side_b
	name = "portal line B"
	icon_state = "portal_line_side_b"
