/obj/structure/droppod_door
	name = "pod door"
	desc = "A drop pod door. Opens rapidly using explosive bolts."
	icon = 'icons/obj/structures.dmi'
	icon_state = "droppod_door_closed"
	anchored = 1
	density = 1
	opacity = 1
	layer = TURF_LAYER + 0.1
	var/deploying
	var/deployed
	var/turf/origin_turf

/obj/structure/droppod_door/New(var/newloc, var/autoopen, var/origin)
	..(newloc)

	origin_turf = origin
	if(autoopen)
		spawn(100)
			deploy()

/obj/structure/droppod_door/attack_ai(var/mob/user)
	if(!user.Adjacent(src))
		return
	attack_hand(user)

/obj/structure/droppod_door/attack_generic(var/mob/user)
	if(istype(user))
		attack_hand(user)

/obj/structure/droppod_door/attack_hand(var/mob/user)
	if(deploying) return
	to_chat(user, SPAN_DANGER("You prime the explosive bolts. Better get clear!"))
	sleep(30)
	deploy()

/obj/structure/droppod_door/proc/deploy()
	if(deployed)
		return
	//Make all pod doors burst open simultaneously


	deployed = 1
	if (origin_turf)
		for (var/obj/structure/droppod_door/DD in orange(4, origin_turf))
			DD.deploy()
	visible_message(SPAN_DANGER("The explosive bolts on \the [src] detonate, throwing it open!"))
	playsound(src.loc, 'sound/effects/bang.ogg', 50, 1, 5)

	// Overwrite turfs.
	var/turf/origin = get_turf(src)
	origin.ChangeTurf(/turf/simulated/floor/reinforced)
	origin.set_light(0) // Forcing updates
	var/turf/T = get_step(origin, src.dir)
	T.ChangeTurf(/turf/simulated/floor/reinforced)
	T.set_light(0) // Forcing updates

	// Destroy turf contents.
	for(var/obj/O in origin)
		if(!O.simulated)
			continue
		qdel(O) //crunch
	for(var/obj/O in T)
		if(!O.simulated)
			continue
		qdel(O) //crunch

	// Hurl the mobs away.
	for(var/mob/living/M in T)
		M.throw_at(get_edge_target_turf(T,src.dir),rand(1,5),50)
	for(var/mob/living/M in origin)
		M.throw_at(get_edge_target_turf(origin,src.dir),rand(1,5),50)

	// Create a decorative ramp bottom and flatten out our current ramp.
	density = 0
	opacity = 0
	icon_state = "ramptop"
	var/obj/structure/droppod_door/door_bottom = new(T)
	door_bottom.deployed = 1
	door_bottom.density = 0
	door_bottom.set_opacity(FALSE)
	door_bottom.dir = src.dir
	door_bottom.icon_state = "rampbottom"