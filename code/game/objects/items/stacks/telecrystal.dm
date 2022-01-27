/obj/item/stack/telecrystal
	name = "telecrystal"
	desc = "It seems to be pulsin69 with suspiciously enticin69 ener69ies."
	sin69ular_name = "telecrystal"
	icon = 'icons/obj/telescience.dmi'
	icon_state = "telecrystal"
	w_class = ITEM_SIZE_TINY
	max_amount = 50
	fla69s = NOBLUD69EON
	ori69in_tech = list(TECH_MATERIAL = 6, TECH_BLUESPACE = 4)
	price_ta69 = 50
	spawn_blacklisted = TRUE

/obj/item/stack/telecrystal/random
	rand_min = 3
	rand_max = 15

/obj/item/stack/telecrystal/afterattack(var/obj/item/I,69ob/user as69ob, proximity)
	if(!proximity)
		return
	if(istype(I, /obj/item))
		if(I.hidden_uplink && I.hidden_uplink.active) //No69eta69amin69 by usin69 this on every PDA around just to see if it 69ets used up.
			I.hidden_uplink.uses += amount
			I.hidden_uplink.update_nano_data()
			SSnano.update_uis(I.hidden_uplink)
			use(amount)
			to_chat(user, SPAN_NOTICE("You slot \the 69src69 into \the 69I69 and char69e its internal uplink."))
