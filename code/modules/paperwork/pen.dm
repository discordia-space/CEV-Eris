/* Pens!
 * Contains:
 *		Pens
 *		Sleepy Pens
 *		Parapens
 */


/*
 * Pens
 */
/obj/item/pen
	desc = "A69ormal black ink pen."
	name = "pen"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	item_state = "pen"
	slot_flags = SLOT_BELT | SLOT_EARS
	throwforce = 0
	w_class = ITEM_SIZE_TINY
	throw_speed = 7
	throw_range = 15
	matter = list(MATERIAL_STEEL = 1)
	spawn_tags = SPAWN_TAG_JUNK
	rarity_value = 6
	var/colour = "black"	//what colour the ink is!


/obj/item/pen/blue
	desc = "A69ormal blue ink pen."
	icon_state = "pen_blue"
	colour = "blue"

/obj/item/pen/red
	desc = "A69ormal red ink pen."
	icon_state = "pen_red"
	colour = "red"

/obj/item/pen/multi
	desc = "A pen with69ultiple colors of ink!"
	var/selectedColor = 1
	var/colors = list("black","blue","red")

/obj/item/pen/multi/attack_self(mob/user)
	if(++selectedColor > 3)
		selectedColor = 1

	colour = colors69selectedColor69

	if(colour == "black")
		icon_state = "pen"
	else
		icon_state = "pen_69colour69"

	to_chat(user, SPAN_NOTICE("Changed color to '69colour69.'"))

/obj/item/pen/invisible
	desc = "An invisble pen69arker."
	icon_state = "pen"
	colour = "white"


/obj/item/pen/attack(mob/M,69ob/user)
	if(!ismob(M))
		return
	to_chat(user, SPAN_WARNING("You stab 69M69 with the pen."))
//	M << "\red You feel a tiny prick!" //That's a whole lot of69eta!
	M.attack_log += text("\6969time_stamp()69\69 <font color='orange'>Has been stabbed with 69name69  by 69user.name69 (69user.ckey69)</font>")
	user.attack_log += text("\6969time_stamp()69\69 <font color='red'>Used the 69name69 to stab 69M.name69 (69M.ckey69)</font>")
	msg_admin_attack("69user.name69 (69user.ckey69) Used the 69name69 to stab 69M.name69 (69M.ckey69) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69user.x69;Y=69user.y69;Z=69user.z69'>JMP</a>)")
	return

/*
 * Reagent pens
 */

/obj/item/pen/reagent
	reagent_flags = REFILLABLE | DRAINABLE
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_MATERIAL = 2, TECH_COVERT = 5)
	spawn_blacklisted = TRUE

/obj/item/pen/reagent/New()
	..()
	create_reagents(30)

/obj/item/pen/reagent/attack(mob/living/M,69ob/user)

	if(!istype(M))
		return

	. = ..()

	if(M.can_inject(user,1))
		if(reagents.total_volume)
			if(M.reagents)
				var/contained_reagents = reagents.log_list()
				var/trans = reagents.trans_to_mob(M, 30, CHEM_BLOOD)
				admin_inject_log(user,69, src, contained_reagents, trans)

/*
 * Sleepy Pens
 */
/obj/item/pen/reagent/sleepy
	desc = "A black ink pen with a sharp point and \"Waffle Co.\" engraved on the side."
	origin_tech = list(TECH_MATERIAL = 2, TECH_COVERT = 5)

/obj/item/pen/reagent/sleepy/New()
	..()
	reagents.add_reagent("chloralhydrate", 22)	//Used to be 100 sleep toxin//30 Chloral seems to be fatal, reducing it to 22./N


/*
 * Parapens
 */
/obj/item/pen/reagent/paralysis
	origin_tech = "materials=2;syndicate=5"

/obj/item/pen/reagent/paralysis/New()
	..()
	reagents.add_reagent("zombiepowder", 10)
	reagents.add_reagent("cryptobiolin", 15)

/*
 * Chameleon pen
 */
/obj/item/pen/chameleon
	var/signature = ""
	spawn_blacklisted = TRUE

/obj/item/pen/chameleon/attack_self(mob/user)
	/*
	// Limit signatures to official crew69embers
	var/personnel_list6969 = list()
	for(var/datum/data/record/t in data_core.locked) //Look in data core locked.
		personnel_list.Add(t.fields69"name"69)
	personnel_list.Add("Anonymous")

	var/new_signature = input("Enter69ew signature pattern.", "New Signature") as69ull|anything in personnel_list
	if(new_signature)
		signature =69ew_signature
	*/
	signature = sanitize(input("Enter69ew signature. Leave blank for 'Anonymous'", "New Signature", signature))

/obj/item/pen/proc/get_signature(var/mob/user)
	return (user && user.real_name) ? user.real_name : "Anonymous"

/obj/item/pen/chameleon/get_signature(var/mob/user)
	return signature ? signature : "Anonymous"

/obj/item/pen/chameleon/verb/set_colour()
	set69ame = "Change Pen Colour"
	set category = "Object"

	var/list/possible_colours = list ("Yellow", "Green", "Pink", "Blue", "Orange", "Cyan", "Red", "Invisible", "Black")
	var/selected_type = input("Pick69ew colour.", "Pen Colour",69ull,69ull) as69ull|anything in possible_colours

	if(selected_type)
		switch(selected_type)
			if("Yellow")
				colour = COLOR_YELLOW
			if("Green")
				colour = COLOR_LIME
			if("Pink")
				colour = COLOR_PINK
			if("Blue")
				colour = COLOR_BLUE
			if("Orange")
				colour = COLOR_ORANGE
			if("Cyan")
				colour = COLOR_CYAN
			if("Red")
				colour = COLOR_RED
			if("Invisible")
				colour = COLOR_WHITE
			else
				colour = COLOR_BLACK
		to_chat(usr, "<span class='info'>You select the 69lowertext(selected_type)69 ink container.</span>")


/*
 * Crayons
 */

/obj/item/pen/crayon
	name = "crayon"
	desc = "A colourful crayon. Please refrain from eating it or putting it in your69ose."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonred"
	w_class = ITEM_SIZE_TINY
	attack_verb = list("attacked", "coloured")
	colour = "#FF0000" //RGB
	var/shadeColour = "#220000" //RGB
	var/uses = 30 //0 for unlimited uses
	var/instant = 0
	var/colourName = "red" //for updateIcon purposes
	var/grindable = TRUE //normal crayons are grindable, rainbow and69ime aren't

	New()
		name = "69colourName69 crayon"
		if(grindable)
			create_reagents(20)
			reagents.add_reagent("crayon_dust_69colourName69", 20)
		..()
