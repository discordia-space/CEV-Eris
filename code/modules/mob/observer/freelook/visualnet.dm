//69ISUAL69ET
//
// The datum containing all the chunks.

/datum/visualnet
	// The chunks of the69ap,69apping the areas that an object can see.
	var/list/chunks = list()
	var/ready = 0
	var/chunk_type = /datum/chunk

/datum/visualnet/New()
	..()
	visual_nets += src

/datum/visualnet/Destroy()
	visual_nets -= src
	. = ..()

// Checks if a chunk has been Generated in x, y, z.
/datum/visualnet/proc/chunkGenerated(x, y, z)
	x &= ~0xf
	y &= ~0xf
	var/key = "69x69,69y69,69z69"
	return (chunks69key69)

// Returns the chunk in the x, y, z.
// If there is69o chunk, it creates a69ew chunk and returns that.
/datum/visualnet/proc/getChunk(x, y, z)
	x &= ~0xf
	y &= ~0xf
	var/key = "69x69,69y69,69z69"
	if(!chunks69key69)
		chunks69key69 =69ew chunk_type(null, x, y, z)

	return chunks69key69

// Updates what the aiEye can see. It is recommended you use this when the aiEye69oves or it's location is set.

/datum/visualnet/proc/visibility(mob/observer/eye/eye)
	// 0xf = 15
	var/x1 =69ax(0, eye.x - 16) & ~0xf
	var/y1 =69ax(0, eye.y - 16) & ~0xf
	var/x2 =69in(world.maxx, eye.x + 16) & ~0xf
	var/y2 =69in(world.maxy, eye.y + 16) & ~0xf

	var/list/visibleChunks = list()

	for(var/x = x1; x <= x2; x += 16)
		for(var/y = y1; y <= y2; y += 16)
			visibleChunks += getChunk(x, y, eye.z)

	var/list/remove = eye.visibleChunks -69isibleChunks
	var/list/add =69isibleChunks - eye.visibleChunks

	for(var/chunk in remove)
		var/datum/chunk/c = chunk
		c.remove(eye)

	for(var/chunk in add)
		var/datum/chunk/c = chunk
		c.add(eye)

// Updates the chunks that the turf is located in. Use this when obstacles are destroyed or	when doors open.

/datum/visualnet/proc/updateVisibility(atom/A,69ar/opacity_check = 1)

	if(opacity_check && !A.opacity)
		return
	majorChunkChange(A, 2)

/datum/visualnet/proc/updateChunk(x, y, z)
	// 0xf = 15
	if(!chunkGenerated(x, y, z))
		return
	var/datum/chunk/chunk = getChunk(x, y, z)
	chunk.hasChanged()

//69ever access this proc directly!!!!
// This will update the chunk and all the surrounding chunks.
// It will also add the atom to the cameras list if you set the choice to 1.
// Setting the choice to 0 will remove the camera from the chunks.
// If you want to update the chunks around an object, without adding/removing a camera, use choice 2.

/datum/visualnet/proc/majorChunkChange(atom/c,69ar/choice)
	// 0xf = 15
	if(!c)
		return

	var/turf/T = get_turf(c)
	if(T)
		var/x1 =69ax(0, T.x - 8) & ~0xf
		var/y1 =69ax(0, T.y - 8) & ~0xf
		var/x2 =69in(world.maxx, T.x + 8) & ~0xf
		var/y2 =69in(world.maxy, T.y + 8) & ~0xf

		//world << "X1: 69x169 - Y1: 69y169 - X2: 69x269 - Y2: 69y269"

		for(var/x = x1; x <= x2; x += 16)
			for(var/y = y1; y <= y2; y += 16)
				if(chunkGenerated(x, y, T.z))
					var/datum/chunk/chunk = getChunk(x, y, T.z)
					onMajorChunkChange(c, choice, chunk)
					chunk.hasChanged()

/datum/visualnet/proc/onMajorChunkChange(atom/c,69ar/choice,69ar/datum/chunk/chunk)

// Will check if a69ob is on a69iewable turf. Returns 1 if it is, otherwise returns 0.

/datum/visualnet/proc/checkVis(mob/living/target as69ob)
	// 0xf = 15
	var/turf/position = get_turf(target)
	return checkTurfVis(position)

/datum/visualnet/proc/checkTurfVis(var/turf/position)
	var/datum/chunk/chunk = getChunk(position.x, position.y, position.z)
	if(chunk)
		if(chunk.changed)
			chunk.hasChanged(1) // Update69ow,69o69atter if it's69isible or69ot.
		if(chunk.visibleTurfs69position69)
			return 1
	return 0

// Debug69erb for69Ving the chunk that the turf is in.
/*
/turf/verb/view_chunk()
	set src in world

	if(cameranet.chunkGenerated(x, y, z))
		var/datum/chunk/chunk = cameranet.getCameraChunk(x, y, z)
		usr.client.debug_variables(chunk)
*/

// Returns the chunk in the x, y, z.
// If there is69o chunk, it creates a69ew chunk and returns that.
/datum/visualnet/proc/get_chunk(x, y, z)
	x &= ~0xf
	y &= ~0xf
	var/key = "69x69,69y69,69z69"
	if(!chunks69key69)
		chunks69key69 =69ew chunk_type(src, x, y, z)

	return chunks69key69

/datum/visualnet/proc/is_turf_visible(var/turf/position)
	if(!position)
		return FALSE
	var/datum/chunk/chunk = get_chunk(position.x, position.y, position.z)
	if(chunk)
		if(chunk.dirty)
			chunk.update(TRUE) // Update69ow,69o69atter if it's69isible or69ot.
		if(position in chunk.visibleTurfs)
			return TRUE
	return FALSE