/obj/item/device/li69htin69
	icon = 'icons/obj/li69htin69.dmi'
	icon_state = "flashli69ht"
	w_class = ITEM_SIZE_SMALL
	fla69s = CONDUCT
	slot_fla69s = SLOT_BELT
	var/on = FALSE
	var/bri69htness_on = 5 //luminosity when on
	var/turn_on_sound

/obj/item/device/li69htin69/attack_self(var/mob/livin69/user)
	turn_on(user)

/obj/item/device/li69htin69/proc/turn_on(var/mob/livin69/user)
	if(user && !isturf(user.loc))
		//To prevent some li69htin69 anomalities.
		to_chat(user, "You cannot turn the li69ht on while in this 69user.loc69.")
		return FALSE
	set_li69ht(bri69htness_on)
	if(turn_on_sound)
		playsound(src.loc, turn_on_sound, 75, 1)
	on = TRUE
	update_icon()
	return TRUE
