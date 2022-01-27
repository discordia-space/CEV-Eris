//Corgi
/mob/living/simple_animal/corgi
	name = "\improper corgi"
	real_name = "corgi"
	desc = "A corgi."
	icon_state = "corgi"
	item_state = "corgi"
	speak_emote = list("barks", "woofs")
	emote_see = list("shakes its head", "shivers")
	speak_chance = 1
	turns_per_move = 10
	meat_type = /obj/item/reagent_containers/food/snacks/meat/corgi
	meat_amount = 3
	response_help  = "pets"
	response_disarm = "bops"
	response_harm   = "kicks"
	see_in_dark = 5
	mob_size =69OB_SMALL
	max_nutrition = 250//Dogs are insatiable eating69onsters. This scales with their69ob size too
	stomach_size_mult = 30
	seek_speed = 6
	possession_candidate = 1
	holder_type = /obj/item/holder/corgi
	var/obj/item/inventory_head
	var/obj/item/inventory_back

/mob/living/simple_animal/corgi/New()
	..()
	nutrition =69ax_nutrition * 0.3//Ian doesn't start with a full belly so will be hungry at roundstart

//IAN! SQUEEEEEEEEE~
/mob/living/simple_animal/corgi/Ian
	name = "Ian"
	real_name = "Ian"	//Intended to hold the69ame without altering it.
	gender =69ALE
	desc = "A corgi."
	response_help  = "pets"
	response_disarm = "bops"
	response_harm   = "kicks"
	spawn_frequency = 0//unique

/mob/living/simple_animal/corgi/Life()
	..()

	if(!stat && !resting && !buckled)
		if(prob(1))
			var/msg2 = (pick("dances around","chases their tail"))
			src.visible_message("<span class='name'>69src69</span> 69msg269.")
			spawn(0)
				for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2,1,2,4,8,4,2))
					set_dir(i)
					sleep(1)

/mob/living/simple_animal/corgi/beg(atom/thing, atom/holder)
	visible_emote("stares at the 69thing69 that 69holder69 has with sad puppy eyes.")

/obj/item/reagent_containers/food/snacks/meat/corgi
	name = "Corgi69eat"
	desc = "Tastes like... well you know..."
	spawn_blacklisted = TRUE//antag_item_targets

/mob/living/simple_animal/corgi/attackby(obj/item/O,69ob/user)  //Marker -Agouri
	if(istype(O, /obj/item/newspaper))
		if(!stat)
			visible_message(SPAN_NOTICE("69user69 baps 69name69 on the69ose with the rolled up 69O.name69."))
			scan_interval =69ax_scan_interval//discipline your dog to69ake it stop stealing food for a while
			movement_target =69ull
			foodtarget = 0
			stop_automated_movement = 0
			turns_since_scan = 0
			spawn(0)
				for(var/i in list(1,2,4,8,4,2,1,2))
					set_dir(i)
					sleep(1)
	else
		..()

/mob/living/simple_animal/corgi/regenerate_icons()
	overlays = list()

	if(inventory_head)
		var/head_icon_state = inventory_head.icon_state
		if(health <= 0)
			head_icon_state += "2"

		var/icon/head_icon = image('icons/mob/corgi_head.dmi',head_icon_state)
		if(head_icon)
			overlays += head_icon

	if(inventory_back)
		var/back_icon_state = inventory_back.icon_state
		if(health <= 0)
			back_icon_state += "2"

		var/icon/back_icon = image('icons/mob/corgi_back.dmi',back_icon_state)
		if(back_icon)
			overlays += back_icon
	return


/mob/living/simple_animal/corgi/puppy
	name = "\improper corgi puppy"
	real_name = "corgi"
	desc = "A corgi puppy."
	icon_state = "puppy"

//pupplies cannot wear anything.
/mob/living/simple_animal/corgi/puppy/Topic(href, href_list)
	if(href_list69"remove_inv"69 || href_list69"add_inv"69)
		to_chat(usr, "\red You can't fit this on 69src69")
		return
	..()


//LISA! SQUEEEEEEEEE~
/mob/living/simple_animal/corgi/Lisa
	name = "Lisa"
	real_name = "Lisa"
	gender = FEMALE
	desc = "A corgi with a cute pink bow."
	icon_state = "lisa"
	response_help  = "pets"
	response_disarm = "bops"
	response_harm   = "kicks"
	var/puppies = 0

//Lisa already has a cute bow!
/mob/living/simple_animal/corgi/Lisa/Topic(href, href_list)
	if(href_list69"remove_inv"69 || href_list69"add_inv"69)
		to_chat(usr, "\red 69src69 already has a cute bow!")
		return
	..()

/mob/living/simple_animal/corgi/Lisa/Life()
	..()

	if(!stat && !resting && !buckled)
		turns_since_scan++
		if(turns_since_scan > 15)
			turns_since_scan = 0
			var/alone = 1
			var/ian = 0
			for(var/mob/M in oviewers(7, src))
				if(istype(M, /mob/living/simple_animal/corgi/Ian))
					if(M.client)
						alone = 0
						break
					else
						ian =69
				else
					alone = 0
					break
			if(alone && ian && puppies < 4)
				if(near_camera(src) ||69ear_camera(ian))
					return
				new /mob/living/simple_animal/corgi/puppy(loc)


		if(prob(1))
			var/msg3 = (pick("dances around","chases her tail"))
			src.visible_message("<span class='name'>69src69</span> 69msg369.")
			spawn(0)
				for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2,1,2,4,8,4,2))
					set_dir(i)
					sleep(1)
