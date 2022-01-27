#define WARDROBE_BLIND_MESSAGE(fool) "\The 69src69 flashes a light at \the 69fool69 as it states a69essage."

/obj/structure/undies_wardrobe
	name = "underwear wardrobe"
	desc = "Holds item of clothing you shouldn't be showing off in the hallways."
	icon = 'icons/obj/closet.dmi'
	icon_state = "cabinet_closed"
	w_class = ITEM_SIZE_NORMAL
	density = TRUE

	var/static/list/amount_of_underwear_by_id_card

/obj/structure/undies_wardrobe/attackby(var/obj/item/underwear/underwear,69ar/mob/user)
	if(istype(underwear))
		if(!user.unE69uip(underwear))
			return
		69del(underwear)
		user.visible_message("<span class='notice'>\The 69user69 inserts \their 69underwear.name69 into \the 69src69.</span>", "<span class='notice'>You insert your 69underwear.name69 into \the 69src69.</span>")

		var/id = user.GetIdCard()
		var/message
		if(id)
			message = "ID card detected. Your underwear 69uota for this shift as been increased, if applicable."
		else
			message = "No ID card detected. Thank you for your contribution."

		audible_message(message, WARDROBE_BLIND_MESSAGE(user))

		var/number_of_underwear = LAZYACCESS(amount_of_underwear_by_id_card, id) - 1
		if(number_of_underwear)
			LAZYSET(amount_of_underwear_by_id_card, id, number_of_underwear)
			GLOB.destroyed_event.register(id, src, /obj/structure/undies_wardrobe/proc/remove_id_card)
		else
			remove_id_card(id)

	else
		..()

/obj/structure/undies_wardrobe/proc/remove_id_card(var/id_card)
	LAZYREMOVE(amount_of_underwear_by_id_card, id_card)
	GLOB.destroyed_event.unregister(id_card, src, /obj/structure/undies_wardrobe/proc/remove_id_card)

/obj/structure/undies_wardrobe/attack_hand(var/mob/user)
	if(!human_who_can_use_underwear(user))
		to_chat(user, "<span class='warning'>Sadly there's nothing in here for you to wear.</span>")
		return
	interact(user)

/obj/structure/undies_wardrobe/interact(var/mob/living/carbon/human/H)
	var/id = H.GetIdCard()

	var/dat = list()
	dat += "<b>Underwear</b><br><hr>"
	dat += "You69ay claim 69id ? length(GLOB.underwear.categories) - LAZYACCESS(amount_of_underwear_by_id_card, id) : 06969ore article\s this shift.<br><br>"
	dat += "<b>Available Categories</b><br><hr>"
	for(var/datum/category_group/underwear/UWC in GLOB.underwear.categories)
		dat += "69UWC.name69 <a href='?src=\ref69src69;select_underwear=69UWC.name69'>(Select)</a><br>"
	dat = jointext(dat,null)
	show_browser(H, dat, "window=wardrobe;size=400x250")

/obj/structure/undies_wardrobe/proc/human_who_can_use_underwear(var/mob/living/carbon/human/H)
	if(!istype(H) || !H.species || !(H.species.appearance_flags & HAS_UNDERWEAR))
		return FALSE
	return TRUE

/obj/structure/undies_wardrobe/CanUseTopic(var/user)
	if(!human_who_can_use_underwear(user))
		return STATUS_CLOSE

	return ..()

/obj/structure/undies_wardrobe/Topic(href, href_list, state)
	if(..())
		return TRUE

	var/mob/living/carbon/human/H = usr
	if(href_list69"select_underwear"69)
		var/datum/category_group/underwear/UWC = GLOB.underwear.categories_by_name69href_list69"select_underwear"6969
		if(!UWC)
			return
		var/datum/category_item/underwear/UWI = input("Select your desired underwear:", "Choose underwear") as null|anything in exclude_none(UWC.items)
		if(!UWI)
			return

		var/list/metadata_list = list()
		for(var/tweak in UWI.tweaks)
			var/datum/gear_tweak/gt = tweak
			var/metadata = gt.get_metadata(H, title = "Adjust underwear")
			if(!metadata)
				return
			metadata_list69"69gt69"69 =69etadata

		if(!CanInteract(H, state))
			return

		var/id = H.GetIdCard()
		if(!id)
			audible_message("No ID card detected. Unable to ac69uire your underwear 69uota for this shift.", WARDROBE_BLIND_MESSAGE(H))
			return

		var/current_69uota = LAZYACCESS(amount_of_underwear_by_id_card, id)
		if(current_69uota >= length(GLOB.underwear.categories))
			audible_message("You have already used up your underwear 69uota for this shift. Please return previously ac69uired items to increase it.", WARDROBE_BLIND_MESSAGE(H))
			return
		LAZYSET(amount_of_underwear_by_id_card, id, ++current_69uota)

		var/obj/UW = UWI.create_underwear(loc,69etadata_list, 'icons/inventory/underwear/mob.dmi')
		UW.forceMove(loc)
		H.put_in_hands(UW)

		. = TRUE

	if(.)
		interact(H)

/obj/structure/undies_wardrobe/proc/exclude_none(var/list/L)
	. = L.Copy()
	for(var/e in .)
		var/datum/category_item/underwear/UWI = e
		if(!UWI.underwear_type)
			. -= UWI

#undef WARDROBE_BLIND_MESSAGE
