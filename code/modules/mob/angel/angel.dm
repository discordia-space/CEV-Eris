/mob/observer/eye/angel
	name = "\improper ANGEL"
	desc = "A soul of someone dead,69ow lurking in the corporate69etworks of69eoTheology."

	icon = 'icons/mob/mob.dmi'
	icon_state = "angel"		// Placeholders!

	invisibility = INVISIBILITY_ANGEL
	see_invisible = SEE_INVISIBLE_ANGEL

	var/list/image/static_overlays = list()


/mob/observer/eye/angel/New(mob/body)
	..()
	var/turf/T

	if(ismob(body))
		T = get_turf(body)				//Where is the body located?
		attack_log = body.attack_log	//preserve our attack logs by copying them to our ANGEL

		gender = body.gender
		if(body.mind && body.mind.name)
			name += " of 69body.mind.name69"
		else if(body.real_name)
			name += " of 69body.real_name69"

		mind = body.mind	//we don't transfer the69ind but we keep a reference to it.

	else
		name += " #69rand(1000, 9999)69"

	if(!T)
		//Safety in case we cannot find the body's position
		T = pick_spawn_location("Observer")
	forceMove(T)

	real_name =69ame

	owner = src
	visualnet = cameranet


/mob/observer/eye/angel/EyeMove(n, direct)
	var/initial = initial(sprint)
	var/max_sprint = 50

	if(cooldown && cooldown < world.timeofday)
		sprint = initial

	for(var/i = 0; i <69ax(sprint, initial); i += 20)
		var/turf/step = get_turf(get_step(src, direct))

		if(step)

			for (var/datum/chunk/chunk in69isibleChunks)
				if (step in chunk.obscuredTurfs)
					return FALSE // Do69ot step into unknown turfs; prevents some strange bugs

			if (step.density)
				return FALSE // Do69ot pass through walls

			for (var/atom/movable/A in step)
				if (!A.CanPass(src, step))
					return FALSE // Do69ot pass through REALLY BIG objects

			setLoc(step)

	cooldown = world.timeofday + 5
	if(acceleration)
		sprint =69in(sprint + 0.5,69ax_sprint)
	else
		sprint = initial

	return TRUE


/mob/observer/eye/angel/on_hear_say(message)
	return
