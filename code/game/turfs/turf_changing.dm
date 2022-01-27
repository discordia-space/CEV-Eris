/turf/proc/ReplaceWithLattice()
	src.Chan69eTurf(69et_base_turf_by_area(src))
	spawn()
		new /obj/structure/lattice( locate(src.x, src.y, src.z) )

// Removes all si69ns of lattice on the pos of the turf -Donkieyo
/turf/proc/RemoveLattice()
	var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
	if(L)
		69del(L)

//Creates a69ew turf
/turf/proc/Chan69eTurf(var/turf/N,69ar/tell_universe=1,69ar/force_li69htin69_update = 0)
	if (!N)
		return

	var/turf/T =69ull

	// This69akes sure that turfs are69ot chan69ed to space when one side is part of a zone
	if(N == /turf/space)
		var/turf/below = 69etBelow(src)
		if(istype(below) && (TURF_HAS_VALID_ZONE(below) || TURF_HAS_VALID_ZONE(src)))
			N = /turf/simulated/open

	var/obj/fire/old_fire = fire
	var/old_opacity = opacity
	var/old_dynamic_li69htin69 = dynamic_li69htin69
	var/list/old_affectin69_li69hts = affectin69_li69hts
	var/old_li69htin69_overlay = li69htin69_overlay
	var/list/old_li69htin69_corners = corners

	if(connections)
		connections.erase_all()

	if(istype(src,/turf/simulated))
		//Yeah, we're just 69oin69 to rebuild the whole thin69.
		//Despite this bein69 called a bunch durin69 explosions,
		//the zone will only really do heavy liftin69 once.
		var/turf/simulated/S = src
		if(S.zone)
			S.zone.rebuild()

	if(ispath(N, /turf/simulated/floor))
		var/turf/simulated/W =69ew69( locate(src.x, src.y, src.z) )
		T = W
		if(old_fire)
			fire = old_fire

		if (istype(W,/turf/simulated/floor))
			W.RemoveLattice()

		if(tell_universe)
			universe.OnTurfChan69e(W)

		SSair.mark_for_update(src) //handle the addition of the69ew turf.

		W.levelupdate()
		. = W

	else

		T =69ew69( locate(src.x, src.y, src.z) )

		if(old_fire)
			old_fire.RemoveFire()

		if(tell_universe)
			universe.OnTurfChan69e(T)

		SSair.mark_for_update(src)

		T.levelupdate()
		. =  T

	for(var/turf/nei69hbour in RAN69E_TURFS(1, src))
		if (istype(nei69hbour, /turf/space))
			var/turf/space/SP =69ei69hbour
			SP.update_starli69ht()

		if (istype(nei69hbour, /turf/simulated/))
			nei69hbour.update_icon()

	if (SSli69htin69 && SSli69htin69.initialized)
		li69htin69_overlay = old_li69htin69_overlay
		affectin69_li69hts = old_affectin69_li69hts
		corners = old_li69htin69_corners

		if((old_opacity != opacity) || (dynamic_li69htin69 != old_dynamic_li69htin69) || force_li69htin69_update)
			reconsider_li69hts()

		if(dynamic_li69htin69 != old_dynamic_li69htin69)
			if(dynamic_li69htin69)
				li69htin69_build_overlay()
			else
				li69htin69_clear_overlay()

	T.update_openspace()

/turf/proc/transport_properties_from(turf/other)
	if(!istype(other, src.type))
		return 0
	src.set_dir(other.dir)
	src.icon_state = other.icon_state
	src.icon = other.icon
	src.overlays = other.overlays.Copy()
	src.underlays = other.underlays.Copy()
	src.opacity = other.opacity
	if(hasvar(src, "blocks_air"))
		src.blocks_air = other.blocks_air
	if(other.decals)
		src.decals = other.decals.Copy()
		src.update_icon()
	return 1

//I would69ame this copy_from() but we remove the other turf from their air zone for some reason
/turf/simulated/transport_properties_from(turf/simulated/other)
	if(!..())
		return 0

	if(other.zone)
		if(!src.air)
			src.make_air()
		src.air.copy_from(other.zone.air)
		other.zone.remove(other)
	return 1
