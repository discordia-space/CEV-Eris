/mob/living/carbon/superior_animal/roach/proc/try_tame(var/mob/living/carbon/user, var/obj/item/reagent_containers/food/snacks/grown/thefood)
	if(!istype(thefood))
		return FALSE
	if(prob(40))
		visible_message("[src] hesitates for a moment...and then charges at [user]!")
		return TRUE //Setting this to true because the only current usage is attack, and it says it hesitates.
	//fruits and veggies are not there own type, they are all the grown type and contain certain reagents. This is why it didnt work before
	if(isnull(thefood.seed.chems["potato"]))
		return FALSE
	visible_message("[src] scuttles towards [user], examining the [thefood] they have in their hand.")
	canBuckle = TRUE
	var/datum/component/buckling/buckle = GetComponent(/datum/component/buckling)
	if(do_after(src, taming_window, src)) //Here's your window to climb onto it.
		if(!buckle.buckled)
			canBuckle = FALSE
			visible_message("[src] snaps out of its trance and rushes at [user]!")
			return FALSE
		visible_message("[src] bucks around wildly, trying to shake  [user] off!") //YEEEHAW
		if(prob(40))
			visible_message("[src] thrashes around and, throws [user] clean off!")
			user.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),30)
			buckle.unbuckle()
			canBuckle = FALSE
			return FALSE
		friends += user
		visible_message("[src] reluctantly stops thrashing around...")
		return TRUE
	visible_message("[src] snaps out of its trance and rushes at [user]!")
	return FALSE

/mob/living/carbon/superior_animal/roach/proc/onBuckledMoveTry(mob/trier, direction)
	SIGNAL_HANDLER
	. = COMSIG_CANCEL_MOVE
	if(trier.incapacitated(INCAPACITATION_CANT_ACT))
		return
	if(trier.next_click > world.time)
		return
	// roach is ded!!
	if(stat)
		return
	// No roach riding for you!
	if(!(locate("\ref[trier]") in friends))
		return
	trier.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	step(src, direction)
