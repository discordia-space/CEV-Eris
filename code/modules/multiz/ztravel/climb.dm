/*********************************************************
	Generic climbing, without using any special equipment

	Requires a nearby wall which runs both zlevels
**********************************************************/
/datum/vertical_travel_method/climb
	var/turf/wall/surface = null
	start_verb_visible = "%m starts climbing %d the %s"
	start_verb_personal = "You start climbing %d the %s"
	base_time = 110
	var/soundfile = "climb"
	var/sound_interval = 20
	slip_chance = 35 //Risky without something to hold you to the wall

/datum/vertical_travel_method/climb/can_perform(var/mob/living/L, var/dir)
	.=..()
	if (.)
		if (isrobot(M))
			to_chat(M, SPAN_NOTICE("You're a robot, you can't climb.")) //Robots can't climb
			return FALSE
		else if (istype(M, /mob/living/exosuit))
			to_chat(M, SPAN_NOTICE("Mecha can not climb, yet."))
			return FALSE //Mechas can't climb, for now.
			//Todo future: add some kind of var or function to allow certain mechs to climb

		if (gravity)
			/*
				Climbing under gravity not yet implemented. would need special powers or augments
			*/
			to_chat(M, SPAN_NOTICE("Gravity is keeping you down, you can't climb like this."))
			return FALSE



		//Climbing in 0G requires a continuous wall to ascend or descend
		var/turf/wall/W = null

		//Lets examine the walls around us
		for (var/d in cardinal)
			var/turf/wall/WA = get_step(origin, d)
			if (istype(WA))
				//We've found a wall, now lets look at the destination floor
				var/turf/wall/WB = get_step(destination, d)
				if (istype(WB))
					//We've successfully located a smooth wall that spans both floors, we can climb it
					W = WA
					break
		if (W)
			surface = W
			subject = W //Subject is used for the visible messages
			.=TRUE
		else
			return FALSE



/datum/vertical_travel_method/climb/start_animation()
	.=..()
	M.face_atom(surface)
	M.offset_to(surface, 8)
	spawn(1)
	travelsound = new /datum/repeating_sound(15,duration,0.25, M, soundfile, 80, 1)
	if (direction == DOWN)
		var/matrix/mat = matrix()
		mat.Scale(0.9)
		M.set_plane(FLOOR_PLANE)
		M.layer = 1
		animate(M, alpha = 100, pixel_y = -16, transform = mat,  time = duration*1.2, easing = LINEAR_EASING, flags = ANIMATION_END_NOW)
	else
		animate(M, alpha = 0, pixel_y = 64, time = duration*1.2, easing = LINEAR_EASING, flags = ANIMATION_END_NOW)


//Subset of climbing using magboots. Slightly faster and much safer
/datum/vertical_travel_method/climb/mag
	start_verb_visible = "%m braces their magboots against the %s and starts walking %dwards"
	start_verb_personal = "You brace your magboots against the %s and starts walking %dwards"
	base_time = 80
	sound_interval = 9
	slip_chance = 0 //Utterly safe, magboots glue you to a wall
	soundfile = "catwalk"
	var/atom/magboots //The boots you're using




/datum/vertical_travel_method/climb/mag/can_perform(var/dir)
	.=..()
	if(.)
		if (!ishuman(M))
			return FALSE
		var/mob/living/carbon/human/H = M
		if (H.check_shoegrip()) //This checks for magboots
			return TRUE

		else
			//If we get here, they are going to fail. But maybe we can display a helpful error message
			//Maybe they're wearing magboots but they aren't turned on?
			if (istype(H.shoes, /obj/item/clothing/shoes/magboots))
				var/obj/item/clothing/shoes/magboots/MB = H.shoes
				if (!MB.magpulse)
					to_chat(M, SPAN_NOTICE("You could use your [MB] to walk up the [surface] if they were turned on."))
					return FALSE

			to_chat(M, SPAN_NOTICE("Your shoes don't have enough grip to climb up."))
			return FALSE


/datum/vertical_travel_method/climb/mag/start_animation()


	//Turn the player at an angle away from the wall
	var/matrix/mat = M.transform
	if (surface.x > M.x)
		mat.Turn(-20)
	if (surface.x < M.x)
		mat.Turn(20)
	M.transform = mat
	.=..()

	//When walking on a wall with magboots, you face the direction you're going
	//Thusly, when travelling downwards, we will face away from the wall instead of towards it
	if (direction == DOWN)
		M.face_atom(get_step(M,get_dir(surface, M)))
