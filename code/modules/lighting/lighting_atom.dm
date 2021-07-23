#define MINIMUM_USEFUL_LIGHT_RANGE 1.4

/atom
	var/light_power = 1 // Intensity of the light.
	var/light_range = 0 // Range in tiles of the light.
	var/light_color     // Hexadecimal RGB string representing the colour of the light.

	var/tmp/datum/light_source/light // Our light source. Don't fuck with this directly unless you have a good reason!
	var/tmp/list/light_sources       // Any light sources that are "inside" of us, for example, if src here was a mob that's carrying a flashlight, that flashlight's light source would be part of this list.

// The proc you should always use to set the light of this atom.
// Nonesensical value for l_color default, so we can detect if it gets set to null.
#define NONSENSICAL_VALUE -99999
/atom/proc/set_light(l_range, l_power, l_color=NONSENSICAL_VALUE)
	if(l_range > 0 && l_range < MINIMUM_USEFUL_LIGHT_RANGE)
		l_range = MINIMUM_USEFUL_LIGHT_RANGE	//Brings the range up to 1.4, which is just barely brighter than the soft lighting that surrounds players.

	if(l_range != null) light_range = l_range
	if(l_power != null) light_power = l_power
	if(l_color != NONSENSICAL_VALUE) light_color = l_color

	update_light()

#undef NONSENSICAL_VALUE

// Will update the light (duh).
// Creates or destroys it if needed, makes it update values, makes sure it's got the correct source turf...
/atom/proc/update_light()
	set waitfor = FALSE
	if (QDELETED(src))
		return

	if(!light_power || !light_range) // We won't emit light anyways, destroy the light source.
		if(light)
			light.destroy()
			light = null
	else
		if(!istype(loc, /atom/movable)) // We choose what atom should be the top atom of the light here.
			. = src
		else
			. = loc

		if(light) // Update the light or create it if it does not exist.
			light.update(.)
		else
			light = new/datum/light_source(src, .)

// Incase any lighting vars are on in the typepath we turn the light on in New().
/atom/proc/init_light()
	if(light_power && light_range)
		update_light()

	if(opacity && isturf(loc))
		var/turf/T = loc
		T.has_opaque_atom = TRUE // No need to recalculate it in this case, it's guaranteed to be on afterwards anyways.

// Destroy our light source so we GC correctly.
/atom/Destroy()
	if(light)
		light.destroy()
		light = null
	return ..()

/atom/movable/init_light()
	. = ..()

	if(opacity && isturf(loc))
		var/turf/T = loc
		T.reconsider_lights()

	if(istype(loc, /turf/simulated/open))
		var/turf/simulated/open/open = loc
		if(open.isOpen())
			open.fallThrough(src)

// If we have opacity, make sure to tell (potentially) affected light sources.
/atom/movable/Destroy()
	var/turf/T = loc
	if(opacity && istype(T))
		set_opacity(FALSE)
	return ..()

// Should always be used to change the opacity of an atom.
// It notifies (potentially) affected light sources so they can update (if needed).
/atom/movable/set_opacity(new_opacity)
	. = ..()
	if (!.)
		return

	opacity = new_opacity
	var/turf/T = loc
	if (!isturf(T))
		return

	if (new_opacity == TRUE)
		T.has_opaque_atom = TRUE
		T.reconsider_lights()
	else
		var/old_has_opaque_atom = T.has_opaque_atom
		T.recalc_atom_opacity()
		if (old_has_opaque_atom != T.has_opaque_atom)
			T.reconsider_lights()

// This code makes the light be queued for update when it is moved.
// Entered() should handle it, however Exited() can do it if it is being moved to nullspace (as there would be no Entered() call in that situation).
/atom/Entered(atom/movable/Obj, atom/OldLoc) //Implemented here because forceMove() doesn't call Move()
	. = ..()

	if(Obj && OldLoc != src)
		for(var/A in Obj.light_sources) // Cycle through the light sources on this atom and tell them to update.
			var/datum/light_source/L = A
			L.source_atom.update_light()

/atom/Exited(var/atom/movable/Obj, var/atom/newloc)
	. = ..()

	if(!newloc && Obj && newloc != src) // Incase the atom is being moved to nullspace, we handle queuing for a lighting update here.
		for(var/A in Obj.light_sources) // Cycle through the light sources on this atom and tell them to update.
			var/datum/light_source/L = A
			L.source_atom.update_light()

/obj/item/equipped()
	. = ..()
	update_light()

/obj/item/pre_pickup()
	update_light()
	return ..()

/obj/item/dropped()
	. = ..()
	SEND_SIGNAL(src, COMSIG_ITEM_DROPPED, src)
	update_light()
