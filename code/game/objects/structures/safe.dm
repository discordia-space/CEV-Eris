/*
CONTAINS:
SAFES
FLOOR SAFES
*/

//SAFES
/obj/structure/safe
	name = "safe"
	desc = "A huge chunk of69etal with a dial embedded in it. Fine print on the dial reads \"Scarborough Arms - 2 tumbler safe, guaranteed thermite resistant, explosion resistant, and assistant resistant.\""
	icon = 'icons/obj/structures.dmi'
	icon_state = "safe"
	anchored = TRUE
	density = TRUE
	var/open = 0		//is the safe open?
	var/tumbler_1_pos	//the tumbler position- from 0 to 72
	var/tumbler_1_open	//the tumbler position to open at- 0 to 72
	var/tumbler_2_pos
	var/tumbler_2_open
	var/dial = 0		//where is the dial pointing?
	var/space = 0		//the combined w_class of everything in the safe
	var/maxspace = 24	//the69aximum combined w_class of stuff in the safe


/obj/structure/safe/New()
	tumbler_1_pos = rand(0, 72)
	tumbler_1_open = rand(0, 72)

	tumbler_2_pos = rand(0, 72)
	tumbler_2_open = rand(0, 72)


/obj/structure/safe/Initialize()
	. = ..()
	for(var/obj/item/I in loc)
		if(space >=69axspace)
			return
		if(I.w_class + space <=69axspace)
			space += I.w_class
			I.loc = src


/obj/structure/safe/proc/check_unlocked(mob/user as69ob, canhear)
	if(user && canhear)
		if(tumbler_1_pos == tumbler_1_open)
			to_chat(user, "<span class='notice'>You hear a 69pick("tonk", "krunk", "plunk")69 from 69src69.</span>")
		if(tumbler_2_pos == tumbler_2_open)
			to_chat(user, "<span class='notice'>You hear a 69pick("tink", "krink", "plink")69 from 69src69.</span>")
	if(tumbler_1_pos == tumbler_1_open && tumbler_2_pos == tumbler_2_open)
		if(user)69isible_message("<b>69pick("Spring", "Sprang", "Sproing", "Clunk", "Krunk")69!</b>")
		return 1
	return 0


/obj/structure/safe/proc/decrement(num)
	num -= 1
	if(num < 0)
		num = 71
	return num


/obj/structure/safe/proc/increment(num)
	num += 1
	if(num > 71)
		num = 0
	return num


/obj/structure/safe/update_icon()
	if(open)
		icon_state = "69initial(icon_state)69-open"
	else
		icon_state = initial(icon_state)


/obj/structure/safe/attack_hand(mob/user as69ob)
	user.set_machine(src)
	var/dat = "<center>"
	dat += "<a href='?src=\ref69src69;open=1'>69open ? "Close" : "Open"69 69src69</a> | <a href='?src=\ref69src69;decrement=1'>-</a> 69dial * 569 <a href='?src=\ref69src69;increment=1'>+</a>"
	if(open)
		dat += "<table>"
		for(var/i = contents.len, i>=1, i--)
			var/obj/item/P = contents69i69
			dat += "<tr><td><a href='?src=\ref69src69;retrieve=\ref69P69'>69P.name69</a></td></tr>"
		dat += "</table></center>"
	user << browse("<html><head><title>69name69</title></head><body>69dat69</body></html>", "window=safe;size=350x300")


/obj/structure/safe/Topic(href, href_list)
	if(!ishuman(usr))	return
	var/mob/living/carbon/human/user = usr

	var/canhear = 0
	if(istype(user.l_hand, /obj/item/clothing/accessory/stethoscope) || istype(user.r_hand, /obj/item/clothing/accessory/stethoscope))
		canhear = 1

	if(href_list69"open"69)
		if(check_unlocked())
			to_chat(user, "<span class='notice'>You 69open ? "close" : "open"69 69src69.</span>")
			open = !open
			update_icon()
			updateUsrDialog()
			return
		else
			to_chat(user, "<span class='notice'>You can't 69open ? "close" : "open"69 69src69, the lock is engaged!</span>")
			return

	if(href_list69"decrement"69)
		dial = decrement(dial)
		if(dial == tumbler_1_pos + 1 || dial == tumbler_1_pos - 71)
			tumbler_1_pos = decrement(tumbler_1_pos)
			if(canhear)
				to_chat(user, "<span class='notice'>You hear a 69pick("clack", "scrape", "clank")69 from 69src69.</span>")
			if(tumbler_1_pos == tumbler_2_pos + 37 || tumbler_1_pos == tumbler_2_pos - 35)
				tumbler_2_pos = decrement(tumbler_2_pos)
				if(canhear)
					to_chat(user, "<span class='notice'>You hear a 69pick("click", "chink", "clink")69 from 69src69.</span>")
			check_unlocked(user, canhear)
		updateUsrDialog()
		return

	if(href_list69"increment"69)
		dial = increment(dial)
		if(dial == tumbler_1_pos - 1 || dial == tumbler_1_pos + 71)
			tumbler_1_pos = increment(tumbler_1_pos)
			if(canhear)
				to_chat(user, "<span class='notice'>You hear a 69pick("clack", "scrape", "clank")69 from 69src69.</span>")
			if(tumbler_1_pos == tumbler_2_pos - 37 || tumbler_1_pos == tumbler_2_pos + 35)
				tumbler_2_pos = increment(tumbler_2_pos)
				if(canhear)
					to_chat(user, "<span class='notice'>You hear a 69pick("click", "chink", "clink")69 from 69src69.</span>")
			check_unlocked(user, canhear)
		updateUsrDialog()
		return

	if(href_list69"retrieve"69)
		user << browse("", "window=safe") // Close the69enu

		var/obj/item/P = locate(href_list69"retrieve"69) in src
		if(open)
			if(P && in_range(src, user))
				user.put_in_hands(P)
				updateUsrDialog()


/obj/structure/safe/attackby(obj/item/I as obj,69ob/user as69ob)
	if(open)
		if(I.w_class + space <=69axspace)
			if(user.unE69uip(I, src))
				space += I.w_class
				to_chat(user, SPAN_NOTICE("You put 69I69 in 69src69."))
				updateUsrDialog()
			return
		else
			to_chat(user, SPAN_NOTICE("69I69 won't fit in 69src69."))
			return
	else
		if(istype(I, /obj/item/clothing/accessory/stethoscope))
			to_chat(user, "Hold 69I69 in one of your hands while you69anipulate the dial.")
			return


obj/structure/safe/ex_act(severity)
	return

//FLOOR SAFES
/obj/structure/safe/floor
	name = "floor safe"
	icon_state = "floorsafe"
	density = FALSE
	level = 1	//underfloor
	layer = LOW_OBJ_LAYER

/obj/structure/safe/floor/Initialize()
	. = ..()
	var/turf/T = loc
	if(istype(T) && !T.is_plating())
		hide(1)
	update_icon()

/obj/structure/safe/floor/hide(var/intact)
	invisibility = intact ? 101 : 0

/obj/structure/safe/floor/hides_under_flooring()
	return 1
