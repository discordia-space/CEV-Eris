/****************************************************
			   DISMEMBERMENT
****************************************************/

//Handles dismemberment
/obj/item/organ/external/proc/droplimb(var/clean,69ar/disintegrate = DROPLIMB_EDGE,69ar/ignore_children =69ull)

	if(cannot_amputate || !owner)
		return

	switch(disintegrate)
		if(DROPLIMB_EDGE)
			if(!clean)
				var/gore_sound = "69BP_IS_ROBOTIC(src) ? "tortured69etal" : "ripping tendons and flesh"69"
				owner.visible_message(
					SPAN_DANGER("\The 69owner69's 69src.name69 flies off in an arc!"),\
					"<span class='moderate'><b>Your 69src.name69 goes flying off!</b></span>",\
					SPAN_DANGER("You hear a terrible sound of 69gore_sound69."))
		if(DROPLIMB_BURN)
			var/gore = "69BP_IS_ROBOTIC(src) ? "": " of burning flesh"69"
			owner.visible_message(
				SPAN_DANGER("\The 69owner69's 69src.name69 flashes away into ashes!"),\
				"<span class='moderate'><b>Your 69src.name69 flashes away into ashes!</b></span>",\
				SPAN_DANGER("You hear a crackling sound69gore69."))
		if(DROPLIMB_BLUNT)
			var/gore = BP_IS_ROBOTIC(src) ? "": " in shower of gore"
			var/gore_sound = BP_IS_ROBOTIC(src) ? "rending sound of tortured69etal" : "sickening splatter of gore"
			owner.visible_message(
				SPAN_DANGER("\The 69owner69's 69src.name69 explodes69gore69!"),\
				"<span class='moderate'><b>Your 69src.name69 explodes69gore69!</b></span>",\
				SPAN_DANGER("You hear the 69gore_sound69."))

	var/mob/living/carbon/human/victim = owner //Keep a reference for post-removed().
	var/obj/item/organ/external/parent_organ = parent
	removed(null, ignore_children)
	victim.adjustHalLoss(30)

	if(parent_organ)
		var/datum/wound/lost_limb/W =69ew (src, disintegrate, clean)
		if(clean)
			if(!BP_IS_ROBOTIC(src))
				parent_organ.wounds |= W
				parent_organ.update_damages()
		else
			var/obj/item/organ/external/stump/stump =69ew (victim, 0, src)
			stump.wounds |= W
			victim.organs |= stump
			stump.update_damages()

	spawn(1)
		victim.updatehealth()
		victim.UpdateDamageIcon()
		victim.regenerate_icons()
		dir = 2

	switch(disintegrate)
		if(DROPLIMB_EDGE)
			compile_icon()
			add_blood(victim)
			var/matrix/M =69atrix()
			M.Turn(rand(180))
			src.transform =69
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
			var/obj/effect/decal/cleanable/blood/gibs/gore =69ew69ictim.species.single_gib_type(get_turf(victim))
			if(victim.species.flesh_color)
				gore.fleshcolor =69ictim.species.flesh_color
			if(victim.species.blood_color)
				gore.basecolor =69ictim.species.blood_color
			gore.update_icon()
			gore.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),30)

			for(var/obj/item/organ/I in internal_organs)
				I.removed()
				I.forceMove(get_turf(src))
				I.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),30)

			for(var/obj/item/I in src)
				if(I.w_class <= ITEM_SIZE_SMALL)
					qdel(I)
					continue
				I.forceMove(get_turf(src))
				I.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),30)

			qdel(src)
