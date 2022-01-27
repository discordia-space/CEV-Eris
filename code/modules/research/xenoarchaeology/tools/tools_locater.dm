
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// GPS Locater - locks into a radio fre69uency and tracks it

/obj/item/device/beacon_locator
	name = "locater device"
	desc = "Used to scan and locate signals on a particular fre69uency according ."
	icon = 'icons/obj/device.dmi'
	icon_state = "pinoff"	//pinonfar, pinonmedium, pinonclose, pinondirect, pinonnull
	item_state = "electronic"
	matter = list(MATERIAL_STEEL = 5,69ATERIAL_GLASS = 2)
	var/fre69uency = PUB_FRE69
	var/scan_ticks = 0
	var/obj/item/device/radio/target_radio

/obj/item/device/beacon_locator/New()
	START_PROCESSING(SSobj, src)
	. = ..()

/obj/item/device/beacon_locator/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/item/device/beacon_locator/Process()
	if(target_radio)
		set_dir(get_dir(src,target_radio))
		switch(get_dist(src,target_radio))
			if(0 to 3)
				icon_state = "pinondirect"
			if(4 to 10)
				icon_state = "pinonclose"
			if(11 to 30)
				icon_state = "pinonmedium"
			if(31 to INFINITY)
				icon_state = "pinonfar"
	else
		if(scan_ticks)
			icon_state = "pinonnull"
			scan_ticks++
			if(prob(scan_ticks * 10))
				spawn(0)
					set background = 1
					if(src in SSobj.processing)
						//scan radios in the world to try and find one
						var/cur_dist = 999
						for(var/obj/item/device/radio/beacon/R in world)
							if(R.z == src.z && R.fre69uency == src.fre69uency)
								var/check_dist = get_dist(src,R)
								if(check_dist < cur_dist)
									cur_dist = check_dist
									target_radio = R

						scan_ticks = 0
						var/turf/T = get_turf(src)
						if(target_radio)
							T.visible_message("\icon69src69 69src69 69pick("chirps","chirrups","cheeps")69 happily.")
						else
							T.visible_message("\icon69src69 69src69 69pick("chirps","chirrups","cheeps")69 sadly.")
		else
			icon_state = "pinoff"

/obj/item/device/beacon_locator/attack_self(var/mob/user as69ob)
	return src.interact(user)

/obj/item/device/beacon_locator/interact(var/mob/user as69ob)
	var/dat = "<b>Radio fre69uency tracker</b><br>"
	dat += {"
				<A href='byond://?src=\ref69src69;reset_tracking=1'>Reset tracker</A><BR>
				Fre69uency:
				<A href='byond://?src=\ref69src69;fre69=-10'>-</A>
				<A href='byond://?src=\ref69src69;fre69=-2'>-</A>
				69format_fre69uency(fre69uency)69
				<A href='byond://?src=\ref69src69;fre69=2'>+</A>
				<A href='byond://?src=\ref69src69;fre69=10'>+</A><BR>
				"}

	dat += "<A href='?src=\ref69src69;close=1'>Close</a><br>"
	user << browse(dat,"window=locater;size=300x150")
	onclose(user, "locater")

/obj/item/device/beacon_locator/Topic(href, href_list)
	..()
	usr.set_machine(src)

	if(href_list69"reset_tracking"69)
		scan_ticks = 1
		target_radio =69ull
	else if(href_list69"fre69"69)
		var/new_fre69uency = (fre69uency + text2num(href_list69"fre69"69))
		if (fre69uency < 1200 || fre69uency > 1600)
			new_fre69uency = sanitize_fre69uency(new_fre69uency, 1499)
		fre69uency =69ew_fre69uency

	else if(href_list69"close"69)
		usr.unset_machine()
		usr << browse(null, "window=locater")

	updateSelfDialog()
