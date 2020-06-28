/mob/living/carbon/human/gib(max_range=3, keep_only_robotics=FALSE)

	var/on_turf = istype(loc, /turf)

	for(var/obj/item/organ/I in internal_organs)
		if (!(keep_only_robotics && !(I.nature == MODIFICATION_SILICON)))
			I.removed()
			if(on_turf)
				I.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,max_range),30)

	for(var/obj/item/organ/external/E in src.organs)
		if (!(keep_only_robotics && !(E.nature == MODIFICATION_SILICON)))
			E.droplimb(TRUE, DROPLIMB_EDGE, 1)
			if(on_turf)
				E.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,max_range),30)

	sleep(1)

	for(var/obj/item/D in src)
		if (keep_only_robotics && istype(D, /obj/item/organ))
			continue
		else
			drop_from_inventory(D)
			D.throw_at(get_edge_target_turf(src,pick(alldirs)), rand(1,max_range), round(30/D.w_class))

	..(species.gibbed_anim)
	gibs(loc, dna, null, species.flesh_color, species.blood_color)

/mob/living/carbon/human/dust()
	if(species)
		..(species.dusted_anim, species.remains_type)
	else
		..()

/mob/living/carbon/human/death(gibbed)
	if(stat == DEAD) return

	BITSET(hud_updateflag, HEALTH_HUD)
	BITSET(hud_updateflag, STATUS_HUD)
	BITSET(hud_updateflag, LIFE_HUD)

	//Handle species-specific deaths.
	species.handle_death(src)

	//Handle brain slugs.
	var/obj/item/organ/external/head = get_organ(BP_HEAD)
	var/mob/living/simple_animal/borer/B

	if(head)
		for(var/I in head.implants)
			if(istype(I,/mob/living/simple_animal/borer))
				B = I
		if(B)
			if(!B.ckey && ckey && B.controlling)
				B.ckey = ckey
				B.controlling = 0
			if(B.host_brain.ckey)
				ckey = B.host_brain.ckey
				B.host_brain.ckey = null
				B.host_brain.name = "host brain"
				B.host_brain.real_name = "host brain"
			verbs -= /mob/living/carbon/proc/release_control

	callHook("death", list(src, gibbed))

	if(wearing_rig)
		wearing_rig.notify_ai(
			SPAN_DANGER("Warning: user death event. Mobility control passed to integrated intelligence system.")
		)
	var/message = species.death_message
	if(stats.getPerk(PERK_TERRIBLE_FATE))
		message = "their inert body emits a strange sensation and a cold invades your body. Their screams before dying recount in your mind."
	. = ..(gibbed,message)
	if(!gibbed)
		dizziness = 0
		jitteriness = 0
		handle_organs()
		dead_HUD()
		if(species.death_sound)
			mob_playsound(loc, species.death_sound, 80, 1, 1)
	handle_hud_list()


/mob/living/carbon/human/proc/ChangeToHusk()
	if(HUSK in mutations)	return

	if(f_style)
		f_style = "Shaved"	//we only change the icon_state of the hair datum, so it doesn't mess up their UI/UE
	if(h_style)
		h_style = "Bald"
	update_hair(0)

	mutations.Add(HUSK)
	status_flags |= DISFIGURED	//makes them unknown without fucking up other stuff like admintools
	update_body(1)
	return

/mob/living/carbon/human/proc/Drain()
	ChangeToHusk()
	mutations |= HUSK
	return

/mob/living/carbon/human/proc/ChangeToSkeleton()
	if(SKELETON in src.mutations)	return

	if(f_style)
		f_style = "Shaved"
	if(h_style)
		h_style = "Bald"
	update_hair(0)

	mutations.Add(SKELETON)
	status_flags |= DISFIGURED
	update_body(0)
	return
