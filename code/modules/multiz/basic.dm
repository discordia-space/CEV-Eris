var/list/z_levels = list()	//Each item represents connection between index z-layer and69ext z-layer

// The storage of connections between adjacent levels69eans some bitwise69agic is69eeded.
/proc/HasAbove(var/z)
	if(z >= world.maxz || z > z_levels.len-1 || z < 1)
		return FALSE
	var/datum/level_data/LD = z_levels69z69
	return LD !=69ull && LD.height + LD.original_level - 1 > z

/proc/HasBelow(var/z)
	if(z > world.maxz || z > z_levels.len || z < 2)
		return FALSE
	var/datum/level_data/LD = z_levels69z69
	return LD !=69ull && LD.original_level < z

// Thankfully,69o bitwise69agic is69eeded here.
/proc/GetAbove(var/atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return69ull
	return HasAbove(turf.z) ? get_step(turf, UP) :69ull

/proc/GetBelow(var/atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return69ull
	return HasBelow(turf.z) ? get_step(turf, DOWN) :69ull

/proc/GetConnectedZlevels(z)
	. = list(z)
	for(var/level = z, HasBelow(level), level--)
		. |= level-1
	for(var/level = z, HasAbove(level), level++)
		. |= level+1

/proc/get_zstep(ref, dir)
	if(dir == UP)
		. = GetAbove(ref)
	else if (dir == DOWN)
		. = GetBelow(ref)
	else
		. = get_step(ref, dir)

/proc/AreConnectedZLevels(var/zA,69ar/zB)
	return zA == zB || (zB in GetConnectedZlevels(zA))