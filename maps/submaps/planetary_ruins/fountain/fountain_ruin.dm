/datum/map_template/ruin/exoplanet/fountain
	name = "Fountain of Youth"
	id = "planetsite_fountain"
	description = "The fountain of youth itself."
	suffix = "fountain/fountain_ruin.dmm"
	cost = 2
	template_flags = TEMPLATE_FLAG_NO_RUINS | TEMPLATE_FLAG_CLEAR_CONTENTS
	ruin_tags = RUIN_ALIEN

/obj/structure/healingfountain
	name = "healing fountain"
	desc = "A fountain containing the waters of life."
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "fountain-blue"
	anchored = TRUE
	density = TRUE
	var/time_between_uses = 1800
	var/last_process = 0

/obj/structure/healingfountain/update_icon()  // update_icon() but as a proc to be able to do a callback
	if(last_process + time_between_uses > world.time)
		icon_state = "fountain"
	else
		icon_state = "fountain-blue"

/obj/structure/healingfountain/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(last_process + time_between_uses > world.time)
		to_chat(user, "<span class='notice'>The fountain appears to be empty.</span>")
		return
	last_process = world.time
	to_chat(user, "<span class='notice'>The water feels warm and soothing as you touch it. The fountain immediately dries up shortly afterwards.</span>")

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.rejuvenate()  // human specific rejuvenate
	else
		user.rejuvenate()  // classic mob rejuvenate

	update_icon()
	spawn(time_between_uses+1)
		update_icon()
