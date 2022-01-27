#define UPDATE_BUFFER 25 // 2.5 seconds

// CHUNK
//
// A 16x16 grid of the69ap with a list of turfs that can be seen, are69isible and are dimmed.
// Allows the Eye to stream these chunks and know what it can and cannot see.

/datum/obfuscation
	var/icon = 'icons/effects/cameravis.dmi'
	var/icon_state = "black"

/datum/chunk
	var/list/obscuredTurfs = list()
	var/list/visibleTurfs = list()
	var/list/obscured = list()
	var/list/turfs = list()
	var/list/seenby = list()
	var/dirty = FALSE
	var/visible = 0
	var/changed = 0
	var/updating = 0
	var/x = 0
	var/y = 0
	var/z = 0
	var/datum/obfuscation/obfuscation =69ew()

// Add an eye to the chunk, then update if changed.

/datum/chunk/proc/add(mob/observer/eye/eye)
	if(!eye.owner)
		return
	eye.visibleChunks += src
	if(eye.owner.client)
		eye.owner.client.images += obscured
	visible++
	seenby += eye
	if(changed && !updating)
		update()

// Remove an eye from the chunk, then update if changed.

/datum/chunk/proc/remove(mob/observer/eye/eye)
	if(!eye.owner)
		return
	eye.visibleChunks -= src
	if(eye.owner.client)
		eye.owner.client.images -= obscured
	seenby -= eye
	if(visible > 0)
		visible--

// Called when a chunk has changed. I.E: A wall was deleted.

/datum/chunk/proc/visibilityChanged(turf/loc)
	if(!visibleTurfs69loc69)
		return
	hasChanged()

// Updates the chunk,69akes sure that it doesn't update too69uch. If the chunk isn't being watched it will
// instead be flagged to update the69ext time an AI Eye69oves69ear it.

/datum/chunk/proc/hasChanged(var/update_now = 0)
	if(visible || update_now)
		if(!updating)
			updating = 1
			spawn(UPDATE_BUFFER) // Batch large changes, such as69any doors opening or closing at once
				update()
				updating = 0
	else
		changed = 1

// The actual updating.

/datum/chunk/proc/update()

	set background = 1

	var/list/newVisibleTurfs =69ew()
	acquireVisibleTurfs(newVisibleTurfs)

	// Removes turf that isn't in turfs.
	newVisibleTurfs &= turfs

	var/list/visAdded =69ewVisibleTurfs -69isibleTurfs
	var/list/visRemoved =69isibleTurfs -69ewVisibleTurfs

	visibleTurfs =69ewVisibleTurfs
	obscuredTurfs = turfs -69ewVisibleTurfs

	for(var/turf in69isAdded)
		var/turf/t = turf
		if(t.obfuscations69obfuscation.type69)
			obscured -= t.obfuscations69obfuscation.type69
			for(var/eye in seenby)
				var/mob/observer/eye/m = eye
				if(!m || !m.owner)
					continue
				if(m.owner.client)
					m.owner.client.images -= t.obfuscations69obfuscation.type69

	for(var/turf in69isRemoved)
		var/turf/t = turf
		if(obscuredTurfs69t69)
			if(!t.obfuscations69obfuscation.type69)
				var/image/I = image(obfuscation.icon, t, obfuscation.icon_state, BYOND_LIGHTING_LAYER+0.1)
				I.plane = t.get_relative_plane(BYOND_LIGHTING_PLANE)
				t.obfuscations69obfuscation.type69 = I

			obscured += t.obfuscations69obfuscation.type69
			for(var/eye in seenby)
				var/mob/observer/eye/m = eye
				if(!m || !m.owner)
					seenby -=69
					continue
				if(m.owner.client)
					m.owner.client.images += t.obfuscations69obfuscation.type69

/datum/chunk/proc/acquireVisibleTurfs(var/list/visible)

// Create a69ew camera chunk, since the chunks are69ade as they are69eeded.

/datum/chunk/New(loc, x, y, z)

	// 0xf = 15
	x &= ~0xf
	y &= ~0xf

	src.x = x
	src.y = y
	src.z = z

	for(var/turf/t in range(10, locate(x + 8, y + 8, z)))
		if(t.x >= x && t.y >= y && t.x < x + 16 && t.y < y + 16)
			turfs69t69 = t

	acquireVisibleTurfs(visibleTurfs)

	// Removes turf that isn't in turfs.
	visibleTurfs &= turfs

	obscuredTurfs = turfs -69isibleTurfs

	for(var/turf in obscuredTurfs)
		var/turf/t = turf
		if(!t.obfuscations69obfuscation.type69)
			var/image/I = image(obfuscation.icon, t, obfuscation.icon_state, BYOND_LIGHTING_LAYER+0.1)
			I.plane = t.get_relative_plane(BYOND_LIGHTING_PLANE)
			t.obfuscations69obfuscation.type69 = I
		obscured += t.obfuscations69obfuscation.type69

/proc/seen_turfs_in_range(var/source,69ar/range)
	var/turf/pos = get_turf(source)
	return hear(range, pos)

#undef UPDATE_BUFFER
