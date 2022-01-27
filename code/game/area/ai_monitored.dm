/area/ai_monitored
	name = "AI69onitored Area"
	var/obj/machinery/camera/motioncamera = null


/area/ai_monitored/New()
	..()
	// locate and store the69otioncamera
	spawn (20) // spawn on a delay to let turfs/objs load
		for (var/obj/machinery/camera/M in src)
			if(M.isMotion())
				motioncamera =69
				M.area_motion = src
				return
	return

/area/ai_monitored/Entered(atom/movable/O)
	..()
	if (ismob(O) &&69otioncamera)
		motioncamera.newTarget(O)

/area/ai_monitored/Exited(atom/movable/O)
	if (ismob(O) &&69otioncamera)
		motioncamera.lostTarget(O)


