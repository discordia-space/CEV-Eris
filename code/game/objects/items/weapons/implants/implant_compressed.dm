/obj/item/weapon/implant/compressed
	name = "compressed matter implant"
	desc = "Based on compressed matter technology, can store a single item."
	icon_state = "implant_evil"
	var/activation_emote = "sigh"
	var/obj/item/scanned = null
	legal = FALSE
	origin_tech = list(TECH_MATERIAL=2, TECH_MAGNET=4, TECH_BLUESPACE=5, TECH_ILLEGAL=4)

/obj/item/weapon/implant/compressed/trigger(emote, mob/source as mob)
	if (src.scanned == null)
		return 0

	if (emote == src.activation_emote)
		source << "The air glows as \the [src.scanned.name] uncompresses."
		activate()

/obj/item/weapon/implant/compressed/activate()
	var/turf/t = get_turf(src)
	if (imp_in)
		imp_in.put_in_hands(scanned)
	else
		scanned.loc = t
	qdel(src)

/obj/item/weapon/implant/compressed/install(mob/source as mob)
	..()
	src.activation_emote = input("Choose activation emote:") in list("blink", "blink_r", "eyebrow", "chuckle", "twitch_s", "frown", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink")
	if (source.mind)
		source.mind.store_memory("Compressed matter implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.", 0, 0)
	source << "The implanted compressed matter implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate."


/obj/item/weapon/implanter/compressed
	name = "implanter (C)"
	icon_state = "cimplanter1"
	implant_type =  /obj/item/weapon/implant/compressed

/obj/item/weapon/implanter/compressed/update()
	if (implant)
		var/obj/item/weapon/implant/compressed/c = implant
		if(!c.scanned)
			icon_state = "cimplanter1"
		else
			icon_state = "cimplanter2"
	else
		icon_state = "cimplanter0"
	return

/obj/item/weapon/implanter/compressed/attack(mob/M as mob, mob/user as mob)
	var/obj/item/weapon/implant/compressed/c = implant
	if (!c)	return
	if (c.scanned == null)
		user << "Please scan an object with the implanter first."
		return
	..()

/obj/item/weapon/implanter/compressed/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return
	if(istype(A,/obj/item) && implant)
		var/obj/item/weapon/implant/compressed/c = implant
		if (c.scanned)
			user << "<span class='warning'>Something is already scanned inside the implant!</span>"
			return
		c.scanned = A
		if(istype(A.loc,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = A.loc
			H.remove_from_mob(A)
		else if(istype(A.loc,/obj/item/weapon/storage))
			var/obj/item/weapon/storage/S = A.loc
			S.remove_from_storage(A)
		A.loc.contents.Remove(A)
		update()
