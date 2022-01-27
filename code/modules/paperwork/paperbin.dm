/obj/item/paper_bin
	name = "paper bin"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "paper_bin1"
	item_state = "sheet-metal"
	throwforce = 1
	w_class = ITEM_SIZE_NORMAL
	throw_speed = 3
	throw_range = 7
	layer = OBJ_LAYER - 0.1
	var/amount = 30					//How69uch paper is in the bin.
	var/list/papers =69ew/list()	//List of papers put in the bin for reference.


/obj/item/paper_bin/MouseDrop(mob/user as69ob)
	if((user == usr && (!( usr.restrained() ) && (!( usr.stat ) && (usr.contents.Find(src) || in_range(src, usr))))))
		if(!isslime(usr) && !isanimal(usr))
			if( !usr.get_active_hand() )		//if active hand is empty
				var/mob/living/carbon/human/H = user
				var/obj/item/organ/external/temp = H.organs_by_name69BP_R_ARM69

				if (H.hand)
					temp = H.organs_by_name69BP_L_ARM69
				if(temp && !temp.is_usable())
					to_chat(user, SPAN_NOTICE("You try to69ove your 69temp.name69, but cannot!"))
					return

				to_chat(user, SPAN_NOTICE("You pick up the 69src69."))
				user.put_in_hands(src)

	return

/obj/item/paper_bin/attack_hand(mob/user as69ob)
	if (istype(loc, /turf))
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			var/obj/item/organ/external/temp = H.organs_by_name69BP_R_ARM69
			if (H.hand)
				temp = H.organs_by_name69BP_L_ARM69
			if(temp && !temp.is_usable())
				to_chat(user, SPAN_NOTICE("You try to69ove your 69temp.name69, but cannot!"))
				return
		var/response = ""
		if(!papers.len > 0)
			response = alert(user, "Do you take regular paper, or Carbon copy paper?", "Paper type request", "Regular", "Carbon-Copy", "Cancel")
			if (response != "Regular" && response != "Carbon-Copy")
				add_fingerprint(user)
				return
		if(amount >= 1)
			amount--
			if(amount==0)
				update_icon()

			var/obj/item/paper/P
			if(papers.len > 0)	//If there's any custom paper on the stack, use that instead of creating a69ew paper.
				P = papers69papers.len69
				papers.Remove(P)
			else
				if(response == "Regular")
					P =69ew /obj/item/paper
					if(Holiday == "April Fool's Day")
						if(prob(30))
							P.info = "<font face=\"69P.crayonfont69\" color=\"red\"><b>HONK HONK HONK HONK HONK HONK HONK<br>HOOOOOOOOOOOOOOOOOOOOOONK<br>APRIL FOOLS</b></font>"
							P.rigged = 1
							P.updateinfolinks()
				else if (response == "Carbon-Copy")
					P =69ew /obj/item/paper/carbon

			user.put_in_hands(P)
			to_chat(user, SPAN_NOTICE("You take 69P69 out of the 69src69."))
		else
			to_chat(user, SPAN_NOTICE("69src69 is empty!"))

		add_fingerprint(user)
		return
	.=..()

//Pickup paperbins with drag69 drop
obj/item/paper_bin/MouseDrop(over_object)
	if (usr == over_object && usr.Adjacent(src))
		if(pre_pickup(usr))
			pickup(usr)
			return TRUE
		return FALSE
	.=..()


/obj/item/paper_bin/attackby(obj/item/paper/i as obj,69ob/user as69ob)
	if(!istype(i))
		return

	user.drop_item()
	i.loc = src
	to_chat(user, SPAN_NOTICE("You put 69i69 in 69src69."))
	papers.Add(i)
	update_icon()
	amount++


/obj/item/paper_bin/examine(mob/user)
	. = ..()
	if(get_dist(src, user) <= 1)
		if (amount)
			to_chat(user, "<span class='notice'>There " + (amount > 1 ? "are 69amount69 papers" : "is one paper") + " in the bin.</span>")
		else
			to_chat(user, SPAN_NOTICE("There are69o papers in the bin."))
	else
		to_chat(user, SPAN_NOTICE("If you got closer you could see how69uch paper is in it."))
	return


/obj/item/paper_bin/update_icon()
	if (amount < 1)
		icon_state = "paper_bin0"
	else
		icon_state = "paper_bin1"
