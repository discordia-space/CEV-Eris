/****************************************************
			   DISMEMBERMENT
****************************************************/

//Handles dismemberment
/obj/item/organ/external/proc/droplimb(var/clean, var/disintegrate = DROPLIMB_EDGE, var/ignore_children = null)

	if(cannot_amputate || !owner)
		return

	switch(disintegrate)
		if(DROPLIMB_EDGE, DROPLIMB_EDGE_BURN)
			if(!clean)
				var/gore_sound = "[BP_IS_ROBOTIC(src) ? "tortured metal" : "ripping tendons and flesh"]"
				owner.visible_message(
					SPAN_DANGER("\The [owner]'s [src.name] flies off in an arc!"),\
					"<span class='moderate'><b>Your [src.name] goes flying off!</b></span>",\
					SPAN_DANGER("You hear a terrible sound of [gore_sound]."))
		if(DROPLIMB_BURN)
			var/gore = "[BP_IS_ROBOTIC(src) ? " of melting metal": " of burning flesh"]"
			owner.visible_message(
				SPAN_DANGER("\The [owner]'s [src.name] flashes away into ashes!"),\
				"<span class='moderate'><b>Your [src.name] flashes away into ashes!</b></span>",\
				SPAN_DANGER("You hear a crackling sound[gore]."))
		if(DROPLIMB_BLUNT)
			var/gore = BP_IS_ROBOTIC(src) ? " in shower of sparks": " in shower of gore"
			var/gore_sound = BP_IS_ROBOTIC(src) ? "rending sound of tortured metal" : "sickening splatter of gore"
			owner.visible_message(
				SPAN_DANGER("\The [owner]'s [src.name] explodes[gore]!"),\
				"<span class='moderate'><b>Your [src.name] explodes[gore]!</b></span>",\
				SPAN_DANGER("You hear the [gore_sound]."))

	var/mob/living/carbon/human/victim = owner //Keep a reference for post-removed().
	var/obj/item/organ/external/parent_organ = parent
	removed(null, ignore_children)
	victim.adjustHalLoss(30)

	if(parent_organ)
		var/datum/wound/lost_limb/W = new (src, disintegrate, clean)
		if(clean)
			if(!BP_IS_ROBOTIC(src))
				parent_organ.wounds |= W
				parent_organ.update_damages()
		else
			var/obj/item/organ/external/stump/stump = new (victim, 0, src)
			stump.wounds |= W
			victim.organs |= stump
			stump.update_damages()

	spawn(1)
		victim.updatehealth()
		victim.UpdateDamageIcon()
		victim.regenerate_icons()
		dir = 2

	switch(disintegrate)
		if(DROPLIMB_EDGE, DROPLIMB_EDGE_BURN) //TODO: IF head cut off, borer actions "stay" in body, camera will be on cut off head, will not be able to be detach. Too Bad!
			add_blood(victim)
			var/matrix/M = matrix()
			M.Turn(rand(180))
			src.transform = M
			if(!clean)
				// Throw limb around.
				if(src && istype(loc,/turf))
					throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),30)
				dir = 2
		if(DROPLIMB_BURN)
			new /obj/effect/decal/cleanable/ash(get_turf(victim))

			for(var/obj/item/organ/I in internal_organs)
				I.removed()
				I.forceMove(get_turf(src))

			for(var/obj/item/I in src)
				if(I.w_class > ITEM_SIZE_SMALL)
					I.forceMove(get_turf(src))
			qdel(src)
		if(DROPLIMB_BLUNT)
			var/obj/effect/decal/cleanable/blood/gibs/gore = new victim.species.single_gib_type(get_turf(victim))
			if(victim.species.flesh_color)
				gore.fleshcolor = victim.species.flesh_color
			if(victim.species.blood_color)
				gore.basecolor = victim.species.blood_color
			gore.update_icon()
			gore.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),30)

			for(var/obj/item/organ/I in internal_organs)
				I.removed()
				I.forceMove(get_turf(src))
				I.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),30)

			for(var/mob/living/I in src) // check for mobs inside you... yeah
				if(istype(I, /mob/living/simple_animal/borer/))
					var/mob/living/simple_animal/borer/B = I
					B.detach()
					B.leave_host()
					I.forceMove(get_turf(src))
					I.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),30)
			for(var/obj/item/I in src)
				if(I.w_class <= ITEM_SIZE_SMALL)
					qdel(I)
					continue
				I.forceMove(get_turf(src))
				I.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),30)

			qdel(src)
