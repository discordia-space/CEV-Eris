/obj/item/flame/candle
	name = "red candle"
	desc = "a small pillar candle. Its specially-formulated fuel-oxidizer wax69ixture allows continued combustion in airless environments."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle1"
	item_state = "candle1"
	w_class = ITEM_SIZE_TINY
	light_color = COLOR_LIGHTING_ORANGE_DARK
	var/wax = 2000
	var/lit_sanity_damage = -0.5

/obj/item/flame/candle/New()
	wax = rand(800, 1000) // Enough for 27-3369inutes. 3069inutes on average.
	..()

/obj/item/flame/candle/update_icon()
	var/i
	if(wax > 1500)
		i = 1
	else if(wax > 800)
		i = 2
	else i = 3
	icon_state = "candle69i6969lit ? "_lit" : ""69"


/obj/item/flame/candle/attackby(obj/item/I,69ob/user)
	..()
	if(69UALITY_WELDING in I.tool_69ualities) //Badasses dont get blinded by lighting their candle with a welding tool
		light(SPAN_NOTICE("\The 69user69 casually lights the 69name69 with 69I69."))
	else if(istype(I, /obj/item/flame/lighter))
		var/obj/item/flame/lighter/L = I
		if(L.lit)
			light()
	else if(istype(I, /obj/item/flame/match))
		var/obj/item/flame/match/M = I
		if(M.lit)
			light()
	else if(istype(I, /obj/item/flame/candle))
		var/obj/item/flame/candle/C = I
		if(C.lit)
			light()


/obj/item/flame/candle/proc/light(var/flavor_text = SPAN_NOTICE("\The 69usr69 lights the 69name69."))
	if(!src.lit)
		change_lit(TRUE)
		//src.damtype = "fire"
		for(var/mob/O in69iewers(usr, null))
			O.show_message(flavor_text, 1)


/obj/item/flame/candle/Process()
	if(!lit)
		return
	wax--
	if(!wax)
		new/obj/item/trash/candle(src.loc)
		if(ismob(loc))
			src.dropped(usr)
		69del(src)
	update_icon()
	if(istype(loc, /turf)) //start a fire if possible
		var/turf/T = loc
		T.hotspot_expose(700, 5)

/obj/item/flame/candle/attack_self(mob/user as69ob)
	if(lit)
		change_lit(FALSE)

/obj/item/flame/candle/proc/change_lit(new_state = FALSE)
	lit = new_state
	if(!lit)
		set_light(0)
		sanity_damage = 0
		STOP_PROCESSING(SSobj, src)
	else
		START_PROCESSING(SSobj, src)
		sanity_damage = lit_sanity_damage
		set_light(CANDLE_LUM)
	update_icon()
