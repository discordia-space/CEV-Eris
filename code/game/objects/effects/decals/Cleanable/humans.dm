#define DRYING_TIME 5 * 60*10                        //for 1 unit of depth in puddle (amount var)

var/global/list/image/splatter_cache=list()

/obj/effect/decal/cleanable/blood
	name = "blood"
	var/dryname = "dried blood"
	desc = "It's thick and gooey. Perhaps it's the chef's cooking?"
	var/drydesc = "It's dry and crusty. Someone is not doing their job."
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	icon = 'icons/effects/blood.dmi'
	icon_state = "mfloor1"
	random_icon_states = list("mfloor1", "mfloor2", "mfloor3", "mfloor4", "mfloor5", "mfloor6", "mfloor7")
	var/base_icon = 'icons/effects/blood.dmi'
	var/list/viruses = list()
	blood_DNA = list()
	var/basecolor="#A10808" // Color when wet.
	var/list/datum/disease2/disease/virus2 = list()
	var/amount = 5
	var/drytime
	sanity_damage = 1

/obj/effect/decal/cleanable/blood/reveal_blood()
	if(!fluorescent)
		fluorescent = 1
		basecolor = COLOR_LUMINOL
		update_icon()

/obj/effect/decal/cleanable/blood/clean_blood()
	fluorescent = 0
	if(invisibility != 100)
		invisibility = 100
		amount = 0
		STOP_PROCESSING(SSobj, src)
	..(ignore=1)

/obj/effect/decal/cleanable/blood/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/decal/cleanable/blood/New()
	..()
	fall_to_floor()
	update_icon()


	if(istype(src, /obj/effect/decal/cleanable/blood/gibs))
		return
	if(src.type == /obj/effect/decal/cleanable/blood)
		if(src.loc && isturf(src.loc))
			for(var/obj/effect/decal/cleanable/blood/B in src.loc)
				if(B != src)
					if (B.blood_DNA)
						blood_DNA |= B.blood_DNA.Copy()
					qdel(B)
	drytime = world.time + DRYING_TIME * (amount+1)
	START_PROCESSING(SSobj, src)

/obj/effect/decal/cleanable/blood/Process()
	if(world.time > drytime)
		dry()

/obj/effect/decal/cleanable/blood/on_update_icon()
	if(basecolor == "rainbow") basecolor = get_random_colour(1)
	color = basecolor

/obj/effect/decal/cleanable/blood/Crossed(mob/living/carbon/human/perp)
	if (!istype(perp))
		return
	if(amount < 1)
		return

	var/obj/item/organ/external/l_leg = perp.get_organ(BP_L_LEG)
	var/obj/item/organ/external/r_leg = perp.get_organ(BP_R_LEG)
	var/hasfeet = 1
	if((!l_leg || l_leg.is_stump()) && (!r_leg || r_leg.is_stump()))
		hasfeet = 0
	if(perp.shoes && !perp.buckled)//Adding blood to shoes
		var/obj/item/clothing/shoes/S = perp.shoes
		if(istype(S))
			S.blood_color = basecolor
			S.track_blood = max(amount,S.track_blood)
			if(!S.blood_overlay)
				S.generate_blood_overlay()
			if(!S.blood_DNA)
				S.blood_DNA = list()
				S.blood_overlay.color = basecolor
				S.add_overlays(S.blood_overlay)
			if(S.blood_overlay && S.blood_overlay.color != basecolor)
				S.blood_overlay.color = basecolor
				S.cut_overlays()
				S.add_overlays(S.blood_overlay)
			S.blood_DNA |= blood_DNA.Copy()

	else if (hasfeet)//Or feet
		perp.feet_blood_color = basecolor
		perp.track_blood = max(amount,perp.track_blood)
		if(!perp.feet_blood_DNA)
			perp.feet_blood_DNA = list()
		perp.feet_blood_DNA |= blood_DNA.Copy()
	else if (perp.buckled && istype(perp.buckled, /obj/structure/bed/chair/wheelchair))
		var/obj/structure/bed/chair/wheelchair/W = perp.buckled
		W.bloodiness = 4

	perp.update_inv_shoes(1)
	amount--

/obj/effect/decal/cleanable/blood/proc/dry()
	name = dryname
	desc = drydesc
	color = adjust_brightness(color, -50)
	amount = 0
	STOP_PROCESSING(SSobj, src)

/obj/effect/decal/cleanable/blood/attack_hand(mob/living/carbon/human/user)
	..()
	if (amount && istype(user))
		add_fingerprint(user)
		if (user.gloves)
			return
		var/taken = rand(1,amount)
		amount -= taken
		to_chat(user, SPAN_NOTICE("You get some of \the [src] on your hands."))
		if (!user.blood_DNA)
			user.blood_DNA = list()
		user.blood_DNA |= blood_DNA.Copy()
		user.bloody_hands += taken
		user.hand_blood_color = basecolor
		user.update_inv_gloves(1)
		user.verbs += /mob/living/carbon/human/proc/bloody_doodle

/obj/effect/decal/cleanable/blood/splatter
    random_icon_states = list("mgibbl1", "mgibbl2", "mgibbl3", "mgibbl4", "mgibbl5")
    amount = 2

/obj/effect/decal/cleanable/blood/drip
	name = "drips of blood"
	desc = "It's red."
	gender = PLURAL
	icon = 'icons/effects/drip.dmi'
	icon_state = "1"
	random_icon_states = list("1","2","3","4","5")
	amount = 0
	var/list/drips = list()

/obj/effect/decal/cleanable/blood/drip/New()
	..()
	drips |= icon_state

/obj/effect/decal/cleanable/blood/writing
	icon_state = "tracks"
	desc = "It looks like a writing in blood."
	gender = NEUTER
	random_icon_states = list("writing1","writing2","writing3","writing4","writing5")
	amount = 0
	var/message

/obj/effect/decal/cleanable/blood/writing/New()
	..()
	if(random_icon_states.len)
		for(var/obj/effect/decal/cleanable/blood/writing/W in loc)
			random_icon_states.Remove(W.icon_state)
		icon_state = pick(random_icon_states)
	else
		icon_state = "writing1"

/obj/effect/decal/cleanable/blood/writing/examine(mob/user)
	..(user)
	to_chat(user, "It reads: <font color='[basecolor]'>\"[message]\"</font>")

/obj/effect/decal/cleanable/blood/gibs
	name = "gibs"
	desc = "They look bloody and gruesome."
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	layer = LOW_OBJ_LAYER
	icon = 'icons/effects/blood.dmi'
	icon_state = "gibbl5"
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6")
	var/fleshcolor = "#FFFFFF"

/obj/effect/decal/cleanable/blood/gibs/on_update_icon()

	var/image/giblets = new(base_icon, "[icon_state]_flesh", dir)
	if(!fleshcolor || fleshcolor == "rainbow")
		fleshcolor = get_random_colour(1)
	giblets.color = fleshcolor

	var/icon/blood = new(base_icon,"[icon_state]",dir)
	if(basecolor == "rainbow") basecolor = get_random_colour(1)
	blood.Blend(basecolor,ICON_MULTIPLY)

	icon = blood
	cut_overlays()
	add_overlays(giblets)

/obj/effect/decal/cleanable/blood/gibs/up
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibup1","gibup1","gibup1")

/obj/effect/decal/cleanable/blood/gibs/down
	random_icon_states = list("gib1", "gib2", "gib3", "gib4", "gib5", "gib6","gibdown1","gibdown1","gibdown1")

/obj/effect/decal/cleanable/blood/gibs/body
	random_icon_states = list("gibhead", "gibtorso")

/obj/effect/decal/cleanable/blood/gibs/limb
	random_icon_states = list("gibleg", "gibarm")

/obj/effect/decal/cleanable/blood/gibs/core
	random_icon_states = list("gibmid1", "gibmid2", "gibmid3")


/obj/effect/decal/cleanable/blood/gibs/proc/streak(var/list/directions)
	spawn (0)
		var/direction = pick(directions)
		for (var/i = 0, i < pick(1, 200; 2, 150; 3, 50; 4), i++)
			sleep(3)
			if (i > 0)
				var/obj/effect/decal/cleanable/blood/splatter/b = new(loc)
				b.basecolor = src.basecolor
				b.update_icon()

			if (step_to(src, get_step(src, direction), 0))
				break


/obj/effect/decal/cleanable/mucus
	name = "mucus"
	desc = "Disgusting mucus."
	gender = PLURAL
	density = FALSE
	anchored = TRUE
	icon = 'icons/effects/blood.dmi'
	icon_state = "mucus"
	random_icon_states = list("mucus")

	var/list/datum/disease2/disease/virus2 = list()
	var/dry=0 // Keeps the lag down

/obj/effect/decal/cleanable/mucus/New()
	spawn(DRYING_TIME * 2)
		dry=1

//This proc prevents blood on openspace tiles, by causing them to fall down until they hit the ground
/obj/effect/decal/cleanable/blood/proc/fall_to_floor()
	if (istype(loc, /turf/simulated/open))
		anchored = FALSE //Anchored things can't fall
		while (istype(loc, /turf/simulated/open))
			var/turf/simulated/open/T = loc
			T.fallThrough(src)

			//A failsafe. If falling through the floor somehow fails to send us anywhere new, we break out to avoid an infinite loop
			if (loc == T)
				break
	anchored = initial(anchored) //Reset it
