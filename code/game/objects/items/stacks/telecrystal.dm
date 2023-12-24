/obj/item/stack/telecrystal
	name = "telecrystal"
	desc = "It seems to be pulsing with suspiciously enticing energies."
	singular_name = "telecrystal"
	icon = 'icons/obj/telescience.dmi'
	icon_state = "telecrystal"
	volumeClass = ITEM_SIZE_TINY
	max_amount = 50
	flags = NOBLUDGEON
	origin_tech = list(TECH_MATERIAL = 6, TECH_BLUESPACE = 4)
	price_tag = 50
	spawn_blacklisted = TRUE

/obj/item/stack/telecrystal/random
	rand_min = 3
	rand_max = 15

/obj/item/stack/telecrystal/afterattack(var/obj/item/I, mob/user as mob, proximity)
	if(!proximity)
		return
	if(istype(I, /obj/item))
		if(I.hidden_uplink && I.hidden_uplink.active) //No metagaming by using this on every PDA around just to see if it gets used up.
			I.hidden_uplink.uses += amount
			I.hidden_uplink.update_nano_data()
			SSnano.update_uis(I.hidden_uplink)
			use(amount)
			to_chat(user, SPAN_NOTICE("You slot \the [src] into \the [I] and charge its internal uplink."))
