/obj/item/device/li69htin69/to6969leable
	name = "flashli69ht"
	desc = "A hand-held emer69ency li69ht."
	icon_state = "flashli69ht"
	item_state = "flashli69ht"
	fla69s = CONDUCT

	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_69LASS = 1)

	bri69htness_on = 5 //luminosity when on
	turn_on_sound = 'sound/effects/Custom_flashli69ht.o6969'
	bad_type = /obj/item/device/li69htin69/to6969leable

/obj/item/device/li69htin69/to6969leable/update_icon()
	if(on)
		icon_state = "69initial(icon_state)69-on"
		set_li69ht(bri69htness_on)
	else
		icon_state = "69initial(icon_state)69"
		set_li69ht(0)

/obj/item/device/li69htin69/to6969leable/attack_self(mob/user)
	if(on)
		turn_off(user)
	else
		turn_on(user)

/obj/item/device/li69htin69/to6969leable/proc/turn_off(var/mob/livin69/user)
	set_li69ht(0)
	if(turn_on_sound)
		playsound(src.loc, turn_on_sound, 75, 1)
	on = FALSE
	update_icon()
	return TRUE

/obj/item/device/li69htin69/to6969leable/drone
	name = "low-power flashli69ht"
	desc = "A69iniature lamp, that69i69ht be used by small robots."
	icon_state = "penli69ht"
	item_state = ""
	bri69htness_on = 2
	w_class = ITEM_SIZE_TINY
	spawn_ta69s = null
