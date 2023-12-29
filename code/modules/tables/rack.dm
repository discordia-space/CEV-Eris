/obj/structure/table/rack
	name = "rack"
	desc = "Different from the medieval version."
	icon = 'icons/obj/objects.dmi'
	icon_state = "rack"
	can_plate = 0
	can_reinforce = 0
	flipped = -1

/obj/structure/table/rack/New()
	..()
	verbs -= /obj/structure/table/verb/do_flip
	verbs -= /obj/structure/table/proc/do_put

/obj/structure/table/rack/update_connections()
	return

/obj/structure/table/rack/update_desc()
	return

/obj/structure/table/rack/update_icon()
	return

/obj/structure/table/rack/shelf
	name = "shelf"
	desc = "For showing off your collections of dust, electronics, the heads of your enemies and tools."
	icon_state = "shelf"

/obj/structure/table/rack/special
	name = "rack"
	desc = "Different from the medieval version. This one is fancier"
	icon = 'icons/obj/objects.dmi'
	icon_state = "rack"
	can_plate = 0
	can_reinforce = 0
	flipped = -1
	var/slotMax = 1
	var/maxItems = 10
	var/list/slotPos = list(
		list(-8,-8),
		list(0,-8),
		list(8,-8),
		list(-8,0),
		list(0,0),
		list(8,0),
		list(-8,8),
		list(0,8),
		list(8,8),
	)
	var/list/slotItems = list(
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null
	)

/obj/structure/table/rack/special/attackby(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I))
		user.drop_from_inventory(I)
		I.forceMove(src)
		var/matrix/mat = new()
		// halve items
		mat.Scale(0.5,0.5)
		I.transform = mat
		I.pixel_x = slotPos[slotMax][1]
		I.pixel_y = slotPos[slotMax][2]
		slotItems[slotMax++] = I
		vis_contents.Add(I)

/obj/structure/table/rack/special/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(slotMax > 1)
		var/obj/item/I = slotItems[slotMax-1]
		var/matrix/mat = new()
		I.transform = mat
		I.pixel_x = initial(I.pixel_x)
		I.pixel_y = initial(I.pixel_y)
		vis_contents.Remove(I)
		slotItems[slotMax--] = null
		I.forceMove(get_turf(src))
		user.put_in_active_hand(I)




