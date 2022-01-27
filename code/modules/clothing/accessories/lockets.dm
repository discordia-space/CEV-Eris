/obj/item/clothing/accessory/locket
	name = "silver locket"
	desc = "This oval shaped, argentium sterling silver locket hangs on an incredibly fine, refractive string, almost thin as hair and69icroweaved from links to a deceptive strength, of similar69aterial. The edges are engraved69ery delicately with an elegant curving design, but overall the69ain is unmarked and smooth to the touch, leaving room for either remaining as a stolid piece or future alterations. There is an obvious internal place for a picture or lock of some sort, but even behind that is a69ery thin compartment unhinged with the pinch of a thumb and forefinger."
	icon_state = "locket"
	item_state = "locket"
	slot_flags = 0
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_MASK | SLOT_ACCESSORY_BUFFER
	var/base_icon
	var/open
	var/obj/item/held //Item inside locket.

/obj/item/clothing/accessory/locket/attack_self(mob/user as69ob)
	if(!base_icon)
		base_icon = icon_state

	if(!("69base_icon69_open" in icon_states(icon)))
		to_chat(user, "\The 69src69 doesn't seem to open.")
		return

	open = !open
	to_chat(user, "You flip \the 69src69 69open?"open":"closed"69.")
	if(open)
		icon_state = "69base_icon69_open"
		if(held)
			to_chat(user, "\The 69held69 falls out!")
			held.loc = get_turf(user)
			src.held = null
	else
		icon_state = "69base_icon69"

/obj/item/clothing/accessory/locket/attackby(var/obj/item/O as obj,69ob/user as69ob)
	if(!open)
		to_chat(user, "You have to open it first.")
		return

	if(istype(O,/obj/item/paper) || istype(O, /obj/item/photo))
		if(held)
			to_chat(usr, "\The 69src69 already has something inside it.")
		else
			to_chat(usr, "You slip 69O69 into 69src69.")
			user.drop_item()
			O.loc = src
			src.held = O
		return
	..()
