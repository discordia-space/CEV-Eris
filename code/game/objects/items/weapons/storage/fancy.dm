/*
 * The 'fancy' path is for objects like donut boxes that show how many items are in the storage item on the sprite itself
 * .. Sorry for the shitty path name, I couldnt think of a better one.
 *
 * WARNING: var/icon_type is used for both examine text and sprite name. Please look at the procs below and adjust your sprite names accordingly
 *		TODO: Cigarette boxes should be ported to this standard
 *
 * Contains:
 *		Donut Box
 *		Egg Box
 *		Candle Box
 *		Crayon Box
 *		Cigarette Box
 */

/obj/item/weapon/storage/fancy/
	icon = 'icons/obj/food.dmi'
	icon_state = "donutbox6"
	name = "donut box"
	max_storage_space = 8
	var/icon_type = "donut"

/obj/item/weapon/storage/fancy/update_icon(var/itemremoved = 0)
	var/total_contents = src.contents.len - itemremoved
	src.icon_state = "[src.icon_type]box[total_contents]"
	return

/obj/item/weapon/storage/fancy/examine(mob/user)
	if(!..(user, 1))
		return

	if(contents.len <= 0)
		to_chat(user, "There are no [src.icon_type]s left in the box.")
	else if(contents.len == 1)
		to_chat(user, "There is one [src.icon_type] left in the box.")
	else
		to_chat(user, "There are [src.contents.len] [src.icon_type]s in the box.")

	return

/*
 * Egg Box
 */

/obj/item/weapon/storage/fancy/egg_box
	icon = 'icons/obj/food.dmi'
	icon_state = "eggbox"
	icon_type = "egg"
	name = "egg box"
	storage_slots = 12
	can_hold = list(
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/boiledegg
		)

/obj/item/weapon/storage/fancy/egg_box/New()
	..()
	for(var/i=1; i <= storage_slots; i++)
		new /obj/item/weapon/reagent_containers/food/snacks/egg(src)
	return

/*
 * Candle Box
 */

/obj/item/weapon/storage/fancy/candle_box
	name = "candle pack"
	desc = "A pack of red candles."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candlebox5"
	icon_type = "candle"
	item_state = "candlebox5"
	throwforce = WEAPON_FORCE_HARMLESS
	slot_flags = SLOT_BELT


/obj/item/weapon/storage/fancy/candle_box/New()
	..()
	for(var/i=1; i <= 5; i++)
		new /obj/item/weapon/flame/candle(src)
	return

/*
 * Crayon Box
 */

/obj/item/weapon/storage/fancy/crayons
	name = "box of crayons"
	desc = "A box of crayons for all your rune drawing needs."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonbox"
	w_class = ITEM_SIZE_SMALL
	icon_type = "crayon"
	can_hold = list(
		/obj/item/weapon/pen/crayon
	)

/obj/item/weapon/storage/fancy/crayons/New()
	..()
	new /obj/item/weapon/pen/crayon/red(src)
	new /obj/item/weapon/pen/crayon/orange(src)
	new /obj/item/weapon/pen/crayon/yellow(src)
	new /obj/item/weapon/pen/crayon/green(src)
	new /obj/item/weapon/pen/crayon/blue(src)
	new /obj/item/weapon/pen/crayon/purple(src)
	update_icon()

/obj/item/weapon/storage/fancy/crayons/update_icon()
	overlays = list() //resets list
	overlays += image('icons/obj/crayons.dmi',"crayonbox")
	for(var/obj/item/weapon/pen/crayon/crayon in contents)
		overlays += image('icons/obj/crayons.dmi',crayon.colourName)

/obj/item/weapon/storage/fancy/crayons/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/pen/crayon))
		switch(W:colourName)
			if("mime")
				to_chat(usr, "This crayon is too sad to be contained in this box.")
				return
			if("rainbow")
				to_chat(usr, "This crayon is too powerful to be contained in this box.")
				return
	..()

////////////
//CIG PACK//
////////////
/obj/item/weapon/storage/fancy/cigarettes
	name = "cigarette packet"
	desc = "The most popular brand of Space Cigarettes, sponsors of the Space Olympics."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigpacket"
	item_state = "cigpacket"
	w_class = ITEM_SIZE_TINY
	throwforce = WEAPON_FORCE_HARMLESS
	slot_flags = SLOT_BELT
	storage_slots = 6
	can_hold = list(/obj/item/clothing/mask/smokable/cigarette, /obj/item/weapon/flame/lighter)
	icon_type = "cigarette"
	reagent_flags = REFILLABLE | NO_REACT

/*
/obj/item/weapon/storage/fancy/cigarettes/New()
	..()
	for(var/i = 1 to storage_slots)
		new /obj/item/clothing/mask/smokable/cigarette(src)
	create_reagents(15 * storage_slots)//so people can inject cigarettes without opening a packet, now with being able to inject the whole one
*/

/obj/item/weapon/storage/fancy/cigarettes/update_icon()
	icon_state = "[initial(icon_state)][contents.len]"
	return

/obj/item/weapon/storage/fancy/cigarettes/remove_from_storage(obj/item/W as obj, atom/new_location)
	// Don't try to transfer reagents to lighters
	if(istype(W, /obj/item/clothing/mask/smokable/cigarette))
		var/obj/item/clothing/mask/smokable/cigarette/C = W
		reagents.trans_to_obj(C, (reagents.total_volume/contents.len))
	..()

/obj/item/weapon/storage/fancy/cigarettes/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!ismob(M))
		return

	if(M == user && user.targeted_organ == BP_MOUTH)
		// Find ourselves a cig. Note that we could be full of lighters.
		var/obj/item/clothing/mask/smokable/cigarette/cig = locate() in src

		if(!cig)
			to_chat(user, SPAN_NOTICE("Looks like the packet is out of cigarettes."))
			return

		user.equip_to_slot_if_possible(cig, slot_wear_mask)
	else
		..()

/obj/item/weapon/storage/fancy/cigarettes/generic
	New()
		..()
		for(var/i = 1 to storage_slots)
			new /obj/item/clothing/mask/smokable/cigarette(src)
		create_reagents(15 * storage_slots)
		fill_cigarre_package(src,list("nicotine" = 5))

/obj/item/weapon/storage/fancy/cigarettes/dromedaryco
	name = "\improper DromedaryCo packet"
	desc = "A packet of six imported DromedaryCo cancer sticks. A label on the packaging reads, \"Wouldn't a slow death make a change?\""
	icon_state = "Dpacket"
	item_state = "Dpacket"

	New()
		..()
		for(var/i = 1 to storage_slots)
			new /obj/item/clothing/mask/smokable/cigarette(src)
		create_reagents(15 * storage_slots)
		fill_cigarre_package(src,list("nicotine" = 15))


/obj/item/weapon/storage/fancy/cigarettes/killthroat
	name = "\improper AcmeCo packet"
	desc = "A packet of six AcmeCo cigarettes. For those who somehow want to obtain the record for the most amount of cancerous tumors."
	icon_state = "Bpacket"
	item_state = "Bpacket" //Doesn't have an inhand state, but neither does dromedary, so, ya know..

	New()
		..()
		for(var/i = 1 to storage_slots)
			new /obj/item/clothing/mask/smokable/cigarette(src)
		create_reagents(15 * storage_slots)
		fill_cigarre_package(src,list("nicotine" = 10, "fuel" = 5))

//////////////////
//NEW CIGARETTES//
//////////////////

/obj/item/weapon/storage/fancy/cigarettes/frozennova
	name = "\improper Frozen Nova packet"
	desc = "FS Brand Cigarette mostly sold to IronHammer PMC on distant worlds, hard hitting, standardized, sleek and clean. Ready in the packs, tightly pressed to each other."
	icon_state = "frozennova_packet"
	item_state = "cigpacket"

/obj/item/weapon/storage/fancy/cigarettes/frozennova/New()
	..()
	for(var/i = 1 to storage_slots)
		new /obj/item/clothing/mask/smokable/cigarette/frozennova(src)
	create_reagents(15 * storage_slots)
	fill_cigarre_package(src,list("nicotine" = 10))

/obj/item/weapon/storage/fancy/cigarettes/ishimuraspecial
	name = "\improper Ishimura Special packet"
	desc = "For the times when you really need to forget, says the advertisement but usually people only have nightmares from this type of cigarettes except the kind of people who get off from it."
	icon_state = "ishimuraspecial_packet"
	item_state = "cigpacket"

/obj/item/weapon/storage/fancy/cigarettes/ishimuraspecial/New()
	..()
	for(var/i = 1 to storage_slots)
		new /obj/item/clothing/mask/smokable/cigarette/ishimuraspecial(src)
	create_reagents(15 * storage_slots)
	fill_cigarre_package(src,list("nicotine" = 5, "haloperidol" = 5))

/obj/item/weapon/storage/fancy/cigarettes/roacheyes
	name = "\improper Roach Eyes packet"
	desc = "This cigarette brand would typically seen in the mouth of a bum in hive cities or in some slums, but the company maintains the quality at acceptable levels. Barely holds up to it really "
	icon_state = "roacheyes_packet"
	item_state = "cigpacket"

/obj/item/weapon/storage/fancy/cigarettes/roacheyes/New()
	..()
	for(var/i = 1 to storage_slots)
		new /obj/item/clothing/mask/smokable/cigarette/roacheyes(src)
	create_reagents(15 * storage_slots)
	fill_cigarre_package(src,list("woodpulp" = 5,"nicotine" = 5, "arectine" = 3, "blattedin" = 2))

/obj/item/weapon/storage/fancy/cigarettes/tannhausergate
	name = "\improper Tannhauser Gate packet"
	desc = "Premium Cigarettes for a handful of people who can afford to smoke daily, each cigarette is said to have a taste processor and filter that increases flavor and effect. It almost feels like you didnt just smoke nicotine-infused grass!"
	icon_state = "tannhausergate_packet"
	item_state = "cigpacket"

/obj/item/weapon/storage/fancy/cigarettes/tannhausergate/New()
	..()
	for(var/i = 1 to storage_slots)
		new /obj/item/clothing/mask/smokable/cigarette/tannhausergate(src)
	create_reagents(15 * storage_slots)
	fill_cigarre_package(src,list("methylphenidate" = 5, "nicotine" = 3))

/obj/item/weapon/storage/fancy/cigarettes/brouzouf
	name = "\improper Brouzouf Message packet"
	desc = "The longest-lasting brand of cigarettes, that survived even darkest times in recent human history."
	icon_state = "brouzouf_packet"
	item_state = "cigpacket"

/obj/item/weapon/storage/fancy/cigarettes/brouzouf/New()
	..()
	for(var/i = 1 to storage_slots)
		new /obj/item/clothing/mask/smokable/cigarette/brouzouf(src)
	create_reagents(15 * storage_slots)
	fill_cigarre_package(src,list("nicotine" = 5, "bouncer" = 5))

/obj/item/weapon/storage/fancy/cigarettes/shodans
	name = "\improper Shodan's packet"
	desc = "Face on the pack looks uncanny, usually smoked by wannabe hackers because of some stupid inside joke."
	icon_state = "shodans_packet"
	item_state = "cigpacket"

/obj/item/weapon/storage/fancy/cigarettes/shodans/New()
	..()
	for(var/i = 1 to storage_slots)
		new /obj/item/clothing/mask/smokable/cigarette/shodans(src)
	create_reagents(15 * storage_slots)
	fill_cigarre_package(src,list("nicotine" = 5, "cherry drops" = 5))

/obj/item/weapon/storage/fancy/cigarettes/toha
	name = "\improper TOHA Heavy Industries packet"
	desc = "The cigarette is thick and massive for its type, looks almost sterile, made on far-off worlds which no one really knows. People wonder if this tobacco even \"real\"?"
	icon_state = "toha_packet"
	item_state = "cigpacket"

/obj/item/weapon/storage/fancy/cigarettes/toha/New()
	..()
	for(var/i = 1 to storage_slots)
		new /obj/item/clothing/mask/smokable/cigarette/toha(src)
	create_reagents(15 * storage_slots)
	fill_cigarre_package(src,list("nicotine" = 5,  "silver" = 5, "tricordrazine" = 3, "gold" = 2))

/////////////////////

/obj/item/weapon/storage/fancy/cigar
	name = "cigar case"
	desc = "A case for holding your cigars when you are not smoking them."
	icon_state = "cigarcase"
	item_state = "cigarcase"
	icon = 'icons/obj/cigarettes.dmi'
	w_class = ITEM_SIZE_TINY
	throwforce = WEAPON_FORCE_HARMLESS
	slot_flags = SLOT_BELT
	storage_slots = 7
	can_hold = list(/obj/item/clothing/mask/smokable/cigarette/cigar)
	icon_type = "cigar"
	reagent_flags = REFILLABLE | NO_REACT

/obj/item/weapon/storage/fancy/cigar/New()
	..()
	for(var/i = 1 to storage_slots)
		new /obj/item/clothing/mask/smokable/cigarette/cigar(src)
	create_reagents(15 * storage_slots)
	update_icon()

/obj/item/weapon/storage/fancy/cigar/update_icon()
	icon_state = "[initial(icon_state)][contents.len]"
	return

/obj/item/weapon/storage/fancy/cigar/remove_from_storage(obj/item/W as obj, atom/new_location)
		var/obj/item/clothing/mask/smokable/cigarette/cigar/C = W
		if(!istype(C)) return
		reagents.trans_to_obj(C, (reagents.total_volume/contents.len))
		..()

/*
 * Vial Box
 */

/obj/item/weapon/storage/fancy/vials
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox6"
	icon_type = "vial"
	name = "vial storage box"
	storage_slots = 6
	can_hold = list(/obj/item/weapon/reagent_containers/glass/beaker/vial)


/obj/item/weapon/storage/fancy/vials/New()
	..()
	for(var/i=1; i <= storage_slots; i++)
		new /obj/item/weapon/reagent_containers/glass/beaker/vial(src)
	return

/obj/item/weapon/storage/lockbox/vials
	name = "secure vial storage box"
	desc = "A locked box for keeping things away from children."
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox0"
	item_state = "syringe_kit"
	max_w_class = ITEM_SIZE_SMALL
	can_hold = list(/obj/item/weapon/reagent_containers/glass/beaker/vial)
	max_storage_space = 12 //The sum of the w_classes of all the items in this storage item.
	storage_slots = 6
	req_access = list(access_virology)

/obj/item/weapon/storage/lockbox/vials/New()
	..()
	update_icon()

/obj/item/weapon/storage/lockbox/vials/update_icon(var/itemremoved = 0)
	var/total_contents = src.contents.len - itemremoved
	src.icon_state = "vialbox[total_contents]"
	src.overlays.Cut()
	if (!broken)
		overlays += image(icon, src, "led[locked]")
		if(locked)
			overlays += image(icon, src, "cover")
	else
		overlays += image(icon, src, "ledb")
	return

/obj/item/weapon/storage/lockbox/vials/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	update_icon()
