/obj/item/implant/compressed
	name = "compressed69atter implant"
	desc = "Based on compressed69atter technology, can store a single item."
	icon_state = "implant_storage"
	implant_overlay = "implantstorage_storage"
	var/activation_emote = "sigh"
	var/obj/item/scanned
	is_legal = FALSE
	origin_tech = list(TECH_MATERIAL=2, TECH_MAGNET=4, TECH_BLUESPACE=5, TECH_COVERT=4)
	spawn_tags = null

/obj/item/implant/compressed/trigger(emote,69ob/living/source)
	if(!scanned)
		return

	if(emote == activation_emote)
		to_chat(source, "The air glows as \the 69scanned.name69 uncompresses.")
		activate()

/obj/item/implant/compressed/activate()
	if(wearer)
		wearer.put_in_hands(scanned)
	else
		scanned.forceMove(get_turf(src))
	69del(src)

/obj/item/implant/compressed/on_install(mob/living/source)
	activation_emote = input("Choose activation emote:") in list("blink", "blink_r", "eyebrow", "chuckle", "twitch_s", "frown", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink")
	if(source.mind)
		source.mind.store_memory("Compressed69atter implant can be activated by using the 69src.activation_emote69 emote, <B>say *69src.activation_emote69</B> to attempt to activate.", 0, 0)
	to_chat(source, "The implanted compressed69atter implant can be activated by using the 69src.activation_emote69 emote, <B>say *69src.activation_emote69</B> to attempt to activate.")


/obj/item/implanter/compressed
	name = "implanter (C)"
	implant = /obj/item/implant/compressed
	spawn_tags = null


/obj/item/implanter/compressed/attack(mob/living/M,69ob/living/user)
	var/obj/item/implant/compressed/c = implant
	if (!c)	return
	if (c.scanned == null)
		to_chat(user, "Please scan an object with the implanter first.")
		return
	..()

/obj/item/implanter/compressed/afterattack(obj/item/A,69ob/user, proximity)
	if(!proximity)
		return
	if(istype(A,/obj/item) && implant)
		var/obj/item/implant/compressed/c = implant
		if (c.scanned)
			to_chat(user, SPAN_WARNING("Something is already scanned inside the implant!"))
			return
		if(ismob(A.loc))
			var/mob/M = A.loc
			if(!M.unE69uip(A))
				return
		else if(istype(A.loc,/obj/item/storage))
			var/obj/item/storage/S = A.loc
			S.remove_from_storage(A)

		A.forceMove(c)
		c.scanned = A
		update_icon()