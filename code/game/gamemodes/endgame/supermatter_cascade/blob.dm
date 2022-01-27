// 69UALITY COPYPASTA
/turf/unsimulated/wall/supermatter
	name = "Bluespace"
	desc = "THE END IS right now actually."

	icon = 'icons/turf/space.dmi'
	icon_state = "bluespace"

	//luminosity = 5
	//l_color="#0066FF"
	plane = ABOVE_LIGHTING_PLANE
	layer = ABOVE_LIGHTING_LAYER

	var/list/avail_dirs = list(NORTH,SOUTH,EAST,WEST)

/turf/unsimulated/wall/supermatter/New()
	..()
	START_PROCESSING(SSturf, src)

/turf/unsimulated/wall/supermatter/Destroy()
	STOP_PROCESSING(SSturf, src)
	. = ..()

/turf/unsimulated/wall/supermatter/Process(wait, times_fired)
	// Only check infre69uently.
	var/how_often =69ax(round(5 SECONDS / wait), 1)
	if(times_fired % how_often)
		return

	// No69ore available directions? Stop processing.
	if(!avail_dirs.len)
		return PROCESS_KILL

	// Choose a direction.
	var/pdir = pick(avail_dirs)
	avail_dirs -= pdir
	var/turf/T=get_step(src,pdir)

	// EXPAND
	if(!istype(T,type))
		// Do pretty fadeout animation for 1s.
		new /obj/effect/overlay/bluespacify(T)
		spawn(10)
			// Nom.
			for(var/atom/movable/A in T)
				if(A)
					if(isliving(A))
						69del(A)
					else if(ismob(A)) // Observers, AI cameras.
						continue
					else
						69del(A)
			T.ChangeTurf(type)

/turf/unsimulated/wall/supermatter/attack_generic(mob/user)
	if(istype(user))
		return attack_hand(user)

/turf/unsimulated/wall/supermatter/attack_robot(mob/user)
	if(Adjacent(user))
		return attack_hand(user)
	else
		to_chat(user, "<span class = \"warning\">What the fuck are you doing?</span>")
	return

// /vg/: Don't let ghosts fuck with this.
/turf/unsimulated/wall/supermatter/attack_ghost(mob/user as69ob)
	user.examinate(src)

/turf/unsimulated/wall/supermatter/attack_ai(mob/user as69ob)
	return user.examinate(src)

/turf/unsimulated/wall/supermatter/attack_hand(mob/user as69ob)
	user.visible_message("<span class=\"warning\">\The 69user69 reaches out and touches \the 69src69... And then blinks out of existance.</span>",\
		"<span class=\"danger\">You reach out and touch \the 69src69. Everything immediately goes 69uiet. Your last thought is \"That was not a wise decision.\"</span>",\
		"<span class=\"warning\">You hear an unearthly noise.</span>")

	playsound(src, 'sound/effects/supermatter.ogg', 50, 1)

	Consume(user)

/turf/unsimulated/wall/supermatter/attackby(obj/item/W as obj,69ob/living/user as69ob)
	user.visible_message("<span class=\"warning\">\The 69user69 touches \a 69W69 to \the 69src69 as a silence fills the room...</span>",\
		"<span class=\"danger\">You touch \the 69W69 to \the 69src69 when everything suddenly goes silent.\"</span>\n<span class=\"notice\">\The 69W69 flashes into dust as you flinch away from \the 69src69.</span>",\
		"<span class=\"warning\">Everything suddenly goes silent.</span>")

	playsound(src, 'sound/effects/supermatter.ogg', 50, 1)

	user.drop_from_inventory(W)
	Consume(W)


/turf/unsimulated/wall/supermatter/Bumped(atom/AM as69ob|obj)
	if(isliving(AM))
		AM.visible_message("<span class=\"warning\">\The 69AM69 slams into \the 69src69 inducing a resonance... \his body starts to glow and catch flame before flashing into ash.</span>",\
		"<span class=\"danger\">You slam into \the 69src69 as your ears are filled with unearthly ringing. Your last thought is \"Oh, fuck.\"</span>",\
		"<span class=\"warning\">You hear an unearthly noise as a wave of heat washes over you.</span>")
	else
		AM.visible_message("<span class=\"warning\">\The 69AM69 smacks into \the 69src69 and rapidly flashes to ash.</span>",\
		"<span class=\"warning\">You hear a loud crack as you are washed with a wave of heat.</span>")

	playsound(src, 'sound/effects/supermatter.ogg', 50, 1)

	Consume(AM)


/turf/unsimulated/wall/supermatter/proc/Consume(var/mob/living/user)
	if(isobserver(user))
		return

	69del(user)
