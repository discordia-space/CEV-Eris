var/global/list/ashtray_cache = list()

/obj/item/material/ashtray
	name = "ashtray"
	icon = 'icons/obj/objects.dmi'
	icon_state = "blank"
	force_divisor = 0.1
	thrown_force_divisor = 0.1
	var/image/base_image
	var/max_butts = 10

/obj/item/material/ashtray/New(var/newloc,69ar/material_name)
	..(newloc,69aterial_name)
	if(!material)
		69del(src)
		return
	max_butts = round(material.hardness/10) //This is arbitrary but whatever.
	src.pixel_y = rand(-5, 5)
	src.pixel_x = rand(-6, 6)
	update_icon()
	return

/obj/item/material/ashtray/update_icon()
	color = null
	cut_overlays()
	var/cache_key = "base-69material.name69"
	if(!ashtray_cache69cache_key69)
		var/image/I = image('icons/obj/objects.dmi',"ashtray")
		I.color =69aterial.icon_colour
		ashtray_cache69cache_key69 = I
	overlays |= ashtray_cache69cache_key69

	if (contents.len ==69ax_butts)
		if(!ashtray_cache69"full"69)
			ashtray_cache69"full"69 = image('icons/obj/objects.dmi',"ashtray_full")
		overlays |= ashtray_cache69"full"69
		desc = "It's stuffed full."
	else if (contents.len >69ax_butts/2)
		if(!ashtray_cache69"half"69)
			ashtray_cache69"half"69 = image('icons/obj/objects.dmi',"ashtray_half")
		overlays |= ashtray_cache69"half"69
		desc = "It's half-filled."
	else
		desc = "An ashtray69ade of 69material.display_name69."

/obj/item/material/ashtray/attackby(obj/item/W as obj,69ob/user as69ob)
	if (health <= 0)
		return
	if (istype(W,/obj/item/trash/cigbutt) || istype(W,/obj/item/clothing/mask/smokable/cigarette) || istype(W, /obj/item/flame/match))
		if (contents.len >=69ax_butts)
			to_chat(user, "\The 69src69 is full.")
			return
		user.remove_from_mob(W)
		W.loc = src

		if (istype(W,/obj/item/clothing/mask/smokable/cigarette))
			var/obj/item/clothing/mask/smokable/cigarette/cig = W
			if (cig.lit == 1)
				src.visible_message("69user69 crushes 69cig69 in \the 69src69, putting it out.")
				STOP_PROCESSING(SSobj, cig)
				var/obj/item/butt = new cig.type_butt(src)
				cig.transfer_fingerprints_to(butt)
				69del(cig)
				W = butt
				//spawn(1)
				//	TemperatureAct(150)
			else if (cig.lit == 0)
				to_chat(user, "You place 69cig69 in 69src69 without even smoking it. Why would you do that?")

		src.visible_message("69user69 places 69W69 in 69src69.")
		add_fingerprint(user)
		update_icon()
	else
		health =69ax(0,health - W.force)
		to_chat(user, "You hit 69src69 with 69W69.")
		if (health < 1)
			shatter()
	return

/obj/item/material/ashtray/throw_impact(atom/hit_atom)
	if (health > 0)
		health =69ax(0,health - 3)
		if (contents.len)
			src.visible_message(SPAN_DANGER("\The 69src69 slams into 69hit_atom69, spilling its contents!"))
		for (var/obj/item/clothing/mask/smokable/cigarette/O in contents)
			O.loc = src.loc
		if (health < 1)
			shatter()
			return
		update_icon()
	return ..()
