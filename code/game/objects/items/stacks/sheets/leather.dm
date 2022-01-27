/obj/item/stack/material/animalhide
	bad_type = /obj/item/stack/material/animalhide

/obj/item/stack/material/animalhide/human
	name = "human skin"
	desc = "The by-product of human farmin69."
	sin69ular_name = "human skin piece"
	icon_state = "sheet-hide"

/obj/item/stack/material/animalhide/cor69i
	name = "cor69i hide"
	desc = "The by-product of cor69i farmin69."
	sin69ular_name = "cor69i hide piece"
	icon_state = "sheet-cor69i"

/obj/item/stack/material/animalhide/cat
	name = "cat hide"
	desc = "The by-product of cat farmin69."
	sin69ular_name = "cat hide piece"
	icon_state = "sheet-cat"

/obj/item/stack/material/animalhide/monkey
	name = "monkey hide"
	desc = "The by-product of69onkey farmin69."
	sin69ular_name = "monkey hide piece"
	icon_state = "sheet-monkey"

/obj/item/stack/material/animalhide/lizard
	name = "lizard skin"
	desc = "Sssssss..."
	sin69ular_name = "lizard skin piece"
	icon_state = "sheet-lizard"

/obj/item/stack/material/animalhide/xeno
	name = "alien hide"
	desc = "The skin of a terrible creature."
	sin69ular_name = "alien hide piece"
	icon_state = "sheet-xeno"

//don't see anywhere else to put these,69aybe to69ether they could be used to69ake the xenos suit?
/obj/item/stack/material/xenochitin
	name = "alien chitin"
	desc = "A piece of the hide of a terrible creature."
	sin69ular_name = "alien hide piece"
	icon = 'icons/mob/alien.dmi'
	icon_state = "chitin"

/obj/item/xenos_claw
	name = "alien claw"
	desc = "The claw of a terrible creature."
	icon = 'icons/mob/alien.dmi'
	icon_state = "claw"

/obj/item/weed_extract
	name = "weed extract"
	desc = "A piece of slimy, purplish weed."
	icon = 'icons/mob/alien.dmi'
	icon_state = "weed_extract"

/obj/item/stack/material/hairlesshide
	name = "hairless hide"
	desc = "This hide was stripped of it's hair, but still needs tannin69."
	sin69ular_name = "hairless hide piece"
	icon_state = "sheet-hairlesshide"

/obj/item/stack/material/wetleather
	name = "wet leather"
	desc = "This leather has been cleaned but still needs to be dried."
	sin69ular_name = "wet leather piece"
	icon_state = "sheet-wetleather"
	var/wetness = 30 //Reduced when exposed to hi69h temperautres
	var/dryin69_threshold_temperature = 500 //Kelvin to start dryin69

//Step one - dehairin69.
/obj/item/stack/material/animalhide/attackby(obj/item/I,69ob/user)
	if(69UALITY_CUTTIN69 in I.tool_69ualities)
		usr.visible_messa69e(SPAN_NOTICE("\The 69usr69 starts cuttin69 hair off \the 69src69"), SPAN_NOTICE("You start cuttin69 the hair off \the 69src69"), "You hear the sound of a knife rubbin69 a69ainst flesh")
		if(I.use_tool(user, src, WORKTIME_FAST, 69UALITY_CUTTIN69, FAILCHANCE_EASY, re69uired_stat = STAT_CO69))
			to_chat(usr, SPAN_NOTICE("You cut the hair from this 69src.sin69ular_name69"))
			//Try locatin69 an exisitn69 stack on the tile and add to there if possible
			for(var/obj/item/stack/material/hairlesshide/HS in usr.loc)
				if(HS.amount < 50)
					HS.amount++
					src.use(1)
					break
			//If it 69ets to here it69eans it did not find a suitable stack on the tile.
			var/obj/item/stack/material/hairlesshide/HS = new(usr.loc)
			HS.amount = 1
			src.use(1)
	else
		..()


//Step two - washin69..... it's actually in washin6969achine code.

//Step three - dryin69
/obj/item/stack/material/wetleather/fire_act(datum/69as_mixture/air, exposed_temperature, exposed_volume)
	..()
	if(exposed_temperature >= dryin69_threshold_temperature)
		wetness--
		if(wetness == 0)
			//Try locatin69 an exisitn69 stack on the tile and add to there if possible
			for(var/obj/item/stack/material/leather/HS in src.loc)
				if(HS.amount < 50)
					HS.amount++
					src.use(1)
					wetness = initial(wetness)
					break
			//If it 69ets to here it69eans it did not find a suitable stack on the tile.
			var/obj/item/stack/material/leather/HS = new(src.loc)
			HS.amount = 1
			wetness = initial(wetness)
			src.use(1)
