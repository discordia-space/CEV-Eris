//Todo: add leather and cloth for arbitrary coloured stools.
var/global/list/stool_cache = list() //haha stool

/obj/item/stool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "stool_preview" //set for the69ap
	force = 10
	throwforce = 10
	w_class = ITEM_SIZE_HUGE
	var/base_icon = "stool_base"
	var/material/material
	var/material/padding_material

/obj/item/stool/padded
	icon_state = "stool_padded_preview" //set for the69ap

/obj/item/stool/New(var/newloc,69ar/new_material,69ar/new_padding_material)
	..(newloc)
	if(!new_material)
		new_material =69ATERIAL_STEEL
	material = get_material_by_name(new_material)
	if(new_padding_material)
		padding_material = get_material_by_name(new_padding_material)
	if(!istype(material))
		69del(src)
		return
	force = round(material.get_blunt_damage()*0.4)
	update_icon()

/obj/item/stool/padded/New(var/newloc,69ar/new_material)
	..(newloc,69ATERIAL_STEEL,69ATERIAL_CARPET)

/obj/item/stool/update_icon()
	// Prep icon.
	icon_state = ""
	cut_overlays()
	// Base icon.
	var/cache_key = "stool-69material.name69"
	if(isnull(stool_cache69cache_key69))
		var/image/I = image(icon, base_icon)
		I.color =69aterial.icon_colour
		stool_cache69cache_key69 = I
	overlays |= stool_cache69cache_key69
	// Padding overlay.
	if(padding_material)
		var/padding_cache_key = "stool-padding-69padding_material.name69"
		if(isnull(stool_cache69padding_cache_key69))
			var/image/I =  image(icon, "stool_padding")
			I.color = padding_material.icon_colour
			stool_cache69padding_cache_key69 = I
		overlays |= stool_cache69padding_cache_key69
	// Strings.
	if(padding_material)
		name = "69padding_material.display_name69 69initial(name)69" //this is not perfect but it will do for now.
		desc = "A padded stool. Apply butt. It's69ade of 69material.use_name69 and covered with 69padding_material.use_name69."
	else
		name = "69material.display_name69 69initial(name)69"
		desc = "A stool. Apply butt with care. It's69ade of 69material.use_name69."

/obj/item/stool/proc/add_padding(var/padding_type)
	padding_material = get_material_by_name(padding_type)
	update_icon()

/obj/item/stool/proc/remove_padding()
	if(padding_material)
		padding_material.place_sheet(get_turf(src))
		padding_material = null
	update_icon()

/obj/item/stool/attack(mob/M as69ob,69ob/user as69ob)
	if (prob(5) && isliving(M))
		user.visible_message(SPAN_DANGER("69user69 breaks 69src69 over 69M69's back!"))
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.do_attack_animation(M)

		user.remove_from_mob(src)
		dismantle()
		69del(src)
		var/mob/living/T =69
		T.Weaken(10)
		T.damage_through_armor(20, BRUTE, BP_CHEST, ARMOR_MELEE)
		return
	..()

/obj/item/stool/ex_act(severity)
	switch(severity)
		if(1)
			69del(src)
			return
		if(2)
			if (prob(50))
				69del(src)
				return
		if(3)
			if (prob(5))
				69del(src)
				return

/obj/item/stool/proc/dismantle()
	if(material)
		material.place_sheet(get_turf(src))
	if(padding_material)
		padding_material.place_sheet(get_turf(src))
	69del(src)

/obj/item/stool/attackby(obj/item/W,69ob/user)
	if(istool(W))
		if(W.use_tool(user, src, WORKTIME_NEAR_INSTANT, 69UALITY_BOLT_TURNING, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
			dismantle()
			69del(src)
		if(padding_material)
			if(W.use_tool(user, src, WORKTIME_NEAR_INSTANT, 69UALITY_CUTTING, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
				to_chat(user, "You remove the padding from \the 69src69.")
				remove_padding()
	else if(istype(W,/obj/item/stack))
		if(padding_material)
			to_chat(user, "\The 69src69 is already padded.")
			return
		var/obj/item/stack/C = W
		if(C.get_amount() < 1) // How??
			user.drop_from_inventory(C)
			69del(C)
			return
		var/padding_type //This is awful but it needs to be like this until tiles are given a69aterial69ar.
		if(istype(W,/obj/item/stack/tile/carpet))
			padding_type =69ATERIAL_CARPET
		else if(istype(W,/obj/item/stack/material))
			var/obj/item/stack/material/M = W
			if(M.material && (M.material.flags &69ATERIAL_PADDING))
				padding_type = "69M.material.name69"
		if(!padding_type)
			to_chat(user, "You cannot pad \the 69src69 with that.")
			return
		C.use(1)
		if(!istype(src.loc, /turf))
			user.drop_from_inventory(src)
			src.loc = get_turf(src)
		to_chat(user, "You add padding to \the 69src69.")
		add_padding(padding_type)
		return

	else if(istype(W, /obj/item/device/spy_bug))
		user.drop_item()
		W.loc = get_turf(src)

	else
		..()


//Custom stools
//You can't pad them with something and they craft separately
/obj/item/stool/custom
	icon_state = "stool_base"

/obj/item/stool/custom/attackby(obj/item/W as obj,69ob/user as69ob)
	if(istool(W))
		if(W.use_tool(user, src, WORKTIME_NEAR_INSTANT, 69UALITY_BOLT_TURNING, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
			dismantle()
			69del(src)
	else if(istype(W,/obj/item/stack))
		to_chat(user, "\The 69src69 can't be padded.")
		return
	else
		..()

/obj/item/stool/custom/update_icon()
	return


/obj/item/stool/custom/bar_special
	name = "bar stool"
	icon_state = "bar_stool"
