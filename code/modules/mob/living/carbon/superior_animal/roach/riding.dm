/mob/living/carbon/superior_animal/roach
	var/taming_window = 30 //How long you have to tame this roach, once it's pacified.

/mob/living/carbon/superior_animal/roach/Move()
	. = ..()
	if(buckled_mob)
		buckled_mob.dir = dir
		buckled_mob.forceMove(get_turf(src))
		buckled_mob.layer = 4.1

/mob/living/carbon/superior_animal/roach/unbuckle_mob()
	if(buckled_mob)
		buckled_mob.layer = MOB_LAYER
	. = ..()

/mob/living/carbon/superior_animal/roach/proc/try_tame(var/mob/living/carbon/user, var/obj/item/weapon/reagent_containers/food/snacks/grown/thefood)
	if(!istype(thefood))
		return FALSE
	if(thefood.reagents.has_reagent("sugar") || thefood.reagents.has_reagent("space_drugs") || thefood.reagents.has_reagent("vodka"))
		if(prob(40))
			visible_message("[src] hesitates for a moment...and then charges at [user]!")
			return FALSE //Sometimes roach just be like that
		visible_message("[src] scuttles towards [user], examining the [thefood] they have in their hand.")
		can_buckle = TRUE
		if(do_after(src, taming_window, src)) //Here's your window to climb onto it.
			if(!buckled_mob || user != buckled_mob) //They need to be riding us
				can_buckle = FALSE
				visible_message("[src] snaps out of its trance and rushes at [user]!")
				return FALSE
			visible_message("[src] bucks around wildly, trying to shake [user] off!") //YEEEHAW
			if(prob(40 + user.stats.getStat(STAT_VIG)))
				visible_message("[src] thrashes around and, throws [user] clean off!")
				user.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),30)
				unbuckle_mob()
				can_buckle = FALSE
				return FALSE
			visible_message("[src] chomps [thefood] and slurps it down whole!.")
			qdel(thefood)
			visible_message("[src] looks slightly stoned.")
			AddMovementHandler(/datum/movement_handler/move_relay_self)
			friends += user
			animate_movement = 3 //So the riding doesnt look all fucky
			pixel_y = 0
			pixel_x = 0
			return TRUE
		visible_message("[src] snaps out of its trance and rushes at [user]!")
		return FALSE
	else
		visible_message("[user] cluelessly holds their hand out, but [src] just looks pissed off!")
		return FALSE //Sometimes roach just be like that

/obj/structure/bed/chair/wheelchair/roach //This meme is too good to kill
	name = "Mobility roach"
	desc = "A pacified roach which stares at you with a hauntingly stoned expression, forced by those it once hunted into a thousand years eternal servitude for the captain of the CEV Eris."
	icon = 'icons/mob/animal.dmi'
	icon_state = "roach"
	animate_movement = 3 //So it doesnt just slide around skrt skrt

/obj/item/plantonastick
	name = "plant on a stick"
	desc = "A crude device which allows you to steer a roach."
	icon_state = "plantonastick"

/obj/item/plantonastick/afterattack(atom/target, mob/user, flag)
	. = ..()
	var/mob/living/carbon/superior_animal/roach/horse = locate(/mob/living/carbon/superior_animal/roach) in get_turf(user)
	if(horse && istype(horse) && user.buckled == horse)
		visible_message("<span class='notice'>[user] dangles [src] in front of [horse].</span>")
		visible_message("<span class = 'warning'>[horse] hungrily gnashes at [src].</span>")
		walk_to(horse, target, 1, horse.move_to_delay)
		if(prob(2)) //Really low chance, but prevents you from having free roach riding powers :)
			visible_message("<span class = 'warning'>[src] snaps at [src] and swallows it whole!</span>")
			qdel(src)

/obj/item/weapon/material/wirerod/attackby(obj/item/I, mob/user)
	. = ..()
	var/obj/item/weapon/reagent_containers/food/snacks/grown/thefood = I
	if(!istype(thefood))
		return FALSE
	if(thefood.reagents.has_reagent("sugar") || thefood.reagents.has_reagent("space_drugs") || thefood.reagents.has_reagent("vodka"))
		to_chat(user, "<span class='notice'>You start to wire [thefood] to the end of [src].</span>")
		if(do_after(user, 50))
			to_chat(user, "<span class='notice'>You finish adding some bait to [src].</span>")
			var/obj/item/plantonastick/roachbait = new(get_turf(user))
			roachbait.name = "[thefood] on a stick"
			qdel(thefood)
			qdel(src)