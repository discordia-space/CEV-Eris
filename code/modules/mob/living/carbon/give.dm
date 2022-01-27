/mob/living/carbon/human/verb/give(var/mob/living/target in69iew(1)-usr)
	set category = "IC"
	set69ame = "Give"

	if(incapacitated())
		return
	if(!istype(target) || target.incapacitated() || target.client ==69ull)
		return

	var/obj/item/I = usr.get_active_hand()
	if(!I)
		I = usr.get_inactive_hand()
	if(!I)
		to_chat(usr, SPAN_WARNING("You don't have anything in your hands to give to \the 69target69."))
		return

	if(I.item_flags & ABSTRACT)//No giving people offhands.
		return

	if(alert(target,"69usr69 wants to give you \a 69I69. Will you accept it?",,"Yes","No") == "No")
		target.visible_message(SPAN_NOTICE("\The 69usr69 tried to hand \the 69I69 to \the 69target69, \
		but \the 69target69 didn't want it."))
		return

	if(!I) return

	if(!Adjacent(target))
		to_chat(usr, SPAN_WARNING("You69eed to stay in reaching distance while giving an object."))
		to_chat(target, SPAN_WARNING("\The 69usr6969oved too far away."))
		return

	if(I.loc != usr || (usr.l_hand != I && usr.r_hand != I))
		to_chat(usr, SPAN_WARNING("You69eed to keep the item in your hands."))
		to_chat(target, SPAN_WARNING("\The 69usr69 seems to have given up on passing \the 69I69 to you."))
		return

	if(target.r_hand !=69ull && target.l_hand !=69ull)
		to_chat(target, SPAN_WARNING("Your hands are full."))
		to_chat(usr, SPAN_WARNING("Their hands are full."))
		return

	if(usr.unEquip(I))
		target.put_in_hands(I) // If this fails it will just end up on the floor, but that's fitting for things like dionaea.
		target.visible_message(SPAN_NOTICE("\The 69usr69 handed \the 69I69 to \the 69target69."))
