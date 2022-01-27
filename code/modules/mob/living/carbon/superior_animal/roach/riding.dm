/mob/living/carbon/superior_animal/roach/Move()
	. = ..()
	if(buckled_mob)
		buckled_mob.dir = dir
		buckled_mob.forceMove(get_turf(src))
		buckled_mob.pixel_x = pixel_x

/mob/living/carbon/superior_animal/roach/proc/try_tame(var/mob/living/carbon/user,69ar/obj/item/reagent_containers/food/snacks/grown/thefood)
	if(!istype(thefood))
		return FALSE
	if(prob(40))
		visible_message("69src69 hesitates for a69oment...and then charges at 69user69!")
		return TRUE //Setting this to true because the only current usage is attack, and it says it hesitates.
	//fruits and69eggies are69ot there own type, they are all the grown type and contain certain reagents. This is why it didnt work before
	if(isnull(thefood.seed.chems69"potato"69))
		return FALSE
	visible_message("69src69 scuttles towards 69user69, examining the 69thefood69 they have in their hand.")
	can_buckle = TRUE
	if(do_after(src, taming_window, src)) //Here's your window to climb onto it.
		if(!buckled_mob || user != buckled_mob) //They69eed to be riding us
			can_buckle = FALSE
			visible_message("69src69 snaps out of its trance and rushes at 69user69!")
			return FALSE
		visible_message("69src69 bucks around wildly, trying to shake  69user69 off!") //YEEEHAW
		if(prob(40))
			visible_message("69src69 thrashes around and, throws 69user69 clean off!")
			user.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),30)
			unbuckle_mob()
			can_buckle = FALSE
			return FALSE
		friends += user
		visible_message("69src69 reluctantly stops thrashing around...")
		return TRUE
	visible_message("69src69 snaps out of its trance and rushes at 69user69!")
	return FALSE